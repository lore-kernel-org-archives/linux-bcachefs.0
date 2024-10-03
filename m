Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECEF8F66
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727948784; cv=none; b=IhJUW6252hYbSzx683KbTaulwJPaG7kwuEbW8NXzsKKCC0BhXnJZUMhnyWw5eDNGGGJDBCx9qHhf3DTPokdWh2ncjYRt0hmKmPtlXcsHLzErnaDUfHlB5b7sJzMn2udoQXanxZv+eF0gU3p0errqg/6UdaOUfpGXJMUjWK3gq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727948784; c=relaxed/simple;
	bh=z3PvjxjRHyX+txMuotUhxMhcT1N8sJk9tmZW21LA2WY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GVl4ltbo7VaumHq9ZI4eNoXzfhb07qYSO7zdp45v+K+T3/aDtoDheTjjGtv6oAw3kppQLlYM+H1hseabj/OzQoBey2vDXqS/pRRGFv3sVnVatcql82sJx/aCdOGLPNEF6s+dB6aBuibANigt3YjNb104JEYUaI/ZHkUJsBisAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WymI5cp5; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WymI5cp5"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20b7eb9e81eso7887415ad.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 02:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727948782; x=1728553582; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVD8vseiaL5wjFbfbMCRI5rUs9M0/YMmEaBrw4fDvds=;
        b=WymI5cp514L99HWRKZwnJkOymtl1BXHav2o352VIgVVfCEZ+ym0bToBDmhepq+690H
         uW5eqb6yOxwoRsZNaFn0nLLBeDnDfju+ONbHTEimGAzu6kEdn+VQWQFh0bLkrBU/egaW
         ronpXBwLm48pqOPfE35jei7KqK29NBAHNvXzQJIG+dnNbyc/A4BORcZYDl1v3OGnh6pB
         MsUgIUlNxDOXPn6N7cH+mtUQJuuvRXAxx9l9BTvl7nU/GK3ANeu/4cgXfGJ++OShvEc/
         xzjMJx0trPe8L1vouyGxWBGXwAL1b3FnAZGjNaju0w9rdtbqz+MFZqjYmIriuITgJBp3
         6E2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727948782; x=1728553582;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVD8vseiaL5wjFbfbMCRI5rUs9M0/YMmEaBrw4fDvds=;
        b=DMpU8Hu0vMEHmuhFhJBQRldPVNCTCKwBfiGTRyLGhfzvLNt/muCuwct4O3owDcXXhM
         8eoHlUEwy+miUw3rUHezSX3l7cnkZ9B6pzEOAJr/SkPV9vjDWQlKr74EYmj0yA2EEfXw
         j3bO0xGKe8V5ndgV53PdmQD1vBboNawns97HYeebbD32mEChw7JMB01DVLJod53lVEvt
         RpC2xPgLIbaEyOMZAAG863RJmGEcDWezYf3mV+JL42PLPDFMHZEfSYGrkqXUYHXQM6Op
         mwwfSEEmBqB4DDHweDECIXp4hlA/buhEazkIt6jRaoN/1s/UrdJdCJUQU9aso0QgmTDw
         toRA==
X-Forwarded-Encrypted: i=1; AJvYcCVzj9lE9q0I5+TUYR80xwrlSeaAommHXyPzFZZnY0V9O6AZIMAq53BJ9KZfBb6Tq5Sz2F69H7GoeriJNT+owQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm7oVIoU/mDenqTd9FAjhOuOpF6kyZE7A2beKD0BexmGnWl7lR
	/W9+Oj6wBym3hnT3FYCEOiogwf1W0DH02Zj34WASNldMh/6qTXGP
X-Google-Smtp-Source: AGHT+IGN65K9e8P5Kk+QGPqFjy5DLBPDtXzb/DEcQqUAxWQC5xGGjifF5UGNGMq/2I2cyZ3k/LrewA==
X-Received: by 2002:a17:902:e742:b0:20b:898b:ec18 with SMTP id d9443c01a7336-20bc5a5c813mr96194525ad.43.1727948781738;
        Thu, 03 Oct 2024 02:46:21 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beef93c2csm5766615ad.138.2024.10.03.02.46.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2024 02:46:21 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] Add support for true/false, yes/no & on/off in bool-type
 options
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <a6da5ca3-5698-4934-8213-b52cfcd59bb9@murena.io>
Date: Thu, 3 Oct 2024 17:46:07 +0800
Cc: Hongbo Li <lihongbo22@huawei.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <21B6E9C0-9A84-4B54-9FC8-307E82AB6006@gmail.com>
References: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
 <20240718122926.99326-3-integral@murena.io>
 <u3wl6277ljmgqlbjw5pxu3oeljgftekeati6xcsyfden25umo6@p3z3z4yc6drg>
 <55b29fbb-3aa8-4ba7-9668-aa19dbb02e78@huawei.com>
 <a6da5ca3-5698-4934-8213-b52cfcd59bb9@murena.io>
To: Integral <integral@murena.io>
X-Mailer: Apple Mail (2.3776.700.51)

> On Oct 3, 2024, at 17:35, Integral <integral@murena.io> wrote:
>=20
> Therefore, if my original patch is okay, could you merge it?

I took a look just now, I think you can use lookup_constant.

>=20
>=20
> Thanks,
>=20
> Integral
>=20
>=20
> On 7/22/24 12:03 PM, Hongbo Li wrote:
>>=20
>>=20
>> On 2024/7/19 6:50, Kent Overstreet wrote:
>>> On Thu, Jul 18, 2024 at 08:29:28PM GMT, Integral wrote:
>>>> Here is the new patch:
>>>>=20
>>>> Currently, when using bcachefs-tools to set options, bool-type =
options can
>>>> only accept 1 or 0. Add support for accepting true/false, yes/no &
>>>> on/off for these options.
>>>>=20
>>>> Signed-off-by: Integral <integral@murena.io>
>>>> ---
>>>>   fs/bcachefs/opts.c | 18 +++++++++++-------
>>>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>>>=20
>>>> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
>>>> index 0770aebef6d8..0e4cd6984eda 100644
>>>> --- a/fs/bcachefs/opts.c
>>>> +++ b/fs/bcachefs/opts.c
>>>> @@ -332,17 +332,21 @@ int bch2_opt_parse(struct bch_fs *c,
>>>>       switch (opt->type) {
>>>>       case BCH_OPT_BOOL:
>>>>           if (val) {
>>>> -            ret =3D kstrtou64(val, 10, res);
>>>> +            if (!strcasecmp(val, "1") || !strcasecmp(val, "true") =
||
>>>> +                !strcasecmp(val, "yes") || !strcasecmp(val, "on")) =
{
>>>> +                *res =3D 1;
>>>> +            } else if (!strcasecmp(val, "0") || !strcasecmp(val, =
"false") ||
>>>> +                !strcasecmp(val, "no") || !strcasecmp(val, "off")) =
{
>> Sorry, may be I was wrong.
>>>> +                *res =3D 0;
>>>> +            } else {
>>>> +                if (err)
>>>> +                    prt_printf(err, "%s: must be bool", =
opt->attr.name);
>>>> +                return -BCH_ERR_option_not_bool;
>>>> +            }
>>>=20
>>> There _should_ be something more standard in the kernel for parsing =
bool
>>> options (commandline options, module options) - please hunt around =
for
>>> that and see if it works; report back on what you find.
>> I find in Documentation/filesystems/mount_api.rst, it give an =
explanation.
>>=20
>> ```
>> Note that if the value is of fs_param_is_bool type, fs_parse() will =
try
>>=20
>> to match any string value against "0", "1", "no", "yes", "false", =
"true".
>> ```
>>=20
>> But this has been handled in fs_param_is_bool with macro =
fsparam_bool. Many file systems do this in fs_parse. I think the =
original patch seems ok.
>>=20
>> Thanks,
>> Hongbo
>>=20
>>>=20
>>> We want to be consistent on how we parse bools throughout the =
kernel.
>=20

