Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34011E377D;
	Fri,  4 Oct 2024 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728062004; cv=none; b=gPBEnuYAd5W2W3Iz346v5vcTIEa4CCzAr05kdKp89+XCPMQTv48zF8qg7MrWqFLTEVTKGP5LFhZD3x/L83NF7C54xzBMUJPDCoB2xdtECt6umDq8R6dww/Mu504gqmsokm2HZpIuFw3H8tiJB4FGah7c4twzMyXfVepLNeCvCQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728062004; c=relaxed/simple;
	bh=LHqprxKT11QQbqhmJEZLGqpjDxBSH8wKedLsZeJ9SFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9EF+H6jjqdniNT4J/nN6kUxT/B102w4g8hjJ1wvdma/wx1CyrtSvxilUDqH63zfA4tbgMzDQcsw+feu60iEip3uDySCshDqtcQC8wsENhAbs+RHaNhH/1Yan4qnkF+cB6T5XpfPopUiSCJ41qdJEkGQ2m8Acu8Bks6z8Djq9Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6r2BjFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6r2BjFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FC8C4CEC6;
	Fri,  4 Oct 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728062003;
	bh=LHqprxKT11QQbqhmJEZLGqpjDxBSH8wKedLsZeJ9SFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X6r2BjFfRCr0TwxhIfOZo85dwkHZ7eA4brv7n52yDVjDmU2ObBGfmw+OD/84qH3aw
	 OxBMrc9dtCJt7/GeqOImJ2rpZXD/VS7kK3L9lVuC/8RBKAdZK+NNSWcVLL5B2BGbug
	 Cvcqz3iznVBbrC2JAutYRWcKW+pQoARP7VQQddfVszeRqc0rC6cqPKoO/Go4GNLk2s
	 ketrT9wSomi4uouunvddXrzSMmy383L9RkLF3ruq/85r06UNmGn3bU1DYFbrdQ39Fq
	 wiRFYceVT149BYmlTNe2Q2B97mbTDqf54If1ia3uMpy9RPzhhf2AIjk49kRQLZ8hlc
	 w3U1aDXzvyhqw==
Date: Fri, 4 Oct 2024 10:13:20 -0700
From: Kees Cook <kees@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202410040958.C19D3B9E48@keescook>
References: <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv8RIs-htdc-PtXB@archlinux>

On Thu, Oct 03, 2024 at 11:48:18PM +0200, Jan Hendrik Farr wrote:
> On 03 14:28:01, Kees Cook wrote:
> > On Thu, Oct 03, 2024 at 05:17:08PM +0200, Jan Hendrik Farr wrote:
> > > gcc currently says that the __bdos of struct containing a flexible array
> > > member is:
> > > 
> > > sizeof(<whole struct>) + sizeof(<flexible array element>) * <count>
> > > 
> > > clang however does the following:
> > > 
> > > max(sizeof(<whole struct>), offsetof(<flexible array member>) + sizeof(<flexible array element>) * <count>)
> > 
> > Clang's calculation seems very wrong. I would expect it to match GCC's.
> > 
> 
> I was on the very same train of thought, but I have since changed my
> mind a bit. A struct containing a flexible array member can be allocated in
> two ways:
> 
> (1):
> 
> struct posix_acl *acl = malloc(sizeof(struct posix_acl) + sizeof(struct posix_acl_entry) * 1);
> acl.a_count = 1;
> 
> or (2):
> 
> struct posix_acl *acl = malloc(offsetof(struct posix_acl, a_entries) + sizeof(struct posix_acl_entry) * 1);
> acl.a_count = 1;
> 
> Both are valid ways to allocate it. __bdos does not know which of these
> methods was used to allocate the struct whose size it has to determine,
> so it's giving the lower bound that doesn't include the (potential)
> padding at the end.

I want to separate several easily confused issues. Instead of just
saying __bdos, let's clearly refer to what calculation within bdos is
being used. There are 3 choices currently:
- alloc_size attribute
- counted_by attribute
- fallback to __bos (which is similar to sizeof(), except that FAMs are 0 sized)

Additionally there are (for all intents and purposes) 2 size
determinations to be made by __bos and __bdos, via argument 2:
- containing object size (type 0) ("maximum size")
- specific object size (type 1) ("minimum size")

For example, consider:

struct posix_acl *acl = malloc(1024);
acl->a_count = 1;

what should these return:

	__bos(acl, 0)
	__bos(acl, 1)
	__bdos(acl, 0)
	__bdos(acl, 1)
	__bos(acl->a_entries, 0)
	__bos(acl->a_entries, 1)
	__bdos(acl->a_entries, 0)
	__bdos(acl->a_entries, 1)

> So it comes down to false positives vs false negatives...
> More details here:
> https://github.com/llvm/llvm-project/pull/111015
> 
> Clangs current behavior would essentially force kernel code to always
> assume option (2) is used. So
> 
> struct posix_acl *
> posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
> {
> 	struct posix_acl *clone = NULL;
> 
> 	if (acl) {
> 		int size = sizeof(struct posix_acl) + acl->a_count *
> 		           sizeof(struct posix_acl_entry);
> 		clone = kmemdup(acl, size, flags);
> 		if (clone)
> 			refcount_set(&clone->a_refcount, 1);
> 	}
> 	return clone;
> }
> EXPORT_SYMBOL_GPL(posix_acl_clone);
> 
> from linux/fs/posix_acl.c would have to turn into something like:
> 
> struct posix_acl *
> posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
> {
> 	struct posix_acl *clone = NULL;
> 
> 	if (acl) {
> 		int size = offsetof(struct posix_acl, a_entries) + acl->a_count *
> 		           sizeof(struct posix_acl_entry);
> 		clone = kmemdup(acl, size, flags);
> 		if (clone)
> 			refcount_set(&clone->a_refcount, 1);
> 	}
> 	return clone;
> }
> EXPORT_SYMBOL_GPL(posix_acl_clone);
> 
> Which is actually safer, because can you actually be sure this posix_acl
> wasn't allocated using method (2)?

First, this should not be using an open coded calculation at all; it
should use the struct_size() macro.

Secondly, if we want to change struct_size(), then we must (via
allmodconfig builds) determine all the places in the kernel
where the calculated size changes, and audit those for safety.

Right now, struct_size() over-estimates in the face of padding.

We're already moving the kernel toward not even calling struct_size()
externally from the allocation, and instead using the it within the
allocation macros themselves:
https://lore.kernel.org/lkml/20240822231324.make.666-kees@kernel.org/

> After looking at the assembly produced by gcc more, it actually looks
> like it's using the allocation size if it's known in the current context
> (for example if the struct was just malloced in the same function)
> and otherwise returns INT_MAX for the __bdos of a struct containing a
> flexible array member. It's only returning the size based on the
> __counted_by attribute of you ask it for the __bdos of the flexible
> array member itself.

Here is my test case for all the corner cases we've found so far:
https://github.com/kees/kernel-tools/blob/trunk/fortify/array-bounds.c

I'd prefer we add cases there so we can all be talking about the same
things. :)

-Kees

-- 
Kees Cook
