Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A452EC7EE24
	for <linux-bcachefs@archiver.kernel.org>; Tue, 16 May 2023 21:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjEPVCQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 16 May 2023 17:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjEPVCP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 16 May 2023 17:02:15 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B307682
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 14:02:13 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1ae4e264e03so1315935ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 14:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684270933; x=1686862933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4gb25Ei0JSEmyaarjaFRwAmoHZeJNXvUZ7mQGmJMkM=;
        b=KtyRC9F1fE4nz8CrqDbA2xaYHOUBWDoNH74nB2uDcEebJO2VwplriHX7LlB09nU3G6
         YEGNUg62dGFEI4no7AG3GW9J9lI/ZY4XPoDo6M0Rkq8hKgaouJ+v7vi0a45NctboVC/I
         NSeJx6HcEkLywbA2pd4HCmOIKTzRc699Uyuv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684270933; x=1686862933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4gb25Ei0JSEmyaarjaFRwAmoHZeJNXvUZ7mQGmJMkM=;
        b=i4/FKZXWJmZbEwa+fn+pmdYgdpTHPBBy7JY/tMegMLwzFsdq+7sRQQx1tP9RpIEj74
         DbVst3ZEblrHTYjza+dqvRwUuUI30HLld8VaqoXP4HfKz6f1Z82OYOmaEFRct9tQyIiF
         MA77ckue8dahtV0RXLaNQVShqSlljepBbj47dxdO9lJTT90XQVhgKnI+zBIxx1FNDp2S
         AIfRTx7wTl5jBw9QHmRWCwu0Hk0OWU4CFseTkF8O4/v+mg/DH4NsYSu7wjZDhthmlAsu
         3tlgyyy2rWPHralTIPOMpo+e/zGeGjKFFspyUIs5wwqUqR/oTOQdDJ+e4ZcsDXPOmm/D
         olzQ==
X-Gm-Message-State: AC+VfDzcWwwZPIWxz3HSjBcXfgklO9Sms6nPlatye9WGEs6Tw+8FkTUQ
        jX1klOBEHQp0XUsi1Fwc0jJDDw==
X-Google-Smtp-Source: ACHHUZ7KotVRk+nJvBcqkyJKzbRGNTueF40ja0SXderHguWoH0vVOUylN9pvJx4d8nNrjCwTTD4G+g==
X-Received: by 2002:a17:902:e545:b0:1ac:544c:12f4 with SMTP id n5-20020a170902e54500b001ac544c12f4mr45522015plf.2.1684270932915;
        Tue, 16 May 2023 14:02:12 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001a9b7584824sm15940769plb.159.2023.05.16.14.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 14:02:12 -0700 (PDT)
Date:   Tue, 16 May 2023 14:02:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH 07/32] mm: Bring back vmalloc_exec
Message-ID: <202305161401.F1E3ACFAC@keescook>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-8-kent.overstreet@linux.dev>
 <3508afc0-6f03-a971-e716-999a7373951f@wdc.com>
 <202305111525.67001E5C4@keescook>
 <ZF6Ibvi8U9B+mV1d@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF6Ibvi8U9B+mV1d@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, May 12, 2023 at 02:41:50PM -0400, Kent Overstreet wrote:
> On Thu, May 11, 2023 at 03:28:40PM -0700, Kees Cook wrote:
> > On Wed, May 10, 2023 at 03:05:48PM +0000, Johannes Thumshirn wrote:
> > > On 09.05.23 18:56, Kent Overstreet wrote:
> > > > +/**
> > > > + * vmalloc_exec - allocate virtually contiguous, executable memory
> > > > + * @size:	  allocation size
> > > > + *
> > > > + * Kernel-internal function to allocate enough pages to cover @size
> > > > + * the page level allocator and map them into contiguous and
> > > > + * executable kernel virtual space.
> > > > + *
> > > > + * For tight control over page level allocator and protection flags
> > > > + * use __vmalloc() instead.
> > > > + *
> > > > + * Return: pointer to the allocated memory or %NULL on error
> > > > + */
> > > > +void *vmalloc_exec(unsigned long size, gfp_t gfp_mask)
> > > > +{
> > > > +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
> > > > +			gfp_mask, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
> > > > +			NUMA_NO_NODE, __builtin_return_address(0));
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(vmalloc_exec);
> > > 
> > > Uh W+X memory reagions.
> > > The 90s called, they want their shellcode back.
> > 
> > Just to clarify: the kernel must never create W+X memory regions. So,
> > no, do not reintroduce vmalloc_exec().
> > 
> > Dynamic code areas need to be constructed in a non-executable memory,
> > then switched to read-only and verified to still be what was expected,
> > and only then made executable.
> 
> So if we're opening this up to the topic if what an acceptible API would
> look like - how hard is this requirement?
> 
> The reason is that the functions we're constructing are only ~50 bytes,
> so we don't want to be burning a full page per function (particularly
> for the 64kb page architectures...)

For something that small, why not use the text_poke API?

-- 
Kees Cook
