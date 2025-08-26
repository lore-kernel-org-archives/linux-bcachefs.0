Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3302877F0;
	Tue, 26 Aug 2025 05:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756184707; cv=none; b=OnboJrloqq5GDk3IbYa3vjqRxsMdtExbAKjpKpqb+xy3OgGg/UZVzEjYaiyC7sH1BJC5HMcNqN87v7BHiIO3OzxgzVNTqv0yR6/rjnqPxzxnzctg/jk+9xOBOr84lZynGYwrTkWrvRcrjNVw2nL6LYgZWD9wtQwfVif9Js6yBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756184707; c=relaxed/simple;
	bh=sjPa3h9TrkiaHGQzOZxLFO+BsFASSkV8qIzabkQ/DC0=;
	h=From:Message-ID:Date:MIME-Version:Subject:References:To:Cc:
	 In-Reply-To:Content-Type; b=eEltmm/16RjBJv0CoOjl4MH6txLudeYuuCUZjscHAmJ6JqQ5ClFVk3LjiEhkAcsoeR+xSd5M2QG8WPZmjy2HpqHrvjJwSwazOuMne7+lfM5T8VwMCpJu5Rbxhu0R8n+mDOSMThBoROU+2xkSjzkOS/EpnTKGfk+3iY7Da2iWZKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N37OJSoC; arc=none smtp.client-ip=209.85.215.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N37OJSoC"
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-b4c1aefa8deso1135333a12.0;
        Mon, 25 Aug 2025 22:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756184705; x=1756789505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PSlMvktid+Ddpqcdw6wG+tzjVJM72KntDG+UV0J9J3U=;
        b=N37OJSoCtH4ekhGMyDwdd++JzjA1fLNSVlRp7TyvGDlU9QM1QoaIN90uNVK7Y0ItLY
         CIxxBhUccm6oQ9Hv7NzFyT2UIBIUQNrL8S7evirEXCaeBNxW7HckQE+JVJvFRCU0XTT2
         o2QNEcm00wYmJxzTrdxtK2UBjdVLBvx2NctdmtDzsVSwmHpN0HYDspW1wJIp640BhAXg
         EUhSHofNNXyxK81LSLFJlz03Xc93VT7+2p8Hpn/tH/WLP9Sor6rmIRB2SeKoFHsxEsvO
         Xy7Jbpli4rlhWb/WC2e4O5J/SlYj+A7Plz/A70o+m5c9q3yfmajS35uEtyZCh9VUyZtU
         VHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756184705; x=1756789505;
        h=content-transfer-encoding:in-reply-to:cc:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSlMvktid+Ddpqcdw6wG+tzjVJM72KntDG+UV0J9J3U=;
        b=j9U/HvysRK0Z17ialvnpc8Cq7bScsSjBieUSttCUj/4K43A3n+aiiopmiSrJRgvHa+
         54gZm0f+GARXTeSbwiSeQoSOL1qtMsYCD4BKxE5V26zh7/024M1pr25mOVQEMtGr4n2b
         0TuKSzWgoLTl3G8M8kxpHtyrKPQ0ShdqNNnypIcxdYTgQaerVQMX5VlryDxSUYZZFulN
         d2nZ1WuDX5mfL49wP413dLicKVxG3FmjJ5uXRjxx+LG/NGbBETI9e8Yr0MwSmP1rxnyT
         TbBQNH4Q1sEGOQwEjB52QP/6iAdbWWVSXaU5o/DlXyxDpbKNmEvSshL1EJ7OySNgRFzB
         WaKg==
X-Forwarded-Encrypted: i=1; AJvYcCUImjRZzX8MzL5kBiXvTcWVaT49tJ8waaKqJFnkb14cW9l34Pu5kjgJS/ZGjesOLzMH6dc2ZWkPmyHk@vger.kernel.org, AJvYcCUQ2i4K+Ir+Iznt38HBZbCB5yJo3CnZtPua982eROJ4KwPK2DMYqpDkq1zreQsIGlmH/o0htThCTmMA/Wow@vger.kernel.org, AJvYcCXmIsZARxlGZBggMzV3+mscU3Fh5IXp5rp0Hw/nA2X4yFQgFEXPkprZHAw/HHToxjQ0ZbFuGw7sm+1qSept9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxufGT+8SEiy9MeO/50Vn2tqPPk4uBX+B7FAv4SoTb1pKABcQ7W
	Ngq+SZg5KlAX4LzPKnSH+e282K9yLfTtaS4LJZMTfRT6J1OIAIP1KJvxRF8SWy+K
X-Gm-Gg: ASbGncu4aWXVcNwZmREkVVh1lwoJ4d8c327qHuhDBl/01gKaKQudBWI2m8mInWq5eFS
	GJu3sLcnfT4OuDxJw169SqRak5ytetvX62IxTREWudFO/PwTpNsgC1ECmA4FLwqb6zx0um7leRM
	wRbDFirwo3eKkjl8CQ4RQEhRqfs5gUTZWHnw+FvF1TuGX46am7tHH7LsuhP0WjcZ74lbF2h3lyB
	4VQVS2MsjvCqjbbIwJ18a9TcIvtDWWeVDDJVRM42BJlAjXiM51USSHgFpGrAP2jf6SqzgCDSdGn
	Pxr00uYzoGM4FuZTl968NTDwQsPFWCnVx59WuqnvZXFDj9LBoKwy47sowjmC1Rqn0SU5lPXcU+C
	S2SCzB7DCxSqfWeHd166LpCDIVcwqvyTjFU5QBiaoKMfJgJzSd3Bm2B5y4VpqX+HKfOR+moSOhi
	05LNGgESMgPylLPELlzI2VAQtrbclqKc93DGc=
X-Google-Smtp-Source: AGHT+IE+CI33EYvWPmjh76db7GEbOlzCZ3TNPUv7S7MZ0gyiLs803+z7prqzDp+S/abVNxbhyIEiUw==
X-Received: by 2002:a17:902:cf4c:b0:246:7d4c:9f90 with SMTP id d9443c01a7336-2467d4ca180mr151892825ad.6.1756184704691;
        Mon, 25 Aug 2025 22:05:04 -0700 (PDT)
Received: from ?IPV6:2401:4900:1cb5:c77c:a6b5:e4a3:1826:1f25? ([2401:4900:1cb5:c77c:a6b5:e4a3:1826:1f25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466885ed72sm83555175ad.92.2025.08.25.22.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 22:05:03 -0700 (PDT)
From: Sahil <chandna.linuxkernel@gmail.com>
X-Google-Original-From: Sahil <chandna.sahil@gmail.com>
Message-ID: <87801a1c-c11b-4615-a225-871be2ad2ae5@gmail.com>
Date: Tue, 26 Aug 2025 10:35:00 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] docs: bcachefs: fix typo in idle_work documentation
Content-Language: en-US
References: <1055aa42-248a-4d14-8ae6-dc97878e33e7@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: corbet@lwn.net, rdunlap@infradead.org, linux-bcachefs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1055aa42-248a-4d14-8ae6-dc97878e33e7@gmail.com>
X-Forwarded-Message-Id: <1055aa42-248a-4d14-8ae6-dc97878e33e7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/08/25 21:38, Kent Overstreet wrote:
> On Sat, Aug 23, 2025 at 05:05:33PM +0530, Sahil wrote:
>> Fix minor spelling mistake in idle_work:
>>
>> - heirarchy -> hierarchy
>>
>> Changes in v2:
>> - Dropped cgroup, idle changes (already being fixed)
>> - Dropped xfs changes (already fixed)
>> - Only keep bcachefs doc fix
>>
>> Link: https://lore.kernel.org/linux-doc/23de3jgp44vih5g6hjgc2ji6momi5t3w7rfkm5mgtajicbbg7a@7r5hgt5e7eir/
>> Based on v6.17-rc2.
> 
> please rebase here:
> https://evilpiepirate.org/git/bcachefs.git
Thanks Kent, I checked the tree and I will drop this patch since this 
typo is already fixed with - 
https://lore.kernel.org/all/a2dvoh6sbqvxbueljd6xbbwytkydu6zgdvzkootojdgddvj4ke@trypmesssyiw/ 

> 
>>
>> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Sahil Chandna <chandna.linuxkernel@gmail.com>
>> ---
>> Documentation/filesystems/bcachefs/future/idle_work.rst | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst
>> b/Documentation/filesystems/bcachefs/future/idle_work.rst
>> index 59a332509dcd..f1202113dde0 100644
>> --- a/Documentation/filesystems/bcachefs/future/idle_work.rst
>> +++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
>> @@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want to be
>> dribbling out
>> background work while the system should be idle.
>> The complicating factor is that there are a number of background tasks,
>> which
>> -form a heirarchy (or a digraph, depending on how you divide it up) - one
>> +form a hierarchy (or a digraph, depending on how you divide it up) - one
>> background task may generate work for another.
>> -Thus proper idle detection needs to model this heirarchy.
>> +Thus proper idle detection needs to model this hierarchy.
>> - Foreground writes
>> - Page cache writeback
>> @@ -51,7 +51,7 @@ IDLE REGIME
>> When the system becomes idle, we should start flushing our pending work
>> quicker so the system can go to sleep.
>> -Note that the definition of "idle" depends on where in the heirarchy a task
>> +Note that the definition of "idle" depends on where in the hierarchy a task
>> is - a task should start flushing work more quickly when the task above it
>> has
>> stopped generating new work.
>>
>> -- 
>> 2.34.1
>>

