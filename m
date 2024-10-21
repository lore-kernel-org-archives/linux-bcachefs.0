Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3598F58;
	Mon, 21 Oct 2024 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729474423; cv=none; b=VDAbWlRJIwxt/f/aYk+TiEgIS3Wy5KJNsxtFEaSOURQwsOBb5TcKlnN88tPiLgQsyiKNYV/7P17sQCDAEoTJbDW9WqgLxUruYn5Oc7dAiDL6uAlX2kIIZgv+l4yiEyC+HL0iw6WDwczI/9RfO6VKgLRF9dkGyj8YUJlIgabcbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729474423; c=relaxed/simple;
	bh=vg53as/IlqXin1fTadmwJLGLM558DxMUNk55pqXRXO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyI9G+iSJOuBG7QEsUD58OTEdCk5asQlfDoelM8+DTHfOiyMqajESrsfG89Djxtz8+SZrRmAx1S5IicO/bLRP7coBQbzD83RtICj5t0V5aWW9axy8a88/lOFbKibVzXJrjA1c7Dnh4+SngKBUv6easQy+cOqvXI/W1qV/byQGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=Nm++2zMl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MHjciiUp; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="Nm++2zMl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MHjciiUp"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id A2C0A138029C;
	Sun, 20 Oct 2024 21:33:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 20 Oct 2024 21:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1729474419; x=1729560819; bh=clIPsP/X+D
	MGbfBBBez55p5htxiiuvak7zJmmrjpmW0=; b=Nm++2zMloaB7J0HcXVbZAev0Zk
	rdM2mVr0bL5RA5oelZFEgCWobLIHzCpkDs5u5Y3rGDK0yixMPOHJGZuqzWNnl49G
	lVt5bcNgS6vKogXs/C1lLrPxbOABRgkleIhXK9akAF4L7assRKgbBA8eKF34WZMI
	bheBtQHWHBxAnj8deyR6C69ZVpmkgL7xaFNc1SXjIjlB4PAWh0wOygU+7tIxqezi
	hYG9Tg86bUFWl4tSu/fySOki8kCHLedSJ4StnMI6ThHZ/QImxST8MiT5ILMwWUIA
	NbOljkoBVCeaJ8LgX4P3b4ME3JFM7ix/Q6I0sPr062EaqQ5OL4xQwjud5L0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1729474419; x=1729560819; bh=clIPsP/X+DMGbfBBBez55p5htxii
	uvak7zJmmrjpmW0=; b=MHjciiUpAfY6wpJeRCyMB8ZR751cOy2YQFrLn56sNibU
	RRU8L4WoJvl9C2ANZ8m59dYM9TA3sNkmFOnUPPY8qvuXQVXeitgd3ajDYA5zaR2I
	DoTlpXwOTeTp9OgoDZG24J0qDzmwyoW94/RCm+wcVDiHn9pRHgx06eL56+NPV9TB
	NJ7NTK4x9Nl8nbv2E9RgprdqSUv7BcvT71sOiGrAIV4ZVcSYquF0q4sYvMX5zGux
	jaHDISDv+lhV0/FyruQrIrWr6KXAcHzWecKEkjiE4xKOFreVt0MFv6Mgr6GZ6nMn
	dteTbxS+B6KXEhgFmF9NkWpo+38ehL1AWHPwyyPojw==
X-ME-Sender: <xms:c68VZ_UySR8kuTacb4Oeie9AbY388FkE-JvRYSnByyMBLIpOTB1YWg>
    <xme:c68VZ3nsxM3uqrnrvmFRuiLWBaovNz8QUOlaIhFxrXFQl4wAiPWY0HTby4OfLUvtt
    BAMg8P_FQNe501sMyI>
X-ME-Received: <xmr:c68VZ7a9OW7obbqJOjyY6EewhuXL-9f8J6yzMsvUFgX6CrmIpqMqizYCVFqfQ3DjX1Y2mM2L9sly_5_7edSuEhwZH6ck>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehkedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeeffffgleev
    keduffevffffueelueevheduiedukeetuedvfeegfeelheekteejieenucffohhmrghinh
    epghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrghdpghhnuhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjh
    hfrghrrhdrtggtpdhnsggprhgtphhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepnhgrthhhrghnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmohhrsg
    hosehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtg
    hpthhtohepkhgvnhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphht
    thhopehrvghgrhgvshhsihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpth
    htoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrgh
X-ME-Proxy: <xmx:c68VZ6W2sssmHtdkK11SPz7aR4U817AJwork9SCMapllwS9h1GwNQA>
    <xmx:c68VZ5nGj_2LXUnGzZ9zjAr1R9coNTLna-5w13A4K07xp5IVhLSIYA>
    <xmx:c68VZ3ehl2ZScvzjP3dPdPkf4cY_h3nhql0mAXS0Lvd7LSJFjCYAXw>
    <xmx:c68VZzE78mcXUDalEVS0cnmQq2VXy1S3uYEaV0o0ikdh_8RINJ9HZA>
    <xmx:c68VZ_f_RET9a8IbIKlYRIbbYDJOs7d2JVmDaQjYWN2A7_129mbMsQ9G>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Oct 2024 21:33:37 -0400 (EDT)
Date: Mon, 21 Oct 2024 03:33:36 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZxWvcAPHPaRxp9UE@archlinux>
References: <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017165522.GA370674@thelio-3990X>

On 17 09:55:22, Nathan Chancellor wrote:

Hi Nathan,

Thanks for the feedback.

> Hi Jan,
> 
> On Thu, Oct 17, 2024 at 05:04:26AM +0200, Jan Hendrik Farr wrote:
> > On 16 17:09:42, Bill Wendling wrote:
> > > Here's a potential fix:
> > > 
> > >   https://github.com/llvm/llvm-project/pull/112636
> > 
> > Here's the patch to disable __counted_by for clang < 19.1.3. I'll submit
> > it properly when your PR is merged. I hope I got all the correct tags in
> > there as there were multiple reports of these issues. Let me know if
> > anything should be added, I'm new to the process.
> > 
> > From: Jan Hendrik Farr <kernel@jfarr.cc>
> > Date: Thu, 17 Oct 2024 04:39:40 +0200
> > Subject: [PATCH] Compiler Attributes: disable __counted_by for clang < 19.1.3
> > 
> > This patch disables __counted_by for clang versions < 19.1.3 because of
> > two issues.
> > 
> > 1. clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
> > https://github.com/llvm/llvm-project/pull/110497
> > 
> > 2. clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
> > https://github.com/llvm/llvm-project/pull/112636
> > 
> > Cc: stable@vger.kernel.org
> 
> Should this include a Fixes tag to give the stable folks a hint about
> how far back this should go? Maybe
> 
> Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
> 
> It won't pick clean without 16c31dd7fdf6 or 2993eb7a8d34 but those are
> easy enough to apply before taking this one.

Yes, I'll add this. I agree that c8248faf3ca2 is the correct commit for
the Fixes tag, as this fix is not needed before this commit.

> 
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
> > Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
> > Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>
> 
> Thanks for all of your help driving getting this fixed. The commit
> message looks good to me aside my small nit above. I do have a
> suggestion on the actual patch itself.
> 
> > ---
> >  include/linux/compiler_attributes.h | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> > index 32284cd26d52..7966a533aaec 100644
> > --- a/include/linux/compiler_attributes.h
> > +++ b/include/linux/compiler_attributes.h
> > @@ -100,8 +100,17 @@
> >   *
> >   *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
> >   * clang: https://github.com/llvm/llvm-project/pull/76348
> > + *
> > + * clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
> > + * https://github.com/llvm/llvm-project/pull/110497
> > + *
> > + * clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
> > + * https://github.com/llvm/llvm-project/pull/112636
> >   */
> > -#if __has_attribute(__counted_by__)
> > +#if __has_attribute(__counted_by__) && \
> > +	(!defined(__clang__) || (__clang_major__ > 19) || \
> > +	(__clang_major__ == 19 && (__clang_minor__ > 1 || \
> > +	(__clang_minor__ == 1 && __clang_patchlevel__ >= 3))))
> >  # define __counted_by(member)		__attribute__((__counted_by__(member)))
> >  #else
> >  # define __counted_by(member)
> > -- 
> > 2.47.0
> > 
> 
> compiler_attributes.h is intended to be free from compiler and version
> checks, so adding a version check means that __counted_by() needs to be
> moved into compiler_types.h. This might be a good opportunity to
> introduce something like CC_HAS_COUNTED_BY in Kconfig, so that we can
> keep the checks unified (since there are already multiple places that
> want to know about __counted_by support for the sake of testing) and
> adjust versions like this easily in the future if something else comes
> up, especially since __counted_by() is not available in a released GCC
> version yet.
> 
> Perhaps something like this? Feel free to take it wholesale if you would
> like or tweak it however you see fit.

Thanks, I only have one tweak below:

> 
> Cheers,
> Nathan
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
> index 1aa95a5dfff8..6da1a8c3d99d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -120,6 +120,13 @@ config CC_HAS_ASM_INLINE
>  config CC_HAS_NO_PROFILE_FN_ATTR
>  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
>  
> +config CC_HAS_COUNTED_BY
> +	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
> +	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> +	# https://github.com/llvm/llvm-project/pull/110497
> +	# https://github.com/llvm/llvm-project/pull/112636
> +	depends on CC_IS_GCC || CLANG_VERSION >= 190103

I think I prefer

	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)

to make it more clear that the purpose is to disable this for clang
versions below 19.1.3, but keep it enabled for every other compiler
including pre-release gcc versions that pass the compile test.

Also after gcc 15 is released I don't think a version check for gcc
should be necessary. I only see an explicit version check as required
when we know a certain version is broken. Otherwise I would prefer using
the build test.


I guess an alternative would be to just create a
CC_COUNTED_BY_BROKEN that is enabled for clang versions below 19.1.3
and continue to use __has_attribute together with that option. That
would make the build test unnecesarry. The downside is that it
will require checking both __has_attribute and
CONFIG_CC_COUNTED_BY_BROKEN for __counted_by support. So I think
CC_HAS_COUNTED_BY is better.

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

I'll submit it once Bill's fix is in the release/19.x branch. Which
maintainer should I address this too? You (Nathan), Miguel, Kees, or
someone else?


Best Regards
Jan

