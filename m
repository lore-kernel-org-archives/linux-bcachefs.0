Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281CB13D28C
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046999; cv=none; b=B0Dt4P1zTWFoE4bwKzZrz2x5X+iVMPgIGuHUKZ/67v8aDsyA/Xnjq3P9RWJm+z/7VynYm2mCFFnzlul2EoVMIK1j8lCXjqtLCrfCHThL3YQ+dBu7DsZEI8GhpjNBKxUlbToPoSae00i0fqDRbK58fn+Pe7fkEG/NATm3XxFYhLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046999; c=relaxed/simple;
	bh=Y6EsRgT+VMwA+DIGU8zUZLDmA+L1mlTK1NR7AkLECGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyHkOT5+eL48n9VSwFF7M5EPU89mnaevRGhoqp8O9nd7tjU03GKFWTNXh/349E9c1XXqrQI/ws2Yqmqi+uFfJJgFr2EJYmwj7SWnG4u/0tUIObf3h2Lddb9Mp86UHm4+BWLM65Lug4pSfcCI09BGImyD4jwykgHnM21iysVYQ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Message-ID: <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
Date: Wed, 7 Aug 2024 12:09:53 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PSA: Avoid Debian
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
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
In-Reply-To: <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FV4c4vO81l2yiCcY7kmQSKvr"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FV4c4vO81l2yiCcY7kmQSKvr
Content-Type: multipart/mixed; boundary="------------DmrbMGw6Y07PAOaCP0895Uw5";
 protected-headers="v1"
From: Eli Schwartz <eschwartz@gentoo.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Message-ID: <fee92c29-2701-4b1e-b9a3-13d1227e6e49@gentoo.org>
Subject: Re: PSA: Avoid Debian
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <7d05b5af-fed0-4ceb-b320-8a1abf11c18b@gentoo.org>
 <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>
In-Reply-To: <s5vi6rgizxjzhp6uch4rpubfhe3546r4fszgzkw4wemlk3nf75@4beqhlz2fd5k>

--------------DmrbMGw6Y07PAOaCP0895Uw5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 8/7/24 12:01 PM, Kent Overstreet wrote:
> This is holding up _bugfix releases_.
>=20
> Anyone would run screaming from a distro that didn't ship updates at
> all.


(What if I said that lots of people *do* run screaming from Debian?)


You have to manually negotiate for those, to avoid the risk of
accidentally shipping an updated bugfix release that breaks their
spacebar heating: https://xkcd.com/1172/

Obviously, lots of software does get bugfix releases, because someone
negotiates the Debian political landscape to advocate for that bugfix
release.

When software cannot be updated by default because it might break
someone's workflow, the natural result of sometimes needing an update is
that people who want updates are pitted adversarially against people who
do not want updates -- you need to plead your case and get permission
and, well, fight for your right to receive a bugfix.

=2E..

Has anyone volunteered to be the political advocate for bcachefs-tools
bugfix releases in Debian?


If not, then I should amend my earlier advice to also include "do not
use Debian if you don't like having to deal with the political
ramifications of using the most politically bureaucratic distro of all
time". :)


--=20
Eli Schwartz


--------------DmrbMGw6Y07PAOaCP0895Uw5--

--------------FV4c4vO81l2yiCcY7kmQSKvr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQTnFNnmK0TPZHnXm3qEp9ErcA0vVwUCZrOcUgUDAAAAAAAKCRCEp9ErcA0vV32B
AP4+XTHtDkro7wEqbMW9AKkMK3FB0EBrrZfn1FU2BAbtUgD+NzGG0oSIY4bEX5Qa+IfY2K7sxTEb
/5ThRJfDq2fu0w0=
=r2q6
-----END PGP SIGNATURE-----

--------------FV4c4vO81l2yiCcY7kmQSKvr--
