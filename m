Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F8267384
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 23:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740093772; cv=none; b=JwhXrBueCSqYjC0glZZ3y7dJ42X9u6o9NhThQ/Te1sSP/Q45qVzwMU1P8pSj1p8R9+Gir8gLmnovrCby7AuslLfXMz9N4HqCSY25aoauw2bY7ExPo80E5aO+SwuHVFte0UzbPYNIpd2KqBp5iQUxk3IfOg4rm9obSfOIhwU7tis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740093772; c=relaxed/simple;
	bh=xi8CB6l1shR+36y3uN/AUAwYc8WHx9Lty7ZTQj2LUq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/1XCNhANnROGZUqPwva6UpHFN9OLMyQKi+HqL4DZZ52cp2v9DblT3UgZbJ2tw4hbc+kTSREZ5Gq2qfXRCswS1VSZbcg65w0vbGIKgvt7Fe9NQlqYLtZOSzp+I3SxDTGD3wteD3qr1+i86Bl/9cJFXV/PoF7kgg+hkFjn/he6Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mivzqwHE; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mivzqwHE"
Date: Thu, 20 Feb 2025 18:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740093768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dGbJ3WI15/5w/qh1lbHhAgnppvZMXGv3YJoFVrrmDPU=;
	b=mivzqwHE7A/0ofjPrldQovdUN2bPRLeU7aZWJ+6DChEQRmd4IMeHYPtMLeJqEZHX8tsmIw
	zv7zqFDuVIyBV8xkXvpw3I03TC/Ky3uOGePhFoQIUYU2zaVfxLKMfIB5bSmUojZQ0Ou2L6
	0DgyuznLU3PPfFvYJ7A4Bf5d70sGNyU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	k2ci <kernel-bot@kylinos.cn>, Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] objtool: Add bch2_trans_unlocked_or_in_restart_error()
 to bcachefs noreturns
Message-ID: <uhf4menbsgtgpyrsuwsipv56xgm6kbklsqgx5p3lfxfbkv43v4@7yjp4slw5dma>
References: <20250218064230.219997-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218064230.219997-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 18, 2025 at 02:42:30PM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Fix the following objtool warning during build time:
> fs/bcachefs/btree_cache.o: warning: objtool: btree_node_lock.constprop.0() falls through to next function bch2_recalc_btree_reserve()
> fs/bcachefs/btree_update.o: warning: objtool: bch2_trans_update_get_key_cache() falls through to next function need_whiteout_for_snapshot()
> 
> bch2_trans_unlocked_or_in_restart_error() is an Obviously Correct (tm)
> panic() wrapper, add it to the list of known noreturns.
> 
> Fixes: b318882022a8 ("bcachefs: bch2_trans_verify_not_unlocked_or_in_restart()")
> Reported-by: k2ci<kernel-bot@kylinos.cn>
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>

> ---
>  tools/objtool/noreturns.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
> index b2174894f9f7..6bb7edda3094 100644
> --- a/tools/objtool/noreturns.h
> +++ b/tools/objtool/noreturns.h
> @@ -19,7 +19,7 @@ NORETURN(__x64_sys_exit_group)
>  NORETURN(arch_cpu_idle_dead)
>  NORETURN(bch2_trans_in_restart_error)
>  NORETURN(bch2_trans_restart_error)
> -NORETURN(bch2_trans_unlocked_error)
> +NORETURN(bch2_trans_unlocked_or_in_restart_error)
>  NORETURN(cpu_bringup_and_idle)
>  NORETURN(cpu_startup_entry)
>  NORETURN(do_exit)
> -- 
> 2.34.1
> 
