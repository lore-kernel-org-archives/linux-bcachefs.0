Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B078923CE
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042877; cv=none; b=Mkn/+xUATZ+FFZ4cZ5H0hSjLhVm9vpHKqcKFlLYXRHhZiSNyZD/vdS4oKsYlrrjpTzQK4vMTc+eBpywGXXmgGAPHhR3Lopbz/pF4+BQLNLGleOI8phJTjnGFWdiWCVVRDcx6LWOTb0+r4xXEW0U2dJF4jWCslFYVMHaMiQiYj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042877; c=relaxed/simple;
	bh=elH89L6ITzLicdV7lCUJYANb/DkO67yk0QMvlyeFPn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t5vV9BGt/sksEcWXDdsWtIThsNo8Dz+mqs1vyw26i/vI+OXagH4deSn0P1ywx5lAIvEDuS0pYamA3aMo6Qd8P5u6G8EEZQVrGvu/OHweMx6bpDp1x1eEQ5bpG4FD0xS14i9FaZmal8ypdSWBFricxN9XNfCY/0767RTvusP8yDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Message-ID: <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
Date: Wed, 7 Aug 2024 11:01:12 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PSA: Avoid Debian
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
Content-Language: en-US
From: Eli Schwartz <eschwartz@gentoo.org>
Autocrypt: addr=eschwartz@gentoo.org; keydata=
 xjMEZmeRNBYJKwYBBAHaRw8BAQdAYNZ7pUDWhx1i2f3p6L2ZLu4FcY18UoeGC04Gq/khqwfN
 I0VsaSBTY2h3YXJ0eiA8ZXNjaHdhcnR6QGdlbnRvby5vcmc+wpYEExYKAD4WIQTvUdMIsc4j
 CIi+DYTqQj6ToWND8QUCZoRL+gIbAwUJBKKGAAULCQgHAwUVCgkICwUWAgMBAAIeBQIXgAAK
 CRDqQj6ToWND8aB5AP9r4kB691nNtNwKkdRiOdl7/k6WYzokvHvDamXxRJ0I+gEAjZqR5V8y
 mfR3fy2Z+r2Joeqdt3CIv5IwPs64spBvigLOOARmZ5E0EgorBgEEAZdVAQUBAQdATT46Z06b
 1X9xjXFCYFxmq/Tj3tSEKZInDWTpoHQp4l8DAQgHwn4EGBYKACYWIQTvUdMIsc4jCIi+DYTq
 Qj6ToWND8QUCZmeRNAIbDAUJBKKGAAAKCRDqQj6ToWND8a2RAP40KPfbfoiZAJW5boFmFJ3G
 TUBDJRh9CWHyaPqq2PN+0wD/R07oLzfnJUN209mzi9TuTuHjeZybysyqXSw4MAxkMAY=
In-Reply-To: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Iggb1YOQHMY6Zd50Hx2xUV20"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Iggb1YOQHMY6Zd50Hx2xUV20
Content-Type: multipart/mixed; boundary="------------vUlyZcLLrKvnld8hRaC3rtoB";
 protected-headers="v1"
From: Eli Schwartz <eschwartz@gentoo.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Message-ID: <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
Subject: Re: PSA: Avoid Debian
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
In-Reply-To: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>

--------------vUlyZcLLrKvnld8hRaC3rtoB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/7/24 12:34 AM, Kent Overstreet wrote:
> Debian (as well as Fedora) currently have a broken policy of switching
> Rust dependencies to system packages - which are frequently out of date=
,
> and cause real breakage.
>=20
> As a result, updates that fix multiple critical bugs aren't getting
> packaged.
>=20
> (Beyond that, Debian is for some reason shipping a truly ancient
> bcachefs-tools in stable, for reasons I still cannot fathom, which I've=

> gotten multiple bug reports over as well).


I can help you fathom the reason.

The inherent purpose of Debian is to not provide updates to software,
since the general class of "computer code" contains the general risk of
"regressions", including "existing config files need to be updated, and
that regresses my ability to run a box unattended for 10 years without
ssh'ing in even once".

It is therefore the stated purpose of Debian that:

- if you managed to get a working installation you do not need new
  versions of the software to maintain a holding pattern in your ability
  to get the same work done today that you were able to get done
  yesterday -- whereas upgrading to new features can break that holding
  pattern.

- if you did NOT manage to get a working installation, you do not need
  that new stuff, and should stop attempting to have an "off-topic
  conversation that misses the purpose of Debian"


If you want updates to software, you upgrade debian, rather than
upgrading software. If you want modern software, you either use Debian
sid rather than stable (bcachefs-tools 1.9.1 may not be the most recent
version but it's very much not "truly ancient") or you do the sensible
thing and use a reasonable distro.

"Reasonable distro" meaning a distro that, when faced with the choice
between:

- allow people who installed the distro in 2017 to pretend it is still
  2017 and keep using their system the way they did back then

- improve the user experience for users

choose the latter.

In short, it is foolish to criticize Debian for shipping ancient
software since the answer is "the purpose of Debian is so that users can
use ancient software".

=2E..

No comment on their switching rust dependencies to system packages.
Possibly the problem can be mitigated though -- is it possible for Rust
build systems to declare a minimum required version of dependencies, the
way pkg-config for C / C++ can do?


--=20
Eli Schwartz


--------------vUlyZcLLrKvnld8hRaC3rtoB--

--------------Iggb1YOQHMY6Zd50Hx2xUV20
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQTnFNnmK0TPZHnXm3qEp9ErcA0vVwUCZrOMOAUDAAAAAAAKCRCEp9ErcA0vVxKO
AP9jvKAg8eMV3Gv1LKcPOWeg7gJRVrEPPRbroLTIRS8sNgEAsYN6Ptr9ZUrtIkqn7GA7LrNmPAIy
Eu1HJGs96kcXIAM=
=lZOV
-----END PGP SIGNATURE-----

--------------Iggb1YOQHMY6Zd50Hx2xUV20--
