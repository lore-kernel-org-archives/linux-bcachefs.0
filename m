Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287AC1DD0C7;
	Tue, 18 Mar 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742278273; cv=none; b=TRnX1RzebLTUplSd+13tKmZiG35yXZAyktVDQMZg7RftJmasX3HcADen1ZhCmJTRSflQf2Ek8gF89PHXvihdaqBYfsj8F9aIj2ldDQjFRe1s+ZwGtQA92SOSNev5slaIYcG9WM06/kvwUi5tqkDc7uLGeQFavOoKP1WQ0ldpITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742278273; c=relaxed/simple;
	bh=AYhdRpESyHliar08/H9SYO0fnXcEcBBpb1JsxDJmJIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQzr1YLVd9IvyrMVHq+TtSIDxFxuvYX4U/9noB1qSsEtD4OTTKKeN6fcqBGSNKk+pXgabqXIyxELCgAkL12UDDaxsyC5INZEYTiksog0y19JGzKiOuUuJ1boX9S3bE/nA1Otrf3he6/zZQHB1t0w5Lw1GzN+UvYWXYMFT64BegI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HA56rQrX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HA56rQrX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N7YZXKEvDAuD54xVo0dtQ0rCi8RxTCj+Bh6oB8eIdOE=; b=HA56rQrXFyjiHE1ONmgw8/pmN3
	mDnJgRrhC4HekbDTUNtFyPsO7AFvmYDV3GGTk4tBcvmJBAaqHWeyJuUZwJ0gyQwnP4oKmrCmR+FaR
	TavG04W3m9AWMqu6pI3mafsrG/p5AgrQosdoiv4N7x4J/SvjSo6di5B2O72ArhmRKumiZfue1PT7F
	3HSIi47nb4S+k/Y07p5XbScgepCqS+mX84FLfzhtnQ39IP1bk7SFrIlVhoq77nGO03znudX2q+ApT
	9+ZkhugEX0BAm/oAyZOFgSWX0g2mSBuey2xBkVoIKfTeQLu/LevsXB2wBM5Y7OqYeKmXOP3ZYJfMv
	UpJRFj9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tuQAQ-00000004nHG-0aIW;
	Tue, 18 Mar 2025 06:11:10 +0000
Date: Mon, 17 Mar 2025 23:11:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9kOftZAZgQYYMU6@infradead.org>
References: <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 17, 2025 at 02:21:29PM -0400, Kent Overstreet wrote:
> Beyond making sure that retries go to the physical media, there's "retry
> level" in the NVME spec which needs to be plumbed, and that one will be
> particularly useful in multi device scenarios. (Crank retry level up
> or down based on whether we can retry from different devices).

The read recovery level is to reduce the amount or intensity of read
retries, not to increase it so that workloads that have multiple sources
for data aren't stalled by the sometimes extremely long read recovery.
You won't really find much hardware that actually implements it.

As a little background: The read recovery level was added as part of the
predictive latency mode and originally tied to the (now heavily deprecated
and never implemented in scale) NVM sets.  Yours truly successfully
argued that they should not be tied to NVM sets and helped to make them
more generic, but the there was basically no uptake of the read recovery
level, with or without NVM sets.

> But we've got to start somewhere, and given that the spec says "bypass
> the cache"

But as people have been telling you multiple times that is not what any
of the specs says.

> - that looks like the place to start. If devices don't
> support the behaviour we want today, then nudging the drive
> manufacturers to support it is infinitely saner than getting a whole
> nother bit plumbed through the NVME standard, especially given that the
> letter of the spec does describe exactly what we want.

That assumes that anyone but you actually agrees with your definition
of sane behavior.  I don't think you've been overly successful on
selling anyone on that idea so far.  Selling the hardware people on it
will be even harder given that the "cache" really usually is not a
cache but an integral part of the data path.

