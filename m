Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441ABC77B6E
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Apr 2023 16:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjDIQSo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Apr 2023 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIQSl (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Apr 2023 12:18:41 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2621E3595
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Apr 2023 09:18:40 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g19so46859507lfr.9
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Apr 2023 09:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681057118; x=1683649118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CQMz1HJ1ngBWEp/esH0pKuhk+9ZZG0GTiCr2s6qx3kE=;
        b=GBsqX2SQxZlu5a7N30dxWMiWzgaPLUfR4bIXPJy1j0d5CTzCYrWsOSZ0B/Qq8JrXGv
         gzih+o6FNwyertzhTkmuLg/f9Cqjy62E2ZC58xHblBJM/cXFnpJ0lxCC1xfHgzXeM70d
         YtMO0ccXF0bEY9J++t53eTNXYGG3eKEQWT9DVUDoEOux0VyUCsfwQfDnTIIRE+oIfyXp
         WO4jyO4dR0Y2T07yfaz5Rudj4MPWx1y1LLZWekzr3dWxAJucIKAGbyoLTA49LHp2gqv7
         RQaZVq/6XltaTfGbrL/HaRyPx6dKfSK3ZBIFk9Yx1xYTwINQpTwZMVzIg1KZxtSO6PWI
         /+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681057118; x=1683649118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQMz1HJ1ngBWEp/esH0pKuhk+9ZZG0GTiCr2s6qx3kE=;
        b=5zkDQldo+psVd6IOMQblGDsioOcFxA87CoUr0lXJs8IyfFDK78rYAHsUpzj4ACUO5Z
         R15Hv+5m0cFkundnSdVBWk5fXIruSLp7pM4pfdVyyqBEHUMP/pcXxAeXwL6XNnomOnly
         jN5LdpA0eq6O8lGQQWuS8QAId5ksw1atMv2QeQniGAzfnuygHBHhqButafd6EPUI+rWO
         j7UT58sAAqN6mBxo1LDkAg/DowKsQfqqHGKCZEiEsPxWXWia+pi8qPXE/1P2n/Fiphfk
         bgxI13wth6lFhzkZH+8BqCM83d4TUkUWF5DToMt7tDOMlI77fyJ/DJL/Zu3KJDOoEMwV
         fdgA==
X-Gm-Message-State: AAQBX9e7P0LVgiTwYG7TpmmzVrljbUVfIyBSEtkb0FQ7lcKWtMsWj60L
        JeyesnEIgMTRnwj8IZeRHnNVjeKudWauY6BtWMHTES4p+34=
X-Google-Smtp-Source: AKy350bPBBy0+QJ6K+JGZkYbqofT4kJOH47gqppUITfOqH5Zx4P8SeMzcNDy4gicHO1DG+/vD4RafS2oM+wSVmrokCI=
X-Received: by 2002:ac2:4543:0:b0:4eb:5232:53ad with SMTP id
 j3-20020ac24543000000b004eb523253admr1294077lfm.3.1681057118269; Sun, 09 Apr
 2023 09:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
 <ZC0XmlhMK1bEE2lq@moria.home.lan> <CAGXxSxVWsoh6=Z039Wn8caXa+BJU7inL-Kg0i328=-jxa4r-BA@mail.gmail.com>
 <ZC8d3nh0DEtpKpRd@moria.home.lan>
In-Reply-To: <ZC8d3nh0DEtpKpRd@moria.home.lan>
From:   cee1 <fykcee1@gmail.com>
Date:   Mon, 10 Apr 2023 00:18:26 +0800
Message-ID: <CAGXxSxUOD-miB_vCc-VZ=HmVcD1yevQN6q6mNd4waXCFda7mTQ@mail.gmail.com>
Subject: Re: Questions about struct btree
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

> > 2. Overwrite an existing key in a written set, a key of a different
> > value will be inserted in a tailing set, am I right?
>
> Yes.
>
> > What if overwrite the same key many times, will this create many
> > bsets? If so, how to keep "up to three bsets per struct btree"?
>
> No, overwrites don't cause new bsets to be created. We create a new bset
> when the last bset is getting too big and the memmove for inserting into
> it is getting too expensive, or when we don't have any unwritten bsets.

Wondering about a written-out bset, a key of it is overwritten, then
a) a new key is appended to that bset
b) bset::u64s will be updated? How to perform that update?

BTW, does each `struct bree` have `bch_fs::opts.btree_node_size`
occupation on disk?
Even if it contains lesser bkeys at the moment?

> > In
> > struct btree {
> >    ...
> >    __BKEY_PADDED(key, BKEY_BTREE_PTR_VAL_U64s_MAX);
> >   ...
> > }
> >
> > Can I say size of -- `struct bch_btree_ptr_v2` plus BCH_REPLICAS_MAX *
> > `struct bch_extent_ptr` -- is big enough for holding any bch_val?
>
> That's only true for btree node pointers.
>
> > In other words, bch_vals are either some small metadata, or somewhat
> > of pointers, e.g. pointing to a continuous of sectors?
>
> Some may be much bigger - i.e. bch_inline_data

Can I say,
- For the deepest bree node, its `->data` contains a series of bkeys
- And the corresponding bch_vals are pointers
- Each of them pointing to a bch_val of bch_inline_data?



-- 
Regards,

- cee1
