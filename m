Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE72C7EE21
	for <linux-bcachefs@archiver.kernel.org>; Tue,  2 May 2023 23:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjEBXOB (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 2 May 2023 19:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBXOB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 2 May 2023 19:14:01 -0400
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF961FF9
        for <linux-bcachefs@vger.kernel.org>; Tue,  2 May 2023 16:13:59 -0700 (PDT)
Date:   Tue, 2 May 2023 19:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683069237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yqXbQ6FjoTT306ke4rARSDcoJyCufK8AvYM2+hVENh4=;
        b=a/Ry3GziLRgPqwkly586bgGD/oDlMBVKn7Lyp2A+64PhjRbFibQQCFhYYlPBAWK+cIG5jr
        dHpivMOIUs+Yzk1zZF96xtBx9hxfAw3MRUqxS/w8xX2K0fbqrTntfW10nTi3gPrk31V1Zo
        NVEw8KYwQJLpkBL5Qr+X4nNC9gDoLOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs replica garbage collection
Message-ID: <ZFGZMl/0GGFwajoz@moria.home.lan>
References: <ZFEjdJE8Q/wzGF7w@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFEjdJE8Q/wzGF7w@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 02, 2023 at 10:58:50AM -0400, Brian Foster wrote:
> Hi Kent,
> 
> I'm tracking an issue that seems to be related to bch_replica garbage
> collection, where fsck reports the following:
> 
>   superblock not marked as containing replicas journal: 1/1 [1], not fixing
> 
> ... and the fs doesn't want to mount (until repaired).
> 
> The short of it looks like there's a window where we write out the sb
> replica info with no BCH_DATA_journal usage where a shutdown/recovery
> doesn't otherwise expect it. I've not fully root caused the problem yet,
> but when looking into the code it looks like we have a couple different
> mechanisms for clearing out unused replicas...
> 
> The "old" _start/_end mechanism handles journal data only and is invoked
> after pin flush. I presume the start/end calls wrap marking journal dev
> replicas to ensure usage accounting is up to date, but I'm not totally
> sure. Is that the case?

It's not anything to do with usage accounting - we don't really do usage
accounting for the journal, not in a way that would work for replicas
tracking.

So the old style replicas gc mechanism that
bch2_journal_flush_device_pins() uses is your traditional mark and sweep
gc - clear everything, then walk and remark everything that's currently
in use.

> If so, any reason the marking via journal_write_done() isn't
> sufficient?

This might be the bug you're looking for - the journal write path should
be doing the marking before the write, not after.

> The "new" bch2_replicas_gc2() mechanism is invoked from various other
> places and always propagates journal data replica entries. Is that
> filter on journal data by design, or temporary because journal replica
> gc is handled separately as above? If the latter, is there some explicit
> reason the old mechanism was left around to handle journal data like
> this?
> 
> As noted above, I still need to track down the root cause of the
> unexpectedly absent journal data replica sb field. It may be agnostic to
> either gc mechanism, but I'm trying to understand the higher level
> situation here a bit better before getting too deep into the weeds...
> thanks.

Applying this...

From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 2 May 2023 18:22:12 -0400
Subject: [PATCH] bcachefs: Improved comment for bch2_replicas_gc2()

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index 8935ff5899..8ae50dfd8c 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -550,8 +550,14 @@ int bch2_replicas_gc_start(struct bch_fs *c, unsigned typemask)
 	return 0;
 }
 
-/* New much simpler mechanism for clearing out unneeded replicas entries: */
-
+/*
+ * New much simpler mechanism for clearing out unneeded replicas entries - drop
+ * replicas entries that have 0 sectors used.
+ *
+ * However, we don't track sector counts for journal usage, so this doesn't drop
+ * any BCH_DATA_journal entries; the old bch2_replicas_gc_(start|end) mechanism
+ * is retained for that.
+ */
 int bch2_replicas_gc2(struct bch_fs *c)
 {
 	struct bch_replicas_cpu new = { 0 };
