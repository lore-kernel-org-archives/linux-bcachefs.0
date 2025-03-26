Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD042A97
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742996749; cv=none; b=hnKd5w0QfxmdGEN54h84nFVX0pqsqjHCDXaJcZtcuYtz4AcFh0IlyjftFThgPF4aYVc0XH8EpNP1LPCdgX9xlNOB2zPrUSEum5ZasN1no+rRI/iwIp4+XJDYV3Kv2PG5HqjgFxCwi8EN63ErbXBPj/2EiRIOvWOmSN2TfW5xvSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742996749; c=relaxed/simple;
	bh=sDFww4oViWj/jvG0iFv7BEpmmRmDoHLp4r4Q/DIvMfY=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=DztTierbvbIDKln+QuSN/Es4R/OsyslmIS69TP6vftbyfeyiCq8w5sITZstg+dYo4JUWV7ijlVYFoOpAoe3QgwCuIh+IkWn1V9Vyq/1bkCGKMSXDFvQxEz5DAuq4JOlW1q9bxUkKhkDIeiVSiALUJbBEPDHWRT0T9pb6D2ggOXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 62F2C1E4AB;
	Wed, 26 Mar 2025 09:45:40 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 0BEBAA0EB0; Wed, 26 Mar 2025 09:45:40 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Message-ID: <26596.1284.21693.708998@quad.stoffel.home>
Date: Wed, 26 Mar 2025 09:45:40 -0400
From: "John Stoffel" <john@stoffel.org>
To: Krzysztof Hajdamowicz <krzysztof@hajdamowicz.info>
Cc: John Stoffel <john@stoffel.org>,
    Malte =?iso-8859-1?Q?Schr=F6der?=  <malte.schroeder@tnxip.de>,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
In-Reply-To: <fe46f2b3-ae9d-49bc-a5a0-2db5817505b2@hajdamowicz.info>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
	<26584.35900.850011.320586@quad.stoffel.home>
	<26584.36927.6100.282713@quad.stoffel.home>
	<66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
	<26585.57291.760395.430511@quad.stoffel.home>
	<3e765804-93b5-4102-8d31-0c91d44c726c@tnxip.de>
	<26586.53721.541198.490221@quad.stoffel.home>
	<fe46f2b3-ae9d-49bc-a5a0-2db5817505b2@hajdamowicz.info>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Krzysztof" =3D=3D Krzysztof Hajdamowicz <krzysztof@hajdamowicz.info> writes:

> W dniu 19.03.2025 o=A015:16, John Stoffel pisze:
>>>>>>> "Malte" =3D=3D Malte Schr=F6der <malte.schroeder@tnxip.de> writes:
>>> On 18/03/2025 22:04, John Stoffel wrote:
>>>>>>>>> "Malte" =3D=3D Malte Schr=F6der <malte.schroeder@tnxip.de> writes:
>>>>> Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
>>>>> someone pulled it of by forcing some libs from Trixie, but that caused
>>>>> other things to break.

> I am one of the people that butchered bcachefs-tools to work on my=20
> Bookworm/Proxmox 8 machine.

> The recent version of bcachefs-tools require liburcu in version 0.14 and=20
> higher.
> Debian Bookworm uses 0.13, while Debian Trixie has 0.14.

> I asked debian-backports team if they could backport it [1].  In
> response, I was informed that newer package uses 64bit time_t; This
> makes it incompatible with Bookworm and a patch would be needed to
> address that.

I was able to self-compile liburcu without any problems and I've got
bcachefs-tools working on Debian 12.  So I think the solution might be
to just make liburcu a sub-project for bcachefs-tools if the system
provided library isn't new enough.=20=20

> As my risk factor for this machine is higher than usual, I've created a=20
> setup with:

>   * LXC container initially set up with Bookworm, containing all build
>     dependencies.
>   * I recompiled liburcu8t64 from Trixie to Bookworm
>   * The package was then force-installed - rendering dpkg package
>     database with conflicting dependencies.
>     apt-cache rdepends shows that xfs and glusterfs depends on working
>     liburcu.
>     Since I do not use either of them, this is something I can live with.

I just installed liburcu into /usr/local/lib and setup my
LD_LIBRARY_PATH to include it as a quick hack.  I really need to try
and tweak the bcachefs-tools Makefile to hardcode that path into the
binary.=20

>   * Then I built bcachefs-tools
>   * The resulting bcachefs binary and liburcu8t64 packages were copied
>     to the target system.
>   * Finally, I force-installed them, leaving the dpkg database with
>     broken dependencies.

> 1: https://lists.debian.org/debian-backports/2025/01/msg00003.html
>>>> So what is the best Linux distro to use to compile bcachefs-tools?

> There is none until you transfer compiled binary with its dependencies.
> # ldd bcachefs-tools/bcachefs
>  =A0=A0=A0 linux-vdso.so.1 (0x0000749f55207000)
>  =A0=A0=A0 liburcu.so.8 =3D> /lib/x86_64-linux-gnu/liburcu.so.8 (0x0000749f54db5000)
>  =A0=A0=A0 libblkid.so.1 =3D> /lib/x86_64-linux-gnu/libblkid.so.1=20
> (0x0000749f54d5e000)
>  =A0=A0=A0 libuuid.so.1 =3D> /lib/x86_64-linux-gnu/libuuid.so.1 (0x0000749f54d54000)
>  =A0=A0=A0 libsodium.so.23 =3D> /lib/x86_64-linux-gnu/libsodium.so.23=20
> (0x0000749f54cfa000)
>  =A0=A0=A0 libz.so.1 =3D> /lib/x86_64-linux-gnu/libz.so.1 (0x0000749f54cdb000)
>  =A0=A0=A0 liblz4.so.1 =3D> /lib/x86_64-linux-gnu/liblz4.so.1 (0x0000749f54cb3000)
>  =A0=A0=A0 libzstd.so.1 =3D> /lib/x86_64-linux-gnu/libzstd.so.1 (0x0000749f54bf7000)
>  =A0=A0=A0 libudev.so.1 =3D> /lib/x86_64-linux-gnu/libudev.so.1 (0x0000749f54bc9000)
>  =A0=A0=A0 libkeyutils.so.1 =3D> /lib/x86_64-linux-gnu/libkeyutils.so.1=20
> (0x0000749f54bc2000)
>  =A0=A0=A0 libaio.so.1 =3D> /lib/x86_64-linux-gnu/libaio.so.1 (0x0000749f54bbd000)
>  =A0=A0=A0 libgcc_s.so.1 =3D> /lib/x86_64-linux-gnu/libgcc_s.so.1=20
> (0x0000749f54b9d000)
>  =A0=A0=A0 libc.so.6 =3D> /lib/x86_64-linux-gnu/libc.so.6 (0x0000749f549ba000)
>  =A0=A0=A0 /lib64/ld-linux-x86-64.so.2 (0x0000749f55209000)
>  =A0=A0=A0 libpthread.so.0 =3D> /lib/x86_64-linux-gnu/libpthread.so.0=20
> (0x0000749f549b5000)

>>> I'd recommend you join #bcache at OFTC. This kind of things has been
>>> and still is discussed there and people have found solutions that
>>> worked for them regarding -tools vs Bookworm. My personal "solution"
>>> was to upgrade to Trixie.
>> Is there a base OS (Fedora?) that people use for development

> As far as I know, most of bcachefs development happens on Nix.
>> which I can use to cross build a package for Debian?
> I would suggest upgrading to Trixie. I can't as Proxmox is not=20
> compatible with Trixie yet.

