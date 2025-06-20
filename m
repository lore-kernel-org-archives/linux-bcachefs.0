Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5678828
	for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 02:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750385001; cv=none; b=HPLYof923r2uj4MKyBQzxvzaWcpYKzZBZypT1ryJNQHSjAwa32HXCg0qFviW3tJaVjkhkM8zbUCNQCvksLmiNwsScI4ZCDSA9S2k+AC9CpYU2aEuA7BeA4Dey1vu131d4ADW1h7W5aTnYNRmdsVRmo+RDnc5A0KWVmPIgTG91qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750385001; c=relaxed/simple;
	bh=bCeJUGYpxv29o3VovdChbPYfUBl9Gr8FyCLIU8MPH7g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=b+X7XMzTRYUk6v0o2yNGJovSvAO5s2NHWfMU+ZcFbILWOQkn0mbds075+MMrQChqKj1Xij6YSgw6OtKjqxCOXWpsmQV+SieLai+cyoLcM/WSEXnS8EpwXHYojo6Nwz6JbmwHmO1W8ip7e8JulrNVRF5fiGiL8hBV4ajqgi8yDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dxm/Ur6q; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dxm/Ur6q"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-237311f5a54so12834385ad.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 19:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750384998; x=1750989798; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuALnAk3r18TYR7YultT+RjawKLAOCKThVjhp0nFKjQ=;
        b=Dxm/Ur6qkNW0n5fIYJP7pSh/NX8tn1ssl22Z3h/gmPRdwVaXVhynaUKg7SwCc1d2Ym
         I+cYRRu8cUw+Hu/KrVECz0rSVRRAN3gQ395MbP+Qcdj4ahredM7sVXTcAA+8SEFH0Ggd
         B+Ps/9VKbviEF1WM1kF6SD4VAJvVKux8Y8Fw0rThR9fJJYTO4n9jqmBMk0AVmVTiYlz1
         XqGV9R9FDUsyBVdYzD2JZk5iPZtxcMR4dntf3rsInHIZis2X48fH6FRP+UD7VxcnPI0s
         ek2rUQnVTPcJDXOSUg9jVfWvRtUiqWaIovPT3e7jjLIKfQPgwL7VFCETWmD5cv6/wuvz
         uUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750384998; x=1750989798;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuALnAk3r18TYR7YultT+RjawKLAOCKThVjhp0nFKjQ=;
        b=Lcc3cpgpuQh6ikP+ZwnxucCbmlJGsCMyx6V0JSytUS7/I+pycjxAQsdZbpHUFCNLtH
         kXSE7LWPx8EOJvaT0g8UCyTNQx3yl8KJXJxlHGT8RZZ/XV4I/M3fRlI8UzI37oKcStlO
         0ydh962gDqDyyK58ovoj9GdKnVmtbJ6QyVyyE2uys1gGvbFwb6SNBn8qKvRCrEkJ2mM0
         l0dTHIUCQd1Lh5BLELZq3ODf0yEAV0xNeUO8ioTVfcCmc9pU6EocaoCL9tK4LoJld9/4
         M7iOXAwluY/xhkmAHIaVluvB48/8J3h4dRBrwZe16AopmpMIQlLNaq1ylwDZZ5sXsRi6
         MevA==
X-Gm-Message-State: AOJu0YwRkAaQBli4ULFWrchDlileGNbS+dBabnYbd4EjGrLcxITQJ/7J
	U43y4qCBoN+4laaG0yF5UvyOfXqsGUREmbyf/NQ75J0CX80noqveFnKbWQ/rbA==
X-Gm-Gg: ASbGncuB7UXwFP9tAScPiTmMeNYbTS7RVT/MECdLI8UUH0diDya7/1UKT4elvMp0Ls/
	JUnwKXdHHFUhMT2JvknrhyGkkdYibm4Hm34wtD0hYH17A8/Zsj2LERaGWM121SntLRWiDM4s8v7
	Y31C/0w/eirBSxDd1hz3e6DxFEYOCFusHNSkhsL/aRS6KLTkA+/KNejn2bBDnev/quyYLDDJTeV
	86C76L+5gmjSg+Xagmitzj5swyvPeHPxZzdzfAgwLGbdqlSGC+cJSgIdLk2TPlDmo/nbCy6HFNj
	vYdKrgX5ymP5CLQmEsbSLhrU+thpgRNKo8feRiegdnTHEA==
X-Google-Smtp-Source: AGHT+IG4VJlkMRP93isreLgTAj6T1zO0am1C19Y10W8DJDoYpNRtOMJtAcZYEuW+qnxve2Wp9hgeIA==
X-Received: by 2002:a17:903:2f88:b0:234:966c:a2f3 with SMTP id d9443c01a7336-237d9a41abdmr14673635ad.27.1750384998277;
        Thu, 19 Jun 2025 19:03:18 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d869fbfcsm5612545ad.194.2025.06.19.19.03.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Jun 2025 19:03:17 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcachefs: Refactor trans->mem allocation
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <c37jfoo6eldcxjhe5uyyxwtwb4koegnw5euetnlrs5nkxkyxbz@kiehaju5g7ek>
Date: Fri, 20 Jun 2025 10:03:03 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <93E5D6CB-99AE-41AE-AF50-A6985774222C@gmail.com>
References: <20250619195826.983765-1-mmpgouride@gmail.com>
 <c37jfoo6eldcxjhe5uyyxwtwb4koegnw5euetnlrs5nkxkyxbz@kiehaju5g7ek>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)



> On Jun 20, 2025, at 04:35, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Fri, Jun 20, 2025 at 03:58:26AM +0800, Alan Huang wrote:
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> ---
>> fs/bcachefs/btree_iter.c | 65 =
++++++++++++++++++++--------------------
>> fs/bcachefs/btree_iter.h | 14 +++++++++
>> 2 files changed, 46 insertions(+), 33 deletions(-)
>>=20
>> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
>> index 352f9cd2634f..0168c4023c74 100644
>> --- a/fs/bcachefs/btree_iter.c
>> +++ b/fs/bcachefs/btree_iter.c
>> @@ -3238,32 +3238,30 @@ void *__bch2_trans_kmalloc(struct btree_trans =
*trans, size_t size, unsigned long
>> }
>>=20
>> EBUG_ON(trans->mem);
>> + EBUG_ON(trans->mem_bytes);
>> + EBUG_ON(trans->mem_top);
>=20
> ???

It=E2=80=99s the first time we allocate memory.

>=20
>> + EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
>=20
> This can't be a BUG_ON(), it's not something we can prove can't happen
> with static analysis. It needs to be a warning (with debug info! like
> the previous warning provided!)
>=20

If new_bytes > BTREE_TRANS_MEM_MAX, we only return -ENOMEM

>> +=20
>> + bool lock_dropped =3D false;
>> + new_mem =3D allocate_dropping_locks_norelock(trans, lock_dropped, =
kmalloc(new_bytes, _gfp));
>> + if (!new_mem) {
>> + new_mem =3D mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
>> + new_bytes =3D BTREE_TRANS_MEM_MAX;
>> + trans->used_mempool =3D true;
>> + }
>>=20
>> - new_mem =3D kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
>> - if (unlikely(!new_mem)) {
>> - bch2_trans_unlock(trans);
>> -
>> - new_mem =3D kmalloc(new_bytes, GFP_KERNEL);
>> - if (!new_mem && new_bytes <=3D BTREE_TRANS_MEM_MAX) {
>> - new_mem =3D mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
>> - new_bytes =3D BTREE_TRANS_MEM_MAX;
>> - trans->used_mempool =3D true;
>> - }
>> -
>> - EBUG_ON(!new_mem);
>> + EBUG_ON(!new_mem);
>>=20
>> - trans->mem =3D new_mem;
>> - trans->mem_bytes =3D new_bytes;
>> + trans->mem =3D new_mem;
>> + trans->mem_bytes =3D new_bytes;
>>=20
>> + if (unlikely(lock_dropped)) {
>> ret =3D bch2_trans_relock(trans);
>> if (ret)
>> return ERR_PTR(ret);
>> }
>>=20
>> - trans->mem =3D new_mem;
>> - trans->mem_bytes =3D new_bytes;
>> -
>> - p =3D trans->mem + trans->mem_top;
>> + p =3D trans->mem;
>> trans->mem_top +=3D size;
>> memset(p, 0, size);
>> return p;
>> @@ -3324,22 +3322,23 @@ u32 bch2_trans_begin(struct btree_trans =
*trans)
>> trans->mem_top =3D 0;
>>=20
>> if (trans->restarted =3D=3D =
BCH_ERR_transaction_restart_mem_realloced) {
>> - EBUG_ON(!trans->mem || !trans->mem_bytes);
>> unsigned new_bytes =3D trans->realloc_bytes_required;
>> - void *new_mem =3D krealloc(trans->mem, new_bytes, =
GFP_NOWAIT|__GFP_NOWARN);
>> - if (unlikely(!new_mem)) {
>> - bch2_trans_unlock(trans);
>> - new_mem =3D krealloc(trans->mem, new_bytes, GFP_KERNEL);
>> -
>> - EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
>> -
>> - if (!new_mem) {
>> - new_mem =3D mempool_alloc(&trans->c->btree_trans_mem_pool, =
GFP_KERNEL);
>> - new_bytes =3D BTREE_TRANS_MEM_MAX;
>> - trans->used_mempool =3D true;
>> - kfree(trans->mem);
>> - }
>> -                }
>> + EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
>> + EBUG_ON(!trans->mem);
>> + EBUG_ON(!trans->mem_bytes);
>=20
> Not sure what the purpose of these assertions even is
>=20

Make sure it=E2=80=99s a reallocation

>> +
>> + bool lock_dropped =3D false;
>> + void *new_mem =3D allocate_dropping_locks_norelock(trans, =
lock_dropped,
>> + krealloc(trans->mem, new_bytes, _gfp));
>> + if (!new_mem) {
>> + new_mem =3D mempool_alloc(&trans->c->btree_trans_mem_pool, =
GFP_KERNEL);
>> + new_bytes =3D BTREE_TRANS_MEM_MAX;
>> + trans->used_mempool =3D true;
>> + kfree(trans->mem);
>> + }
>> +
>> + EBUG_ON(!new_mem);
>> +
>> trans->mem =3D new_mem;
>> trans->mem_bytes =3D new_bytes;
>> }
>> diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
>> index 09dd3e52622e..cc2c6bb6b6a8 100644
>> --- a/fs/bcachefs/btree_iter.h
>> +++ b/fs/bcachefs/btree_iter.h
>> @@ -963,6 +963,20 @@ struct bkey_s_c =
bch2_btree_iter_peek_and_restart_outlined(struct btree_trans *,
>> _p; \
>> })
>>=20
>> +#define allocate_dropping_locks_norelock(_trans, _lock_dropped, _do) =
\
>> +({ \
>> + gfp_t _gfp =3D GFP_NOWAIT|__GFP_NOWARN; \
>> + typeof(_do) _p =3D _do; \
>> + _lock_dropped =3D false; \
>> + if (unlikely(!_p)) { \
>> + bch2_trans_unlock(_trans); \
>> + _lock_dropped =3D true; \
>> + _gfp =3D GFP_KERNEL; \
>> + _p =3D _do; \
>> + } \
>> + _p; \
>> +})
>=20
> This helper is fine
>=20
>> +
>> struct btree_trans *__bch2_trans_get(struct bch_fs *, unsigned);
>> void bch2_trans_put(struct btree_trans *);
>>=20
>> --=20
>> 2.48.1


