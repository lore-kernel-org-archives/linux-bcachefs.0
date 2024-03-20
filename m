Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB833062
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710970625; cv=none; b=YT1+evOvvyJGnRm1uqw3vbFCYkwZDlDyG2WwM/xbAJYEVv7Di2LHrYmIm53n1oDYf13eIO0L4rf6DTJ/s4PhrjFGpyxLbSshesGAGnhvOqm+cWMu5P2OYKVKmb8AQuCWhmi0R1n/7Tot4/VdrlZjcwdDUCF7InyQPN1R7vlaFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710970625; c=relaxed/simple;
	bh=lk7aQyX6ZKYD8DGcsUW3OSf1EDVaB0iBT6wMAEUmdiQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ea/oEPvwWdHomN4+Oxz7HlsKDtqumN9uy34Ta/WGUO1+mJx3R+FUwOz2oNYBPgqHKHDXRsvglJSePXyKB7CYuRLh9TiHoUTHzwUM+p9PVPPbZVjRURoTfjglO3gK8t83ZW7pWolgBxqUn7fJTQsRNmCvHC0VKNu78xAAIVAvj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoKZsYHp; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoKZsYHp"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-430c32c04c7so2211721cf.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 14:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710970623; x=1711575423; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7f3OJG+sIAatBITf0/0yxDo/7UCXkd+0KskGpiXx3NI=;
        b=LoKZsYHpy7Vboe2w8r/L6SGTYMtjfUoE0tiBcq+PJfoPWLfa7WZ+GAdHLCOjzMnbl9
         HDYVbeU3o+dS4xHipHZQgHcCz5eMLPGXHieAA9pk4rheKqqk3YWcufSnlLM2UzN8EqWX
         C08atYKUgUX+QMlmvKtTYWnwicEjogaFiV719zoqlHSctP7k0Rx92bFwm9vFbJ4aSXaF
         janZV7ppo8fDWeirG0GPlPhxmkzVjFRmur2WEnIcr3B621Kej2iX89a0q4CcsUBg22Si
         jokFPA7yOMdMDejICWeUuXTrrmF0BsRq2y9Dm2Q9GMvwYYOdbkkyQYPPyI9M0/MAgrst
         WsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710970623; x=1711575423;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7f3OJG+sIAatBITf0/0yxDo/7UCXkd+0KskGpiXx3NI=;
        b=nMx5RLjgLCww2XWL3DayFcwPiGmV9iVnBsOk27SGDFFLTrJbYYq3oYrFks9yg9Dr2e
         xuSv/LDqQgJNOl/yq0zoGBGviLmgQP5tk86moqIQnQm3DowiqvLtVNhU9Rd7iBhqPMnR
         FTUXobjIkiY/y3Lbqqhq8umLzEBb84a4I8LTzSO4BcdhOVSHkRPTxGdVYpx/h7q442OJ
         fv3r9ktezZNtPHI6o73m5s7r2qXLYR6KzL2bbZNCLeYjyjm18gofUi7+l6Pf3hXHoEmq
         YoXyfPy1DnZalFYbKe1caBjz2FfMZ4EhCVi2LU3vtrXJzVP0XTzDmS7VN6U2NZTAJSzz
         otOw==
X-Gm-Message-State: AOJu0YxPQfrIlj5ovjs3GXvHC8rSN3QCwcHgx5vuW+b08Ijf2tf4HvXe
	g3RaBuzspWjv9XBnohGhUBL7Y19Tmtqi5fgAzrUXLDuboP60qiv1
X-Google-Smtp-Source: AGHT+IFe6FRswK1PK+7QB0xSx3iX/rDj/bkx1NQsn+6vAo42LaikTto/+KVlDyIUZfiCRoLZ2+80uQ==
X-Received: by 2002:a05:622a:489:b0:42e:f47f:7fe7 with SMTP id p9-20020a05622a048900b0042ef47f7fe7mr21401411qtx.37.1710970623298;
        Wed, 20 Mar 2024 14:37:03 -0700 (PDT)
Received: from [10.193.190.170] (mobile-130-126-255-72.near.illinois.edu. [130.126.255.72])
        by smtp.gmail.com with ESMTPSA id dn17-20020a05622a471100b0042ee2bda028sm7510370qtb.54.2024.03.20.14.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 14:37:03 -0700 (PDT)
Message-ID: <080de8c1-497c-45aa-a5a0-10dba5319c64@gmail.com>
Date: Wed, 20 Mar 2024 16:37:02 -0500
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: kent.overstreet@linux.dev, bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org, chenyuan0y@gmail.com
From: Zijie Zhao <zzjas98@gmail.com>
Subject: [fs/bcachefs] Question about memory allocation in btree_paths_realloc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear BCACHEFS maintainers,

We encountered an unusual usage of kzalloc in btree_paths_realloc 
while performing a static analysis for kernel code.


https://elixir.bootlin.com/linux/latest/source/fs/bcachefs/btree_iter.c#L1523

```
static noinline void btree_paths_realloc(struct btree_trans *trans)
{
	unsigned nr = trans->nr_paths * 2;

	void *p = kzalloc(BITS_TO_LONGS(nr) * sizeof(unsigned long) +
			  sizeof(struct btree_trans_paths) +
			  nr * sizeof(struct btree_path) +
			  nr * sizeof(btree_path_idx_t) + 8 +
			  nr * sizeof(struct btree_insert_entry), GFP_KERNEL|__GFP_NOFAIL);

	unsigned long *paths_allocated = p;
	memcpy(paths_allocated, trans->paths_allocated, 
BITS_TO_LONGS(trans->nr_paths) * sizeof(unsigned long));
	...
}
```

Here kzalloc might return NULL in case of out-of-memory, making 
memcpy(NULL,...) to have undefined behavior. Would a NULL check be 
needed here?

Please let us know if we missed any key information or assumption! We 
appreciate your time!


Best,
Zijie
