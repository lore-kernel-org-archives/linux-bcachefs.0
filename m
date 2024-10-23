Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF04A3E
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729709388; cv=none; b=UNucrzel1rXt8Uryy7lHdESuTNzMw9g2D2NP7rVjApTJ0jbiGVwk/84E1QIieL31yMcw5a5B2giCbkPTcZgojKGuftTZqIOrK9eQZAJzNoaJTIvqY4vClfMwVL4kjtcyHORiVjrNDKTPd5oDajjNOeO3H0BFVByxG6ndN8OJVj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729709388; c=relaxed/simple;
	bh=XPnN62ZBlQZImssytxovjP/V9cQveU9XL26gCSZtOBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSUh0ZrQz5z2aPtY98olRKvcmEi2PMmmsH7DBhcmY65cQZNQsrKpBCdmJ0XR6f2RaE8W8hI4QLe46j/JGWOo16HARYWOgbVp2lyGnss66PinQYHgRi15crKuszGXkf+iX/smB6kCT5fGrSbx2qOJKTZjz0ya38BZm+FdlVejzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L0jwbP06; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L0jwbP06"
Date: Wed, 23 Oct 2024 14:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729709383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nF75Swmrc4DybBH+UHmkCKkY43FdDmg+xTVuy7hs7zs=;
	b=L0jwbP061swxl6ks0UcEfzKSMJNyCt+zYlf7RAYEBwvO0CJ545mHKbQQQLqz1q+gSQKMyg
	5SxEefCBk4tsseKUHgXfuPOs2QvMSRO4TRhWlHUzbc7Up8A+otLm0QAxUJAtu1gazNL4/p
	Kc7NEikOaDgxg9CiATqklLobrKuEzew=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bcachefs: Explicitly select CRYPTO from BCACHEFS_FS
Message-ID: <3jhkejzn2prqk5xmqudfo4czy6fgxivqbcxkg7vq42x7z77lte@zwh6glvjgoiw>
References: <20241023183521.3752681-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023183521.3752681-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 06:35:21PM +0000, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Explicitly select CRYPTO from BCACHEFS_FS, so that this dependency of
> CRYPTO_SHA256, CRYPTO_CHACHA20, and CRYPTO_POLY1305 (which are also
> selected) is satisfied.  Currently this dependency is satisfied
> indirectly via LIBCRC32C, but this is fragile and is planned to change
> (https://lore.kernel.org/r/20241021002935.325878-13-ebiggers@kernel.org).
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202410232254.ogS6Em2d-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied

(or acked-by, if you want to take it through your tree?)
