Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D0E1CCB36;
	Thu, 22 Aug 2024 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724348158; cv=none; b=uErhHfBKuOOe5nZR4YCYSgSES/LnSRt84+kz1U1AlD0Yv26Tm9SYwKRlqQrvMM5/c3MOBNYs/0sQdfnmoNvfDH2DxLYscjxO1sLsL4mxQ5WyBYk+xYzN2TRRed/1NVB0l0nVqy7Wi50sE3CsC+oazXGUQnMOdVdtsX8S0iVmD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724348158; c=relaxed/simple;
	bh=DqqCnDF00rsr59sEZNT81erTVMO+b9kOBdJ5Qphzw+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ftl5q8yYeZKWJmfG7LRWnBJDqcWt7ugArHNKErDDokSrah1HcIANxFTUTlPYRZbih008eMbCCx7BjSlUYCnw7NHIyB4QPfF40+8bKgbuqUtjBTRcorNWPvKOZcMXMMHJGNzzKmzk19s5iVAtg9SKYX+xxO7EJwH2gAZueshO5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dks3aFY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dks3aFY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF83C32782;
	Thu, 22 Aug 2024 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724348157;
	bh=DqqCnDF00rsr59sEZNT81erTVMO+b9kOBdJ5Qphzw+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dks3aFY8w6JgcV63GfhP2nZSNecUArb8lQKOzFG9G++J5vCe06GYk+onavFVOS4pS
	 F6LtVNN+eHzqtQc7F5B69q8zQhgXNP5lQRx4Gze4tyZ5GSjKhJWZ08v9oY7OlQdrc1
	 Qpccr26s7GHyxMUnbxevTX8aRoZROsmXjS2xvlQ1R+51rI6fPMyvhljn5ndwkbRhlZ
	 d5RYMyVfEskQqbULCS8Fy1e28D7qvkzltX/Htz1PWT7EYsdDAsKZJSXVXF9SPvH3OE
	 QJXLfZV7+hdLUfU7waRek9n7NGkuzqn8yKgroIl8gDExIbq8SRJ8v8woox7oTxIw0K
	 leF0Y1I7tA1vg==
Date: Thu, 22 Aug 2024 10:35:57 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kent.overstreet@linux.dev, gustavoars@kernel.org,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Annotate struct bucket_array with
 __counted_by()
Message-ID: <202408221035.5464B1E0@keescook>
References: <20240821162921.86767-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821162921.86767-2-thorsten.blum@toblux.com>

On Wed, Aug 21, 2024 at 06:29:22PM +0200, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array member
> bucket to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  fs/bcachefs/buckets_types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
> index c9698cdf866f..a19460a1bb7c 100644
> --- a/fs/bcachefs/buckets_types.h
> +++ b/fs/bcachefs/buckets_types.h
> @@ -24,7 +24,7 @@ struct bucket_array {
>  	u16			first_bucket;
>  	size_t			nbuckets;
>  	size_t			nbuckets_minus_first;
> -	struct bucket		b[];
> +	struct bucket		b[] __counted_by(nbuckets);
>  };
>  
>  struct bucket_gens {

I only see this being allocated in one place and nbuckets is immediately
assigned to the count of "b" elements, so this looks correct to me.

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
