Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DE1C71153
	for <linux-bcachefs@archiver.kernel.org>; Mon,  4 Sep 2023 02:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350910AbjIDC3r (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 3 Sep 2023 22:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350904AbjIDC3r (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 3 Sep 2023 22:29:47 -0400
Received: from out-212.mta1.migadu.com (out-212.mta1.migadu.com [IPv6:2001:41d0:203:375::d4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B0ECA
        for <linux-bcachefs@vger.kernel.org>; Sun,  3 Sep 2023 19:29:43 -0700 (PDT)
Date:   Sun, 3 Sep 2023 22:29:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693794581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YVm55DEAM2Y9yA2pupNDYpBInWGc6+1co+yQ2e0gFjw=;
        b=VstAGtu9NzMAo+ah7UxfA4kR3WctDD/iEpg67XC5jxGA2T5KXiHZM1PGf3PgUV6iYOE/BE
        XKzrlVlOXbPgKNM5/XXkRM43AQDWgwD3uvwmSn5KQzML4T/rL2LUQKP2GJ63oouPgXx8nx
        Q97h/52YcaWXlPm4ZpfKlKOfLdGNe6A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
 <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Sep 03, 2023 at 05:18:12PM -0400, Kent Overstreet wrote:
> On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> > bcachefs freeze testing via fstests generic/390 occasionally
> > reproduces the following BUG from bch2_fs_read_only():
> > 
> >   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
>
> Your fix makes sense, but I wonder if it might be simpler and better to
> fix this in bch2_journal_reclaim_fast().

What do you think of this fix?

diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 10e1860dad..021c56ac67 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -303,6 +303,12 @@ static void bch2_journal_reclaim_fast(struct journal *j)
 	 */
 	while (!fifo_empty(&j->pin) &&
 	       !atomic_read(&fifo_peek_front(&j->pin).count)) {
+		u64 seq = journal_last_seq(j);
+
+		if (seq > j->seq_ondisk &&
+		    journal_state_count(j->reservations, seq & JOURNAL_BUF_MASK))
+			break;
+
 		fifo_pop(&j->pin, temp);
 		popped = true;
 	}
