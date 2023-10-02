Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2232BE7849A
	for <linux-bcachefs@archiver.kernel.org>; Mon,  2 Oct 2023 04:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjJBEw1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 2 Oct 2023 00:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjJBEw1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 2 Oct 2023 00:52:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC39B4
        for <linux-bcachefs@vger.kernel.org>; Sun,  1 Oct 2023 21:52:24 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c5db4925f9so18643605ad.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Oct 2023 21:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696222344; x=1696827144; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vgZc1gl8r9gpj8F7Au1ygxE46XZZIEmRRHjiEVQPVBA=;
        b=TL+HoLMvWBDopW0IXzRldKSynFlSpTg0Bg1mJ4trFQJilvADyqdIfpRRV0VZlwLXh7
         Sc3dCxRRCOZNIcawLY8aBmEyTDR2cFz2FbiIyc6/IMFfBa4+V6f9HlTQog0wfwISkkfI
         iZc749P+OsQk+I8lQnLhnH63D7kTF5iSkptB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696222344; x=1696827144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgZc1gl8r9gpj8F7Au1ygxE46XZZIEmRRHjiEVQPVBA=;
        b=ebdcRxoWY4TT68MZb/RnISg1D/m0/1X4wm7f2G0CUxpl0bUFi+sRZTvOWsxi8rDRe3
         aMtTT+hw3Ux6v8bDJDKsXjrYJBBgokOqYFZ6JXjtZUe8PrcmGZxZbuxtIi9FqNHsLHAj
         7HYC1zLjhnC0T/YJ7gkZ7L5c4YdCZoVTih/gMeFSfE0xX+2WOM8j4m9FBlUTnKrgktdH
         OeQhlU6qYFHaovD6QyKrf5J+aZjXi0gQa5g5v+c9YSfhQTAnwTJHwfbKgZhBc12gYkxR
         T9T7eISI85g+MvGknW52SMADbzxJD5QrgO6vrlbR1GpNgNCKJHdBYBmOe4Us/+LulVHt
         oqRg==
X-Gm-Message-State: AOJu0YzsNszziJZxh+IbwOPuRf9KpVwbWp1pA0kx9aHE26hp8ixZWN5Y
        kswW/yv3rah2818PD6d2/ekQwg==
X-Google-Smtp-Source: AGHT+IEoCHeBBwDUL5/duEukBlE8ayroCrMSrtJAST1F9vN+5909TzVhFCg4Lq92qLJoTTJZW7Qzsg==
X-Received: by 2002:a17:902:e54a:b0:1c5:6f4d:d6dd with SMTP id n10-20020a170902e54a00b001c56f4dd6ddmr18858004plf.24.1696222344309;
        Sun, 01 Oct 2023 21:52:24 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902d31200b001b03a1a3151sm9883404plc.70.2023.10.01.21.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Oct 2023 21:52:23 -0700 (PDT)
Date:   Sun, 1 Oct 2023 21:52:22 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Brian Foster <bfoster@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 df964ce9ef9fea10cf131bf6bad8658fde7956f6
Message-ID: <202310012150.72AAB06FAD@keescook>
References: <202309301308.d22sJdaF-lkp@intel.com>
 <202309301403.82201B0A@keescook>
 <20231002032239.t7ghpigbq5jy3ng7@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002032239.t7ghpigbq5jy3ng7@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 01, 2023 at 11:22:39PM -0400, Kent Overstreet wrote:
> I'm not leaping at the chance to reorganize my fundamental data
> structures for this.

Yeah, understood. Thanks for taking a look at it!

> Can we get such an escape hatch?

Sure, please use unsafe_memcpy(), and include a comment on how the sizing
has been bounds checked, etc.

-- 
Kees Cook
