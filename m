Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77A033D8
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 03:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725161298; cv=none; b=uA1mgsESgJ60BQxqogWRXQR4P5+9mdh/OQEhv1hQ9rFM1FoyNdQkABTvkDJuKAkE+E8g4Dbe64flii6j1Vy+/wZpLe94MG56KY5Sor/SaHB1p/UtkLTOKIOU7/Wau9bvV0Bi9753n/wzEt7cvgsbj7YSeD/O0uYmMaQCY4i1AIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725161298; c=relaxed/simple;
	bh=hQkXFHnTR2Ig9V4z2TEilT1JFS0c3mURgc9hUTjKQcE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mKesWMlJY4sVAiFotWRBDihotOCbioDvDM/yRWxn2uEyvZd0ILbTd2Sq7gWRHASVLlzql9DAW66A9UDMMtTO7tRGL3JkXqukqHpBO2FYkly91Z+O9I5gT0JhLNln5VE05g5F/q4/aufUhd4SuiBOMuqm8FQ7TItPjHzC8IL2la4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqa1bGBc; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqa1bGBc"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d89dbb60bdso506823a91.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 Aug 2024 20:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725161296; x=1725766096; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1VpDNdi4LrZYCQsRPnFtPmWf8abfqa1tKn3LahL3Xac=;
        b=gqa1bGBc0uynYM1jMtSvdMoIsCIco2PaVDeG+1DXLH4BdkVjhmkYbi9ErkRfdVcYsQ
         0rff+mz2VE0kVKSgi9bPmcgovu3c4smbG7xu5rGng6zByoOGFX9Rq15IhhIJLY8hV/Ap
         X+5Pscw+W/P4/80eG2feo4rI93tn0UtSE/bckpp1YXE+4gO2+WU1+qb54R2Vefg8G5ec
         hsAwO9UPBllSzPhVEiwkSUnmlaTN7ntEnxqxHUZIdTv3z4mKlTJ0yC+3QKm6kYalJCEd
         Qlzmno2YmuQ+F8UxWGB/Uq+2ZBkRexGcfKXjtBV7aANLNVhWkOq7MgDOYV78iQaliVi4
         NDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725161296; x=1725766096;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1VpDNdi4LrZYCQsRPnFtPmWf8abfqa1tKn3LahL3Xac=;
        b=pnGCNWfitnekaiVetz0nAMMzbecAnayNcKV6faaM+01safoNqr1M5YTDOIGlM7dz7y
         9fsd/6AhdhVpeIVnPaZGrGgww5eVVVvC8MQKZelRbIBfHJjbi7CDbyDNdOGIYKiOtLio
         btpZgQ3Dwx1mRknExwm/Rtr4hvUkUzVuyB/GzxBrhsu7TjK6W3tzm5FRMDky2jwW3Emi
         Vl+ak1A0MFb1N3uE0OeNNvbVjEFkbGceMkmx60AFB1NEHeP6c3tL8CDUjzywVN5A/bd8
         7l8SMwNSSgI2sEyfagG8vb6E2Xyh/7BJWMUysh7GIPfPTxO7juT9KEsdc6VhwA0TYBQT
         oErg==
X-Gm-Message-State: AOJu0YyKo3tBgHkxzVNcGt0BtqXUDimlkexkmPTYyPIgl/X5rOIDsrPw
	0uFSUSJbiupiBff2VC1ZtmmLAqkkyz1okTWphz/RpjKJpd/4YXYUTBEm3Q==
X-Google-Smtp-Source: AGHT+IF3LF2WMDSi24qcaUB+j4s98IU+5eP29r6LQiP4EoRAJdr6V5oARBPoFvklgFMfRb71JT8kPg==
X-Received: by 2002:a17:90a:3da6:b0:2c9:a015:ac2e with SMTP id 98e67ed59e1d1-2d8561a2013mr12216842a91.14.1725161295826;
        Sat, 31 Aug 2024 20:28:15 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d85b12553asm6520855a91.22.2024.08.31.20.28.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Aug 2024 20:28:15 -0700 (PDT)
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
In-Reply-To: <viwjm5w7b7rwjewxn3aleluzkgttlc6j4cfcg4x7sadqtd65k2@plktedd7yfam>
Date: Sun, 1 Sep 2024 11:27:59 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E4EF9EA4-9EFE-4BAF-8025-349B4F175134@gmail.com>
References: <20240827151448.680522-1-mmpgouride@gmail.com>
 <hp2wa4k32nej5x5rgp6l2ffxsrdmgg2x5nxhuaqjzw7l24xmr3@pzticjr576mf>
 <8DC4157E-A12E-45FF-A3B4-F5DA1DC55A24@gmail.com>
 <viwjm5w7b7rwjewxn3aleluzkgttlc6j4cfcg4x7sadqtd65k2@plktedd7yfam>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

2024=E5=B9=B49=E6=9C=881=E6=97=A5 11:10=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> wrote=EF=BC=9A
>=20
> On Sun, Sep 01, 2024 at 10:50:37AM GMT, Alan Huang wrote:
>>> 2024=E5=B9=B49=E6=9C=881=E6=97=A5 09:09=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> wrote=EF=BC=9A
>>>=20
>>> On Tue, Aug 27, 2024 at 11:14:48PM GMT, Alan Huang wrote:
>>>> If the reader acquires the read lock and then the writer enters the =
slow
>>>> path, while the reader proceeds to the unlock path, the following =
scenario
>>>> can occur without the change:
>>>>=20
>>>> writer: pcpu_read_count(lock) return 1 (so __do_six_trylock will =
return 0)
>>>> reader: this_cpu_dec(*lock->readers)
>>>> reader: smp_mb()
>>>> reader: state =3D atomic_read(&lock->state) (there is no waiting =
flag set)
>>>> writer: six_set_bitmask()
>>>>=20
>>>> then the writer will sleep forever.
>>>>=20
>>>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>>>> ---
>>>> fs/bcachefs/six.c | 12 +++++++++---
>>>> 1 file changed, 9 insertions(+), 3 deletions(-)
>>>>=20
>>>> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
>>>> index 3a494c5d1247..b3583c50ef04 100644
>>>> --- a/fs/bcachefs/six.c
>>>> +++ b/fs/bcachefs/six.c
>>>> @@ -169,11 +169,17 @@ static int __do_six_trylock(struct six_lock =
*lock, enum six_lock_type type,
>>>> ret =3D -1 - SIX_LOCK_write;
>>>> }
>>>> } else if (type =3D=3D SIX_LOCK_write && lock->readers) {
>>>> - if (try) {
>>>> + if (try)
>>>> atomic_add(SIX_LOCK_HELD_write, &lock->state);
>>>> - smp_mb__after_atomic();
>>>> - }
>>>>=20
>>>> + /*
>>>> +  * Make sure atomic_add happens before pcpu_read_count and
>>>> +  * six_set_bitmask in slow path happens before pcpu_read_count.
>>>> +  *
>>>> +  * Paired with the smp_mb() in read lock fast path (per-cpu mode)
>>>> +  * and the one before atomic_read in read unlock path.
>>>> +  */
>>>> + smp_mb();
>>>=20
>>> What is this barrier ordering?
>>>=20
>>> This is only a change in the !try case, and we didn't do anything =
before
>>> checking pcpu_read_count() - except way back in six_lock_slowpath()
>>> where we set SIX_LOCK_HELD_write, but that does have a barrier.
>>=20
>> Make sure six_set_bitmask(lock, SIX_LOCK_WAITING_read << type)
>>=20
>> happens before pcpu_read_count()
>=20
> that's in another thread, a memory barrier orders things in the same
> thread

six_set_bitmask(lock, SIX_LOCK_WAITING_read << type) is called before =
__do_six_trylock()


