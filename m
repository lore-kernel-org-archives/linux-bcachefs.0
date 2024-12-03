Received: from rivercloud.ext.redscript.org (rivercloud.ext.redscript.org [181.214.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8013813F43A
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Dec 2024 06:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=181.214.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733206407; cv=none; b=t3h6UfCqhE8WW+1FaoT9IKlkvKIjtY7o73UVR/1xaqKUNa2t6GvtWQXtH4V80HPTvivJP8zAe7N4Z9kjm19NpGJD4aYmy9pmx4KWaRQBUNSl4T5jDK37G3RpBM6ApK/ksOj65BqlLXEz40nsU/dfHOX0cI/+40TGGftu9C9ZpsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733206407; c=relaxed/simple;
	bh=0N8NtPsJfMNbU6P0QcZNzteIiC69tm3Bk7HDIb2D9nw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KY9pIPtfMPfjkl6s5F38Y1J2eNp8qzJ8VzFizlYy3qyeP1heB91OvUIC385dVImnaJGJzcw9K39ylLBUC2c429oHYyKTE2BMmJdBjqbsGea2m/2clk4A1Dtlvvh/Uo+dv+QogxWhrR+k5GAJpzz+xXKFw77VeCVldDOaWRRjDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redscript.org; spf=pass smtp.mailfrom=redscript.org; dkim=permerror (0-bit key) header.d=redscript.org header.i=@redscript.org header.b=YmYvAQIf; dkim=pass (1024-bit key) header.d=redscript.org header.i=@redscript.org header.b=lVus2TFf; arc=none smtp.client-ip=181.214.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redscript.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redscript.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=redscript.org header.i=@redscript.org header.b="YmYvAQIf";
	dkim=pass (1024-bit key) header.d=redscript.org header.i=@redscript.org header.b="lVus2TFf"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=redscript.org;
	s=mail2-ed25519-2024; t=1733205994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww+92E3Vs/yf6o1TR71WV7BDnpS35SmTQRkvttBan5o=;
	b=YmYvAQIf41cohrGT9H49khF9u/QbzQdBpJQRHjZAInGXlBrFIc/igBaHykh6+WDF2xWhNo
	KLEvGENPWJTFWSBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redscript.org;
	s=mail2-rsa-2024; t=1733205994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ww+92E3Vs/yf6o1TR71WV7BDnpS35SmTQRkvttBan5o=;
	b=lVus2TFf5sXsem8CUb/cZPWERZmFn6ZffLV59aXqluGXo1CBuxrPz6qNfPAd2CUfliHJKF
	6gNc9GAW+CfYb0qt80ZHocjl6teICsQ5PTW6owSe2ecnCoWEoZ7hlrGxp5O7YxDvyDG/HK
	Y/vqxI6u54NU+ChihQJbcruWd1uJ7Eg=
Received: 
	by rivercloud.ext.redscript.org (OpenSMTPD) with ESMTPSA id ca24d00f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 3 Dec 2024 06:06:34 +0000 (UTC)
Message-ID: <eaa30a2b-3d96-4249-983b-79cb0348d16d@redscript.org>
Date: Tue, 3 Dec 2024 10:06:29 +0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Allocator now directly wakes up copygc when
 necessary
From: Ahmad Draidi <a.r.draidi@redscript.org>
To: linux-bcachefs@vger.kernel.org
Cc: syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com
References: <20241019215605.160125-1-kent.overstreet@linux.dev>
 <92dce846-d110-4c97-afd1-0b198c1fdf4d@redscript.org>
Content-Language: en-US
In-Reply-To: <92dce846-d110-4c97-afd1-0b198c1fdf4d@redscript.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,


On 10/24/24 07:46, Ahmad Draidi wrote:
> Greetings,
>
>
> On 10/20/24 01:56, Kent Overstreet wrote:
>> copygc tries to wait in a way that balances waiting for work to
>> accumulate with running before we run out of free space - but for a
>> variety of reasons (multiple devices, io clock slop, the vagaries of
>> fragmentation) this isn't completely reliable.
>>
>> So to avoid getting stuck, add direct wakeups from the allocator to the
>> copygc thread when we start to notice we're low on free buckets.
>
> Since I switched to 6.11.x from 6.10.x, I've had "Allocator stuck? 
> Waited for 30 seconds" messages and I/O would stop to the FS. No 
> timeout on read, for example, but it just stops for hours, until I 
> reboot. I'm able to quickly and reliably trigger this with my workload.
>
>
> I applied this patch on top of 6.11.4 but can still see "Allocator 
> stuck" in dmesg. I see the following before and after the patch:-
>
> "BUG: unable to handle page fault for address: fffffffffffff81b
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page"
>
> ...
>
> "RIP: 0010:bch2_btree_path_peek_slot+0x64/0x210 [bcachefs]"
>
>
> A longer log snippet of "allocator stuck" and the above are at: 
> https://pastebin.com/ptuzaryi

Just a quick update for anyone reading this. The issue is solved for me 
after upgrading to 6.12.1.


>
>
> I did fsck after FS got stuck, and errors were found and fixed, but 
> issue happens again, before and after the patch.
>
> Some info that might be needed: I'm using ECC RAM, 2x SAS SSDs, 2x 
> SATA HDDs, LUKS, and the following opts:
>
> starting version 1.12: rebalance_work_acct_fix 
> opts=metadata_replicas=2,data_replicas=2,metadata_replicas_required=2,data_replicas_required=2,
>
> metadata_checksum=xxhash,data_checksum=xxhash,compression=lz4,background_compression=gzip,metadata_target=ssd,foreground_target=ssd, 
>
>
> background_target=hdd,promote_target=ssd
>
>
> Let me know if I can help.
>
>
> Thanks!
>
> Ahmad
>
>
