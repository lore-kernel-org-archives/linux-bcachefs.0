Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91178E7849A
	for <linux-bcachefs@archiver.kernel.org>; Mon,  2 Oct 2023 07:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjJBHHD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 2 Oct 2023 03:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbjJBHHC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 2 Oct 2023 03:07:02 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC39AC
        for <linux-bcachefs@vger.kernel.org>; Mon,  2 Oct 2023 00:06:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-50435a9f800so24103412e87.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Oct 2023 00:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696230417; x=1696835217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WGSmVU6eV61MEm0eDF1LjmBvte+gjgPeqhrseQVFPWQ=;
        b=eLbWnRa36GNcZkjZ9H6CHmbBxpGRwnPpqbheEb7mjXBO63a4RQYlX2SqcehANGP9Ju
         U4hlN2qv5yWQ7uh8RNWZFBZYlqIKkxugExiz9yXLoAxGY5wyzPH5FVCsHA8XFiP1F1pQ
         FxSL9sYlLD1gE+xB1e81mcSv2Ss+XrVDLr+QxU2Kq6OBtrC0o6rS4KGxplNMdOpKHOIY
         Bth9ZWy7wJZDvJPsonDpxD/yQvmaRzuLeJSOHZ5KO8TJhWwrNWYDwaxN+LfzXl2JwHVb
         Zo1leWQURgLaTSAKxXpwkv6PgG3w8fL1qsL+4VFg2dO/fWBzEK6ffYQM7r1CfMnXILKb
         R/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696230417; x=1696835217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGSmVU6eV61MEm0eDF1LjmBvte+gjgPeqhrseQVFPWQ=;
        b=VI53gjq7OeZzb6mra9YClf+D1SMcI1JipLk9eMkFjxa8TkyR4e4o+i61AXoLe/KrT1
         YG5R6WUzUQxQlxWFcPZDSw8SCrnI4ov7VyMzJKjoJaxBlGM3Zu3vAikbUipOQLe45G1J
         EeTwZSCsCof1VFjqNwb2Q/z/q7PQFhdeXZ+97/jPJiZcRtFZbonxVQApc9BVVm7mjwzf
         fI2hrdbtmmh3vhnTreFI4rEyxzULWpzyDWfY5uCJFlnQA/+X/pTuwD0gf1TfQbfenu/c
         rAhyRR+R4P8Nhpzt7VpmRw7+b6jKNtTeQ7ok6y+GiZ7z3A+1g8o3rs6dY2aJm5NN9a8h
         amiw==
X-Gm-Message-State: AOJu0YwVO+vNVHXfrbPc6uNysXi4MwN1Mx9aWfhvvvTvvTLhEJbRqNi3
        cknosY8wesKdbX8Ag1rKtswJCw==
X-Google-Smtp-Source: AGHT+IFqNxtPg80t50ZYFfWxUt2W5y2FEtd43xRb6YCWO1WM7DYE1bqvmoOMC0T13JN44j87ql34Rw==
X-Received: by 2002:a05:6512:1598:b0:500:78ee:4cd7 with SMTP id bp24-20020a056512159800b0050078ee4cd7mr10804857lfb.23.1696230417514;
        Mon, 02 Oct 2023 00:06:57 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id z17-20020a05600c221100b0040642a1df1csm6565662wml.25.2023.10.02.00.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 00:06:57 -0700 (PDT)
Date:   Mon, 2 Oct 2023 10:06:54 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Use struct_size()
Message-ID: <fdc46489-4266-48e3-99cc-ddb23b64f02e@kadam.mountain>
References: <120b638f99b088f91d5a4491c800463c554e70b8.1696144401.git.christophe.jaillet@wanadoo.fr>
 <7ae7737e-e32c-e9e7-880c-cafc240e7c33@embeddedor.com>
 <ff682afb-a914-4cd7-8d19-202a6cb778de@kadam.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff682afb-a914-4cd7-8d19-202a6cb778de@kadam.mountain>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 02, 2023 at 09:42:06AM +0300, Dan Carpenter wrote:
> On Sun, Oct 01, 2023 at 09:23:17AM +0200, Gustavo A. R. Silva wrote:
> > 
> > 
> > On 10/1/23 09:13, Christophe JAILLET wrote:
> > > Use struct_size() instead of hand writing it.
> > > This is less verbose and more robust.
> > > 
> > > While at it, prepare for the coming implementation by GCC and Clang of the
> > > __counted_by attribute. Flexible array members annotated with __counted_by
> > > can have their accesses bounds-checked at run-time checking via
> > > CONFIG_UBSAN_BOUNDS (for array indexing) and CONFIG_FORTIFY_SOURCE (for
> > > strcpy/memcpy-family functions).
> > 
> > I would prefer this as two separate patches.
> > 
> 
> I kind of feel like it's all part of one thing.  It's easier to review
> as one patch.

Also I think there is static analysis which sees struct_size()
allocations and pushes people to use __counted_by() so doing it in two
steps is sort of like introducing a static checker bug and then
silencing it in the next patch.

regards,
dan carpenter

