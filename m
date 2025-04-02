Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7776F19258E;
	Wed,  2 Apr 2025 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611329; cv=none; b=fRghnDr2or8YHAUyMCEkMFnsa091n/egdd1EPBv3zIHeMAk5QJvo2yg5p+u9a+G1T0CAZu8odRJc1O6I07TkNPxIZKLM1L3lnLRzKl0ciLbrQ5WRfetv6kPCf2tOeoXWIkt4T7g56jP5guoBGIIcMtXs1ZUYWsAMmQYXim37DbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611329; c=relaxed/simple;
	bh=OYkhbBfauUOygNIRWFe/JB2WsSefX4yclKRnnqYWreg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F63trbodgxusQtFcLOoK2AbaP+Rw30zhH24lngFAqRdxOiBMvjNOs4zJP7ATj1eVnxJFxbvrkA9WEE4KsC7zm8q2fXm6yoBnyCxcoI8Q1DSJ59tNy8omtxHbXVkawk+Fms3SRA6A71hrjD+aN1aA8fiRBRujX5HLhXr3okz0O0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWQRKQuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWQRKQuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C0DC4CEDD;
	Wed,  2 Apr 2025 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743611329;
	bh=OYkhbBfauUOygNIRWFe/JB2WsSefX4yclKRnnqYWreg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWQRKQuuhVwDZNtv8YFAGVGrBFD4BDdd1LoSHUuz0+8uHI1VBZmwbn5QyT9ue9CZS
	 nynEtAdr2uCq+2ZWuoiLrvzt4JK95zqeon0SYy0l4WWoDuCqUYCjMYkbOxJ4b0pKR/
	 mQDSZv1KNu5SwKY/NZd8DkMIKnrB19etuUq6LvMBfV2Pbg+twGAHx9zj/gVq1TqzA0
	 KD/j9DlG0WhiJEz+SNUG13qr1B3wr63X2mqjZ+fHbAe09UskTcJcZ2RXJgkAXVs3C6
	 bxRCXM5RLceDtfzw6UmKhsvEbTNjD74GCZuwAs+F5tZa1fgEBfj1y8paXV+uoMBkPb
	 bu2ybdKK/egDg==
Date: Wed, 2 Apr 2025 09:28:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] bcachefs: use library APIs for ChaCha20 and Poly1305
Message-ID: <20250402162847.GA1235@sol.localdomain>
References: <20250402043333.352723-1-ebiggers@kernel.org>
 <icwysnfc3v7b2hpwvm6ay6567sb5zcmcctmlt44cag6gblaylv@ubrzwcmphci2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <icwysnfc3v7b2hpwvm6ay6567sb5zcmcctmlt44cag6gblaylv@ubrzwcmphci2>

On Wed, Apr 02, 2025 at 10:01:07AM -0400, Kent Overstreet wrote:
> On Tue, Apr 01, 2025 at 09:33:33PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Just use the ChaCha20 and Poly1305 libraries instead of the clunky
> > crypto API.  This is much simpler.  It is also slightly faster, since
> > the libraries provide more direct access to the same
> > architecture-optimized ChaCha20 and Poly1305 code.
> > 
> > I've tested that existing encrypted bcachefs filesystems can be continue
> > to be accessed with this patch applied.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Fantastic!
> 
> Applied, and this should go into 6.15 - this should get the strange bugs
> in the poly1305 path that I wasn't able to reproduce off the dashboard
> (and if they're still there, they'll be much easier to debug.)

Thanks!

If you're referring to
https://lore.kernel.org/r/CAHOo4gLWAbArwg+w+AqqkxGmOFX6cm8Tvy85tb4igN6V7Z9BZQ@mail.gmail.com/,
I think bcachefs passed invalid memory to Poly1305 as a result of mounting a
fuzzed filesystem image.  So it should be unaffected by this patch.

- Eric
