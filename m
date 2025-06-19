Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54966BE46
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750351997; cv=none; b=ZZrtBZPCkIIUYQoHV9E2tWwtoaIKnn2EFjaOHWdLtGPLtjOq12CzvkihENZ9GhYXNJc73EC6Z83Kc9K4q0E/drJ3FDLGYfptIq70hMW1noeObs4401Oaij9t5v1EtffOsEp9m0KVKSgTF3m0rCZllkulgHOsCtEqNBe5oQOyLW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750351997; c=relaxed/simple;
	bh=HJ6QHD5b9kRh38IWHmpAcnRApRrwBD4ZzLCK7N+pVJM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=q4Zpik4bmpfPnTfpfxC2lpOWgY2jqeWgheo5skUG67WlwX1HLUBGPvuQ4SfxxWAWivn2ELi2xYldFoc1XvQkspvbLfGv4O0yc7Ks3iD9S1zSWsWWZPdwqG2nFIEcUxtHmpXIFaBmu4qXyYc+anPH5hm4IkkwC3iDTH71tyE76w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzK4+CHe; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzK4+CHe"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-311c95ddfb5so681830a91.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 09:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750351995; x=1750956795; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSAt3oOawPZSE+pamyanZKIXeeUuHvnaV6GseQGjUK0=;
        b=IzK4+CHevmhcrfRUjEzbtCVvdj16KhUakSv9vkhO1BKCRt62ZNSVA17LbYITxhXFlq
         qgS3FYXfyLiqi2loKHRLXHg0RF6qkWfb3mqDe3DOc86aG4Hvyn+qF4nYgV6EBMEwoh97
         k7Sr4yglEKRbrT0pVCeVaWJjqVTEOdjkvfsowrK5izBYuFIb6zizsGMcgCvfhWyi+8zt
         nu/yONEXdQkH47WCs+BO64C8NtiWxnf4yJeK2R1OLiH7Q339lFqGhwYI+qlxTU1s5m2p
         18YE+vgpynqyfcdHcyGcd6lQYL3cuVnUhRGKX2DYknxYIupUq6NlDpIWn3ucB+hEU+b/
         7Q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750351995; x=1750956795;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSAt3oOawPZSE+pamyanZKIXeeUuHvnaV6GseQGjUK0=;
        b=nXruUK+TuCe7SM7v4atmWQV+0WPPvL7At3BDj3U/at+9xdcvgV+z0K5UGqAv9LBR5B
         4leMK127sKKD7M3xtvC+ngqehPBjJ7TkPedvzNudxSvIkHL8V+4zc/Yn0KDxV5G8J/sU
         qKzF6lXLm0yhGZGNyTaJy35ijnKtz1k/l11astVreQXabKoO6yKM6U90bANfQhbVRzMz
         FB1rNzBxENCL9vAl0LHChT+4nrM9kBoC+PYBNyzM4pSvba1E5TG1K9kZeuDYHO8E5brH
         GfrXNlXYm7vwMlTrfDx2kF8Gzeigw1cBlpwuLoUB/kzcphSgplNFSI2k/EflHHZ3E/2B
         I/Rg==
X-Gm-Message-State: AOJu0YwhfwPoZ/NcpG8zkDeWZ8PalNYmFUm5p2U7e09zpA6WWiZnhvR7
	h/JcWct9LUrZYKpO9y+0/d+lbb0bUPbTGkTMgFAH2MvgDWZPRhuZFJD2yZ52AQ==
X-Gm-Gg: ASbGncuP/x96BcXSVONabDXVDa5hEAdGPgu36vc84bju6Y9pvTPk6o4geXeLRAgKAg9
	VPpiO+hL57RXl4wwxqESklkJ0s3DN6drEgS3nqwgQQs/Jlb5G8ymZmMLwbMEGXlw8/0cD+FpnIR
	WlJ92UhAUjiYd3OCq58XPI6BA0jD5xDcfdiPtwIUeu/AUcL3HQB2QZfQkiEt9JrG35El07Vh81y
	rwzvH0YxDeoD/44yIogXXNgC+286MewqC4Xswn5jxVZT2S4r7tTADYDl+4aGDKTmmSeBdEBXLzR
	fHa3SAXLyJ2aaqKUjkqazDllGKrqUF5KDf/sxEldL5duOwYuzCSkizDB
X-Google-Smtp-Source: AGHT+IH4U1+1oTV1v60Kj+SKeXxS+/UneWeBGybOs2qbiW8iXmqkA6c49bIgz3LguGHSPEwyoQulWQ==
X-Received: by 2002:a17:90b:52c7:b0:311:afd1:745b with SMTP id 98e67ed59e1d1-313f1ca8002mr35466473a91.11.1750351995370;
        Thu, 19 Jun 2025 09:53:15 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a23e19bsm2455401a91.12.2025.06.19.09.53.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Jun 2025 09:53:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 2/3] bcachefs: Fix *__bch2_trans_subbuf_alloc() error path
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250619163714.767851-2-kent.overstreet@linux.dev>
Date: Fri, 20 Jun 2025 00:53:00 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EBCEB9D4-EF19-4424-82A3-DD353FE57712@gmail.com>
References: <20250619163714.767851-1-kent.overstreet@linux.dev>
 <20250619163714.767851-2-kent.overstreet@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)


On Jun 20, 2025, at 00:37, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> Don't change buf->size on error - this would usually be a transaction
> restart, but it could also be -ENOMEM - when we've exceeded the bump
> allocator max).
>=20
> Fixes: 247abee6ae6d ("bcachefs: btree_trans_subbuf")
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
> fs/bcachefs/btree_update.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
> index f7949dbe8f70..668d4feb2879 100644
> --- a/fs/bcachefs/btree_update.c
> +++ b/fs/bcachefs/btree_update.c
> @@ -550,19 +550,26 @@ void *__bch2_trans_subbuf_alloc(struct =
btree_trans *trans,
> {
> unsigned new_top =3D buf->u64s + u64s;
> unsigned old_size =3D buf->size;
> + unsigned new_size =3D buf->size;
>=20
> - if (new_top > buf->size)
> - buf->size =3D roundup_pow_of_two(new_top);
> + BUG_ON(roundup_pow_of_two(new_top) > U16_MAX);
>=20
> - void *n =3D bch2_trans_kmalloc_nomemzero_ip(trans, buf->size * =
sizeof(u64), ip);
> + if (new_top > new_size)
> + new_size =3D roundup_pow_of_two(new_top);
> +
> + void *n =3D bch2_trans_kmalloc_nomemzero_ip(trans, new_size * =
sizeof(u64), ip);
> if (IS_ERR(n))
> return n;
>=20
> + unsigned offset =3D (u64 *) n - (u64 *) trans->mem;
> + BUG_ON(offset > U16_MAX);

offset * sizeof(u64)  ?

> +
> if (buf->u64s)
> memcpy(n,
>       btree_trans_subbuf_base(trans, buf),
>       old_size * sizeof(u64));

copy buf->u64s is enough.

> buf->base =3D (u64 *) n - (u64 *) trans->mem;
> + buf->size =3D new_size;
>=20
> void *p =3D btree_trans_subbuf_top(trans, buf);
> buf->u64s =3D new_top;
> --=20
> 2.50.0
>=20

