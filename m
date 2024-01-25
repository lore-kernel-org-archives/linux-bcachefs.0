Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7935125BD
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Jan 2024 23:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706223815; cv=none; b=iCVmnQ5b6wAjXRq/nRiwxs8qm3rFX0ej2fxuVDH8QJ8NRVWr5WIXKdeANy+mLvt8E+I5qEV3MlO5FSdZOiKDhlwwbF3GZEg/Mj9BEirybWapwoRJQZwsO6MSRZmLxaHAvGy2jIG112QSeBTfm2QU/uxXTORpq+YeRYCYqO7O1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706223815; c=relaxed/simple;
	bh=JuEAPIHqZ2n4rzCZmdpUY+22HewPuZlhdgKazOx9y0o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ee04HgEHsIQNA08GsoOvh60gVer6ffsXt18wehAAOkQdGdbq1Q7fF5gNnxQbeEDQc6I31qA2osK/eqM7bjIkv+CZy0Uep/Aco+YlB2GER+csYZ8VZsuXzkMJoXRg0qkN/1plOiBEeDcldPaClc8La6AqFde6WR4goU5IO9fug+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id F0C6287DDE7;
	Thu, 25 Jan 2024 23:54:04 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
 RlndVt <RlndVt@protonmail.com>
Subject:
 Re: Mounting a encrypted disk: Fatal error: Required key not available
Date: Thu, 25 Jan 2024 23:54:04 +0100
Message-ID: <6015419.lOV4Wx5bFT@lichtvoll.de>
In-Reply-To:
 <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
References:
 <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Roland.

RlndVt - 25.01.24, 21:10:25 CET:
> I'm having difficulties mounting a new array I've created:
> 
> # bcachefs mount /dev/sde /mnt/vault/
> ERROR - bcachefs_rust::cmd_mount: Fatal error: Required key not
> available

This has been discussed before. A possible work-around is: 

Re: Error while unlocking encrypted BCacheFS: Required key not available

Date: Tue, 16 Jan 2024 11:59:08 -0600

https://lore.kernel.org/linux-bcachefs/
CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com/

I did not yet take time to test it, but I think for George it worked.

Best,
-- 
Martin


