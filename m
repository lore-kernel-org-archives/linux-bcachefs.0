Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B328E7E643
	for <linux-bcachefs@archiver.kernel.org>; Tue, 26 Sep 2023 14:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbjIZOyS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIZOyR (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 26 Sep 2023 10:54:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DE810E
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:54:10 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-99c93638322so2003516066b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695740049; x=1696344849; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Byv7gLwDTKNLooXJQ3qslykgS3alMsM9pSK+EXKvnU=;
        b=ePNaM/lkNy65zRWT2sgw9dVQpeYnjmVSRb1epu+oGzBIjAX+BGMYhpGInIJnnv3qwX
         fu6Sgxk1atZjIYAVNr9IROhYnnn+meWgAVZ+ok3ZFX4ZeGen6DF6Gsy+O3kloLwBukCt
         pi6ZWjyyudzgxFK5XzPx5/Kgy1QKcNx+z0lr6Qjcl64qFisw/zZEy1mj6Q15IOYeYtVv
         IAag5TxTXRG4w2CRWne2mJ5JutmvN6qvEWxZNon98trdar7ItNRuLDrO0SoV/tm7Zo78
         sR2waqgdPvvV/dEJ9qURDuEnrRhRU7pYMklarctmMF7eFf3HTvwegO+5bVP6X5LgR9fl
         +HDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695740049; x=1696344849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Byv7gLwDTKNLooXJQ3qslykgS3alMsM9pSK+EXKvnU=;
        b=AOzdUNPkuL4gHBXhjBt3N5aolzG7+5g2g1ogiaJa0EaPqSIJfL7Cz6FGZh9Athz/H1
         XgGhRBi/OSb477M0pTUuajwUhqpYWfgeWkQPQI+xQnCrKt/jibKy1n5v+nxnpxSZjgku
         o2Xyy3DwNasUXGRHrmnLAHsDIhDYfRumYHHdGC+DxPJoBiwOXJCm3KSIiRJX55mBoovV
         h1hhsUe8EqFlsgMJVR62G05im930uuexoA4X/96v0XLwjlwOQ2o7f0pFoifJUt8eMgQw
         6rKWpsNemzR61z+9a+3gqTFmwQcByKbkFaasIxI0yM39HEGobJlujZ7THftroAyf3uXf
         NwSg==
X-Gm-Message-State: AOJu0Yxev+oTMs9mddp0f/SsWW+gHCpSqZaqGLke2dKLnza5weAbBsxO
        Sdx9oS46JfGN9GDPWjit8rxgvd7O5rnFVVgm0dE=
X-Google-Smtp-Source: AGHT+IH2LObpeToYEhF7qQYf4U/PoAMh8HmLdssBmj1OlqlFkZT6u9KQFHHYnvW7QkFVeHefE36lBw==
X-Received: by 2002:a17:907:1c0f:b0:9a5:ca06:6a25 with SMTP id nc15-20020a1709071c0f00b009a5ca066a25mr4795212ejc.16.1695740049132;
        Tue, 26 Sep 2023 07:54:09 -0700 (PDT)
Received: from localhost (h3221.n1.ips.mtn.co.ug. [41.210.178.33])
        by smtp.gmail.com with ESMTPSA id h13-20020a170906584d00b00992b8d56f3asm7868242ejs.105.2023.09.26.07.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 07:54:08 -0700 (PDT)
Date:   Tue, 26 Sep 2023 17:54:00 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <5b5dfab5-ef1a-4ee8-bef7-4b8293f513f2@kadam.mountain>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
 <20230920023731.e3emdmwqpqktta2j@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920023731.e3emdmwqpqktta2j@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 10:37:31PM -0400, Kent Overstreet wrote:
> On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> > Hello Kent Overstreet,
> > 
> > The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> > 2023 (linux-next), leads to the following Smatch static checker
> > warning:
> > 
> > fs/bcachefs/journal_io.c:1461 journal_buf_realloc() warn: sleeping in atomic context
> > fs/bcachefs/journal_io.c:1662 bch2_journal_entries_postprocess() warn: sleeping in atomic context
> > fs/bcachefs/journal_io.c:1764 bch2_journal_write() warn: sleeping in atomic context
> > fs/bcachefs/journal_io.c:788 jset_validate() warn: sleeping in atomic context
> > fs/bcachefs/replicas.c:439 bch2_mark_replicas() warn: sleeping in atomic context
> > 
> > All this sleeping in atomic warnings start in journal_write_done()
> > where it takes spin_lock(&j->lock) so preempt is disabled.
> 
> 
> >From 0528bebd8b42ce43a39da8e911bf21825f5085dd Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Tue, 19 Sep 2023 22:36:30 -0400
> Subject: [PATCH] bcachefs: drop journal lock before calling journal_write
> 
> bch2_journal_write() expects process context, it takes journal_lock as
> needed.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Thanks!

regards,
dan carpenter

