Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA843204948
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730927877; cv=none; b=uhWXNjVoSvgrhYWk31xaP6dHVQ5/h3flG5mCLgoBQ0OL4jvkpOVDKByXn6Ws76uMbTxCRM0QvVZ48jhppSAaKo02rOOsoN3qr41ErSJtal58N5anaJtE2exCra5PnM60CZjvciWcooGU6GCI2Q2dfs7uWzh5ve/V83FRnectxWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730927877; c=relaxed/simple;
	bh=W/vgp9s6b4YcpxA+E0lpuQL2RzPcj3c7TSSJdKFdu2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLRG/qIz0AvynwKvs4MAGNwBKxYQOvslM9wKbAg49ZzWBw3DcX+wSnVv8JXAH/gjAkqgabSL8tolnoRoe02IoizvRu1BAxiDu9QADOKCwfoiz44eNmi8LnwAZ/emolQWtoyUMaDINQzNH8KFYioT4U2UA5Nb2BtPhFh/WK46vf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s0bCThT/; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s0bCThT/"
Date: Wed, 6 Nov 2024 16:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730927872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJPApgH2MGMQfV7AHgLLYTI9lB/Qvl+rWcog+BIT5tQ=;
	b=s0bCThT/QVuLPzmKu2mKSJ8IcnZnd8hm7SnMA8c5nEyqC4/UDjs/FmjpxpCMFr3EkJrm4k
	1UJIumrwmLAsQDwYzEhdkEhuypXOF4J5nF2xUhu05rtH5m0MNhkWqDXj8pRYLRFPPiaaPb
	6rVLepazM2HvYYXXuBLoUDUcZ2G/MYQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Herman <eric@commonscaretakers.com>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org, 
	Eric Herman <eric@freesa.org>
Subject: Re: [PATCH 1/2] ktest README.md: update location of test file
Message-ID: <lkmy7vlvayr3s2sy73wkewaklxpu2akkunbs7qiyihsi77ivgv@gywmguyzm4mf>
References: <20241031140602.2146768-1-eric@commonscaretakers.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031140602.2146768-1-eric@commonscaretakers.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 31, 2024 at 03:06:01PM +0100, Eric Herman wrote:
> From: Eric Herman <eric@freesa.org>
> 
> As of commit 89bba65 the .test files moved.
> 
> Signed-off-by: Eric Herman <eric@freesa.org>

Thanks! Applied

> ---
>  README.md | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 28c0801..e6a415e 100644
> --- a/README.md
> +++ b/README.md
> @@ -43,7 +43,7 @@ Then, to build a kernel and run some tests, from your linux kernel source tree
>  run
>  
>  ```
> -build-test-kernel run -I ~/ktest/tests/bcachefs/single_device.ktest
> +build-test-kernel run -I ~/ktest/tests/fs/bcachefs/single_device.ktest
>  ```
>  
>  While virtual machine is running, you can interact with it by running various
> -- 
> 2.39.5
> 
