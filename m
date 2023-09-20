Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D3ECE79A8
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 02:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjITCRG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 22:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjITCRF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 22:17:05 -0400
Received: from out-211.mta1.migadu.com (out-211.mta1.migadu.com [IPv6:2001:41d0:203:375::d3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD9AB
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 19:16:58 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695176216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBfsL9e8WK63ZBaMOwPmWGQdTPnQbpbgUzbzSkQ4V80=;
        b=v9s87G4CwRk5s4qNHkpz5I6DOfApKa1gh2HPlSsldYOvuB7wqFxJpQu7DIuqa1GEIswbau
        AVgwiDW9aOEhPPQDWrc2h90/DydOuU79O3ZM2PKDtc+z5xXfXo2pEleYIPJwu77WET3QeL
        ZQA7h50TRcpisQ9l5qGK4ooTXcqzUR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Kill bch2_fs_usage_scratch_get()
Message-ID: <20230920021649.w5xhmkkktdktftil@moria.home.lan>
References: <b4f209ea-fdf6-412c-98bd-7be52b54447b@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f209ea-fdf6-412c-98bd-7be52b54447b@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 04:38:11PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 502bed819cc3: "bcachefs: Kill bch2_fs_usage_scratch_get()"
> from Apr 3, 2021 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	fs/bcachefs/buckets.c:1352 bch2_trans_fs_usage_apply()
> 	error: we previously assumed 'trans->disk_res' could be null (see line 1302)
> 
> fs/bcachefs/buckets.c
>     1296 int bch2_trans_fs_usage_apply(struct btree_trans *trans,
>     1297                               struct replicas_delta_list *deltas)
>     1298 {
>     1299         struct bch_fs *c = trans->c;
>     1300         static int warned_disk_usage = 0;
>     1301         bool warn = false;
>     1302         unsigned disk_res_sectors = trans->disk_res ? trans->disk_res->sectors : 0;
>                                              ^^^^^^^^^^^^^^^
> This code is quite subtle, but the static checker says that we check
> for NULL here.
> 
>     1303         struct replicas_delta *d = deltas->d, *d2;
>     1304         struct replicas_delta *top = (void *) deltas->d + deltas->used;
>     1305         struct bch_fs_usage *dst;
>     1306         s64 added = 0, should_not_have_added;
>     1307         unsigned i;
>     1308 
>     1309         percpu_down_read(&c->mark_lock);
>     1310         preempt_disable();
>     1311         dst = fs_usage_ptr(c, trans->journal_res.seq, false);
>     1312 
>     1313         for (d = deltas->d; d != top; d = replicas_delta_next(d)) {
>     1314                 switch (d->r.data_type) {
>     1315                 case BCH_DATA_btree:
>     1316                 case BCH_DATA_user:
>     1317                 case BCH_DATA_parity:
>     1318                         added += d->delta;
> 
> And we set added to non-zero here so that doesn't seem related.  Or the
> relationship is not obvious.
> 
>     1319                 }
>     1320 
>     1321                 if (__update_replicas(c, dst, &d->r, d->delta))
>     1322                         goto need_mark;
>     1323         }
>     1324 
>     1325         dst->nr_inodes += deltas->nr_inodes;
>     1326 
>     1327         for (i = 0; i < BCH_REPLICAS_MAX; i++) {
>     1328                 added                                += deltas->persistent_reserved[i];
>     1329                 dst->reserved                        += deltas->persistent_reserved[i];
>     1330                 dst->persistent_reserved[i]        += deltas->persistent_reserved[i];
>     1331         }
>     1332 
>     1333         /*
>     1334          * Not allowed to reduce sectors_available except by getting a
>     1335          * reservation:
>     1336          */
>     1337         should_not_have_added = added - (s64) disk_res_sectors;
>     1338         if (unlikely(should_not_have_added > 0)) {
>     1339                 u64 old, new, v = atomic64_read(&c->sectors_available);
>     1340 
>     1341                 do {
>     1342                         old = v;
>     1343                         new = max_t(s64, 0, old - should_not_have_added);
>     1344                 } while ((v = atomic64_cmpxchg(&c->sectors_available,
>     1345                                                old, new)) != old);
>     1346 
>     1347                 added -= should_not_have_added;
>     1348                 warn = true;
>     1349         }
>     1350 
>     1351         if (added > 0) {
> --> 1352                 trans->disk_res->sectors -= added;
>                          ^^^^^^^^^^^^^^^^^
> Unchecked dereference.

If disk_res was NULL, disk_res_sectors was 0, and added gets completely
zeroed out - not a bug.
