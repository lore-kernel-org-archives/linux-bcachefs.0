Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7CC225AE
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709861002; cv=none; b=Y3HQmO4zbWyi3DnnU6WojrnTPt7z8Zbx67J1raDSnee5x1Pn7SQ2RiAlJv4Cb4QlD4bAsprttImTJf5DS6WI/X8LBNrEq14q9IM/ZfDUkSMBP0DjotFtNN9cF8IYpyW8Eik4SXFvZmkMcvBi+msI3ivGMBg3AY8V9NeeMYsSy2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709861002; c=relaxed/simple;
	bh=sJOle0TfUYxstKMgel09TJ/kKsb8xMMTr/mLtucUaSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPPPRsoSiOC0zT7CcuJk5+4DH8rifvAez5AslU+PdRxC3edIfi81LbRBTFF3Y/4qZaSAYjCSleYutW32RAr5oZp6MrakBe3fmGbNObilbj0KMc7ymaN1FmWRbfD1lr46WTsbqW/pnIDu5mxXWQE/HUAanSyMb/tEpykJgHycRGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcHYIM/w; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcHYIM/w"
Date: Thu, 7 Mar 2024 20:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709860997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJQ3m4N05abn6Lu9DecctEL6PUVe4ZuIOPNH8h68ytc=;
	b=bcHYIM/wxrT08IZqcMRbcTBVh5DXRPinmr5C0d9iv8fSRxVDGlo1OBxTE1xKq+KydfILvl
	A+0PtcRnT5OBJ4TS3zHs7PoEc4FOh1/cs0hN8Gl5ZPsrcjX1tfbsvOlecD45BLcDc7mSfV
	ppJjWuN3gD0xdjZKnIPCSycUfc2J84U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [WIP] bcachefs fs usage update
Message-ID: <iloqkrwanqljkorf3tky4rskjqpnl4zqqklejjf3w3gfu3ezjp@uwr2xwhscjlz>
References: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 11:14:45AM +0000, Mike Fleetwood wrote:
> On 2024-03-02 04:14, Kent Overstreet wrote:
> > I'm currently updating the 'bcachefs fs usage' command for the disk
> > accounting rewrite, and looking for suggestions on any improements we
> > could make - ways to present the output that would be clearer and more
> > useful, possibly ideas on on new things to count...
> 
> [Sorry for any email thread butchering.  I've only just subscribed to
> the list and seen this in the archive.]
> 
> Background:
> I'm working on adding some level of support for bcachefs into GParted.
> It wants to be able to report the FS usage (per device) of a file system
> to (1) display in the UI, and (2) to limit how small it allows a
> partition to be shrunk.  (I understand that bcachefs doesn't currently
> support shrinking devices).
> 
> What I would like from bcache fs usage is:
> 1. To be able to get free and capacity figures for a device in an
>    unmounted bcachefs file system.
>    EG:
>    bcachefs fs usage /dev/$PTN

that'll take some work, but should be doable

> 2. To continue to be able to get free and capacity figures in bytes.
>    Using a command line switch is okay.

json output?
