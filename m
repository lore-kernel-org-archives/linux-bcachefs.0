Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D6C170853;
	Thu, 24 Oct 2024 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729770684; cv=none; b=IrURvhZsv9KWzmVxjCJ/Xuour5z1sRPTy+ZKn9rDwGBqIIuLmWA/OUtyKFgC5BgMl7lHA/g6ZPMntlBI6NxHwYhkM47mddijgPEAORVJIPOWzoUXlgV4rxGQ2cLEz4rj9asRW/eZxXtxsXLAMgL2OCMmPEV9tdaD0VlRrnob3kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729770684; c=relaxed/simple;
	bh=ObToXn1uN52Ji+FyF1i7vx015LgZ9B/m9BxmJO7giVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNdYXoOXJevDq4GH+BuOpxM79MTNrjn/qU7Prh0beme/6buIuEFhbIPJQuTMcsJkYniUUphHvG08JPu7c1uDktd749g9zNyGkkcA5k8fFekN3zrTlTevYVbvcNdj7NVw6KKMFBiLpKgTpBkj5XxO77LdIkt9qlduuj6MREfpVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJm2tSDI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJm2tSDI"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43155afca99so12942685e9.1;
        Thu, 24 Oct 2024 04:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729770680; x=1730375480; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4f+ncTElWxuaHlRSc9sIvuc0sLwN6e+jbNOHYwrcO2s=;
        b=KJm2tSDIh2MlW5E1dNBmWe84EXMSjYQY9I2Rc+VgIIL+KMkrw9vglS3tY+3E4iTd/W
         dE35rX+4Alr5CWa8loEVdOyKqbYbLPGmfAUVeQniKqMTnCTbrtTgI9czpkBqL0xtrYyg
         T7YhuvvLnfUpGC9sYdGLD0KdoVsdAvDdHR0jY9zymSvYFtWgnEIKJI2TujEjXnQ7LdOO
         9bh8/mSflwJpathXJqko4FeYEWvJHhTgNQPAODeQ92qNw1tat4jijiQUezdpwTCmQvRk
         9LGgvZEjb4ev3Esd08u+24OPzWLf0d2ZClROKPUyAjaKcGACmm2FEZXG/9EYTnSTTIXA
         mD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729770680; x=1730375480;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4f+ncTElWxuaHlRSc9sIvuc0sLwN6e+jbNOHYwrcO2s=;
        b=a7eESv0t2pOz/EjSl0yC/KcdAYxsAnzUkGLlfpqGNBxJf25CqlLnaKgSsuthjGBh5D
         U8MYXwV0iiUxiVlHRcWRY+DF4lgPWCWDOsfbPgrUG+ol/EZJP2Cem5jRCicvNyXoyIjp
         FXQ1tHGmBZA35fjTNPPtJ00ZZ49kZ2Yi0nD6nA+WqWQlgpclSulWKEQxchXJ3VTZdHvL
         KbFhRglcHqRpEocvC7w4d9RwSAQVnozV6JM2YRNXxCqXyMB8NqRDUOBKi9klQcie9umU
         hmBJk8WINZtssvf1zoJtx8RLRuN3MbH0gBFCiCmg9GhyeOiNEepUGt/pxLVVCjjhnioZ
         Bspg==
X-Forwarded-Encrypted: i=1; AJvYcCVUSDbXa0bOWUEukSaLE39YwUP0kGvLIL0VzI+GRel2ZvacOWsdy3UPp24qXuV10opoO8TTKEqLrq+aAFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaMVci3qeJCRkk0we4HoHSIhYbCni7NbwH1xx1vd/UOlj4+6YY
	UP7p5KbMM9utLGSFxQhIro7L897IX55YWCake0I55Gecv7zYzbsj
X-Google-Smtp-Source: AGHT+IGUts/pqiOnQUDlq8+mpIjJ6pvrQA50D7aIMHxlYlsnD/0uHpYCwABMwVeSbjaLKSV7g7Hd8w==
X-Received: by 2002:a05:600c:4689:b0:42c:b826:a26c with SMTP id 5b1f17b1804b1-4318b5a561cmr11835735e9.8.1729770679744;
        Thu, 24 Oct 2024 04:51:19 -0700 (PDT)
Received: from ?IPV6:2a01:e11:5400:7400:4be9:6ab9:1062:7d2a? ([2a01:e11:5400:7400:4be9:6ab9:1062:7d2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4317d03ee7asm58999885e9.0.2024.10.24.04.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 04:51:19 -0700 (PDT)
Message-ID: <58e3d8a4-9e8b-41d5-a134-d41b38bd7216@gmail.com>
Date: Thu, 24 Oct 2024 13:51:14 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Fix invalid shift in validate_sb_layout()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
References: <20241023213043.47846-2-gianf.trad@gmail.com>
 <be3e7378-7aec-4ebb-b6e6-e7b824452adb@gmail.com>
 <jaxnjw5ergn7zrnjuzzosgclpmv5st77gtfaj75my3hblufrn2@b4si2orrodw5>
From: Gianfranco Trad <gianf.trad@gmail.com>
Content-Language: en-US, it
In-Reply-To: <jaxnjw5ergn7zrnjuzzosgclpmv5st77gtfaj75my3hblufrn2@b4si2orrodw5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/10/24 13:24, Kent Overstreet wrote:
> On Thu, Oct 24, 2024 at 12:48:30PM +0200, Gianfranco Trad wrote:
>> On 23/10/24 23:30, Gianfranco Trad wrote:
>>> Add check on layout->sb_max_size_bits against BCH_SB_LAYOUT_SIZE_BITS_MAX
>>> to prevent UBSAN shift-out-of-bounds in validate_sb_layout().
>>>
>>> Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
>>> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
>>> Tested-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
>>> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
>>> ---
>>>    fs/bcachefs/errcode.h  | 1 +
>>>    fs/bcachefs/super-io.c | 5 +++++
>>>    2 files changed, 6 insertions(+)
>>>
>>> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
>>> index 649263516ab1..b6cbd716000b 100644
>>> --- a/fs/bcachefs/errcode.h
>>> +++ b/fs/bcachefs/errcode.h
>>> @@ -222,6 +222,7 @@
>>>    	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_type)			\
>>>    	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_nr_superblocks)	\
>>>    	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_superblocks_overlap)	\
>>> +	x(BCH_ERR_invalid_sb_layout,    invalid_sb_layout_sb_max_size_bits)     \
>>>    	x(BCH_ERR_invalid_sb,		invalid_sb_members_missing)		\
>>>    	x(BCH_ERR_invalid_sb,		invalid_sb_members)			\
>>>    	x(BCH_ERR_invalid_sb,		invalid_sb_disk_groups)			\
>>> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
>>> index ce7410d72089..44d0ac9b00dd 100644
>>> --- a/fs/bcachefs/super-io.c
>>> +++ b/fs/bcachefs/super-io.c
>>> @@ -287,6 +287,11 @@ static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out
>>>    		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
>>>    	}
>>> +	if (layout->sb_max_size_bits > BCH_SB_LAYOUT_SIZE_BITS_MAX) {
>>> +		prt_printf(out, "Invalid superblock layout: max_size_bits too high");
>>> +		return -BCH_ERR_invalid_sb_layout_sb_max_size_bits;
>>> +	}
>>> +
>>>    	max_sectors = 1 << layout->sb_max_size_bits;
>>>    	prev_offset = le64_to_cpu(layout->sb_offset[0]);
>>
>> Wondering if this other patch might be considered more correct to prevent
>> shift oob, given also [0]:
> 
> Your first patch looks better, we want to know if we're feeding it
> garbage
> 

Understood. Thanks Kent.
Have a nice day,
--Gian
>>
>> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
>> index ce7410d72089..428172897501 100644
>> --- a/fs/bcachefs/super-io.c
>> +++ b/fs/bcachefs/super-io.c
>> @@ -287,7 +287,7 @@ static int validate_sb_layout(struct bch_sb_layout
>> *layout, struct printbuf *out
>>   		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
>>   	}
>>
>> -	max_sectors = 1 << layout->sb_max_size_bits;
>> +	max_sectors = 1 << min(BCH_SB_LAYOUT_SIZE_BITS_MAX,
>> layout->sb_max_size_bits);
>>
>>   	prev_offset = le64_to_cpu(layout->sb_offset[0]);
>>
>> Also this patch was already tested by syzbot [1]
>>
>> [0] 71dac2482ad3c8d4a8b8998a96751f009bad895f ("bcachefs:
>> BCH_SB_LAYOUT_SIZE_BITS_MAX")
>> [1] https://syzkaller.appspot.com/x/log.txt?x=1640b640580000
>>
>> Thanks for your time,
>>
>> -- Gian
>>

