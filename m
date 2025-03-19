Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1518250F8
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742393821; cv=none; b=pxM4Ia9nMErsDEDTlic1U5/JQ3OeBP0CywbqKFmHmVaWpLO7RsZS8KKMtiGm4hypBwv7So5lMyZKqmyEB2FUFEDavfi/0HKAFAxtUn48Fk0w3HJGj0SI/nwjkV6GIMInHtUvQGnFKmLljQGwtdWlFbPXRfSIV1h9xsA61zGc85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742393821; c=relaxed/simple;
	bh=qSfnseLj7bYA6Sbe9DEhrUOkzsrmo7D1A1jR/lsNB6E=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=I2X5p8ijBrjZXnyfIl2GYsltW6/dF2P1HVK0YckHo5MGdAdOAtYicUW/oCMZ4/6ldPmHDZfpiZtm49nPxzTFpCJjeASEVQivEhJ24VT/YTj5AkoFdridjMpDhtyMadUfBSYrQsOjxzwcnWE86ziCWRfLT4K6xo3s23W3av3Nckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 45DB71E4A9;
	Wed, 19 Mar 2025 10:16:58 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 8A998A0E88; Wed, 19 Mar 2025 10:16:57 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Message-ID: <26586.53721.541198.490221@quad.stoffel.home>
Date: Wed, 19 Mar 2025 10:16:57 -0400
From: "John Stoffel" <john@stoffel.org>
To: Malte =?iso-8859-1?Q?Schr=F6der?= <malte.schroeder@tnxip.de>
Cc: John Stoffel <john@stoffel.org>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
In-Reply-To: <3e765804-93b5-4102-8d31-0c91d44c726c@tnxip.de>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
	<26584.35900.850011.320586@quad.stoffel.home>
	<26584.36927.6100.282713@quad.stoffel.home>
	<66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
	<26585.57291.760395.430511@quad.stoffel.home>
	<3e765804-93b5-4102-8d31-0c91d44c726c@tnxip.de>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Malte" =3D=3D Malte Schr=F6der <malte.schroeder@tnxip.de> writes:

> On 18/03/2025 22:04, John Stoffel wrote:
>>>>>>> "Malte" =3D=3D Malte Schr=F6der <malte.schroeder@tnxip.de> writes:
>>> Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
>>> someone pulled it of by forcing some libs from Trixie, but that caused
>>> other things to break.
>> So what is the best Linux distro to use to compile bcachefs-tools?
>> And can someone upgrade the INSTALL.md doc and the
>> https://bcachefs.org website to talk about what is the best
>> development environment now to use as a baseline?  And how to
>> cross-compile the bcachefs-tools for use on older distros with newer
>> kernels?=20=20
>>=20
>> I'm sure more people would test and play with bcachefs if there was
>> more docs for ends users to work from.
>>=20
>> John

> I'd recommend you join #bcache at OFTC. This kind of things has been
> and still is discussed there and people have found solutions that
> worked for them regarding -tools vs Bookworm. My personal "solution"
> was to upgrade to Trixie.

I'm old, but for some reason I've never done IRC.  :-)  Is there a
base OS (Fedora?) that people use for development which I can use to
cross build a package for Debian?=20=20




