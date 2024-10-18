Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F5618C92E
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 08:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729239435; cv=none; b=YTvo5F7vzO5h1RmLP0mCuOsOj+xGEeoYefEhPPPrAiXb2MRxxOruqGZVpt2h2gSLBtMigDFAl65xUnziLYhj1fZZi8JzqBMbieKi1qas1Pc1kBlTV+oQLzSonCMtfnKBgb+hGYV480CRbMLnGuGu0HGhjZhLVgri6JQpQGJE93o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729239435; c=relaxed/simple;
	bh=dzw+H0yhfamn5ih5NHQz4l+lgLRRIZfPPBORuuscM1A=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=A20hAAU1PsQMYiCKDB3a9SBZPqEkUAnvj44h1R7+TeN7MsGfkbSnvSiqFn/fWPqonuM0VfC1b5R0edffsFaoHN3MKn8+2GqvObGX/4M8U6ilASAkMeyZkZvrWOqIDKfNvCsu0d3VhweJnLuuRQgFH2fdQNXf8q4tw4EAYNFyVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kode54.net; spf=pass smtp.mailfrom=kode54.net; dkim=pass (2048-bit key) header.d=kode54.net header.i=@kode54.net header.b=PpRbMmae; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kode54.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kode54.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kode54.net header.i=@kode54.net header.b="PpRbMmae"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kode54.net; s=key1;
	t=1729239429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzw+H0yhfamn5ih5NHQz4l+lgLRRIZfPPBORuuscM1A=;
	b=PpRbMmaeGSSjKkMyks/5CWX1z7WxomFl57BOZeRPWK/rozr9LfDN9NJaA71pAzU2FVQ+FV
	HAI+h4xnGuWUQ7z5jRqWn2WGZrPgPwvV3v3h4OP/8SE+dJGBQYUm2/ncO/ZU6q5xH+rjBr
	Llq6J07hQIQa3SL1aMYOqG2Y9lrEdFRMhmkNiLoSMhrAvmnL6PA+XGfuvinsV8iRbNNC35
	QdndExLCEjUeCRTN3FEv/8aZlEYQmi4vKTOrSsVZgc7By5FgOqpgifAML19appTCrz8UIP
	LO3tq7M02untRFv0IzrtduspApJxTc8D6Op4DrdorsghoVOiKSxp8Jc89JVzZA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Oct 2024 01:17:06 -0700
Message-Id: <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
Subject: Re: Another bcachefs version downgrade bug
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Christopher Snowhill" <chris@kode54.net>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>, "Kent Overstreet"
 <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
In-Reply-To: <504302838.942.1729183773058@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu Oct 17, 2024 at 9:49 AM PDT, Carl E. Thompson wrote:
>
>
> > On 2024-10-17 3:13 AM PDT Kent Overstreet <kent.overstreet@linux.dev> w=
rote:
>
> > ...
>
> > Carl, I'm happy to fix bugs that you find, but the attitude and the
> > unnecessary advice - that I don't enjoy.
>
> Seriously, Kent? **You're** talking to **me** about attitude?
>
> **You're** giving **me** passive-aggressive attitude about how I'm report=
ing a bug when using a kernel which is only 4 months old. And how about tha=
t crack about about how I should have just done an fsck when you knew (shou=
ld have known) that a fsck doesn't fix the problem? I don't doubt that in y=
our mind those are subtle insults that would fly right over my head and I w=
ouldn't notice but I might suggest that other people aren't quite the idiot=
s you seem to always assume we are.
>
> I'm trying to **help** you, Kent. And that includes the reminder about ho=
w long it takes to put mostly-done software into a usable state. That's not=
 attitude, that's just reality.
>
> Carl

FYI, 6.9 was first released in May, and is already EOL now. In fact, so
is 6.10, at 6.10.14. There are no LTS kernels with bcachefs support yet
at this point. All further development is going into 6.12 now, with bug
fixes being backported into 6.11.

The only distributions still shipping 6.9 or 6.10 are backporting things
themselves. Actually, last I recall, there's at least one distribution
that decided to slap 6.8 into an LTS as well. I guess big distributions
just *love* doing their own backport work.

- Christopher
