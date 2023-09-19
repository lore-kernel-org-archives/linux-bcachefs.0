Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED95CE79A9
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 21:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjISVcl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjISVcl (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 17:32:41 -0400
Received: from out-229.mta1.migadu.com (out-229.mta1.migadu.com [IPv6:2001:41d0:203:375::e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B3BAD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 14:32:35 -0700 (PDT)
Date:   Tue, 19 Sep 2023 17:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695159153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZEEHkN9l6sqcq/1kW/XMqJGykEfNEO9Ab9gOD8zKdQ=;
        b=GSCLXj8dUNni0eXhbjc6k1LAdmp6P+ClbVFOs3G5GPooZ55euAkAvtEQsUFZW9VPEQK/tm
        loItcifB8FdoGorK+nR8Mx9h9/7/3SzvLEcO1RiBPnF+UIJU0NrExI4oxIL9dsIgHrL9qp
        XuumJ5KLN1ur2AQZ37BSGR4dgJBLb3o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Message-ID: <20230919213231.m77cwmpt3nb3ynm3@moria.home.lan>
References: <20230915125154.307450-1-bfoster@redhat.com>
 <20230915125154.307450-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915125154.307450-5-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 08:51:54AM -0400, Brian Foster wrote:
> Initial support for the vfs superblock freeze and unfreeze
> operations. Superblock freeze occurs in stages, where the vfs
> attempts to quiesce high level write operations, page faults, fs
> internal operations, and then finally calls into the filesystem for
> any last stage steps (i.e. log flushing, etc.) before marking the
> superblock frozen.
> 
> The majority of write paths are covered by freeze protection (i.e.
> sb_start_write() and friends) in higher level common code, with the
> exception of the fs-internal SB_FREEZE_FS stage (i.e.
> sb_start_intwrite()). This typically maps to active filesystem
> transactions in a manner that allows the vfs to implement a barrier
> of internal fs operations during the freeze sequence. This is not a
> viable model for bcachefs, however, because it utilizes transactions
> both to populate the journal as well as to perform journal reclaim.
> This means that mapping intwrite protection to transaction lifecycle
> or transaction commit is likely to deadlock freeze, as quiescing the
> journal requires transactional operations blocked by the final stage
> of freeze.
> 
> The flipside of this is that bcachefs does already maintain its own
> internal sets of write references for similar purposes, currently
> utilized for transitions from read-write to read-only mode. Since
> this largely mirrors the high level sequence involved with freeze,
> we can simply invoke this mechanism in the freeze callback to fully
> quiesce the filesystem in the final stage. This means that while the
> SB_FREEZE_FS stage is essentially a no-op, the ->freeze_fs()
> callback that immediately follows begins by performing effectively
> the same step by quiescing all internal write references.
> 
> One caveat to this approach is that without integration of internal
> freeze protection, write operations gated on internal write refs
> will fail with an internal -EROFS error rather than block on
> acquiring freeze protection. IOW, this is roughly equivalent to only
> having support for sb_start_intwrite_trylock(), and not the blocking
> variant. Many of these paths already use non-blocking internal write
> refs and so would map into an sb_start_intwrite_trylock() anyways.
> The only instance of this I've been able to uncover that doesn't
> explicitly rely on a higher level non-blocking write ref is the
> bch2_rbio_narrow_crcs() path, which updates crcs in certain read
> cases, and Kent has pointed out isn't critical if it happens to fail
> due to read-only status.
> 
> Given that, implement basic freeze support as described above and
> leave tighter integration with internal freeze protection as a
> possible future enhancement. There are multiple potential ideas
> worth exploring here. For example, we could implement a multi-stage
> freeze callback that might allow bcachefs to quiesce its internal
> write references without deadlocks, we could integrate intwrite
> protection with bcachefs' internal write references somehow or
> another, or perhaps consider implementing blocking support for
> internal write refs to be used specifically for freeze, etc. In the
> meantime, this enables functional freeze support and the associated
> test coverage that comes with it.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This is going to get a whole lot more test coverage and I'm pretty
excited about that - thanks, applied the series
