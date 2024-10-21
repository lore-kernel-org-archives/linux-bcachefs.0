Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA511F6681;
	Mon, 21 Oct 2024 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729522347; cv=none; b=RCzVTtiLzYdI+/9P7GUuKAv8FNpsxyflT2V4eS67XqechxQO2qH2sunqaySXR4Zls1C6oXagmsEzmLnfE9gulSwcDrVU2027mhEvBolQ70zvOfre6jObCxF0jt+aUbm/LQvz+gLZHiS2LgIQVi/gqJNztzztpr7Jx87KKIk+gnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729522347; c=relaxed/simple;
	bh=FowACoN2b+0Ge0RZ36VFhGeMwK+RM4hKXl9ttJGBZgY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OA6/rnBgYcL61dNUxfxNjUfynVJh1LdyAbKjcOrH3Bh412EB8YnyOnlfevHKeVgg6gnao00d5CGBBxMiwQ0mzMEJnGNCvus3K9LykyZIjco6hZRtiMKJrXmjMGqDRPx2DNyhTTaYl79EqPSgUOfiBMmVG1neNNXXWeycLKdqVZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nCc2KfDr; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nCc2KfDr"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c70abba48so36474685ad.0;
        Mon, 21 Oct 2024 07:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729522345; x=1730127145; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ERo6rITP6HUIczBUz1Hheo3MKjLwe9uWSn3gY/EEL4=;
        b=nCc2KfDr6A7NLfooLdROoRKjC4vsr0JxCBgrDpbkNrDbxrrVX5X1zTmefnJ6yRXaju
         RYcXE2yyK6Y4m6/LovmKenxEosHTMjmuuZ3bQsJLs9JePvct8qE7+dCN/PhDgN86Ul1P
         6jmEwD3a6a8rl8fp8/JvA9fnmrW8uMwYuKnKlQRPU0S1RtdsvP14qppWxGxUF505cTgD
         eeqt8ivCu/RkVObY9fut9WFC2RBuoqRAluqBDo9+zYIXU6+svUKM/f+eZJ47+QvkR3d1
         ZkUYP+0RYJ/l48y2/cLHRlv9S5uTeA8unrKHxcJ3xPZYS6AWPEnU6fAeixeCRMKoUOFH
         dyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729522345; x=1730127145;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ERo6rITP6HUIczBUz1Hheo3MKjLwe9uWSn3gY/EEL4=;
        b=IdSfUDndaziP5zB+bfxp5ERbvCZ7PdPb04OnECkkXJ5EzwQkAoJspT//STiyqHyx1F
         9RhNItbFQTWuAp6LSh5WURhdqAoagSK3gFv2rxU1r7sli1vRMgj+9XXpSKAN3/zDDE+r
         hZ2ydtTd13IIFEHuvVaIxg+guMhQXNz54qnn8xEfu5HtYI7y53UJ9+tbxLn3HER42g67
         ZiQNe1XEd8f57YczJMhWDedROKH7/AmgCSeb6Ur8PADQOoq4BlgaNpiXFLPYZlxNRGUs
         bfdmRqrE3wUYMbrIOgRk39AlH5yF0ZREbAB0u2sy042oBvnuPxP3chxvHjOrQSncZziS
         EcbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYS52IbJpSXiik7kgTPGoH8PH9w2IcEr+ojgV5WbZT9sXY2oAQCK4bOD35Pl1n5B2TmkXw6JMu+XlI2qU/@vger.kernel.org, AJvYcCXC+r3Urg82Xc6vNL+ykZj1iRIQg2wzxjkCFRSlFfGZ9yABrQLJ0PHt9Bq21o+qxQtIBOjzKFlTmcpwbbHeFg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcqG6yRVVhRAs0iAswAlwn7TSWyGUhpPvmNUtNbhgWMiPLKpqQ
	zcdt1AFbOcHlAAzi3M629NFhd7Iu0NCMEqNl1/oI/yHv6HKHXB4REbJujG85
X-Google-Smtp-Source: AGHT+IEQpfinzGbZ9bbZ6wqp+SETYR3+MaQZQf07P8pgWWxOTCceOVOn0hvPZzXD2jYaYpD4Qd99FA==
X-Received: by 2002:a17:902:ea0a:b0:20c:a189:c006 with SMTP id d9443c01a7336-20e5a91f162mr141998065ad.45.1729522344562;
        Mon, 21 Oct 2024 07:52:24 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0f36e6sm26799735ad.258.2024.10.21.07.52.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2024 07:52:24 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20241021140949.29204-1-aha310510@gmail.com>
Date: Mon, 21 Oct 2024 22:52:09 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <656AA7DA-D2FB-447A-9491-781880D79A4B@gmail.com>
References: <20241021140949.29204-1-aha310510@gmail.com>
To: Jeongjun Park <aha310510@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 21, 2024, at 22:09, Jeongjun Park <aha310510@gmail.com> wrote:
>=20
> The size of a.data_type is set abnormally large, causing =
shift-out-of-bounds.
> To fix this, we need to add validation on a.data_type in=20
> alloc_lru_idx_fragmentation().
>=20
> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
> fs/bcachefs/alloc_background.h       | 3 +++
> fs/bcachefs/disk_accounting_format.h | 2 ++
> 2 files changed, 5 insertions(+)
>=20
> diff --git a/fs/bcachefs/alloc_background.h =
b/fs/bcachefs/alloc_background.h
> index f8e87c6721b1..66a334e2edcd 100644
> --- a/fs/bcachefs/alloc_background.h
> +++ b/fs/bcachefs/alloc_background.h
> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum =
bch_data_type type)
> static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>   struct bch_dev *ca)
> {
> + if (a.data_type > BCH_DATA_TYPE_MAX)
> + return 0;
> +=20
> if (!data_type_movable(a.data_type) ||
>    !bch2_bucket_sectors_fragmented(ca, a))
> return 0;
> diff --git a/fs/bcachefs/disk_accounting_format.h =
b/fs/bcachefs/disk_accounting_format.h
> index 7b6e6c97e6aa..0232bc9f590d 100644
> --- a/fs/bcachefs/disk_accounting_format.h
> +++ b/fs/bcachefs/disk_accounting_format.h
> @@ -72,6 +72,8 @@ enum bch_data_type {
> BCH_DATA_NR
> };
>=20
> +#define BCH_DATA_TYPE_MAX 10

Use BCH_DATA_NR instead.

> +
> static inline bool data_type_is_empty(enum bch_data_type type)
> {
> switch (type) {
> --
>=20

