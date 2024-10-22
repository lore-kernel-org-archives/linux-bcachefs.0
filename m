Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3852F819;
	Tue, 22 Oct 2024 04:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729569945; cv=none; b=UXj2dNa8lEevNlzE/XCujSE972gDzWDkyCJuWEhG5U7wnODaVLYyNKArwg0uHvBN1clcjpYIHRg4gIXSX5591y7WOkmn4v7A624IFEMxUOQhrcUq1Fb4geos4YTjwAX/Bcbu1qJhyyfXPM6SE5tIWAOTeqNzWwhTzp2k+gmiIH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729569945; c=relaxed/simple;
	bh=eJyVsZi1XXXWsu+AWkgjRqdLWtAtzfdi0mXUYDcPs0s=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=aqK+vtPLxGe0OAciA8PVYOaMt6UjnRbuAB55Hg2dYWLHXkPlr720ciul3yuPo6nSOGwksB+F1Aux/etdOEPWTFztvF2m4mO9aqIuYSYunfW85cBrj3zbkg+HQDJ9NkQloqEk601c0tsm1A2stCwQAwgIpjhOGB6smFZ9X+AV65g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/IAsobp; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/IAsobp"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7db90a28cf6so4045994a12.0;
        Mon, 21 Oct 2024 21:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729569942; x=1730174742; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qeYyq2oOzR5uOQR9ScxbvYco7XW/CAhsEW70HQRkLlg=;
        b=F/IAsobpNLrKC0VD6U79l34VX4SExW977/LFstV64kcawx84TDm96GJeAVAlfFIFYV
         ENtdxW1X2SZPdix+aaCMqeBcArnJrp1tGAlH+m/gb2fb+mDxiSWYa3bLpToTRVSpnaVd
         pXDnKohsbE+qdDXFdeAO4hW331dQbjdfz2DFErxCPg7QT2TP/P2JCSkgMz5V51rzrsEG
         xoFyisjbUP1Up3s6lYG6/fEO02edBAGoYqMu5ovwCRahF9BPgIAXMSF3uwcpoUBWJUvH
         L8t92xeJQT2R2UFJ711mIZO/nC22cSXy0BKPvW7szu8n6H+xq6xtOJvHMVCCgjfAxavX
         4b1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729569942; x=1730174742;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeYyq2oOzR5uOQR9ScxbvYco7XW/CAhsEW70HQRkLlg=;
        b=ACuyaQA04pvrSUffNhemsYDVhcBwjzh2bPlVzPbwhickC7pnEaA2N18IQaBLkeoODg
         Fv7cG9RjiswPe3DOccHQ+EifN9yQINzlz0vkJFotMyDSwY7eZU7axphTHUpAFWMN3xPX
         TOnv6bTkj+D33NXf5Nuiq+gXWBUn5zhOQsu7Yf/Z9ltz8bKvMFuD8WQa5w/hl3pxoxpm
         DdMZmkOG3LYb8oC47eMLwYcMleHb84I/k4QmDeXLMlhywbz0eeL52v6EquN14SAMYswh
         IeaeVL9BhDCQgn+W2r3SXReoH5mymxTE43zFUC6+yixYek9QAhBPZwstMHj2FmQG4u97
         /qNw==
X-Forwarded-Encrypted: i=1; AJvYcCUjiin8eQ/untwcZzO36p+C0MrNmMcfMj1gkFEZ2tewE44uo4f1cbxKtl9EAQux3HTofQNgT3C/IdDBnhgDMA==@vger.kernel.org, AJvYcCUyBFvbsXM9QSwP6tg9JhuUf4/ZMY09gCn2V6WoVDCYdW0mnje9O/k/zxXnxU5+cxOn+EG4NbkP41igfWw7@vger.kernel.org
X-Gm-Message-State: AOJu0YzyE5h7ciaFAeiyqWMpE7jj5OKMaKTH/OlCQff1TWBfGyBSNsLc
	bk3xp/oR5s0GXPaZ+Jpnsr2Bua3+lfeC4XWiQiCA9OvNIWqjsvNtx48SRw9L
X-Google-Smtp-Source: AGHT+IEEt239aEO1r2xrdV3J65WlKODbaqXoH+Q2k7+nVHltvgSx6xPDMT0LT/wXHf3XqYpmlOhpbA==
X-Received: by 2002:a05:6a21:393:b0:1c8:de01:e7e5 with SMTP id adf61e73a8af0-1d96c3ee885mr2427407637.15.1729569942387;
        Mon, 21 Oct 2024 21:05:42 -0700 (PDT)
Received: from smtpclient.apple ([2001:e60:a409:cb40:2dbb:16ed:d48d:b2b3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec1312e2bsm3721755b3a.42.2024.10.21.21.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 21:05:42 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jeongjun Park <aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Date: Tue, 22 Oct 2024 13:05:30 +0900
Message-Id: <D983ED6A-1206-4D3F-AAEB-4572BD81AB2B@gmail.com>
References: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
Cc: kent.overstreet@linux.dev, mmpgouride@gmail.com,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
In-Reply-To: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
To: Hongbo Li <lihongbo22@huawei.com>
X-Mailer: iPhone Mail (21G93)



> Hongbo Li <lihongbo22@huawei.com> wrote:
>=20
> =EF=BB=BF
>=20
>> On 2024/10/21 23:43, Jeongjun Park wrote:
>> The size of a.data_type is set abnormally large, causing shift-out-of-bou=
nds.
>> To fix this, we need to add validation on a.data_type in
>> alloc_lru_idx_fragmentation().
>> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
>> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
>> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
>> ---
>>  fs/bcachefs/alloc_background.h | 3 +++
>>  1 file changed, 3 insertions(+)
>> diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_backgroun=
d.h
>> index f8e87c6721b1..163a67b97a40 100644
>> --- a/fs/bcachefs/alloc_background.h
>> +++ b/fs/bcachefs/alloc_background.h
>> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_ty=
pe type)
>>  static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>>                            struct bch_dev *ca)
>>  {
>> +    if (a.data_type >=3D BCH_DATA_NR)
>> +        return 0;
>> +
>=20
> oh, I found I have done the same thing in [1]("Re: [syzbot] [bcachefs?] UB=
SAN: shift-out-of-bounds in bch2_alloc_to_text"). But in my humble opinion, t=
he validation changes also should be added. And in addition, move the condit=
ion about a.data_type into data_type_movable will be better. Just my persona=
l opinion.:)
>=20
> [1] https://www.spinics.net/lists/kernel/msg5412619.html

I still disagree with the fix to make data_type_movable() do the validation,=
=20
but I think [1] is definitely a patch that needs to be added.=20

However, [1] is far from preventing the shift oob vulnerability described=20=

in that syzbot report. Therefore, I think [1] should be written as a=20
standalone patch and committed, rather than as a patch for that=20
syzbot report.

>=20
> Thanks,
> Hongbo
>=20
>>      if (!data_type_movable(a.data_type) ||
>>          !bch2_bucket_sectors_fragmented(ca, a))
>>          return 0;
>> --
