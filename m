Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8468F18D64B
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742058204; cv=none; b=E89FQlpm4gcw4YoJ+GH1KsNaW1vBlCAzIWfZCBa2BL9wzrJ77zhBXadYbjt51wdF31E5bUM6UINVpUQzmd9nPDVPZntRwtiBbqvcqMSJyBAJDdt7Xellh4GUIV8UShzOt7sqG739Xi433ClXwof2uZy671G9drL3IvOPlSGY+eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742058204; c=relaxed/simple;
	bh=7ZdLXaf+CadhUXljcsUJzvjVnLmjmhtXw6QW5CUaWKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E/Tl6nJOgkK/ofv04N8eAG0xsI1Iul7KaWE/WQJwlqJwj1GhcBdKd4/W8HU2eEX/GumI2fnZtLF+87l8pw+5UvJBMZ6IRZrIegB+dDeSAPyPBApC9U1GxoZJWeBeDSC9F13rZ0/Jxqm/Imqse5ekpbqCzIFTMJRgv57WNWhLWw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TlPMonJf; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TlPMonJf"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3cf880d90bdso10890345ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 10:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742058201; x=1742663001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Egxjbspk7CUTt0+tSR1DyNLTrwPXLP2pqAPJwtCDH5M=;
        b=TlPMonJfTBp+8Lb+TLdCihB5zrZAXN5sVUWjsv/WIkpvCX+1diKrEdSr7AcrBV44Th
         a6wQk0Jz6ElhavFnpcQE6wC7EA1pkhJFY7Z3u0REgQqaDMYcSjjICJCjpZPdj/qq658t
         6R02lx6NnZF7Hx+AH8DBSnNDXUjp1JI1U0tGw3Ggiht7NZ89Nr6fwqFlRSQWM/IQpAH9
         UmG7RWpGYPOgIzaQqnwbajDvdDI2uqVTDx8OkxqRXE0eXQJEORwToA/qBG7WvXRF3SAf
         RZfRe1Oq1wWyMDKLwmkCDfRyQJJYRLlwk2xTB+/ijQS8U5cvvupxVNNBGgR1RnZULosF
         jVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742058201; x=1742663001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Egxjbspk7CUTt0+tSR1DyNLTrwPXLP2pqAPJwtCDH5M=;
        b=uUSemYys1jhSAO3jgg7VpwHjSEc5D13hctcsuRIizvLnNZCDf3DWsSMe7ykbgGbtML
         Ra+zJsfNsET/YKg0BmKIpvaohlYDVYlHUnfBWR2eK0lqZmusg1iC1172vUFpmcn7lLla
         UPQn3BklPUOS0dedeSEw/cqxt+BXX0nZPh3KW27QzjnSl0JeSCDZrxOutW4jz0C0ZVr3
         v1tYUVwQyBwvG7yYyzJ3s5PnRZcER0w8Jva01t1bSmKpBQLYj8YUUdzQhigR3yIzjDtw
         u8PEbV10kwjOXTZxjMoiseoia/SjPt0W86ADNvPJiRvJB9CNb+y24vLrFI79uAXSeQMu
         czPQ==
X-Gm-Message-State: AOJu0YyHWXb+WEC//sL2Jbf9E/TVtFEdtwPO9rFdrhNPQD1Wlygb/GmH
	lxNE97SabM6nC1tXXELmq/W8aBYVAPDnXJLn+YWJgBIPjV8bNzGuIZCR5CTOP8Y=
X-Gm-Gg: ASbGncscEDOHJ3AsCmjV18UASdFJBKCH+kekdREjVL6MyrGcb1Bs4hHk4nmC+HjAemi
	2hqS++ynG/MtA3Zw3LfiYYLk5+PZkAdhAtA59+9MRJTBvtoBaW4pnTFSToKdGiKufoNPT+ZFYg0
	WrhdRYql15mLjW+GVi2gvpGcQEIjSQwcPDUr+23R3BBX3ZlMjbaBvC3uxrqu+4lfIjHk4JMDeWl
	jNZ7W1sIoOYUmdL6xIx8KktSeIrttmFsz/xUoIcpdZG4eMI/GnZIfBZooDBoMGvFjb50zo5fj9j
	6jvyUMO3YORb6842NZ3cHl3hRyNahC80iEky27z/oDdr5O9PAek+
X-Google-Smtp-Source: AGHT+IE321PsNWhzNdrkjj2zIMLoscsn+Dfjy1kwPwR01aE8+0mG91VZHf8xuhXbf7dGLwUeABh1Qw==
X-Received: by 2002:a05:6e02:3710:b0:3d3:d965:62c4 with SMTP id e9e14a558f8ab-3d483a0adb3mr64189635ab.10.1742058201572;
        Sat, 15 Mar 2025 10:03:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a667197sm16598545ab.25.2025.03.15.10.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 10:03:20 -0700 (PDT)
Message-ID: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
Date: Sat, 15 Mar 2025 11:03:20 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
 <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/25 11:01 AM, Kent Overstreet wrote:
> On Sat, Mar 15, 2025 at 10:47:09AM -0600, Jens Axboe wrote:
>> On 3/11/25 2:15 PM, Kent Overstreet wrote:
>>> REQ_FUA|REQ_READ means "do a read that bypasses the controller cache",
>>> the same as writes.
>>>
>>> This is useful for when the filesystem gets a checksum error, it's
>>> possible that a bit was flipped in the controller cache, and when we
>>> retry we want to retry the entire IO, not just from cache.
>>>
>>> The nvme driver already passes through REQ_FUA for reads, not just
>>> writes, so disabling the warning is sufficient to start using it, and
>>> bcachefs is implementing additional retries for checksum errors so can
>>> immediately use it.
>>
>> This one got effectively nak'ed by various folks here:
>>
>>> Link: https://lore.kernel.org/linux-block/20250311133517.3095878-1-kent.overstreet@linux.dev/
>>
>> yet it's part of this series and in linux-next? Hmm?
> 
> As I explained in that thread, they were only thinking about the caching
> of writes.
> 
> That's not what we're concerned about; when we retry a read due to a
> checksum error we do not want the previous _read_ cached.

Please follow the usual procedure of getting the patch acked/reviewed on
the block list, and go through the usual trees. Until that happens, this
patch should not be in your tree, not should it be staged in linux-next.

-- 
Jens Axboe
