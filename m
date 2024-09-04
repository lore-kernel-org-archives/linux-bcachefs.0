Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1B17E1
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 00:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725409881; cv=none; b=AZyJM7NJA6EMeaCkYnn27lUnV/EuIlN6wqTYe0JSDuIVu6S4PFtcb+VY3Sk7IBuSqYwrxAxMJLrU+Pi6azt/tNRYAkFNJHQtqQbIAfcD9gZ4d4YcjX2DTGuV2DXltleNlMit+CufSfjNs48+yDoIOKGsOP+BYNOWRypNgf1j2Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725409881; c=relaxed/simple;
	bh=aSQbts5GhZsFPK6IMq1LullBoGx2BzOaKo4gmHhgss4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=guOA2IjQ1LgNSMnBEXKbsPp8N+WdItSqggnTgCLRFj79WiHnM6cZk5L7c9Q3deBL/t8p3QazpzQQKkc0tNibzgTX8P+Kekm45LEcCUn7uBOFLsYtbV+LzOhNGBoMZYD1UwD3LT9xYju564CxHyxA2B3nRmZA76yEoDSLXY7t50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Message-ID: <3d737289-9c3b-4596-8c3d-de8b0cb5c9af@gentoo.org>
Date: Tue, 3 Sep 2024 20:31:16 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PSA: Avoid Debian Stable
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
 "Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
 <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
 <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>
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
In-Reply-To: <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Btanv1z0ake3F13M0esInNht"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Btanv1z0ake3F13M0esInNht
Content-Type: multipart/mixed; boundary="------------pjr7dA0NRFLD94Fv0drbEL0V";
 protected-headers="v1"
From: Eli Schwartz <eschwartz@gentoo.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
 "Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Message-ID: <3d737289-9c3b-4596-8c3d-de8b0cb5c9af@gentoo.org>
Subject: Re: PSA: Avoid Debian Stable
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
 <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
 <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>
In-Reply-To: <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>

--------------pjr7dA0NRFLD94Fv0drbEL0V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/3/24 8:04 PM, Kent Overstreet wrote:
>> Back to Debian. Since each package can only have one source
>> *.orig.tar.xz, I would assume that Debian has basically two choices as=
 a
>> result of their packaging format:
>>
>> - package each crate as a system dependency
>> - repack each program source after running `cargo vendor`, and upload
>>   *that* as the canonical source code
>=20
> I already provide 'cargo vendor' tarballs. Yes, it's big (thanks to
> bindgen), but it's not _enormous_.


Sure. Debian was probably working with the notion that using vendor
tarballs makes individual packages a "special snowflake", which is a
tempting rationale until you realize you're patching to allow versions
that are way too low.


> And bindgen is unfortunately the problematic one (and the one that brok=
e
> the build) - the semantics of the packed and aligned attributes are
> subtle, and bindgen has had difficulty getting them right (due in part
> to differences between gcc and microsoft).


Heh, no doubt. :)

-bindgen =3D "0.69.4"
+bindgen =3D "0.66"

Really makes you think about the wisdom of allowing versions that
upstream specifically marked as incompatible (downgrading, not upgrading!=
)

Especially since binding between two languages will inherently tend to
violate rust's safety semantics! The entire point of bindgen is to
create a "safe" description of C types...


> Don't unbundle the other dependencies. They're tiny, and it's not worth=

> the pain it could potentially cause.


Yeah but again this has nothing to do with unbundling, rather, it's
about modifying version and disrespecting:

- the lockfile
- the Cargo.toml

If the debian packages were simply the same version as all the
Cargo.lock entries, then it would be *unbundling*, but not *modification*=
=2E
'
It's the modification that's a problem, and specifically, the
modification of *required lower bounds*. It might be safe to upgrade a
crate, to get a "better" version, but downgrading to get a worse version
generally feels pretty silly.

Again, Simply running `cargo install --git
https://github.com/koverstreet/bcachefs-tools` will totally ignore your
lockfile and feel free to update to "newer =3D=3D better" versions. Perha=
ps
bindgen would even fix more attribute issues. :D

But it would always, always, always respect Cargo.toml, which is why
Debian did NOT bother doing anything to the lockfile, but did apply a
patch to Cargo.toml


> The cargo dependency model is _really good_ because it means dependency=

> updates happen in commits in the consuming package, meaning it's
> actually possible to bisect for breakage caused by a dependency update =
-
> that's not something we've had before.


And you can do the same with any C build system that isn't "I like
Makefiles because I think they are simple to write". You do a dependency
update in commits in the consuming package as an update to the version
specification of the url+checksum used to download and build C libraries
as vendored dependencies. Just like Cargo.lock

And like Cargo.toml, you can do the *other* kind of dependency update
(also as commits in the consuming package) by updating the *minimum*
version permissible (e.g. when consuming a system package).

This really is a solved problem in C/C++ and has been for a decade. It
has to be, if for no other reason than that Windows developers ***do not
have a choice*** as there is no such thing as system dependencies. That
is why vcpkg exists (and using it involves adding a manifest to your
Windows project describing the exact pinned versions of your
dependencies to go ahead and build).


--=20
Eli Schwartz


--------------pjr7dA0NRFLD94Fv0drbEL0V--

--------------Btanv1z0ake3F13M0esInNht
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQTnFNnmK0TPZHnXm3qEp9ErcA0vVwUCZteqVAUDAAAAAAAKCRCEp9ErcA0vV9ax
AQCeGxSY+43OOMHZVTvHpbKlR9nf0U8T9knUjmk+LJEPwQD/dawCw+kqY9EvqA5RnZtYt9VfNurr
3QX3PWKT/bC0twA=
=Fjny
-----END PGP SIGNATURE-----

--------------Btanv1z0ake3F13M0esInNht--
