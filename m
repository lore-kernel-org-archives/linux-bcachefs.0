Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A5143871
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729710041; cv=none; b=LXaP3LohHGZBywGqxbOwAEew3CNohhIhuxocdsGLYwiNfTX9zVh03RUdOoNj3+3jWZCmGgYJ8V6z+/6fcrBeVA1K7Zb8VatZvkCCv0QaA8+/5CPn9U+aRoQKG83wCWIlLPVBrLn55noQgPL2krq5sPxTf4Vntfi5Ofc0e8SebhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729710041; c=relaxed/simple;
	bh=oRSIKPsBGknjG9GxtaiuO7PDh5zEZa+XJJGySfvCHkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uN2y9HSHmoBL6Xrzm48HVkr7K2I4AG8/lmKTTosb3eN40HjRtlXoWFevcbNjCWaOs+HFKtUyfSDH0SrQqMrBrNZAxQY1pRCKadZg0j43MdfL1z6ARu1AacFXNZs72Os9X2AYxg/kmZwvxX3TOtd5YJLWEVL20r+WruzT/w4/k8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtaKcwtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtaKcwtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C1EC4CEC6;
	Wed, 23 Oct 2024 19:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729710040;
	bh=oRSIKPsBGknjG9GxtaiuO7PDh5zEZa+XJJGySfvCHkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QtaKcwtFc/oN9g3CgMtq8uQtnhc2Zsdk3/rDQZZNccnTLdEm8gUpr+F7imhzdbTr6
	 Cb6ye7EneOoXixtvf1K//sys0BqKTSVsUhB7oIVVdhOhjxWtvkik/vwFgEQxnmpPXw
	 RSF21a18OvzPP41w+9EBloAY4CZN8WJrcd8J/Luvv8PzSYddLoiFtnJ2ISQlo0KO6M
	 p781B1Z/woV6wf2GewbQd4bBA9z63J+DeZ0GYgrX6mNq+n8E21kedIAvzQ+M7CRmjh
	 oUR3hrPsERqcA6tjkzEnuZp7cu7GHaz0Q7EkFukP8ZplOKKT36Rpjnec93R68xAAtP
	 Kqa++6XENExeg==
Date: Wed, 23 Oct 2024 19:00:38 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bcachefs: Explicitly select CRYPTO from BCACHEFS_FS
Message-ID: <20241023190038.GA3736641@google.com>
References: <20241023183521.3752681-1-ebiggers@kernel.org>
 <3jhkejzn2prqk5xmqudfo4czy6fgxivqbcxkg7vq42x7z77lte@zwh6glvjgoiw>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3jhkejzn2prqk5xmqudfo4czy6fgxivqbcxkg7vq42x7z77lte@zwh6glvjgoiw>

On Wed, Oct 23, 2024 at 02:49:38PM -0400, Kent Overstreet wrote:
> On Wed, Oct 23, 2024 at 06:35:21PM +0000, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Explicitly select CRYPTO from BCACHEFS_FS, so that this dependency of
> > CRYPTO_SHA256, CRYPTO_CHACHA20, and CRYPTO_POLY1305 (which are also
> > selected) is satisfied.  Currently this dependency is satisfied
> > indirectly via LIBCRC32C, but this is fragile and is planned to change
> > (https://lore.kernel.org/r/20241021002935.325878-13-ebiggers@kernel.org).
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202410232254.ogS6Em2d-lkp@intel.com/
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Thanks, applied
> 
> (or acked-by, if you want to take it through your tree?)

Please go ahead and take it.  It will take a while to get my patchset merged,
and it will help to get dependencies like this out of the way first.  Thanks!

- Eric
