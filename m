Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD643CF45;
	Mon, 12 Feb 2024 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707753142; cv=none; b=dFhsrK8HKWTE41VFVQifodiIRWdYLtZohSf2QhPZN2zXlLAvgSlGt/0OeybTPwaIQ2dks2f/AyOqJTagczHDjzkaGjsdsiDjntJQb4/O/cFT5eWQzH1QJTD6fPXcIzpVdXZm2oH1NgLDxQBlZBG2ZZC02OUSgXCnVYdm0soaVE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707753142; c=relaxed/simple;
	bh=gv2GhH8lA7e+BegMfuoFr5juDlHcR6ol8Y92EvU+GNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrodZAp3X81XLCbG8KfD69TxCTFn1ubIHdEtxfIiu9pILdkZS2/+pdiTUfjedevdF0Cxkyq6uKNcxxpmJBC2iL8mWe58+j6y3jKEroy9qZGKOvQFXynhU27Vyaxdwz0I3MQdmH1VsdrpZESr2hcbnQvoUwQL2Z/Tw7uTj9mkesE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EBF968978A1;
	Mon, 12 Feb 2024 16:52:10 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-usb@vger.kernel.org,
 Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
 linux-bcachefs@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Date: Mon, 12 Feb 2024 16:52:09 +0100
Message-ID: <6599603.G0QQBjFxQf@lichtvoll.de>
In-Reply-To: <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
References:
 <1854085.atdPhlSkOF@lichtvoll.de> <5444405.Sb9uPGUboI@lichtvoll.de>
 <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Kent Overstreet - 11.02.24, 19:51:32 CET:
> On Sun, Feb 11, 2024 at 06:06:27PM +0100, Martin Steigerwald wrote:
[=E2=80=A6]
> > CC'ing BCacheFS mailing list.
> >=20
> > My original mail is here:
> >=20
> > https://lore.kernel.org/linux-usb/5264d425-fc13-6a77-2dbf-6853479051a0
> > @applied-asynchrony.com/T/ #m5ec9ecad1240edfbf41ad63c7aeeb6aa6ea38a5e
> >=20
> > Holger Hoffst=C3=A4tte - 11.02.24, 17:02:29 CET:
> > > On 2024-02-11 16:42, Martin Steigerwald wrote:
> > > > Hi!
> > > > I am trying to put data on an external Kingston XS-2000 4 TB SSD
> > > > using
> > > > self-compiled Linux 6.7.4 kernel and encrypted BCacheFS. I do not
> > > > think BCacheFS has any part in the errors I see, but if you
> > > > disagree
> > > > feel free to CC the BCacheFS mailing list as you reply.
> > >=20
> > > This is indeed a known bug with bcachefs on USB-connected devices.
> > > Apply the following commit:
> > >=20
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/c
> > > ommi t/fs/bcachefs?id=3D3e44f325f6f75078cdcd44cd337f517ba3650d05
> > >=20
> > > This and some other commits are already scheduled for -stable.
> >=20
> > Thanks!
> >=20
> > Oh my. I was aware of some bug fixes coming for stable. I briefly
> > looked through them, but now I did not make a connection.
> >=20
> > I will wait for 6.7.5 and retry then I bet.
>=20
> That doesn't look related - the device claims to not support flush or
> fua, and the bug resulted in us not sending flush/fua devices; the main
> thing people would see without that patch, on 6.8, would be an immediate
> -EOPNOTSUP on the first flush journal write.
>=20
> He only got errors after an hour or so, or 10 minutes with UAS disabled;
> we send flushes once a second. Sounds like a screwy device.

Thanks for that explanation, Kent.

I am the one with that external Transcend XS 2000 4 TB SSD and I
specifically did not CC bcachefs mailing list at the beginning as after
seeing things like

[33963.462694] sd 0:0:0:0: [sda] tag#10 uas_zap_pending 0 uas-tag 1 infligh=
t: CMD=20
[33963.462708] sd 0:0:0:0: [sda] tag#10 CDB: Write(16) 8a 00 00 00 00 00 82=
 c1 bc 00 00 00 04 00 00 00
[=E2=80=A6]
[33963.592872] sd 0:0:0:0: [sda] tag#10 FAILED Result: hostbyte=3DDID_RESET=
 driverbyte=3DDRIVER_OK cmd_age=3D182s

I thought some quirks in the device to be at fault.

However while Sandisk Extreme Pro 2 TB claims to support DPO and FUA I see

Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

also with other devices like external Toshiba Canvio 4 TB hard disks. Using
LUKS encrypted BTRFS on those I never saw any timeout while writing out
data issue with any of those hard disks. Also with disabled write cache
any cache flush / FUA request should be a no-op anyway? These hard disks
have been doing a ton of backup workloads without any issues, but so far
only with BTRFS.

I may test the Transcend XS2000 with BTRFS to see whether it makes a
difference, however I really like to use it with BCacheFS and I do not real=
ly
like to use LUKS for external devices. According to the kernel log I still
don't really think those errors at the block layer were about anything
filesystem specific, but what  do I know?

With UAS enabled for Transcend XS2000 I see:

Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

This sounds about right: Without cache flush / FUA request disable write
cache.

With UAS disabled, using only usb-storage, however I see:

Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Which appears to be broken to me: If it cannot do cache flush / FUA it
should have write cache disabled.

Thus I removed the quirk to disable UAS again. It did not help anyway.

However when I look at the output of "hdparm -I" for that Transcend XS2000
none of this makes sense. Cause it blatantly advertises to support

[=E2=80=A6]
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
[=E2=80=A6]
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
[=E2=80=A6]

It has firmware revision S9K00107. I see whether I can get this updated
in case any update is available. Which is not obvious to me as Kingston
only offers to download a Windows application to update the firmware.

I asked them how to do an update on Linux. But am also prepared to run to
a friend with Windows system to do the update.

There is no urgency in this, so let's see whether a firmware update may
fix anything. In case someone has any additional insight, feel free to add
it. Otherwise I consider it case closed unless I retest with either Linux
kernel 6.7.5 or 6.8-rc4 and/or after having made a firmware update
if available.

Maybe also some other quirks would need to be enabled for that
device? I tested it with:

% cat /etc/modprobe.d/disable-uas.conf
# Does not work with external SSD Transcend XS2000 4TB
options usb-storage quirks=3D0951:176b:u

but as explained that did not help and thus I disabled UAS disabling
quirk again.

Best,
=2D-=20
Martin


