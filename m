Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718E7E784A4
	for <linux-bcachefs@archiver.kernel.org>; Mon,  2 Oct 2023 06:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbjJBGm0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 2 Oct 2023 02:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbjJBGmZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 2 Oct 2023 02:42:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7749B4
        for <linux-bcachefs@vger.kernel.org>; Sun,  1 Oct 2023 23:42:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-327be5fe4beso988574f8f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Oct 2023 23:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696228941; x=1696833741; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iFLmBMbTAf5mYpVSeF0tgLxlIm+hQtraBWqw0SVaZ1s=;
        b=naGNygrWouv1YEjdJBD+4287aMp5/GFRojK0NrGzzsdHpmff/N6Io1fiYjlkMD4aw6
         00oet6LnyjwPxQbu99r1+fu5kyqYPenaYRmQeQ6ffkTh1AE5RtYnPS9ZXtLmiUWHOhhL
         OJuaYcvCpUtBNYQn2bL2T/6pg6EP+v8C6YMM8NgTfbGPm2CH7fqmZoujoJyvNxEow2HQ
         mHoXB89mF/4n98+PCVqylfjxp/fHkkho+eANT53vHan+RFgKiy+v1kUeFJWuwjvoKvOp
         VNpdRNy01htzmY1nnH2VE7SDYyZJFveOVXtMORoIjuhv5j04wfKD9Ckx+uHxMOYL+zVg
         xsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696228941; x=1696833741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFLmBMbTAf5mYpVSeF0tgLxlIm+hQtraBWqw0SVaZ1s=;
        b=rXBwO/y66v3baGMykbV2RIoBDqcknNBulIeuav5DXgJiAuxVDMPSh/b2hpjoLQZbvY
         tu41sT03DP49yV46Lr0RvmcYe6/28iliK8D79uDYMz5P9w5PNoWRDw5AcJWAVzYCfc+a
         bUnXPZTLivmhKYN+AHf/L1VTaZQrbwxjMXuUU0HscG25Ez30OQAOTnu3uMV2oeCQArqx
         1DQtRN6Dl5GOzKV2Rc5pPQT1wt4dN6xnQiOrdNpEo6A0ZbfF5c6Ufl84VwuZeEnGL5NN
         ndCRuep5DRinRrb2IOL1uhEyph0Pl6S1mYy+lzKHlY5YnKV+kFSb43tk52SkDXLseUn2
         saww==
X-Gm-Message-State: AOJu0Yzq45++BCJdOyYe0pIisnNtJPRBfl4NfbKdS8LGvAutH5Jw264M
        MkH5wjSxKk2ZGJV4qCcoSWBiwg==
X-Google-Smtp-Source: AGHT+IG5F6WCA+givsf9KFa40Uq2QQ0EtyZVPcp2/kezx1bCSCz837j2NkrcYNJnzvEwO3xWwac9nA==
X-Received: by 2002:adf:f085:0:b0:320:77f:a97c with SMTP id n5-20020adff085000000b00320077fa97cmr9346986wro.63.1696228941280;
        Sun, 01 Oct 2023 23:42:21 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d594b000000b003140f47224csm9346368wri.15.2023.10.01.23.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Oct 2023 23:42:20 -0700 (PDT)
Date:   Mon, 2 Oct 2023 09:42:06 +0300
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
Message-ID: <ff682afb-a914-4cd7-8d19-202a6cb778de@kadam.mountain>
References: <120b638f99b088f91d5a4491c800463c554e70b8.1696144401.git.christophe.jaillet@wanadoo.fr>
 <7ae7737e-e32c-e9e7-880c-cafc240e7c33@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae7737e-e32c-e9e7-880c-cafc240e7c33@embeddedor.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 01, 2023 at 09:23:17AM +0200, Gustavo A. R. Silva wrote:
> 
> 
> On 10/1/23 09:13, Christophe JAILLET wrote:
> > Use struct_size() instead of hand writing it.
> > This is less verbose and more robust.
> > 
> > While at it, prepare for the coming implementation by GCC and Clang of the
> > __counted_by attribute. Flexible array members annotated with __counted_by
> > can have their accesses bounds-checked at run-time checking via
> > CONFIG_UBSAN_BOUNDS (for array indexing) and CONFIG_FORTIFY_SOURCE (for
> > strcpy/memcpy-family functions).
> 
> I would prefer this as two separate patches.
> 

I kind of feel like it's all part of one thing.  It's easier to review
as one patch.

regards,
dan carpenter

