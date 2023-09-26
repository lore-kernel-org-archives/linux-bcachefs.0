Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71939E7E644
	for <linux-bcachefs@archiver.kernel.org>; Tue, 26 Sep 2023 14:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjIZOlu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbjIZOlu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 26 Sep 2023 10:41:50 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE7CE6
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:41:43 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-5044dd5b561so9210090e87.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695739301; x=1696344101; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q11hPvs/AWjH4kFjSv9Z2H7G6/oXN1MsQexjWQ3fxz0=;
        b=YnXa1kOt4emRO8i5AcSzxO8MxDXKZPPq6dxCuGws8SHv5rTaTnTP4JcMzLOzPYxcrJ
         VgA5RKtOuVyfVVlVimBc3RicCoxPUa1l1BVa2iIW28nj7fbFKsadqCtMnLJ47x69PtAu
         khEGy3tBT6keU0jFyn3X499byExTSMeKw+uW9byjx96IJaXj5UpIXqBALX09Z95K0Acr
         zQSfzwr5zk/xv2kvDX9ngnKa+PClV7PtNECTAL6BgADlD/BLgwzOAsWXnFNhg4HS6dN0
         FaJI0Dx/NJ+04CBoBrx2dyzIZgrGv5LP876z5cvdu01lVb2+a8VYz36Wy5cIYNs5KmHn
         c94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695739301; x=1696344101;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q11hPvs/AWjH4kFjSv9Z2H7G6/oXN1MsQexjWQ3fxz0=;
        b=Mgv92kowmURn6Qf5btBsh3Hh1Lyjd2aQoNS0EyRQpjnOyhtYR6YqEz6BjtpC+cTwPC
         /ifDYRHlXSxku83jFYs0g/ui57/weo8wi/UUpVGw46re6qZwlUpDyiw5qUzZA1GlMT2F
         JID2a07dkAjsc/dD02VbnCXDX5aOaTY1xCAkBYmsi7k4ktEVg4CdKEIrEzwkZYLZALFQ
         D4b342gZraMdXrqdYBTapdICrf7fGy+RQPNLkSeWdh0YO+Q19OYhHa+Kjz6PcUr/T7X3
         UcbIHWIj4XMIfn96lA6hZ2bhXiB83xcZ7ibVYJeME/B3xyLCS/VlViTzLi5HpNu0PER8
         sMWg==
X-Gm-Message-State: AOJu0Yy0ZU2KbfNhRxH/JCtVKcbXsgjyQ5+RtR3M6CZSfU5y98IDwHRc
        A/6IFrQq8U/v97KDVzgOrItBSQ==
X-Google-Smtp-Source: AGHT+IEHOdTOJSTcVMfwa592fOc8bh270wexG/ulCKbXHJcFYZhKs++nUmDiFA+/UANrE9F7Zstz5g==
X-Received: by 2002:ac2:515c:0:b0:501:c1d4:cf68 with SMTP id q28-20020ac2515c000000b00501c1d4cf68mr9230465lfd.15.1695739301411;
        Tue, 26 Sep 2023 07:41:41 -0700 (PDT)
Received: from localhost (h3221.n1.ips.mtn.co.ug. [41.210.178.33])
        by smtp.gmail.com with ESMTPSA id dz12-20020a0564021d4c00b0052fdc837d93sm3646006edb.47.2023.09.26.07.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 07:41:40 -0700 (PDT)
Date:   Tue, 26 Sep 2023 17:41:37 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <128ed1f9-fda3-48b0-b46d-e2a13982a880@kadam.mountain>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
 <20230919205659.v7ofsxjm2h7gkcgw@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919205659.v7ofsxjm2h7gkcgw@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 04:56:59PM -0400, Kent Overstreet wrote:
> On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> > Hello Kent Overstreet,
> > 
> > The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> > 2023 (linux-next), leads to the following Smatch static checker
> > warning:
> 
> So the smatch warnings are pretty hard for me to deal with - it appears
> you're testing each individual commit, which is what _I_ normally like
> to do, except in this case there's no way I'm applying all the fixes to
> individual commits in a 3k commit branch.
> 
> And, dealing with the back-and-forth of going through emails is also a
> bit much, I'm going to need to get smatch integrated into my CI.
> 
> But...
> 
> smatch doesn't build on debian.
> 
> Can we get that fixed?

It should.  I'm using it on Debian.  This should be a complete list of
the required packages.  Let me know if that's not complete.

apt-get install gcc make sqlite3 libsqlite3-dev libdbd-sqlite3-perl libssl-dev libtry-tiny-perl

Perhaps send a copy and paste of the build error?

regards,
dan carpenter
