Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5B9EE0210
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 22:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjIMWGg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjIMWGf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 18:06:35 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B19E1998
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 15:06:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-7983b202929so11139639f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 15:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694642791; x=1695247591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=urxSjSL8TtkNIjZ7m8FLIkazvrzMdKz3VUacjiaJ2lk=;
        b=bAcmVUDP6DCYHwYVTd07mGoaSWz9vDMuwc7y/MsDGXScHp88EjVsDFEWlzLjEYb2M3
         0l9OtUDelQfF027yic3n53mTtnLZlozMu81nQqS7wi7Ux6wg6BKycW9UxyKW3Ko0odIl
         PCqGBdFMHztAG1/qNsow1WciC03TT1/9d3aXjnCznIlS+yK60zD6mjDHcrjkbpgp6zhQ
         JDI9uJBi1R8QKmdAzpAmu3/til6U36MpchrvzRieedYddf+EJbWvH85wOi+ChVkPqNHQ
         pDfspOByVAAdSo48owMKOiF90evLg0wyE+gwUje3QT1KDkenKnHgXgoPWyydRe4m6Pz5
         wXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694642791; x=1695247591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urxSjSL8TtkNIjZ7m8FLIkazvrzMdKz3VUacjiaJ2lk=;
        b=w80qSfzAWwgIn+6pEe2MoTieRagClkUUtbw7OL0QDfiWLv90xCz02eyrSEHMh/Cjzs
         yrGptbZtATryaiFtfYFVEjBv2Tp1JMOT6LPW2QOU5mtjgYkdrD7qUGLTczeZchl6Wa6y
         iC+yqqgY4/6ZyiHPFI9cKRB2IB/KpoioSnnOV5rGt/pfjpuvHG3keKZNY2ggJD8KSG80
         wjzvkrIc8Xo+WGgWuoHSKtxDcfcQ33AHz+vJh+NU92pI2YkbeMMqcZowR8QAujBUgNyZ
         GjEqZg4QnwHAEExD4SlxQaIH7w72PYWjg9fZlA0PtzHvlJgdkdu7UK3OiLaO7DaaNwmg
         tphA==
X-Gm-Message-State: AOJu0YwFEmmCZsxQVDbJMEC0n0NL82D6isH+2AHEdEC3h+gUWeOmj/zK
        A6Dz14lPoH+DvgIlugAYpkMs8sny8ws5+0/OqQMbdA==
X-Google-Smtp-Source: AGHT+IG5lMN9N/NzZheFxGkrAa3zZ64Hdpr+KgHYX6YrzH90dnpy4eCfT7a9AYM2XtlTfn9FY4Ldpg==
X-Received: by 2002:a6b:6d15:0:b0:795:196c:a074 with SMTP id a21-20020a6b6d15000000b00795196ca074mr4625700iod.3.1694642790891;
        Wed, 13 Sep 2023 15:06:30 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id i9-20020a02cc49000000b0042b0de0b976sm31899jaq.154.2023.09.13.15.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 15:06:30 -0700 (PDT)
Date:   Wed, 13 Sep 2023 22:06:27 +0000
From:   Justin Stitt <justinstitt@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     kent.overstreet@linux.dev, bfoster@redhat.com,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 7/7] bcachefs: Fix -Wcompare-distinct-pointer-types in
 bch2_copygc_get_buckets()
Message-ID: <20230913220627.stso6sxqyraizqod@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-7-a1cc83a38836@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-7-a1cc83a38836@kernel.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:15:44PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a warning when using
> max() to compare an expression involving 'size_t' with an 'unsigned
> long' literal:
>
>   fs/bcachefs/movinggc.c:159:21: error: comparison of distinct pointer types ('typeof (16UL) *' (aka 'unsigned long *') and 'typeof (buckets_in_flight->nr / 4) *' (aka 'unsigned int *')) [-Werror,-Wcompare-distinct-pointer-types]
>     159 |         size_t nr_to_get = max(16UL, buckets_in_flight->nr / 4);
>         |                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/minmax.h:76:19: note: expanded from macro 'max'
>      76 | #define max(x, y)       __careful_cmp(x, y, >)
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
> warning when comparing these two expressions. Use max_t(size_t, ...) for
> this situation, eliminating the warning.
>
> Fixes: dd49018737d4 ("bcachefs: Rhashtable based buckets_in_flight for copygc")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
> ---
>  fs/bcachefs/movinggc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index 256431a6dc0c..1cb441d90b34 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -156,7 +156,7 @@ static int bch2_copygc_get_buckets(struct btree_trans *trans,
>  	struct bch_fs *c = trans->c;
>  	struct btree_iter iter;
>  	struct bkey_s_c k;
> -	size_t nr_to_get = max(16UL, buckets_in_flight->nr / 4);
> +	size_t nr_to_get = max_t(size_t, 16U, buckets_in_flight->nr / 4);
>  	size_t saw = 0, in_flight = 0, not_movable = 0, sectors = 0;
>  	int ret;
>
>
> --
> 2.42.0
>
