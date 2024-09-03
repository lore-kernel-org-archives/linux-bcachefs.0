Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7E9126BE1
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725407098; cv=none; b=dgukQWQM5Y8RbXsMWN82DJEqjHUQyEl/qsJMcHVfvjqVslMD+DNwFTXIi68nUuoUYz85wrRpSJQSk+/mc0a0cCf4IovTP9CjTGDD0tH6sl/qtl8QalF4yDz3GeNmLMu7glL+x4RM3POTKDxZPVHsCJian5pBgy/Mh62ndMkbgQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725407098; c=relaxed/simple;
	bh=5LMmNQRgXtjdPLQcKfpTwXT0EgosnNoHrbLqigEHZYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EwGfpytkj9CFiUSm5qqxvZnEdFD/GdoMATxD0L+d5xdPicPphcP2D/5TvIKsdzVL7/tONbM+ErsS/21FziiZIRnt8G2mVNd+stHkzZBSgT9rkyoMpUDrZg4RJTKO0sybpvub9fsSvyYzJ3Q06tCTziXJZmDMf0Nj3pjvhgfv/dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Message-ID: <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
Date: Tue, 3 Sep 2024 19:44:52 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PSA: Avoid Debian Stable
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Martin Steigerwald <martin@lichtvoll.de>
Cc: "Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
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
In-Reply-To: <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------yvK0ecXUp04QsOjpH8gztNQC"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------yvK0ecXUp04QsOjpH8gztNQC
Content-Type: multipart/mixed; boundary="------------BMSc9nbBmJUNsvQpK2L4okoG";
 protected-headers="v1"
From: Eli Schwartz <eschwartz@gentoo.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Martin Steigerwald <martin@lichtvoll.de>
Cc: "Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Message-ID: <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
Subject: Re: PSA: Avoid Debian Stable
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
In-Reply-To: <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>

--------------BMSc9nbBmJUNsvQpK2L4okoG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/3/24 6:15 PM, Kent Overstreet wrote:
> I still have not yet heard a single good reason for this policy.
>=20
> The rust dependencies are statically linked, and that's not going to
> change because dynamic linking that works with the full Rust typesystem=

> is, simply, a _really_ hard problem that's going to take a massive
> enginering effort to solve. Swift was able to do it - but I'm quite
> familiar with what it took to do that, and they were only able to
> because Apple invested significantly into it.
>=20
> So, given that they're statically linked, why?
>=20
> It can't be for security updates, because to update a dependency we
> _still_ have to update and spin a new release of bcachefs-tools. And
> that's not such a big deal, because nodays there's bots that notify me
> if I need to do that.
>=20
> So it seems to me that Debian people just aren't thinking things
> through.


There's an interesting conversation to be had here about distfiles,
duplication, and offline building.

Probably the biggest single requirement here is the offline building.
It's not enough to download the bcachefs-tools source tarball and build
that, since you also need crates downloaded from crates.io and added to
a local registry. Most (sane) distros build packages with the network
disabled for security reasons, because you want to verify that all the
code you are building is code which was included in the original source
checksumming which is part of the build manifest (and the build manifest
in turn is probably PGP-signed by the distro developer that processed
the update).

And the Debian packaging format involves converting every package into
an "orig" tarball with the debian build recipes installed inside as
debian/ and then running the dpkg package building tools from inside
there. The key to a successful packaging experience is somehow getting
to run the build tools from that source tarball.

The packaging formats used by most other distros work differently: a
package can have multiple (checksummed) source tarballs and one of the
build phases is unpacking each listed distfile. Alpine, Arch, CRUX,
Fedora, Gentoo, Void, all list urls to download the source(s) from and
the checksums to validate against as part of the build recipe, and
unpack those into a temporary directory.

So for example that means that Gentoo can list 90 different crate
dependencies, plus one primary bcachefs tarball, and download each of
those files into /var/cache/distfiles, then unpack them into a fake
cargo registry. Of course, this is pretty slow if you don't have
parallel downloads -- not usually a problem for most packages that have
only one or two sources, but there you have it. And they can be shared
between multiple packages, or multiple versions of bcachefs-tools,
assuming that packages use exactly identical versions.

In theory, one can also specify a different crate version to use instead
of basing the versions on Cargo.lock. The update tool (pycargoebuild)
always builds the list based on Cargo.lock, though.

Now you have a 90-line package recipe, so have fun with that! :) Of
course, since any solution for bcachefs-tools is logically consistent
with handling other rust software, keep in mind that some packages have
1,000+ crates. Even more fun!


Back to Debian. Since each package can only have one source
*.orig.tar.xz, I would assume that Debian has basically two choices as a
result of their packaging format:

- package each crate as a system dependency
- repack each program source after running `cargo vendor`, and upload
  *that* as the canonical source code

Option 2 tends to not become great, e.g. due to the complete inability
to deduplicate between packages. Option 1 is entirely workable, *iff*
you assume that each crate and each crate *version* forms a unique
package *name* within Debian. For example, byteorder version 1.5.0 would
become a Debian package "librust-byteorder-1.5.0-dev (1.5.0)", and then
you could install as many versions of the "byteorder" crate as you like,
and depend on whichever one you need. Except... oops! Debian does this a
bit different. They depend on librust-byteorder-1-dev (>=3D 1.3), because=

the package name is based on semver and the package restriction is >=3D
your Cargo.toml

[dependencies]
byteorder =3D "1.3"


One possible reason why they bind the name to the semver might be
because they, as noted, "have" to install the resulting -dev package to
/usr/share/cargo/registry/byteorder-1.3.0 or whatever, and by using a
global registry it's possibly impractical for *cargo* to determine the
"correct" version to use when both byteorder-1.3.0 and byteorder-1.5.0
are there.


Since the rust ecosystem takes great pride in semver and cargo is
designed to work this way (Cargo.lock even when checked into git is not
necessarily respected by ordinary commands) that probably feels like a
reasonable solution for the average use case of the rust ecosystem
within Debian. And it has some advantages, such as the ability to have
packages depend on only their direct dependencies, and have *those*
depend in turn on their dependencies, for great simplification of the
manifest of crates needed. Or, provide a patch to a crate *once* and
have all packages using that crate respect the patch. Anyone who thinks
that distros shouldn't ever patch software is unfortunately a fool. :)
It tends to be especially urgent for users of alt-arches where software
wasn't tested on e.g. mips or ppc64 or sparc or hppa and miserably
fails, while the maintainers have disappeared, but there are other fun
examples such as software with a build.rs that builds its own private
copy of a C library and should use the system one instead. Clowns that
insist on building their own private openssl version and ignoring the
system copy are the bane of computing.

Again, this is all about why a linux distro might have a *general
policy* for handling rust crates in one place per crate.

I suppose it's pretty unfortunate for rust software that isn't
compatible with the ^1.2.3 style versions described in Cargo.toml,
though that is a bit of an easy fix -- upgrade them.

It's unclear to me if bcachefs-tools was having bugs on Debian due to
following the strictures of Cargo.toml, or due to the patch "Relax build
dependencies to match what's available in Debian":

https://salsa.debian.org/debian/bcachefs-tools/-/blob/master/debian/patch=
es/relax-build-dependencies

e.g.

-rustix =3D { version =3D "0.38.34", features =3D ["termios"] }
+rustix =3D { version =3D ">=3D 0.35 , < 1", features =3D ["termios"] }


Because Debian Stable has 0.35.12 and Debian Testing has 0.38.32 and
neither of those are sufficient.


--=20
Eli Schwartz


--------------BMSc9nbBmJUNsvQpK2L4okoG--

--------------yvK0ecXUp04QsOjpH8gztNQC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQTnFNnmK0TPZHnXm3qEp9ErcA0vVwUCZtefdAUDAAAAAAAKCRCEp9ErcA0vV/yx
APwOCSYxsWrLGd7jaGl0GqOTgenniyadVaqYqCHXWzghRAEA+zhzEa9F18eGPPBr665DGDkhUFY+
L0LT5MtOWcMstQ8=
=i4yJ
-----END PGP SIGNATURE-----

--------------yvK0ecXUp04QsOjpH8gztNQC--
