Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE28EEBB
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Jun 2025 10:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749377129; cv=none; b=pgZtlPVMxlZT4FJvW6VumY/PJAxPr0eYfoAwz2SBQQhNdZsdnPdmwoI8hvpEHDVOSa6BrN4tVhSQNp3fDuFyrlO6MUM6djTdjA+tTOHJYMC2HMt/eVEEyiTrwaC6D6+yj39vmTdvU79XVOYEfO+wXScHqmhFfFxgBhUBKn41amo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749377129; c=relaxed/simple;
	bh=096XEeidvdZgvsE2wcP6DO/2tjvd6JH325/XkcgAC8M=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fZz5EB5nKBC/vM2gyfxJtPEF9wqGhNNQQ1ixe80CHF4Isbds/E5AqVCsY6bfgEpvaFzXJwU+Nz3ASqf5XFRGXyt0KqtgFuOMN6k4H+K5XpTCet8Gfjh8ACaW2vfoBPMnyDwx1nRzIg2PCqtDU2TgECI03oevrHagQ+TiO0gShmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ju0AzCdW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ju0AzCdW"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235ae05d224so32038655ad.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 08 Jun 2025 03:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749377127; x=1749981927; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iKi+gI65MPA6tifT7yylnpCdteVwUfk8UZu4qsdvRY=;
        b=ju0AzCdWKi2wvIpsM0Rwo49jR9uezPz45YjjqS8hmM2+ag+/9tjOP0YeGtXKWXiIHv
         QMA1ys7sn8T569vXouxq7RVyz/6qzSV+LDQKVheo/SYMQjsE4naoevg2bUTkQKaN33eK
         maJfCk3Ij6tZ2kRMC7j6huqFGLzi2JsRjMwCRxMMvCwOX0AdrvAeo6YSCpfVDOlOkBdY
         Y996HTIX3KW80R8z/GdnqlQEcET/H4vIvkpTQ4Z/scc2hjMFi9AIHULq0UsDrjnzXPPp
         6HN5W0MFsSicisJxAnLMRNgnQUTV9NlOlPDAjrtiJZCBMXsysgpSL2tWZvv8ZeFeyssV
         6OqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749377127; x=1749981927;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9iKi+gI65MPA6tifT7yylnpCdteVwUfk8UZu4qsdvRY=;
        b=kgBj2bXX/u/jStFBg6nl6ETQxbg+CMRJok75pV1ER41LFCyka0dSqIm86w80xM9moR
         pPKfLip1zBYCZLppKTRQbTMaPRJiDrS6otjDk9w5cokJzxftjuwdJy6iBv82+I2yW2Jc
         0tMXskn2N4048TX/q6WqQo6xwr1z1mlmziDBM0CqAARj3Zutz4qlJokbZ5310CBPPww/
         GrwwBvuYfJ/AgQdU4r2gkKck2ztAhVkwjfnu7Zu7dp9s34gYwghOUIAZE/WaXNkvu013
         UvEKbIlCGt5Pza8iz/fyZ+YU6JGbSHoJ+JO4cH5tBY3Pc1uUjyuKLPTo8sS2kjqOmZEQ
         p3WQ==
X-Gm-Message-State: AOJu0Yz9xt61UQGYgWYmXDYJVMB/AVWHFSXkrGwmTKkLa4MKGNd9uNZ2
	7vFdPAJBJo69O/Xq6BiUpur0ev0EjulIebb5sYYFJNPpLjya/vWrVrCGoFOYEg==
X-Gm-Gg: ASbGncu0Nrr3ByJNLw4rv5N/h/utwkg+E58Bmmn7+kQ6nCJPbExp7HnWV0Jmv1XMdUw
	4YVb7NjdmDuT50xTWf7Wmo9A0C8tQrgheRIFaApzqTEHMXgzpci5Eu45hNltY+XWxySLDeeXTJi
	i0aqoDLvBv2imj60MUEcDAO04TzS8TJ5jKDX7OLjO/U0wyK9PfgO5uLmy1n3wY+vrv2Qb7K5Ph/
	ivw8ImIeQtoFrgsj7g5DULXU+at23uvg+moEsQ6Yt8ZjOH0DkOTIqAYH3E/KaWVdYp65CqNBKei
	uiLuCy+9MGbJUsk2GmFR6yY19+Jf9dlWPWIlkETlY8XFdg==
X-Google-Smtp-Source: AGHT+IHwHl3WRUXdndTZjYp2UCFQF3B/dT4iJaNG6V6Gn9JUCWKL2ZodY9QJq2noWxxcyBLm6AHV6g==
X-Received: by 2002:a17:903:1447:b0:234:595d:a58e with SMTP id d9443c01a7336-236136a31bcmr72434125ad.25.1749377126835;
        Sun, 08 Jun 2025 03:05:26 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603410969sm37337655ad.211.2025.06.08.03.05.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Jun 2025 03:05:26 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcachefs: Re-add seemingly duplicate bch2_trans_begin()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250608002847.1871960-1-kent.overstreet@linux.dev>
Date: Sun, 8 Jun 2025 18:05:11 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A9A09A25-4737-4022-A6FA-E9C45EDB320B@gmail.com>
References: <20250608002847.1871960-1-kent.overstreet@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jun 8, 2025, at 08:28, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> Include a comment this time - we can't call iter_init() in a =
transaction
> restart, and write bufer flush doesn't guarantee that we aren't in a
> restart when it returns.

Why would it related to iter_init(), bch2_trans_begin(trans) is at the =
top of  for_each_btree_key_max


>=20
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
> fs/bcachefs/movinggc.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index 6d7b1d5f7697..697d58b0bf91 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -154,6 +154,12 @@ static int bch2_copygc_get_buckets(struct =
moving_context *ctxt,
> if (bch2_fs_fatal_err_on(ret, c, "%s: from =
bch2_btree_write_buffer_tryflush()", bch2_err_str(ret)))
> return ret;
>=20
> + /*
> + * we might be in a transaction restart from write buffer flush, =
start a
> + * new transaction before iter_init -> path_get
> + */
> + bch2_trans_begin(trans);
> +
> ret =3D for_each_btree_key_max(trans, iter, BTREE_ID_lru,
>  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, 0, 0),
>  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, U64_MAX, LRU_TIME_MAX),
> --=20
> 2.49.0
>=20

