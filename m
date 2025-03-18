Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387061DF240
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 21:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742333629; cv=none; b=GRQM+bcWTQoL7P593BZArCBghehgxupjPYkJdWb2i6Z3h/WErpYNo42PO7lHJBAZ6eg20nbU5zfwpeG6MJDe6qiWiCSyFPM0y3kMqFcd+uGeDQKmk74NuIkWBxWRpKSDdRFV2FWvi12M+WiilQXdeTEb0a8tWnx5qqP0NtbXOCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742333629; c=relaxed/simple;
	bh=yPrACEXC0AHNwx5w8YYzWO946MVzQgap67C/sXvWWB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGjG/B926TlmenbjmLw0YQRemEArpx5gE/UQC8OcSHBrSPP5aXuelkH74sbT71hQ1KXFX/RPJYokCYs41l6d6fVnjMei4f1dg3SgqHH0EO/Y9kh4PiuI8RV4IfSO+t/9TOSbdrJODgHyLuEcwg6SlttlbknyuZdDlJI7JcSA7vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NeJRFR//; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NeJRFR//"
Date: Tue, 18 Mar 2025 17:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742333624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wJkM1Kqmtkvq+hbyPWsnAEsKOLS1w1MOE/fS1Wi5N8M=;
	b=NeJRFR//a4kY9xCZ2bo9CgpVfP8jsapNnDqs/dNinrQRzE/MZ+Gcg62QE09oKfxkIe0J/1
	+v5SAZzdL9va0z1GCTV6ulbyt0uWam0uFuLamPlryujuTlcL99UXENMVMeKELGVXMCGtzf
	ICeJZKorqnXTDvdSjqN3e9qlvpmUfbs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <y46xnqnnltwz3y6b5rvepn4gqivkksoszn2ktjts4jlkqgmjqq@qoaq2fb5ayu2>
References: <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9kOftZAZgQYYMU6@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9kOftZAZgQYYMU6@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 11:11:10PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 17, 2025 at 02:21:29PM -0400, Kent Overstreet wrote:
> > Beyond making sure that retries go to the physical media, there's "retry
> > level" in the NVME spec which needs to be plumbed, and that one will be
> > particularly useful in multi device scenarios. (Crank retry level up
> > or down based on whether we can retry from different devices).
> 
> The read recovery level is to reduce the amount or intensity of read
> retries, not to increase it so that workloads that have multiple sources
> for data aren't stalled by the sometimes extremely long read recovery.
> You won't really find much hardware that actually implements it.
> 
> As a little background: The read recovery level was added as part of the
> predictive latency mode and originally tied to the (now heavily deprecated
> and never implemented in scale) NVM sets.  Yours truly successfully
> argued that they should not be tied to NVM sets and helped to make them
> more generic, but the there was basically no uptake of the read recovery
> level, with or without NVM sets.

Well, if it can't be set per IO, that makes it fairly useless.

If it _was_ per IO it'd be dead easy to slot into bcachefs, the tracking
of IO/checksum errors in a replicated/erasure coded extent is
sophisticated enough to easily accommodate things like this (mainly you
need to know when submitting - do we have additional retries? and then
when you get an error, you don't want count it if it was "fast fail").
