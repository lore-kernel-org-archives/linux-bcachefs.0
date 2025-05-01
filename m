Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50B0215179;
	Thu,  1 May 2025 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746120528; cv=none; b=eZ9M6quCY19flP+qZLlhlBxSlgbMYuZCBRo1kFmc0SQ4U7FHxudKOSaHzbJ/liDE3TNvfndxTHmJYygkxM1XGUshjxJuf5MrrJ1DScgiU05wYnMg94GyYzFMmdRYMnPgcrXEAQNYiogGDBkTqq33jkvmVWuQlTpAYLpPjllwIyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746120528; c=relaxed/simple;
	bh=ZKcuaFW2oPn0jqodDr0XtTaRO5hQX0tUhd25Cdcl2zI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=FWfVp7VcEXpwQzObm8LB2ipwvdOOtC193Efok5iy3aAibRwjYtg9dWjJKT1MxHavKkD81zFt7V7s+ZzrYUVeFykw6miELkuzWAvDWthA5X+9d6E6Zzie8vrBI7yRH+iv9w7FUHxqZIn/Vut+9qRIkVSh1TC0egXlmRc7HvVr8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GA3IgpZJ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GA3IgpZJ"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7394945d37eso1153942b3a.3;
        Thu, 01 May 2025 10:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746120526; x=1746725326; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gk0ol3/wv1Ndo/6VMxze6mTl31v+JnNdZPKIadRxVM=;
        b=GA3IgpZJdbHvpfw8j6xuxwWNA8kB6CeOeno6bUDXEztTc86QidXbEtGuxORTWHaplp
         Lzw0ZpmvlzVr421+KtjctWj6g4YQfDlpZtsvcpZTbV25lK7X5Bixxot3iO0pSP8iBKPl
         znySmG6jtCA462jVK56SSYPy2TCADKqK9OnjFjev5lBg7blzdsgHrMH2fHKI1Tulom00
         l653i9luFQnUMBjAedSQwsEBtWJRp3B3kg8BD7PNOjzi1M0uvU6mipMtb5AM0cQI4vlY
         5yz9OjIFddpMAKLUTzdmCD20ntix9fMuj890+0HvQbF6jFLaij7twLrDe45QeqqOFvxd
         b9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746120526; x=1746725326;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7gk0ol3/wv1Ndo/6VMxze6mTl31v+JnNdZPKIadRxVM=;
        b=YwPdQoAWKcIO1h/Mg0IIaw1/YHfYANtesI/0EiwALcA4/Je3m0GkhBD9SRpxt08Ilh
         uRzkBH+dbicjP+z7yAekfsY63ijG3dCLd374iNUoiEWtXl1S2vuG2zygC1bYDJhBgcYN
         xDzEDkOUNulGucGGhAdWy0c7gKfoPVFyfPobOdjrxBOtg2WlytvAi1m8h96RQIGgqnCt
         M+7Ea84h8gIemEbYXcYbnpV+IKqWelzQlDP8Ayh5bwGiAfJ+YxNb2DzI8mD3hUBIs/s0
         Y5swNs+YnFP1ZNDSkSYxOTXUwVwoy3vWeLMSiBj7EsVxXYgtL7zwuH7aH9Pk7x8jQ5i+
         RQNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU585SftOf+USaLf7KxRy/dLPJYJYSlj61KXrAj4T1nVedK/Kz9+l7xAOuEl3kWOTucMGKhfoCjuzP/Lp2k@vger.kernel.org, AJvYcCWqZQG4+YEctdZEO5cfe66lpz6VgTR6F0oKe0mvhSiBxcUbwreGpXFeypH0eq7oTtdU/PEeXJKgWFS6EY+srw==@vger.kernel.org, AJvYcCXQrfhfysVGU7vaNX4EdmQDUP6l007jdMW0z5e11w1NqP35aI8KKPDs9edEKxxhg0lFKyejf+LNh8/oLwfJI2S8@vger.kernel.org
X-Gm-Message-State: AOJu0YwctxS5FO0Wf+RE7J0CHyPWD6mr7jeoP9fpWTWsWvLgtXuuODpu
	VAo2I20TL9QnJjeo6IGFad35sJCEesxYf4G6W54eZGFPwTAqpQYKGCP/Cw==
X-Gm-Gg: ASbGncvPj0I4Z9uVX7MBjCkyT5Pc44+DaJPBItxRKXIjMD88mpuWallMAuco3uooeJY
	3M3vwihb/ywMY6OkERVKTJdrawWypeAaXeluAWeMiIYougDTIcSzGsoWY5ChCzvP+k763nQQKpi
	4fnvzBwsuDx6Og97HygYbWaJNlECWNUmVWP3jOn5x2BvQ509nb6IGUPbDL0NaERceytuF2gYRqO
	Dw4BPdefzZ8YJGheLXR5RM9TYmlRfC46yCCf5KBwunh/qEaLVuMJGb5J/XGhr9Y3KB1aV3+ISnZ
	H7MEx8CkTxnDjB3XUa1U/0FM
X-Google-Smtp-Source: AGHT+IEgg7uXTQ3WUEXhJXM8v3+QeUxJpI0i4LZui8mpkQ/mbC8oIZwbu+WgLDu6v+KCE7SlcmbSvw==
X-Received: by 2002:a05:6a20:2d1f:b0:1f5:8d3b:e294 with SMTP id adf61e73a8af0-20ba70f1ee4mr5342966637.16.1746120525853;
        Thu, 01 May 2025 10:28:45 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f9d4799e0sm1013074a12.14.2025.05.01.10.28.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 May 2025 10:28:44 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <aBOtxplvvpgHed7o@archlinux>
Date: Fri, 2 May 2025 01:28:28 +0800
Cc: kent.overstreet@linux.dev,
 Thorsten Blum <thorsten.blum@toblux.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Bill Wendling <morbo@google.com>,
 Kees Cook <kees@kernel.org>,
 regressions@lists.linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 ardb@kernel.org,
 ojeda@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9967EB7-7F4D-4122-9470-DB14700FD906@gmail.com>
References: <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux> <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux> <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux> <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
 <aBOtxplvvpgHed7o@archlinux>
To: Jan Hendrik Farr <kernel@jfarr.cc>
X-Mailer: Apple Mail (2.3826.500.181.1.5)


Thanks,
Alan



> On May 2, 2025, at 01:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>=20
>>=20
>> I wonder if the __counted_by(x_name_len) in struct bch_xattr is =
needed, since there is also a value after x_name.
>=20
> Wait a minute. Are you saying that the value with length x_val_len
> is behind the name (of length x_name_len) at the end of the struct.
> So essentially the flexible array member x_name has a length of
> x_name_len + x_val_len and contains both the name and value?

Yes.

>=20
> If that's the case:
>=20
> 1. that's not at all clear from the struct definition
> 2. __counted_by(x_name_len) is not correct in that case
>=20

Both clang and gcc say:

    =E2=80=A2 p->array has at least p->count number of elements =
available all the time.=20

Note the at least here. Though I think the counted_by is misleading =
here.

>=20
> Best Regards
> Jan

