Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F42AE7C
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747473161; cv=none; b=SDwsUhir3hT9OPlTEKAzfpI7ROJbdM8Sf5tBIu2mlYG1Me0Gu9PsddVjtpFZbHPVhObExBxIiHsY7/OBo+uQAyW6bkXZdgVLXhPTFSK1VPXP032jDp/4pSgnrvBKiA3yptqaIiySYqHvKTpcfHIKCxpVP/P+jj9tbUHnlo1CL2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747473161; c=relaxed/simple;
	bh=23OfVFdZqO30Sw/L/ApsH75WpQN8oQ806FNmNH/ONl4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ClSzMj9AESZhnXTzOUSbFJQ2Bcyj6iKaf43LaP2Jdz3C9BvrPScp12vI15su1Vd84sDKxkT8P2LMka0zMRjVdXjU5D8/YTNpkG55mM9whAUs1AXjgvGpoeEeNOxzM6i8QRcYR2dU3mg9VLgbMBT4/DlInFJwAtzbvcvwJWctKIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 912ACFB7DA;
	Sat, 17 May 2025 09:12:29 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org, Pavin Joseph <me@pavinjoseph.com>
Subject: Re: Status of rebalance and scrub support
Date: Sat, 17 May 2025 11:12:29 +0200
Message-ID: <4984817.GXAFRqVoOG@lichtvoll.de>
In-Reply-To: <c76f1900-de04-422e-b6eb-12453d982ddf@pavinjoseph.com>
References:
 <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <c76f1900-de04-422e-b6eb-12453d982ddf@pavinjoseph.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi.

Pavin Joseph - 17.08.24, 19:17:18 CEST:
> Gentle ping, anyone? =F0=9F=A5=BA
>=20
> On 8/7/24 11:07 AM, Pavin Joseph wrote:
> > Hello everyone,
> >=20
> > Is there an ETA available for full rebalance and scrub support?

I take it that scrub support is not yet fully implemented?

I am not really asking for an ETA =E2=80=93 it will be done when it is done=
 =E2=80=93=20
however I am not sure whether scrub is not yet fully implemented or=20
whether I am facing a bug:

% bcachefs data scrub /mnt/tmp
Starting scrub on 1 devices:  dm-6
device   checked   corrected uncorrected  total
dm-6     0 B         0 B         0 B      17.2 GiB    0%  0 B/sec

(quick test filesystem formatted with bcachefs format without additional=20
options on LUKS encrypted LVM)

Stays there until I Ctrl-C it. I waited for a bit more than 5 minutes. No=20
disk I/O to the logical volume.

Self-compiled bcachefs-tools from 1.25.2 tag (displays version 1.25.1=20
still) on self-compiled kernel 6.14.6 on Devuan Ceres. bcachefs-tools with=
=20
tiny patch to Makefile to recognize eudev for determining udev directory.

Best,
=2D-=20
Martin


