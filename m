Received: from msa.smtpout.orange.fr (smtp-71.smtpout.orange.fr [80.12.242.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB16212B93;
	Wed, 31 Jul 2024 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444479; cv=none; b=U8JbLwT70ZV5btoiQQwEkZC1HJ+TdahzxiHnj2mP072ut5O08rtzIBzzINsvzDesuTZgMK6yv7lVTLkCrMOBc3BMH+U9W2sXylJWRvCqFEEhKB671e7ILNy9cXD5HmxtIrlzFNmu0NpIJLzW6l4+l226rjOKF3t5/e+7UgPmM6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444479; c=relaxed/simple;
	bh=4uHbXnCqyeN/PPauYKzp7cffjEDp+YQtq2y28ilcGrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVPuw+GgyXjloPgfEuifdIoNPkGq5zR8D4ahAeNJlyLLYkxLTlCeDjlWzCx+l3As+BcA2X00Vcv68NwEVLnxzDSJl4cT6niVPG1mfHGMtD9eHh3+cloZSAdNTh+YOq95fweN0th03LdyjRbCBR9tIlyMhpKWjkosHCtBX4xrHDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=qBAIupNA; arc=none smtp.client-ip=80.12.242.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="qBAIupNA"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id ZCTHs891oXE9oZCTIs6MVz; Wed, 31 Jul 2024 18:46:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1722444401;
	bh=yDOoaBlcKMGnayNc55dFVomZrlZLMC5XeCJcRsJ0XMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=qBAIupNAyBWoL61aEoHQnYf+EGDET3s/DBDqAhfDp1BL+8gkbfn0Y6JantU7yy49u
	 ftFTrLHbchlKz2t8eB2dahIfNx8JEk7wEd8uog00ym28RVr+9kuDETdbEqo4hCVGUp
	 QTANMVFVFxXEe/F5TKHO7sO8atKYX1EFo7YBXVqilHQqEWfmy3bHE3HqmMFmNyRgrx
	 rK9MMCtrmRj67+zZTPzi8jY5VfmDvRrylr9FMwpiDlt9FSRdI/VDNlbxOq4ta2Q/br
	 LqypcfcUln8UVOPy92pin5hfzqzjWZI7SqCLvEcYQCvliImuj78zR0TXQg6959JlIz
	 kFszq2hqAG4KA==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Wed, 31 Jul 2024 18:46:41 +0200
X-ME-IP: 90.11.132.44
Message-ID: <4f8f1e94-2d5f-46e9-8860-af54f522dc94@wanadoo.fr>
Date: Wed, 31 Jul 2024 18:46:39 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] bcachefs: Kill opts.buckets_nouse
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <31ed13c7-7a14-4693-a9cc-fdb078a3c412@stanley.mountain>
 <x3nici64pxcqqhcngceu2nbtemc64bbirss7fbaeuxk7orjwuc@oxixb5xee5n2>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <x3nici64pxcqqhcngceu2nbtemc64bbirss7fbaeuxk7orjwuc@oxixb5xee5n2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 31/07/2024 à 00:23, Kent Overstreet a écrit :
> On Tue, Jul 30, 2024 at 02:45:17PM GMT, Dan Carpenter wrote:
>> Hello Kent Overstreet,
>>
>> Commit ffcbec607613 ("bcachefs: Kill opts.buckets_nouse") from Apr 6,
>> 2024 (linux-next), leads to the following Smatch static checker
>> warning:
>>
>> 	fs/bcachefs/super.c:1202 bch2_dev_free()
>> 	warn: 'ca->buckets_nouse' double freed
> 
> yup, that's a bug
> 
> -- >8 --
> Subject: [PATCH] bcachefs: Fix double free of ca->buckets_nouse
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: ffcbec6076 ("bcachefs: Kill opts.buckets_nouse")
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 0542953a7a..6d0ce3d734 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -1195,7 +1195,6 @@ static void bch2_dev_free(struct bch_dev *ca)
>   	if (ca->kobj.state_in_sysfs)
>   		kobject_del(&ca->kobj);
>   
> -	kfree(ca->buckets_nouse);

Hi,

unrelated, but apparently this should also have been kvfree().

Dan, do you already have a check for such cases where kvfree() or 
kfree() are called when the other one should be used instead?

CJ

>   	bch2_free_super(&ca->disk_sb);
>   	bch2_dev_allocator_background_exit(ca);
>   	bch2_dev_journal_exit(ca);
> 
> 

