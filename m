Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61762040B2
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742063574; cv=none; b=gwOBOMlQX7a+eX5v+0MJ0M5MYWcCDlT4tgOzzRZ4AqJMBR5dPOPqj61HimGIVInIcCw1g8ZS2dQQUcG9j1BGvABiurkJjZX8Bzbaqc0q2C1+d5HnDdJMVD5onzTr211S3fs/jrjORZoKWbInc7Jts84ZM7CrR/d/TjzhkP7qzO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742063574; c=relaxed/simple;
	bh=v8D/N3jCGC4p2rP7k3QeoptnJJAlXxhEpXyRAgRNPRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdNbqUBuyKYditlomyGU/AWZmSFI+zQdCXAwhbFUcv+9WoJtA+PgX8oKVCBdFpvEL1wLYNdbtVu+gfoS69So9BLaIY6FMTrKhmXM3ClC6IKXBl2mBw1bh8vUozZ17lljDAEk+lzx0Vn1phlyO5lt5Bu1mdqjnPYo0Wb7iU6k9qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f9jfFhsU; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f9jfFhsU"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85afd2b9106so295366239f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 11:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742063571; x=1742668371; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aeztam6ghUtq9MDLhdqtlE9lL81ADanK1zpJziE7Q3E=;
        b=f9jfFhsULeuqmdI3l7wiOth272VG/5pLzie2egZ4sNhBMXOt4OojB79rXZk3rG22Kz
         GHBU+tYge5Un1pAPsEMvZTJdVmDvXkwfzVxjOZtPO6W9Crn/5phUvMir8wV5ynt8zufK
         PBGDmuBBz3u72bH9ceQMEz+5+9ktf5B3cx2IoChhUY3c6Zu3ZQ1ObqrftMD0pWw6s/N5
         8o6ScrEGX1dZwllzsvHna0z3JoY83RZuk2o6Kx2c9pr+D7p/viIJZkpxn8UxCGgx5uqM
         Pru4HPY+MnLmJqWUwxubEE0a+Cj232XQ38t4zxm01p13KtbmAw5N36pSG66YF/+1clpb
         spUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742063571; x=1742668371;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aeztam6ghUtq9MDLhdqtlE9lL81ADanK1zpJziE7Q3E=;
        b=WLY5nlcLZvVpk2JtDPajYWLiFJ6iR5Dj2UM3N7fMJUMSH2ZlTIJ0dTWZYbElgbsQcA
         5Sm/Q7PbTE4S0OdfU4EMlL8l7nBRTqF6xjCmt7e1h/pIIsRAyxnYI8rV7U/EVBc7zFX0
         i9LaEP/mYoiHWMI0eH17v4TdtIXQ8tbt6dgicx5elg2bSPNl6pZ5xJtUi+NqU0VyrnOW
         qpG/8I1Z3ZQ76EOWmMvySCkY+phv3GLKUKFDFQkcSFcdVqIqqS8I47+HAGbB0OMFRey0
         UzWaz6eXeZjq2ibwiMNyJNW7CHX+84oKCz26yq3hJr0FD8zAvghXVUqV1f2J9h7joCY4
         4seQ==
X-Gm-Message-State: AOJu0YynE99AGLJz7lgWxnB5KDCYLeXgURO9O3Lq7hyT20ne8V7zQ6Sd
	K0usuR6Y6fTDDa8Dn/PbCb/3VHTYatKzkex/qwNYRj8DshNXgCe6+kshWjG8mBIQJWwzBha/GDu
	y
X-Gm-Gg: ASbGncv+Taaa4PAOoaofwPev9atYIl/9CiVr8By9k2V0/Fa8ehwEIMKBm0CbuH/2bWk
	IS8xI6UvOW3//Gkv1ylGDvHTLiKNKFX12Q03iWc1CaDfuqklHWuP0EJwKn5drQjhDrDLzXER1Zs
	LrGsaI8Fi/Nm3+goFhR3gXqf887vtK5vPWRglaWbFf4X7IzxQjR8+3TTzy+/oYMzVFaxTJrw9G6
	PxIsezyv+QJNDEfbACzuCXWvK1bJH9td4L0kNriG5qXy2s5mAq0WfLxQZ9PgLSS3Ozj/TnAzM/Y
	W+Xs4rQXsv37fgpkT3lm8LPteC77Vzp5YHy2QCB/eA==
X-Google-Smtp-Source: AGHT+IErFgEGEaeaBt1IKwR3lbucnH0t9kK46B98ON5bj92E4nH1khAsNT4+PmCXVGo9geHqTquRTQ==
X-Received: by 2002:a05:6602:3894:b0:85b:3885:1592 with SMTP id ca18e2360f4ac-85dc48783a6mr755365339f.10.1742063570739;
        Sat, 15 Mar 2025 11:32:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637199e1sm1448512173.55.2025.03.15.11.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 11:32:50 -0700 (PDT)
Message-ID: <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
Date: Sat, 15 Mar 2025 12:32:49 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
 <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/25 12:07 PM, Kent Overstreet wrote:
> On Sat, Mar 15, 2025 at 11:43:30AM -0600, Jens Axboe wrote:
>> On 3/15/25 11:27 AM, Kent Overstreet wrote:
>>> On Sat, Mar 15, 2025 at 11:03:20AM -0600, Jens Axboe wrote:
>>>> On 3/15/25 11:01 AM, Kent Overstreet wrote:
>>>>> On Sat, Mar 15, 2025 at 10:47:09AM -0600, Jens Axboe wrote:
>>>>>> On 3/11/25 2:15 PM, Kent Overstreet wrote:
>>>>>>> REQ_FUA|REQ_READ means "do a read that bypasses the controller cache",
>>>>>>> the same as writes.
>>>>>>>
>>>>>>> This is useful for when the filesystem gets a checksum error, it's
>>>>>>> possible that a bit was flipped in the controller cache, and when we
>>>>>>> retry we want to retry the entire IO, not just from cache.
>>>>>>>
>>>>>>> The nvme driver already passes through REQ_FUA for reads, not just
>>>>>>> writes, so disabling the warning is sufficient to start using it, and
>>>>>>> bcachefs is implementing additional retries for checksum errors so can
>>>>>>> immediately use it.
>>>>>>
>>>>>> This one got effectively nak'ed by various folks here:
>>>>>>
>>>>>>> Link: https://lore.kernel.org/linux-block/20250311133517.3095878-1-kent.overstreet@linux.dev/
>>>>>>
>>>>>> yet it's part of this series and in linux-next? Hmm?
>>>>>
>>>>> As I explained in that thread, they were only thinking about the caching
>>>>> of writes.
>>>>>
>>>>> That's not what we're concerned about; when we retry a read due to a
>>>>> checksum error we do not want the previous _read_ cached.
>>>>
>>>> Please follow the usual procedure of getting the patch acked/reviewed on
>>>> the block list, and go through the usual trees. Until that happens, this
>>>> patch should not be in your tree, not should it be staged in linux-next.
>>>
>>> It's been posted to linux-block and sent to your inbox. If you're going
>>> to take it that's fine, otherwise - since this is necessary for handling
>>> bitrotted data correctly and I've got users who've been waiting on this
>>> patch series, and it's just deleting a warning, I'm inclined to just
>>> send it.
>>>
>>> I'll make sure he's got the lore links and knows what's going on, but
>>> this isn't a great thing to be delaying on citing process.
>>
>> Kent, you know how this works, there's nothing to argue about here.
>>
>> Let the block people get it reviewed and staged. You can't just post a
>> patch, ignore most replies, and then go on to stage it yourself later
>> that day. It didn't work well in other subsystems, and it won't work
>> well here either.
> 
> Jens, those replies weren't ignored, the concerns were answered. Never
> have I seen that considered "effectively nacked".

Kent, let me make this really simple for you, since you either still
don't understand how the development process works, or is under some
assumption that it doesn't apply to you - get some of the decades of
storage experience in that first thread to sign off on the patch and use
case. The patch doesn't go upstream before that happens, simple as that.

-- 
Jens Axboe
