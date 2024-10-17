Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA9219CA7;
	Thu, 17 Oct 2024 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191355; cv=none; b=sxNwb2F0bb2C16y3aeIA6muS1MpH2ZqS5jdrEIBIl1q8raP/N+i2jJG4Omc95BRElwJOevqD4H0TgjcdHyf4K1MeE5q67vfPb6WTjBKeje16Vd5O15waO6/hIElVcdwSIiO4uyoPnCMjcTb2hekAuH7C0R12dOm7NBjyZzlrcvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191355; c=relaxed/simple;
	bh=X7HCFoaUk82oqckdGpNK/01aR61kZ+YTuBrRRtP5v14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqPdVtwU6dbIQldSq66S1N0D9W6/wxD/P3q0BdWTUUPHhQGwOfGr0xaLuDtqxXZzb/kaEM7t+KT9VOYIMM5bc9A4EHJZUQffttwQuQUlCxPv0vj+nVj5qnZpqS2nIe+u1nQSr3q/alczkrQqlodXfjbIYfcoyxWnXMezNTVTHIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3x5x+Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3x5x+Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBC9C4CEC3;
	Thu, 17 Oct 2024 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191355;
	bh=X7HCFoaUk82oqckdGpNK/01aR61kZ+YTuBrRRtP5v14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h3x5x+Apad7J+kdq6cENxZgJPqTl3MDck0PCFp28aU7XIzU00m6PjEq6goo6rlJlL
	 +6X8P0WD2yvcKbw3oQfdjv+EyzEJhQ0UnjpwFERy4DSWqe8n49pIZoM5CKxAhu3uyy
	 vXxK04LGjo9sckN9h34nVWVZdPWUrCrCOBAm2LrCJG1Hul/jM+DRu0BZ77m4H/YdqR
	 8+K1CH//dpJRFqXrvFdDhZ17Oe+RfobYjFPBkMdgIoit7denq9ppBb57cYTs9Zm8o5
	 pqk4M+im90JInBnpRHlMs6nrSM8poLnRavbxBXVJkkKz4/m5MCDUy4LzGh3TUQakz0
	 9je/c+/3DqTlg==
Date: Thu, 17 Oct 2024 11:55:52 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, Bill Wendling <morbo@google.com>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <20241017185552.GA2263054@thelio-3990X>
References: <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <CANiq72=cUS4GRzuU0WAWn9owttU-L4UpV1Dip6QjUdudCoT8VA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=cUS4GRzuU0WAWn9owttU-L4UpV1Dip6QjUdudCoT8VA@mail.gmail.com>

Hi Miguel,

On Thu, Oct 17, 2024 at 07:39:43PM +0200, Miguel Ojeda wrote:
> On Thu, Oct 17, 2024 at 6:55 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Should this include a Fixes tag to give the stable folks a hint about
> > how far back this should go? Maybe
> >
> > Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
> 
> Yeah, I am not sure -- it does not really fix that commit, but if it
> helps the stable team...

The most "correct" Fixes tag would appear to be the one that first
introduced __counted_by itself (dd06e72e68bc) but __counted_by can never
be used at that original change because the test used __element_count__
as the attribute name, which never shipped in any compiler. So I would
argue that this change really does fix c8248faf3ca2 because that is the
point in time that needs this fix.

> > compiler_attributes.h is intended to be free from compiler and version
> > checks, so adding a version check means that __counted_by() needs to be
> 
> Yeah, ideally we should avoid that since the goal was to have a file
> with the straightforward ones.
> 
> Though if we do go for `CC_HAS_*`, I guess it would be simple enough
> too, i.e. similar to `has_attribute` (but on our side), but it also
> loses the simplicity of knowing those do not have arbitrarily complex
> conditions which `CC_HAS_*` could hide.

Yeah, I think the way compiler_attributes.h has operated so far with
regards to tests and such is working fine so far, no real need to switch
things up yet.

> > moved into compiler_types.h. This might be a good opportunity to
> > introduce something like CC_HAS_COUNTED_BY in Kconfig, so that we can
> > keep the checks unified (since there are already multiple places that
> > want to know about __counted_by support for the sake of testing) and
> > adjust versions like this easily in the future if something else comes
> > up, especially since __counted_by() is not available in a released GCC
> > version yet.
> 
> Sounds good to me (even if we did the unification somewhere else).
> Using `CLANG_VERSION` looks better too.
> 
> > +config CC_HAS_COUNTED_BY
> > +       def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
> 
> I am probably missing some context, but what is the reason for the
> build test? i.e. is there a reason we cannot test the GCC version too?

The only reason I generally do build tests plus compiler version checks
is due to certain vendor versions of clang, such as Android, which may
hijack the patch version and appear newer than they actually are.
However, now that I think about it, LLVM moving to GCC's minor
versioning scheme of 0 for the development / main branch and 1+ for
released versions should avoid that issue, so it isn't strictly
necessary for that reason. However...

> If the reason it is that it is not released, should we change it
> later?

This is a good point, as technically to allow use of __counted_by with
GCC with a version check, it would need to be 150000, which would
potentially break GCC versions between the 15 version bump and landing
__counted_by support without the feature check. We could also just do
150100 to be simple about it but I am not sure that is worth doing,
since I believe it is important that we support using __counted_by with
prerelease GCC. We want to make sure that this attribute gets decent
testing coverage while in development.

We could ship this with a comment to simplify the check when GCC 15.1.0
is released, since this is a feature very unlikely to be backported to
earlier GCC releases?

Cheers,
Nathan


I guess since we have a hard version check for clang, we might as well
have one for GCC as well.
