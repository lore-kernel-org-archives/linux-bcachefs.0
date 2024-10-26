Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F079FD;
	Sat, 26 Oct 2024 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729902230; cv=none; b=rCBymvc5soNyEnBOX6UhgZp2VA81Dxv5x+jH9CtMFPvnTMlIjIy6+X1CwixDpQK8aLBrWX9bgqiaf7l6z2S4VNzllmowa4Im8CelOTc3TXlwMDYlr0SCOkzoTN0O2KGL9vR6W1Oz0NbALllOuktjZjy7kMsgeGjnK1YeBewKdCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729902230; c=relaxed/simple;
	bh=jS3ejs185tGNTmZFMZBHnouuDZRFtmV11LXePLyCyhE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAYR91NCUkBeCFUS7kfGplF9Xv6w5iUvJNwH/PTuiGokkimKDLrIM2D7GTPsDiVxRpTv4eKMzcuiQB8qDmZ3qx15/aj0/AkX7xBjHTXiRdzsoEGkl/B5UrjnaxSEsyYKZix4Vr8aBnbnYQ4G7jlX84L772DyR1FrbTBn7F2KN2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Q1UX8Ht8; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Q1UX8Ht8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729902226; x=1730161426;
	bh=jS3ejs185tGNTmZFMZBHnouuDZRFtmV11LXePLyCyhE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Q1UX8Ht8DPo8UnJ2A1cZI/oV0gEDkFO8+nSsJSBDXcs8Ld0qF9+nB/9wvbisxNDBj
	 yPoha50GaePxPNIr/ypfrVnEKlKgHIvOjbImvpzIdDZ+B+2GTLFWA4PY5xtnAb4Ac3
	 MB5a8BMJGheXUaamdgzMuZ/5jnj8qrfvFAjE6ADj0TjN4Wwn/egPDc5swA4qDRGXyG
	 9jKWKiC1QD4L8Oz7LAMhCAlfLoOUJ95AOA2F2Fr17Da61p8aViZedcRIU7XUjXfBe3
	 h4n7vvbp+Kd7LACt846ANkiIr5t76711jFY2BJhXvMOVi64t5DzE5K2ESmURLIhwz+
	 Ebap+Ah7SfPNw==
Date: Sat, 26 Oct 2024 00:23:40 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <bYeu9DQqsfsNY3FFRdkXqypW-RCyXXx63_QipilBHZIJDJluqBfaaSpO4YkudfinbGDsq91vJFmvQOge3BFGL5AkUqswR4eIpGwbwz41fIM=@proton.me>
In-Reply-To: <6uve5q7c6o4bvuifa2klcwpussxpy5cvcjf2pqdezfuvneqjaz@kdj67a2ehnrf>
References: <20241023072024.98915-3-pZ010001011111@proton.me> <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com> <udcnrneobxa2nmwg47jrks6j67bsulaw7s43oldd5l3ge5wunp@r5rzrwwgzls6> <6uve5q7c6o4bvuifa2klcwpussxpy5cvcjf2pqdezfuvneqjaz@kdj67a2ehnrf>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 1c07ddfc4cfcd67dab686b6dc2de36e5c8312ff6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable






Sent with Proton Mail secure email.

On Saturday, October 26th, 2024 at 2:16 AM, Kent Overstreet <kent.overstree=
t@linux.dev> wrote:

> On Fri, Oct 25, 2024 at 08:11:50PM -0400, Kent Overstreet wrote:
>=20
> > On Wed, Oct 23, 2024 at 03:33:22PM +0800, Alan Huang wrote:
> >=20
> > > On Oct 23, 2024, at 15:21, Piotr Zalewski pZ010001011111@proton.me wr=
ote:
> > >=20
> > > > Add NULL check for key returned from bch2_btree_and_journal_iter_pe=
ek in
> > > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > > bch2_bkey_buf_reassemble.
> > >=20
> > > It would be helpful if the commit message explained why k.k is null i=
n this case
> >=20
> > This code is only for iterating over interior btree nodes - k.k is only
> > null when we have a bad btree topology (gaps).
> >=20
> > Piotr, could you add a comment to that effect?
>=20
>=20
> Actually, not just that - when this happens we should flag the
> filesystem as having topology repairs, and possibly start topology
> repair.
>=20
> Calling bch2_topology_error() will do that.
>=20
> We definitely want to log an error message, too; it should reference the
> btree node we're iterating over and explain that it's missing child
> nodes.

Thanks for the clarification. I will send v2 tomorrow :)

