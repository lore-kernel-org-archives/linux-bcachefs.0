Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1D2C7619A
	for <linux-bcachefs@archiver.kernel.org>; Sat, 15 Apr 2023 16:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDOQOa (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 15 Apr 2023 12:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDOQO3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 15 Apr 2023 12:14:29 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C44830DB
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Apr 2023 09:14:28 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id n22so20393211ljq.8
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Apr 2023 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681575267; x=1684167267;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h821yxgt7ngXLg6yGdPQIm/ouvEam5X+xrK0/h9puLo=;
        b=M79ToCuVI5CsCgPFKm6cbtoZK29greTcW9eeXu7YMdpHKYvYFRFnVMwtEkbVxE65Kg
         7BQs+NpYSFHleALvDkuTaqmZW4W3oMUyBMpSwpKXBXkstr0F9BwYXF2WHHHPJ+U8IlnZ
         +IZyfbk03gnPENyzFJWjjnzEEmSGEEetpY9bVJzd5YtGKWKXJl7zr3Xu0DrF+a47vyIu
         EavQV/P8uqsmJf5GECJV43ErMCLDlL+vKfn7OQySWiyex6zNCa9+kR57Q3nVgLsNvx9/
         kTs9IzWF9HTzdzjWD483WlDMhuiOiS8cyNCr5NVvgI9XKtQ4p+EGIdAA+XTnb8UAHS/p
         VXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681575267; x=1684167267;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h821yxgt7ngXLg6yGdPQIm/ouvEam5X+xrK0/h9puLo=;
        b=CBdsAaNgopRkG+guPzSwigdC5vqmkXLtXhl+M6D+j0LAWhk+O0rPKUa0pqgebtpXVc
         GBQSa0CBd87DB6RBrrH9DxgTcEKH8HDKU67K/uWeGf/1R7+s5tHKaRCGruUUDUKz4ity
         9VkxulSfTSws7LrbDPcnV+P9Z/gbnEc4x8ykzAj0jAaQLPfQX7zpn28XqW4dSr8R1otz
         Tvyb6H8IIAf8Ghoj2lcjqhhe43KKGtHW/zxERuuK5LbY9LVuJlEOKLQ4itREOl/uYjCs
         NY1GoimRBxEOmVllNURcVpzmzktav5Fp3JHShgI8HMAL7U/4tiuGBB314BnxGIdOqWdV
         T7FA==
X-Gm-Message-State: AAQBX9eMN0YC3oaOWWIjxim847rseHwzYZRWUs/KLhb4ZUVeVE6YRI5Q
        qFpMUPoH5LlKByRTkvkCspzt6XUhxqrpr7UmVFKj/lNK1yY=
X-Google-Smtp-Source: AKy350bqpJa26m/E/wB1Q+y6Gl4qvVqxThZvzLaEVwvgn+ZymX1I0rSGJSZRkloSomzWjbYLVB0PCVvV55IpelCHMJw=
X-Received: by 2002:a2e:9811:0:b0:299:a9db:95 with SMTP id a17-20020a2e9811000000b00299a9db0095mr3044755ljj.1.1681575266579;
 Sat, 15 Apr 2023 09:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
 <ZC0XmlhMK1bEE2lq@moria.home.lan>
In-Reply-To: <ZC0XmlhMK1bEE2lq@moria.home.lan>
From:   cee1 <fykcee1@gmail.com>
Date:   Sun, 16 Apr 2023 00:14:14 +0800
Message-ID: <CAGXxSxWa0CRmC-+Qt6my+FD+9Q=2G929Ufj+POTR75mUxkUMKg@mail.gmail.com>
Subject: Re: Questions about struct btree
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

> > b) struct btree::set
> > How many effective bsets (or btree_node / btree_node_entry) referenced
> > by btree::set?
> > Two? one for written, one for in-memory?
>
> Up to three, decreasing in size geometrically.

Still thinking about how this "up to three bsets" is accomplished?

I find:
a) In the read path of `struct btree`,  e.g. a b->key of type
KEY_TYPE_btree_ptr_v2:
    That means it has a bch_val of a bch_btree_ptr_v2 head following
several bch_extent_entries

    In `bch2_btree_node_read()`, it will construct a bio:
    set bio.bi_iter.bi_sector to bch_extent_ptr::offset
    set bio.bi_iter.bi_size to btree_bytes, which is 256KB by default

    And then in `bch2_btree_node_read_done()`, it will try to retrieve
ALL bsets in
      "0" - "bch_btree_ptr_v2::sectors_written" of 256KB

   ALL above bsets will be sorted via `struct sort_iter`, that means
num of bsets is limited to "MAX_BSETS + 1", right?

   ALL above bkeys of bsets will be filtered and moved into a new
bsets in `bch2_key_sort_fix_overlapping()`, and b->nsets is set to 1

b) In the write path, i.e. `__bch2_btree_node_write`,
    All changes that are not written to disk will be filtered and
moved into a new bset.

    And a bio is constructed:
    set bio.bi_iter.bi_sector to "bch_extent_ptr::offset + (old) b->written"
    set bio.bi_iter.bi_size to size of `struct btree_node_entry` and its bset

    That means, the new content is appended to formerly written content.


My question is: if many write path is triggered, there will be too
many bsets written to disk.
-   Then doing a bch2_btree_node_read() later, it may overflow
sort_iter::data[MAX_BSETS+1]?



-- 
Regards,

- cee1
