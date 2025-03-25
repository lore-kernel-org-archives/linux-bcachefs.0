Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FD7BA53;
	Tue, 25 Mar 2025 01:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742866398; cv=none; b=g+VO2C13/2/5dOg/hKhpRMoNNugoWXw3DxJlc6pTiSVn4PN/w5DgTHrl2lIQsLkR2kwUli97ylcYyHU/kre4zV8GyGohFykdMucI+zlURQsD/COu/1fYH8OJMZPQmyF3d5BmLGdk4fva9TE7JHI5eqeJ1ifVzVNwtNIxNCc+s28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742866398; c=relaxed/simple;
	bh=dBaOEme30YRUdSk2oIRZi23qL/4FGjEpNPquQLSQKIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JBhRt0eAAPAXvBfxwe5EImJOsTSVqFJy3CKScCwtWRmUah92EBISUil2ZZRhwUMZtVzB9N02RGgFlO0ndB/w6Ht0NP2EEZG3VNr8id2npbAvaDQoEW4o93rJUCqooI9mRAmptreZPW3j+6OiUFrajojDDS1mQm/5/A+ov1Lpkjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1txE17V; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1txE17V"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-524038ba657so4922714e0c.0;
        Mon, 24 Mar 2025 18:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742866395; x=1743471195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBaOEme30YRUdSk2oIRZi23qL/4FGjEpNPquQLSQKIA=;
        b=C1txE17Vtf59xrIhIpHLcrMxE//2bfWOjxw4p4tZ/3xqdqwMsGO6e6oJuykrvOfwVB
         fYH0InX8ec7MMOnfi44649k/vsSXEEuQ4JxsuNQaKp4i0vMNdh71RAsY9BeEAMRbIWfc
         MHxzfcsw5msEJVJbxauwoK739SUE6v9+7661nT1CsEbCVni1X2boTM5JDRpM0v/nKaJj
         RYkPxO/I+kD/OYL2TDGcWmkayxU9vupGK0qczBQJIN/0buWQFQXHfj8yQWnu4asPD9G+
         j0nBqlcx4WzwGaENSk0uGg4ZGhMz0Vo5QKBX53bJ5pUlCV26kOT6lH169RdEnyOxL/dP
         ap4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742866395; x=1743471195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBaOEme30YRUdSk2oIRZi23qL/4FGjEpNPquQLSQKIA=;
        b=HTJdS01cvbA39rfSzOYwGMLeQ4XE1YIpqS6pQTo4hV876Y2oe0qP9iOJ4fMLAHVJmp
         3Rm2PLqEalmhLUNlo771U4PACUx2mTkok0h175Q1bPMYUPiUfkr99ICJd5mp+BBMDdwj
         cFMihd6+Yr9+2f/5l3Rz1mQxP1gMpHqq9fmV99p4wzwuuTD8qnwt0MqXROokPLLIOyvL
         nlydO+Oahq2FsrUyK7N0E4OcHhuFSnrJFZB8ETrkJpNNB5fHTXRAWcG1kexSJfujiGbv
         0doRO9d1slBuZL0ghA25UPmefK/GFrl33wi02ejsU1H+DXnuK0JdiIe6weSk5WiHHzKR
         mIoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8yJIrrKHugpLlxQqqJAmVq8wnGvJIeonPZU0bp/Er08p+HLjrXJcDGYrmEYsHmLzEClSNqfDLVzui1dhoaA==@vger.kernel.org, AJvYcCXC6F8qwXmwHyIfBr4PzNw6WQetVd/Xu8q6+5d6ZeGYAibPhmch/vTNEJ6aK2ITalB+An4gtoYg9i1VOhop@vger.kernel.org, AJvYcCXMJbRzCBiSGgZFfRDp7jXIXovrSCxoBfDI7ddpUNzIxal8SDpMj8CQUGo7wqO0xzX4vUjjwiqXfZJyOelI@vger.kernel.org
X-Gm-Message-State: AOJu0YwN4LTwmZfwk+YF4DqeCRzcQNvIlpGDTdsnfXwNXt4jSm3dfP0k
	p5txb0S5RxNVXCvDQSyzdDSgnxsyhLQXfvGolY3e4mWhQEscNxqZ+AF6v8ape9Bjfu+OupMUYpc
	r6XdqPGwv5xMuWFfz5vycHSI7M2A=
X-Gm-Gg: ASbGnctFeCslk+M23pS+P8rZGlkX0dFokJpH48IooNtHUYzX7gi1sn/i+/0s35sNR4S
	kaSaWW5fYfH1eyZFe7dwg60r8CvEdE+KOuwDFtUPIutQk72TYRdjbZ7kaZTY2ks1cdLlNSLHuzM
	60GUFJH2MeHWJWvhmNvQURyhUh3Oc=
X-Google-Smtp-Source: AGHT+IFcKyGrmwFeZOkZfUk6dgLpT20Raubjmbigh65PTf9Zgys4T3/kl6TOrYJigHLNClVGpmixmCpg85sh5NXU7bA=
X-Received: by 2002:ac5:c9bc:0:b0:523:771e:8b81 with SMTP id
 71dfb90a1353d-52595ec0b28mr10952976e0c.7.1742866394818; Mon, 24 Mar 2025
 18:33:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHOo4gLWAbArwg+w+AqqkxGmOFX6cm8Tvy85tb4igN6V7Z9BZQ@mail.gmail.com>
 <20250324170046.GA19087@google.com> <rs7ocmzcqkwf3ac6spqvign6rov2ecqef3bu2dzeg6y6ryvv7x@4c47km4r5iqb>
In-Reply-To: <rs7ocmzcqkwf3ac6spqvign6rov2ecqef3bu2dzeg6y6ryvv7x@4c47km4r5iqb>
From: Hui Guo <guohui.study@gmail.com>
Date: Tue, 25 Mar 2025 09:33:03 +0800
X-Gm-Features: AQ5f1JpqKL-h73MdjIF1-5BnHK1FjqGccZpWWAyLvdauIRBJVCsC8gDEKSFQXUE
Message-ID: <CAHOo4gKENirYHJ40sU3LBQv9MPic9umz3+g8DcTGzX+LEn7Uog@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in poly1305_update_arch
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-bcachefs@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/mai=
n/586de92313fcab8ed84ac5f78f4d2aae2db92c59/my.config
you can try this config to build the kernel image. I reproduce this
issue in 586de92313fcab8ed84ac5f78f4d2aae2db92c59 (kernel commit) by
the above my.config.

Kent Overstreet <kent.overstreet@linux.dev> =E4=BA=8E2025=E5=B9=B43=E6=9C=
=8825=E6=97=A5=E5=91=A8=E4=BA=8C 02:06=E5=86=99=E9=81=93=EF=BC=9A

>
> On Mon, Mar 24, 2025 at 05:00:46PM +0000, Eric Biggers wrote:
> > This is a bcachefs issue.
> >
> > +linux-bcachefs@vger.kernel.org
> >
> > In the future, when fuzzing a filesystem please direct any bugs found d=
irectly
> > to the mailing list for the corresponding filesystem.
>
> This is also one I've been unable to reproduce, so if anyone knows what
> does it (kernel config opts?) so I can repro it in ktest - please let me
> know
