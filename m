Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BC1442E8;
	Tue, 22 Oct 2024 03:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729567412; cv=none; b=Wn4dSHJn9zER3f7uftvMpYpQqG6LVc7+JZQ2ZEzYIUgx/ZdKgsw0OzgzjWQpHISfCaEVnSRNG0YaD+2O2DMzgNyNFxa3gklghKcqhZTJnf4Gu8PPB5oEbThvd9hc+nomyCjXO54pCp8AWpbkIpLhCQoumOz8CzLKdghH+3k3v3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729567412; c=relaxed/simple;
	bh=EUdkE/JzIkciKin0lTeyOJWE2+TwwJIscWovAjZ3EOc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=d2C7/pgy4T3Cu+//qf9fqotk/Ig/VheRhO4Wqmo96ZGX5yL39aNyU55dRVlHK83FvGuD+OTnKnJO3c4KP/7Lqz+P8kGuElolbP+o32ItdzpkSvkRGU+fszEgH/MRN/aTzLoEFlXnLRKp/yOv65OmaNBsqhRtvgVAuA0O8OjsOKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lKrHKmEI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lKrHKmEI"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20cb47387ceso45729805ad.1;
        Mon, 21 Oct 2024 20:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729567409; x=1730172209; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaALaW8nzNfwR2BNGGr9dEQJgHBRoXm2vibHMuBTRx4=;
        b=lKrHKmEI488twOVxiN98vDMpEFdW8I24Whp8048aOHJUX+7vQa1aS3KGWtxrDYf1ON
         TppEoZxnsmCivaB0ydB4z5NpTmOtmVrQMRjg0WxYBVH017Iil3dEQA+WadK8amU5Ux5q
         LyoIqCCX72/28qmdqps4CI2sOpwcQ7hxYBuJRE6Wqd1HWqVfySDWNNSpe0BgoC6DPZz8
         ivG2UZmEPLi/N2HAVrW3MYX7Nf2evbrQpxDO3cdvbMMlGhvA12GaUvVq8NdB4+7G7Z7J
         bch8JP1kb7nG5akGTMATGCiEHngTPjAT/KH+M+VZeosAwNRjTO8X/v8oofeyTTqRl6ED
         vO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729567409; x=1730172209;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YaALaW8nzNfwR2BNGGr9dEQJgHBRoXm2vibHMuBTRx4=;
        b=Dpc8bwHVNYLpkUjJWTw/9xD3an1qk4Wk69aH8Av9v05iVn+zxLzIK5mnLGJE90N6Ab
         6PFGXRTZc7LkyxqoqtrKlPOxpRcGTftevwzawF74n0C0KnmaUaWq+a5+QXG+D0lkvfy6
         prYPXKWKHX5EyYw6HL/vvvXS21LW5RwTjIFGOyBrq7DpVPAk2bnBZhdcS9d6H3Arnvmj
         lAdmDLtyuzMl81crgEVPj+RYoqeUbRIrim786LDjxpmaHJx70YBP8S63yNd9nNE0f01i
         sMV/uqtpXNhjp2cJfcd/ClYLDkbnsyZITWzqGw4NFaD7+pPWNrqNvS8xAF9mBwoJoskr
         I2ug==
X-Forwarded-Encrypted: i=1; AJvYcCV+hb1GFYaI1celWSDBv7sjqjDMsr9XX2T5LCk2GHu+7QLyvZCT5ij5PDp5LDeHItJiVY3iePO8lNxvDc6A@vger.kernel.org, AJvYcCX3ewhiCvaiYzHy8L685769Us0yfgtoGeKdR4Aq0Dbb7nvQK2ZoFscNT91rnVPq1hikNKQKz4X5RfrSfcXEPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUPcEmZLjNn8UqNgyCDKhspMhndmjWnxTHCPaeiiqRVYul7CXa
	eWaRjDto6NwC/PRMgZrQ/M7FeeNWc9niS9nV5eKyLyzNF+Sttkjw
X-Google-Smtp-Source: AGHT+IEQ9l+rgtuChT4dveBuRdRhUbq8ydAi1dTuFwuQq8ykSCTLX2Ze/ydituja7uIUStfyHuX5GA==
X-Received: by 2002:a17:902:da8f:b0:20d:2848:2bee with SMTP id d9443c01a7336-20e5a752281mr199612745ad.16.1729567408807;
        Mon, 21 Oct 2024 20:23:28 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0cc12sm33346855ad.95.2024.10.21.20.23.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2024 20:23:28 -0700 (PDT)
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
In-Reply-To: <10aed636-b665-49f0-8fa3-fcb5504c13c6@huawei.com>
Date: Tue, 22 Oct 2024 11:23:14 +0800
Cc: Jeongjun Park <aha310510@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F346797-D10A-4A03-BE5E-6AB3FE1F64BC@gmail.com>
References: <20241021154356.38221-1-aha310510@gmail.com>
 <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
 <45EF275D-8F04-41DF-9895-CCAF28D5AAAC@gmail.com>
 <10aed636-b665-49f0-8fa3-fcb5504c13c6@huawei.com>
To: Hongbo Li <lihongbo22@huawei.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 22, 2024, at 11:05, Hongbo Li <lihongbo22@huawei.com> wrote:
>=20
>=20
>=20
> On 2024/10/22 10:38, Alan Huang wrote:
>> On Oct 22, 2024, at 10:26, Hongbo Li <lihongbo22@huawei.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 2024/10/21 23:43, Jeongjun Park wrote:
>>>> The size of a.data_type is set abnormally large, causing =
shift-out-of-bounds.
>>>> To fix this, we need to add validation on a.data_type in
>>>> alloc_lru_idx_fragmentation().
>>>> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
>>>> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
>>>> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
>>>> ---
>>>>  fs/bcachefs/alloc_background.h | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>> diff --git a/fs/bcachefs/alloc_background.h =
b/fs/bcachefs/alloc_background.h
>>>> index f8e87c6721b1..163a67b97a40 100644
>>>> --- a/fs/bcachefs/alloc_background.h
>>>> +++ b/fs/bcachefs/alloc_background.h
>>>> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum =
bch_data_type type)
>>>>  static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 =
a,
>>>>         struct bch_dev *ca)
>>>>  {
>>>> + if (a.data_type >=3D BCH_DATA_NR)
>>>> + return 0;
>>>> +
>>>=20
>>> oh, I found I have done the same thing in [1]("Re: [syzbot] =
[bcachefs?] UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But
>> Your patch there is still triggering the issue.
> Yeah, it just notify the issue and not prevent the issue. So I found =
it should add a.data_type condition indeed. :)
>>> in my humble opinion, the validation changes also should be added. =
And in addition, move the condition about a.data_type into
>> There is already the validation:
>> bkey_fsck_err_on(alloc_data_type(a, a.data_type) !=3D a.data_type
>=20
> This is actually not enough. This only do some transition check. For =
example, if a.data_type break when bch2_bucket_sectors_dirty (the data =
corruption can lead to various situations occurring) is true, the helper =
does noting.

Make sense.

>=20
> Thanks,
> Hongbo
>=20
>> And the unknown data type is already printed in bch2_prt_data_type, =
additional validation doesn=E2=80=99t help much.
>>> data_type_movable will be better. Just my personal opinion.:)
>> In my personal opinion, I don=E2=80=99t think so :)
>>>=20
>>> [1] https://www.spinics.net/lists/kernel/msg5412619.html
>>>=20
>>> Thanks,
>>> Hongbo
>>>=20
>>>>   if (!data_type_movable(a.data_type) ||
>>>>       !bch2_bucket_sectors_fragmented(ca, a))
>>>>   return 0;
>>>> --


