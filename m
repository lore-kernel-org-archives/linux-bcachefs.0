Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180971D6DB5
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Oct 2025 05:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760420869; cv=none; b=q30jlEZPbTKGyMeNgZhSsYRPF2sPEM5FBEs0Exdyx/24coN8H2vT4oklbU+IGLzkUTyWakedFw8PrCN19I81f0/N8r6Acs/+urayWcxWyuy4KlyChGaDkPVItAaMwWaI35v46dnqONGBgtUkimNeFqVf+gHGhGNJJNjCJdZYZzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760420869; c=relaxed/simple;
	bh=euTph/IiVlbToNrEOW3TaBdy/mvkCjr1ehUNjRJaVY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBCYJ+TVQd4C8Je3IeOSYSeyX+rPYlqleNAy5ZGc+XkR2GzILeuFBdWYKiUUzdPOVpi7W35oQckkl06MNSPPo3hqF/cBaSEVznNjn6wZ46gtATjpLz88E4SxetmXFD/fpXa+uMlb6IzFZx6ijCMrX5snnUruKeN0X+lZIjYkqPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6C8971565FF;
	Tue, 14 Oct 2025 05:47:37 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Roman Lebedev <lebedev.ri@gmail.com>
Subject:
 Re: Debian repository: missing release channel (was: Re: bcachefs: DKMS
 availability/migration general announcement)
Date: Tue, 14 Oct 2025 07:47:36 +0200
Message-ID: <2805390.mvXUDI8C0e@laptop>
In-Reply-To: <8592586.T7Z3S40VBb@laptop>
References:
 <wpunhwfhumd76tzitnd3zoxnpwq6ipxxzq7rx2igxmtpsr6jns@k3ip5mm6mxtj>
 <8592586.T7Z3S40VBb@laptop>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi Kent, hi Roman, hi.

Martin Steigerwald - 12.10.25, 16:01:16 CEST:
> It appears to me that the release channel "release" is gone since some
> days:
>=20
> Ign:3 https://apt.bcachefs.org/unstable bcachefs-tools-release InRelease
> Err:4 https://apt.bcachefs.org/unstable bcachefs-tools-release Release
> 404  Not Found [IP: 2a[=E2=80=A6]f3::1 443]
> Error: The repository 'https://apt.bcachefs.org/unstable bcachefs-tools-
> release Release' no longer has a Release file.

With 1.13.8 the release channel became available again.

Thanks!

Best,
=2D-=20
Martin


