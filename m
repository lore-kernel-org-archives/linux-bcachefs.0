Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693F0EE0211
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 21:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjIMV7J (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbjIMV7J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 17:59:09 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E931739
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:59:05 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-34dec9c77d4so1127035ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694642344; x=1695247144; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+zCQ2BjBgtFZ2NhlAiFIzP/Im5wW1vWUYChl7lp+s88=;
        b=C0/FLksVXCzrSsWv6Olgk6TH/DNyfcQuLtXkWD1j3DYxHeTnumPet4iuR3/EjGWfKZ
         tNq+JHOOYtcjy6nBgMUvo3X8ejCAPUv6QjJ22sjTmPZWLvFwHQ/nx6Wtn9q/MZjIO/UP
         MumGtm52a2kwj6vQ3wQpcadrWI3wyHK1k4Fa9urFAMmEr8KZzrSBvvsE8+h8YlHIVU1U
         ntPmPQXnq+hFXbdeaSdPqZ/Oybb8O76uk5layqSCoPsIFWgzKwu0d5fghbAGhpZG5Wu3
         ee/v3dYRg+MT3oZdE6JBCsX4NuXfGI8yXoyITSRNqMQgoQyVer7nMuy4i82Z2EqPsaQ3
         FcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694642344; x=1695247144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zCQ2BjBgtFZ2NhlAiFIzP/Im5wW1vWUYChl7lp+s88=;
        b=s8JuUGJ5re1plD6sXIyspKQAj7BlQ3R1CVG6Y/hOpda56Rvck228ZTpnqlsXzdTvzd
         caMt/qd/CQy4ORpWesM3rCFZ7CKOA+DRbdZSzUnmkZ3tpbPJD3ppJkVCgtsvBvL30eHp
         IQP6DqQ3DzC4gbBwlXTBIDuhr+HMv2YSxVWQJZZS8b1UOxYeu0sfXaUHt7XgO0A2PbaH
         5j7AK1CI5bnshNhW/291M3ImjmHRG1XablBv+Z/WVbMsamTm1qrWdTx6vv+OakkspNEp
         EwJxs8ptIxm3GFenwxsl2+Lvhikcqht82oblKZNLNg6zIiG94hH0aB3ywFPGjkfHJCwz
         xtZA==
X-Gm-Message-State: AOJu0YzCq2ZMS6kCqKIYA8hpXMtYnYoWVGkutBeYSu+U7YvW8nHLLWNr
        VVUpz5potgUTBu5xpCOECyoFEA==
X-Google-Smtp-Source: AGHT+IHqayyFOTET4Oxr9mF0S5RGQHFaeK9o3on7YXY3s2SYxwil2JxnMX2Joby5fXJ//kuV/gya1Q==
X-Received: by 2002:a05:6e02:1d8b:b0:349:2d61:8631 with SMTP id h11-20020a056e021d8b00b003492d618631mr5002348ila.10.1694642344560;
        Wed, 13 Sep 2023 14:59:04 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id ee18-20020a056638293200b0042b57bbbaf2sm34665jab.26.2023.09.13.14.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:59:03 -0700 (PDT)
Date:   Wed, 13 Sep 2023 21:59:01 +0000
From:   Justin Stitt <justinstitt@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     kent.overstreet@linux.dev, bfoster@redhat.com,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 6/7] bcachefs: Fix -Wcompare-distinct-pointer-types in
 do_encrypt()
Message-ID: <20230913215901.kffbnpkosg7pkxd6@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-6-a1cc83a38836@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-6-a1cc83a38836@kernel.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:15:43PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a warning when using
> min() to compare a variable of type 'size_t' with an expression of type
> 'unsigned long':
>
>   fs/bcachefs/checksum.c:142:22: error: comparison of distinct pointer types ('typeof (len) *' (aka 'unsigned int *') and 'typeof (((1UL) << 12) - offset) *' (aka 'unsigned long *')) [-Werror,-Wcompare-distinct-pointer-types]
>     142 |                         unsigned pg_len = min(len, PAGE_SIZE - offset);
>         |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:69:19: note: expanded from macro 'min'
>      69 | #define min(x, y)       __careful_cmp(x, y, <)
>         |                         ^~~~~~~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:38:24: note: expanded from macro '__careful_cmp'
>      38 |         __builtin_choose_expr(__safe_cmp(x, y), \
>         |                               ^~~~~~~~~~~~~~~~
>   include/linux/minmax.h:28:4: note: expanded from macro '__safe_cmp'
>      28 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>         |                  ^~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:22:28: note: expanded from macro '__typecheck'
>      22 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>         |                    ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
>   1 error generated.
>
> On 64-bit architectures, size_t is 'unsigned long', so there is no
> warning when comparing these two expressions. Use min_t(size_t, ...) for
> this situation, eliminating the warning.
>
> Fixes: 1fb50457684f ("bcachefs: Fix memory corruption in encryption path")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/bcachefs/checksum.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
> index 36939020f67d..ff0c3cd39ee2 100644
> --- a/fs/bcachefs/checksum.c
> +++ b/fs/bcachefs/checksum.c
> @@ -139,7 +139,7 @@ static inline int do_encrypt(struct crypto_sync_skcipher *tfm,
>
>  		for (i = 0; i < pages; i++) {
>  			unsigned offset = offset_in_page(buf);
> -			unsigned pg_len = min(len, PAGE_SIZE - offset);
> +			unsigned pg_len = min_t(size_t, len, PAGE_SIZE - offset);
>
>  			sg_set_page(sg + i, vmalloc_to_page(buf), pg_len, offset);
>  			buf += pg_len;
>
> --
> 2.42.0
>
