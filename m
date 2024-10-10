Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0318E1953AD
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578400; cv=none; b=Fytx7JgcefHsNarINVJ96Za+8bbr36x9kWVfvFiLmf1iEtCBlo0mR1z1G/PelAEhliTefVTADh7w+t2Sw98PDyCjs/wi894d3g8cyrwgOzk15MKUXq1ux6t3e0rGyU0p/1GicTCmUQIcsdthyXFGToI9LbXZJlhHCPdF3nQhYPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578400; c=relaxed/simple;
	bh=z9/Z9eosGs73eqPcI3xxbL+eKrchlqfQ2+7PYsST1Xw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=iVLDpCITXzX8g3r1k+mW6ZoOJBf/7cDJi4z8Ihlb91DmJohEv1+x6GM6JLRj43kBRjcLpkSDgyHy59+CIWfNC0b8pXcq3RJetimC+lmuDSERzmpk6FcBxw4+PfCCn3wgsNQWN7BAOb7IO41xoqvk/qcXoedG/08tmOMQiQcvIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkXntOdQ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkXntOdQ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20c7edf2872so9794105ad.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 09:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728578398; x=1729183198; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCZLkBjZ3d134lTld0cXB5MqLxpPLshQ3ANehJL/xl8=;
        b=HkXntOdQvyqUIRNMZWhWsyM2Bke6TnrguUpzn+0YO0kgDoy8smIdmFpMPyPvxIvaXe
         73D+itOyZZwK5NmzkSgbLPmmgkW005TRQYRPOfGaarb0gHluOXmb8UqNZEnWMBfnbJNx
         6IHMOXvGCcEFvHwLjRyTjOoXc97ASRHYKkMwwN7PPgO3an+gspPn7BjttftHmApQaWmD
         6K5H25Gt3MFKeltxtzbyaeabftqXuQdv16hgVPizNtFREWFRHIUpWQ1VXKKgVkTU9J2I
         7Tw5aPtfIu+go1gV2z4Mjro0l0/N2JhJeNSgSdmBJwcvhKYVYUi3r0sqXFpIB8shzQfa
         kPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728578398; x=1729183198;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCZLkBjZ3d134lTld0cXB5MqLxpPLshQ3ANehJL/xl8=;
        b=OB553pFwXqfMbfPsuLNfZfzgK70Bm2EveKuBnRWomks4fOZq18y9HKPqOEeoQ5PBQT
         B6h+6xD0IYkmbL/D0b620fnXBgRRMAU7OJxW+29/8w4Ig0ofW0kxAfeYEUYjfDEo3hHa
         EGXz6RHTI0VVLERVr0t7/kWM9/qhc9r1gysIchziSw1Vnkd9kpOnE725R+KdHMr+kxAP
         voLtiJI6vdazarm/XwqvD/wbeL/zZ69dBb7COu7a3owSmjg54o/CvjMdSajqPOlLwrnM
         93TJLCnNBNlo6q1BCh/Wd7jazcQJcw0fD39VJ1ulol8BqLxNaLfgoq3PWKf5ZObGzRPH
         cJZQ==
X-Gm-Message-State: AOJu0Yz6/LUlz3xuqFo3gaQBw4TP4G/JkGNDG4qgzhaagAZwrekH4lXj
	OY5/l9sLrSPUwHU6+CiqYbii6ge9SMMb2fR0kSKUkoUAAo0V1tU54xOCWyXq
X-Google-Smtp-Source: AGHT+IGeSTQYVZqR3aMPE6pliethT4IJiA6hwC5TYZdHHeXkgqf/adRfnwhquCbJi6WpoATmwa27dQ==
X-Received: by 2002:a17:903:1c9:b0:20b:9df1:54d5 with SMTP id d9443c01a7336-20c80531f49mr52802985ad.29.1728578398167;
        Thu, 10 Oct 2024 09:39:58 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8bc00dcesm11260645ad.64.2024.10.10.09.39.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2024 09:39:57 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcachefs: Do not allow no fail lock request to fail
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <fdu4feezls66tsqjf5hgegnthczntpj3jfl2mo62rcyvekk56u@w32hjbtyvqax>
Date: Fri, 11 Oct 2024 00:39:44 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0F9A8E3-F19D-4660-881F-14C40D740910@gmail.com>
References: <20241010132150.1814411-1-mmpgouride@gmail.com>
 <fdu4feezls66tsqjf5hgegnthczntpj3jfl2mo62rcyvekk56u@w32hjbtyvqax>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 11, 2024, at 00:20, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Thu, Oct 10, 2024 at 09:21:50PM GMT, Alan Huang wrote:
>> If the transaction chose itself as a victim before and restarted, it
>> might request a no fail lock request this time. But it might be added =
to
>> others' lock graph and be chose as the victim again, it's no longer =
safe
>> without additional check. We can also convert the cycle detector to =
be
>> fully RCU-based to solve that unsoundness, but the latency added to =
trans_put
>> and additional memory required may not worth it.
>=20
> This is going to need ascii art diagrams...

Assume (txn represents transaction):
=09
	txn1 owns lock1 and requests lock2
	txn2 owns lock2 and requests lock1

txn2 runs cycle detector first, so it has added itself to lock1=E2=80=99s =
wait list,
txn1 now requests lock2, since txn2 haven=E2=80=99t lock lock2=E2=80=99s =
waitlist lock, so txn1 added itself to lock2=E2=80=99s waitlist.
txn1 now runs cycle detector and detects it will have a cycle and choose =
txn2 as the victim.
txn2 now also detects a cycle, and choose itself as the victim, so it =
restarts.
txn2 now requests a no fail lock and runs cycle detector again and sleep
txn1 sets txn2=E2=80=99s lock_must_abort to true and wake up txn2.

So txn2 is going to abort.

>=20
> I would expect the lock waitlist locks and sequence numbers to protect
> against this kind of race, do they not?
>=20
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> ---
>> fs/bcachefs/btree_locking.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/fs/bcachefs/btree_locking.c =
b/fs/bcachefs/btree_locking.c
>> index bf25fd0a1cca..fff176382e30 100644
>> --- a/fs/bcachefs/btree_locking.c
>> +++ b/fs/bcachefs/btree_locking.c
>> @@ -293,7 +293,7 @@ int bch2_check_for_deadlock(struct btree_trans =
*trans, struct printbuf *cycle)
>>=20
>> g.nr =3D 0;
>>=20
>> - if (trans->lock_must_abort) {
>> + if (trans->lock_must_abort && !trans->lock_may_not_fail) {
>> if (cycle)
>> return -1;
>>=20
>> --=20
>> 2.45.2
>>=20

