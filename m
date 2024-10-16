Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A32170D5;
	Wed, 16 Oct 2024 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729111404; cv=none; b=KLDM1dTdDrX2GbkU2y8SF7W6Z2PeG0nWMLB1WqqnuKgRZbEpH/cEXvmSgLp1Lre/V68Y0o3jOXkpmmQ1fLnNn4gFKRShcqSnXpEJwCoU8X92qDNR96Zshhnq9QAQ8LM5GzX7g14v/9rbx5iqc/4OZczCTOlkPVI5V3UqEASKHFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729111404; c=relaxed/simple;
	bh=qo/iVoYCKv6clO7FRi1PwRL1hqwG01g25YyRsbCYQ00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YG17SS4uBsDB/OGfy7+k48BKcUa4rqpwk56+5PPu1JgAvcgMQAB+Ls5YB6becCB928Voxgk9kqHdXkcuybcg+ONhThR8GWBfDh5f6WRra3oXL6KJ4KEWW4t6kfSp5bV7jfFIrGEqjOGQ340jXpOiY0zRdikL2GZ4fAdYGy+Lb5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AJZq1F2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AJZq1F2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E29C4CECD;
	Wed, 16 Oct 2024 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729111404;
	bh=qo/iVoYCKv6clO7FRi1PwRL1hqwG01g25YyRsbCYQ00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AJZq1F2dulcRjkSp/MnZnzLjHNPn3ZptXhO7JV7B3NrGDtMWpHuPHDzKBFv2U9Owq
	 6zDdDSEn2+ZcGf3f8ciCWjuUgHtgy3lwetxKCoauF6g00b220IlNk2dIcod9jxWLrh
	 7VhZQnFmSmfeWrAh5IYhhuOe3IyU3zIclimupa0sRSH9zRQ6vNWno4qkoxPIPz5wZ6
	 NCV7qT1DCHVesCR/hEnE/SZ3Yixt3z9Knw2JuTM+bY2itrLyNrNqskP5UHKhmAC5s0
	 nsk5UI4oR4DRmtXNImEDJOXplbCeiCkexpL5qUnDWJjYzSxuLrYl64ErstZVcIBlZl
	 dIfIyjuNJqs8w==
Date: Wed, 16 Oct 2024 13:43:21 -0700
From: Kees Cook <kees@kernel.org>
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Bill Wendling <morbo@google.com>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <202410161342.53075D369C@keescook>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <CAGG=3QVecaZfoRrjToToq8=Azh8M0vQ5Q=V8dfhdBnDR8GWy5A@mail.gmail.com>
 <Zw8iawAF5W2uzGuh@archlinux>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zw8iawAF5W2uzGuh@archlinux>

On Wed, Oct 16, 2024 at 04:18:19AM +0200, Jan Hendrik Farr wrote:
> On 15 18:22:50, Bill Wendling wrote:
> > On Thu, Oct 3, 2024 at 4:33 AM Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > > On 02 11:18:57, Thorsten Blum wrote:
> > > > On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > > > > [...]
> > > > >
> > > > > Sorry, I've been out of commission with covid. Globally disabling this
> > > > > macro for clang is not the right solution (way too big a hammer).
> > > > >
> > > > > Until Bill has a fix, we can revert commit
> > > > > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited to
> > > > > certain situations where 'counted_by' is in use.
> > > >
> > > > I already encountered two other related __counted_by() issues [1][2]
> > > > that are now being reverted. Would it be an option to disable it
> > > > globally, but only for Clang < v19 (where it looks like it'll be fixed)?
> > > >
> > > > Otherwise adding __counted_by() might be a slippery slope for a long
> > > > time and the edge cases don't seem to be that rare anymore.
> > > >
> > > > Thanks,
> > > > Thorsten
> > > >
> > > > [1] https://lore.kernel.org/all/20240909162725.1805-2-thorsten.blum@toblux.com/
> > > > [2] https://lore.kernel.org/all/20240923213809.235128-2-thorsten.blum@linux.dev/
> > >
> > > This issue is now fixed on the llvm main branch:
> > > https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> > >
> > > So presumably this will go into 19.1.2, not sure what this means for
> > > distros that ship clang 18. Will they have to be notified to backport
> > > this?
> > >
> > FYI, Clang 19.1.2 shipped with your fix in it.
> > 
> 
> Thx for the info.
> 
> How should we continue with the "off by 4" issue? The way I see it either
> the kernel has to change struct_size (lots of work) or clang has to get
> an option to follow the kernels behavior. I'm in favor of adding an
> option to clang.

I'm planning on checking how much impact there is on the kernel to fix
struct_size() to be precise. It really does need to match __bdos for
Clang and GCC.

-Kees

-- 
Kees Cook
