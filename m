Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC421FF7DD
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 21:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744072; cv=none; b=jSnw6GuQcInvil0r/KmS4G132yRnUHYArwv1fs9PPXmQ3uRETFbjxPGX0JiNLyP3ewzU2Kan/eZEbF295mXu5RA6QmyotB8Ebiy1NmfqLjHmjIrQjrk+ZAWBHs90YIGMHUfZc3aGyMmGfJuDIIdMoCGta1KogzL2fyJOhh7J3Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744072; c=relaxed/simple;
	bh=Yu9eV8aMSgJY3eRDSR877vu35VsTeSfTjqyRCx+cb7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CntEoufV4woOpCnpM//SedXxDoBEzeQxRj+f6ofYTfjBjGqx1JUTUPTKGMxljNbUckcK7prCpOsHT1GYPIbbF6xgCT0k7jCKJTFsJPHuLQzJC9scCOJ0jWQ35mzBbl7LrZdb2E+MMIjcLWLnC3lv7TJXFWo8JjT4MppcYfgt/lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=luB0RLCG; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="luB0RLCG"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2968322f5feso188529fac.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 13:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732744069; x=1733348869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hk+VLjTh/bjqFCtbLbQLYV8o243n8P6oyhK1ZeYQRkQ=;
        b=luB0RLCGu0btJxSfmW+WbGvgLLHre0C9CmxWzFYK+SgRd68f/qkEZIKl5N+NcvImMw
         5S/TJja04wV40wIu/pR0zaTg/hZQ82NhCpASfDt59rmT7Tkr4nhpe9uJITCkEFZnAG2K
         dlArvRTykKCUOQ///DyWdYQPV47XNjcIdQAq1JXcAZNhAVeHuBYcncGqAAibSkvhc26k
         vpXJqKOwn3MODoNEWEDVFzCsHjZHOKpfe1CU9GFadaIx+aYOSCHBTzqc0EA8kb73QJ7v
         2Si1EsawpMT4zGxHk6sWw9/oRBvPoAMNz0CetIxln36GMgqsQS+oBQBJg0/3domjYm1k
         uTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744069; x=1733348869;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hk+VLjTh/bjqFCtbLbQLYV8o243n8P6oyhK1ZeYQRkQ=;
        b=pyhdy+S5QXB8dXlf3nEswZkrOketQC+azt1piqJc+uwwlAvPgp5ifMq9LKxVSAGfFs
         iLpbL298gByetDN2qxTxRO4Hwn9x6ls3R1ZlLQqkybdc7HG9EY+JpN10SzA4jL7pELS6
         7agRodJRAr5k5ExBrCRT65w/FvPHq0avQ0xLZvtvcJbESpU8VKhXwP8g7/UudFlzTYVf
         Apb7+/HDJ6mHiEQs5UAnOWPfm4Oa9trROHar0BJmvyD/br0djx2qCjmnfp6BP+pY9ETE
         SK5JLiGwGspHRjct1XQHKE9k9PBoR8JvrGQA+0LjsLE82FPfw22nOvT6QUNAtazhVBSU
         ckkA==
X-Forwarded-Encrypted: i=1; AJvYcCWwvv1ydWTMo1wfZb78B8+LTqvSHTu/yNukBI0R2/JuJBsqZ9I4CNVm50rziujX8a2AyojwlTS3goWAYteXTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtPZGKcCCprmYuBK9fARSE5aSpFLJIlrqdEg39yT9ICU7bM82O
	j8ZVSJfVzl+jVjHoEy1uu+zsd6kWJCCP6AZ03xy0fbMOeRkxzG8kQ7EdVER8mmE=
X-Gm-Gg: ASbGncuKo6KIOJOKMK5A54EDuvdPhCHs6qTgdePqPH7hFzn/pgPwTg55Fl2AgfGPff8
	/MIzpzL3Bn0k4iOirPmWHD6hTfxRArjzAV2Zv7nyYx3X6XcYA0S2hQOVPZFma00LN9hTp8ARP2M
	nEqjBjanTZEwUrjm9uWUj/7er4M0BR5DFikY2AC4lSovsVIEJ0RkXp+BR7aGvxJAKM4z3DXm5/o
	svYvYwyCfPCNS6jrMYP87l7UzpjKAxFazzf5Xfpwobf0w==
X-Google-Smtp-Source: AGHT+IH1Fy7Uvzc3tY0TGYqb1J7lf5ga2A84Hn18Mh9+sRQOeXgY9B6hXphfAFtE2Va3X63kWz4DRQ==
X-Received: by 2002:a05:6870:9d8b:b0:296:9f83:9678 with SMTP id 586e51a60fabf-29dc432c857mr6038650fac.26.1732744069401;
        Wed, 27 Nov 2024 13:47:49 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71d7255f7bfsm29154a34.38.2024.11.27.13.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:47:48 -0800 (PST)
Message-ID: <09129809-d3b0-43ad-88d5-aee2bc0d04ba@kernel.dk>
Date: Wed, 27 Nov 2024 14:47:47 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: dio write: Take ref on mm_struct when using
 asynchronously
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Cc: Jann Horn <jannh@google.com>
References: <20241127213649.1615078-1-kent.overstreet@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241127213649.1615078-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 2:36 PM, Kent Overstreet wrote:
> When invoked from aio, mm_struct is guaranteed to outlive the request
> since its lifetime is tied to the io_context - but that's not the case
> for io_uring, it's possible that a process could be killed and mm_struct
> goes away while a request is in flight.
> 
> So if we're submitting the rest of the io asynchronously, we may need a
> ref on mm_struct.
> 
> Per Jens, this is not actually a bug because we're not yet flipping on
> FMODE_NOWAIT, meaning io_uring will do the submission from an io_worker
> kthread - but this patch is necessary for safely flipping on
> FMODE_NOWAIT for more efficient submissions in the future.

This doesn't look right. The mmgrab looks fine, but that should be
paired with mmdrop. And you still need an mmget_not_zero() before doing
kthread_use_mm(), and then the mmput/mmdrop when after unuse done.

-- 
Jens Axboe
