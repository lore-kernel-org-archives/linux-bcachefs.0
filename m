Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0823D8
	for <linux-bcachefs@vger.kernel.org>; Sun, 31 Dec 2023 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=quora.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quora.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="mIwyD0GL"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5553f251e3cso2961105a12.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 31 Dec 2023 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1704016464; x=1704621264; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UMSYvbQU54i14Wl8nNwYDolPzMJV8XGJUyQsZje4uBY=;
        b=mIwyD0GLQQqdipZ3TUrib+Vdws8pi5kjz6dCN7TL5DIAENfuf8IjWPSeQrZxgDpIdh
         TKa6j9rmb0g+i28o+HG8tQC07e4cwU+RXVdbQQ1D/x+VIizAAZwd8ev1P/tqnNddynCI
         oDKK5CluVseZ5Ek7lMZrJ18DScZNSlBySFvA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704016464; x=1704621264;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UMSYvbQU54i14Wl8nNwYDolPzMJV8XGJUyQsZje4uBY=;
        b=EQ1Ul7qRZcqVw//KunFbcfHH91nw3R5BqFDleZGNEEiOpb5KzwjfK8DiCvOagxpfIp
         0u8IcN+d09M9KyTxa/HEJWu6aXS56m43y1ceQ/NMgrtgnmLLQzvFjO2sofJRkr/RqFUK
         /jUlRrY7q74IyhEMhGLem870acJZtuPay+qC5thafZNJXppcegw1EJDCkl/3L0WCvkky
         c43S32TcjgLQkc+Aa9AGZ/Bb57Om5A+vqfgmbtBHKDgnA9esiIjxkMnzSfaceT2+jxRD
         yYA4oUD/qMDb6j41WZn39t8s21Y+MbQQzGspXM6/+rJYYYdEG0cdHC1FACbopevzPIrE
         Ckgw==
X-Gm-Message-State: AOJu0YxfQEVYaRwba7ehlVhWPFhsDId2/YdpK6pMawkP3hjAVyTskFp0
	cCFNuvPV8I0g9H2Nw0UB400G8GTF6RITdJGBCZ1Cizm1MMmM/+IzVML33Q2oZOE=
X-Google-Smtp-Source: AGHT+IGguVoLqG7zV7/NKjRUlfprYZvwSNt3u5/ArIaKl+XloJV19T36AckPR4r0EbobPLiRtrpZ9JopO5oPdj8AcQM=
X-Received: by 2002:a17:906:b0d8:b0:9fe:81a:c258 with SMTP id
 bk24-20020a170906b0d800b009fe081ac258mr8091222ejb.26.1704016463805; Sun, 31
 Dec 2023 01:54:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMVG2su=Kt5mkyEHGh5D4YH+1xTUFX3BhOjf-D0bcRTntav3ng@mail.gmail.com>
 <2g6gw7ybne5d5u2ewsbfpsoxslw5vie3d6whlhrcmbombkyzqs@dd6tr3se6fu7>
In-Reply-To: <2g6gw7ybne5d5u2ewsbfpsoxslw5vie3d6whlhrcmbombkyzqs@dd6tr3se6fu7>
From: Daniel J Blueman <daniel@quora.org>
Date: Sun, 31 Dec 2023 17:54:12 +0800
Message-ID: <CAMVG2sueLr7Sy58iaZqbnvvj2POtQNRiaQRNh2TjPw3gw3ei1Q@mail.gmail.com>
Subject: Re: Stack corruption in bch2_nocow_write
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, 
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 31 Dec 2023 at 06:41, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Fri, Dec 29, 2023 at 07:43:13PM +0800, Daniel J Blueman wrote:
> > Hi Kent et al,
> >
> > On Linux 6.7-rc7 from bcachefs master SHA f3608cbdfd built with UBSAN
> > [1], with a crafted workload [2] I'm able to trigger stack corruption
> > in bch2_nocow_write [3].
> >
> > Let me know if you can't reproduce it and I'll check reproducibility
> > on another platform, and let me know for any patch testing.
>
> Can you give the bcachefs-testing branch a try?

Good fixes! I can't reproduce the issue on SHA 67503f8d4 in
bcachefs.git/bcachefs-testing, and no warnings are triggered with
CONFIG_PROVE_LOCKING.

Tested-by: Daniel J Blueman <daniel@quora.org>

Thanks,
  Dan
-- 
Daniel J Blueman
