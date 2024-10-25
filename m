Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF84DBA3D;
	Fri, 25 Oct 2024 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729818930; cv=none; b=aeimM8m9G62jBVkVY3jCjmGNEHDo7CZ7bWknSgEUhAnaTwbl6g0gvOyZmh825Rn7T2q7jVhjZx0CofzYNxTIiWmCGKQ57oIoLfrSFMbTRObBmhoDM934T/XWFxRi6IxpVG0Ardsg0fXbnFGIGliHeOsUG7BrAOuuQDmcglc0stM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729818930; c=relaxed/simple;
	bh=vCt26z8Q/nN2hXXXf/3s0lEZ6H6OLpIZ1+pICKG3AHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTxcopAMNTBFXqa3QW+xXFfTqODuUQEGykoxr2Zkwp2YBF5T4Gb9qj8H/CstMj7VxstMllg+khvOHf7qV53TZ0KWlFjr0YJJbBBScbv7G7c/32xbtPFj2T/4tTpxIVaL91NamllRq4H0KoCP3R/rBxaFq6B6NpYEcqpz1/FwMeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSn2yBtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSn2yBtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94518C4CEC7;
	Fri, 25 Oct 2024 01:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729818930;
	bh=vCt26z8Q/nN2hXXXf/3s0lEZ6H6OLpIZ1+pICKG3AHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PSn2yBtugOSxaX05toB/b8OAh5VrwUNycHLUvvEz4qHqRZSCVYPypEiGTCLbH7qG/
	 SXV3F0mCS6nuSk8hu3sF83c8oY/ze7ni1Khxz2sUffeCpyQtKjUrY5JK/u43wisVPl
	 V90aRtm3YOCtWsTdxqWxXdYUcL5lB3YLYCdS0zBtVafo2j8KH2WM5t7EHfg3HZqaTa
	 KItDCGuIldaKDsQLEhJbsOE2c55ZO4cygP7H3izitHqEO7W2zG5g2rEVCmTRs8KK6q
	 jwwx3qa3lofx5rV7fwehxwD5r9UFvfxElbg9xpdTjGiLMKEiGtGZkCmwKBoVjBO+ky
	 njjjYOyCkKhpg==
Date: Thu, 24 Oct 2024 18:15:27 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <20241025011527.GA740745@thelio-3990X>
References: <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxpIwkfg9_mHO3lq@archlinux>

Hi Jan,

On Thu, Oct 24, 2024 at 03:16:50PM +0200, Jan Hendrik Farr wrote:
> Do you want me to add a Co-Developed-by tag for you? I feel bad just
> taking it.

I would not be opposed to a Co-developed-by tag since it reflects the
collaborative nature of the change but I do not need it just for the
sake of credit because you have done a good amount of work analyzing and
driving getting this problem resolved. I would argue I just
"Kconfig-ified" your proposed change :) So you have my permission to add
one but I will not be offended with just the Suggested-by!

> For reference here is the current state of the patch, still waiting on
> the merge into clang 19.1.x:
> 
> It needs three prerequisite commits on top of 6.6.x, but unfortunately
> still requires a small amount of manual conflict resolution, but it's
> easy enough
> 
> 1. include/linux/compiler_types.h:
> 	use the incoming change until before (but not including) the
> 	"Apply __counted_by() when the Endianness matches to increase test coverage."
> 	comment)
> 
> 2. lib/overflow_kunit.c: 
> 	HEAD is correct

Good to know. If they cannot resolve the conflicts, we'll get notified
that it has failed to apply so you (or one of us) can send a massaged
backport as a reply.

> From 6c667a43af0c57cd3f260fd75d5c4a198ba94220 Mon Sep 17 00:00:00 2001
> From: Jan Hendrik Farr <kernel@jfarr.cc>
> Date: Thu, 17 Oct 2024 04:39:40 +0200
> Subject: [PATCH] Compiler Attributes: disable __counted_by for clang < 19.1.3
> 
> This patch disables __counted_by for clang versions < 19.1.3 because
> of the two issues listed below. It does this by introducing
> CONFIG_CC_HAS_COUNTED_BY.
> 
> 1. clang < 19.1.2 has a bug that can lead to __bdos returning 0:
> https://github.com/llvm/llvm-project/pull/110497
> 
> 2. clang < 19.1.3 has a bug that can lead to __bdos being off by 4:
> https://github.com/llvm/llvm-project/pull/112636
> 
> Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
> Cc: stable@vger.kernel.org # 6.6.x: 16c31dd7fdf6: Compiler Attributes: counted_by: bump min gcc version
> Cc: stable@vger.kernel.org # 6.6.x: 2993eb7a8d34: Compiler Attributes: counted_by: fixup clang URL
> Cc: stable@vger.kernel.org # 6.6.x: 231dc3f0c936: lkdtm/bugs: Improve warning message for compilers without counted_by support
> Cc: stable@vger.kernel.org # 6.6.x
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/all/20240913164630.GA4091534@thelio-3990X/
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
> Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
> Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>

If you do not add the Co-developed-by, feel free to carry forward

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

on the official submission.

> ---
>  drivers/misc/lkdtm/bugs.c           |  2 +-
>  include/linux/compiler_attributes.h | 13 -------------
>  include/linux/compiler_types.h      | 19 +++++++++++++++++++
>  init/Kconfig                        |  8 ++++++++
>  lib/overflow_kunit.c                |  2 +-
>  5 files changed, 29 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
> index 62ba01525479..376047beea3d 100644
> --- a/drivers/misc/lkdtm/bugs.c
> +++ b/drivers/misc/lkdtm/bugs.c
> @@ -445,7 +445,7 @@ static void lkdtm_FAM_BOUNDS(void)
>  
>  	pr_err("FAIL: survived access of invalid flexible array member index!\n");
>  
> -	if (!__has_attribute(__counted_by__))
> +	if (!IS_ENABLED(CONFIG_CC_HAS_COUNTED_BY))
>  		pr_warn("This is expected since this %s was built with a compiler that does not support __counted_by\n",
>  			lkdtm_kernel_info);
>  	else if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 32284cd26d52..c16d4199bf92 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -94,19 +94,6 @@
>  # define __copy(symbol)
>  #endif
>  
> -/*
> - * Optional: only supported since gcc >= 15
> - * Optional: only supported since clang >= 18
> - *
> - *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
> - * clang: https://github.com/llvm/llvm-project/pull/76348
> - */
> -#if __has_attribute(__counted_by__)
> -# define __counted_by(member)		__attribute__((__counted_by__(member)))
> -#else
> -# define __counted_by(member)
> -#endif
> -
>  /*
>   * Optional: not supported by gcc
>   * Optional: only supported since clang >= 14.0
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 1a957ea2f4fe..639be0f30b45 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -323,6 +323,25 @@ struct ftrace_likely_data {
>  #define __no_sanitize_or_inline __always_inline
>  #endif
>  
> +/*
> + * Optional: only supported since gcc >= 15
> + * Optional: only supported since clang >= 18
> + *
> + *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
> + * clang: https://github.com/llvm/llvm-project/pull/76348
> + *
> + * __bdos on clang < 19.1.2 can erroneously return 0:
> + * https://github.com/llvm/llvm-project/pull/110497
> + *
> + * __bdos on clang < 19.1.3 can be off by 4:
> + * https://github.com/llvm/llvm-project/pull/112636
> + */
> +#ifdef CONFIG_CC_HAS_COUNTED_BY
> +# define __counted_by(member)		__attribute__((__counted_by__(member)))
> +#else
> +# define __counted_by(member)
> +#endif
> +
>  /*
>   * Apply __counted_by() when the Endianness matches to increase test coverage.
>   */
> diff --git a/init/Kconfig b/init/Kconfig
> index 530a382ee0fe..5f1fe3583f20 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -116,6 +116,14 @@ config CC_HAS_ASM_INLINE
>  config CC_HAS_NO_PROFILE_FN_ATTR
>  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
>  
> +# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> +# https://github.com/llvm/llvm-project/pull/110497
> +# https://github.com/llvm/llvm-project/pull/112636
> +# TODO: when gcc 15 is released remove the build test and add gcc version check
> +config CC_HAS_COUNTED_BY
> +	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
> +	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
> +
>  config PAHOLE_VERSION
>  	int
>  	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
> diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
> index 2abc78367dd1..5222c6393f11 100644
> --- a/lib/overflow_kunit.c
> +++ b/lib/overflow_kunit.c
> @@ -1187,7 +1187,7 @@ static void DEFINE_FLEX_test(struct kunit *test)
>  {
>  	/* Using _RAW_ on a __counted_by struct will initialize "counter" to zero */
>  	DEFINE_RAW_FLEX(struct foo, two_but_zero, array, 2);
> -#if __has_attribute(__counted_by__)
> +#ifdef CONFIG_CC_HAS_COUNTED_BY
>  	int expected_raw_size = sizeof(struct foo);
>  #else
>  	int expected_raw_size = sizeof(struct foo) + 2 * sizeof(s16);
> -- 
> 2.47.0
