Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFC22B9B7
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730014622; cv=none; b=jSWyF3QZLcq/p5Zus9klRFwuNYV5d49qVboeb8GRzVmpeJTBN8WmHtqJLRzVi/65upW9B1qtv6WGj0A7tHZJ6Fxt5KMr96h1Kel9m06oNqdwIhVqrzkf5kO2flp5QJAmDeDwwp/x1rJrwOe/fSR80EBOBWCg90/i3riFTU4YQJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730014622; c=relaxed/simple;
	bh=AQWip/cZczC/tBrne84M82OSmszyF4vHtjZjMnUkQvk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=d4PlvBkF1H2FK+DCXrzzSqyXaS0CwB+9ots9eQ8IgNUUm0kgDPyJqXTR60a9iAAwW2w9dUMUKXt51CCPXCF5fGnTcihMo2uKDBVypeY/JrTOXvhbPVSMV0iqGQ/HkawSwD6Cu9BTQ8hyvC9plV+fIcofsnHwGPjafwNNQBBI9WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4wYl6GR; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4wYl6GR"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7ea7ad1e01fso2222081a12.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730014620; x=1730619420; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FH+esngs657OM5+FCEsPyX1b/R08zRs0YnJ3dJIEMDk=;
        b=W4wYl6GRp6GhpF4P5heaHeb1O7FmuBuu2WX/YIgHqMcpxbxZxMln+mUVGgCgtrD8Y6
         WY6x6hTbjX7+6KPDrQW/zbUJmyWLg6gB0cFP13j1Zq419+E+rHYdBDzse6UsKle4NPA6
         7GjU+Juwri2u3d0cZJJJ6Q6YRyIez8WTgI4ENH7jRStRjrkCoZk5pl23WXGPCU5hdo0H
         J6BQGSRhssAurDhIl8qfKgxkOa36LASmbtN0yqia7Cp/kKEWW+Wf4ffXbey66Fi5OGou
         i5X8ESK8z3QJ4M/YAtdZKTqwIBWm3OtqpPJYaNcBC9iAHQQicgJEkhquwEUrV7EcKit0
         uJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730014620; x=1730619420;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FH+esngs657OM5+FCEsPyX1b/R08zRs0YnJ3dJIEMDk=;
        b=ELyus834JtWpvVyJNkkuszVwHk7MObaFNl7Esx3MmtAuLzDvtB9edNhE07D37d/Fgl
         EteYRE/+wDxZfTc5n9WUxsm6pEjTFp0l8BCRJ9JSp7pzj8wiWsHGM+ytZzYxYCz8hlff
         Fm+tklmGFKBLLHg21uxgQxwRIQ62LOwHG+5tHJdEbMuGQXVLHQdgvWhpPokT77yHI0aN
         rMrMGD284HcgwR8Fwf8YYeIQ+74YLTFMDqkmcozo1PBz7zVzWgNnvvhdhotRq0+TGgEA
         vUkbAzJEBmAovghKeJt4oWr2WpwqyQMyjLLLY72zan7vvM/zRScDwmywh+dNCKByQyj1
         WGug==
X-Forwarded-Encrypted: i=1; AJvYcCW1/Rp1u4zlcmLD0Ea5dQbPZipjg9y7V3oyiMb5diiyU488OpihuxQNqbUkU0UfeGmY0j47L97J6pkmfDtqSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDWzbwCc2/UdDHoBzu84qSz1zy7RHRVoxKTZPEB0bOCDJKEQmO
	Gk/WAKZ8bFkzciga47Ryp6qUYm/SOdpBw4Rfv4m7Ftc7grUAeFra
X-Google-Smtp-Source: AGHT+IFv/pcxqXY8VzdLYHib0pw7zO+LY1Td3Tmal2KzTDF7Ppwc/flhMLkBQYXQGgRxl7hJx+X3og==
X-Received: by 2002:a05:6a21:4d8a:b0:1d9:dc8:b80d with SMTP id adf61e73a8af0-1d9a764fa65mr6623484637.20.1730014620110;
        Sun, 27 Oct 2024 00:37:00 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a3a4e1sm3650456b3a.182.2024.10.27.00.36.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2024 00:36:59 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v5] bcachefs: add support for true/false & yes/no in
 bool-type options
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20241023100033.166289-1-integral@murena.io>
Date: Sun, 27 Oct 2024 15:36:45 +0800
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Hongbo Li <lihongbo22@huawei.com>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3384DDD6-51C6-46BD-8FB1-4569FAEEC6A7@gmail.com>
References: <C427A74E-0AE3-48F6-A47C-633E54949379@gmail.com>
 <20241023100033.166289-1-integral@murena.io>
To: Integral <integral@murena.io>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 23, 2024, at 18:00, Integral <integral@murena.io> wrote:
>=20
> Here is the patch which uses existing constant table:
>=20
> Currently, when using bcachefs-tools to set options, bool-type options
> can only accept 1 or 0. Add support for accepting true/false and =
yes/no
> for these options.
>=20
> Signed-off-by: Integral <integral@murena.io>

The code changes part looks good.

> ---
> fs/bcachefs/opts.c | 18 +++++++++++-------
> fs/fs_parser.c     |  3 ++-
> 2 files changed, 13 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 68d240126522..b564c42d62f8 100644
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
> @@ -322,6 +323,8 @@ int bch2_opt_validate(const struct bch_option =
*opt, u64 v, struct printbuf *err)
> return 0;
> }
>=20
> +extern const struct constant_table bool_names[];
> +
> int bch2_opt_parse(struct bch_fs *c,
>   const struct bch_option *opt,
>   const char *val, u64 *res,
> @@ -332,17 +335,18 @@ int bch2_opt_parse(struct bch_fs *c,
> switch (opt->type) {
> case BCH_OPT_BOOL:
> if (val) {
> - ret =3D kstrtou64(val, 10, res);
> + ret =3D lookup_constant(bool_names, val, -BCH_ERR_option_not_bool);
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
> diff --git a/fs/fs_parser.c b/fs/fs_parser.c
> index 24727ec34e5a..6521e9a9d6ef 100644
> --- a/fs/fs_parser.c
> +++ b/fs/fs_parser.c
> @@ -13,7 +13,7 @@
> #include <linux/namei.h>
> #include "internal.h"
>=20
> -static const struct constant_table bool_names[] =3D {
> +const struct constant_table bool_names[] =3D {
> { "0", false },
> { "1", true },
> { "false", false },
> @@ -22,6 +22,7 @@ static const struct constant_table bool_names[] =3D =
{
> { "yes", true },
> { },
> };
> +EXPORT_SYMBOL(bool_names);
>=20
> static const struct constant_table *
> __lookup_constant(const struct constant_table *tbl, const char *name)
> --=20
> 2.47.0
>=20

