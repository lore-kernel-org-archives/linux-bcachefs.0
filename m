Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5647CDB483
	for <linux-bcachefs@archiver.kernel.org>; Wed, 18 Oct 2023 23:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjJRXIf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 19:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjJRXIe (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 19:08:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2771711D
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 16:08:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5a9d8f4388bso3561886a12.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 16:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697670512; x=1698275312; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R+6LQBPGNqtPA5naLsc4aWMbk2cbN8f3X83ZN1e7doc=;
        b=Xq16VMB8MbLQIbbytd5otyYLEV5P2YpV1m0avVRYXmb7fxOQ+y/1DjQg8EiZGn1auC
         BoLq16q7xV3IWV/PrLuaJnEmN/80IWjLd6d7PXrdeuBXNvCq4+q2g3vBbVAabycaAPP7
         zHoJnb7bg6Xjx4OfEYnbPBZE53RHlC4ngKZB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697670512; x=1698275312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+6LQBPGNqtPA5naLsc4aWMbk2cbN8f3X83ZN1e7doc=;
        b=Kys4sOpRX6bTb6RIlCqk1hlkb83a3Qo4sb4aH6p/bfbtmiCmT5ZvBmjCxDoyGGlOkj
         tuLY3eeFy8v2BqhIax/8fxDXa/b6ZdHG+iWMLVRXGzYQp2Y7yMPc1U71fwusl/IKX7cZ
         iLLBg5MQy8EDMUuxCjj2cHftEmVZqAVJ3cFagYWtxHUm0RWRsTbGUzKQC5jfqSIqCnue
         Cpp73/nTQuzlPOFJzQWwWV9IbuOGa1hgZoaoW7xTCiVlHaINciFVFw1u2e1heG+r++N9
         Wz096VR4I/1m1LVe4dgQh48SUICf4I75fmxR6jGIXDfCzuWp7EL5E8px6ms7GzL1uREV
         hjvw==
X-Gm-Message-State: AOJu0YwQNr6myzH+Tq6jSh0CMdkmFjGWQ8R026qaYd71VQXc6g5PbH3i
        +IWHAsy6PyX90Ua4lM5WN0vKLQ==
X-Google-Smtp-Source: AGHT+IGYHNW6Jmdfy0D/h4oQ4a9/L+RvvlkoNY7K3oxKe9nrIXzWzuGuPdxEnJjAmD+yjr63m8Zczg==
X-Received: by 2002:a05:6a21:329d:b0:17b:43:9ba5 with SMTP id yt29-20020a056a21329d00b0017b00439ba5mr625475pzb.52.1697670512667;
        Wed, 18 Oct 2023 16:08:32 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id v5-20020a1709029a0500b001bbb7af4963sm471155plp.68.2023.10.18.16.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 16:08:32 -0700 (PDT)
Date:   Wed, 18 Oct 2023 16:08:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Refactor bkey_i to use a flexible array
Message-ID: <202310181607.2244DB9F40@keescook>
References: <20231010235609.work.594-kees@kernel.org>
 <ZSkpU0vdrCTfTxuZ@bfoster>
 <202310131637.D0C66BFBA@keescook>
 <20231018220407.b5dvm2ehibcqvhzq@moria.home.lan>
 <202310181534.54934E68@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202310181534.54934E68@keescook>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 03:36:00PM -0700, Kees Cook wrote:
> On Wed, Oct 18, 2023 at 06:04:07PM -0400, Kent Overstreet wrote:
> > On Fri, Oct 13, 2023 at 04:44:21PM -0700, Kees Cook wrote:
> > > On Fri, Oct 13, 2023 at 07:26:11AM -0400, Brian Foster wrote:
> > > > Hi Kees,
> > > > 
> > > > I'm curious if this is something that could be buried in bch_val given
> > > > it's already kind of a fake structure..? If not, my only nitty comment
> > > 
> > > I was thinking it would be best to keep the flexible array has "high" in
> > > the struct as possible, as in the future more refactoring will be needed
> > > to avoid having flex arrays overlap with other members in composite
> > > structures. So instead of pushing into bch_val, I left it at the highest
> > > level possible, bch_i, as that's the struct being used by the memcpy().
> > 
> > I agree with Brian here - I'd like this buried in bch_val, if possible.
> > 
> > I also went with unsafe_memcpy() for now - that's now in my for-next
> > tree. I'm not seeing any advantage of DECLARE_FLEX_ARRAY over that -
> > perhaps later if we could use __counted_by that would make more sense.
> 
> This won't help here because of the combination of -fstrict-flex-arrays=3
> and -Wstringop-overflow (the latter is in W=1 builds). The builtin memcpy
> still complains about the 0-sized destination. I'll send a v3 with this
> in bch_val.

Actually, I've sent a v3 that totally replaces the memcpy with a direct
assignment instead. No struct changes needed!

-- 
Kees Cook
