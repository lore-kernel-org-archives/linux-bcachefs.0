Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0240B652;
	Sun, 15 Dec 2024 01:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734227916; cv=none; b=fVuE51cO2QqddE4xgSebfIqTwjfAXjSl/5gFGqKxx+V1eVsFMrUVesAbW9sEqwHPp+goGeE/yaZnh/iIMnW3H7Htr6HQ1LvlG0ARf5kqwKuRVuqYfXlIXLdj8SKFCPggrvpqnylPf9lQaj9tzyt14dt2MN0CAwNTJCKj2zyY0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734227916; c=relaxed/simple;
	bh=CF9bYFp0m87oRUXrkUd/+BjsY5616uFcr6874/IsR30=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jr8DTfPTjCOeQXqyQW1UuW3TELY7Cu/uYVj3A8mEnHMyupZHd4jn9eIQVV/FJ8rzrFuKHHqJ+/rMJU/aiFIfbnaQlBm/8AmE++p+gla72DveaNqgUfAUXzOMQZoz8Z1OqMLCLwyKwUT2TlQvxz4gsLMKfJVgDM1j0bz4fi8nI/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MajERkA0; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MajERkA0"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa6aad76beeso424584966b.2;
        Sat, 14 Dec 2024 17:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734227913; x=1734832713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uTOtKCAD862fn6SOopJdqjcyjCQDh5Qti6fRy3fD1D0=;
        b=MajERkA0XFpn9Z8QeVoxPgaGUzJ+e0xcWl4bMu3k0JyYyHygZgn2cACY0W5fmP/VDd
         KYtpYuazQyLGoYmvdy0oOzvXTS7GXvauCN4Tk3+HnhkiUwk7gkvkDd4dO5LYj28AIIvd
         t/3zO8ye7Pf7NLcibibzRyTo8zi9fYXkg1jbSSpH6+5OB/iIAhB4z4jfmQfiOT8Tylfz
         /Xwt5XPdyv6atk0RwKvIih3z4FfBKhzc+A5bvQAzFUGnb2IIDcRhhhNAHYpGrY7ugnWS
         6O2BH09J5J2E23B9i5jCh8nS9HnmeQMura9gtVKIYcC3IEai6OmsNfXPP84jRtkLRutp
         bQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734227913; x=1734832713;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTOtKCAD862fn6SOopJdqjcyjCQDh5Qti6fRy3fD1D0=;
        b=K21GVNA7E9EGz81+3On3Vk2zK1WOzYOhd3DaxVH4x0P1XJrFq4fKkxergOH0du5GJv
         CITDUVwzL8FreIVui97mDZCebcbETWovcfpGH1WxpbXootjXM0aYXw0md+cSIkIS6lO6
         rpIj1mV/GUYCccJkHOyTdl/CIbtzBggASlBAOceI2UWoJbMcT3lLmSxP1n9xIFK8za+a
         hktR+gejs0hkZjF6tpdUGbQP/UpDANH9eDMiaZ5qn5spz2VQUVPex+3ubssvpVYFLDBv
         5bSyAREvO1uUBXPy2Pov4V0m0axKfyb2Y0R6K5vCm/6TiLudGA5XMFgUQJwpq/bhZ03n
         rbWw==
X-Forwarded-Encrypted: i=1; AJvYcCVVfRgWTHF+unT2KmD1ttczImzEgM+JmwGktCYj6hW9nW23eL8m8Qg52iAHZ0WbrL3p/7AsBaqU2/XBxVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVPZDchwOh2+pVt+DxSLiTj5fpIZR1ey5eSJkrNKzq05+MeVQs
	R5JemoTzSorSqSoc/y0UMboikjxTo38Q+BtJj7z/oNF4p9U9xUvE
X-Gm-Gg: ASbGncvtkRw+469tyrCks867kYOdRIlkIwq0sa2k9MI2gvDDFjGeBFz6tudQiI7t+4K
	287ONoUVJMIdEHkAeiyCT+U+cms6SlxXjBKUMet76jkPtel7mbpRDMzHDyXTb3uzyYl9uSMKcvx
	cm8XVM0EYdkqC3cNGXBIhHHpZbxwDC0NJyhd3m2c66ElhtWJNk4clND9KwVE6zLH2UzydCQhd+z
	9G4Tgr+V+ryV6iNWJbSfyCzOGI2hjN4birvT5eioi2tZ1Xe7RPCyeeO0JOPfyommmfSflOOeLZQ
	UEy9DJX4bhMeGXkzwnMw6qB5nqBheg==
X-Google-Smtp-Source: AGHT+IEM5hXsWlVdtZMgp9ING2qHEtQwRmuSxXfMpBDX+6ZK1JT+y0v+Aun2iQhvhcDFZxZBPh/Zgw==
X-Received: by 2002:a17:906:3145:b0:aa6:3f93:fb99 with SMTP id a640c23a62f3a-aab779d16aamr722104366b.36.1734227912976;
        Sat, 14 Dec 2024 17:58:32 -0800 (PST)
Received: from ?IPV6:2a01:e11:5400:7400:2afd:8633:4d49:50ca? ([2a01:e11:5400:7400:2afd:8633:4d49:50ca])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aab9c968803sm133566466b.197.2024.12.14.17.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2024 17:58:31 -0800 (PST)
Message-ID: <60464a9b-aa46-40b3-b8fa-0567f86f6747@gmail.com>
Date: Sun, 15 Dec 2024 02:58:26 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: zero-init move_bucket struct in
 bch2_copygc_get_buckets()
From: Gianfranco Trad <gianf.trad@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org,
 syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
References: <20241111144242.757798-3-gianf.trad@gmail.com>
 <vtm2n2sjx4kpkx4slzpve6pv4lxhmotnvrhtqp2qobrmubvz35@s33ak2pst3h2>
 <382408d3-21ed-4bb3-87a2-60ad61583726@gmail.com>
Content-Language: en-US, it
In-Reply-To: <382408d3-21ed-4bb3-87a2-60ad61583726@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/11/24 16:08, Gianfranco Trad wrote:
> On 11/11/24 21:09, Kent Overstreet wrote:
>> On Mon, Nov 11, 2024 at 03:42:44PM +0100, Gianfranco Trad wrote:
>>> zero-init move_bucket struct b fields in bch2_copygc_get_buckets()
>>> to mitigate later uninit-value-use KMSAN reported bug.
>>>
>>> Reported-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=8689d10f1894eedf774d
>>> Tested-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
>>> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
>>> ---
>>>   fs/bcachefs/movinggc.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
>>> index d658be90f737..cdc456b03bec 100644
>>> --- a/fs/bcachefs/movinggc.c
>>> +++ b/fs/bcachefs/movinggc.c
>>> @@ -171,7 +171,8 @@ static int bch2_copygc_get_buckets(struct 
>>> moving_context *ctxt,
>>>                     lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
>>>                     lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, 
>>> LRU_TIME_MAX),
>>>                     0, k, ({
>>> -        struct move_bucket b = { .k.bucket = u64_to_bucket(k.k- 
>>> >p.offset) };
>>> +        struct move_bucket b = { 0 };
>>> +        b.k.bucket = u64_to_bucket(k.k->p.offset);
>>>           int ret2 = 0;
>>
>> Providing any sort of initializer should cause the whole struct to be
>> initialized, are you and syzbot sure this is the right fix?
> You are right, there's no need to initialize the whole struct.
> I'm still in the process of fully understanding what reproducer is 
> trying to do.
> So far with the additional findings, b.k seems not to be initialized 
> prior usage in repro case, therefore memset to 0 only the b.k field 
> seems enough:
> 
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index d658be90f737..515b05d26d11 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -171,7 +171,9 @@ static int bch2_copygc_get_buckets(struct 
> moving_context *ctxt,
>                     lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
>                     lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, 
> LRU_TIME_MAX),
>                     0, k, ({
> -        struct move_bucket b = { .k.bucket = u64_to_bucket(k.k- 
>  >p.offset) };
> +        struct move_bucket b;
> +        memset(&b.k, 0, sizeof(b.k));
> +        b.k.bucket = u64_to_bucket(k.k->p.offset);
>           int ret2 = 0;
> 
>           saw++;
> 
> The above patch was already tested-by syzbot[1].
> 
> Let me know if the patch looks good enough or if I should work on it more.
> 
> Thanks for your time,
> 
> [1] https://syzkaller.appspot.com/x/log.txt?x=1733b8c0580000
> 
> --Gian

Hi Kent,

I wanted to follow up on this patch. Over the last few days, I've 
investigated it further and observed the following that might be of help:

1- zero-initing whole b struct (as the first patch version) leads to a 
clean log [1].
While if trying to memset to 0 only b.k field log reports [2]:

bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): filesystem UUID already 
open
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): shutdown complete
bcachefs: bch2_fs_get_tree() error: EINVAL


2- Given both versions of the patch didn't trigger the uninit issue 
anymore I checked whether inner fields of b.k.bucket are correctly 
inited, just before the bug triggers.
b.k.bucket fields seeming to look correctly inited: snapshot = 0, offset 
= 34, inode = 0, gen = 0.

3- The first of the 2 reproducers causes a segfault:

==9335== Invalid[  264.802101][ T9346] read of size 1
==9335==    at 0x483BC39: strnlen (vg_replace_strmem.c:426)
==9335==    by 0x1098F0: netlink_query_family_id (repro.c:176)
==9335==    by 0x109A51: syz_genetlink_get_family_id (repro.c:211)
==9335==    by 0x10B476: execute_one (repro.c:2071)
==9335==    by 0x10B1A5: loop (repro.c:745)
==9335==    by 0x10B52F: main (repro.c:2088)
==9335==  Address 0x0 is not stack'd, malloc'd or (recently) free'd

As of now, it seems unrelated to the root cause of the reported syzbot bug.


At this point, zero-initializing the entire struct seems to work 
reliably, thought I'm still trying to get the full picture on this bug.

I know you are busy, but I'd highly appreciate your thoughts on this.
I hope it might help.

[1] https://syzkaller.appspot.com/x/log.txt?x=1724b4e8580000
[2] https://syzkaller.appspot.com/x/log.txt?x=1733b8c0580000

Thanks for your time,
--Gian
