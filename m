Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91D642A97
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 02:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945698; cv=none; b=IW5u2w7xbmfbij2eVRe7fjdQuqaAxjIufCj/yisbo2sPbdjD/DAgs9yIEnN3XFT9xKnk+CELrN+cyc2xzQIaOeKpgBzmNaRnPTIk1Q36Sp/U3GRnfSv5Oo4UjYknKVh4whmZePbJG2XtkCHsKViKnPP7MulxSRYitOJEM49O8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945698; c=relaxed/simple;
	bh=5sz7nt54ekNj3mEIcCr2gyeKKU/altdQTr9l9p8s1fw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bkuNdq/2jDp9X0rLpmAjHvaI+WLFipyWQia5Ab38jQ0ZgsclYs/hRMwPIBs56VUFRGcrH2CU3/+OLTwEnspZelrS3Ig5q+KROm5tBB+KpgX3OsmVPFwQHlqpRzFNiI3OeIti9zD6ktc/D27CD9fnx1Gs3DHXcLNnoRTL4rOB0cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E+kPmMSG; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+kPmMSG"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a3b0247d67so1949955ab.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Nov 2024 18:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730945696; x=1731550496; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5sz7nt54ekNj3mEIcCr2gyeKKU/altdQTr9l9p8s1fw=;
        b=E+kPmMSGfUq4n2VT8D6VhF3/82FgUIQC3ItzwiOhJR4QqJy2CeAoUCYvQsdbp5XKGi
         +YeI/4hHBwrLtNoyCHl+HoPznn2XbNB/r4MbDKdyvXZLXjWeAddslVP0VM7zQRK4LeL5
         fwbEkBGJ9L6SDYwVATYntrescMKs59OspfiVPMv7SQ699HIelcwZAICVKT8XF8D0fMcu
         csYIO/P65nBPEuxp0t+hIO4L8slcc+DCZUEIWx5R8KTCdBaej0yBPwSCsMjUZSgtwIsG
         5/2i+vpzpeX2u2IjaD/m1FVuxXRB5FOBLgOncDjVjNr/GHzD8A4lX27KYlOzWl/vpUm5
         PurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730945696; x=1731550496;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5sz7nt54ekNj3mEIcCr2gyeKKU/altdQTr9l9p8s1fw=;
        b=Vtq4lqa3lpY2J6lE24SaHyXSio4p5fxaPF9JyIYJxJEU8MSnhxXyamKhLMngTdJ92W
         fe0oJSkRrdJsSAJCHMiPoHp0v0jy4yM+HJwjBTZco9xTHm4xwTkXovEnrds1NObAqq5R
         QgTpdX6os22LqbAJfQza2yToMm0ABxEeaGUY3g6dCRfZSasW/HvGAHpyF9nq5lur9WUX
         eE6n9eF6N2ocOAU6Yd/l55ugny8xsyqvPTOFOXmNr1aZ5KDhHWCiOHBE+NxM8XvKNGlL
         gO4pXGmZMiH8iQG/iyO+P9vsbiR+jUE+zrRYdoeYAj/bBV9a5dpu4UoWuI8mlgCxO1Bc
         fwkw==
X-Forwarded-Encrypted: i=1; AJvYcCUECzFZobIVKJvmR3hBn96PystDYoO4CTMjLjKZyx+PLT4o0GXakWaXd4aldzJCgKh2LmsEOhlJZnx/ZN55oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/B7pmEdKoxjLzKYXoJJgstlDaq6LDdaDQIYHYCX4cCUYJceAy
	DtWmsAKbckRecOjGxlf3xbNAgoclBSTrYUWLOC6DEhD0BoU/q6IT
X-Google-Smtp-Source: AGHT+IGJxIl9Z3fRNADNQ/kJ0eemjUD/XbSIKpG6wW5+L30Jt8tjpEzpaVEx1Ogk+Dt5KtJNIdELZg==
X-Received: by 2002:a05:6e02:1d9e:b0:3a2:7592:2c5 with SMTP id e9e14a558f8ab-3a6b031a2e7mr229373855ab.17.1730945695991;
        Wed, 06 Nov 2024 18:14:55 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f644db5sm210104a12.55.2024.11.06.18.14.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:14:55 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] libbcachefs: add support for true/false & yes/no in
 bool-type options
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <kfqkrmgcyfrtdqqgmohuiykzj54guywr32jbc6a32gny3yk67h@b62qzrg4zr2r>
Date: Thu, 7 Nov 2024 10:14:48 +0800
Cc: Integral <integral@murena.io>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <258E7BB1-C6B1-4B3D-ADB2-685C003B9A75@gmail.com>
References: <20240718071346.68754-3-integral@murena.io>
 <kfqkrmgcyfrtdqqgmohuiykzj54guywr32jbc6a32gny3yk67h@b62qzrg4zr2r>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

On Nov 7, 2024, at 05:20, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Thu, Jul 18, 2024 at 03:13:48PM +0800, Integral wrote:
>> This is a resend of my previous patch with code style optimized as I
>> forgot to add Kent Overstreet in "To". The previous patch is
>> =
(https://lore.kernel.org/linux-bcachefs/20240718062835.58037-2-integral@mu=
rena.io/T/#u).
>>=20
>> Currently, when using bcachefs-tools to set options, bool-type =
options can
>> only accept 1 or 0. Add support for accepting true/false and yes/no =
for
>> these options.
>=20
> Sorry I missed this before - you just need a signed-off-by line and I
> can apply
>=20

There is a v5 now:

=
https://lore.kernel.org/all/906b76f2-479d-4d12-b9ed-eb19fb108079@murena.io=
/T/#mea54884e20fa63d4ee32132a1980749e9f6283b9


