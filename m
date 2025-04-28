Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BE28460
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 02:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745806607; cv=none; b=EZddsRnNZU+YhWPLSkvACwbZ3CnRUqNXUKnIClnwO6XNOA87RWEjAR/IkmduFJOi1clne5yg+Ae58j3wcoCl9358sQY4sDzUCzdrlbp5Sx1SltZgCaFaKqnHP7XPDl0uR4YazmaYygJkrWDvsU2byj4bSeEcaJRNK5zHWkL/cC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745806607; c=relaxed/simple;
	bh=SQqRlFD5fYY2+fVv3+FPvlMoGm8Uc3q9VP/c9Mdfv9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oew5gJ2c2AX7LnML94bXPhQ3xBM9vi7NprKyF4upJTp0Ars/CmTu/ahNlG0Yht3mGge92JRzj6BbhXJvHlAhqb7/GpuZMN2dkOCpmjg3lqj7nwgmGCBbIvnwxefDvnkE57GuHwCX98HwXp9soo6GhV6UjnTmG5Lse09UstxT8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fXK7J1ZY; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fXK7J1ZY"
Date: Sun, 27 Apr 2025 22:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745806601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RmM07fRPec/1zzAWMCpOGJvhJQMyg467Y39fmijBlIc=;
	b=fXK7J1ZYYemrn5k/9JQGCAtrtD1+xeanhXWhDlCNThGmi28Fo/MGnwEUHnuslo69ljd+53
	rwzsonvYSj/74D3Qex4/S3faX+YH1vqkQl9vonjEhXTrJNrMln5PfjPm8hwS+LRwYTbnQD
	yVSiWaUlt9R1s3kDmh6QD+6Z/JcZ/CU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Autumn Ashton <misyl@froggi.es>
Cc: Eric Biggers <ebiggers@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <wjj4ld5jpnj57wwe6ygtldm3jazlnlbendzwpe65xce5xfv5tg@im53llnthtxd>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <aAvlM1G1k94kvCs9@casper.infradead.org>
 <ahdxc464lydwmyqugl472r3orhrj5dasevw5f6edsdhj3dm6zc@lolmht6hpi6t>
 <20250428013059.GA6134@sol.localdomain>
 <ytjddsxe5uy4swchkn2hh56lwqegv6hinmlmipq3xxinqzkjnd@cpdw4thi3fqq>
 <5ea8aeb1-3760-4d00-baac-a81a4c4c3986@froggi.es>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ea8aeb1-3760-4d00-baac-a81a4c4c3986@froggi.es>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 28, 2025 at 03:05:19AM +0100, Autumn Ashton wrote:
> 
> 
> On 4/28/25 2:43 AM, Kent Overstreet wrote:
> > On Sun, Apr 27, 2025 at 06:30:59PM -0700, Eric Biggers wrote:
> > > On Sun, Apr 27, 2025 at 08:55:30PM -0400, Kent Overstreet wrote:
> > > > The thing is, that's exactly what we're doing. ext4 and bcachefs both
> > > > refer to a specific revision of the folding rules: for ext4 it's
> > > > specified in the superblock, for bcachefs it's hardcoded for the moment.
> > > > 
> > > > I don't think this is the ideal approach, though.
> > > > 
> > > > That means the folding rules are "whatever you got when you mkfs'd".
> > > > Think about what that means if you've got a fleet of machines, of
> > > > different ages, but all updated in sync: that's a really annoying way
> > > > for gremlins of the "why does this machine act differently" variety to
> > > > creep in.
> > > > 
> > > > What I'd prefer is for the unicode folding rules to be transparently and
> > > > automatically updated when the kernel is updated, so that behaviour
> > > > stays in sync. That would behave more the way users would expect.
> > > > 
> > > > But I only gave this real thought just over the past few days, and doing
> > > > this safely and correctly would require some fairly significant changes
> > > > to the way casefolding works.
> > > > 
> > > > We'd have to ensure that lookups via the case sensitive name always
> > > > works, even if the casefolding table the dirent was created with give
> > > > different results that the currently active casefolding table.
> > > > 
> > > > That would require storing two different "dirents" for each real dirent,
> > > > one normalized and one un-normalized, because we'd have to do an
> > > > un-normalized lookup if the normalized lookup fails (and vice versa).
> > > > Which should be completely fine from a performance POV, assuming we have
> > > > working negative dentries.
> > > > 
> > > > But, if the unicode folding rules are stable enough (and one would hope
> > > > they are), hopefully all this is a non-issue.
> > > > 
> > > > I'd have to gather more input from users of casefolding on other
> > > > filesystems before saying what our long term plans (if any) will be.
> > > 
> > > Wouldn't lookups via the case-sensitive name keep working even if the
> > > case-insensitivity rules change?  It's lookups via a case-insensitive name that
> > > could start producing different results.  Applications can depend on
> > > case-insensitive lookups being done in a certain way, so changing the
> > > case-insensitivity rules can be risky.
> > 
> > No, because right now on a case-insensitive filesystem we _only_ do the
> > lookup with the normalized name.
> > 
> > > Regardless, the long-term plan for the case-insensitivity rules should be to
> > > deprecate the current set of rules, which does Unicode normalization which is
> > > way overkill.  It should be replaced with a simple version of case-insensitivity
> > > that matches what FAT does.  And *possibly* also a version that matches what
> > > NTFS does (a u16 upcase_table[65536] indexed by UTF-16 coding units), if someone
> > > really needs that.
> > > 
> > > As far as I know, that was all that was really needed in the first place.
> > > 
> > > People misunderstood the problem as being about language support, rather than
> > > about compatibility with legacy filesystems.  And as a result they incorrectly
> > > decided they should do Unicode normalization, which is way too complex and has
> > > all sorts of weird properties.
> > 
> > Believe me, I do see the appeal of that.
> > 
> > One of the things I should really float with e.g. Valve is the
> > possibility of providing tooling/auditing to make it easy to fix
> > userspace code that's doing lookups that only work with casefolding.
> 
> This is not really about fixing userspace code that expects casefolding, or
> providing some form of stopgap there.
> 
> The main need there is Proton/Wine, which is a compat layer for Windows
> apps, which needs to pretend it's on NTFS and everything there expects
> casefolding to work.
> 
> No auditing/tooling required, we know the problem. It is unavoidable.

Does this boil all the way up to e.g. savegames?

I was imagining predetermined assets, where the name of the file would
be present in a compiled binary, and it's little more than a search and
replace. But would only work if it's present as a string literal.

> I agree with the calling about Unicode normalization being odd though, when
> I was implementing casefolding for bcachefs, I immediately thought it was a
> huge hammer to do full normalization for the intended purpose, and not just
> a big table...

Samba's historically wanted casefolding, and Windows casefolding is
Unicode (and it's full, not simple - mostly), so I'd expect that was the
other main driver.

I'm sure there's other odd corners besides just Samba where Windows
compatibility comes up, people cook up all kinds of strange things.
