Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3DE574;
	Mon,  7 Oct 2024 02:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728269600; cv=none; b=XgjcIVQu77B8VdOxr/BNw5wqDaYbhb1oKynygIho8VxdWXB8gwCqMaqXqhTpPEPPWbWAKdm/V+XyXAluTze46d+pg80PCYQzhomxF7YxbogCwdL72xlDt5/KiOvC+wyK1Pwrk/RpOu/n7e9XD9MeS493jBWrOfYrL3DhL8U28hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728269600; c=relaxed/simple;
	bh=881KbzcbX8SxBHoAc4rb+ELsyBUwrME/E7fkmNtqcsg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyF0Q+R2/OvHfjO8INZA2xWbBNTEe3fq93eD3t/vunkkeJ6m985s22c2tHAAgMcY9mTxN4PDV1fEb4V2uzOV5TmQi2nns147J4f36XCYMrpcGjR2te4eN1DBEc4KIlejbtj0SK6Gub6C/8HG9xAjhe9XGdsNPL1dSoW+JV4BRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=i6i8fyXf; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="i6i8fyXf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1728269594; x=1728528794;
	bh=iv7kvcuVHYOUPMvnAsML1zSU5lL8RIxypUUyiPuNsP0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=i6i8fyXfu+KoQoNlSFztXhI8nHcYWcPp89scu8VB6VDyZDQfNs9a36ZPFPVi5pSAh
	 JiUMNV4MgJBwlklCigc2Ff/PxKhaSiIxJ2Iw3UHKSd2jIZX6zgvFki9AXyfftNPhLK
	 LH7ABCflxn5Hrab/ZFL4omRy+VwpLeBTB1w4kx5OPlZWBWt97IvXGqKOK6fX3k6PW1
	 zjma06Tegb43bPgBjOHRnHtnsU6+YoOPp4NahrAk5G8aV+NFkGgW4O8pYTnL1+A5lR
	 5X9+/arMDArKH+j9ectRtJVJ/9l+IGYQ27luc0OvclalPpzDpOkIr5MuO3zB2WIKpP
	 lKzMM5kZtA0Ew==
Date: Mon, 07 Oct 2024 02:53:13 +0000
To: Piotr Zalewski <pZ010001011111@proton.me>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: add check for btree id against max in try read node
Message-ID: <O4rJH-M2oslervXHx_G8BgaihhTfNDOLBvBL3_-k-xQ5v3RLnZ1m8WfhBENbliRTjeQV-22K7tqvKJzgLNeV2A72qKLNmFl5KBa_Y65unyo=@proton.me>
In-Reply-To: <20240929142348.4028284-2-pZ010001011111@proton.me>
References: <20240929142348.4028284-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: d562aeb5bf30fab3ce34254b0df7b4632698ff28
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> Add check for read node's btree_id against BTREE_ID_NR_MAX in
> try_read_btree_node to prevent triggering EBUG_ON condition in
> bch2_btree_id_root[1].

There seems to be some kind of (pro)regression regarding this issue. Now it
triggers a deadlock. I also found related bug detected by syzbot[2] for
which someone supplied the same patch recently and it triggered the same
deadlock. I will look into it (perhaps simple check isn't a proper fix=20
here).

> [1] https://syzkaller.appspot.com/bug?extid=3Dcf7b2215b5d70600ec00

[2] https://syzkaller.appspot.com/bug?extid=3D9f41e4b255897d99d4e9

> Reported-by: syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcf7b2215b5d70600ec00
> Fixes: 4409b8081d16 ("bcachefs: Repair pass for scanning for btree nodes"=
)
> Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
>=20
> ---
> fs/bcachefs/btree_node_scan.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.=
c
> index b28c649c6838..a24b4004e8f0 100644
> --- a/fs/bcachefs/btree_node_scan.c
> +++ b/fs/bcachefs/btree_node_scan.c
> @@ -171,6 +171,9 @@ static void try_read_btree_node(struct find_btree_nod=
es *f, struct bch_dev *ca,
> if (BTREE_NODE_LEVEL(bn) >=3D BTREE_MAX_DEPTH)
>=20
> return;
>=20
> + if (BTREE_NODE_ID(bn) >=3D BTREE_ID_NR_MAX)
>=20
> + return;
> +
> rcu_read_lock();
> struct found_btree_node n =3D {
> .btree_id =3D BTREE_NODE_ID(bn),
> --
> 2.46.2
> 
