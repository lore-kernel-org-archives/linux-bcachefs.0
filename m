Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F1FC38142
	for <linux-bcachefs@archiver.kernel.org>; Fri, 27 Jan 2023 07:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjA0HVz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 27 Jan 2023 02:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjA0HVy (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 27 Jan 2023 02:21:54 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31BA113F8
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Jan 2023 23:21:49 -0800 (PST)
Date:   Fri, 27 Jan 2023 02:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674804107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dix8HAPUiwXJgeChMsr0LZ7uu2WQF8GHePXR181+Axo=;
        b=f8R/03RBTwCJiTq3unWQ2utfpcqz/Hlsui0Mvv8VXFWC8WWe+6HiKX6/WPKz0ZmpnctlnO
        w3kQ8dBCXVIrdBBAAvyXnpKQmCoPJz5VAFFPnRCDR6K9S/yOu8Gh8mYLQVsA50Dw3DhnnA
        TeGxExHTWPQTblYqa5S8wQeJ2RuBenU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y9N7iISg7MK20j3U@moria.home.lan>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9KXaSkuMZM663Vi@moria.home.lan>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jan 26, 2023 at 10:08:29AM -0500, Kent Overstreet wrote:
> Hey Brian - my understanding of this bug was that it was even simpler.
> 
> As I understand it, the decreed semantics of fsync by the Powers That Be
> are that it should return a given error _once_  - if a subsequent fsync
> returns an error, then there must have been another write that errored.
> 
> So we just need to plumb our errors from the journal through the
> errseq_t mechanism. The tricky bit is that bch2_fsync() doesn't record
> or check if it's actually doing a journal flush or if the journal flush
> was already done.
> 
> So I think we'd need to add another sequence number to
> bch_inode_info to track the sequence that was flushed, and then only
> call bch2_journal_flush_seq() if flushed_seq !=
> journal_seq_of_last_update, and then to make this work correctly when an
> inode has been evicted it might need to go in struct bch_inode, stored
> in the btree, as well.

BTW, I'm not suggesting we do this right now - I agree with you in that
the current behaviour makes sense to me. It might be worth changing at
some point for consistency, but I'm not in a hurry here.

Thanks for looking at this :)
