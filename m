Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02CD145B38
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732746096; cv=none; b=CNQRX4j8zZXm/qgSC/6kDPAimE5TLJYtu4gpSZSm10/QzrYSloQSk4otuRWhD3PGf2h/1w/VFBnWZbfgrmsvl8H9Ri+WEYiFRceq39hKAgGdJy5R7Pc7I4idkRmn6EMcfqL5uNbxfirVFWVHRi586sNldHsD28yFf17huh61Gm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732746096; c=relaxed/simple;
	bh=mh0FJ+JikUwI6SkG12v3C2Z2TqYys3hL8qLQp3cl++Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJzYuWU8wU+uyUfI1ohn4WAQodcLcUe9h5VxUK2QxSNDB5S4oB31D5Z21lGw4VrcWfiPFhYToPM6I3S7x+npASlEy5W+A894i0gGT6Wt2eXnbAp0pJXqwe6Ec6QKAyZpAsnoxADg2AgM+zZszcpDTO/ONj0XSF0t6rPJQpmAXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KLC8Sd8X; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KLC8Sd8X"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3ea47869282so597915b6e.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 14:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732746093; x=1733350893; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4WYvj72NAPpEN1QPhDkrCQ/M59C4W8yTCGMMs+JhlcA=;
        b=KLC8Sd8XCWpqKEeXbnJAKFAYsrL0q+0EmLzVVKy3XF1/kZ1jHYgwh6JFPhMcc8fJd2
         /Mpj6N3FIxPsCgLpyFimXgrcTA8OojnQxrBYRxmHn9SQmWG3VEyQHcVgH9pZSMUTpH2e
         6lY+QMd9bgkFkF79lLpTC1dqB6qFWO6EvxEC1BlwfEr32HJdmJ4PkzvzUGZpI1A/2oJt
         Iewgd/bglRFT29r9ERnF/qhzVvD6ofqjgGSnireVoeRV5vuMYmC/3h0sycRWFS7xxduN
         +STfEH6eiFquKPoyrWpjkODmyc5oM7UdnEfuxzmZtmF5kDT1dHCt+J/ocE8C4Il1oIYQ
         Oajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732746093; x=1733350893;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4WYvj72NAPpEN1QPhDkrCQ/M59C4W8yTCGMMs+JhlcA=;
        b=R4xP35z5KXekaj8HdGMctUdRSf/3FgSCUNIIeVbQMxOq3Mvi6mqpZSmMTDL32bq6aS
         X3sOrA5SGytY6++ZaudxMd1HsPeVbg4AYoo8W+qsoa64Rwg3YeZCma6vnulFn73Kz/nu
         JaoIu7w62+OKDk7nXovBx2OyHvP4a+mx661MYPVSt49bc60MlwNMKV3zsHaZqv8G3O9S
         Hw9AvjTya9cduZN/nz6pdcohgk33erHmsvR6qjvONgXG/xEn3NHzEtZi5mTFRALBYREV
         c5LLHfRPmNEtNp/ylAQVS+0Mjs43i70+/SUQ/l5R55WlrBaMe+dUB2VlZ4Hk9w84hd9e
         5HLA==
X-Gm-Message-State: AOJu0YzrqEqGAfR7bm2ir3TOid1T6hKVuN2LHcB80mgZW+OoeOEYIWMR
	apFn9aiWNMAzjshECspODMgFzMwYkH8ZuNoZfvwEJCOJHsTI0HRMEQsV6y8z0hI=
X-Gm-Gg: ASbGncuT3aKiitGdCicCGU2qzHdt06YffT287OW9S145MdoqmJqIHDY8HOXE4HGGieq
	9NWQyLU+vy+6JOMtdzNk356uunP6EQXSrvPVvzu+j0LobJOWUm6yG+G+Kv2LNfZv8RDEwNchVSw
	WdA3zF3nWjpLimqzxkTwgHIU+47v0JwhVPX4zbuZvq7C+evCpFiQ4G+ZeOVGofmpNbJza4Tzvfy
	opUNptLRZseJ2vnRyTW0YVFw/tMrt17uyGIEv5zCr/EIQ==
X-Google-Smtp-Source: AGHT+IGIb12Sfp8HAtx+F7AK3WP3dqW2IkLDFoiaoO903iSAXwEmX28lGh1jJAsjG4P7ChOVTLx+xQ==
X-Received: by 2002:a05:6808:3094:b0:3e7:c4ca:9d19 with SMTP id 5614622812f47-3ea814cf33amr637581b6e.15.1732746092852;
        Wed, 27 Nov 2024 14:21:32 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ea860df6d2sm7223b6e.25.2024.11.27.14.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 14:21:32 -0800 (PST)
Message-ID: <6ada0aa7-a260-4c0b-b80c-6360b2ea878f@kernel.dk>
Date: Wed, 27 Nov 2024 15:21:31 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: dio write: Take ref on mm_struct when using
 asynchronously
To: Kent Overstreet <kent.overstreet@linux.dev>, Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org
References: <20241127213649.1615078-1-kent.overstreet@linux.dev>
 <CAG48ez2CXiAieL5-htj86p0cwVOoD5S5Pq=-E+Sf03ifzfYqdQ@mail.gmail.com>
 <xrjd4otiojkszczc2u2buwbnb6sw2z7u2p66evivsgxrpkidxq@55yc6lbcnhh2>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <xrjd4otiojkszczc2u2buwbnb6sw2z7u2p66evivsgxrpkidxq@55yc6lbcnhh2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 3:11 PM, Kent Overstreet wrote:
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index 2089c36b5866..8da0577411e8 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -226,6 +226,7 @@ struct dio_write {
>  	struct mm_struct		*mm;
>  	const struct iovec		*iov;
>  	unsigned			loop:1,
> +					have_mm_ref:1,
>  					extending:1,
>  					sync:1,
>  					flush:1;
> @@ -390,6 +391,9 @@ static __always_inline long bch2_dio_write_done(struct dio_write *dio)
>  
>  	kfree(dio->iov);
>  
> +	if (dio->have_mm_ref)
> +		mmdrop(dio->mm);
> +
>  	ret = dio->op.error ?: ((long) dio->written << 9);
>  	bio_put(&dio->op.wbio.bio);
>  
> @@ -529,9 +533,24 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
>  
>  		if (unlikely(dio->iter.count) &&
>  		    !dio->sync &&
> -		    !dio->loop &&
> -		    bch2_dio_write_copy_iov(dio))
> -			dio->sync = sync = true;
> +		    !dio->loop) {
> +			/*
> +			 * Rest of write will be submitted asynchronously -
> +			 * unless copying the iov fails:
> +			 */
> +			if (likely(!bch2_dio_write_copy_iov(dio))) {
> +				/*
> +				 * aio guarantees that mm_struct outlives the
> +				 * request, but io_uring does not
> +				 */
> +				if (dio->mm) {
> +					mmgrab(dio->mm);
> +					dio->have_mm_ref = true;
> +				}
> +			} else {
> +				dio->sync = sync = true;
> +			}
> +		}
>  
>  		dio->loop = true;
>  		closure_call(&dio->op.cl, bch2_write, NULL, NULL);
> @@ -559,15 +578,25 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
>  
>  static noinline __cold void bch2_dio_write_continue(struct dio_write *dio)
>  {
> -	struct mm_struct *mm = dio->mm;
> +	struct mm_struct *mm = dio->have_mm_ref ? dio->mm: NULL;
>  
>  	bio_reset(&dio->op.wbio.bio, NULL, REQ_OP_WRITE);
>  
> -	if (mm)
> +	if (mm) {
> +		if (unlikely(!mmget_not_zero(mm))) {
> +			/* process exited */
> +			dio->op.error = -ESRCH;
> +			bch2_dio_write_done(dio);
> +			return;
> +		}
> +
>  		kthread_use_mm(mm);
> +	}
>  	bch2_dio_write_loop(dio);
> -	if (mm)
> +	if (mm) {
> +		mmput(mm);
>  		kthread_unuse_mm(mm);
> +	}
>  }
>  
>  static void bch2_dio_write_loop_async(struct bch_write_op *op)

Based on a quick look, this one looks good to me.

-- 
Jens Axboe
