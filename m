Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D184719BA6
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 19:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717787747; cv=none; b=PtuLTPtL5QoNN60YkXGNWDhYIgZ7WFQfGmBG/nDx335PwdjRoCD7vY6bLiJHLKNW2O3Z8wPCuACXZVafrSi0bMuz7K37MWEjmO/spcruQ3Q+ArPcAYFsMi6w+Tq2VSuXMTNxNBbhDEMEqDlFfuXfTbVcESjpyhwR1OZoN3Q1aNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717787747; c=relaxed/simple;
	bh=MrSlp7UrmvMkJ4FFJbI0BFuWW0C6RDp2sYMYisMBBeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RL96qVbYsyaFXlVOQbe2+i9qMIM0BZbPu45RmDjN9P2E5GoJGmBiqG2Ptdav029DTCyoz/aM6cT75G6h9BogkBdw4q4oKT3tHirOv/yabIPSa0y0KG+8r8cOYnkZB0MIM12PEDTbbmxXcG6XfjbJRhQKOwC78V7Rb08+nf5jX8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXRCAnDk; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXRCAnDk"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a6265d48ec3so302775466b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 12:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717787744; x=1718392544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrSlp7UrmvMkJ4FFJbI0BFuWW0C6RDp2sYMYisMBBeY=;
        b=GXRCAnDkw9uHJzHjltLDqSZj/NlMudyAAOaBGTTSa06CmXAaXyn2ANyDPgpRMAuXrO
         NuAAtJ00Cs8WnPgFcbDD3xcoAlNMyNV2rD1s7v/97YkNkQzcZ7mnl66CeuusuAp9hhjG
         Xa8H/V/Xwk0MwZjnrBwWyP3XrSZzDbxNh0s6Wq0efz9a0eMzeOCXDL6x6kDyV7pG/wAa
         Ak1W4oSCs0S68dPypZJJiltOOOZED7Ltd91ws8rofPC0IVKOEIbB9RVm65GmghNhuTQW
         tf9d06aMyAX0Ua50WFk7wuOo1fE+r8YbYikSPctGvjkIYTMMVwtkNkoCg71IKkgHfUr7
         qBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717787744; x=1718392544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrSlp7UrmvMkJ4FFJbI0BFuWW0C6RDp2sYMYisMBBeY=;
        b=ai6/NQrxtn2psVzisa0oMhRfSustwgKnDWaNtAYMSHs3Ws0w+iV3kX9fkqnUu8pk4k
         /5DzXuUfsqKzQ3Zq++xgra5JMi1SR7vVT6e/LjjSMFAGq79glx69aynxqSg9DPHTfTDa
         1wEf4wPYoW4a+8qgH8s7pHn8LwLOGOSgEy0bupHR8u+QiH7OcStEKu1l3fUX0LllmOpZ
         At0+x5Fd/Ho29pOdCUp8s22IWVncARTc7SoN92YkbfJsL7i5KTSZGCwFoYnxnKaU+EsZ
         nkfwaEeaZaYlUwL5oYkOlG4f4FPAWJKdlhGh72KjQ0LX9YGoNavsbhpZbF3Q307uzpc7
         dU3w==
X-Gm-Message-State: AOJu0YzQJzTPyKqkKakzWXHY7fPRLNe2fBZg6HWmhTo8Y93DLRHkrEwX
	dXxGdvQsh8cZ0R13RO87bBOEPWHXlfbokcEiW1iaFgj9Vm2XjjV1Czzbr/PqWt+6HSwzCkHxmRJ
	ND2dv5+GzmcUYLaVtpskvEWlid7o=
X-Google-Smtp-Source: AGHT+IERUEXt+ODk/XkV9CZllWN0uoIN5u8WsJaZ4YQ15fpJY5NUnWJF6rW3+qe5sAXizBmQD638S3J/GigHQdeoKp0=
X-Received: by 2002:a17:906:25d4:b0:a69:20df:bb9f with SMTP id
 a640c23a62f3a-a6cd7a89d4bmr240723466b.44.1717787744135; Fri, 07 Jun 2024
 12:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <CAGudoHHwAC5adU6p6yM_mwrwGzDDQLn8ES985X08kY==+juAFg@mail.gmail.com>
 <CAGudoHEcZtQ6w7vECoV3Jk+oWA_ejHdtbN2VpmR0qPPN+9-X5Q@mail.gmail.com> <3pfkkl4ig6jzdfh7bu5y3hb7jbhzlumtzrk4syi5kunmr5vjov@7jtnnr35dlh5>
In-Reply-To: <3pfkkl4ig6jzdfh7bu5y3hb7jbhzlumtzrk4syi5kunmr5vjov@7jtnnr35dlh5>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 21:15:31 +0200
Message-ID: <CAGudoHFHp_XP_WrABv7pO6BuhJCkKo7BwHiAwJ53QAg_NMMSPg@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 8:43=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 07, 2024 at 08:28:07PM +0200, Mateusz Guzik wrote:
> > Well I did a quick skim through, it's probably a no-go:
> > 1. uses bit locks which i'm told would be problematic vs lockdep and
> > rt kernels (see the original patchset by Dave Chinner, linked in my
> > fsdevel post)
>
> The bit spinlocks are confined to the rhashtable code; they're fine.
>

That's indeed fine then, the worry was about bitlock -> spinlock ordering.

> > 2. insertions can fail with ENOMEM? for this particular usage that is
> > very iffy to me, but i don't have a voting power in linux vfs
>
> Inode allocation can fail with -ENOMEM, so that's also fine.

Of course it can fail. I'm saying the fewer failure points for inode
handling the better.

But this is between you and vfs overlords.

--=20
Mateusz Guzik <mjguzik gmail.com>
