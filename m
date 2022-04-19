Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A60C433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 18:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353571AbiDSSfM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357234AbiDSSez (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Apr 2022 14:34:55 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526EF3CA4E
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Apr 2022 11:26:11 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id d19so6337973qko.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Apr 2022 11:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TVrSTiDEKIaKyp3DAJ7q1DL+kynVDQ9riEOq2QZpnuU=;
        b=dF/VZa1IYe0px7m6I4Pijx+Q2lYrMuZdOzcc3iySe9Q4OyU6f4Ls2WDnsB/ecoLXRq
         3YlIUId7ZNxaT7hZZR3sPZWMgxDiLgIZSBUlN3o5+2b9YEqsGceNdxlGFojP+V+e8DAT
         hsI3IMY86/Wn6N8UAmDMzKG3bNeGQjvlrdQIMyy6inXzJlgNbQcp2v0qR1TO4mYN4WMl
         O+buQ3O7K92FCVukkGoQAlJNSvQx2n/6f91oXvAn/g/FQmz2ww8IMYD8ZtyUPZ7vofuq
         1RTxYhxo+s359s3nOSi1BEPkV7zxHruvNyZldF2/CvZ0slTd43eQYrD6eEW7VSHZhQY4
         GSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TVrSTiDEKIaKyp3DAJ7q1DL+kynVDQ9riEOq2QZpnuU=;
        b=O2OB+IQqwRRL05yKZ3Yy8Rb5Pd/4/s8yA1ABWYRyVFUXKZ8E2jYmQzW111WrSoHRzR
         WCMvwN0zaFBjhCkzEi5iQT+x5n8c35/dacUHZrsZcJNk9oYSymnwzdq0HtiQsLOUMQFC
         ocKMFwX+q9iEXmaxqoEg+aWK7zDFpaH31iWX7ONLjC53/NclggzEnhVs+rMDVN+wYf1N
         qGIZIPQxADbLaRjuEa9R+lELNt/VX+x3wYBsj/xnZUH/IZTKPgwqKjAKrD1U0j/nhYl4
         XdrTMBhPfuEEq+R6Is/BXkZZnOznGDh9N9B+09lJDW3l6JSVCA0A9Gb8P0YyCQqDMA39
         U4xQ==
X-Gm-Message-State: AOAM532S99fo2O3sp/jbmSUc8oSrzjdSdM+yFeRga4yqvHGOdBZ96gpO
        iNbAnWVViM0LU/dP/9KBWA==
X-Google-Smtp-Source: ABdhPJxmZfSktmXTUOJb+ijMCqUubv7AodhdTkvxuV4KzLHixxbs0iOFL/dzw54SVlGLzwR5HWtlEg==
X-Received: by 2002:a05:620a:28ce:b0:69e:7b84:888e with SMTP id l14-20020a05620a28ce00b0069e7b84888emr9368055qkp.252.1650392770263;
        Tue, 19 Apr 2022 11:26:10 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id c20-20020a05622a059400b002e1d59e68f3sm466554qtb.48.2022.04.19.11.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:26:09 -0700 (PDT)
Date:   Tue, 19 Apr 2022 14:26:07 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: migration to livetree failed: journal corrupt
Message-ID: <20220419182607.vbuyafvic3j5wj3v@moria.home.lan>
References: <b3eddb73-abb9-49aa-af43-7c90efd602b7@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3eddb73-abb9-49aa-af43-7c90efd602b7@kabelmail.de>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Mar 24, 2022 at 07:27:41AM +0100, Janpieter Sollie wrote:
> Something failed while moving a large (24tb, 4tb allocated) multi-tiered filesystem to livetree
> structure,
> it immediately goes read-only.
> After doing bcachefs fscheck, it hung at going read-write,
> so I retried with --realloc-btree.
> This time, it complained about journal corruption.
> Is there any way I can safely drop the contents of the journal? The filesystem contents have not
> changed since its last reboot.

Bug reports need to include relevant logs - I can't say anything without at
least that much
