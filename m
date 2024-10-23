Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008913AA31
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 07:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668630; cv=none; b=q4k0xxERW4wjvloQYIjtqQc1MqxWQW5sLgpYGWi/88g6rz4dOGq8XCGSiUsPe22JgYlm4W2Ew5Pv3CsS1Ww3H+kHxbiNf6Rv5Ezx9H8/KmPNJJ5DSCSr8wh5dC5ccuPnvySuxVG5RR4y+KyU3mCsuZrvyEz2i3+HMbO8Zo+vtAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668630; c=relaxed/simple;
	bh=VS+rhmjPdrvCRvmzMilx12EZqPOXIlZ93ZoCYUnKA/o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sFwtseN1SJpCef29+Pgmn0f8/EvnlVI4+dPMJQdTo8Ku+JFA50DKnYD1W8MIt+sgNt6LAclkT4NCXjQHybRqMxTVlCrXWs/wq+Llk5FilDbygEKroGvp8CaIM6mSi9F0NXSPn7lPjWmD0eE4b3/7DwwCDzD+Kp6E5UB6Zy3Cq14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8t0DvAS; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8t0DvAS"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e2cc469c62so4373177a91.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 00:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729668628; x=1730273428; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owbnBqcAOdbgKaq+xfV9htpf34eXRTrfUlCl69M+kN8=;
        b=W8t0DvASJ5ZhmdJA0h368AYX9TWRP9khYDjPHTskrQb0/J2wEgJ5A/w08OMHDBIikX
         aCLG6QnBWJvSTLbYYd/bnjtJBBZTNfZA3RRW6d4N5IDwNs3xnfboTTfA3vOSnWIDuQfN
         7N1Zr9kVRUqCdoJZfIrHQHQiORe//H6+LCdhXs4o6B4xOU4oV8Sw/4hb/5YqUjLZyVzc
         WP/oYYKCv20kb78wlbHkImSZkSnQSnaPMczVO2fXB0kUurfGejS9TMoUJkBDjdnjaGVI
         BjCYCqydB0ihSbFVQwYzYR8YU8zs4aXbiY1q686hhVFNPvA7yv35L+WeLkjAEPfmDuEs
         V8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729668628; x=1730273428;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owbnBqcAOdbgKaq+xfV9htpf34eXRTrfUlCl69M+kN8=;
        b=FqVUk7aQbYFfEm7pycx2nGfXk55DFU64e/6Gki2+Z47VH+cPf3AFeUzs2XaaArv8Rd
         Brb6COwtghCw+uQZl2NBfFsrXTDguPf226nljLZYCIsypk/5cMEFxgPM7d77sCirXPl4
         sEXwRSCieqxUPXjJqWM6XvLgivONZvpoOmASpQA06SMdtiHcTstOvqL0/jwJkcWkRZFK
         qB0gRBsO0msoJPUbye1xQ72f8uCzqe0QxOOuJNtwp0rtt/oGrXAMmTVWCAni4cNQ20b3
         85IhLm31Ng63hcLQfvt0bCGc+dgYhVeJrZ4tmWwLIPNGWCOXz3UpS8DDBBXF7IwhDxLh
         aj/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/16dxV1AIbTnlol9Wrx5mgAEERMjNY5ZsDIDpW+565MwYzupNnQISjKtpg9l0itDXb50+7hHwwaZ2w/9hWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8oMtfBuQv3Gz7liLui9apf2kKlyVwp2oV1TG9EMTGxTBvDF4j
	JPeB+71VzyACl/wsTqOGXSo3eitSiYiMaS2hpaYSGam7gialuUe4fPKBgN5v
X-Google-Smtp-Source: AGHT+IHMx4DNGQrIuSmT9xbh41c9r4QGZa2nIKbc7gl6ujyTPPm6rPJctiXFqUt2DQoIVu0KGHHjsw==
X-Received: by 2002:a17:90a:d80e:b0:2e2:bb22:eb59 with SMTP id 98e67ed59e1d1-2e76b74362amr1506195a91.41.1729668628135;
        Wed, 23 Oct 2024 00:30:28 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76df714f5sm673902a91.33.2024.10.23.00.30.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2024 00:30:27 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v4] libbcachefs: add support for true/false & yes/no in
 bool-type options
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20241023051504.59321-2-integral@murena.io>
Date: Wed, 23 Oct 2024 15:30:13 +0800
Cc: Hongbo Li <lihongbo22@huawei.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C427A74E-0AE3-48F6-A47C-633E54949379@gmail.com>
References: <916cace5-ecf5-426d-a215-17e1107fef88@huawei.com>
 <20241023051504.59321-2-integral@murena.io>
To: Integral <integral@murena.io>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 23, 2024, at 13:15, Integral <integral@murena.io> wrote:
>=20
> Here is my latest patch:
>=20
> Currently, when using bcachefs-tools to set options, bool-type options
> can only accept 1 or 0. Add support for accepting true/false and =
yes/no
> for these options.
>=20
> Signed-off-by: Integral <integral@murena.io>
> ---
> fs/bcachefs/opts.c | 26 +++++++++++++++++++-------
> 1 file changed, 19 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 68d240126522..2d81e39ddd73 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -1,6 +1,7 @@
> // SPDX-License-Identifier: GPL-2.0
>=20
> #include <linux/kernel.h>
> +#include <linux/fs_parser.h>
>=20
> #include "bcachefs.h"
> #include "compress.h"
> @@ -322,6 +323,16 @@ int bch2_opt_validate(const struct bch_option =
*opt, u64 v, struct printbuf *err)
> return 0;
> }
>=20
> +static const struct constant_table bch2_opt_bool_names[] =3D {
> + { "0", false },
> + { "false", false },
> + { "no", false },
> + { "1", true },
> + { "true", true },
> + { "yes", true },
> + { },
> +};
> +

Can you use the existing constant table?

> int bch2_opt_parse(struct bch_fs *c,
>   const struct bch_option *opt,
>   const char *val, u64 *res,
> @@ -332,17 +343,18 @@ int bch2_opt_parse(struct bch_fs *c,
> switch (opt->type) {
> case BCH_OPT_BOOL:
> if (val) {
> - ret =3D kstrtou64(val, 10, res);
> + ret =3D lookup_constant(bch2_opt_bool_names, val, =
-BCH_ERR_option_not_bool);
> + if (ret !=3D -BCH_ERR_option_not_bool) {
> + *res =3D ret;
> + } else {
> + if (err)
> + prt_printf(err, "%s: must be bool", opt->attr.name);
> + return ret;
> + }
> } else {
> - ret =3D 0;
> *res =3D 1;
> }
>=20
> - if (ret < 0 || (*res !=3D 0 && *res !=3D 1)) {
> - if (err)
> - prt_printf(err, "%s: must be bool", opt->attr.name);
> - return ret < 0 ? ret : -BCH_ERR_option_not_bool;
> - }
> break;
> case BCH_OPT_UINT:
> if (!val) {
> --=20
> 2.47.0
>=20

