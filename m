Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434833DF;
	Tue, 22 Oct 2024 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729564725; cv=none; b=UseV5Pgsgzo4625Go9IfEatp/1beVBzvj9IO31voXsGgkNpFDcBmmifS+WILo0aYmiJxbnNOUg7Z82OxOrWaXFXtxWNwxXzu8ybnuwIIy8nkJECdQEyO3g6iYNVPhOCiCdIe+k6N14WCOep0MZncpsFkJzvQyrra3UIuA6t7+0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729564725; c=relaxed/simple;
	bh=IIG+eMUHDIPkcPBHjbgUD7NpjzTrZF89PpyRqmEd8Ts=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eHSS3/dO6BlUTA0bz/vlr66h4bLaMJlkX61fscZR2eIxE9MqNFVoADkHZxWnamEcDgs/F3y/aAUOMg8ChrNHjyoVFD6aeowk9OZ7nz9ePivxAq/Ht0bkrlfERH9Dwr3xCmS+19n/4RWIKoXZDHWjoK3oIihKT3Licl/Cwm0xqvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7p2Tpm8; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7p2Tpm8"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e2e2d09decso4296305a91.1;
        Mon, 21 Oct 2024 19:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729564723; x=1730169523; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9PYj57V6Dso8QE/VKq1cEMgmsfvOIboMv8dlddy3Zw=;
        b=M7p2Tpm8ewsJhZ2ftJLsIHP3StyaRxk5PQ0Q+ES8dhQZBHiEtb61adDMRvS4b6kIGB
         d0ybacwzfbLWnG0SNgpeL4tCVY+BWoh+BI58F9RuISCLwxxez+ThEq/sHpwqCcgWvVF1
         C637P9FXQiQRBVshhCBCQlQ3oo/hCsxcOCVeON/X78I4WWadUHZY+Gh3UwqLeQQHIrgy
         u7+adBV//mn3xCuLFF0iPNagnR4QDLoCAVOznhNIE4ThsiFvY7bLgUwumecUGmQZj9qe
         vuvn9lzS2De3pxGZbmgYLnx1QyWqsRKSfDqvDJonwoBPM/VGDVlz8qAd8hjgFXxDMgxr
         xglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729564723; x=1730169523;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9PYj57V6Dso8QE/VKq1cEMgmsfvOIboMv8dlddy3Zw=;
        b=J5QpQa2eMtSB3Lh+mbFiIasGNIyyE4ZWbMCHWvtHw/jyRMn0JTA7lODy70ZeLr1YUy
         zIvzbTgV9GsWXdw53DhIpUXTszBcDRYECqA1MhP8sl5+ifyPLCR4yPfQ9GBVxIg1kkqj
         QImCS0L8HhjZhVlPFIPyrNiYsiKqlpRv1CHOz9QCQov1WZmUkbMBt1NNaJxItBpXWY6U
         Zr4KROcJUAY20PtUuG92YdI7CrKAnpbX9wSQqJDwE9Sq0ZqO0PFy7pVGKizVT3VXTPSc
         OPKZO4Yy4jvoPsm2P7YoRYEW3CwJhPGGkyWk/ZGco4hTqCLBuFKM0OvRIJqVytNFN1Ic
         0vwg==
X-Forwarded-Encrypted: i=1; AJvYcCUP1dp+QB0G99LDfrfKypFgrx6ryMJTR7tbX3bYKzAz0nc8isySms2R/ALDLdZkquGOBIFrSUwCSd53tohf3A==@vger.kernel.org, AJvYcCXDVlVsgk3JI+kmXzJn8U6XuzrU7LWWJ4Jq/1yJuMfj6MA6Ism5Y3Kmp+GVTTZOIaaUhxOiLLvZY+QB3qmD@vger.kernel.org
X-Gm-Message-State: AOJu0YxmObehpC24cTJVP3XdLrioNJSNmdh4cLnStjr7Iq3zHpfQom3j
	n3NLqLhjbefC9TIsFkhKvvt29GbK5DMcQm2/Y1RHP+eslst3u6ZZ
X-Google-Smtp-Source: AGHT+IFRH5PZloUMnG3ehT/dVUWM/HxSI6UleiA503Z3OUYjfq0StILaHbEeVnyupYq7QydobZFRog==
X-Received: by 2002:a17:90b:4a90:b0:2e2:8ee3:b936 with SMTP id 98e67ed59e1d1-2e5db945499mr2464293a91.6.1729564723344;
        Mon, 21 Oct 2024 19:38:43 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5e20357b1sm180466a91.1.2024.10.21.19.38.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2024 19:38:43 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
Date: Tue, 22 Oct 2024 10:38:28 +0800
Cc: Jeongjun Park <aha310510@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <45EF275D-8F04-41DF-9895-CCAF28D5AAAC@gmail.com>
References: <20241021154356.38221-1-aha310510@gmail.com>
 <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
To: Hongbo Li <lihongbo22@huawei.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 22, 2024, at 10:26, Hongbo Li <lihongbo22@huawei.com> wrote:
>=20
>=20
>=20
> On 2024/10/21 23:43, Jeongjun Park wrote:
>> The size of a.data_type is set abnormally large, causing =
shift-out-of-bounds.
>> To fix this, we need to add validation on a.data_type in
>> alloc_lru_idx_fragmentation().
>> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
>> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
>> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
>> ---
>>  fs/bcachefs/alloc_background.h | 3 +++
>>  1 file changed, 3 insertions(+)
>> diff --git a/fs/bcachefs/alloc_background.h =
b/fs/bcachefs/alloc_background.h
>> index f8e87c6721b1..163a67b97a40 100644
>> --- a/fs/bcachefs/alloc_background.h
>> +++ b/fs/bcachefs/alloc_background.h
>> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum =
bch_data_type type)
>>  static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>>         struct bch_dev *ca)
>>  {
>> + if (a.data_type >=3D BCH_DATA_NR)
>> + return 0;
>> +
>=20
> oh, I found I have done the same thing in [1]("Re: [syzbot] =
[bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But

Your patch there is still triggering the issue.

> in my humble opinion, the validation changes also should be added. And =
in addition, move the condition about a.data_type into

There is already the validation:

bkey_fsck_err_on(alloc_data_type(a, a.data_type) !=3D a.data_type

And the unknown data type is already printed in bch2_prt_data_type, =
additional validation doesn=E2=80=99t help much.

> data_type_movable will be better. Just my personal opinion.:)

In my personal opinion, I don=E2=80=99t think so :)

>=20
> [1] https://www.spinics.net/lists/kernel/msg5412619.html
>=20
> Thanks,
> Hongbo
>=20
>>   if (!data_type_movable(a.data_type) ||
>>       !bch2_bucket_sectors_fragmented(ca, a))
>>   return 0;
>> --


