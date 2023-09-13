Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59E5EE020F
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 21:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjIMVqJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjIMVqI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 17:46:08 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C349D173A
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:46:04 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-34f68376b57so1179065ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694641564; x=1695246364; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hS6LHZP97enWTuQrtj4p55fJQ0mnk4aMtCPKI4xtC9M=;
        b=18tlNagWct2lJErMpBBze8hACFvX5AZfJLqUoJDTdn8+tzMzPrIui3pb2PRkgj3YRu
         f3PuBDz4ls1YMRvPhgpSyYyA6cuJ4I5XNaR6KVrZiBdpZf4zJxTuT43MBLxiREBUSS0h
         n0rMasvjPs+aSvU1ZoLuE4EJrbCDGYGXaOjaTabw0jAPqvNi8OB2Zs35x0jwYYoeZL1t
         GCazIk56jwrycpvcVMZDZuY4cmhHxFrFJYFGDTEOghy3vcv022pDC3ofYa/CDup4TApO
         zsqta+wTSCB6mC7WWxEw7SwfhbeBOm48l4Kvz/qeKWRo2I6tLda2b1MaCpapl6aCnH08
         4F2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694641564; x=1695246364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS6LHZP97enWTuQrtj4p55fJQ0mnk4aMtCPKI4xtC9M=;
        b=bDUZlECEYvNAyoJStn2LaiSM8pM56wdaRkXBBBgEQwv/reGsabDRqNNaLSRPNUcGEz
         Mj3XETXXbrrVcwNSh0IxVEF7OCZ5Dbq21f6WEzpMkNxVdUkeTzI/8bQuqbmLVbBIA2rC
         gCfAUOJP16YD8Ere/Xj4F36ZHZorf12bKc950i8nLHDJPDWt2rToEt5veHZ34jJOET7l
         lw/MF6R4+deV6EmZCZHzPtPx5Hg/lw0iai4n+7V8MQmTsk3H27hvnnbp9R+P5B9lNM6x
         9vGxzjh6Yu3ssG7jpAknvrTozR0NJvS9aNVt4lgpbaqBpksnnhzTSBsfAgXsifvMYGpR
         XRwg==
X-Gm-Message-State: AOJu0YyI+BVuUx02mUEh2s48ssSLo6tezO8t05FuefqhrMGZnW1dOH1h
        znU0a7Nb5tZs6cR1x49B5WYQJg==
X-Google-Smtp-Source: AGHT+IEB+MklxqwnlrjkpN5LSD98xUtIFfRsg2kZyYkJD4SxmRxnVtsxRjGe7HwbeANhxquKJjnX0g==
X-Received: by 2002:a05:6e02:214d:b0:349:9af9:d412 with SMTP id d13-20020a056e02214d00b003499af9d412mr4794802ilv.0.1694641564057;
        Wed, 13 Sep 2023 14:46:04 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id f15-20020a056638118f00b004316bbe1d4csm24843jas.78.2023.09.13.14.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:46:03 -0700 (PDT)
Date:   Wed, 13 Sep 2023 21:46:00 +0000
From:   Justin Stitt <justinstitt@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     kent.overstreet@linux.dev, bfoster@redhat.com,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 3/7] bcachefs: Fix -Wformat in bch2_alloc_v4_invalid()
Message-ID: <20230913214600.y3eo3emayljnxfuy@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-3-a1cc83a38836@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-3-a1cc83a38836@kernel.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:15:40PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a compiler warning in
> bch2_alloc_v4_invalid() due to use of an incorrect format specifier:
>
>   fs/bcachefs/alloc_background.c:246:30: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     245 |                 prt_printf(err, "bad val size (%u > %lu)",
>         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                     %u
>     246 |                        alloc_v4_u64s(a.v), bkey_val_u64s(k.k));
>         |                        ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/bkey.h:58:27: note: expanded from macro 'bkey_val_u64s'
>      58 | #define bkey_val_u64s(_k)       ((_k)->u64s - BKEY_U64s)
>         |                                 ^
>   fs/bcachefs/util.h:223:54: note: expanded from macro 'prt_printf'
>     223 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
>         |                                                               ^~~~~~~~~~~
>
> This expression is of type 'size_t'. On 64-bit architectures, size_t is
> 'unsigned long', so there is no warning when using %lu but on 32-bit
> architectures, size_t is 'unsigned int'. Use '%zu', the format specifier
> for 'size_t' to eliminate the warning.
>
> Fixes: 11be8e8db283 ("bcachefs: New on disk format: Backpointers")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/alloc_background.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index 540d94c0cceb..67e73864823c 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -242,7 +242,7 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
>  	struct bkey_s_c_alloc_v4 a = bkey_s_c_to_alloc_v4(k);
>
>  	if (alloc_v4_u64s(a.v) > bkey_val_u64s(k.k)) {
> -		prt_printf(err, "bad val size (%u > %lu)",
> +		prt_printf(err, "bad val size (%u > %zu)",
>  		       alloc_v4_u64s(a.v), bkey_val_u64s(k.k));
>  		return -BCH_ERR_invalid_bkey;
>  	}
>
> --
> 2.42.0
>
