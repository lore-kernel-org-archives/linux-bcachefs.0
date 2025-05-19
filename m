Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E721DEFE0
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747666146; cv=none; b=gJAyZ/pA7dSPZ8jgLb+O0OTlv0EhtfaChPuy/9mLa1UrA8kaO4lTiLX8W6FJE46oUbapPYIkYU7Hty0AnAcQ2qWUw7ee+MpYj67IlD+pyKS8v1b90rhIBr4ASGpmkD+suFALvXRuIWSzU5q263Q5g4D94tRWQNPT1JwJkeFTAsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747666146; c=relaxed/simple;
	bh=udbZf08lXV3sZVmd5EnH1AL8teLpo8Q2Qg1riix3MYU=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=fgGAjDf9stoYvb2IHpMF7dHhU1Yzs++OWnRl8M75szV9NSSMhPRvGQuwgOX7/1AiICXv4qI5BcartMKCw+T7bQOszNh6LB6S+RIB1omf8Uk2DbAjws4AwDBCgd1OcnUS0ZulxEyShMzDb5mHNLmifJX2WKeqG0AKmeaTeMl48J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 4040C1E38E;
	Mon, 19 May 2025 10:43:18 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 7475FA0FD5; Mon, 19 May 2025 10:43:17 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Message-ID: <26667.17285.448393.277537@quad.stoffel.home>
Date: Mon, 19 May 2025 10:43:17 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Malte =?iso-8859-1?Q?Schr=F6der?= <malte.schroeder@tnxip.de>,
    Pavin Joseph <me@pavinjoseph.com>,
    Martin Steigerwald <martin@lichtvoll.de>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Status of rebalance and scrub support
In-Reply-To: <qmuquecmaljpmmullubtsw2bflzspmtwp2u4ffdcrbvyoro6lh@arpwh7rlc5jl>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
	<4984817.GXAFRqVoOG@lichtvoll.de>
	<7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
	<5890559.DvuYhMxLoT@lichtvoll.de>
	<dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
	<21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
	<qmuquecmaljpmmullubtsw2bflzspmtwp2u4ffdcrbvyoro6lh@arpwh7rlc5jl>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" =3D=3D Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Sat, May 17, 2025 at 02:21:34PM +0200, Malte Schr=F6der wrote:
>> On 17/05/2025 14:18, Pavin Joseph wrote:
>> > On 5/17/25 4:11 PM, Martin Steigerwald wrote:
>> >> So seems since 6.15 there is scrub support :)
>> >
>> > That's wonderful news!
>> > Could you check if rebalance is also working in 6.15?
>> >
>> > Thanks,
>> > Pavin.
>>=20
>> If by "rebalance" you mean equalize the amount of data between drives
>> (like btrfs): No, it can't do that at the moment. There is a thing
>> called rebalance on bcachefs, but it does something different (I think
>> it moves data between tiers).

> I was thinking about renaming "rebalance" to "background_data".

tier_migrate?  migrate?=20=20
