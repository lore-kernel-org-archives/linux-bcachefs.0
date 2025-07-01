Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1955B2F1FE2
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Jul 2025 04:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751343194; cv=none; b=b7RNazvFJl1NFgGKXcwO80y6+EEjMcqFXIiG0WZiTddfqVkf0YFq6G7i4h5/CAwWlc/dwwp1BwC3JKYElsEjrtaB71fD6++xAa5+1Rguqb8jVhctFyE63UGA88EgzacmURU+9VuJJ+4VMRkgy0SpxRNlD9mpGT3q4eH7xwn6QLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751343194; c=relaxed/simple;
	bh=LVD925RjPZQ4XoT7tCTPqvv2L4C3nUpnLe1LFZAuYGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqHONEcTBHo/8ht/kVgSC+50u1DECoJFtiJgDyqUZ2u/VyDE9ynqdFTM/DKdWfaUIeSZ79BGKpOiFm7Umz5oZxunfZZXKcijVMt2UefwsHATgmg65E/yHiVC03XZ2VS32DXSKeprYAsUOpNHzpzf1l8YN5EZdmBQQWbgr91wAr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fqNgkvFn; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fqNgkvFn"
Date: Tue, 1 Jul 2025 00:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751343188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/O3WQjH0GRtsA98A5or+zvWp9Y3C/SbFNFlpVCQe/DI=;
	b=fqNgkvFnmyK0xImyq/3+vTCreM7lrPlKaWqYy/8daNDUqbk2+tj+ngfWOTCaFI21OObDZP
	0wEf0nDFV4hJji5/DF+7XMbnFRx1q81885ojCmkUEGsJ5jUMrUxMyyrT3fEsKU8jIHetyj
	m89lmh5dB62tjzP22ob3Et+o48gATfg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Don't lock exec_update_lock
Message-ID: <e4kbig4daeu2vazkvfk5v72ithllchrb57lmh7ahwjzd5mindw@3phi77biu7oo>
References: <20250701025738.46423-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701025738.46423-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 01, 2025 at 10:57:38AM +0800, Alan Huang wrote:
> exec_update_lock is used to check permissions, no need here.

Can you explain a bit more? How thoroughly did you audit the locking?

> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/util.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 05b40debf211..7a4436fd4441 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -299,17 +299,12 @@ int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *task, unsigne
>  	if (ret)
>  		return ret;
>  
> -	if (!down_read_trylock(&task->signal->exec_update_lock))
> -		return -1;
> -
>  	do {
>  		nr_entries = stack_trace_save_tsk(task, stack->data, stack->size, skipnr + 1);
>  	} while (nr_entries == stack->size &&
>  		 !(ret = darray_make_room_gfp(stack, stack->size * 2, gfp)));
>  
>  	stack->nr = nr_entries;
> -	up_read(&task->signal->exec_update_lock);
> -
>  	return ret;
>  #else
>  	return 0;
> -- 
> 2.48.1
> 
