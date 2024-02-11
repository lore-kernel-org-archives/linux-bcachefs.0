Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A959149
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Feb 2024 14:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707660813; cv=none; b=ZEAzo+AcROyZANpo19wyR9RAyhvYwStyZImeYZP+wtCC80zCahAOHHFfpXc+VI6tzAHSC/qdbJpLCydOeJ2sHRpnmtdIRd1/AhAShm7TarsPP+jTYWH1iqd++1h41lIa+1QAa9KC69E9JcOvG668KrO2H1luhgRefnk2uV1UK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707660813; c=relaxed/simple;
	bh=5rjg83ReskTlKYBy2FIOP5hPUR5ycbKc9ckwcnc9jzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJW5/XUNd1dCbEh2tYMeEaFwQVMrpCI1XTQ8ilKypXSK3zuKQ3wF48gG71wO9qQEXos5nJi6zkg31E4i7a0ealHrRqg0ku+PUiKcVxE1BSIxQqyYQC3U2iWs0HItuyCKKRRrhdgriIfpz3H2FCQtr2NYRHGcwEzXkmVnf3lKRpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A484C8961FA;
	Sun, 11 Feb 2024 15:13:26 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: RlndVt <RlndVt@protonmail.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject:
 Re: Mounting a encrypted disk: Fatal error: Required key not available
Date: Sun, 11 Feb 2024 15:13:25 +0100
Message-ID: <6018852.lOV4Wx5bFT@lichtvoll.de>
In-Reply-To:
 <afzrkbtBglFNpOW-YIx7L6WNqdsPlgWUp9EzVxMzGXdUrzUW0Np_eVwo7EkCWWIaSNTFsZUv7TYn6zeWxLH3qa_tuB-tCNhoQeGZbb5DG4c=@protonmail.com>
References:
 <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
 <6015419.lOV4Wx5bFT@lichtvoll.de>
 <afzrkbtBglFNpOW-YIx7L6WNqdsPlgWUp9EzVxMzGXdUrzUW0Np_eVwo7EkCWWIaSNTFsZUv7TYn6zeWxLH3qa_tuB-tCNhoQeGZbb5DG4c=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi Roland,

RlndVt - 26.01.24, 13:22:02 CET:
> On Thursday, 25 January 2024 at 23:54, Martin Steigerwald=20
> <martin@lichtvoll.de> wrote:
> > Hi Roland.
> >=20
> > RlndVt - 25.01.24, 21:10:25 CET:
> > > I'm having difficulties mounting a new array I've created:
> > >=20
> > > # bcachefs mount /dev/sde /mnt/vault/
> > > ERROR - bcachefs_rust::cmd_mount: Fatal error: Required key not
> > > available
> >=20
> > This has been discussed before. A possible work-around is:
> >=20
> > Re: Error while unlocking encrypted BCacheFS: Required key not
> > available
> >=20
> > Date: Tue, 16 Jan 2024 11:59:08 -0600
> >=20
> > https://lore.kernel.org/linux-bcachefs/
> > CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com/
> >=20
> > I did not yet take time to test it, but I think for George it worked.
[=E2=80=A6]
> Thanks; from the #bcache IRC I got the advice to try unlocking with the
> `-k session` option, which worked for me.

It did not work for me. I tried

bcachefs unlock -k session /dev/sda1

but could not mount it:

error requesting encryption key: ENOKEY

The sequence

bcachefs unlock /dev/sda1

keyctl link @u @s

does work. The "keyctl" command is from the mail I linked above.

Now on to copying 1,4 TiB of data once again as Transcend XS2000 4 TB=20
external SSD does not seem to like UAS. Lots of timeouts and I/O errors=20
after a certain time. BCacheFS told a lot of interesting stuff to kernel=20
log, but that is to be expected on timeouts and write errors. BCacheFS is=20
not to blame for that.

Thus I recreated the file system and start from scratch after adding the=20
following quirk:

% cat /etc/modprobe.d/disable-uas.conf
# Does not work with external SSD Transcend XS2000 4TB
options usb-storage quirks=3D0951:176b:u

I hope it works stable with usb-storage only instead of uas.

Will provide bug report to USB people about that.

Best,
=2D-=20
Martin


