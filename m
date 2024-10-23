Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3388A73451;
	Wed, 23 Oct 2024 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668820; cv=none; b=j2cUZzgwJtk1EeJcSxNmza/2Ogt0mknchwMZEZPQa2aNotgSW4aDFbGFoRFb7QULPXMWZUVUC71ed0tk7+/DKiLLkTmgIQH2IQOc2ThaqBb8YQaH0CInOTsaXNBNXue/6q3rLR4KoHnL/sr2JTvJXo3e1ou3kZHch31ESqgeako=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668820; c=relaxed/simple;
	bh=7/XKigXuC97EO4hBvGCC9fyMB0r05484l5DDM24QqE0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PhIsJIqDR2FVFigd/4gKa/PgE7RoPQKQVSc3k7JhHMg7tsLlRXLeX0NED5z8EDF62XQ4PssMcBTyBV5pwNd+9f/pDtbIlJ2BKJSWqe0QXmagdzZjZ4b9uF8ovWrQ+1LgpRgkgj5lnb/LPH6vKCxMQzKkoUELpOTkH11Mf5i0hKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I/PdG6ci; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/PdG6ci"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-718065d6364so3050588a34.3;
        Wed, 23 Oct 2024 00:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729668817; x=1730273617; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAjqjr6bU9AHssEjGBws6avXM1iyDJeINARZbx3wDCo=;
        b=I/PdG6ciimqmN47yBEzqSpe7sY9iQXuBBScKKjUe6ZN5j303GRn1zo1mtttAR00v+w
         ieVI2W68E0U60R0r1vv9/ptoCOE4DiPP0nE4nIlOUDVX3DwNPjq9w/VCkjC1nIIKVuEB
         tl4/xqGtVJ3lIaIIYh0ACK4zGnj4O82wf7tsve4YRg/Mb9CxAC2wJQ6gs//kQUofxEDS
         4Kxys7opoIaF/GkNxH6Te7yGQQm9OHuXT1c5YEXUv2A+LQh+UCANEJK7Hjd5vjdW343X
         dVIXmRF2MciJfxA5ed5p4ozAW3cBt8NPzHyLHXXMiRI+xOg0HTo0+2pQesFisJwQ047N
         GDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729668817; x=1730273617;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAjqjr6bU9AHssEjGBws6avXM1iyDJeINARZbx3wDCo=;
        b=R2WuPPZmm90nVWH5i9qIgSziDb6FpmAi1NFz2Ma72JzmUGrcWRTXxQ2BOMrSy5Mzsu
         CRzrqyc36G1FT/ItMvfUXaFpGrkOdjBQUGn/BYudMRjLRwN4AHxTToeGifhwnLmBy5Wr
         IMvc1TaNscN838ymJXYki9iRCO/fuTgo2KdmgnLchfphuE2mnhjMzekgytsKqV4qxcfQ
         hW264PC4swT3TEvqF8Svg6rwMUcssSiENP3mFD6CXckZ/WqkXCwLFcFygN2uQ5JPpuzi
         dOYwESnVvRgO7n6jv4bwayDJqcxcfkZVn4f6+/eAyERT6eja3ahf9P87qjTIzuAd/A15
         w6KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAlh/2yu8c7V1a6IwqcDJwLvwnePPiGOIArulgSgB93uZa1+R9fyJ39c45f+x893uobXzkgN1ZRN+YirXY@vger.kernel.org, AJvYcCXHS6dqXdPYSjQP+P1AIRkSQcIR7p07vaD8y6w0GbWnhbzk4ri7NwWCNo0I8+iuTkBHQdEhZiG5BhBkwYhg+w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3MIhCfAtMmJfbeOIW4EV+U/NqpO4axlcHdLyCl6aQlGvyq91m
	9WaTiORv0mdVVxEuer84fuzTdmFEioQEBf26pW5xcjPBpBhEjDHG
X-Google-Smtp-Source: AGHT+IHGxoTpmD1Fn7QShAC5ShitKn/rp54NuZPzOSOHSvD6BGqTyHGxlj2B9f8Elw4flKB3CQ6bVw==
X-Received: by 2002:a05:6830:6489:b0:710:f223:3e32 with SMTP id 46e09a7af769-7184b3771aemr1585741a34.10.1729668817120;
        Wed, 23 Oct 2024 00:33:37 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeabde7d5sm6128596a12.93.2024.10.23.00.33.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2024 00:33:36 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20241023072024.98915-3-pZ010001011111@proton.me>
Date: Wed, 23 Oct 2024 15:33:22 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 skhan@linuxfoundation.org,
 syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com>
References: <20241023072024.98915-3-pZ010001011111@proton.me>
To: Piotr Zalewski <pZ010001011111@proton.me>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 23, 2024, at 15:21, Piotr Zalewski <pZ010001011111@proton.me> =
wrote:
>=20
> Add NULL check for key returned from bch2_btree_and_journal_iter_peek =
in
> btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> bch2_bkey_buf_reassemble.

It would be helpful if the commit message explained why k.k is null in =
this case

>=20
> Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
> Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> ---
> fs/bcachefs/btree_iter.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 0883cf6e1a3e..625167ce191f 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -882,6 +882,8 @@ static noinline int =
btree_node_iter_and_journal_peek(struct btree_trans *trans,
> __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, =
l->iter, path->pos);
>=20
> k =3D bch2_btree_and_journal_iter_peek(&jiter);
> + if (!k.k)
> + goto err;
>=20
> bch2_bkey_buf_reassemble(out, c, k);
>=20
> @@ -889,6 +891,7 @@ static noinline int =
btree_node_iter_and_journal_peek(struct btree_trans *trans,
>    c->opts.btree_node_prefetch)
> ret =3D btree_path_prefetch_j(trans, path, &jiter);
>=20
> +err:
> bch2_btree_and_journal_iter_exit(&jiter);
> return ret;
> }
> --=20
> 2.47.0
>=20
>=20
>=20

