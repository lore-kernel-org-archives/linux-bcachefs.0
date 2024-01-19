Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4EA55E7D
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 21:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705699330; cv=none; b=auL9+h5MWS2NPVEaScnvIOwOBFZuBMHjpRxuvUu4kp35Wrt5723oK4Dnf051k0jR8WmLEPJuJ/sh4lyMxHiCVPZU9HXTo2NP4Z79K4eO7eByU9BYVhjeR6PXCxoHKrV02HbCUm36zoHdXD5ulvsnJ1oF8+GSPd5RfOVmItrNskk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705699330; c=relaxed/simple;
	bh=sPGlgEPqyfWmZ8BYf2d0lG1R1fXgaJyVnL6kDWoOcPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWVbrd0oKihj1zAYOYSdxqciaPB0BpZRUAR5A1E5Mp9BVdWoE0fYTkZ3MYgpjpNWheGzkLPXJgV0W8axL8X4C9DLs7Te0v4DS0ZmzycWMBgrJHSjhtT0syav79Fqwo4V/M+67Ikf8ZWlwFSIC0qINCgl1Ob+fRMyKJGf76doLWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L0/tgKDl; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L0/tgKDl"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bb5be6742fso13606339f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 13:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705699326; x=1706304126; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HMqalDxMtWXRWw8mRuYXoI3Qq2FQfasx9rH0LZ2RkwY=;
        b=L0/tgKDlF1vioWBaZtBljCQRPyzrNW2kVWpwt/cW7jgoVZI/1UzAPr2WUI5bnJXnqc
         4cCwhy5PvNWju6lTK0vVU9LqaVdcaetYCgOjIQOJzPCJ3vIhGU3Gn+fVKDkoCDh/vrs9
         05abD9UzSDXtD5WaS5ZHH/TcNw3TpGaRxvI/UOGPSp8YQ5LmAzdBKcsPBhkgpB5qSRVH
         NAN9EYirmLqRxRTxu7WtVDADUsaM5CSzQ5UVnMct5G4LSVqu87u1kQZnxVxlVc1+bq8L
         2VhS7md+0K8KWjoZhm7IQDtyPPRM7loVDPaTlZwFgSctQ80JD2uXpEoQoyg3+cweyAZe
         WfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705699326; x=1706304126;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMqalDxMtWXRWw8mRuYXoI3Qq2FQfasx9rH0LZ2RkwY=;
        b=rVANYBQyh8KMJ2U8xtK21Q5EAF3a2nREou8rLRt4pIGP9z7k9XqNEYfp5ZyYfhHQnS
         cDMBnVujSXQZdVoraIauJCXN1dqgOQhNq585snG0rgns5xfNrox7pLsqp63J+QJ8+AFX
         Iy4Q6cNLBsxYYsIJakEgsj1J+fBWPBqhr7ob3eCGRvwVJC4K2HKGhGsZhb1LAKdHs3SQ
         dQp/y6RtqgzzMZMtc59EdY8pWFrZVNoh09B8wwCfoip6HBrBxlKxZjMqhz2mSxSPsz6u
         GGkVFkFCUw0T6QlLLbI5zbB4D1Ajy50g81H9JOO9w+ALrXNwjoRlGdQd6zU6DxL8C8Sn
         Z6QQ==
X-Gm-Message-State: AOJu0YwxZx+MBH9Q7sPhmmTqnU+CWrjW+s9vPU+TEhZN3nZmrnPD0jsr
	4gQ7rRsh6Gpvmx/ubRTNBPT2XTAirr79EG0LxNeqr9sU2wDHFQTomqtX7xaHjxA=
X-Google-Smtp-Source: AGHT+IETOhplWLP41h6xBUC+m/7v+gFVgoTG0pk5jIAa7NUtVmlGHwni76xjxsx+S3umlrFezQ54QQ==
X-Received: by 2002:a05:6e02:1ca2:b0:35e:6ae2:a4b7 with SMTP id x2-20020a056e021ca200b0035e6ae2a4b7mr941831ill.2.1705699325824;
        Fri, 19 Jan 2024 13:22:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t11-20020a92c0cb000000b003606dc5804asm5634663ilf.65.2024.01.19.13.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 13:22:05 -0800 (PST)
Message-ID: <c8f441c2-d662-43fc-9e8e-fc847428dbaa@kernel.dk>
Date: Fri, 19 Jan 2024 14:22:04 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] I/O timeouts and system freezes on Kingston A2000 NVME with
 BCACHEFS
Content-Language: en-US
To: Mia Kanashi <chad@redpilled.dev>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <54fcc150f287216593b19271f443bf13@redpilled.dev>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <54fcc150f287216593b19271f443bf13@redpilled.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/24 5:25 AM, Mia Kanashi wrote:
> This issue was originally reported here: https://github.com/koverstreet/bcachefs/issues/628
> 
> Transferring large amounts of files to the bcachefs from the btrfs
> causes I/O timeouts and freezes the whole system. This doesn't seem to
> be related to the btrfs, but rather to the heavy I/O on the drive, as
> it happens without btrfs being mounted. Transferring the files to the
> HDD, and then from it to the bcachefs on the NVME sometimes doesn't
> make the problem occur. The problem only happens on the bcachefs, not
> on btrfs or ext4. It doesn't happen on the HDD, I can't test with
> other NVME drives sadly. The behaviour when it is frozen is like this:
> all drive accesses can't process, when not cached in ram, so every app
> that is loaded in the ram, continues to function, but at the moment it
> tries to access the drive it freezes, until the drive is reset and
> those abort status messages appear in the dmesg, after that system is
> unfrozen for a moment, if you keep copying the files then the problem
> reoccurs once again.
> 
> This drive is known to have problems with the power management in the
> past:
> https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Troubleshooting
> But those problems where since fixed with kernel workarounds /
> firmware updates. This issue is may be related, perhaps bcachefs does
> something different from the other filesystems, and workarounds don't
> apply, which causes the bug to occur only on it. It may be a problem
> in the nvme subsystem, or just some edge case in the bcachefs too, who
> knows. I tried to disable ASPM and setting latency to 0 like was
> suggested, it didn't fix the problem, so I don't know. If this is
> indeed related to that specific drive it would be hard to reproduce.

From a quick look, looks like a broken drive/firmware. It is suspicious
that all failed IO is 256 blocks. You could try and limit the transfer
size and see if that helps:

# echo 64 > /sys/block/nvme0n1/queue/max_sectors_kb

Or maybe the transfer size is just a red herring, who knows. The error
code seems wonky:

> [  185.384762] nvme0n1: I/O Cmd(0x2) @ LBA 105272408, 256 blocks, I/O Error (sct 0x3 / sc 0x71)

-- 
Jens Axboe

