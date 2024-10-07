Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E92313A40D;
	Mon,  7 Oct 2024 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728328542; cv=none; b=njgDwf4nIbjj+2mK0XDjJ8+4BCxG5QFiGbv11HXBNDD1T3A9rrwMIHAlXaBO++V/FZi4wAUkmLwlvITr1uGM4aj1tMNNnlGKhbbH8ftlMbMiyHw0pfsbGcXhS5t3+/7wQfooOwdO8z1yJ4lUyt9DQHLeRZmKWb7//Y3PbmGwwmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728328542; c=relaxed/simple;
	bh=DQS82RjBN3HvITOXFCpiTqjfE6j4bhj7PhZlljv7tD4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCEByLCCFAuU9/fG/32wt9mrVCvegi1SeI4rWS85F7KdfcxuIu7KKVvfUzW4xLadn+U9tLsB6tXvIjUyo050eyNyz9JTlR98QqClt9AxbSuz7aWZb9fJCUt68BYL5zf3fkhdQEqXnyone7zomLx+Q/U1aB3qbMji0Kde6DQtCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=a2dzfkXH; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="a2dzfkXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=s32t4fuewfdp7kz73kroomwn4i.protonmail; t=1728328532; x=1728587732;
	bh=DQS82RjBN3HvITOXFCpiTqjfE6j4bhj7PhZlljv7tD4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=a2dzfkXHy5fEcQGb0pAp8M9IV5yTa/opCStftxokTddjl5sGKIh/OIS6S0d2VYRVR
	 6HE8spV9nFDCADZywsAAIJr9oibjloza22gnPmftFU6Bi39t/mFsy7lQpyAwt5QzY2
	 9ErTQLO3sTUdQ+TLKTvsXVLJ3A0EEzdKr56O88KEnbJGZuDP/CRPPILWyxNZFBtfY1
	 jcU4egShMvE14m28Fa1m3xKvkiIBakW5I/tsMKoSdGlr1c/J6YBTQk6/HIwc3yA1au
	 L1vkas/CjxzPv3QVU1z9wrUTfPzaw5Im32ksbcYqoTm0bPlTUmJ4GB5gBUxZCR9+Hg
	 qBhK3uIjik8ag==
Date: Mon, 07 Oct 2024 19:15:27 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: add check for btree id against max in try read node
Message-ID: <YYqtQ3LHwPRNwdc7cnA2de3ng6TXMh5UQZ5DbBC1gT4K7Ksd9n7zI6h9saJ7KAQDaBOQ7T1EVo9eEkTELyGsloBLPJqOH8eo9JrqaSEDDs0=@proton.me>
In-Reply-To: <lxq42z72rrcoqmcj6z4rvesjvxoxf3q7dss666pjyzao4gaftt@tiayr4siis3z>
References: <20240929142348.4028284-2-pZ010001011111@proton.me> <O4rJH-M2oslervXHx_G8BgaihhTfNDOLBvBL3_-k-xQ5v3RLnZ1m8WfhBENbliRTjeQV-22K7tqvKJzgLNeV2A72qKLNmFl5KBa_Y65unyo=@proton.me> <lxq42z72rrcoqmcj6z4rvesjvxoxf3q7dss666pjyzao4gaftt@tiayr4siis3z>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 2d1b13fbc6ca7069a1fe1d27e6c6418b599d0b0a
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, October 7th, 2024 at 5:05 AM, Kent Overstreet <kent.overstreet@l=
inux.dev> wrote:

> On Mon, Oct 07, 2024 at 02:53:13AM GMT, Piotr Zalewski wrote:
>=20
> > > Add check for read node's btree_id against BTREE_ID_NR_MAX in
> > > try_read_btree_node to prevent triggering EBUG_ON condition in
> > > bch2_btree_id_root[1].
> >=20
> > There seems to be some kind of (pro)regression regarding this issue. No=
w it
> > triggers a deadlock. I also found related bug detected by syzbot[2] for
> > which someone supplied the same patch recently and it triggered the sam=
e
> > deadlock. I will look into it (perhaps simple check isn't a proper fix
> > here).
> >=20
> > > [1] https://syzkaller.appspot.com/bug?extid=3Dcf7b2215b5d70600ec00
> >=20
> > [2] https://syzkaller.appspot.com/bug?extid=3D9f41e4b255897d99d4e9
>=20
>=20
> Your patch looks correct, [2] shouldn't be possible with it - and it
> appears to only be reported on upstream commits. I'll apply your patch.

Hi Kent,

Today I sat down to the other bug found by syzbot and retested it on
master, it triggers the same deadlock warning[3]. It seems like in
bch2_replicas_entry_validate mutex doesn't have to be always acquired?=20
Also, I found the issue for specifically that warning[4]. The "count" is
high for the issue, is there some patch for that already pending? I=20
couldn't find any.

[3] https://syzkaller.appspot.com/bug?extid=3Da1b59c8e1a3f022fd301
[4] https://syzkaller.appspot.com/bug?extid=3D4d24267b490e2b68a5fa

Best regards, Piotr Zalewski
