Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AE412EBDB;
	Thu,  3 Oct 2024 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727990604; cv=none; b=Yx8rR1tXqBvbosGR6GTnO3AImVl7C9rKEgTN3bFsvk1uyVG5v2Y8VCPoVDqjX4ALPvBmcvb1dDN81oHbHnAMPOeBsHVsugBT5Wl2Lfiy+PjuNXiVKlrBlKzzw+X98e0VbjSS5BoG91+/U5jQnCt5yrabYDhHLXoaumGIV3+9ZOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727990604; c=relaxed/simple;
	bh=NiqRhU4jkbgyFIZ31V4GQy0bGXpyVLmxUq9/QvMDlqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnXUhiQEePRrR3RVSe9h7TgEe11bx4tWZJ39uj4g8PYcg6qh3fzW+9Xm8lolNFoWNlHgw4Jw2pDmor/pg5wcjWqaoR+nc6KjV7vXUtYpeQScJ//f/AdA6JUFrHdFPYGhKXDCa3AfLlmc2hFx5bSEHewRiwr0pJ8XjxPT0fpAqgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sU8Hfg5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sU8Hfg5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91FAC4CEC5;
	Thu,  3 Oct 2024 21:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727990603;
	bh=NiqRhU4jkbgyFIZ31V4GQy0bGXpyVLmxUq9/QvMDlqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sU8Hfg5Q04zPDNnTlu8PwffrVZE1NtSoTKgOFSZ5aaKmlBy/S7j73rz2YcY/xRROx
	 sGfbwDybVQWZOc0jBdLpmMA5wBEjn4S7OGLZOakV1N0E1/t52ecf5VeyoLll70XG3c
	 iQLmC8WFwdE3v0bf2tUTtYrXYdCaq/YOH+US5fluf551/AQJIoH2/uuoTc7MnE3vsW
	 ZC4KDWzdRFJHsm4DkcWOfAxJhBssSEZgWWOPUZOfqyB0QB6fLzarlMlPEe6uhyNss8
	 KMzQFb25z6qzubM6Lh6WTvOI3doho+4ljH7I0cA4eFyyf5nKZLfYrsHvsLHh+8Xrlf
	 R/3CPDEvQk+Xg==
Date: Thu, 3 Oct 2024 14:23:20 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202410031422.72F54BE4@keescook>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>

On Wed, Oct 02, 2024 at 11:18:57AM +0200, Thorsten Blum wrote:
> On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > [...]
> > 
> > Sorry, I've been out of commission with covid. Globally disabling this
> > macro for clang is not the right solution (way too big a hammer).
> > 
> > Until Bill has a fix, we can revert commit
> > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited to
> > certain situations where 'counted_by' is in use.
> 
> I already encountered two other related __counted_by() issues [1][2]
> that are now being reverted. Would it be an option to disable it
> globally, but only for Clang < v19 (where it looks like it'll be fixed)?

Yeah, once we have a solid fix (so we have a known Clang version to
target), I'll want counted_by disabled in versions prior to that.

-- 
Kees Cook
