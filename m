Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835FAEE14C3
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Sep 2023 00:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbjIGADR (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 20:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjIGADR (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 20:03:17 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B11739
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 17:03:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-68bedc0c268so404202b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 17:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694044988; x=1694649788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ti3MTuTnE8QUIsT6JhVKAYKBHjNaaV3NZtYfcLrTnyM=;
        b=QJhsPW5pmsVJAMPEgdoSr420jjUt8SdP9cCSdbV9l9M5C0ezH5wAPh3DFmWjbmbWbo
         kCRvT6CL8DQLqNDRFo4TZ93WILYOeK14WCg9gYP4xmIU2szwujaawPMmC2kfE+unmfjH
         kSTx6a0pkzLkeLzTEzpgqe3qBE0GfIHg9xsu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694044988; x=1694649788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti3MTuTnE8QUIsT6JhVKAYKBHjNaaV3NZtYfcLrTnyM=;
        b=Wt83WltlimKOoOY0ympopMIDAjcOtJjVLcxe/W7vqFe4PEe6Pt8vZ1vDgDtKFcN2Da
         DTWVrIAUODL8Hvll1fbMzQPXp5dMDcJaU8ElR2zZbQ1ieRhwMaf2+DiXY4RzG88nFS0S
         RyZ8AowgTc6HRBq8LiVwPtTCFDV/OlvCsJpukN7QSxnV2MEQ6aHheokxDgKQBSAltmx8
         fCJ1jrNs2BgI6K/us3xbgCgL50aSFU2vbj2m1fiMBNMu0weZtqvR4opFb/X3iC0kyzM5
         itcop1Wrlkr8fg5EsUy3VP5S4/yoTZZ2lH7lYrT1fEzG/voVb6nWwWVlw5z3d3xm8eFP
         fIlA==
X-Gm-Message-State: AOJu0YweanHdI4R4xJbgzSyJ8WhDH1RklhByBYYedyCaNZDXc2K6uzeD
        0kjjf+RpjYJLs7onLf/5LtymiWtnwMFVun91yc0=
X-Google-Smtp-Source: AGHT+IFTP8tZKvLB6uavqOYtGmVlHW4eo+pUC3lCgd7rg3HzFhsrSXbcr2fuPtY2kR0VpOZ14cTQ7g==
X-Received: by 2002:a05:6a00:4208:b0:68e:3614:87cb with SMTP id cd8-20020a056a00420800b0068e361487cbmr2325108pfb.8.1694044988402;
        Wed, 06 Sep 2023 17:03:08 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a17-20020a62e211000000b006887b69f034sm11351432pfi.102.2023.09.06.17.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 17:03:07 -0700 (PDT)
Date:   Wed, 6 Sep 2023 17:03:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs
Message-ID: <202309061658.59013483F@keescook>
References: <20230903032555.np6lu5mouv5tw4ff@moria.home.lan>
 <20230906222847.GA230622@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230906222847.GA230622@dev-arch.thelio-3990X>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 06, 2023 at 03:28:47PM -0700, Nathan Chancellor wrote:
> Hi Kent,
> 
> On Sat, Sep 02, 2023 at 11:25:55PM -0400, Kent Overstreet wrote:
> > here's the bcachefs pull request, for 6.6. Hopefully everything
> > outstanding from the previous PR thread has been resolved; the block
> > layer prereqs are in now via Jens's tree and the dcache helper has a
> > reviewed-by from Christain.
> 
> I pulled this into mainline locally and did an LLVM build, which found
> an immediate issue. It appears the bcachefs codes uses zero length

It looks like this series hasn't been in -next at all? That seems like a
pretty important step.

Also, when I look at the PR, it seems to be a branch history going
back _years_. For this kind of a feature, I'd expect a short series of
"here's the code" in incremental additions (e.g. look at the x86 shstk
series), not the development history from it being out of tree -- this
could easily lead to ugly bisection problems, etc.

-Kees

-- 
Kees Cook
