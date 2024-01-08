Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1567481
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 03:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/+5OwG/"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bc32b0fdadso56019439f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 07 Jan 2024 19:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704683406; x=1705288206; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0l9zdIiwDA3TpTrD5ezW7eX5BrFM1L+KK7soO4V7IM=;
        b=Y/+5OwG/hmtpD1NN54eoYIr60Ldz76gXXTIIc1IHg0t2Qxe4V564W+T9fPloG1BsG0
         AhsrgK0TaSAKqadbF/GYj6fD6VeXR66lbYCntsBNfNkrIborVkUYPknM6hwrCuN8HcvX
         F5yypMeaaxYzPFHNZr5UdTgJlFrJPWknPwWXeomACdbGwMmqidAIvqs4272MAlIbw8Ws
         9g95smEmuyqd36L2iAA7UnNyR7vS5CG/fdx01V/ORu1ReJtFXltJmladi7bFmaxSuukH
         mdsaUwo+YU8DSNLhqZFMMnSxSPAFv58lQictpdcfj0adIbfw6X4v5JjkyAMyN2jqZMw7
         jx4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704683406; x=1705288206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0l9zdIiwDA3TpTrD5ezW7eX5BrFM1L+KK7soO4V7IM=;
        b=LkACa50Bvkq2vRwf7Zei1fvOWvn0q+XwqUF/f42fxKr8v5vp+COguRfEXj13xxpm1/
         S4ksARsJ/Gk64D2S3VzI+gowCVQFmbrNiUJ+JExdTqR+Yp04Fe67a7KfMb3lITZW0cWu
         Y/Gbr+HfZFLbsEFmaO1s58vU2o9CSUcScIRbkdOiaD+d4jZnkooLMJ4n6AzjwyI42j6f
         DmPVxsNVKfgyR4gUjPkxSsP5CbinwSGsETNw/2mD2Ixx3AMsAY/+/qRsRoNB8HICG1oo
         0R2FWSszWVFGOQb64xlGTfa4E2Fr3qHwMQtX8J+erekN3bpKGADv/MWAgM/x0W1p1qZe
         fnmQ==
X-Gm-Message-State: AOJu0YwkLNCR8XJT+R6Y9wPMBFKfB/cplfIhZLyKIp2dIKbmiWg14FvU
	rE9IPbDjjHukXzrj65meGbM=
X-Google-Smtp-Source: AGHT+IHD07HVSOV2FPY5HH11vw8GEsmrTdMbQP5eLujAHlTywXLbEu8epAbCYhw1bb7aiCgZN1X4xw==
X-Received: by 2002:a05:6602:147:b0:7b7:fe7d:7b with SMTP id v7-20020a056602014700b007b7fe7d007bmr2661407iot.33.1704683406516;
        Sun, 07 Jan 2024 19:10:06 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id i13-20020a05663815cd00b0046e255b3cf8sm368194jat.115.2024.01.07.19.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 19:10:06 -0800 (PST)
Date: Sun, 7 Jan 2024 20:10:03 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] create common entry point for Rust commands
Message-ID: <20240108031003.GB120162@fedora-laptop>
References: <20240108013633.119160-1-tahbertschinger@gmail.com>
 <haijgauamlu7pn2rrvjtk4hpskxxjjezrdzo5wtuvre3aihm4i@ncqgo4t2rilc>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <haijgauamlu7pn2rrvjtk4hpskxxjjezrdzo5wtuvre3aihm4i@ncqgo4t2rilc>

On Sun, Jan 07, 2024 at 09:37:53PM -0500, Kent Overstreet wrote:
> Applying this
> 
> If you feel like going the extra mile, maybe we could convert the top
> level main() to Rust, that'd further improve our helptext...

I thought about that, I wasn't sure if it made sense to do it now or wait
until more stuff is done on the Rust side. Are there plans to move all
the commands over to Rust at some point?

I'd be willing to give this a shot and send a patch if it'd be useful.

Is it important to keep a C top level main() around for compiling
without Rust, BCACHEFS_NO_RUST defined? Or is Rust considered a hard
requirement at this point?
