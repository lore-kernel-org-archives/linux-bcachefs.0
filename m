Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EA712E72
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Jan 2024 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706271737; cv=none; b=DS14LWCNfc/EBdCKU1ALf1ekk2yLD+tU55zkAgx11vRUjhFgA1HKg9Dsg5n95nmIsucKAsihZk2iIXtgIW2YKBljYUBjb/Njfloq3zpnKN5b48y+NWgQe6cpmPomDfKIZ2Is7uvJXkFyc6wTVjlkrerQj7xT73k8r6X64L7G3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706271737; c=relaxed/simple;
	bh=05AfKgls+6VOSQ2LEDxaQ6SPUvc9+oyrRRo+UHsCqIg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9ZtIzN5tN4S6VIRUF5R8+kYqTuUC4QO/fJ5fcJKYMIOxqaANHVcGTpyLHN3x5CCTIIB+hK09dFLLgMtSJxDxk3XZhQPyWeFH/pLTANQhMIsAdLZWtQ2ybpMUDrHXlQIL58BmkdAZnyM0hrYyeCrTDyqKxp2i0rjlPn/BD9J290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=cDCu9he5; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="cDCu9he5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1706271727; x=1706530927;
	bh=05AfKgls+6VOSQ2LEDxaQ6SPUvc9+oyrRRo+UHsCqIg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=cDCu9he58Cq8IjCQIUJ6hvS02eH2dutsHTtKZuPz4vhQXOBjYizZ6HhSpyjTx7R2N
	 kcWNDWsIP6BCoHJeHMJ4t22nA7dJzj1qxTEKx7WOpydQd/VzFHqA2P/9OnPu+EltR8
	 Q/CKb3JabY/GUNPDPLVA/IUfEm0CxmFxqoL0nCACVIYdohBzqkJAPiK9cxjgyhqgYn
	 np175tir+J5UlzlTcE9/KbjPO27ZNjZiT+iGdNip6/s+H/8HUDgI9AhS+S6e5LY8Th
	 /E7SM/oWaxf9MHzk13dmvmc5y4wyUQ/Pvj8z1ohbBSSne0sC/f3aLQBleoKcjw6mJ9
	 M65KBSRl6ZpmA==
Date: Fri, 26 Jan 2024 12:22:02 +0000
To: Martin Steigerwald <martin@lichtvoll.de>
From: RlndVt <RlndVt@protonmail.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Mounting a encrypted disk: Fatal error: Required key not available
Message-ID: <afzrkbtBglFNpOW-YIx7L6WNqdsPlgWUp9EzVxMzGXdUrzUW0Np_eVwo7EkCWWIaSNTFsZUv7TYn6zeWxLH3qa_tuB-tCNhoQeGZbb5DG4c=@protonmail.com>
In-Reply-To: <6015419.lOV4Wx5bFT@lichtvoll.de>
References: <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com> <6015419.lOV4Wx5bFT@lichtvoll.de>
Feedback-ID: 63185315:user:proton
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Martin

On Thursday, 25 January 2024 at 23:54, Martin Steigerwald <martin@lichtvoll=
.de> wrote:

>=20
>=20
> Hi Roland.
>=20
> RlndVt - 25.01.24, 21:10:25 CET:
>=20
> > I'm having difficulties mounting a new array I've created:
> >=20
> > # bcachefs mount /dev/sde /mnt/vault/
> > ERROR - bcachefs_rust::cmd_mount: Fatal error: Required key not
> > available
>=20
>=20
> This has been discussed before. A possible work-around is:
>=20
> Re: Error while unlocking encrypted BCacheFS: Required key not available
>=20
> Date: Tue, 16 Jan 2024 11:59:08 -0600
>=20
> https://lore.kernel.org/linux-bcachefs/
> CACmrr9gQeXccyS9ZRiR2KnTKnA6EVBCVz_YWcDC3p1mbGqgMSg@mail.gmail.com/
>=20
> I did not yet take time to test it, but I think for George it worked.
>=20
> Best,
> --
> Martin

Thanks; from the #bcache IRC I got the advice to try unlocking with the `-k=
 session` option, which worked for me.=20

Regards,
Roland
