Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B57C1FBC9C;
	Mon, 21 Oct 2024 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729538760; cv=none; b=K4Ht6P4aw7Y0mdADIQ5NqqafroFzaULsvLAB62VHBNZj1f2KOIkOgkvaUNy/7q9OL0rl9t8q/jdYR6g0TM4js/vkOPKdM0bVy99czf0eeBS2uAH4vs9bo2QHR0gy/KETmqz/vT6J22vzi5Ib+fsdU1iWx3ENfveOrk8lxZ8kY1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729538760; c=relaxed/simple;
	bh=gHgFXRPZ5AKuvTaw9/gjvzuyWZ8Ok1DwaWL1zLbodZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsWcrXCFuS5jt4/A3wdBiWrKYX6jqQpQ5jfP71G676Z30puQE4rTzAxJ2aQkW5CZxJgvKVDH4I3YUOzO3rY7rYII78eYYbSLM8ThqcF3sqF6QoKzsJjQwC0Xz1mV5ge0pw9TU7xIZSOy9pGYkBtXuq4nmI7uvVQMpXVMR75B9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/0x8TMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/0x8TMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F9C4CEC3;
	Mon, 21 Oct 2024 19:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729538760;
	bh=gHgFXRPZ5AKuvTaw9/gjvzuyWZ8Ok1DwaWL1zLbodZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h/0x8TMu8RVN5UEEsauL3AgXPPHf879EVRjepAneaZANhvvZvLocmHiLte8czCEou
	 Ii8zdP+GpsKoH3GIOl8wOT/gD2TG7LlWYW+KSqBXgmtYl52b8gMTCCwVRGdewhmxgb
	 qTgTSCcd36YqG8VKHpCKHOsddT24WLBzwPooJpb+64v1m96vDQqferfxulcEVOEH8F
	 Ftrk1dAGmdXbCnP41sQv7AEIu+FDUYyiBubF/LqCPYkxsFCrpYTEv5D4+SloiGZ5mt
	 k5K2KVI/YNbas4+WXuGAGJejRoDmwyPshBgdvChPwueO4HZDS9pA0dTk6XFsuqeWly
	 BHgKt8tWi70oA==
Date: Mon, 21 Oct 2024 12:25:57 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <20241021192557.GA2041610@thelio-3990X>
References: <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxWvcAPHPaRxp9UE@archlinux>

On Mon, Oct 21, 2024 at 03:33:36AM +0200, Jan Hendrik Farr wrote:
> > +config CC_HAS_COUNTED_BY
> > +	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
> > +	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> > +	# https://github.com/llvm/llvm-project/pull/110497
> > +	# https://github.com/llvm/llvm-project/pull/112636
> > +	depends on CC_IS_GCC || CLANG_VERSION >= 190103
> 
> I think I prefer
> 
> 	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
> 
> to make it more clear that the purpose is to disable this for clang
> versions below 19.1.3, but keep it enabled for every other compiler
> including pre-release gcc versions that pass the compile test.

Sure, that's a reasonable tweak to keep it a little bit more concise and
to the point. It's obviously logically equivalent.

> Also after gcc 15 is released I don't think a version check for gcc
> should be necessary. I only see an explicit version check as required
> when we know a certain version is broken. Otherwise I would prefer using
> the build test.

Yeah, I think this mostly got addressed with the comments downthread, I
think we are all in agreement.

> I guess an alternative would be to just create a
> CC_COUNTED_BY_BROKEN that is enabled for clang versions below 19.1.3
> and continue to use __has_attribute together with that option. That
> would make the build test unnecesarry. The downside is that it
> will require checking both __has_attribute and
> CONFIG_CC_COUNTED_BY_BROKEN for __counted_by support. So I think
> CC_HAS_COUNTED_BY is better.

Yeah I thought about something like that briefly but came to the same
conclusion quickly, especially once I realized how many places were
using __has_attribute for __counted_by already.

> I'll submit it once Bill's fix is in the release/19.x branch. Which
> maintainer should I address this too? You (Nathan), Miguel, Kees, or
> someone else?

Like Miguel said, you can send it to all the people you have mentioned
here but I would probably expect Kees to chauffeur this to Linus with
Miguel's Ack for compiler_attributes.h since Kees has generally owned
__counted_by up until this point.

Cheers,
Nathan
