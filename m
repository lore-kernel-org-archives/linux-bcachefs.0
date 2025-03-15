Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091821C8623
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742057234; cv=none; b=hcECs00No9e0AS1kbjo82xefjJf8sRndZPoxnGXvoFBdRejgQAVQSXjFJAOp8l0RUhHDX2sBkq9k3fHNaJ0u5wR+6vQVC93X7h73k1SID6FjU4S+HNWM891yugmfPK/SzOWIdEPXp9XtU1dONt6hvpePIo5BloR1p4OKEcp9DV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742057234; c=relaxed/simple;
	bh=RzHWaT4y8FPuXSb9EybUcX/aTXlFTIG+ZECIl1glCDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5efdd6+1ab/V6jfnyjwARRUF5p54BEukypO5kLHI2ZhetyeADqH2Zy6j4jH+5hiUm/ORYQkCIunyM4F9hxKv9YpX4aERC8b2xwUyWYs0UHRmJP5PYzEU5kSR5tpu6Ds9BAZNNVxPS4Km5GKCcG4W/o1aXG1DZL0EMBbW2Vvy68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NezbWjHJ; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NezbWjHJ"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85da5a36679so301036339f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742057231; x=1742662031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RvVjMW0xlIRW+xAq0tG5On8FqH6hGpEXfAg7HOXwb2o=;
        b=NezbWjHJWogCb+zWyAdo2X381DaXgKolfJvDEb8zZqsIOoEq9DzU5aQ1iUCzVj43US
         Mi6gCU2K27H9SVnXImmqcAQFKwn6nRTfpcs9nlNIGKf4L2D7qBPHsMXV/ESJa91aIX5q
         zwCNOHlFQFsH6yEbwMvXZL5a+tzF7o8/pcJp3QvNQTMcbF4j7Qj7kP5JK1JXHrz4h/bW
         WFpCL9mfNaSWzmdMMLP9y3CYLD+KsFBszYm0Yi+o0TgymxImGZNxCJbw89tF8DxkD3te
         e0cL34wbXjIBJDlK60DVVjQbeUEjFApw4j5od7A9dIK/l7pAlcC1/kuTATzbSapcOUVd
         xx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742057231; x=1742662031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RvVjMW0xlIRW+xAq0tG5On8FqH6hGpEXfAg7HOXwb2o=;
        b=OJwIdH9f9RbKO3jnfI+pH2b/J/igRvuSUoEYhgeIOymrathDtzx+zOeKcNgptzTySC
         x3ovU36kvD1Siu4cSY+6SOsStvAUv48mOS7dMNMSFivpAXiK1Pt4QY506UfnL0ETkctH
         KWIvcIK2eV7lbNpiTaEFUfk66mKVeQKugCkOIBWVd4rYGB7MYXBYPdtB1MOeQirrS02Q
         NnpVPEBghaVpCIfom0dJ/XFsVv7LFy+i+CCuHJMIeu9iMUMqp9LWLMiXGfrsqZlqRLpD
         AVT6tXoUa4FWS+0DwfIVv6CtZ5toQfFRvmzzZOsZHKA1fx0gPK0gzPgbvq1BZ3hDSn3a
         sm3A==
X-Forwarded-Encrypted: i=1; AJvYcCWeQrstgZZQAkgG06wVkEDTuiMZ2vdJOBgsawUJ3bDnAHHeG7VWjf5QgL9n6T/BQ6sjYW0YkHJzSk6PIx9QUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKEMakDuqguL8egj/rBlggtkjN4PIwFD67gFQx/u2yZqoXnqHG
	Dg/2d0tpOf2J8JBPvL2raN/s4BHBuPi0LlHGvaJceD4ksXPqii4xk0MrBpWPNAlWepteq0FDQ2C
	Y
X-Gm-Gg: ASbGnctPagQeCImihPdOBg35iTL7ZcdmhZ6Ldrny5Gg92CUM1sgK1TvvXgSd8CG6ldp
	QWoKksY4bYvhke/rSGprk1UrLYb4Mee/ea9oJ9IozKn6op9s7gLXsB6IxYyw3HnxbcAkAhK0GCa
	8beScSciliCOb5k3AtYozn/bc6LU3xvZs8jsKGdANFg7FJsL0fI4T8wGebzr3dORtMDPJs/8JvQ
	blTKZu3mHKi6mYljgqUZkydERD/pLyL5ZzjYTT8eWeMHXc/Y0+OmdZfJMALZ6Cy0lxmuKazfZM/
	iMLTPulKREGPkjUgf5jUye0VhxrRGXWsLHKdKAhtSQ==
X-Google-Smtp-Source: AGHT+IHOOeiIQZQPOu8/OVyhd4PFH31ke+riSoGFw34JBk8pbMYH6OQSgnRrTi5e/eP9N2SBosxEdw==
X-Received: by 2002:a05:6602:3a0c:b0:85b:5d92:35b9 with SMTP id ca18e2360f4ac-85dc47d6010mr680553339f.2.1742057231114;
        Sat, 15 Mar 2025 09:47:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb2b2sm1404595173.94.2025.03.15.09.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 09:47:10 -0700 (PDT)
Message-ID: <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
Date: Sat, 15 Mar 2025 10:47:09 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Cc: linux-block@vger.kernel.org
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250311201518.3573009-14-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 2:15 PM, Kent Overstreet wrote:
> REQ_FUA|REQ_READ means "do a read that bypasses the controller cache",
> the same as writes.
> 
> This is useful for when the filesystem gets a checksum error, it's
> possible that a bit was flipped in the controller cache, and when we
> retry we want to retry the entire IO, not just from cache.
> 
> The nvme driver already passes through REQ_FUA for reads, not just
> writes, so disabling the warning is sufficient to start using it, and
> bcachefs is implementing additional retries for checksum errors so can
> immediately use it.

This one got effectively nak'ed by various folks here:

> Link: https://lore.kernel.org/linux-block/20250311133517.3095878-1-kent.overstreet@linux.dev/

yet it's part of this series and in linux-next? Hmm?

-- 
Jens Axboe

