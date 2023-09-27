Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFAAE810C1
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 10:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjI0Kjs (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 06:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjI0Kjs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 06:39:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3F1126
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 03:39:46 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-3247d69ed2cso411627f8f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 03:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695811185; x=1696415985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vn2vVC5SvMAm8tEuxz3PSrFXyrRn293kZnwOzoWmIeM=;
        b=V4jOrjnhmrgYG9uurISX8HQxO8mVMnKmzXNQ5CK7Vz6QL/U4B84dPWMztgFi8C9DMw
         ShvM3IuppLG1dlWdvm2DvMjGWmeT8UyiI8X2p/GhSlmgRC5G1iuZ/grvM1oMqqKkcAuh
         KdqFPMgF/MJJZgYvs4r/w1HcqC7B6X3VgYpscvv4TSQfbwL9RsVwR5Cga9nrNOuhC6bo
         1UePDMVmsPku/c1K2C3WSoPLUci2epXZC8RvjwKBsc1IeOtfXQdrBItbElWjgVX/hPSO
         j9movOWVdkV5BwahHdyC4xzNg0M/T8DRW1Fr7/xa274QnnzEfOHAH3S7VkPGrZvQQW8A
         mfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695811185; x=1696415985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vn2vVC5SvMAm8tEuxz3PSrFXyrRn293kZnwOzoWmIeM=;
        b=hpu4kiyF0jcD4doabMXpv/deyzXCIFChh7iTiFVRDrXO6HsExcpH27/7MXK4yJIMQJ
         40b0pS/igoL59wiZYeYlFw3ygjoUQYgxH8EiTP07lBpTVto7uja7nMIFv+/nzuJthho6
         ksgw9uNo8S3f3riVa1ZVrAwQdIbqZIzRenYngJACD8vK9yr0x+P1UpoSd03CwdGLeYvb
         0gP1CI4zb9DYpgJtCsQXBbhB71jwFbgEelv1pcVQHYi3DzZyCVgyhv492Xk2pa+nVJOQ
         DWjO/FZiBdHNY/QV8DkntxnRm3khBuB4AcbjTQ4rY4FY9uwNFH4LCBGshfHweIYbxcDg
         uUrw==
X-Gm-Message-State: AOJu0YyE1ysxX42KNyPkj0pK83ZLc4bIiYIHGlkCwMQkeUeFwcTjSaT2
        Hr6S3FVZzIXVZMtyslBnHe2H0Q==
X-Google-Smtp-Source: AGHT+IHrg2bh8EshM/N0SQ7b0AU7WYnr8ull4zRdUZnWX9vFBk3JON2bvghW8XlJJcDoWZef+jqBiA==
X-Received: by 2002:a05:6000:10d0:b0:31a:e772:ddf6 with SMTP id b16-20020a05600010d000b0031ae772ddf6mr1337240wrx.39.1695811184812;
        Wed, 27 Sep 2023 03:39:44 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b12-20020a5d634c000000b0031ad2f9269dsm16807421wrw.40.2023.09.27.03.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 03:39:44 -0700 (PDT)
Date:   Wed, 27 Sep 2023 13:39:40 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: sleeping in atomic
Message-ID: <2e7d85bd-1a1c-4c38-90f2-9b439984efb9@kadam.mountain>
References: <cf328a38-b2a6-4cae-8ec0-fb17551623c0@moroto.mountain>
 <20230919205659.v7ofsxjm2h7gkcgw@moria.home.lan>
 <128ed1f9-fda3-48b0-b46d-e2a13982a880@kadam.mountain>
 <20230926161333.kkkbyx2jotssbqvm@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926161333.kkkbyx2jotssbqvm@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 26, 2023 at 12:13:33PM -0400, Kent Overstreet wrote:
> On Tue, Sep 26, 2023 at 05:41:37PM +0300, Dan Carpenter wrote:
> > On Tue, Sep 19, 2023 at 04:56:59PM -0400, Kent Overstreet wrote:
> > > On Fri, Sep 15, 2023 at 03:57:34PM +0300, Dan Carpenter wrote:
> > > > Hello Kent Overstreet,
> > > > 
> > > > The patch 93a640e2570b: "bcachefs: GFP_NOIO -> GFP_NOFS" from May 28,
> > > > 2023 (linux-next), leads to the following Smatch static checker
> > > > warning:
> > > 
> > > So the smatch warnings are pretty hard for me to deal with - it appears
> > > you're testing each individual commit, which is what _I_ normally like
> > > to do, except in this case there's no way I'm applying all the fixes to
> > > individual commits in a 3k commit branch.
> > > 
> > > And, dealing with the back-and-forth of going through emails is also a
> > > bit much, I'm going to need to get smatch integrated into my CI.
> > > 
> > > But...
> > > 
> > > smatch doesn't build on debian.
> > > 
> > > Can we get that fixed?
> > 
> > It should.  I'm using it on Debian.  This should be a complete list of
> > the required packages.  Let me know if that's not complete.
> > 
> > apt-get install gcc make sqlite3 libsqlite3-dev libdbd-sqlite3-perl libssl-dev libtry-tiny-perl
> 
> What of the llvm dependency? I could only get it to build when I
> disabled that, is that dependency important?

No, that doesn't matter.

> 
> It also consistently segfaults on the bcachefs code.

There were some problems parsing bcachefs initially but I pushed the
fixes for that two weeks ago.  Can you give me the filename and your
.config?  Or even better would be to run
smatch_scripts/kchecker --valgrind path/to/file.c and send the stack
trace.

regards,
dan carpenter

