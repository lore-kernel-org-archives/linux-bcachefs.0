Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63569BE5E
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747666858; cv=none; b=CvVQlAMEk0EYWsjjSLgsI8Id3faqwyn2g+h521Jgb109Jx8Xh2QS9Z3NQwMsOW7Tnz0FpfmdgL0nnhObP7Cq4t/i2ilebjfyxJ6GmvsAQm6PMjmWlz+8tgTiC9/FRcE2rc3py84Y0fQdQGuN4bbP71yebdM7DHRNo4bfeIWQ6DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747666858; c=relaxed/simple;
	bh=DRU+oZMZcuXTO0LaSov0T9Nv9JDurmAIZSiXv1LWSBU=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=tIYLIScG5slSSj9Ndax8Gn7LRMWKRv4quJAyIgs+95Jq99sqFPOcQ2NYvhsm89lmNAe34eGC5I628EC2wW9VE3vsU+DGqLSNfCyzVal1hI0CityM9rQQWmv+9PaHFsnTAyhMFJqmr5/E4pogLUGIrbq+O4x53SynlJLMJPYrvaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 3AA661E499;
	Mon, 19 May 2025 11:00:54 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id E08E4A0FD7; Mon, 19 May 2025 11:00:53 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Message-ID: <26667.18341.891221.196797@quad.stoffel.home>
Date: Mon, 19 May 2025 11:00:53 -0400
From: "John Stoffel" <john@stoffel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: John Stoffel <john@stoffel.org>,
    Malte =?iso-8859-1?Q?Schr=F6der?= <malte.schroeder@tnxip.de>,
    Pavin Joseph <me@pavinjoseph.com>,
    Martin Steigerwald <martin@lichtvoll.de>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Status of rebalance and scrub support
In-Reply-To: <wqlurfdcgogbxneenl4dbu756x3qy5oez3thyp5ifjb2n326md@ixrcqjntrzc2>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
	<4984817.GXAFRqVoOG@lichtvoll.de>
	<7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
	<5890559.DvuYhMxLoT@lichtvoll.de>
	<dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
	<21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
	<qmuquecmaljpmmullubtsw2bflzspmtwp2u4ffdcrbvyoro6lh@arpwh7rlc5jl>
	<26667.17285.448393.277537@quad.stoffel.home>
	<wqlurfdcgogbxneenl4dbu756x3qy5oez3thyp5ifjb2n326md@ixrcqjntrzc2>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Kent" =3D=3D Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Mon, May 19, 2025 at 10:43:17AM -0400, John Stoffel wrote:
>> >>>>> "Kent" =3D=3D Kent Overstreet <kent.overstreet@linux.dev> writes:
>>=20
>> > On Sat, May 17, 2025 at 02:21:34PM +0200, Malte Schr=F6der wrote:
>> >> On 17/05/2025 14:18, Pavin Joseph wrote:
>> >> > On 5/17/25 4:11 PM, Martin Steigerwald wrote:
>> >> >> So seems since 6.15 there is scrub support :)
>> >> >
>> >> > That's wonderful news!
>> >> > Could you check if rebalance is also working in 6.15?
>> >> >
>> >> > Thanks,
>> >> > Pavin.
>> >>=20
>> >> If by "rebalance" you mean equalize the amount of data between drives
>> >> (like btrfs): No, it can't do that at the moment. There is a thing
>> >> called rebalance on bcachefs, but it does something different (I think
>> >> it moves data between tiers).
>>=20
>> > I was thinking about renaming "rebalance" to "background_data".
>>=20
>> tier_migrate?  migrate?=20=20

> It's not just for migrating to different devices, background
> compression is quite popular.

Ah... then maybe 'reorganize' or something like that?  I still need to
try and build the bcachefs tools for myself that are upto date, but
your development is so bleeding edge that it's a real pain.=20=20

Yes, I'm runnign Debian 13, which is certainly not bleeding edge.=20=20
