Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3621AD41F;
	Wed, 26 Mar 2025 10:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742983369; cv=none; b=Vcii6MUboZXpqZypqSepdkuR/8fso9Vr5uUy5R7O+U7Td6P+gymLOuvjyt5eM2ps9a8HELHbGBiy1SZSgXpz+fYo6pPtmwzjjNREBfZbaz4cc+uOnFsPYhzsJP8EnHs7e95bMGY+EsQDchAC60EPQzZ1KpzyhfYybjb8f9xrv4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742983369; c=relaxed/simple;
	bh=ltuYgOBoRIHSm1h/laNdzdjkrsOJvZ1PJctSimi+EH4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Nkr4A43jzb0G0eiSZK+pUAlxhqRWC2YITTRBWZH7Rl0HLK84G2r+/qbdnJ0ZQG5xO1juJzJntF7C6ve5SfvryGB6AlnvOK6BPaQGEhgy/2DSG7TLdegNJoNuLjI4ryInvqRUggbcsRoRNyagpnL9RkavcZwDNNy7/s3sriuPGZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhAxOtVn; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhAxOtVn"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22580c9ee0aso135225405ad.2;
        Wed, 26 Mar 2025 03:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742983367; x=1743588167; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltuYgOBoRIHSm1h/laNdzdjkrsOJvZ1PJctSimi+EH4=;
        b=VhAxOtVnSX7tjRf/CZM4o4tBMS58bdJzjH1MMaIRKRyRJ8QvoEoXjB4HS5DzW6W5z/
         PKlAu2DEOPPS0zbDilzT2JiWIr/PGnpqCPft6siKeLJSnczsAOiJXlPI+7s1A5ZcEXOQ
         NNr8haunoqKa21/yi7IZpfgIoCUuKB8iCY0HBaeme8Yr9cY01EVbFFAY60btEdMvNB77
         MF2OHTSlGdZnvrN13s3GB9XjxAEh9gtawDGfuKU7MBvfct+K1tMReud1TBuRdVfCpHNY
         O04hdXCYP/UdxK8DZS863yL5Qk582bxDALjaV0zK53Sr/39W2motLdk3FiDCnfVi6Pqg
         3l/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742983367; x=1743588167;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltuYgOBoRIHSm1h/laNdzdjkrsOJvZ1PJctSimi+EH4=;
        b=VJ9fLq6QhLi6D/wCqq0VqPQ156kZZnA7tOOP0wAUcquGjk/gWIHi0Xzk9ISzUgmoub
         C8sgGDK6XKfg9xE/FLeR/M4zUnNyGUPyxV5mSsoBKmY7uD00X2OZEuIlYRTq5fP8p+SB
         j51mcgxbzf6gGPGQpFuemF1tZAh9XSLMxVK75QZqOlNzdAjUYX0g0HJ2SixUOMLKDLb0
         sGvpjnj+zMr5Nbfn3A8AFt0L67yeuUiMAunMVh5j4ymWUXB9aLpn2vAJWKebNP1teR0c
         RDozhafTbJnOt/OH8aXTSj1AV4uvieLs4zblhxSD49/eTfRaSyE6zqU9AO9NyZqxNUuD
         eXzg==
X-Forwarded-Encrypted: i=1; AJvYcCWKFxcTQkS4CCK/YkMVoiVE4dpbpE8xS+gJClv4lt91B4ydddd4DffijvRyA+YBHWSpddEh9tj/pgYPMsV31g==@vger.kernel.org, AJvYcCXIN1SquEIyCxuZZi4k5Ky71SHaSbDkxHwMvNj4TRBCyuiD4lek5b6MOr6+K7qgH9QMb10WDd7Tt5JJBs0a@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9M0tvgK2JwTtUCOZv0vC7vE1v1arFX/Pl6cVajclEuzgUuRs6
	3vTFK/1NQtkfPgZR3ayVzRD6E34kYF86WfvyEVzV3fDZSFcOn72C
X-Gm-Gg: ASbGncvnjS8g3X4TjWttayvaR4rpQnwRWy0KWd7RZV3jhrKK8FVy+mkZKclxr1sEPvb
	5qf8I7piltNTfSNiGQ9z2RP6TFB1qdbBK1WPmBz56pciqN/WI4jZhL12/8LIeefB/YneWsxxb9T
	w/MDTPz8ABtFBlL/R4oS8GRNvJ/HfIAtDBtucy//6ws9cl99S3U/KFbLqJ5O02MlS6hXp6fxBVl
	0mEsfisuJPH83QXV1hZEIA5/v6MOoFRsLyn+WfmUiS+FKVUY7iiIH5RHSkxzGv3EKLH1LmSVJms
	oCSnrNUoZs3+Hz1GaByn3IyZge4a
X-Google-Smtp-Source: AGHT+IFmRyDrWSokAiWcXtmt94I5j1NjixzYSrCGTSWharoB2uW3Raf6+3NbGkx8mxeuoWEV6s6VYg==
X-Received: by 2002:a17:902:f548:b0:224:a74:28cd with SMTP id d9443c01a7336-22780dacae2mr271815945ad.31.1742983367118;
        Wed, 26 Mar 2025 03:02:47 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227967dfe4dsm88116595ad.167.2025.03.26.03.02.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Mar 2025 03:02:46 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
Date: Wed, 26 Mar 2025 18:02:31 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 linux-kernel-mentees@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
To: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Mar 26, 2025, at 17:44, Roxana Nicolescu =
<nicolescu.roxana@protonmail.com> wrote:
>=20
> strncpy() is deprecated for NUL-terminated destination buffers. Use
> strscpy() instead.
>=20
> Link: https://github.com/KSPP/linux/issues/90
> Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
> ---
> fs/bcachefs/btree_trans_commit.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/bcachefs/btree_trans_commit.c =
b/fs/bcachefs/btree_trans_commit.c
> index c4f524b2ca9a..7ab25b425d11 100644
> --- a/fs/bcachefs/btree_trans_commit.c
> +++ b/fs/bcachefs/btree_trans_commit.c
> @@ -364,7 +364,7 @@ static noinline void =
journal_transaction_name(struct btree_trans *trans)
> struct jset_entry_log *l =3D
> container_of(entry, struct jset_entry_log, entry);
>=20
> - strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> + strscpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));

The last time I asked Kent about this line, he didn=E2=80=99t want this.

> }
>=20
> static inline int btree_key_can_insert(struct btree_trans *trans,
> --=20
> 2.34.1
>=20
>=20
>=20

