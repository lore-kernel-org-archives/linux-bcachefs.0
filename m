Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2429813CFB6
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Sep 2024 10:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725617550; cv=none; b=ll8P6ScCdjqBi++J7/FFlpDnmDrqayGyxRmib09iVmyJgJpwYQVJ7MBhxKFAHDMFGn9oAfTpwPKr+/rLXJw5jkrU2BQ8NyCK42Q1sfLhq3gH41sKrHPtYzm1AwQzNJ+knWOJXzz1n1SyUW7C4Mtykk1QGsRyV4AxypZFuWlg/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725617550; c=relaxed/simple;
	bh=TOC4CcFbLEj/vpwqcWwoeaFF7kNPf7VLZZ2NdNiuko4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Efks8HoQRj3xmBT6/ef5L6mTpfMdySVutE5Q8Joz1NKYRzwmElKWmBth0++xFRwvaZ2fGg41IJTvPx13a7NpYda1r/B1Xqflx3M9rTLGhyIxaDlZyh36/tIQcq6IcwluUbIFSEdTIrbmBMbf4WZP/TwyyKUfTQ2Kb7R9LSZeGFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GdzHCf4d; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GdzHCf4d"
Date: Fri, 6 Sep 2024 06:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725617544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zNuPmzz4xYBPuROeNW2jBZZ/AakkUGXSmJQVuDxnntA=;
	b=GdzHCf4d6L0pJI/sy5DvI/t9jeFYSLGLnI7qc/P6og3S1hCOAZ1H1OPtcgpUb+PHlmzXZ/
	9COnbjtTTE9RIcBJ7EI7/gkPnfFxYFjJ/U/wHNN2UPpl60xMKd1J6lQ1EO9XBpYaIqzFzQ
	yzsyKKAmuQ13RA+yLH1M6vONdkqWyl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Petr Vorel <pvorel@suse.cz>
Cc: Martin Doucha <mdoucha@suse.cz>, ltp@lists.linux.it, 
	Li Wang <liwang@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [LTP] [PATCH 2/2] fallocate05: Deallocate whole file on bcachefs
Message-ID: <gmjff4tugu3ccio35isd4jfdbvxmriepvd3z2vxruzw46zcpha@7mk7g3awjgw5>
References: <20240905134502.33759-1-mdoucha@suse.cz>
 <20240905134502.33759-2-mdoucha@suse.cz>
 <20240906080200.GA985598@pevik>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906080200.GA985598@pevik>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 06, 2024 at 10:02:00AM GMT, Petr Vorel wrote:
> Hi Martin, all,
> 
> [ Cc Kent and Bcachefs ML ]
> 
> > The default deallocation size is likely too small for bcachefs
> > to actually release the blocks. Since it is also a copy-on-write
> > filesystem, deallocated the whole file like on Btrfs.
> 
> Make sense.
> Reviewed-by: Petr Vorel <pvorel@suse.cz>

I haven't looked at this specific test, but one thing that we run into
with the weird CoW behaviour tests in xfstests is that bcachefs btree
nodes are 256k by default - you're going to see weird effects from that
if tests are looking at disk usage.
