Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5934F217709;
	Mon, 11 Aug 2025 12:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754916655; cv=none; b=p7aV/ph7rZFqoqv/KbINPD2GVMq1Nn5iLw3KrdO2mooAdjH4JHRYB/7vKBmrnSJkYhYht4DKXSiSOT3QfD3dN9KPDsFLSW+jFDwXm4AsOOSFq9gaTQlxmvbEu1vem9kZT/zJu3x7iQ5cc4IX/8wUIZrL3ZLkP4V/xYPLx1KVZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754916655; c=relaxed/simple;
	bh=d2sHLHvSVyFklgV1qgK42wPXdASR5TaIWwfAj0DU+lE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Szypmm5YNqYKb+xL/Dh4bLhC5XLbnxvLLAByXi7YltfIFGrcDoUHd6K6LwyeL6FXiYMTlhNMoAeyVvmksTjMhR0iydV3x/WkTu655GB/t/DS1BO/nzSD9EdhoBouH2Mr/JUQesY2BopPCvtRACmM72QNwFND0GT05eGHUz9Cy4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l55hEkHG; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l55hEkHG"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31f4e49dca0so5210310a91.1;
        Mon, 11 Aug 2025 05:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754916652; x=1755521452; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihtOm1TaCpPd/gazvBdb1QnrfCHqjlh2aMsqATTPojM=;
        b=l55hEkHGqgeNTeKRnDJnfnSKlyA6/+rX5PuI2CUYHpg/Lgc+asWJdxE1Szl+ACwGEA
         pUZa/LJIF3vs5s32fSJKJXmibZkj0EFR/6hhpcDEq6PQ4BeJPojUc3gygAHwxIcXY7A2
         8JP4yT9iRXeVZ2EbTYQlBdhBAQp+JsmD8SlBJw/zEeQNl0GVFet7dpo5kUZH8ewCuUJJ
         Bpcvwgt5cFIMcwmPBrFOBpGbxtRdgjY09OrNLibRm/V0tZFAL3dcRerkDvner2vd8hkF
         0R7iO99wfhenO4pBvCY3YBoeUq/fawcQs02yIgcto/ddvfQPUaDwOClpeOpPsCy5seY8
         9Sqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754916652; x=1755521452;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ihtOm1TaCpPd/gazvBdb1QnrfCHqjlh2aMsqATTPojM=;
        b=ArLBJHmqZF91l06FB8PYWuVduYfZzM+dPvMrxKK6Y0Abv7AUxrWKAq2fap81u3NnpM
         igNzWU1BXBOb2S55Fp0iedPSTXFpAHgD4Igem/ZudOwwd6FAXSz3iPhKewSTqf1lS7Z2
         J7sajc+clmTO1xe9L9HwNphvfre65hokeY1yCrzIL2CFSuPMXJX9xfgYhedp5LQZ6Hfl
         K8sRD4zKnxCihKdI2t6sVzREQ1BzP1ftGI/561Wy1mnN3qq8Yiru4YoU/v0wsR4hajrM
         bFhZuSM+KUElCeSZP2URKW3rIAVQVY9/mxVQ4yZdRvWRBxBCu8wle5hD+s+e/aOH46l5
         c+Jg==
X-Forwarded-Encrypted: i=1; AJvYcCW/tSAUq4bhyXVHpXWXOVNbXG+vxkShMVzzEz4xJLPrcjxMhLprsx+guYqnnaL4PfK1oZVqFcazH/7abYWrQw==@vger.kernel.org, AJvYcCXPqkmGo+zoWXV40E+x3/CDiulHX1YafgZviVBF2SB9dFJ65vrxT0cRXCyfKd38euGXo4hZGWqIkqEJprdS@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi3gLhAL1IfhS+FvKziwmN+pHUKr+gkRIFwRwcMIepZyxlfqL2
	EMiBjtYzgw11EINzA7PnG7LHRpC6oeWgC1Mx27kx5yZ3dlk6y2eET0eGgHbOIw==
X-Gm-Gg: ASbGncuBsgdSblEwNXdEiTrijk+oc+/nIBrR0WThwhHe4FD7RxLGQ3w9BUgJra/AYSn
	1mA+RhXHkG39rnUVQrRJnLhojlsqemojyf0JwbrzzyInQKh6xytTgxVWbTt97TzOZnFWaiTBMRJ
	1zGyKwSiE0GGXWzojabJjcfD5iiUaeoFnlrHXZbmZEBlNp7njAh4pq+KPISqt2rmP4yjNsMS2ck
	HhVYKPD4YrLcj+pvVYuVVJUwpyhLxeElcC1+oGpKIIm1LP3EKOXeuyOJOwU4f7W5Dm4E/718De1
	+DvKs7NvnVdW6rnED8UQKdtT3g2lQyhYHS9ouR9nocSeUTqyJLJeBNzY5I3gwAbhdFKpQI1P3Uq
	MYSp5Cw==
X-Google-Smtp-Source: AGHT+IFwEX5u1VRuc74mYwJHyP4t3wsD4T361k67FpOAQo/55gn0pyoo/yjVZqpPdQGiGlOI8OYLjQ==
X-Received: by 2002:a17:90b:3908:b0:311:df4b:4b94 with SMTP id 98e67ed59e1d1-321839dfb03mr20574702a91.4.1754916652443;
        Mon, 11 Aug 2025 05:50:52 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63f33e58sm31566574a91.33.2025.08.11.05.50.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Aug 2025 05:50:51 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 1/2] bcachefs: Using vmalloc_array() for array space
 allocation
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250811120953.529864-2-liaoyuanhong@vivo.com>
Date: Mon, 11 Aug 2025 20:50:37 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1EB1AD1A-C14A-4A1F-A97B-55F956D241E7@gmail.com>
References: <20250811120953.529864-1-liaoyuanhong@vivo.com>
 <20250811120953.529864-2-liaoyuanhong@vivo.com>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Aug 11, 2025, at 20:09, Liao Yuanhong <liaoyuanhong@vivo.com> wrote:
>=20
> Replace kmalloc(size * sizeof) with kmalloc_array() for safer memory
> allocation and overflow prevention.
>=20
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
> ---
> fs/bcachefs/btree_key_cache.c    | 2 +-
> fs/bcachefs/btree_trans_commit.c | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/bcachefs/btree_key_cache.c =
b/fs/bcachefs/btree_key_cache.c
> index 4890cbc88e7c..8dd70024e513 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -136,7 +136,7 @@ static struct bkey_cached =
*__bkey_cached_alloc(unsigned key_u64s, gfp_t gfp)
> struct bkey_cached *ck =3D kmem_cache_zalloc(bch2_key_cache, gfp);
> if (unlikely(!ck))
> return NULL;
> - ck->k =3D kmalloc(key_u64s * sizeof(u64), gfp);
> + ck->k =3D kmalloc_array(key_u64s, sizeof(u64), gfp);
> if (unlikely(!ck->k)) {
> kmem_cache_free(bch2_key_cache, ck);
> return NULL;
> diff --git a/fs/bcachefs/btree_trans_commit.c =
b/fs/bcachefs/btree_trans_commit.c
> index 4d58bdb233e9..4102a3cb2410 100644
> --- a/fs/bcachefs/btree_trans_commit.c
> +++ b/fs/bcachefs/btree_trans_commit.c
> @@ -396,7 +396,7 @@ btree_key_can_insert_cached_slowpath(struct =
btree_trans *trans, unsigned flags,
> bch2_trans_unlock_updates_write(trans);
> bch2_trans_unlock(trans);
>=20
> - new_k =3D kmalloc(new_u64s * sizeof(u64), GFP_KERNEL);
> + new_k =3D kmalloc_array(new_u64s, sizeof(u64), GFP_KERNEL);

No, it=E2=80=99s not an array.

> if (!new_k) {
> struct bch_fs *c =3D trans->c;
> bch_err(c, "error allocating memory for key cache key, btree %s u64s =
%u",
> --=20
> 2.34.1
>=20
>=20

