Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04F74594A
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Oct 2025 11:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760181496; cv=none; b=KMjre3YcP4uUuzecL9AP8C61f9Q3/i9Y5yBKuyu76XBfLXNpU6rV2L0MP7S8ol3LvuooHKApy8Ok7LD76BtjEb8SN+1Z+8L/5XoPEChIeJ9WD/n3R3WP4uxjGxntxOqyoJi8Q7qSkjSwBve0sQLj75fH3lR6Ifvs+xkcG8NpU00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760181496; c=relaxed/simple;
	bh=VazwT1cFhW7cMHnVRSNdLvkMi+IvwhogMnXQshRAQBM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=fbKLCdn6rHaXiIq25o1HBttPWQiGy0Z32GP5PvKFo/FQBVCPQ9qHDlBcWEV+GflDWllnjvo/apOve2HuMIgmO5aBDXf46MtUqP8+aiwpswJ8Z5Mnnhf656HAidKdHmJkZJX4jWH3Z4xzXKRwlqucYt7PvLHt2h8+/NpJOBFm+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=WH3BLBVx; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="WH3BLBVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760181488; x=1760786288; i=devzero@web.de;
	bh=VazwT1cFhW7cMHnVRSNdLvkMi+IvwhogMnXQshRAQBM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=WH3BLBVxMI9Qkgfgq3F9iifeY/bQQ6O5Cuk1v62JMwklQRLrJwnb9LpBKYq/HQ5n
	 iPNIMbqLFUsugjuBXXG1gzoE8OdJXsbYqQPC2ECEF0QeqcxdDQZ+Ag7IkNiBkf4zk
	 5TZK9PCAwHPs4PKhax/Xv6dxF69YcspMckAR9AE/5mDs4tYganBAoTP2jGi0AvVGO
	 uTemG1c52ba7+DofjCF05deX5cZRMB8suoj9S+vlvKZe34RYq7Ko5uIOax9Y7Nbpz
	 7Y7D+rv6e2+57jNHDzbDKr2+xFWAXG2wxFnYjycGnve8uughBRStvNCYp/aGxYkIq
	 Zl3anV3V01SY4BHFbg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.107] ([87.78.141.14]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MLARU-1upSlJ3YzC-00S9Js for
 <linux-bcachefs@vger.kernel.org>; Sat, 11 Oct 2025 13:18:07 +0200
Message-ID: <1fe84ce2-bee8-4a4b-816c-d81e9675d691@web.de>
Date: Sat, 11 Oct 2025 13:18:07 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-bcachefs@vger.kernel.org
From: Roland <devzero@web.de>
Subject: how can we check if a bcachefs mirror is consistent and not affected
 by kernel bugzilla #99171 ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EGP2XwvwRHkAsy5G+e2+9ZaQIlZF6XBVFoBv0oOAM3m8h7FJs4N
 1mvNJEjFGCmBiqDk1/fbPXr46j7eeZ7TBOWxQoQ9666CU8J5+Ge9EF34+Xpvqs3r9+QLWHf
 b8Ip9GALLfBmNmOEVzwJdajqtAkHgStjBFHf+XMtioO2uZdI5IX4hOfxdgbu7x4APHJlQzU
 z90K1zanLbo3cO+zA5lsw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:iBuSupyLp28=;pcI0Orst2Q/NJ7VgHSqa6v7+W/H
 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

hello,

i'm playing with bcachefs , as it's nice to see that there is another=20
powerful cow filesystem in development.

i would like to make sure that it is not affected by=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D99171 , which is about=20
drbd/mdraid/btrfs/lvm suffering from raid mirror inconsistencies under=20
special circumstances when written to using O_DIRECT.

at least i can see that development of bcachefs has focus on O_DIRECT

https://patchwork.kernel.org/project/linux-fsdevel/patch/20230509165657.17=
35798-7-kent.overstreet@linux.dev/

one question to make sure that my testing gives reliable result:

does "bcachefs data scrub /fs" scrub both sides of the mirror in=20
parallel AND while doing that, does it compare, if data blocks on each=20
device really are the same / have the same checksum , so that we would=20
see if O_DIRECT writes go wrong , probably reaching only one side of the=
=20
mirror ?

root@debian13:~# bcachefs=C2=A0 data scrub /bcachefs
Starting scrub on 2 devices:=C2=A0 sdb sdc
device=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0checked=C2=A0=
 =C2=A0corrected uncorrected=C2=A0 =C2=A0 =C2=A0 =C2=A0total
sdb=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 518 MiB=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 B=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 B=
=C2=A0 =C2=A0 =C2=A0518 MiB 100%=C2=A0=20
complete
sdc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 518 MiB=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 B=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 B=
=C2=A0 =C2=A0 =C2=A0518 MiB 100%=C2=A0=20
complete

Roland
sysadmin

p.s.:
i'm not subscribed to this list, so please keep me CC'd.

