Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89DBCE79A8
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 02:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjITChm (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 22:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjITChl (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 22:37:41 -0400
Received: from out-220.mta1.migadu.com (out-220.mta1.migadu.com [IPv6:2001:41d0:203:375::dc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6684C9
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 19:37:35 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695177454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQe+Tkc4EAzN9G/NSAz+nDqO2YBPS/yj3eKcjc9HR60=;
        b=TIrPEPP1DmTULo4gcHebI0hmbo2D6LHoH7jDDXihm5XPhXEN5KCYmE4sQQTRrU4nvE+onJ
        uW5g+V7F83yMWwcuEFyEJ2/KX6RIVHRDcCazpH/nczQ23TNuyXCUWiJZy9kDLAPLJWPqjQ
        jGv2BQW74I5UZ1+0wQZOuLOGJZm2Qo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <20230920023731.e3emdmwqpqktta2j@moria.home.lan>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> 2023 (linux-next), leads to the following Smatch static checker
> warning:
> 
> fs/bcachefs/journal_io.c:1461 journal_buf_realloc() warn: sleeping in atomic context
> fs/bcachefs/journal_io.c:1662 bch2_journal_entries_postprocess() warn: sleeping in atomic context
> fs/bcachefs/journal_io.c:1764 bch2_journal_write() warn: sleeping in atomic context
> fs/bcachefs/journal_io.c:788 jset_validate() warn: sleeping in atomic context
> fs/bcachefs/replicas.c:439 bch2_mark_replicas() warn: sleeping in atomic context
> 
> All this sleeping in atomic warnings start in journal_write_done()
> where it takes spin_lock(&j->lock) so preempt is disabled.


From 0528bebd8b42ce43a39da8e911bf21825f5085dd Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 19 Sep 2023 22:36:30 -0400
Subject: [PATCH] bcachefs: drop journal lock before calling journal_write

bch2_journal_write() expects process context, it takes journal_lock as
needed.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 269c8e8a1d95..6a3d6a374e9c 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1554,6 +1554,7 @@ static void journal_write_done(struct closure *cl)
 
 	if (!journal_state_count(new, new.unwritten_idx) &&
 	    journal_last_unwritten_seq(j) <= journal_cur_seq(j)) {
+		spin_unlock(&j->lock);
 		closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
 	} else if (journal_last_unwritten_seq(j) == journal_cur_seq(j) &&
 		   new.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL) {
@@ -1566,10 +1567,11 @@ static void journal_write_done(struct closure *cl)
 		 * might want to be written now:
 		 */
 
+		spin_unlock(&j->lock);
 		mod_delayed_work(c->io_complete_wq, &j->write_work, max(0L, delta));
+	} else {
+		spin_unlock(&j->lock);
 	}
-
-	spin_unlock(&j->lock);
 }
 
 static void journal_write_endio(struct bio *bio)
