Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48192E3EB;
	Mon,  2 Sep 2024 03:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725249165; cv=none; b=HDuOl6dPsa4gQBP1qB0b0fbjSj5s7lLDSI7d8mKS4g2J9xsx2giJGRBlvFA3T/+MUV8d9C+sLIMARrfJtXLReQQUb7Hc5wL1OSA7uKMIzU6RKTwmPQE5oHVxz604wvW5jOQOF0/97+XOICBpdEwAk4Uvf5/9X2Ms/X6SIvYZxig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725249165; c=relaxed/simple;
	bh=7T9EFXkKwg1R15vNn/8F1+fWeePN8YlaAfwn1Ma0Xgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D5r08wKN6W/OvFQAgCavh1OF1kgCmYGJfhIRV3A1nCmXB7qZuo1R1mXmMaZ3dSJ4RLYDO/ynC2bL4sMSDZsV+QnzWb/U71DKLEv0i0kAbmgrKcg8UdBrmX1WdhzymUSA72zsESSR4qxECYMH7GRfa6eP8OwyU/E0ah+ou0LueLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkZD6Xfq; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkZD6Xfq"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4fcff944d1dso1076555e0c.0;
        Sun, 01 Sep 2024 20:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725249162; x=1725853962; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G2RUnlHbNnTjl8NCMkpReeIs3Yr6dRgv9k7EM3TjbyY=;
        b=RkZD6XfqbrjClh6CSZKP/QCBGGy7YBIKxZZ8gaEC5cJb8Wir0RBQ4JsWlNltoPJip8
         7fc+GYS4vmfbdLwAa8z/i2wxO381jOcBM+OnFETpPOw3fiM1vBXOLtbWuAbcll26535F
         uM6ybQZ+9qZGiBnd1gpOxE3Hwmqump7stWHSgH4Fc+Dv3TSc1Q5yVoJfiVZRrK9gnc60
         XbJjgjQdvkbRGZu3rhJDi5JkeNRHrqUww4y+4LYSEjNR3cnp1SX3bYG2DyZNhJCAcbrr
         hmZ92zPyGEa3rUAdwzu+QEsuTQfkiydom0jbMY5txhAh73TLekQoTF7J6T37Ac1Fsn/I
         hUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725249162; x=1725853962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2RUnlHbNnTjl8NCMkpReeIs3Yr6dRgv9k7EM3TjbyY=;
        b=WHI20wXLfx/J+FgIBpOXMaqHFQgj+cZ1HmKX5Bff6KIgkDrIdzAREQIFXQaZNZ7s6B
         ZyF8T9xR0gdgAN+VQp8Z16KSIcoADtre1bfu80E3Cz/+I2+wHkRTLUYAlj8vBSfOhwBv
         pPt6Dq4gn/hm7WiphYA9QwEtWroQmlu9X7uiRHUTHALUxrKJ9SYEPG78VC1WNFUF8H9C
         7Ba3SNuUz6sbHApKAQqh2uVM1r9BDQKLboT1FnG8oR7h+HOI1pnvPFx9VoDg91WnWGfp
         fCLCnsq2v3xK8x1wCTNwsGxWE8hlY8XdoWq3HCtirAMfdfuxFPuPn8ZE9PF/VIN6OZpa
         WzDA==
X-Forwarded-Encrypted: i=1; AJvYcCUc6CT9TyRSIc08GMJC2oYC3S+ZahOPAHsEYp2m4Voa7RSz8SSDWOSnk7uM/eIN7WTxC7OgaahZRiwBVmza@vger.kernel.org, AJvYcCUwi28ayDHA847hO4TlY8k9OFCOECiMudA2hzeVrks0BXDL71G9d4MNbss/6XqjcSJKJscgnlc09YKMsA==@vger.kernel.org, AJvYcCWq+FBHVyoP2JJasBTsWeiPETh8249ZDa9zKZOEdsRWuctEeO3Kc+FoUK+kCD8rqfyCYFkwYeabmQPWC17L@vger.kernel.org
X-Gm-Message-State: AOJu0YyxvCDlq6LBdA3PeWgKbC7K07lxdR6BklacJRSYPPbLrXT+wgvL
	6LZewujiFWFWIMlzVBgLWlb7y6BKVtBlwQuRvji48rDeKM8Fjkz33mOcnQD9GdJO5Z/PnHynKM0
	dwqANwicl0FzFuOWO+Xyna2KPCriigMu1I8pDYQ==
X-Google-Smtp-Source: AGHT+IFOFvhlA3yGgyBjxo/ShtFk6zMi99psF4OFBXtaEeqWpyEov+j30W8jdMyOX7uBms2EB08Vk2QgDmkDj87ZfX4=
X-Received: by 2002:a05:6122:1828:b0:4ef:6865:8ffd with SMTP id
 71dfb90a1353d-4fff16970aemr11072932e0c.10.1725249162178; Sun, 01 Sep 2024
 20:52:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHOo4gJxTt2HrnN8s9zM0spSV385R=ykNd8Mp_zvPS8tGP3Nfw@mail.gmail.com>
 <nm2qm77haolpraz3ta3pxh5mv52yfbxe6qzix5j7h3jmq4zljl@4qfjzp3dfadd>
 <CAHOo4gKhwsSpoAYDTwnvt3Wh71hTVf=3xR4rUvDEZui8N53ijg@mail.gmail.com>
 <yqwjxc3jkcjkb65r4lfpg24fmmlelt3oisnc5eh4fex7wtkp5d@bueuka6g54k3>
 <CAHOo4g+Q40RhdzuOOtAOPWtonCEty+4-zZSHqcgpzSCxbeVPjg@mail.gmail.com>
 <pkbhhxz7emkubq4qvawtbjlxjgt5zejvlg4nxsfdzk7xozrfgt@7l7kobl5ejoq>
 <CAHOo4g+BRWHuQu+ekLunyOi0m=j1w9Tsy=mHeMMut68XXU1ORg@mail.gmail.com> <rkwucrtbwkykuivros2gdq2cdwmjri2c2xuglbnpcvnkemwls6@yoe32qbeimjw>
In-Reply-To: <rkwucrtbwkykuivros2gdq2cdwmjri2c2xuglbnpcvnkemwls6@yoe32qbeimjw>
From: Hui Guo <guohui.study@gmail.com>
Date: Mon, 2 Sep 2024 11:52:30 +0800
Message-ID: <CAHOo4gLWFfjrPtuAD1i4+UUY9vDio_55NTk-bpwDmMm65+uk9Q@mail.gmail.com>
Subject: Fwd: general protection fault in bioset_exit
To: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kernel Maintainers,  after discussion with Kent Overstreet, we
think this bug (general protection fault in bioset_exit) may be caused
by crypto module.
The bug information can be viewed in the previous reply email content,
could you please check if the crash is caused by the crypto module or
some other reason?

---------- Forwarded message ---------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A Kent Overstreet <kent.overstreet@linux=
.dev>
Date: 2024=E5=B9=B49=E6=9C=882=E6=97=A5=E5=91=A8=E4=B8=80 11:16
Subject: Re: general protection fault in bioset_exit
To: Hui Guo <guohui.study@gmail.com>


On Mon, Sep 02, 2024 at 11:14:01AM GMT, Hui Guo wrote:
> Thank Kent Overstreet for your quick response=EF=BC=81
> Can I CC this email to the developers responsible for the crypto
> module? I would like them to get involved and see if they can help
> identify the cause of the crash.

Go for it.

I'd also include the syzbot dashboard, there's a couple crypto ones
there I haven't been able to track down (but I haven't dug that deeply
in to them either): https://syzkaller.appspot.com/upstream/s/bcachefs
