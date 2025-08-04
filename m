Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDA21C18C
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754327504; cv=none; b=J6hlrvQq6fHQ9IaiOZtELshLuf43y6GrXq2jjGReXFU5W5djjtLXXF9PbgDfQKs4JA2JAU4RUZjAg4AeaCma3RdrFQ4YHmrED4vRruEzrmYydvWean7Zp0qxh86Gu0CE9xLvTNj924EUFWEXJ70mzL1utFn8sUjA1K2OKH8nJZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754327504; c=relaxed/simple;
	bh=7u489nAL/j0gzS9b6O14mHto/j3HnlCLO2oJBBI7KWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8QwrIlBeROAVZhP9JDrgYRnFGYoOAGftsPpGeCQjjv0ZLYK1Fn/QKJRprGlY3VERH8TWwEOgfjhFz+ZPF4Bb/iGdkvju0p+h8/yxpoYSYXCrewC9YmDj+5FEdG92tJ2cdvQaKbUmbh+BabyAmhF6uE8qC6Uu5Gf9AvLaWihlVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vbQcSOkf; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vbQcSOkf"
Date: Mon, 4 Aug 2025 13:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754327495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BNZ4Oz8kjyxWYKZZp/X80gppa0sK9lu1JrRxH6pnNf8=;
	b=vbQcSOkfqATZp282njTRfSkRXG7nTBurZQHnrfvD8Fu2PJDuchj9Y3pOEBpRB5vig2N0xi
	z/PqTR6iXYqMC3STTrv3kYQfIQG8pSOWCV3IP8M+owMdLT+RzmZcbVY/Eixs9SBOwUdvlH
	amZNN3afdXGV47CQ57L2/YXUQfunZdU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Add missing else statement
Message-ID: <jvhtywwzxnu2zxkxpbnxjkvoc7mfmj65hc5ygbsus4nu4b3u53@23s6z3nnjaxy>
References: <20250804170127.255678-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804170127.255678-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 01:01:27AM +0800, Alan Huang wrote:
> The if condition was broken, ret was always assigned to BCH_ERR_fsck_delete_bkey
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/error.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
> index 0c3c3a24fc6f..213814787dd6 100644
> --- a/fs/bcachefs/error.h
> +++ b/fs/bcachefs/error.h
> @@ -173,7 +173,8 @@ do {									\
>  	if (!bch2_err_matches(_ret, BCH_ERR_fsck_fix) &&		\
>  	    !bch2_err_matches(_ret, BCH_ERR_fsck_ignore))		\
>  		ret = _ret;						\
> -	ret = bch_err_throw(c, fsck_delete_bkey);			\
> +	else								\
> +		ret = bch_err_throw(c, fsck_delete_bkey);		\
>  	goto fsck_err;							\
>  } while (0)
>  
> -- 
> 2.49.0
> 
