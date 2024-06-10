Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B4E18C36
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718045977; cv=none; b=QtoS2jBTeb+sqwwrdLKMGCZN6KQkNtTQq9vbwD8IKXB/5Fvg6/O4K1ezxFpBeAITj1xWUPu7NSAC0LjtbDQjVOvY9PEU3vvuQZzx1etIIpLSFZbbswQ0lSD5/nCgJuruIa4x9cE4T+3UwfYrtVWvUZJ5acMFefIoDwf45U0fdzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718045977; c=relaxed/simple;
	bh=oo04jI2UVkPAWLQkZkcb9aGnFtqRtUnyR6fqahBfkKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZeiYqJ3TEh45vOHQ1Qd7itwTm+I6vy0htB3nhGtcJ/eWg9ln+3kxGGQL5b7WI/zRI6uAM81BjG9UkChwLFod+Rw2yt0kFIP9CfCMXTyNTMj4jzq8LHUKjxdz1RAyHTtPR/HlRIH/2SLl4JFJfwbCHoqB6gdh6mEmdiyXBJ7GbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbStmFsB; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbStmFsB"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57c72d6d5f3so2800152a12.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 11:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718045974; x=1718650774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo04jI2UVkPAWLQkZkcb9aGnFtqRtUnyR6fqahBfkKM=;
        b=AbStmFsB7lo95/K5+/RrtrURRkE7dcjZJt9m+aW8O3ipLoniqkrxLsw6NyEFr0TUZI
         ks5p5Rce8KWS622zh7eurckAqFEH9J3XZMNVgqFEST1BiFWH6Q2DkFP7NH3nXfsp8diQ
         QdHi6dN4bCfzKSrW8zOo77rlP7O5zOU7lsZGxUlG8vhkn6VLvSKetr4l2QJbIMyZBFEu
         mRCDJnolMGORoCP9g8o1Lny1Xsz26vuoVZsYf2LPtw6948/SR+k+1SQrV3XELEmwkDQF
         W9buJdxaEGmpVitmb2Wnqt3gipVOoxlK+p9Sj2AAQtxUig4kUqr8P/UdliZWhBYa1cPL
         bw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718045974; x=1718650774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oo04jI2UVkPAWLQkZkcb9aGnFtqRtUnyR6fqahBfkKM=;
        b=cLy3fXKg/bUfdzZilgzNHrtT4T+Uo/gF4vsso9rGmgdpNW6UoUNlcbEgMBJCwx0ZGf
         odABSrjSpN0+EeD2AbURWLwKUOBjYtglVtS8iyT3dDQHZ2jgVSvzEzafPNzSCXES55zN
         C5peWcuKINgRpHrIHSP9NlNM9QPyQbsjEJ55uFs/UMBH3smGNkENmn1qA6or1viJbmmA
         vQ+V7XVulO1FJB721Bv4vuPU+cdOxJdk2kw/+M9j8YFk/iis3YWsWLPO7F6y7a/vti97
         metp9IP1xG20fcx0UPEBEqC84ZAfFrPDnTniVZ8FlEidYX15gRfBpgespH8EnxKcigD3
         3mWg==
X-Gm-Message-State: AOJu0Yyf8snhKLICScjHo8pgkGE7so55AEj6taNBAf1RDqUVGwb5hGx9
	OdkrAiO8CpM6ECUFssCWLA3QCov6m8fDVnzqOUrRiV8VhkjjFhER7bdqv5A2+AdqLg5H5DVjzCF
	Tg5+T7VOvVIwX9ErenG8q9x0yQc/mGQ==
X-Google-Smtp-Source: AGHT+IHP3QMWhwtgRQIbwgR35iUVOBOGid/M+LB+BY6C4TYrejszG7ak0cSmwpN7F+sOciJa0ebaiSdLPA0EO209wVE=
X-Received: by 2002:a50:8ad3:0:b0:57c:61a2:ed47 with SMTP id
 4fb4d7f45d1cf-57c61a2eee4mr5121956a12.24.1718045973841; Mon, 10 Jun 2024
 11:59:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk>
 <gskaw3ud7aicys3kq3j5nlf66ihcisfrnkwo2wlb5hji5svhvf@vvbuomk2fhmm>
 <CAGudoHFZ76yfxL7v=_KhEY=0RzKrc-AksSAFwL-L+u9TQPVnkQ@mail.gmail.com> <noxotudfocqhmmg6z7j5ifwt55zqpptyx6nl2fmcbrxvz37ftu@r6tevsh2fvlf>
In-Reply-To: <noxotudfocqhmmg6z7j5ifwt55zqpptyx6nl2fmcbrxvz37ftu@r6tevsh2fvlf>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 10 Jun 2024 20:59:21 +0200
Message-ID: <CAGudoHFCe4cRjhZ9OpCZp6qM142tOkviAsi7xPkpXqs9CwOPBQ@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 8:50=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Mon, Jun 10, 2024 at 08:44:37PM +0200, Mateusz Guzik wrote:
> > On Mon, Jun 10, 2024 at 8:13=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Sat, Jun 08, 2024 at 11:24:37AM +0200, Mateusz Guzik wrote:
> > > > On Fri, Jun 07, 2024 at 02:10:05PM -0400, Kent Overstreet wrote:
> > > > > Does the following patch help? I think the hammering on the key c=
ache
> > > > > lock may be correlated with the key cache being mostly empty (and=
 it
> > > > > looks like the shrinker code is behaving badly and trying very ha=
rd to
> > > > > free from a mostly empty cache)
> > > > >
> > > > > [snip the patch]
> > > >
> > > > I see you committed the patch along with some other stuff.
> > > >
> > > > I git pulled to 46eb7b6c7420c2313bde44ab8f74f303b042e754 ("bcachefs=
: add
> > > > might_sleep() annotations for fsck_err()").
> > > >
> > > > For me the problem is still there.
> > > >
> > > > This time around I populated the fs and *rebooted*, then did walktr=
ees
> > > > test in a loop. So the first run has 0 state cached.
> > > >
> > > > It looked like this:
> > > > # while true; do sh walktrees /testfs 20; done
> > > > 3.17s user 605.22s system 1409% cpu 43.150 total
> > > > 2.77s user 887.92s system 693% cpu 2:08.34 total
> > > > 3.05s user 726.20s system 777% cpu 1:33.77 total
> > > > 3.19s user 600.90s system 1476% cpu 40.904 total
> > > > 3.10s user 956.80s system 599% cpu 2:40.19 total
> > > > 3.15s user 575.78s system 1331% cpu 43.464 total
> > > > 3.30s user 865.48s system 1386% cpu 1:02.64 total
> > > > 2.79s user 470.09s system 1404% cpu 33.666 total
> > > > 2.78s user 884.00s system 718% cpu 2:03.36 total
> > > > 2.95s user 568.63s system 1439% cpu 39.714 total
> > > > 3.02s user 964.90s system 729% cpu 2:12.72 total
> > > > 2.95s user 829.68s system 703% cpu 1:58.44 total
> > > > 2.77s user 597.92s system 1486% cpu 40.403 total
> > > >
> > > > So the time varies wildly and there is tons of off cpu time -- with=
 20
> > > > workers eating 100% cpu for the duration it would be 2000%.
> > > >
> > > > I also started seeing splats in dmesg (example at the end of the ma=
il).
> > >
> > > this confirms that the SRCU splats we've been seeing are partly cause=
d
> > > by this, as I suspected
> > >
> > > > That is to say I would suggest you also leave it running in a loop.
> > > > Expected setting is that it approaches complete CPU usage for the p=
eriod
> > > > and takes in the ballpark of 40s (well shorter on your hw, but you =
get
> > > > the idea).
> > >
> > > Yeah, I do see it with more iterations.
> > >
> > > I'm redoing the key cache to get rid of the key cache lock - that sol=
ves
> > > it nicely. If you want to take a look at what I'm working on,
> > >
> > > https://evilpiepirate.org/git/bcachefs.git/log/?h=3Dbcachefs-vfs-inod=
es-rhashtable
> > >
> > > this is unfinished - I'm going to be switching back to the polling sr=
cu
> > > interface (so we can allocate from pending frees), and the patch to
> > > switch vfs inodes to an rhashtable currently breaks writeback - but i=
t's
> > > much faster.
> >
> > So you are not patching up the vfs inode hash with rhashtables, just
> > migrating bcachefs away from it to your own rhashtables variant?
>
> Yeah, doing it for every filesystem will be more involved since the
> lifetime rules of fs/inode.c are tricky - and right now I just want to
> be able to profile without inode hash table lock contention blowing
> everything up.
>
> > I don't blame you, but this also means I'm going to do some touch ups
> > to my patch and send a v2. Was waiting for the bcachefs (and maybe
> > inode hash) situation to resolve itself.
>
> Well, we really should figure out some sort of a plan for fs/inode.c :/

My plan for short term is to get the cheap hack in, it already
provides vast majority of whatever win one can expect to get from any
inode hash rework for next to no price.

As for long term, there is other stuff I intend to do in vfs. Should I
manage to get the stuff in and find this remains unfinished, maybe
i'll do something about it.

Part of the problem is that plain rcu conversion would require
reviewing every iget5_locked and similar consumer out there, to see if
their callback is safe to use with it. Not something I'm signing up
for anytime soon.

Anyhow, you are free to object on fsdevel with a patch of your own. :)

--=20
Mateusz Guzik <mjguzik gmail.com>
