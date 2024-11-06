Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D0207A1A;
	Wed,  6 Nov 2024 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730919491; cv=none; b=XNXN3PkzalLDIZcvO9KJDEwkehaomhexyOx0oSYirf1/YLCjMj7OWNskcZ5OlSW5j0gdL/+Fz+j30KpCxZEVhe6vAhHCNl+VUPSswyNFJ32lLryoolWKwcdFi1bQBWbNLnJo+WTJi2CaRPHo8LaYloKhZXIoEw9v7PSlVGIsno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730919491; c=relaxed/simple;
	bh=1SJUl3tA3a6a31XHunu4dXCE+Re7BWWToL00ihVENuw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1zoApfyvekPNC1VvLSb2TECeA+84QvKAIautjXHvgN4MCQ+YsKRR5Bi43I3U0CRim+ag1/AZP5NWKpRB5NhQgxpX0SCVnijD8v2wslfrgDziMl2LT0EY0ixctrk0paiTD9qsmtY71PYHryzJEShsPl+VPSBRPH2g076crEzY1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=JzsybBs+; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="JzsybBs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=ldyvedltf5e6jkr5fuxoye5agq.protonmail; t=1730919487; x=1731178687;
	bh=1SJUl3tA3a6a31XHunu4dXCE+Re7BWWToL00ihVENuw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=JzsybBs+dGBhcUDfVv1zTRME55roTPOUdAXbLKezkYdV3brmizJz4FdNywE8hqMwv
	 I5FqIfPuOnsBeTXlDEX+d9BmwWyiC54wLiXOQNz0ZD/slQn0Oi8PMez5RETyjrQ8+7
	 bjes4Nsaa/Ob9lk72sMh908CsowLKEbwFQNqVCIXGksfV6rJE1TWq8sb/C5GRM0wmg
	 Jzc/fThhsyTaMecLWSJoJCxaFktb5ZGOPaQYMsuqENb62XRQ6F74KgMlqfVvzxLkip
	 zUIru/0DI+II0t4zsuWBHSqyWCzZfmJdQ9IykSCO7Bw9ksBbLO933r7C/ekzClbcE+
	 0f5CsmlXZzxbg==
Date: Wed, 06 Nov 2024 18:58:04 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Subject: Re: [PATCH] Fix wrong max check in bch2_opt_validate
Message-ID: <QYWUohk8PTK2Z_y-IZBUFDFqM6BNsqv4oS95yfOP5DGWuvCNyvC6R1bizXEubPYtqm2ZpRWNN4BH9__biGJ5Ti3Yh88Ge_9HCSSAdyU1MxA=@proton.me>
In-Reply-To: <v5wttxaimwpqb5jfpxvcs3rmg27fm4mf7446slutl7ztha6q4p@434ppx3gzv7l>
References: <20241031231823.688918-2-pZ010001011111@proton.me> <pkxqQnSTQLReyYEHegx90LNp5dbR6LlpcqUIkBFa2CiL-0P48QWpGJ1YYKtWwu0IFM7H-2T4fYQz0MldP6OqZppPzmqafQDKouhETLnM5o4=@proton.me> <v5wttxaimwpqb5jfpxvcs3rmg27fm4mf7446slutl7ztha6q4p@434ppx3gzv7l>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 74232368084e9af70729c236316a1e751cd6bf8b
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable






Sent with Proton Mail secure email.

On Wednesday, November 6th, 2024 at 6:52 PM, Kent Overstreet <kent.overstre=
et@linux.dev> wrote:

> On Wed, Nov 06, 2024 at 08:11:13AM +0000, Piotr Zalewski wrote:
>=20
> > Hi Kent,
> >=20
> > Did you see this?
>=20
>=20
> Whoops, I did miss it the first time.

np

> I think it'd be better to fix it in the OPT_STR() macro though.

If changed in OPT_STR() macro it would also require a change in
bch2_opt_to_text:434 (it also does -1 there).

Best regards

