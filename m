Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFABFCE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 01:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjITB4O (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjITB4O (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:56:14 -0400
Received: from out-229.mta1.migadu.com (out-229.mta1.migadu.com [IPv6:2001:41d0:203:375::e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173EBB3
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 18:56:05 -0700 (PDT)
Date:   Tue, 19 Sep 2023 21:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695174964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DHSOSCzqJKjJo1Y8B2TPQjjIrH+N1Ydz3K1c+Rb0qbM=;
        b=R7+Si3chAab/f5kETA7qNMZTGvcHyd9EgUtVUDbrnIBmHZO9Pvdy69x4xW2M1hUAuIP1nK
        rSQ1/M4O8e4MqqMrFYus32Vr26jyVZ/KnZTmN/+iw61XOamU6HBPmMTcSEB6n8ffQ6yIn+
        4VqytG5ye2Z92GjX5jobG6LweCalu+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: error pointer dereference in bch2_copygc()
Message-ID: <20230920015602.kob76glwgfnvgf3p@moria.home.lan>
References: <18930ca3-9636-47c4-81bf-08766c4f28f4@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18930ca3-9636-47c4-81bf-08766c4f28f4@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 03:57:00PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 46be00209417: "bcachefs: Rhashtable based buckets_in_flight
> for copygc" from Mar 11, 2023 (linux-next), leads to the following
> Smatch static checker warning:
> 
> 	fs/bcachefs/movinggc.c:224 bch2_copygc()
> 	error: 'f' dereferencing possible ERR_PTR()
> 
> fs/bcachefs/movinggc.c
>     190 noinline
>     191 static int bch2_copygc(struct btree_trans *trans,
>     192                        struct moving_context *ctxt,
>     193                        struct buckets_in_flight *buckets_in_flight)
>     194 {
>     195         struct bch_fs *c = trans->c;
>     196         struct data_update_opts data_opts = {
>     197                 .btree_insert_flags = BCH_WATERMARK_copygc,
>     198         };
>     199         move_buckets buckets = { 0 };
>     200         struct move_bucket_in_flight *f;
>     201         struct move_bucket *i;
>     202         u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
>     203         int ret = 0;
>     204 
>     205         ret = bch2_copygc_get_buckets(trans, ctxt, buckets_in_flight, &buckets);
>     206         if (ret)
>     207                 goto err;
>     208 
>     209         darray_for_each(buckets, i) {
>     210                 if (unlikely(freezing(current)))
>     211                         break;
>     212 
>     213                 f = move_bucket_in_flight_add(buckets_in_flight, *i);
> 
> move_bucket_in_flight_add() can return a mix of error codes such as
> -E2BIG.

E2BIG is not possible since we don't set max_elems when initializing the
rhashtable...
