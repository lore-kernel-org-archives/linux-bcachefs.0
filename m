Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096CAEE14C3
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Sep 2023 20:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbjIFUVa (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 16:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244384AbjIFUV3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 16:21:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491801BD3
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 13:21:20 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51a52a7d859so2925889a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 13:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1694031678; x=1694636478; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=juvIBN8bH5nfyemIbaYqy2hi6dz3IfTdEON4xkDZyZg=;
        b=LmO/AEN05xILKYsMLaoZsLbQGdc/6PcgAb5OerutYzUfm49tWSoRfaGS3YrE5+hmW2
         o4HvizGFnU4GnuycWAduXHmqNQrAY39kDjLmQ4SKC2uqwdk8OpALf5UKxHqXRwPkkU+Z
         4YnKK5dT2R4E1KsW8GHvtVBQ6plmYXY9r1Zns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031678; x=1694636478;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=juvIBN8bH5nfyemIbaYqy2hi6dz3IfTdEON4xkDZyZg=;
        b=DV47juCOwTa5ABHilSuaevvO9kiJMWNjiKyQfY/zw7AR1EGncJ5S9pfscEM0Z9f7Am
         abFmUeuhPpMjEYlZk3WaQ4IPAt3W+RhUOT6EV4u7k92r+5eGxoUInTjEeZzovxbY/PEy
         aU59LAHFVXyAkdRIIJ+uJ04D4V7zmeedbvIkZlfmhaTwL+29wrjZqnUgX0KNaVfX2mEn
         Zq6RfLbXWxMzxqYPlwaQ2QiITMlJ9mkqE742q75+XXveH5IML6HQ1wyizTqODrrQG141
         dbhN5LFEiAlPSHJcaGUFglsHVLROCQUJ/akrsCzqyrc4VNvCWAK9NAQPsqn/F+2dyHwn
         MFjQ==
X-Gm-Message-State: AOJu0Yw0NnSa8BT4hmScsU/gJJ46E1TU4F3S4Erc5VJmK9BNhtkL7mJj
        TIGU//NHUU8M1xAIq4/r7ZwYeTbDs5pGYjuqv11IsQ==
X-Google-Smtp-Source: AGHT+IHWyPCcXn6+2oz3QAfgEHxE3eDcQax4RT+XWhvL4IBb2XcuyKd1sJqz5Ln0bAUYsxhSK5aeMg==
X-Received: by 2002:a17:907:7855:b0:9a5:a543:2744 with SMTP id lb21-20020a170907785500b009a5a5432744mr982784ejc.33.1694031678463;
        Wed, 06 Sep 2023 13:21:18 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090699ce00b0099bccb03eadsm9300797ejn.205.2023.09.06.13.21.17
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 13:21:17 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so2876557a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 13:21:17 -0700 (PDT)
X-Received: by 2002:a05:6402:50ce:b0:521:ef0f:8ef9 with SMTP id
 h14-20020a05640250ce00b00521ef0f8ef9mr908145edb.19.1694031677181; Wed, 06 Sep
 2023 13:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <CAHk-=wjUX287gJCKDXUY02Wpot1n0VkjQk-PmDOmrsrEfwPfPg@mail.gmail.com> <CAHk-=whaiVhuO7W1tb8Yb-CuUHWn7bBnJ3bM7bvcQiEQwv_WrQ@mail.gmail.com>
In-Reply-To: <CAHk-=whaiVhuO7W1tb8Yb-CuUHWn7bBnJ3bM7bvcQiEQwv_WrQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 6 Sep 2023 13:20:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6EAPRzYttb+qnZJuzinUnH9xXy-a1Y5kvx5Qs=6xDew@mail.gmail.com>
Message-ID: <CAHk-=wi6EAPRzYttb+qnZJuzinUnH9xXy-a1Y5kvx5Qs=6xDew@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 6 Sept 2023 at 13:02, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And guess what happens when you have (unsigned char)-1? It does *not*
> cast back to -1.

Side note: again, this may be one of those "it works in practice",
because if we have -fshort-enums, I think 'enum
btree_node_locked_type' in turn ends up being represented as a 'signed
char', because that's the smallest simple type that can fit all those
values.

I don't think gcc ever uses less than that (ie while a six_lock_type
could fit in two bits, it's still going to be considered at least a
8-bit value in practice).

So we may have 'enum six_lock_type' essentially being 'unsigned char',
and when the code does

    mark_btree_node_locked(trans, path, 0, BTREE_NODE_UNLOCKED);

that BTREE_NODE_UNLOCKED value might actually be 255.

And then when it's cast to 'enum btree_node_locked_type' in the inline
function, the 255 will be cast to 'signed char', and we'll end up
compatible with '(enum btree_node_locked_type)-1' again.

So it's one of those things that are seriously wrong to do, but might
generate the expected code anyway.

Unless the compiler adds any other sanity checks, like UBSAN or
something, that actually uses the exact range of the enums.

It could happen even without UBSAN, if the compiler ends up going "I
can see that the original value came from a 'enum six_lock_type', so I
know the original value can't be signed, so any comparison with
BTREE_NODE_UNLOCKED can never be true.

But again, I suspect that in practice this all just happens to work.
That doesn't make it right.

               Linus
