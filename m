Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1F32901
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 02:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725159054; cv=none; b=duOZoWbcD2cwazutWHEbyV/UpEY9pyNOo5e+/1HNcjytcerncRfRic5vtRPNRVk1immiTTvLmKwPP9be0ATKZaE6LvIvOJkMe5k+/cW/hUTiMGBDRGemDPwyq4yfFWYdYJqS9spKZ2kur3DejwqmOZ5cGuUJdB/l8H6tBDB0UL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725159054; c=relaxed/simple;
	bh=m9aRQPKEZKLBV+0YU+CLDNOzpFvaPBxRdHvahNRLynw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=i7RNxFeCHf5imJ+cfyq4PM/EqtVPzhyK8KwKY3kTUsWC77Pg4OG7eg26E9msvY2flz0DVkK8j/T6emYUW72aS80I/9ApdKM/D6IqtVye7xdLQyZgXhsHJWZoLJnO+YoRgtVKbewhuaXRa89fY0TR8SinlpGZJsnA0TcEKwaQbkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mjfeyyZK; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjfeyyZK"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2702a00aad4so1626045fac.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 19:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725159052; x=1725763852; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZrMfCgBQ+ZfM+33FRmQQ20gabgolE9U7Pt1Wqxaveo=;
        b=mjfeyyZKg7NkyvA8PvmXhcr+FDUKLhuZ4Y49NePjnrl3N++J9nfezMWWEW/arWtw7z
         4uqU/CQg582Hw8A6hN3fy6vIBFZVZsaJC0OE/6eBPWrpbUspTdQ1caypRLZiZAgvcQXj
         P/YOATMQeeJZmmFP7qSo0kVv0TjbRnnH7wIjkyHvYy1EFYUd0q2H9oYzHrj772CQ3KS6
         2foPTXmZ65Vg8rmKK5Ek4XE2PqEiotwwj+rJzsQw5wcSva4OtbkV9tMG/tFQ4UxctBP2
         TfPvOYHMAXixedLxGLF0NZwY6lPp5KwhFpm94cpYHLVCbZ3lSYf/L4rmSkJ8FRyi2fvb
         t7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725159052; x=1725763852;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZrMfCgBQ+ZfM+33FRmQQ20gabgolE9U7Pt1Wqxaveo=;
        b=xT5yBYmb8GfoxS9MO7GWfKI8ZOm9RyAn+BP7ZRUIWqubcd74ynYpKzEigzVoZ0f3PT
         83Gr/zGYb184yN+TQq5lnCMyf69kMo9L40zPNU578SOPUc85fSPKjYTH0FA0GskqJ3b7
         780WcUgEsa+QVPCcdpHO2bddhNQODnm4Ej3VfzOHhd/zpD9M82vLVrrMf25Acl+gNH8H
         AlVZHlPmqOxJbEHC2IpEMXpRXWDkn/fVopvuwGtsKhjyxFxzg0gbknD/hOVmqpB1FOjy
         DeLHABfx6fxY6FCc3RRclcjXKzRg7CxeD7oFCmafEqKEnh+ameGQZujtjgRh6LXKUBmZ
         nazQ==
X-Gm-Message-State: AOJu0Yzx4uZeUBBt40ElA3cGUFLxgENBYIHQoQzUYgpTyzzrlGv4q5X0
	pnPCBcVoGPWF1Ox2BJreEiXLCqMOhP2xwWlwOp6GK+MxWSIOj9ry
X-Google-Smtp-Source: AGHT+IGj1hZeD476dTHfUIpWxHWKJe2MeZQHOW7TvneT9Oq2EoS7moFUpFZDaYry2zvI42gAMtoGMQ==
X-Received: by 2002:a05:6870:a34e:b0:25e:de4:9621 with SMTP id 586e51a60fabf-27790142a9emr11498589fac.24.1725159051738;
        Sat, 31 Aug 2024 19:50:51 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e575c0a1sm4793012b3a.194.2024.08.31.19.50.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2024 19:50:51 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcachefs: Fix lost wake up
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <hp2wa4k32nej5x5rgp6l2ffxsrdmgg2x5nxhuaqjzw7l24xmr3@pzticjr576mf>
Date: Sun, 1 Sep 2024 10:50:37 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8DC4157E-A12E-45FF-A3B4-F5DA1DC55A24@gmail.com>
References: <20240827151448.680522-1-mmpgouride@gmail.com>
 <hp2wa4k32nej5x5rgp6l2ffxsrdmgg2x5nxhuaqjzw7l24xmr3@pzticjr576mf>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

> 2024=E5=B9=B49=E6=9C=881=E6=97=A5 09:09=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> wrote=EF=BC=9A
>=20
> On Tue, Aug 27, 2024 at 11:14:48PM GMT, Alan Huang wrote:
>> If the reader acquires the read lock and then the writer enters the =
slow
>> path, while the reader proceeds to the unlock path, the following =
scenario
>> can occur without the change:
>>=20
>> writer: pcpu_read_count(lock) return 1 (so __do_six_trylock will =
return 0)
>> reader: this_cpu_dec(*lock->readers)
>> reader: smp_mb()
>> reader: state =3D atomic_read(&lock->state) (there is no waiting flag =
set)
>> writer: six_set_bitmask()
>>=20
>> then the writer will sleep forever.
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> ---
>> fs/bcachefs/six.c | 12 +++++++++---
>> 1 file changed, 9 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
>> index 3a494c5d1247..b3583c50ef04 100644
>> --- a/fs/bcachefs/six.c
>> +++ b/fs/bcachefs/six.c
>> @@ -169,11 +169,17 @@ static int __do_six_trylock(struct six_lock =
*lock, enum six_lock_type type,
>> ret =3D -1 - SIX_LOCK_write;
>> }
>> } else if (type =3D=3D SIX_LOCK_write && lock->readers) {
>> - if (try) {
>> + if (try)
>> atomic_add(SIX_LOCK_HELD_write, &lock->state);
>> - smp_mb__after_atomic();
>> - }
>>=20
>> + /*
>> +  * Make sure atomic_add happens before pcpu_read_count and
>> +  * six_set_bitmask in slow path happens before pcpu_read_count.
>> +  *
>> +  * Paired with the smp_mb() in read lock fast path (per-cpu mode)
>> +  * and the one before atomic_read in read unlock path.
>> +  */
>> + smp_mb();
>=20
> What is this barrier ordering?
>=20
> This is only a change in the !try case, and we didn't do anything =
before
> checking pcpu_read_count() - except way back in six_lock_slowpath()
> where we set SIX_LOCK_HELD_write, but that does have a barrier.

Make sure six_set_bitmask(lock, SIX_LOCK_WAITING_read << type)

happens before pcpu_read_count()

>=20
>> ret =3D !pcpu_read_count(lock);
>>=20
>> if (try && !ret) {
>> --=20
>> 2.45.2


