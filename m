Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3111E104E;
	Thu, 24 Oct 2024 13:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775817; cv=none; b=gAJfmM/ubeZoRhokGxdvEljfw/YvTXnjyIyTnlR8cuGC+b3RhsHG0UKsHNNhTvQbWGzeBb94ZVRgmnKe1vZNE3ciyBXrnnilmwcQol3ktfDeiFYlL03C5l9IOzcURYj/NFABFkrwLSZfS2i1pAhw6PX/JzJoHxBURHruiHMPkZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775817; c=relaxed/simple;
	bh=oku5NNRsExLUlwbdff53zTinMYUInsOzU9jIg/cWHO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OKAtV1hyBU8y5Q0XC7B/zRTcvaYrEipj0wtU4N9boyvOsetkFfCe7YfBQOYElLg8R8Pqz6wQjw12hf1gKIdszmqpdQz6ljQvibKQdPKdg5GyRz70UIMO/WIAMnr8ImqZglYxl4o1jV0OcKsC1dY7Lb7Ts6/IRlKQGXR2vbIP9ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=btxR6pRd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=alXNkauI; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="btxR6pRd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="alXNkauI"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A860911400EC;
	Thu, 24 Oct 2024 09:16:53 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 24 Oct 2024 09:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1729775813; x=1729862213; bh=06FwsQ0dYC
	4jSFygPf1ghqE3s2gNvHhwTL8NDrtl2Sw=; b=btxR6pRdMVUoXoOszDx4kcZBeI
	sSHXMkN4eecOoqfZrRnFR0jXHmrP61wFs9VC65b1NDRKofl8vQsKyDn2qoeroh8a
	lmgu7RUA4wPlOFfo2gbhDp6lSjLnIbP/OIVMD4UBTd1RS9EHWNi/AnQch2RH367A
	kGYCjx3cUaQrBrM6h2+HwP6bGXSZrMI/p2NLndN+2402HTtnTOPtos8NkRzbI3I6
	wvpMa0hkB4Lxjc3qWZuHjND2LP0doHypbFg+UsL130arfwRXXaUzw3+WYZ9aRiyX
	LDUoIJEe4v1Lb2hE2nOjYrCdio6HnUq1T0VK0H2D0AFOWAjnsv+3OcAE6F0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1729775813; x=1729862213; bh=06FwsQ0dYC4jSFygPf1ghqE3s2gN
	vHhwTL8NDrtl2Sw=; b=alXNkauI5/q4nxx5yHUoNM2fPn1aVBbj9aWX0C3n1gR8
	yg4pgMYyC+FVEeTRLLbMaoCtvDnIrl0FH7G0fRZ3pMLd4GwNE8OiC24yCbASLk4J
	H3Gi3n/4fUTGTQWgfqceGt38rlyEZgeGlfzd4oaqTfrDbz9VeKAzKFnNg+S+IJWh
	Qldwz7NBLyJW0hcrGNu8jgCSLlHwmBKyDFayqY3vdmXuIWH/ucMOLiqNTxQR/YIT
	GGl4yWp2/1TMqYCLjiotHvC4uuH3+WzyUk4qjy6lDd7c67pkYt4Vk+g2dJBdty1I
	SJFQXWlgJnNC9Pn6n1soqen+pwvLc4m0pOi7IHJkxw==
X-ME-Sender: <xms:xUgaZ0cvIjLs8Q0kgCClr3vlQqKqWyoTwfVf9mqR1t9q6psQUN26jA>
    <xme:xUgaZ2MHcn4YuwBwHSqJymwznoPSPqC-WPMSp26CAb6D6OZ7-XC9gxjFB6rkLJSDk
    Ch5-OG8zZcSG_Z84Bs>
X-ME-Received: <xmr:xUgaZ1hv1Omo70J-lbNpl5wqmxaijKirv4PcxGdxKTykcx-JZza0fU3gWsuc_ZwmkD46JkpS2m1RIdCur5DKYNaAs6hH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdejtddgfeejucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:xUgaZ5_kf6WBzbsJ6N6hNjYIpwx9YPcRiUO-6smCJ-Cluc5y3n6ORQ>
    <xmx:xUgaZwv2sj841txQoivKillwDjHlzO34fMuR4gOsIzV6UcKAPGh_3g>
    <xmx:xUgaZwFBS8Vv2dVoz0ogtzpfInrVgkvAHlkcCddS5UuWouvtGxY5nQ>
    <xmx:xUgaZ_Mk-9oJkkc2rCP7px519UnbCTh6G3dvmCuuwUBeVauKyU1U1w>
    <xmx:xUgaZwGWp8E_sZPRu_Ceg5VlrdD0sv9c__ipW8dBT0uNI2MssZDp7waT>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Oct 2024 09:16:51 -0400 (EDT)
Date: Thu, 24 Oct 2024 15:16:50 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZxpIwkfg9_mHO3lq@archlinux>
References: <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021192557.GA2041610@thelio-3990X>

Hi Nathan,

Do you want me to add a Co-Developed-by tag for you? I feel bad just
taking it.

For reference here is the current state of the patch, still waiting on
the merge into clang 19.1.x:

It needs three prerequisite commits on top of 6.6.x, but unfortunately
still requires a small amount of manual conflict resolution, but it's
easy enough

1. include/linux/compiler_types.h:
	use the incoming change until before (but not including) the
	"Apply __counted_by() when the Endianness matches to increase test coverage."
	comment)

2. lib/overflow_kunit.c: 
	HEAD is correct


From 6c667a43af0c57cd3f260fd75d5c4a198ba94220 Mon Sep 17 00:00:00 2001
From: Jan Hendrik Farr <kernel@jfarr.cc>
Date: Thu, 17 Oct 2024 04:39:40 +0200
Subject: [PATCH] Compiler Attributes: disable __counted_by for clang < 19.1.3

This patch disables __counted_by for clang versions < 19.1.3 because
of the two issues listed below. It does this by introducing
CONFIG_CC_HAS_COUNTED_BY.

1. clang < 19.1.2 has a bug that can lead to __bdos returning 0:
https://github.com/llvm/llvm-project/pull/110497

2. clang < 19.1.3 has a bug that can lead to __bdos being off by 4:
https://github.com/llvm/llvm-project/pull/112636

Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
Cc: stable@vger.kernel.org # 6.6.x: 16c31dd7fdf6: Compiler Attributes: counted_by: bump min gcc version
Cc: stable@vger.kernel.org # 6.6.x: 2993eb7a8d34: Compiler Attributes: counted_by: fixup clang URL
Cc: stable@vger.kernel.org # 6.6.x: 231dc3f0c936: lkdtm/bugs: Improve warning message for compilers without counted_by support
Cc: stable@vger.kernel.org # 6.6.x
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20240913164630.GA4091534@thelio-3990X/
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>
---
 drivers/misc/lkdtm/bugs.c           |  2 +-
 include/linux/compiler_attributes.h | 13 -------------
 include/linux/compiler_types.h      | 19 +++++++++++++++++++
 init/Kconfig                        |  8 ++++++++
 lib/overflow_kunit.c                |  2 +-
 5 files changed, 29 insertions(+), 15 deletions(-)

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
index 530a382ee0fe..5f1fe3583f20 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -116,6 +116,14 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
+# https://github.com/llvm/llvm-project/pull/110497
+# https://github.com/llvm/llvm-project/pull/112636
+# TODO: when gcc 15 is released remove the build test and add gcc version check
+config CC_HAS_COUNTED_BY
+	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
+	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
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
-- 
2.47.0
