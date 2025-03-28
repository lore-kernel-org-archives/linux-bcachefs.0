Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237815FEE6
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Mar 2025 15:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176911; cv=none; b=VQViKYTmcpCglJ2TktfS3xiT7kY8Jjjg9LjAQ7EFOeMvljUrsczOhDbJKjGNrJvh9rYvnK32wugbNfo3V+XDO7LCNKzaLsyfSv/VjD5cJj6ReCC12d/NDIGvaLfzMRx3ykVbZ+aMw19+lbp9DCA/hvHg09CzqfKX8ENXmRaW/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176911; c=relaxed/simple;
	bh=/1EXUcnEzRipk1mkzFu009xvcPfXe0nSr81MdlJpBTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBPsgll/OQuveVNtroOzPCd8ZLd3ziMEETk8dqS0xagWsaBhfPQCNZlshI56V5B/YNEdnM5yMz+VgvlzW+OAZl3FJFrElzWLACmaeADZPYXMtiRghO0ltHok95xCH4k7xQyVdQ9ErMPxfsQL3BaWLDNkQkEMI0DeZWwXXxHq+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tHg5laPe; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tHg5laPe"
Date: Fri, 28 Mar 2025 11:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743176896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wY2rJ58CuGhHvpCweL3K5CZDmMKrY2RaGPFz90RJmzg=;
	b=tHg5laPeCVbttwGqKM8rvmBG8YWbzFkj6NvM98oCXflUk7cfi/rkjdYrF52oBO2ihBHUdQ
	OtGWM2sJB2h3J/zx1086V7uapv1LccjoUVc6ZTc5lFaQSscnny0iCmq60fN9pAx/I3UcVL
	RCH5a2B5i7IcOgbcnmWhaSOrOokemcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, tech-board-discuss@lists.linux.dev
Subject: Re: [GIT PULL] bcachefs for 6.15, v2...
Message-ID: <ighuwxny4a3obxwbmfsblz4lzpc2qubqqu4nqf6yvqsttuqffc@hs2tbqrwjo4v>
References: <wg47lanrvfqkqdospive4b3ymc5snuhqdygcle33q3cxudw3xl@rkllblbmre4v>
 <5b02fcfedcd006d202d38e2ec16b477919264408.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b02fcfedcd006d202d38e2ec16b477919264408.camel@HansenPartnership.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 04:46:21PM -0400, James Bottomley wrote:
> On Mon, 2025-03-24 at 14:56 -0400, Kent Overstreet wrote:
> > The following changes since commit
> > 1a2b74d0a2a46c219b25fdb0efcf9cd7f55cfe5e:
> > 
> >   bcachefs: fix build on 32 bit in get_random_u64_below() (2025-03-14
> > 19:45:54 -0400)
> > 
> > are available in the Git repository at:
> > 
> >   git://evilpiepirate.org/bcachefs.git tags/bcachefs-2025-03-24
> > 
> > for you to fetch changes up to
> > d8bdc8daac1d1b0a4efb1ecc69bef4eb4fc5e050:
> > 
> >   bcachefs: Kill unnecessary bch2_dev_usage_read() (2025-03-24
> > 09:50:37 -0400)
> > 
> > ----------------------------------------------------------------
> > bcachefs updates for 6.15
> 
> I note that the controversial block changes that got NAK'd but which
> you tried to put into your first pull request are now removed from this
> v2 pull request, thanks.
> 
> I also thought it was time to state more formally what's been
> circulating around a few maintainers as shared knowledge: any tree you
> send a pull request for that includes changes outside of bcachefs won't
> be accepted by Linus.

We had a situation where the process clearly broke down in -block, and I
opted to let Linus make the call (knowing he'd already been CC'd on the
previous thread).
