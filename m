Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E6C7618D
	for <linux-bcachefs@archiver.kernel.org>; Thu,  6 Apr 2023 16:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbjDFQJz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 6 Apr 2023 12:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbjDFQJq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 6 Apr 2023 12:09:46 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F150A9755
        for <linux-bcachefs@vger.kernel.org>; Thu,  6 Apr 2023 09:09:37 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h11so44517301lfu.8
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Apr 2023 09:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680797376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6YTCRQT6hyEtiiy0sDa9aiW7+kcUVdGCLAoyncjik58=;
        b=XW00Ddz6trK/mpmd6ObZdFK3e53qz792axxO81bvszYKcM4Zqs8Ld9zpNzk1E9EhmW
         dFvojwo/StIH/D+j3h8eO2MCQwzZFktxfqA+6aXB6AXQoDeIV4Vc5OB225wF9KNL197h
         G0wJ3aoOuZKB6aEwjhflsl7XjSAuDhWvVyggmjfDHR2h18MyDo1x22eWMyzc5GYBi7GS
         Yx59AboSkHgKbnS16f8qwWdGzAN7xczMWpm2BKqWvOzv/Aj+gOMaD35oQHDrJT9NAFP+
         eyyHG/QItHP0xgIsbqi5ft0PAltaIiOw4/XpYa+vdLWvaYwHnrMvv+zbaU8M1MqmcWHy
         M95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YTCRQT6hyEtiiy0sDa9aiW7+kcUVdGCLAoyncjik58=;
        b=DjiWooyozB31XYJwYX/6xnGrRzBVXp/nyUzOqlRwyDfHkrc0xf72fiq91nd460gZrm
         3XRTXUiFAb1hIk4f4XH+zt68B1OMCBUAHemARMX/exjso2K1tjKLYqhjWwWOvosihMB/
         VWiAuY7lujwVSpruckJnCOyPmMBOqAsYi/7I7v5o0dVLy2VF8muAh9Ksmu/oooSN8ih3
         mOI/tixn6DaTbT5hnr40P2B0r83BHoPAhIo9qDjNHUKlKU/1luAhFsAcHyyPjGfJW4OG
         tHKMi8m9OmzZl0JVriC529RxkSqgSV/jT1E3qhnIRJLfB/2PSokiJ6Yv9WpSJ2YqzjRx
         EuRQ==
X-Gm-Message-State: AAQBX9dbh+ggVBKlJhUf5VW7YJ+KIpFidCxBHrHiF83kXii6v6CjEjo9
        BVy/9jxjlFD+mX0TzSTWc3NdVzko9AcFBH2MImrrfJ/e94A=
X-Google-Smtp-Source: AKy350ZNyRZSU75ygD1TEkdSVehUzJc6WE9FnaY+Qjo29Vip8hGKRT5FfwNhXhoM5xn2KzYf3PYGM1QAZoK7GK96aCI=
X-Received: by 2002:a19:c206:0:b0:4eb:5232:53ad with SMTP id
 l6-20020a19c206000000b004eb523253admr2162517lfc.3.1680797375969; Thu, 06 Apr
 2023 09:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
 <ZC0XmlhMK1bEE2lq@moria.home.lan>
In-Reply-To: <ZC0XmlhMK1bEE2lq@moria.home.lan>
From:   cee1 <fykcee1@gmail.com>
Date:   Fri, 7 Apr 2023 00:09:23 +0800
Message-ID: <CAGXxSxVWsoh6=Z039Wn8caXa+BJU7inL-Kg0i328=-jxa4r-BA@mail.gmail.com>
Subject: Re: Questions about struct btree
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

Thanks for the reply.

>
> > b) struct btree::set
> > How many effective bsets (or btree_node / btree_node_entry) referenced
> > by btree::set?
> > Two? one for written, one for in-memory?
>
> Up to three, decreasing in size geometrically.

Is btree::set[0] special? How is set[0] special comparing with the
other two sets?

Comments from struct btree:
/**
 * set[0] is special; set[0]->tree, set[0]->prev and set[0]->data point
 * to the memory we have allocated for this btree node. Additionally,
 * set[0]->data points to the entire btree node as it exists on disk.
 */

Two further questions:
1. btree_node::min_key and max_key, does it mean ALL keys start from
min_key, end with max_key, exist in this btree_node? (assuming not an
interior node)

2. Overwrite an existing key in a written set, a key of a different
value will be inserted in a tailing set, am I right?
What if overwrite the same key many times, will this create many
bsets? If so, how to keep "up to three bsets per struct btree"?


>
> > c) What are bch_vals ?
> > bch_val is BCH_REPLICAS_MAX number pointers, which are offsets --
> > pointing to BCH_REPLICAS_MAX number extents, am I right?
>
> bch_val is an empty type, a placeholder for whatever the actual value
> type is - you may be referrinc to bch_extent.

In
struct btree {
   ...
   __BKEY_PADDED(key, BKEY_BTREE_PTR_VAL_U64s_MAX);
  ...
}

Can I say size of -- `struct bch_btree_ptr_v2` plus BCH_REPLICAS_MAX *
`struct bch_extent_ptr` -- is big enough for holding any bch_val?

In other words, bch_vals are either some small metadata, or somewhat
of pointers, e.g. pointing to a continuous of sectors?


-- 
Regards,

- cee1
