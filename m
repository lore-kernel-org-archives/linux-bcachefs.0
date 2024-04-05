Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4616EC0B
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Apr 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712334057; cv=none; b=nE9Mz5mN6Jk4IBFcJi13KZaK4cqbucj3HGNZA9WRfZ/xwdZexn1w+h75pIdtasEHH2jUvBusp8kGGlHKP1rctKmtV9Ulf+JhJhl7A6bL4K2koRalUdiWGYMKkO/59OhnkY4JMlQkZjzsV7XFkwwizc2d1hsY3QGQvY39I6vEYnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712334057; c=relaxed/simple;
	bh=/Rsbj8LxP1g2WtSvrzy0UFYcze0LmoWNHJd2iDKONHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BcXCM+WOpymfIgnDIJEmEV88rw1T0vuamCq9s2taEiD/yUboO9k5ze4ODettv3/Je/3u8H4Rba38OCFp8xyrElGNnUZf5x/d71IJqfz229SBdqKnU7TMU07qt77tWWsAsXehhIkB75XmmNUeCRvH0zGwHVHW8+MkFS/vNs22pHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dbF2KShc; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dbF2KShc"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e062f3a47bso160905ad.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Apr 2024 09:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712334055; x=1712938855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Rsbj8LxP1g2WtSvrzy0UFYcze0LmoWNHJd2iDKONHw=;
        b=dbF2KShcAMtvfOGkZ1FF3UHGIu8xs6Jf2GwxFWJoOzL6ifQXrgRHpfOdPNMY2kAPE9
         KpwdiPeV9zq1jGBsbhlKRqMVJYnN+CtzgHvT3aWsbRKbcfAIY3E9WwnGYNOJdVKCGgml
         pOqoe5k+/OJ6oNO6IrV9UOnDaYfeEpheZrMBStUMTvIILEoLzFb9muMQQkQU84pZ3GtU
         AfJLOTNhjQ0WOWQJr6AmYaDewTtEf6Y1yZpZtho+Gj0Gh2cYNYEbAGz3/f2zrk5FscI5
         RvZ89iThH9YFdH/+0ZjomW72z9Ckuow1+8Mle5xioQ63qaD+KWJb2D0mIP4V52cOPbFU
         Fvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712334055; x=1712938855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Rsbj8LxP1g2WtSvrzy0UFYcze0LmoWNHJd2iDKONHw=;
        b=QkWqdLFByHJYUeu57teHItOzHa09UASc5KxfwAT494f5p/fzrs2X/oWgpZiVsMK/Gp
         M0wVK5go1CzI8fx3OjtWIbAsxTiGwnJF9XfGaq/DoAuSGtVRmIFEYI6npnJ0XwTDVEgQ
         yTNvioKfDshpF/L3kIdODfmis702Wqwy+j0W94YFAtqZxoy0MkMjxTefQjPWrb6NThMT
         0QGKoYJLyFpcTyXGPvRIVXY7utrr0FxLIAERXob7phykzM4oMpLgY+MCK4rsOwov6lDR
         YBJlc6Ugc8crowhJt/Vwt5HkMhDK2DOatKNTR4ziMNIGoKekkoourr4IL0Pn9ofoQbV3
         aeFA==
X-Forwarded-Encrypted: i=1; AJvYcCVy5HLI8yQV7E1rVBncfLEPEssdCrymxWGmXB5V95m/5GYb4TouuD4tE3Xhm0rQ2BtCdkaMFm/osMtJiZJyyCCeZ4DUDK978Kezz3mcxI0=
X-Gm-Message-State: AOJu0Yz+JNvY95mxxJ6Z+Nk46pnJFMlT95VSb4jiZNQScwZZNcg7wEEq
	l/akpIlo+OodPYx3DwQXzuS4oHurHXw19jt3Tl/KEenmUtHRgC2t2cFlEI/siHk6LBwmVSrdBSK
	w+tveNu6xof61W0CkLi4Pix/AzCta/MprL5Hb
X-Google-Smtp-Source: AGHT+IHO0eYohAt+IJavyNTlU3rwUIO3xgxI8Lhpos0DArMBVnuSy3AswyhW/2DQqEDqwSKjYoexUYDZjnRNGDE1CFs=
X-Received: by 2002:a17:903:5c5:b0:1e2:3991:9e9 with SMTP id
 kf5-20020a17090305c500b001e2399109e9mr422234plb.0.1712334054663; Fri, 05 Apr
 2024 09:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com> <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
In-Reply-To: <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 5 Apr 2024 18:20:41 +0200
Message-ID: <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
Subject: Re: syzbot for bcachefs?
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 1:16=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Thu, Apr 04, 2024 at 10:33:07AM +0200, Dmitry Vyukov wrote:
> > On Thu, 4 Apr 2024 at 01:59, Kent Overstreet <kent.overstreet@linux.dev=
> wrote:
> > >
> > > Hi - what would it take to get syzbot going for bcachefs?
> >
> > Hi Kent,
> >
> > There are 2 parts:
> >
> > The easy one: we need to enable it in syzbot configs. Should we
> > configure it as follows?
> >
> > CONFIG_BCACHEFS_FS=3Dy
> > CONFIG_BCACHEFS_QUOTA=3Dy
> > CONFIG_BCACHEFS_ERASURE_CODING=3Dy
> > CONFIG_BCACHEFS_POSIX_ACL=3Dy
> > CONFIG_BCACHEFS_DEBUG=3Dy
> > # CONFIG_BCACHEFS_TESTS is not set
> > # CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
> > # CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
> > CONFIG_BCACHEFS_SIX_OPTIMISTIC_SPIN=3Dy
> >
> > In particular, I am interested in CONFIG_BCACHEFS_DEBUG. Does it
> > really add more debug checks rather than lots of console printing w/o
> > checks? Some "DEBUG" kernel configs are misleading here. Checks will
> > be useful on syzbot, lots of printing not so much.

For the record: I've just sent
https://github.com/google/syzkaller/pull/4647 with syzbot config
updates.

>
> CONFIG_BCACHEFS_DEBUG adds piles of assertions and no extra console
> printing :)
>
> > Second part: syzbot will need to exercise the fs in some useful way.
> > Is it just a "normal" fs with files, or something special?
>
> It's a normal - but multi device - filesystem, similar featureset to
> btrfs.
>
> > Is it mounted from an image, or an image-less fs? If it needs images,
> > how can they be created?
>
> apt install bcachefs-tools
> mkfs.bcachefs <dev>
> mount <dev> /mnt
>
> ...
>
> > "find tools/testing/ Documentation/ -name "*bcachefs*"" does not give
> > me anything useful.
>
> https://bcachefs.org/ has some docs, and the tools have a man page
>
> Anything else you'd be interested in? Thomas was interested in working
> on on-disk-image error injection, is that something that would be
> useful?
>
> Ariel's also probably going to be working on adding full image creation
> to mkfs, i.e. pass it a directory - is that something that would be
> useful as well?
>
