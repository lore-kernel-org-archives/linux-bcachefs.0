Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7739F1DFDB4;
	Thu, 17 Oct 2024 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729184125; cv=none; b=NrmiseTEhisdFmYrP4xYDnT0YGPk7oDiE3YPcIVY3aTtqdY6/mi31xbHuegVgg7KMcx7nCdlauCObHaV1KUOz+7nD1uDkN4FrAS8ngYfJdOfWdVhhWoHTcBeMfOD3l0uDEUsDB/wJCFj1eChD8ID4c6/g95Xsi5tbdyY3Xc+33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729184125; c=relaxed/simple;
	bh=+FlDwpL8JrTw5+TUWtRBZr+ozEoLG4mlZiWyNJ3zjGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtKrLNF8YSE0bp/QNz415n4aYohk8gkLaqzhUfQNEE9qBQeLrbapYXnIjcHaF60OOjWRtb2BVKXihbPD7FZLOAKm21YPyKks1AAxC2rAidswCUIPxoag8tpESsqmb7sYbSk/hCL85ynvwdDB59fnTrVt/7BnFy5vuQyn089Gq9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pnPeft3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pnPeft3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B501C4CEC3;
	Thu, 17 Oct 2024 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729184125;
	bh=+FlDwpL8JrTw5+TUWtRBZr+ozEoLG4mlZiWyNJ3zjGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pnPeft3/fS3pgWcKxCJ0r/xY5PX9YelddMZ5RGP128nEgDTNsVpON9bRH1m2WJnXj
	 mjvobpU1sadlfSHjVMQhAf+RvRy/cSm0stmqiRxRbiwK8xuL8Su4dm2U4u5Jq8h7Hu
	 0NtXxLN3pvTsZk2wydO0CCPD3JqDEDyEjjMipKnnJotpKuCJDh1GxSh9CnwdjePw+E
	 X4bjOU35mUTXA99YI9CFG43jn/aPyvFn6RwgwXiePId45vRhBXiC/Q2n+QRdBz4DH1
	 miqNqZlOlAJiBgRUAnzkpzQVswbSjiq/bNZNfR96TUYxP5U1CL/w4wJ3H9DRJcw5Iv
	 V/3/2OI30JO9g==
Date: Thu, 17 Oct 2024 09:55:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <20241017165522.GA370674@thelio-3990X>
References: <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxB-uh1KzfD4ww2a@archlinux>

Hi Jan,

On Thu, Oct 17, 2024 at 05:04:26AM +0200, Jan Hendrik Farr wrote:
> On 16 17:09:42, Bill Wendling wrote:
> > Here's a potential fix:
> > 
> >   https://github.com/llvm/llvm-project/pull/112636
> 
> Here's the patch to disable __counted_by for clang < 19.1.3. I'll submit
> it properly when your PR is merged. I hope I got all the correct tags in
> there as there were multiple reports of these issues. Let me know if
> anything should be added, I'm new to the process.
> 
> From: Jan Hendrik Farr <kernel@jfarr.cc>
> Date: Thu, 17 Oct 2024 04:39:40 +0200
> Subject: [PATCH] Compiler Attributes: disable __counted_by for clang < 19.1.3
> 
> This patch disables __counted_by for clang versions < 19.1.3 because of
> two issues.
> 
> 1. clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
> https://github.com/llvm/llvm-project/pull/110497
> 
> 2. clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
> https://github.com/llvm/llvm-project/pull/112636
> 
> Cc: stable@vger.kernel.org

Should this include a Fixes tag to give the stable folks a hint about
how far back this should go? Maybe

Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")

It won't pick clean without 16c31dd7fdf6 or 2993eb7a8d34 but those are
easy enough to apply before taking this one.

> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
> Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
> Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>

Thanks for all of your help driving getting this fixed. The commit
message looks good to me aside my small nit above. I do have a
suggestion on the actual patch itself.

> ---
>  include/linux/compiler_attributes.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 32284cd26d52..7966a533aaec 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -100,8 +100,17 @@
>   *
>   *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
>   * clang: https://github.com/llvm/llvm-project/pull/76348
> + *
> + * clang versions < 19.1.2 have a bug that can lead to __bdos returning 0:
> + * https://github.com/llvm/llvm-project/pull/110497
> + *
> + * clang versions < 19.1.3 have a bug that can lead to __bdos being off by 4:
> + * https://github.com/llvm/llvm-project/pull/112636
>   */
> -#if __has_attribute(__counted_by__)
> +#if __has_attribute(__counted_by__) && \
> +	(!defined(__clang__) || (__clang_major__ > 19) || \
> +	(__clang_major__ == 19 && (__clang_minor__ > 1 || \
> +	(__clang_minor__ == 1 && __clang_patchlevel__ >= 3))))
>  # define __counted_by(member)		__attribute__((__counted_by__(member)))
>  #else
>  # define __counted_by(member)
> -- 
> 2.47.0
> 

compiler_attributes.h is intended to be free from compiler and version
checks, so adding a version check means that __counted_by() needs to be
moved into compiler_types.h. This might be a good opportunity to
introduce something like CC_HAS_COUNTED_BY in Kconfig, so that we can
keep the checks unified (since there are already multiple places that
want to know about __counted_by support for the sake of testing) and
adjust versions like this easily in the future if something else comes
up, especially since __counted_by() is not available in a released GCC
version yet.

Perhaps something like this? Feel free to take it wholesale if you would
like or tweak it however you see fit.

Cheers,
Nathan

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 62ba01525479..376047beea3d 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -445,7 +445,7 @@ static void lkdtm_FAM_BOUNDS(void)
 
 	pr_err("FAIL: survived access of invalid flexible array member index!\n");
 
-	if (!__has_attribute(__counted_by__))
+	if (!IS_ENABLED(CONFIG_CC_HAS_COUNTED_BY))
 		pr_warn("This is expected since this %s was built with a compiler that does not support __counted_by\n",
 			lkdtm_kernel_info);
 	else if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 32284cd26d52..c16d4199bf92 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -94,19 +94,6 @@
 # define __copy(symbol)
 #endif
 
-/*
- * Optional: only supported since gcc >= 15
- * Optional: only supported since clang >= 18
- *
- *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
- * clang: https://github.com/llvm/llvm-project/pull/76348
- */
-#if __has_attribute(__counted_by__)
-# define __counted_by(member)		__attribute__((__counted_by__(member)))
-#else
-# define __counted_by(member)
-#endif
-
 /*
  * Optional: not supported by gcc
  * Optional: only supported since clang >= 14.0
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 1a957ea2f4fe..639be0f30b45 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -323,6 +323,25 @@ struct ftrace_likely_data {
 #define __no_sanitize_or_inline __always_inline
 #endif
 
+/*
+ * Optional: only supported since gcc >= 15
+ * Optional: only supported since clang >= 18
+ *
+ *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
+ * clang: https://github.com/llvm/llvm-project/pull/76348
+ *
+ * __bdos on clang < 19.1.2 can erroneously return 0:
+ * https://github.com/llvm/llvm-project/pull/110497
+ *
+ * __bdos on clang < 19.1.3 can be off by 4:
+ * https://github.com/llvm/llvm-project/pull/112636
+ */
+#ifdef CONFIG_CC_HAS_COUNTED_BY
+# define __counted_by(member)		__attribute__((__counted_by__(member)))
+#else
+# define __counted_by(member)
+#endif
+
 /*
  * Apply __counted_by() when the Endianness matches to increase test coverage.
  */
diff --git a/init/Kconfig b/init/Kconfig
index 1aa95a5dfff8..6da1a8c3d99d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -120,6 +120,13 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config CC_HAS_COUNTED_BY
+	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
+	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
+	# https://github.com/llvm/llvm-project/pull/110497
+	# https://github.com/llvm/llvm-project/pull/112636
+	depends on CC_IS_GCC || CLANG_VERSION >= 190103
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
index 2abc78367dd1..5222c6393f11 100644
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -1187,7 +1187,7 @@ static void DEFINE_FLEX_test(struct kunit *test)
 {
 	/* Using _RAW_ on a __counted_by struct will initialize "counter" to zero */
 	DEFINE_RAW_FLEX(struct foo, two_but_zero, array, 2);
-#if __has_attribute(__counted_by__)
+#ifdef CONFIG_CC_HAS_COUNTED_BY
 	int expected_raw_size = sizeof(struct foo);
 #else
 	int expected_raw_size = sizeof(struct foo) + 2 * sizeof(s16);
