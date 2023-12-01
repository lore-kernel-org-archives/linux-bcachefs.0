Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="k74UPw0g"
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8EA171A
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Dec 2023 10:45:58 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-50bd4fcbde1so2282507e87.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 01 Dec 2023 10:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1701456357; x=1702061157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ehPF3PQOoozfZlnimBntfStR9Uo37yTTJuQcGJqsFug=;
        b=k74UPw0gvygvuodz9qrWcR7HUx0dBMN4mF149dah9Uxyi9VWLTZ60NyEPAEAs/R4ub
         5P9zzkzUxJPVEhx6wPJ2w4wKVJZZoCSTZf2NyddD/4zcsrulrVz4HmcKQbpAnA6Jxq9F
         B0mFDhbNST8NJrTmf+X4W53+RWTFFSVCJiRf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701456357; x=1702061157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ehPF3PQOoozfZlnimBntfStR9Uo37yTTJuQcGJqsFug=;
        b=KjienWKcR1MGptMxTLdL6+BD4CBzdPMBon9Q5nHSwntOVMpx/pebv4JUISYhx3D7RO
         Py6kjCA2TbmDArwM/Ud543YVSiAVzS1fuzjovv9GRF6KatVtpXz+VN3FawKVLFdKwPoR
         MAX4PQeYSdntSl0sohPBMSZm59CI6P6UP0i4ip1UJ2X+3FAc7JqAjsyw7Fe7G2CcEJ0+
         b79eMpoKbdjqoF/0NHAi4DYebr9d/GC8LjqxEwNP7Uo3Mw4cfx6rpRbq8maDRsGGEaV6
         d/8bcq3iwmBrF4wbJtxuQ66VfGfqsWAEJQvbW8ULiV8RS47odowHds1BRROT9RHRzckn
         cPgw==
X-Gm-Message-State: AOJu0Yz78SuHkXcqppo6R5gLyZR0P3vfkjPvm/ehfNFEfzq4B8EyIaHx
	0yAMxmqhujoyWMa7xeCBJTIVqsobrmlstd/xMzx7GlnW96pKvMScB5o=
X-Google-Smtp-Source: AGHT+IE8xiDq7cDppayGfqhkRD9LEy43hC3BSAYf6c5fbstKSddOuXMTu49xOCFaaxIyVwQF4T/pnR9h142dF8etd88=
X-Received: by 2002:a2e:9e8a:0:b0:2c9:c1f8:fa29 with SMTP id
 f10-20020a2e9e8a000000b002c9c1f8fa29mr873997ljk.33.1701456356945; Fri, 01 Dec
 2023 10:45:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMVG2stxMYZbDoAHeVQjgJ7f+Td7+VJrLNRbY8au68ZVkzhb0g@mail.gmail.com>
 <20231201032548.5y3lafkwamlhruqs@moria.home.lan> <20231201052701.jrxwpjte4htzn6wo@moria.home.lan>
In-Reply-To: <20231201052701.jrxwpjte4htzn6wo@moria.home.lan>
From: Daniel J Blueman <daniel@quora.org>
Date: Fri, 1 Dec 2023 13:45:45 -0500
Message-ID: <CAMVG2ssNi_otD9tjobdCVFn6RivojzvKGqS7b6k+aPrvk-7JQA@mail.gmail.com>
Subject: Re: bcachefs page fault oops after device evacuate/remove and unmount
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, 
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Dec 2023 at 00:27, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Thu, Nov 30, 2023 at 10:25:48PM -0500, Kent Overstreet wrote:
> > On Thu, Nov 30, 2023 at 08:47:33PM -0500, Daniel J Blueman wrote:
> > > Hi Kent et al,
> > >
> > > On upstream bcachefs (master @ evilpiepirate.org/git/bcachefs.git) SHA
> > > f8a1ba26, I was able to develop a minimal reproducer [1] for a page
> > > not present oops I can provoke [2]. It appears we need further
> > > synchronisation during unmount.
> > >
> > > Let me know when there is a patch I can test, or for debug.
> > >
> > > Thanks,
> > >   Dan
> > >
> > > -- [1]
> > >
> > > modprobe brd rd_size=536870912 rd_nr=2
> > > bcachefs format -f /dev/ram0 /dev/ram1
> > > mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> > > fio --group_reporting --ioengine=io_uring --directory=/mnt --size=16m
> > > --time_based --runtime=60s --iodepth=256 --verify_async=8 --bs=4k-64k
> > > --norandommap --random_distribution=zipf:0.5 --numjobs=16 --rw=randrw
> > > --name=A --direct=1 --name=B --direct=0 >/dev/null &
> > > bcachefs device evacuate /dev/ram0
> > > bcachefs device remove --force --force-metadata /dev/ram1
> > > bcachefs device remove --force --force-metadata /dev/ram1
> > > kill %1
> > > wait
> > > umount /mnt
> >
> > The remove fails for me with DEVICE_SET_STATE_NOT_ALLOWED - evacuate set
> > ram0 to ro, we can't remove our last rw dev.
>
> Got it to repro, just had to ignore those errors - there's now a ktest
> test for it, and the fix is in master :)

Fine work Kent! The fix is good from further testing here.

Tested-by: Daniel J Blueman <daniel@quora.org>

Thanks again,
  Dan
--
Daniel J Blueman
