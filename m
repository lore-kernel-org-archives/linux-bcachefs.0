Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823F3EE020F
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 21:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjIMVnt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjIMVnt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 17:43:49 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F73173A
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:43:45 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-79266c8617eso10448539f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694641424; x=1695246224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2uTbHoVjqIh4YniElhtNqUimTSs8A7qRExDkzz0sEF0=;
        b=z9SMGeeCnAahU4w37gRdubNuNIWAlcY0lSpKN9caI91xeuEaFeIImhr607geAvw5uo
         0M8nGp+hZICMldY3Oczy+oXjbuMKHciPyMxAGjZHSExJPuotCHTCr3Gpl1mO/7Ydj3FV
         Q7X+kGmbhxgZdHnAyvISD2pHir3ztW0Q/BTESaNrVGYVZE6SZxb+0fLg/s6Tq3odP+6e
         URNHVdhFaY+G/GOHt6Xn72cHpxHQJodw94mNEA1ozImsQyd/7m5AJu+A0nErEztEK4f9
         XqQMdssFP62kvlLQ+srZZcSBixJbnMWJd1Z1mojhO6fLs+e/JBC7dCkGi7Y5xJMcA6nt
         gs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694641424; x=1695246224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2uTbHoVjqIh4YniElhtNqUimTSs8A7qRExDkzz0sEF0=;
        b=UBrS72FaSIqeelcDB6y/tTCyrtrjaD7SczsHt9N5XJyXTsUUWHL0oixgbHobolWZoZ
         n/g66c+fKfF2+RkSRqhV9FjR2SBXWUILelYYHS6fNV6eLcOWCxMNV0cLAWLngBZlPy24
         lIEUG69Pom/elsewOTnOqw76eMDukgzX38jCTkGMRqU6ehyr6k7AUQEeRFbPDf3Nyeob
         VwMS9WR8elOHlh5AEKVKNptH97P6vCLb5VZpQ6LAW4lM9uJK3JzIplUROMp/m6qz1DHK
         k9q9zDGiJdDk8te2jt1rv0bUmBgIXQI+06HgPTIAF2cCvTsjTuxAwp5Uz/I8XFWLKGGt
         teVg==
X-Gm-Message-State: AOJu0Yzi7NEMsNxds83ttJVT7sp/Sb3L6y7ZJ5Y1Oh/Gf++adoNyw5Ht
        AvJMLAmXOQaKyJd9wbOAGOGitw==
X-Google-Smtp-Source: AGHT+IFO/zPVL+GskkRXe3VhmvyBnlW+kHMrQL8DvF+HjBFPQoUGhuvzyAvTppC+0h0D/069z/uhyQ==
X-Received: by 2002:a05:6e02:1a87:b0:34c:cc37:3064 with SMTP id k7-20020a056e021a8700b0034ccc373064mr4518209ilv.15.1694641424661;
        Wed, 13 Sep 2023 14:43:44 -0700 (PDT)
Received: from google.com (26.103.132.34.bc.googleusercontent.com. [34.132.103.26])
        by smtp.gmail.com with ESMTPSA id e17-20020a056638021100b00431824abeccsm26753jaq.42.2023.09.13.14.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:43:44 -0700 (PDT)
Date:   Wed, 13 Sep 2023 21:43:41 +0000
From:   Justin Stitt <justinstitt@google.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     kent.overstreet@linux.dev, bfoster@redhat.com,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/7] bcachefs: Fix -Wformat in
 bch2_btree_key_cache_to_text()
Message-ID: <20230913214341.7qucftdltsljrzpf@google.com>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
 <20230912-bcachefs-warning-fixes-v1-2-a1cc83a38836@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-2-a1cc83a38836@kernel.org>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:15:39PM -0700, Nathan Chancellor wrote:
> When building bcachefs for 32-bit ARM, there is a compiler warning in
> bch2_btree_key_cache_to_text() due to use of an incorrect format
> specifier:
>
>   fs/bcachefs/btree_key_cache.c:1060:36: error: format specifies type 'size_t' (aka 'unsigned int') but the argument has type 'long' [-Werror,-Wformat]
>    1060 |         prt_printf(out, "nr_freed:\t%zu",       atomic_long_read(&c->nr_freed));
>         |                                     ~~~         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                     %ld
>   fs/bcachefs/util.h:223:54: note: expanded from macro 'prt_printf'
>     223 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
>         |                                                               ^~~~~~~~~~~
>   1 error generated.
>
> On 64-bit architectures, size_t is 'unsigned long', so there is no
> warning when using %zu but on 32-bit architectures, size_t is
> 'unsigned int'. Use '%lu' to match the other format specifiers used in
> this function for printing values returned from atomic_long_read().
>
> Fixes: 6d799930ce0f ("bcachefs: btree key cache pcpu freedlist")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
> ---
>  fs/bcachefs/btree_key_cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 505e7c365ab7..a74ee6d8a7cf 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -1053,7 +1053,7 @@ int bch2_fs_btree_key_cache_init(struct btree_key_cache *bc)
>
>  void bch2_btree_key_cache_to_text(struct printbuf *out, struct btree_key_cache *c)
>  {
> -	prt_printf(out, "nr_freed:\t%zu",	atomic_long_read(&c->nr_freed));
> +	prt_printf(out, "nr_freed:\t%lu",	atomic_long_read(&c->nr_freed));
>  	prt_newline(out);
>  	prt_printf(out, "nr_keys:\t%lu",	atomic_long_read(&c->nr_keys));
>  	prt_newline(out);
>
> --
> 2.42.0
>
