Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59263383B2
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 03:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724385366; cv=none; b=sVMb4bhdDw27ratdZkyb/LB63gU0Uqw4GZuIHePtZktFPM0h7thE1uUJiU4bownytTawPmKKI8wiaWPEmzuTZfz5MGrMMKciGwNiTDy9WjZyY8fvsyovVF1ZxIJBUxjVMqXXKFahRHDZz7dkzWopzh5J44/2h0vm8itI6noSN4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724385366; c=relaxed/simple;
	bh=mIsEUyW4k8HB4WSZEdflm6tCGdhZrEsZbUddreQfyZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtU74/LwgOk0L8JYQQzoK+GO6oUIbM71obzv3ifJvEdSNgiYfpJRXmmBhutjgRhgXQPslHtGzOuysBWlwpLzFpISwEJlKQSBft+Yp+IEuRR511s5iJ/tFN8Hqb4TBYxz/NuHQKtZlDuSL3qu+2gPFbByTEKnOR6RoYf5ozK2C7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JN034MPT; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JN034MPT"
Date: Thu, 22 Aug 2024 23:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724385360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PkEzWlxaq7zulouscVxlD9YgBdgJUj/+c8bwDtryew4=;
	b=JN034MPT0Lw4bDbaYGnG5cHw338KwmDsJNQX9bentglvZqNRb0tq97BmC7Z1a6VtjZAh3k
	nqJSfAzC5s6mO24yUPht46OEZiDdTJZ0rU2ZN3hZqxehhqVyoDdVm75NRn8gDHEJEqbkz/
	sQi92fo6IB7YhYiWORjkx1KOqcAitR4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Remove the handling of bch2_trans_iter_exit()
 in __bch2_bkey_get_iter()
Message-ID: <f2uohiy7zaaiv33r7xhofaprv6tk5mumvzzf7plvagdtavrini@3orfgcehid7q>
References: <20240823031955.202795-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823031955.202795-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 23, 2024 at 11:19:55AM GMT, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> - Reduces bkey_err() calls.
> - Avoid redundant calls to bch2_trans_iter_exit() in some functions.

no, a function that returns an error should clean up after itself
