Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89728CA5E
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Sep 2025 00:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756774472; cv=none; b=Ca+D3M068d7yuqJAKTynH4NK3sIC/U8GPtmHLpf6ZhWtYh1MDkeQ2DbXKhFAH10YhNlnBiCxGpFr3HqP8yKuDVz+4LvPkWQkEyTsXnAU1DTTCotnSUW7ylLAKNKK87SDaqHYFqqjg9i//6oBrS3vFUuABQmSxLxnSqCTWYbJpig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756774472; c=relaxed/simple;
	bh=/xKQsTJJWdMFIonOJ5MHgVDV1fF1G9Dm+NjSFyJ4SnU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NB6LApklRrI6GralqY2BUgOon3hXeL++pEV5q0rD+dO3w2jS6gZYeOIQ62hNH6vI+8J1QbZ04m7qmtFORQoe3FGaDs2pOh/QgaRirdJbLdDSS6Psmob6oVQaxw44+IyYdzotdflMUYjejezydvPIHivK0gRDAr8O6WSJg4GcX3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0DOxU5f; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0DOxU5f"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-323266d6f57so5251391a91.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 01 Sep 2025 17:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756774470; x=1757379270; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkmzlwU3Ckm/daIxY9yfAdazZ5GecRZmud7ONMpGLAA=;
        b=a0DOxU5fnRYjR02P2FCfnKOr38b5k7zYk9EkqglhLj0B3shVOb8I9mnBfWZQt/rI/Z
         NF9EJ7lXnjg+y96iSX0PPdPM8zzkJbi8e+v2Hts8ArcZzbqQO9PuI1bM8mogG+81S38S
         eVyO53BYNveXgmVZAQnQo6Vp8vUZUydCaAYEuuRO04f+yu0ptf7PDo9xOcySWaIwDi4K
         KTiYezuUDIkhjBT3eF5MVmA93/hdJY4PkjxVv5K6sX4Eb9980eeSX4Oge+feL2o8Kbur
         EzoPQVOY0C8k3hOCo/45ihEpPCFX8UoBhy6pbZ1bJeCu0bxxW4zJK/UhsHJkWhHS4nWo
         1eDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756774470; x=1757379270;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkmzlwU3Ckm/daIxY9yfAdazZ5GecRZmud7ONMpGLAA=;
        b=fFrKFAnx5pMoslFhLAvDwTobMprobjnbL6lVmu1DQ+ec5EPpgWpf1H0xVVRsjpawMo
         XqFqI+eqhdadY8OzUkwmLVnKrJI6Q4VJZz3ssefsL1KDZEHHWtdjOzQnXVC89ncpRJkL
         ChB8ggFIEFgqMAaVnCnreqYw81H9AZpbh/TZYhFh5NgoRRtaL9hmMCVbhIiojdXPPizH
         dr5gzlBekzHLbmUZjdrc+xSbYTUW4kUDEO9RtV8XFVY5rUAfzjFnwP0VhfUa+QozKPbQ
         IWyv1Rfhr18wnfkWVSln4W3QwzbkPkNiDkkyUTg2QTRAq9/0csLRJMOOIJubIjFN/wNq
         uR9Q==
X-Gm-Message-State: AOJu0YymMvaJURGD9LIndon/1Nd3mV8EMwz02ZQH4R05HqTbHvX2ksYw
	mYXQl1VcvR8OicXnM4/reFHflWxk7E7bbV7zHvJvLAITsHzmtUZN6Xwd
X-Gm-Gg: ASbGncu9UVXSDDM0Q1x7YlgjrXXn6pI+2tDRKdJqaD999Em/x6guNmZk4IJ4l0Hj6Zd
	y4uyyoYnRuv45gdjCnWXfGiV+d/r0uA3JjUk4uEjtECOvJEsMzXoFwW0qlid5kHL7JAR/7N5u4y
	QqkyMBIDyxnJoZh+fNmO46NaeLBpJQID91HKRuiG1D5aj1ZS6jf3C5J5ZNOzS/+ebRCVWkEuTVR
	eUc2dIJMFqLB5BwwVXKCdmVfUvMQFqfOj4VzuJiyD/bVNhWkb/uMjLQqYe7kvyYqD4HMEeGuwJO
	czX+g0A+UTa9tHUAZcNdE76/0G+cqqWMcxDcBjLab3o9do6+2ZvMqclwcKc4MnP4imWZ4yiC+Y8
	CNViqcQ==
X-Google-Smtp-Source: AGHT+IELuP1lEq374SqduOE+exWe1zahp/Iui+tt2aeCoiVpJA/VBE2DSqtCCuODGLDH/0/uXwPj9w==
X-Received: by 2002:a17:90b:3851:b0:327:50c8:7c1b with SMTP id 98e67ed59e1d1-328156f4316mr11353967a91.31.1756774469763;
        Mon, 01 Sep 2025 17:54:29 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-329b3e28a10sm3574978a91.18.2025.09.01.17.54.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Sep 2025 17:54:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcachefs: Kill duplicate error code
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <frmmbj6oawjwb4dklf4rqico3ajauud6jqw3hspfdewkxhs5qj@b42regdayqhy>
Date: Tue, 2 Sep 2025 08:54:14 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <87267DB6-1666-440A-B606-F4AC9606E255@gmail.com>
References: <20250823184132.235684-1-mmpgouride@gmail.com>
 <frmmbj6oawjwb4dklf4rqico3ajauud6jqw3hspfdewkxhs5qj@b42regdayqhy>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Sep 2, 2025, at 06:42, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Sun, Aug 24, 2025 at 02:41:32AM +0800, Alan Huang wrote:
>> btree_node_read_error is duplicate of btree_node_read_err, which =
impacts
>> repair path if misused.
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> ---
>> fs/bcachefs/btree_io.c         | 2 +-
>> fs/bcachefs/errcode.h          | 1 -
>> fs/bcachefs/sb-errors_format.h | 2 +-
>> 3 files changed, 2 insertions(+), 3 deletions(-)
>=20
> So the patch builds, but this still doesn't make sense, because
>=20
>>=20
>> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
>> index 2e3dd9bacac5..3d594c4ae9d8 100644
>> --- a/fs/bcachefs/btree_io.c
>> +++ b/fs/bcachefs/btree_io.c
>> @@ -1902,7 +1902,7 @@ static int __bch2_btree_root_read(struct =
btree_trans *trans, enum btree_id id,
>> scoped_guard(mutex, &c->btree_cache.lock)
>> bch2_btree_node_hash_remove(&c->btree_cache, b);
>>=20
>> - ret =3D bch_err_throw(c, btree_node_read_error);
>> + ret =3D bch_err_throw(c, btree_node_read_err);
>=20
> this references an errcode.h error
>=20
>> goto err;
>> }
>>=20
>> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
>> index adc1f9315eab..7106d72fca80 100644
>> --- a/fs/bcachefs/errcode.h
>> +++ b/fs/bcachefs/errcode.h
>> @@ -295,7 +295,6 @@
>> x(BCH_ERR_btree_node_read_err, btree_node_read_err_cached) \
>> x(EIO, sb_not_downgraded) \
>> x(EIO, btree_node_write_all_failed) \
>> - x(EIO, btree_node_read_error) \
>=20
> which you delete
>=20
>> x(EIO, btree_need_topology_repair) \
>> x(EIO, bucket_ref_update) \
>> x(EIO, trigger_alloc) \
>> diff --git a/fs/bcachefs/sb-errors_format.h =
b/fs/bcachefs/sb-errors_format.h
>> index aa0ea1ec9f10..483358588abc 100644
>> --- a/fs/bcachefs/sb-errors_format.h
>> +++ b/fs/bcachefs/sb-errors_format.h
>> @@ -73,7 +73,7 @@ enum bch_fsck_flags {
>> x(btree_root_read_error,  59, FSCK_AUTOFIX) \
>> x(btree_root_bad_min_key,  60, 0) \
>> x(btree_root_bad_max_key,  61, 0) \
>> - x(btree_node_read_error,  62, FSCK_AUTOFIX) \
>> + x(btree_node_read_err,    62, FSCK_AUTOFIX) \
>=20
> and rename the persistent error?

The persistent error is never used, renaming it to the same as the error =
in errcode.h makes sense.

>=20
>> x(btree_node_topology_bad_min_key,  63, FSCK_AUTOFIX) \
>> x(btree_node_topology_bad_max_key,  64, FSCK_AUTOFIX) \
>> x(btree_node_topology_bad_root_min_key,  323, FSCK_AUTOFIX) \
>> --=20
>> 2.49.0


