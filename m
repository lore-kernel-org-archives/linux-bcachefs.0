Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49BFEE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbjIOM5L (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbjIOM5K (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:57:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F321713
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:05 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40434d284f7so20515045e9.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782624; x=1695387424; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oFe9oLMYDZb0cL6pfqjyCazU+kdCf5KMcpUvaiRPkaM=;
        b=HnP3WLbCOi3CY9+BJanHMARfqYyXKhfeMpf+V+Xx+Zz2zP0+A1e93JsBK4aNjvpWko
         Ff9hstL1t999PhUn+N+MXVHrMQP1BOZ9nrWcfQzohgDUxTH5rI2Z5UuXwjgtW6mf17qq
         0aupKPGGlfj7++ivefeiF1FBSP2bVn3VgjOTIVAd76uLWyrdcB0JvK1OaAGm5EO2tJu1
         QCIG0jjgdMqHYG0HVCygD7Q+8Up6zd5AzCY8ZfcaL2qhuMeMOQRwYhSZ2XcqmmrU7lto
         G7zXrK3MvinnsWhRXAUnzHpDt4cgSOSql66VdeK/G3Xbfv9xPSei2az0v1M00QZVgjZL
         jVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782624; x=1695387424;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFe9oLMYDZb0cL6pfqjyCazU+kdCf5KMcpUvaiRPkaM=;
        b=mVZVXU1yG9jNvxSFZrEekxmq15ym52yE1t2NmSg4e+259lBrp38r7IqYHrKG289t+b
         Ja8a9OD/CRUu10P0ZsrXDy9Lxkkqo3n6wKnua8O2uwkWUbh55GVdD3WjDWiK9KbEDRmi
         r0ay6x3rPzjdi3jU+TU4fBfsEbDCRTj+LMKfNX8fsq+JhQY7Hxx0k91yrPQEckRi7+uM
         X4GeAszHTVMOCTqhCQCYQRA57JWywhwmLg6V883aX5G1K4ZOfvBC/7C9+fuf5OwFb+Xu
         eILO+9twYBcuTjcUSBU3W+MUrkfmjXboC+L3w4YjT/UhCkvUPdIE249w+PsLh5tK4fZq
         18ew==
X-Gm-Message-State: AOJu0YwD35yyZ62BeV57iDLO+1XFT7V2uDxz/UCLIPGT+1jMxq/gYjiH
        ZGJHQFcpnnUES2epmZiAGujVWA==
X-Google-Smtp-Source: AGHT+IFpFgpWtQ0vxZHxxYqMEpv0vc+/4XUlVs2V2Kn0Ns0GGo2Ux88Orz/A1dcw/4CdBekgYXLkbQ==
X-Received: by 2002:a05:600c:205a:b0:3fe:5053:1a0b with SMTP id p26-20020a05600c205a00b003fe50531a0bmr1516585wmg.11.1694782624112;
        Fri, 15 Sep 2023 05:57:04 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p6-20020a7bcc86000000b003fbdbd0a7desm7373402wma.27.2023.09.15.05.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:57:03 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:57:00 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: error pointer dereference in bch2_copygc()
Message-ID: <18930ca3-9636-47c4-81bf-08766c4f28f4@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello Kent Overstreet,

The patch 46be00209417: "bcachefs: Rhashtable based buckets_in_flight
for copygc" from Mar 11, 2023 (linux-next), leads to the following
Smatch static checker warning:

	fs/bcachefs/movinggc.c:224 bch2_copygc()
	error: 'f' dereferencing possible ERR_PTR()

fs/bcachefs/movinggc.c
    190 noinline
    191 static int bch2_copygc(struct btree_trans *trans,
    192                        struct moving_context *ctxt,
    193                        struct buckets_in_flight *buckets_in_flight)
    194 {
    195         struct bch_fs *c = trans->c;
    196         struct data_update_opts data_opts = {
    197                 .btree_insert_flags = BCH_WATERMARK_copygc,
    198         };
    199         move_buckets buckets = { 0 };
    200         struct move_bucket_in_flight *f;
    201         struct move_bucket *i;
    202         u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
    203         int ret = 0;
    204 
    205         ret = bch2_copygc_get_buckets(trans, ctxt, buckets_in_flight, &buckets);
    206         if (ret)
    207                 goto err;
    208 
    209         darray_for_each(buckets, i) {
    210                 if (unlikely(freezing(current)))
    211                         break;
    212 
    213                 f = move_bucket_in_flight_add(buckets_in_flight, *i);

move_bucket_in_flight_add() can return a mix of error codes such as
-E2BIG.

    214                 ret = PTR_ERR_OR_ZERO(f);
    215                 if (ret == -EEXIST) { /* rare race: copygc_get_buckets returned same bucket more than once */
    216                         ret = 0;
    217                         continue;
    218                 }
    219                 if (ret == -ENOMEM) { /* flush IO, continue later */
    220                         ret = 0;
    221                         break;
    222                 }
    223 
--> 224                 ret = __bch2_evacuate_bucket(trans, ctxt, f, f->bucket.k.bucket,
                                                                     ^^^^^^^^^^^^^^^^^^
Warning.

    225                                              f->bucket.k.gen, data_opts);
    226                 if (ret)
    227                         goto err;
    228         }
    229 err:
    230         darray_exit(&buckets);
    231 
    232         /* no entries in LRU btree found, or got to end: */
    233         if (bch2_err_matches(ret, ENOENT))
    234                 ret = 0;
    235 
    236         if (ret < 0 && !bch2_err_matches(ret, EROFS))
    237                 bch_err_msg(c, ret, "from bch2_move_data()");
    238 
    239         moved = atomic64_read(&ctxt->stats->sectors_moved) - moved;
    240         trace_and_count(c, copygc, c, moved, 0, 0, 0);
    241         return ret;
    242 }

regards,
dan carpenter
