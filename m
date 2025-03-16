Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77810944E
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742146858; cv=none; b=UKLoW6Xj231SkXVgACixRWUDQxAxqqxHyvBAQn3Wa/r22jN/I4GjGq2ptu2Bo5qUPCSnE3lFwxeSPwuTxhvVgv+N4K88zFuUlEh0nrM6OOAToKFaUEVETJMLcekUAimvXwS4P41t5Dtd69O2JVmqNDfADzkcojlTRznUgIdlkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742146858; c=relaxed/simple;
	bh=aMP3QDE8gN9YhGFi+nD0jaiqG7QVdlmbqAKc8tFdUgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ko0gDbJ4hvUXgl2l9Dw6scAtEYhkmkIsLMz4cdcbYkqxNEvezFZts+o0hfJM5PhLhccZ0F35QjsVvcfTtqLwyEpxVidOdwnGhsX3AJpWMe4Qgg3VlR6M9StJGsNX+kkrsUnUqjP3o8ikCMxzHPhQbmOpERpwoZeG6Ch/1pLimfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uFdTuJ1g; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uFdTuJ1g"
Date: Sun, 16 Mar 2025 13:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742146854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/HD0mo0/lX/8RsFY8vIJht6pZvIVsZ/yZBXHjzilPJk=;
	b=uFdTuJ1govSDH84qzwFXs/3Ghd4JvTQFXVTjKsd7GqQ4HVOWRVj0eQAjF6vpOCU/LFoh33
	NP8dKRWM997odFr+dJXxSCI0xFeJxQnIg57lkv6XIk29CcWNaUJSPK1emuZXRC7FkfAqLl
	+y0GQYkqH6Y+CRziuFFlEPnmHkc2yAE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove unnecessary softdeps on crc32c and crc64
Message-ID: <fab4x27fwuq6pylyx2sspo2wdyylyeywp4bf6ki4cluh63p22k@eh2hxqnkayeo>
References: <20250316030319.92651-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316030319.92651-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 08:03:19PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since bcachefs does not access crc32c and crc64 through the crypto API,
> there is no need to use module softdeps to ensure they are loaded.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied
> ---
>  fs/bcachefs/super.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 78a8daa80fcce..6de3a5751561e 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -73,12 +73,10 @@
>  #include <crypto/hash.h>
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
>  MODULE_DESCRIPTION("bcachefs filesystem");
> -MODULE_SOFTDEP("pre: crc32c");
> -MODULE_SOFTDEP("pre: crc64");
>  MODULE_SOFTDEP("pre: sha256");
>  MODULE_SOFTDEP("pre: chacha20");
>  MODULE_SOFTDEP("pre: poly1305");
>  MODULE_SOFTDEP("pre: xxhash");
>  
> 
> base-commit: da920b7df701770e006928053672147075587fb2
> -- 
> 2.49.0
> 
