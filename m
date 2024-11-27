Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9947412E1E0
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 20:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732737696; cv=none; b=dLmKORe/2oK2fEX1tb/d2n6NZPGwBQfnUvohLE4c4KuHlRHAbT0FLZJ9yW0tNPuZf5t1r6OM3cH2P9BOcxqLjXp05uITOcy5dVCAyL3HeDBPlRPko1leEAYsELRT+X2Q4yaQeLYJ1Qe1YIqGg6M5SkNunFc98zCWRyMOhH0herc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732737696; c=relaxed/simple;
	bh=iGLSaQYvOpZLIRVOKm7zAxg5mxG+KrquynDIeaa/XyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE2S5SNXnnzYEs5c6dTTBby3Ge0v3SyVj+SQtfYIZ8LV2atk/2vNSgLK8yBrV4XbH7UTkkx2XxhJCHj3juq0NlOmECASFnO+C3hwK6vGgjPLsxHvMjlMknHQGODCM0qRbgrzCBghAyv2aW7NHosWI8vp/0Me1fuNbmy2PdDFShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NOolMrL7; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NOolMrL7"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-296539a58b4so129393fac.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 12:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732737693; x=1733342493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGAs9+TLtxCXXP5blBGV1RPMNvOSXa/kEVbzs2tZuvQ=;
        b=NOolMrL7FzEuUVnGdtu2bp7yFYuj30HpHrEr+g1gEUn4jXglpmL+Ga+ysxooboP7qJ
         qwo2KXZM9nBvbyOGqRL9C+WyEqPDh1h7Uw0hq42LMtFSwbOMOGaS5rc/QqmSdYN9mVYG
         Ia4/VVqnihciMVIK4qQHZAV/lmtyJ4ukL0NAgfTDCoeLzxf3mAYK9m0L9XJ9C+3fwllU
         jp/LWbg/KYCA+Bq1Wn6xxyDyT67Xahr3TWxSxCg3I/2iIaevDG8wHwc7zsfag8+CMClS
         n4BLcHLzhWKRov6+OV71baVN+ttFCXiODDxvGdZ8FXgwwZ9/I3olDwNCFv3H/1dVxg7m
         KKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732737693; x=1733342493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGAs9+TLtxCXXP5blBGV1RPMNvOSXa/kEVbzs2tZuvQ=;
        b=gfCjw90uZ1iPP2UwZq6ItIUdHMt/VP2BTTWtQpX4H9ZGPH81R8ZE7Vqv/LJ0dpl3af
         /P1aa5GI7AIUzCyVdjw9x3h4etUom3ykIWrPEBBRyESov3bd5GNMYq44srfEJAWr081g
         prcJBvCyxGE55KkJF0ZeSNC1ftacaoptENjQTxbeMWtjBKu1rmJZ5ERrdUSn71jEAe4+
         2uZyYCpExp0cGAWvYUHTZGbass+2AJDKP510TtOM2028Vk0odd7txjzKb7j2UaumO0BM
         cu/SsQxX900RS76uKFk/1i2HgH/f5ixI5AUsGJzS0gDu/FzxW0AjqE8L6h8CFslC/OXK
         MpbA==
X-Forwarded-Encrypted: i=1; AJvYcCXYyCoxoUG9CGskNpgRjV7jjbZ+mWkChFRpDxWe5eMhnMwKFh6b0xfmJLwamcBwWWLEGHOjZ3S5qgMnbWB+Jg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGaZZAhVJYpQ8wBWUyerqg8Gb8RiwygLG4ZxNaZEXXwAXRY3ZU
	QgERh4B7sfcKK3O5OqqPG46h3aGODLjEo4YKpPvOBhwsPnSUGuKSGbj3DxzRV3mjgE0nG8oOVsf
	KssA=
X-Gm-Gg: ASbGnctRDzPGFossBKJvsdnggQExOpJj4gCdsbZHrTYI1fdDywYgMt8QIWELf17zg9Q
	8VJNCN0DQ8yXzhXo6pNcPn2hYGMmAOpjLA/rd9QV4RRFluQCApXGGchnIny+UPIId/4mk/P95lt
	KFQec+zcJwW+S/asNUo5MxkXjnAj5N/FmbZH4h83mhmRXVqeA2CxSA9Ra9TyTO0J1/QEysZjKV2
	rCp6dL0EOd+yksrmSv2fb9AFnWR/CU7JeDjxF7TKtNmtQ==
X-Google-Smtp-Source: AGHT+IFF4P2YXnscplxiGukxPYkf09OAWc7B/D6urrQUWsAbwpbsXxn6dv3H+qNYpcsHs46pVmyu6Q==
X-Received: by 2002:a05:6870:828a:b0:296:e58a:fbbe with SMTP id 586e51a60fabf-29dc4189835mr4165584fac.19.1732737692603;
        Wed, 27 Nov 2024 12:01:32 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71d65a48895sm755944a34.63.2024.11.27.12.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 12:01:32 -0800 (PST)
Message-ID: <cd72e289-f671-4b8d-adb9-aebdf8a43afd@kernel.dk>
Date: Wed, 27 Nov 2024 13:01:31 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 12:43 PM, Jann Horn wrote:
> On Wed, Nov 27, 2024 at 7:09?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 11/27/24 9:57 AM, Jann Horn wrote:
>>> Hi!
>>>
>>> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
>>> to an mm_struct. This pointer is grabbed in bch2_direct_write()
>>> (without any kind of refcount increment), and used in
>>> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
>>> which are used to enable userspace memory access from kthread context.
>>> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
>>> guarantees that the MM hasn't gone through exit_mmap() yet (normally
>>> by holding an mmget() reference).
>>>
>>> If we reach this codepath via io_uring, do we have a guarantee that
>>> the mm_struct that called bch2_direct_write() is still alive and
>>> hasn't yet gone through exit_mmap() when it is accessed from
>>> bch2_dio_write_continue()?
>>>
>>> I don't know the async direct I/O codepath particularly well, so I
>>> cc'ed the uring maintainers, who probably know this better than me.
>>
>> I _think_ this is fine as-is, even if it does look dubious and bcachefs
>> arguably should grab an mm ref for this just for safety to avoid future
>> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
>> means that on the io_uring side it cannot do non-blocking issue of
>> requests. This is slower as it always punts to an io-wq thread, which
>> shares the same mm. Hence if the request is alive, there's always a
>> thread with the same mm alive as well.
>>
>> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
>> to dig a bit deeper to verify that would always be safe and there's not
>> a of time today with a few days off in the US looming, so I'll defer
>> that to next week. It certainly would be fine with an mm ref grabbed.
> 
> Ah, thanks for looking into it! I missed this implication of not
> setting FMODE_NOWAIT.
> 
> Anyway, what you said sounds like it would be cleaner for bcachefs to
> grab its own extra reference, maybe by initially grabbing an mm
> reference with mmgrab() in bch2_direct_write(), and then use
> mmget_not_zero() in bch2_dio_write_continue() to ensure the MM is
> stable.

Yep I think that would definitely make it more sturdy, and also less
headscratchy in terms of being able to verify it's actually safe.

> What do other file systems do for this? I think they normally grab
> page references so that they don't need the MM anymore when
> asynchronously fulfilling the request, right? Like in
> iomap_dio_bio_iter(), which uses bio_iov_iter_get_pages() to grab
> references to the pages corresponding to the userspace regions in
> dio->submit.iter?

Not aware of anything else doing it like this, where it's punted to a
kthread and then the mm used from there. The upfront page
getting/mapping is the common approach, like you described. Which does
seem like a much better choice, rather than needing to rely on the mm in
a kworker.

-- 
Jens Axboe
