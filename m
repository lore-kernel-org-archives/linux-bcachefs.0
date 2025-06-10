Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803DA170A2B
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562681; cv=none; b=a/NCxYGDurx7bmDlYxir8na1gvYhEobzrpCGn6HF6HgKX/WvxdIeg+tvwK6nSwoPzS/dzYFxl81Rzf1pT7DplUuoQImEVeuRJKLK8r2v3aVWddnKtcFAIAkfzB660Km0+B9BnnsG87hcApSfxL2VfM9AxkfzmkgwoU5kJYGIYuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562681; c=relaxed/simple;
	bh=AhPf0HPlWCa0aJD35+a4IfqIt8OKABnu+k8qfBCHN9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmIGB3gr2wLmoiyvmy4Kj//Po+NSY6q5GzRDaWl/7SsYgk8o7VWMXtsnQpo72RKecKlr5qBeXOstnIdYwx1iRLXKvScuByw0UVIoQYKbrZ22qA5Py7WA1YJ891imSu29v7iGAHCqILdh+vr04xvgPgMlaNnyg2lgiZzSCyEAccU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aKKh7GD6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aKKh7GD6"
Date: Tue, 10 Jun 2025 09:37:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749562667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kbrE13Z6Z8RsWUrcqg26zEiS4673dzviRDejxhOoIyU=;
	b=aKKh7GD65rmNR9h/MOTdkZQ8+wMS0zf742dSYvcPsjvZDGFCIGIcuMQbgNV7uQT3QZAyO6
	wgOtaYX9dBCZdCIz2WyFuM2Cf+YAU7WUmWhq02opYls3gni2zvKAWjr2HBAdt2DAyfu/s7
	3zm+jMepc3qgZqrOdJT2wAJU7ztwLPI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Thomas Bertschinger <tahbertschinger@gmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] bcachefs: ioctl: avoid stack overflow warning
Message-ID: <okwdyhfmx6qocem3ckgvt3jhdglyjav7tdrjzgquugj3kkolvn@ontqnranltb6>
References: <20250610092413.2640349-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610092413.2640349-1-arnd@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 10, 2025 at 11:24:04AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Multiple ioctl handlers individually use a lot of stack space, and clang chooses
> to inline them into the bch2_fs_ioctl() function, blowing through the warning
> limit:
> 
> fs/bcachefs/chardev.c:655:6: error: stack frame size (1032) exceeds limit (1024) in 'bch2_fs_ioctl' [-Werror,-Wframe-larger-than]
>   655 | long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
> 
> By marking the largest two of them as noinline_for_stack, no indidual code path
> ends up using this much, which avoids the warning and reduces the possible
> total stack usage in the ioctl handler.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks

> ---
>  fs/bcachefs/chardev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> index 2d38466eddfd..fde3c2380e28 100644
> --- a/fs/bcachefs/chardev.c
> +++ b/fs/bcachefs/chardev.c
> @@ -399,7 +399,7 @@ static long bch2_ioctl_data(struct bch_fs *c,
>  	return ret;
>  }
>  
> -static long bch2_ioctl_fs_usage(struct bch_fs *c,
> +static noinline_for_stack long bch2_ioctl_fs_usage(struct bch_fs *c,
>  				struct bch_ioctl_fs_usage __user *user_arg)
>  {
>  	struct bch_ioctl_fs_usage arg = {};
> @@ -469,7 +469,7 @@ static long bch2_ioctl_query_accounting(struct bch_fs *c,
>  }
>  
>  /* obsolete, didn't allow for new data types: */
> -static long bch2_ioctl_dev_usage(struct bch_fs *c,
> +static noinline_for_stack long bch2_ioctl_dev_usage(struct bch_fs *c,
>  				 struct bch_ioctl_dev_usage __user *user_arg)
>  {
>  	struct bch_ioctl_dev_usage arg;
> -- 
> 2.39.5
> 
