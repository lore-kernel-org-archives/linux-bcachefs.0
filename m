Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F54219CCF5
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727969444; cv=none; b=g8i+kKay1bfnHzd4G22Q1oC6Okqkk/SRLoltuXbULWNAKcCqXKAe2pyMhqySTd/899uR7NyWpbqTgMsicrGlKMWOVQw0kiRZ5ZER0kR5L6x9eafvgFu76G6KVS3c1yl1yiDpEBnVJT8C9wKno90batilyc1dVFtLs67tdAsx1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727969444; c=relaxed/simple;
	bh=Cx4Y4EIPbRLGBZOJ2U9uswU7XGSHhz+L/e8UGfY1ngs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=g3Vih5lw3C9mmZFxAcYx6jxuy/5+UQiM5wZyFoTkzPTB/G60oNouOP0bf11ekybXJ755ujcaDDJDyS1kIBQESz/hks1b6yPBLep9wsYN7mngQ59QpJpNbukDnM/HPeOtgoYBw2xWYnT30QZNgk+N6SfMBDUAuaJJW98gH7SXaV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=NQq1eDhI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="NQq1eDhI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42ee66c2c49so1629095e9.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 08:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1727969441; x=1728574241; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cx4Y4EIPbRLGBZOJ2U9uswU7XGSHhz+L/e8UGfY1ngs=;
        b=NQq1eDhIGMvWgFRK25N+IOcReIq27QXtKqwCpgCZC6/AHZ4vVOFaoTxdf5WQ4kU1fX
         fUL0eORMR8Pl4nuOOGFeviIaubw2KZiwq9kFMVKVycEwAgp+oHikZff2WdzX5FsAgEVH
         vmwP9kyjB0n3lsgyeGY2wUEm/Iy7BJYxtmya6/z5DBJXCHZyYflwzD97XfrCO26sRnWX
         VKbaj2bSIXfqtOTk+G1ANKxt1iGuaEmkDPVC+5EFLOKOYw4R5Vxki1bjkxHvUzyEB7We
         /8z1+ok6y1USjbObDzysFKUmvDcDyKnSJqBl5IuGhiERJJMnRF1+veIQKiWcyFm1nHkG
         kmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727969441; x=1728574241;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cx4Y4EIPbRLGBZOJ2U9uswU7XGSHhz+L/e8UGfY1ngs=;
        b=CrhiT+cKUIEemd+/XrKDNZREdScHBXHzx1OSZbl3irZhHAL76YeoAaNWqEiXP5BFd1
         2Hpu9WH/tSvhRBEqDcfj78E1K6C6y9bHTbzPntyGkTEfem8INDwWMwMr8XAC12BT2FgX
         NM43RuiZX3SObQvbyHF2idHl8PF9yD364j75w3RGs7g7uTiHgnIQA1a/mMiFsJP5lYjH
         b4W5UKYAFtE3Bz9fzo3dGAdlzgsyc4w0fqZp0rv9WusMxBbFoeWlQOdVH8xJHZVP86Cp
         UThdzQ772rFYqOJRnFkx/NntLtg28UyQO36ivsA0VoxjvJzpsRSO9tX2esoI6L2ui9Ma
         oxnA==
X-Forwarded-Encrypted: i=1; AJvYcCWkObBzlR/l0nDLvKiKXFpiIOFgJp2tfisOhZLrU5X2RXvexYZqLBmrVJgnZxMXGzp8sUfS3bBcossPEPgSSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgMvLZJaEFIv1i7YVHKXDOyfXK1D6meJ4MCVt4n4oJT2k1WypH
	rKAeAXTeS0S3zJ6RiizsheoTtfIGKBhP5U49N7sIWcCXTM9bY8lkfHdNy8eqW8w=
X-Google-Smtp-Source: AGHT+IG1CWXzgBWSp2zEqk/fVKLo93dcFsrO6YxiqkpAdkLG0XAdvAg7Dxpmf46BKl4Jop2PrKfgqw==
X-Received: by 2002:a05:600c:3b02:b0:42c:ba6c:d9a7 with SMTP id 5b1f17b1804b1-42f7d0a09a9mr18086265e9.4.1727969440783;
        Thu, 03 Oct 2024 08:30:40 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:a4f:301:1558:85f1:4dd0:3ea9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d0822b94fsm1504884f8f.46.2024.10.03.08.30.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2024 08:30:40 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <Zv62pi1VVbpkvoDM@archlinux>
Date: Thu, 3 Oct 2024 17:30:28 +0200
Cc: Kees Cook <kees@kernel.org>,
 kent.overstreet@linux.dev,
 regressions@lists.linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ardb@kernel.org,
 morbo@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <83834AC8-0109-40C5-A80C-8BFFA8F16B19@toblux.com>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux> <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv6YInHiwjLeBC3D@archlinux>
 <63D4756D-31B7-4EA9-A92F-181A680206EF@toblux.com>
 <Zv62pi1VVbpkvoDM@archlinux>
To: Jan Hendrik Farr <kernel@jfarr.cc>
X-Mailer: Apple Mail (2.3776.700.51)

On 3. Oct 2024, at 17:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> On 03 17:02:07, Thorsten Blum wrote:
>> On 3. Oct 2024, at 15:12, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>>> On 03 15:07:52, Thorsten Blum wrote:
>>>> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>>>>>> [...]
>>>>>=20
>>>>> This issue is now fixed on the llvm main branch:
>>>>> =
https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf76=
9fc9a93e8a
>>>>=20
>>>> Thanks!
>>>>=20
>>>> Do you know if it also fixes the different sizes here:
>>>> https://godbolt.org/z/vvK9PE1Yq
>>>=20
>>> Unfortunately this still prints 36.
>>=20
>> I just realized that the counted_by attribute itself causes the 4 =
bytes
>> difference. When you remove the attribute, the sizes are equal again.
>=20
> But we want these attributes to be in the kernel, so that
> bounds-checking can be done in more scenarios, right?

Yes

> This changes clang to print 40, right? gcc prints 40 in the example
> whether the attribute is there or not.

Yes, clang prints 36 with and 40 without the attribute; gcc always 40.

>>>> I ran out of disk space when compiling llvm :0
>>>>=20
>>>>> So presumably this will go into 19.1.2, not sure what this means =
for
>>>>> distros that ship clang 18. Will they have to be notified to =
backport
>>>>> this?
>>>>>=20
>>>>> Best Regards
>>>>> Jan
