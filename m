Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0971650263
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 19:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717789890; cv=none; b=T/y+pp4DUx+LNBEtpOr26G+1dpqXtQVuMNAtl6A/JlFt1SK6bYjnRy1IxInUMIJp2UEGFFmxDePfk4rhIs+yUQLZ17kVGWx98RyBxjwHsETV5CUFX7etSuCNWRC0e9sWXEohtsU5Tfud9NC7l9vegXr2Pp6RWVzXCZD1yd9fFCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717789890; c=relaxed/simple;
	bh=Ap/rRm6o4hIpOgRimkewMQ9tFw1y8o6xE4rO767AqLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JMZTRaCv66xBp8ENVIK7BtCNGOAVbs0u1x38M/yjc3sWQV8i1Hi+j9OSeLPr38yzTMsaSer4nj7rGsQBgOC5V8xI93D1VbOAzPE3bECBAdBci4CRjINe5rr1QOb9BJar46C7HOJvE7But2R5Wc17S26N5mn1A2EV8AKrzcayZvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3FtF9ej; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3FtF9ej"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a6265d48ec3so305486366b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 12:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717789887; x=1718394687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ap/rRm6o4hIpOgRimkewMQ9tFw1y8o6xE4rO767AqLE=;
        b=S3FtF9ej2fmXAzHRF4MZb0yfp4T1YBqUKoyHVkzQeC2vHrhXAxr5aV3nQsE6RVr6vs
         kuDMm15TvSBAgNm8dNg3E7YpQet8k77C/uMR4QMt+mjOiGli6Xtbh8mjVStv5Hj2ts2e
         adWkkStFTfbYTajroeXcHFXIBXuazlTbkz+QxmlzBpr2u9YXAXW+Qk0d7ji8we6eV2Mq
         VKKCbBYbC9IXp3PI3aRhUZBoUy6BRbDuu1IwYR3a1KrnXJKvyxRULoECWFrqAhgVa2dF
         qr9iaFY5hAKrXmjdT7oH0RZMF5yP9y0SYy8AV6FVuEnRUfbMMS5vhV5x/8Kpd7foeKNj
         i6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717789887; x=1718394687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ap/rRm6o4hIpOgRimkewMQ9tFw1y8o6xE4rO767AqLE=;
        b=J6WDh2zhsp7FwmOkIgCvU+G0/iCALkEE+enewIVbPG/RdbhdmUjJw4nhRAZIwLQ71e
         riVW8fui2BUdERzgvYRJNbZVZAQ/0fMl7nFfiCMkJlOQMoJ8psg3rnxuw5Ra07Nz9/Fn
         hB2djqWk8+Stbdh4q4eX1hqnJbriPIkTiwBEPy22pgf1qckOXNly5zkbwXimnTuSf3S4
         iRL/XKobndcmFPOCj4qnM3rZdihAe3xXxlqFEU3WmE1sEbZ75bTiElCxdskaJs9Kk5x/
         7FdMPVei3C4CI6CGlFTZAKNv86PHR2I8RB9I5GZyOrSibOgq5tkZ0/Yjiz9BpKIGSpR4
         /qXQ==
X-Gm-Message-State: AOJu0YyHnfqmVucQz6+SUrtLTg5fgFLOOGMI9mQOCymfWeZyW1OvbfFU
	UyggTqHEePPWs7/zjuScY8V4MdMCxG4vg0VO0vaQ3il5Ll7ex1mV8g33/yiIeTqxcI4gYlaErKQ
	8BLEfMKXp6dB/HN2vZyb6shkAymk=
X-Google-Smtp-Source: AGHT+IFForeNP/Cp5AxFdXwEsSPBhKqn1TbP55AC3UWZpeZ5jtXyxdxHSEYidz8bu6KclGgtzZgdZ+kQLiLNTqDwG58=
X-Received: by 2002:a17:906:fa9b:b0:a59:d4f0:cfc3 with SMTP id
 a640c23a62f3a-a6cdacfeefbmr240798166b.59.1717789887192; Fri, 07 Jun 2024
 12:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <CAGudoHHwAC5adU6p6yM_mwrwGzDDQLn8ES985X08kY==+juAFg@mail.gmail.com>
 <CAGudoHEcZtQ6w7vECoV3Jk+oWA_ejHdtbN2VpmR0qPPN+9-X5Q@mail.gmail.com>
 <3pfkkl4ig6jzdfh7bu5y3hb7jbhzlumtzrk4syi5kunmr5vjov@7jtnnr35dlh5>
 <CAGudoHFHp_XP_WrABv7pO6BuhJCkKo7BwHiAwJ53QAg_NMMSPg@mail.gmail.com> <kqvrgt5i4id45a5qoxu4oqinxcmrb5bfl5pqyptj3usmb6c5ma@s2xnp5p6l34j>
In-Reply-To: <kqvrgt5i4id45a5qoxu4oqinxcmrb5bfl5pqyptj3usmb6c5ma@s2xnp5p6l34j>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 21:51:14 +0200
Message-ID: <CAGudoHFqTYFX+-8AvQ5hgZH9sUNY-mAdNNxCc8tt_S-tQQV0QQ@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 9:37=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 07, 2024 at 09:15:31PM +0200, Mateusz Guzik wrote:
> > On Fri, Jun 7, 2024 at 8:43=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, Jun 07, 2024 at 08:28:07PM +0200, Mateusz Guzik wrote:
> > > > Well I did a quick skim through, it's probably a no-go:
> > > > 1. uses bit locks which i'm told would be problematic vs lockdep an=
d
> > > > rt kernels (see the original patchset by Dave Chinner, linked in my
> > > > fsdevel post)
> > >
> > > The bit spinlocks are confined to the rhashtable code; they're fine.
> > >
> >
> > That's indeed fine then, the worry was about bitlock -> spinlock orderi=
ng.
> >
> > > > 2. insertions can fail with ENOMEM? for this particular usage that =
is
> > > > very iffy to me, but i don't have a voting power in linux vfs
> > >
> > > Inode allocation can fail with -ENOMEM, so that's also fine.
> >
> > Of course it can fail. I'm saying the fewer failure points for inode
> > handling the better.
> >
> > But this is between you and vfs overlords.
>
> Do you want to just do yet another bandaid, or a proper fix with a real
> data structure?
>
> Fixed size inode hash is a problem, and we need to stop hand rolling
> data structures. That's why I'm telling you I'm not in favor of your
> current approach.

As I stated in my patch posting the current state is bad (not only
contention, but also sizing and hashing algo), but I don't have time
nor serious interest in reworking the entire thing. I also noted a
patchset sorting things out, posted few times, and stalled. Given that
nobody picked it up or wrote alternatives I figured the issue is not
getting attention.

I proposed a small change which damage-controls the problem and which
is easy to review, hopefully not running into any roadblocks as a
result.

Should someone write a non-hack with a here-to-stay solution I would
not mind whatsoever. Whether that solution is rhashtable I don't know.
I guess most of the difficulty here is getting the change in.

If decided to hack up rhashtable it would most likely land in limbo
just like the hash-bl patchset, I have negative interest in putting
time into something like that. The ez change posted is has the best
shot imo at getting something done for the time being. You being an
established contributor may have better luck.
--=20
Mateusz Guzik <mjguzik gmail.com>
