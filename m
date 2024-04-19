Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CC94C8A
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 08:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515742; cv=none; b=hU8ORaUQLfbutCN1NFGwI37Tlzvg7clvbSMA1fXKjMTdpFoRKWRx69bmBC42BhthvUT+d4CsNfAdNr7e8qMEcJfOWnGXJFg5Fi4iki/gb33OKBGzcNSa3jYvQ7jihCR1SRiLBdxBAvqlTtECSsbXhjR/JZPIIAxuX0EbRhE+E74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515742; c=relaxed/simple;
	bh=jwTP9di+gHYQLhb3wSyH/zZps3BSu1afU28CygVkNa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UQrNo34TLZC8KUysDTD9Zkq8APOnAEh/7GtBiBYJUpDaEcc2AWFR9lOOEg9j4T9lSC9/CLaJg61bDLeQCVJqRNr9xHiZ+7iABettZORolmqKHqJGeyorj6M7NNRWVx/gO8J44LN2uEdFWtbdnkfmm0G5K+2RLg5mVlUtRQ5gCjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uL2jwuJv; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uL2jwuJv"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-571b5fba660so7508a12.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 01:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713515739; x=1714120539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwTP9di+gHYQLhb3wSyH/zZps3BSu1afU28CygVkNa0=;
        b=uL2jwuJvEKYrrRp7dcoQp6DENqfgIpWHU+G9p6uUgOV4+mDcG4doW6ayENy+yV9u+x
         M1TOyQRNWOdO0vl1vg7LK4qbvP56V7Gsxs5wUaAtqaXGgC1hj1UNBC6yOTpd2TboEAQM
         MBglx25/1rlaXHX1i1T3u7FHGS3hNpH6Qx6GisOw8wcJIuRO2DSHwnFeo6HigxkEgVvv
         Ig2w1cVUnVsPevcb9xWHaEExxD1PY2l+WEznxp4ax03PsNOkWmL/ItPRLTWoWaBNHarq
         ky+mf7rwHx0pVbYw+4+cGYpDPzwENm1Je29rxoj9TE6y/E+41Y1T4+ktZRToZGYpxGpw
         6V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713515739; x=1714120539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwTP9di+gHYQLhb3wSyH/zZps3BSu1afU28CygVkNa0=;
        b=QhVWyv4PKLew9//mLruCUzHd5RGc6gdNTTP5kWXoFr2Qmpq5Q4r87enaMTOSSTtnsm
         WBBupy5o1dUHu9pbBMlvMUFUgxCEWp/tvlYkp+hERECeiBBEltLcRnZ33IGNIZsaMPfC
         dcgpx2wJbZkzmRFB2L502X2dgQFy7T1HxHPhyhjDFLeMeXDiF3XDNVOEUe9AWgT7ArW7
         CRtfb1FLxCCTGM+jnx1XMMfBilsd3BMsJutg5HAQS30vpl6T+bqyGbarLG75uv/Si4Zb
         DlgdwFe9kpgjQyry5T+Q005KNMWUbEwnczmcEBOQhn2ASOXenrlVtSw0oaW2sWkcCLpq
         AjHA==
X-Forwarded-Encrypted: i=1; AJvYcCVIcRHdx+7fHG1mOLojqaDceffPs2QFYurwtM7xjpdxqWlqm9QmCxegk/Q+FnOb2/5zoGt6hJ4udeaepr2rPjRrQLLp1QEGAqHkY7OaVDo=
X-Gm-Message-State: AOJu0YybIyFelZFV4z8z1Fjz6NDlnZ+6E9JWRNRQ4aMRykC6hRe7xvt4
	IilrgVlwVDpfaqeGeOhaHHXMIleJ3FeB7zLGfd+SsOHYxA2aGgDr7gPyZbqNZB1P2zW8rCIvc1W
	OIYeAnaaBblNkuT6Anv4k2//cqeeHdhK9h57m
X-Google-Smtp-Source: AGHT+IGqF68h9enzzjjZJLarSKc7mCIqZSv1psCJory//Z+kLQXyNBectIhnkDEBS1rwOCdwAx98Yf9KvgrLdUx4qPQ=
X-Received: by 2002:a50:cdca:0:b0:570:5d40:5e35 with SMTP id
 h10-20020a50cdca000000b005705d405e35mr122504edj.6.1713515738560; Fri, 19 Apr
 2024 01:35:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf> <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
In-Reply-To: <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 19 Apr 2024 10:35:27 +0200
Message-ID: <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
Subject: Re: syzbot for bcachefs?
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Apr 2024 at 18:20, Aleksandr Nogikh <nogikh@google.com> wrote:
>
> On Fri, Apr 5, 2024 at 1:16=E2=80=AFAM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Thu, Apr 04, 2024 at 10:33:07AM +0200, Dmitry Vyukov wrote:
> > > On Thu, 4 Apr 2024 at 01:59, Kent Overstreet <kent.overstreet@linux.d=
ev> wrote:
> > > >
> > > > Hi - what would it take to get syzbot going for bcachefs?
> > >
> > > Hi Kent,
> > >
> > > There are 2 parts:
> > >
> > > The easy one: we need to enable it in syzbot configs. Should we
> > > configure it as follows?
> > >
> > > CONFIG_BCACHEFS_FS=3Dy
> > > CONFIG_BCACHEFS_QUOTA=3Dy
> > > CONFIG_BCACHEFS_ERASURE_CODING=3Dy
> > > CONFIG_BCACHEFS_POSIX_ACL=3Dy
> > > CONFIG_BCACHEFS_DEBUG=3Dy
> > > # CONFIG_BCACHEFS_TESTS is not set
> > > # CONFIG_BCACHEFS_LOCK_TIME_STATS is not set
> > > # CONFIG_BCACHEFS_NO_LATENCY_ACCT is not set
> > > CONFIG_BCACHEFS_SIX_OPTIMISTIC_SPIN=3Dy
> > >
> > > In particular, I am interested in CONFIG_BCACHEFS_DEBUG. Does it
> > > really add more debug checks rather than lots of console printing w/o
> > > checks? Some "DEBUG" kernel configs are misleading here. Checks will
> > > be useful on syzbot, lots of printing not so much.
>
> For the record: I've just sent
> https://github.com/google/syzkaller/pull/4647 with syzbot config
> updates.
>
> >
> > CONFIG_BCACHEFS_DEBUG adds piles of assertions and no extra console
> > printing :)
> >
> > > Second part: syzbot will need to exercise the fs in some useful way.
> > > Is it just a "normal" fs with files, or something special?
> >
> > It's a normal - but multi device - filesystem, similar featureset to
> > btrfs.
> >
> > > Is it mounted from an image, or an image-less fs? If it needs images,
> > > how can they be created?
> >
> > apt install bcachefs-tools
> > mkfs.bcachefs <dev>
> > mount <dev> /mnt

We've enabled the configs, but we don't have good image seeds yet.
Aleksandr tried to generate them, he is currently OOO, but maybe you
can help meanwhile.
He said that running:

$ mkfs.bcachefs test.img

gives this error (on a quite big image, I don't know how large exactly it w=
as):

insufficient space for superblocks: start 8 end 4104 > 4096 size 2048

Why could it give such an error and how to avoid it?

Also what would be a good sets of options to generate seed images?
We try to "sample" space of different images to create seeds. To give
you an idea here is what we do for other file systems:
https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03c824d664=
2f6c0b/tools/syz-imagegen/imagegen.go#L60-L516
