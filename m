Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716BF4207B
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172569; cv=none; b=FeSU4YFW4zT91/67g669A1EJzXE7hYOIDYlxnNsZunbmMSP4HdGnoUgwAGvC0S1Cfar0s2P9ywcbda8DtHfiD6tLHr22PGDCedNoZbeDnplTijGUyBvculweTJvHl5eqpHjnrhL6Leof47ZrPLMP+zyWzgWimfmUH4HNp38iK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172569; c=relaxed/simple;
	bh=wM5TaYd/DiQA72gOlVOvUf6udxhV+3YkvnHLuWtHgtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DMjKl5lwRnaN3Hrt6eo2AsdwuP5H4KEwmdjhe+/JLrtWTOqBzjD5LkpTbqkz7QH8Hcvz+xOlXxuYrsFR7dZVdvJBZEghKP707HOBjq999OvP/A3H88zDUKxkiOUccQ9X2o12v3IfYS7RM0qvyyO/7HI/UqP0RkPgm6WNYh1uW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=e6Sv/dby; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="e6Sv/dby"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d204e102a9so59327161fa.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Mar 2024 08:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1710172563; x=1710777363; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HiF7GBB/2WBtnbobBcywyv4zcAZ18CMSOARtD/lMsXk=;
        b=e6Sv/dbyNkBT5H59rSIrTMP/5az9xsNFmEq1DtuwScDnju46sbfPisLNuijZD/2/3T
         GN48ieL6EWFzMPfxmRUz6jeZe9hMvNkeKHKJoaHR9vhkw3FXxz2PxanByq0pkF9uQY5B
         2BxZgL2fZeYWWz9RIUWf8WvqsRfLSWABbdqSZUZNpygMr7IqnWVpqw1Twsm8LcF/XZUC
         T7yVJN+SxWOkylI0BhGaBmByS74FGNbgXacV+PWkGsX+v6rRvesUUQmKM0ZTpk5msQ8i
         vwKiYiNAwOxtXyQDgrg974zRoA4eraX6wjsP2AWlH8dMoMl72D2d4JVbfee0Td6UDr2m
         2t0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710172563; x=1710777363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HiF7GBB/2WBtnbobBcywyv4zcAZ18CMSOARtD/lMsXk=;
        b=M1r53btZ4tsxF7BX/Y1hD/khpDn8TV+GZZE/Q6euF8OH1Zb7QFKhRKXYldizZH/iPi
         N/mQmMMhemz6hUacDa1M7nltzgf6sRoX9Qt4TEjFeo7j+HBqYCy/HHFjF9o5zSKJ0J83
         V7ULl+RfBKUx2cRqjMBZWmwgVE+aOQx12Y8MzwOzCN6LsPP1x9d9xk7aZXySPI1N62v4
         YHpTVV727YEzWE1EUVlI15x7DvYNTeuqIanCSn88/nRx/cLjaxU8oH2/txXT3L7ZVgIv
         H5ANGDzJPwA2qiXoja7Cv9vwr3WRTJCSvmQXyUcgeIph1E9EvTRrM2gz23j9krQ/ziPh
         i0pA==
X-Gm-Message-State: AOJu0YyciUu1PTr6ieSJdNPRB5KbnN1yg05tlFUzggiemTGe418ie4I2
	t5scd79EyZ8r7ka5fhwTFd5YQXxN/ahx1KZO/q1tiJnmBMEKOUn/4uvI3yN88pWYyEmWte8b/DU
	4+elW2Um+TkZ0crFDobfo6qAAiRZJn5hL3xA=
X-Google-Smtp-Source: AGHT+IFn4X1KqOm/8tHyiEJJ7VlL6i6L/wQ6S5XGEpeYVRLkRCRbXR6fgxbtUYWmaFeW3z5+4A8SUpMvY5VDsQhoQ3k=
X-Received: by 2002:a2e:9bd7:0:b0:2d4:4b9e:f37b with SMTP id
 w23-20020a2e9bd7000000b002d44b9ef37bmr85562ljj.44.1710172563335; Mon, 11 Mar
 2024 08:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
 <iloqkrwanqljkorf3tky4rskjqpnl4zqqklejjf3w3gfu3ezjp@uwr2xwhscjlz>
 <CAMU1PDjK=j+OfZhs1i7vPwWQ1E4VNx0t0XB-q4xeZ90_imOu1w@mail.gmail.com> <yyrmhuevljcnukg6uazcw3jwf5bffpda32eabxvl5eommkxzch@loxecv63dk4a>
In-Reply-To: <yyrmhuevljcnukg6uazcw3jwf5bffpda32eabxvl5eommkxzch@loxecv63dk4a>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Mon, 11 Mar 2024 15:55:51 +0000
Message-ID: <CAMU1PDgJDKyBCb9OXpkkWRQCqGR5ScXSfpHjSccAfC-gt-FDoQ@mail.gmail.com>
Subject: Re: [WIP] bcachefs fs usage update
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Mar 2024 at 23:42, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Fri, Mar 08, 2024 at 11:37:13PM +0000, Mike Fleetwood wrote:
> > On Fri, 8 Mar 2024 at 01:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > On Wed, Mar 06, 2024 at 11:14:45AM +0000, Mike Fleetwood wrote:
> > > > On 2024-03-02 04:14, Kent Overstreet wrote:
> > > > > I'm currently updating the 'bcachefs fs usage' command for the disk
> > > > > accounting rewrite, and looking for suggestions on any improements we
> > > > > could make - ways to present the output that would be clearer and more
> > > > > useful, possibly ideas on on new things to count...
> > > >
> > > > [Sorry for any email thread butchering.  I've only just subscribed to
> > > > the list and seen this in the archive.]
> > > >
> > > > Background:
> > > > I'm working on adding some level of support for bcachefs into GParted.
> > > > It wants to be able to report the FS usage (per device) of a file system
> > > > to (1) display in the UI, and (2) to limit how small it allows a
> > > > partition to be shrunk.  (I understand that bcachefs doesn't currently
> > > > support shrinking devices).
> > > >
> > > > What I would like from bcache fs usage is:
> > > > 1. To be able to get free and capacity figures for a device in an
> > > >    unmounted bcachefs file system.
> > > >    EG:
> > > >    bcachefs fs usage /dev/$PTN
> > >
> > > that'll take some work, but should be doable
> > >
> > > > 2. To continue to be able to get free and capacity figures in bytes.
> > > >    Using a command line switch is okay.
> > >
> > > json output?
> >
> > Json output is not required.  Plain human readable text will do.
>
> But it'll be a lot less fragile as things change and are added. We
> really should be getting away from machine parsing of output intended
> for humans.

Okay I'll read json output from bcachefs fs usage when available.

> >
> > None of the other file system tools provide json output so GParted just
> > parses the plain text output they do provide.  These are the commands
> > GParted runs and parses the output from to get usage figures for a few
> > of the file systems it supports:
> >   btrfs inspect-internal dump-super /dev/$PTN
> >   dumpe2fs -h /dev/$PTN
> >   xfs_db -r -c 'sb 0' -c 'print blocksize' -c 'print dblocks' \
> >   -c 'print fdblocks' /dev/$PTN
