Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F1D2FF
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727144814; cv=none; b=EzoHTaU0GOgwRZSX0V6WKOgDs8BRKEM3kFigrjSFzU2HWWzGvtAURz5m8lxj3S8iZiiTJUtFPIyLu4NqjOhXgaNX+t2VRagBkr0E/tEvaIi/7gtP9X1/6/BVAJez8dkvrgKbxy23FrMj9NAtSMXo/pJP7J/U0wwsOS5Xzg/i/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727144814; c=relaxed/simple;
	bh=bxOnn9+awkw8sN8GOkoGhDOBqS/M5kXNIzc8Ou4SrO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/crXpSHJNWDnRcAGGt3Ptd5//T4uQrlVBbv4F/JWpkZ6WfwEqMKEw54WM+LI9RqUtl9HPDEvLyf4qBfbBdINifPHFSsgik2NWc2VkTFnsD7rZYS5lBDeQnQJpLyAnqfBqLHYExmAR+fmLycrG5TIWSYq8W4q3HU7lzJRJe0VFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mib6P9mW; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mib6P9mW"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-535be093a43so6062567e87.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727144811; x=1727749611; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rzKZqwNvBPW3pytUWUsUv/7tI4XFMgW7ZP3i5FQGL2s=;
        b=Mib6P9mW/eQzgMkGI8g7D92CP0SWshZSQQNTawKYca2pDS9erj+WsYKcm5FhNVXphJ
         LXq5U3iXGt1IFx/lVUDOoN6Qrl+uj6AGk/Db++PIG9NXsvatXOXs5R5zoFIWWI8Qxxue
         6tWrs/5lveI0f5OwFWz3Jd/U4zLkg9C/G7eTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727144811; x=1727749611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rzKZqwNvBPW3pytUWUsUv/7tI4XFMgW7ZP3i5FQGL2s=;
        b=jsi6eJguvAsERIwJN5AceFVgBaoq+Km/d5/Sft7K9D4cP1JAFmmDX1i+9KOsPkn0qr
         kzlSR/ZbfnwEO9Jd9cPiPfuRQiFU/+LNsHz+Sk6n7ry7tsn1PjUoTPoyzQ8xQxqU59gL
         1yb9ylPOdulp23uV3PSEhdypTle9LeI730dwgP6pQUIHAR/e4yiWdiZfRxX3ULvjYctO
         xkXuJqrmpLMsqhT751+LdOpWWr/ZX3xn3CIXDx7kAbQu4DVucTfFGnTvX7FPxLXKDy85
         7qIqaTQkZKfqZXx0AJaUMQCXALlToCxHVLlGz6wL+Cjq99ouCFmyv2GtPRgu7CAksIfN
         mepA==
X-Forwarded-Encrypted: i=1; AJvYcCXivhzVcBmNYY3EMpE0eqiIdYUposOcuiyq6jUKx62klRKxQB+VBCSrm7TxQin16xsk1O2kcaDW3UwDMIy4Eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjGDVPeRv+1zhYFU2mlu12bgcvc9OTvenJm+wdUtzNPzlHkcF6
	o3Kzp/5gJtsZcsjf2bs/a45WW6uHbY4gJjTW5rgAixO/ZyGF+FtGKmMwjFi0j8cjEt3lu6kbtdq
	gtACswg==
X-Google-Smtp-Source: AGHT+IGdDzFB7HxDKIoTKmq6c53sNxN8wdxnyi7T6dwFU2bXpAL/Zja6AQKkKwQLA+42FUdT7HgVOw==
X-Received: by 2002:a05:6512:3192:b0:52e:7656:a0f4 with SMTP id 2adb3069b0e04-536ac32012emr6847637e87.41.1727144810570;
        Mon, 23 Sep 2024 19:26:50 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-537a8648c3fsm60195e87.229.2024.09.23.19.26.48
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 19:26:49 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-535be093a43so6062545e87.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:26:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUbMDRKkNj0arVtmOShXcM4tIUX4bL7e6OuQNVCjK25sZrU9TI1tppay/PQm5EG361HxabWJqzqCsxSzjDgng==@vger.kernel.org
X-Received: by 2002:a05:6512:3f01:b0:52c:dfa2:5ac1 with SMTP id
 2adb3069b0e04-536ac2e51c8mr7222689e87.24.1727144808378; Mon, 23 Sep 2024
 19:26:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
 <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg> <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
In-Reply-To: <ZvIHUL+3iO3ZXtw7@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Sep 2024 19:26:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
Message-ID: <CAHk-=whbD0zwn-0RMNdgAw-8wjVJFQh4o_hGqffazAiW7DwXSQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
To: Dave Chinner <david@fromorbit.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Sept 2024 at 17:27, Dave Chinner <david@fromorbit.com> wrote:
>
> However, the problematic workload is cold cache operations where
> the dentry cache repeatedly misses. This places all the operational
> concurrency directly on the inode hash as new inodes are inserted
> into the hash. Add memory reclaim and that adds contention as it
> removes inodes from the hash on eviction.

Yeah, and then we spend all the time just adding the inodes to the
hashes, and probably fairly seldom use them. Oh well.

And I had missed the issue with PREEMPT_RT and the fact that right now
the inode hash lock is outside the inode lock, which is problematic.

So it's all a bit nasty.

But I also assume most of the bad issues end up mainly showing up on
just fairly synthetic benchmarks with ramdisks, because even with a
good SSD I suspect the IO for the cold cache would still dominate?

               Linus
