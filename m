Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7181FC7ED
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732730959; cv=none; b=D2zhSU83WY6sAOJLzXIR+t9qzQFebB4tYwuICeC7edk3Qtw0+IbMdxpZdD06RlR5zqhkuOtNS3Y1xDTMjTXEz7twEvnVU/FUkefOv9lJRIV5y5+tEz4xYrJ81UlqwcCnvcXmAdGUqTEdssKqP0tYXRMBVmFxyYdKWIVPrmPJDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732730959; c=relaxed/simple;
	bh=k6twA83RhgEkYTndqjBQH+J9zpIY+1fGNgoXAENHfK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ue5RIyPDhcF2kdMjc+mFrTfIEWoqNxUuM94Fy0Uva4nEVqQV874QxIybrtc9jcQWw1I/wEeJoqIXpL4MFH8FpDfA37QjLrsP8mK5yGP83RzOI7YNk/aas6Zw2ZGeDLjuSX30f4kgUjqtCYuqG6yzHWGwmYgPgb5Ufqxar0y0jrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qkDGMqlx; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qkDGMqlx"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3ea369fdb0cso38045b6e.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 10:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732730956; x=1733335756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DoGbLkeVIO7J9gwZq5xeigAI0HvXe8K7jWGsWScuDCY=;
        b=qkDGMqlxIWubWLRKYO23oG6uIwivmta7IvJ0SkOX7iBAHMgG4k4WfVZpluKHcsPqTW
         6p86b5qbChpTbOlagcjN5HVaLjksRfJ2Ws0bfOulCExI5z5HM/xg39nueBubch9CIVL6
         JvmBaVduzAsmQp5AlW3tMLRfIdae65qHqv8YxJpy1luYHnMN9KbkSOjbaUX8QrUTJwML
         429GabbJkKLPPraWu0wMDlODcdSG559mnNK1ls4VouCWralFlNAwzq5Byd1+fGR2CatH
         3AlvVODs0vS6/pGFfjYuPomDT25JGEwELKAbbguSZnLbRNramxBrpT5wk2ckN/taR9SC
         CGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732730956; x=1733335756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DoGbLkeVIO7J9gwZq5xeigAI0HvXe8K7jWGsWScuDCY=;
        b=J4j33UE8RSN5OqyJtFQ2DNEqZizSZo94zsd7OFUSWBZ5ArhXdOasetirSy2PLnulUd
         hx5uwsQjrg4EQAZI/Gpf5Bj2cnQ9OzPa8RowyWvITOtdJ4gSY5rLqnYt2OuOw765ki/+
         utpeuQiu8Mlo1/vutJaLXzts/v+fN+8hw9Q8+UcEBo/Mhoa14cjJbLYJR8Kugx+cn6pW
         g7sZ1gfG5Qb6F5kc7p7bL+v95PVpaDQC9ED5LsU0v630kIdR5ngWVc22ZpdFH1/vPXD4
         l21xTttVwN3XHrDcYdA2tBEZYLlr/baDuOOF+VHxtYHKRDU8BF3J/DZcbztfbryGPLCG
         9eGw==
X-Forwarded-Encrypted: i=1; AJvYcCV8MKnZ6j5Hqlc7+cLBPI/x9SZwpaHV3ou4/ezjr4gofYmClxHie2RdYzfCFExAZ14yw4Fc1cVT9hseCQF5bg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw00LOIlK0fAmTK1p9zIrpxSuUyvqFwOvuLQbND61AuvyovsGck
	Jd6KYOv1rC6m0h/omA95JzKgegtR/hzs1jweZno2hRJ91MD2iOBgBIydSDJh4SQ=
X-Gm-Gg: ASbGncuhfNdzreMHyAbkNtgdNSqCqYvlUQrSpU755pcs91vfoASmYZ8DSM0N/bltHz7
	VbGydEL+LmbgHk+S/6+MIcu684XILobAdWRQfJuNStdsm3RTZ44M8o1gLboh8e2iepbEmTb5gMF
	VzHkABv3vm9wDSGCHbijJt5NV1UoIrXwMguRRvQcm9GNptKBagzZklJXOYiig84z0lMPwR4pKiP
	F0GOAngxXnnzSZeAY+k7Az1n9dwaVAaB7SM6ezxdEtBOw==
X-Google-Smtp-Source: AGHT+IEzYAvcMur4sgCG1WEl9xZWuubacTInfBqh/+y3ztclPYbL17Apse++rxDF3EcKguN87eXAzA==
X-Received: by 2002:a05:6808:6508:b0:3e6:263b:9108 with SMTP id 5614622812f47-3ea6dc223f8mr4430489b6e.22.1732730956242;
        Wed, 27 Nov 2024 10:09:16 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e91500f931sm3740165b6e.51.2024.11.27.10.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 10:09:15 -0800 (PST)
Message-ID: <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
Date: Wed, 27 Nov 2024 11:09:14 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jann Horn <jannh@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 9:57 AM, Jann Horn wrote:
> Hi!
> 
> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> (without any kind of refcount increment), and used in
> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> which are used to enable userspace memory access from kthread context.
> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> guarantees that the MM hasn't gone through exit_mmap() yet (normally
> by holding an mmget() reference).
> 
> If we reach this codepath via io_uring, do we have a guarantee that
> the mm_struct that called bch2_direct_write() is still alive and
> hasn't yet gone through exit_mmap() when it is accessed from
> bch2_dio_write_continue()?
> 
> I don't know the async direct I/O codepath particularly well, so I
> cc'ed the uring maintainers, who probably know this better than me.

I _think_ this is fine as-is, even if it does look dubious and bcachefs
arguably should grab an mm ref for this just for safety to avoid future
problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
means that on the io_uring side it cannot do non-blocking issue of
requests. This is slower as it always punts to an io-wq thread, which
shares the same mm. Hence if the request is alive, there's always a
thread with the same mm alive as well.

Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
to dig a bit deeper to verify that would always be safe and there's not
a of time today with a few days off in the US looming, so I'll defer
that to next week. It certainly would be fine with an mm ref grabbed.

-- 
Jens Axboe
