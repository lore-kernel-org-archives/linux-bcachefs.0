Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943621884B;
	Thu,  1 May 2025 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746130421; cv=none; b=St1Za8zmrx14bt0WGp00pXfJtN8NlKpbkCyW4S/lj9p9YCTfsJUCOdGRj593fXbBk3obbRMY9RZYWk3kHq32FScLaub+Po675+HtU7dV7g5CdCq31kQ4n0ewBPeUifl/T9YJsyCVmooRYPPZyXPdMzQIWNIm/H9EwHpFO5UHIn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746130421; c=relaxed/simple;
	bh=whnXD8DMgmW4wZq2U8LDzABFoRsWpQUcqa8Qd+5IX1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ca1/ueLIX/6uY0znwuX/TUhsgc1SLysYNTliG5glzM4KDXRhKvb0uwB7FPA3p0ZUpADUvqd8TpVXW6JMBuGhT8H9OoxM9T0ZwPI9gz9Sj/n/OkHYvQxCShOtYvv4zEzAPGgiHaMCtKKoQn12IKDwRcNAqt8QncFkqe+NNLwV4hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/yoxNJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/yoxNJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0923FC4CEE3;
	Thu,  1 May 2025 20:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746130421;
	bh=whnXD8DMgmW4wZq2U8LDzABFoRsWpQUcqa8Qd+5IX1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/yoxNJtVI9yakzaWY8j13a+SHPK/LaImTngvf5PxJSDIHfkbrewKEPYPN0FrTrBj
	 sufPHMCQtfLbu1ChL/hwNIytkWU7W+iEIZM3UGmyn2DW+uzB04uQDRyQtLONXM7LVq
	 S1WSc5YZGkse5X4amUijFuOUCYr8apUBCfeKljEC4S9U5yJXSkUNGWQdZZyO9L1YWu
	 3YVKafKuvKnA8sOfmjdF+kpyVE2FOQ36vQQSgaYMVwsXrwe9VK7g5JqPdyIjGV7h0O
	 7YE/s+7Sf8/BVUs7qiEU3tjm4eABnvKZg5tjR+c5zutbwFcJ/459xx1iAFPmehPCKW
	 ZU+iIe9y27LHQ==
Date: Thu, 1 May 2025 13:13:38 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alan Huang <mmpgouride@gmail.com>, kent.overstreet@linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: Remove incorrect __counted_by annotation
Message-ID: <202505011313.52AF4DC@keescook>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
 <9BACA2F2-D306-46BA-ACBE-E06460E11FA0@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BACA2F2-D306-46BA-ACBE-E06460E11FA0@linux.dev>

On Thu, May 01, 2025 at 10:08:16PM +0200, Thorsten Blum wrote:
> On 1. May 2025, at 22:01, Alan Huang wrote:
> > +	/*
> > +	 * x_name contains the name and value counted by
> > +	 * x_name_len + x_val_len. The introduction of
> > +	 * __counted_by(x_name_len) caused a false positive
> > +	 * detection of an out of bounds write.
> > +	 */
> 
> Instead of removing it, would __counted_by(x_name_len + x_val_len) work?

Not yet, but once __counted_by_expr() has landed in GCC and Clang, yes
it will. :)

-- 
Kees Cook
