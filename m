Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD441F947
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718045093; cv=none; b=VsfrYrjluq3mgm18g8wc4aA7PD0p3cGfI7n88xN0rz2HKwng1pLzTRtAexBz2nfQZsIbpUv32POCdWcbKfDuQeCXoPW/xHX2OuO1H3+oL+eYb2anJMsq4WoyS64ToxKOXPB/H+ih+lNt/9ZnCEwXfsvNQyJtPHX9PJDOdYlYt/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718045093; c=relaxed/simple;
	bh=X/9o4/6vjmlkiBb/fKX2bE9rxY3WSyMVDhW6CJKGVuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ICqYtgQbeDE8dGNmITOZoyPum4vvktFjnav0URI4AhHAhEPSWLlitn3yXYXdikLvawWfAkBw1WJiSB2MTKTu/1VteCU+zCgdn4eVKMXpLP41BNlfZnoSvrhoOLAxrMuemn6KKncFY3IPT69EnrPCiRRJRqPHfsZlbCtOc9q65Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S4pSMEFF; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S4pSMEFF"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a6ef8e62935so27836866b.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 11:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718045089; x=1718649889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/9o4/6vjmlkiBb/fKX2bE9rxY3WSyMVDhW6CJKGVuo=;
        b=S4pSMEFFpg1RuF94UxLADFCiGv+3B9VVKGwDTcWA9VDhjWlvTGPTmDquA5IcUKOiOo
         fQJv6ZvlRkjX4cNLKBWaLu/K/evGkFFB80wJ0PfRHgV3kvM2nlNuNjdirOyJB2L+Dafm
         4FsJitu9hu2OXN6CfUWB3b3wULfH6CUPBxr+Jg2xVXaF/qYOBif6U/CRGvtdl8gjAyMv
         bwRuHC/QsNLUdw5Ki+5iaEzhuz1fWLL8YJc3TJa7L7MUZWxb0OGSmRhHFpZRCuzxhPZA
         FF3Ov2aPQJbzNg1ZznqfdZw8EpIYOL5J4sy5gih3lysxMmu9urNgFdXEQYRrxUwt8L3r
         cCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718045089; x=1718649889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/9o4/6vjmlkiBb/fKX2bE9rxY3WSyMVDhW6CJKGVuo=;
        b=tv2VAEYCzVD8F38PrCnI2jXHZKsuhOlMhEVtGTMRXNbcJ5irR3/VRj2Po7eHY9pHeb
         8bCjf+xQxrSIFARaYIjvR3LrCcUaCsvBV0oJfenwnIUv943fiRxkjKHwSdPzBpib+v+D
         HjkKKYl/EKVCqYDuMx75WPupW/Jb4TM5WonANd/P0FlN6GZ4NWv8MDCxGKPxiqsf8S23
         zUPwp25/F/fdR4hhPB8B18PJO/dzpgaNcmN7rtZ9pAmmRMi6HvtNzpG4UV3j3Hvi+N6n
         k3k6KGjMVCnrDKqco+rit7iRDEvGqLYjWbPaghD9EAPK28U18SakMKETjU3kSTyD4m8J
         FI8w==
X-Gm-Message-State: AOJu0Yy3+GOqmzg1wiENW3L/nLWR7TYp+7WiU4wAi0+yozxA4J7b0u4J
	Z2amrjciat9bougfHaoyUqSs9YMpta5DykLwsy+LLkkiuwt/flPr+8p/w+0hC0EOCKi2nqiSf7R
	teExMcljMeqyT6Ul3+IGEgWSFfvXogg==
X-Google-Smtp-Source: AGHT+IGlzW5d7IEw4e10I7svP3fwFDdUEL56wQC4gW+7VOCLGHFQCjIugw+AwJ5d2mPS4txhKmdVZ5PT2+fASRDZY0A=
X-Received: by 2002:a17:907:3ea0:b0:a6f:1b3d:8e0e with SMTP id
 a640c23a62f3a-a6f1b3d9041mr411995566b.25.1718045089194; Mon, 10 Jun 2024
 11:44:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
 <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk> <gskaw3ud7aicys3kq3j5nlf66ihcisfrnkwo2wlb5hji5svhvf@vvbuomk2fhmm>
In-Reply-To: <gskaw3ud7aicys3kq3j5nlf66ihcisfrnkwo2wlb5hji5svhvf@vvbuomk2fhmm>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Mon, 10 Jun 2024 20:44:37 +0200
Message-ID: <CAGudoHFZ76yfxL7v=_KhEY=0RzKrc-AksSAFwL-L+u9TQPVnkQ@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 8:13=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sat, Jun 08, 2024 at 11:24:37AM +0200, Mateusz Guzik wrote:
> > On Fri, Jun 07, 2024 at 02:10:05PM -0400, Kent Overstreet wrote:
> > > Does the following patch help? I think the hammering on the key cache
> > > lock may be correlated with the key cache being mostly empty (and it
> > > looks like the shrinker code is behaving badly and trying very hard t=
o
> > > free from a mostly empty cache)
> > >
> > > [snip the patch]
> >
> > I see you committed the patch along with some other stuff.
> >
> > I git pulled to 46eb7b6c7420c2313bde44ab8f74f303b042e754 ("bcachefs: ad=
d
> > might_sleep() annotations for fsck_err()").
> >
> > For me the problem is still there.
> >
> > This time around I populated the fs and *rebooted*, then did walktrees
> > test in a loop. So the first run has 0 state cached.
> >
> > It looked like this:
> > # while true; do sh walktrees /testfs 20; done
> > 3.17s user 605.22s system 1409% cpu 43.150 total
> > 2.77s user 887.92s system 693% cpu 2:08.34 total
> > 3.05s user 726.20s system 777% cpu 1:33.77 total
> > 3.19s user 600.90s system 1476% cpu 40.904 total
> > 3.10s user 956.80s system 599% cpu 2:40.19 total
> > 3.15s user 575.78s system 1331% cpu 43.464 total
> > 3.30s user 865.48s system 1386% cpu 1:02.64 total
> > 2.79s user 470.09s system 1404% cpu 33.666 total
> > 2.78s user 884.00s system 718% cpu 2:03.36 total
> > 2.95s user 568.63s system 1439% cpu 39.714 total
> > 3.02s user 964.90s system 729% cpu 2:12.72 total
> > 2.95s user 829.68s system 703% cpu 1:58.44 total
> > 2.77s user 597.92s system 1486% cpu 40.403 total
> >
> > So the time varies wildly and there is tons of off cpu time -- with 20
> > workers eating 100% cpu for the duration it would be 2000%.
> >
> > I also started seeing splats in dmesg (example at the end of the mail).
>
> this confirms that the SRCU splats we've been seeing are partly caused
> by this, as I suspected
>
> > That is to say I would suggest you also leave it running in a loop.
> > Expected setting is that it approaches complete CPU usage for the perio=
d
> > and takes in the ballpark of 40s (well shorter on your hw, but you get
> > the idea).
>
> Yeah, I do see it with more iterations.
>
> I'm redoing the key cache to get rid of the key cache lock - that solves
> it nicely. If you want to take a look at what I'm working on,
>
> https://evilpiepirate.org/git/bcachefs.git/log/?h=3Dbcachefs-vfs-inodes-r=
hashtable
>
> this is unfinished - I'm going to be switching back to the polling srcu
> interface (so we can allocate from pending frees), and the patch to
> switch vfs inodes to an rhashtable currently breaks writeback - but it's
> much faster.

So you are not patching up the vfs inode hash with rhashtables, just
migrating bcachefs away from it to your own rhashtables variant?

I don't blame you, but this also means I'm going to do some touch ups
to my patch and send a v2. Was waiting for the bcachefs (and maybe
inode hash) situation to resolve itself.

--=20
Mateusz Guzik <mjguzik gmail.com>
