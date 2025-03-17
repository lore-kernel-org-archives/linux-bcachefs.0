Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2303BBF0;
	Mon, 17 Mar 2025 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742191223; cv=none; b=gHqGQTOi4954SK6YPYo4GvV0+7WR4pHak9rXeNqWlCGLpOFlfeBFoQfqGxdQ6xsYBtY065XGLWXmm1ceNl2nP2Ed/gsJGYdFE1VXdYpM9lmHq4GTbfUtadq2NMy/HRfxBzpZl1FXmWLbcTMcu4OICpGj00Cn/H+7rvBN+7qniGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742191223; c=relaxed/simple;
	bh=HYMjdZynXD+SaKqnHwIsdGzmxPdoD5zqSm3a6FLsnhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvwNCLv+/EVyHPR4C5p/94Vd5OgcvBTrHYVmNxpsOYXidCIlaIgK6dCyVKjZaKEbYe/ut8TwmcouIpnL7IqDbxIWo345eJJNA40GWYt2je73JauRfMriCh0YacpzTVotI4P81V+dz1xP2WeaXaq4BiVotS17m1BTurAkHskVP54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NirtVxUH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NirtVxUH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E6/1EgeeNI6LPJIra80vLPIcvTCIfeWl0FS26UuI8Co=; b=NirtVxUHZkITf73QYu2N4DVzTn
	U2lipxL4KhrGqKNVT0/HyjRXi0tb/29Ox+uD+WuTcM/DWMX3JkJLw7IdO/qijqkrtW4HF5X09L5OM
	8IDK4R5Ae/DunjaKIKFMdMZXeph8RiQPGkicPPqOOdqLMwHPEiRo51O5hZJ6vJwCtCSIxxYrfCUBC
	WoJwvt7viQzVmzfeA6G5vfqXIWOmFg3NlRNIl0K2tacY9/dxo05R8Mo9It0GnWdq6gTPP0sFX2PAB
	/MGtotIg2f9UR7OnwceyBuPHtbmHfTDiBdZ5/E5/EiGNbMeY7D+ac8p80F92LXxV02Fq8gGTEumU9
	zHyA5U+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3WO-00000001K5A-2amo;
	Mon, 17 Mar 2025 06:00:20 +0000
Date: Sun, 16 Mar 2025 23:00:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org,
	linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9e6dFm_qtW29sVe@infradead.org>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
 <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Mar 15, 2025 at 02:41:33PM -0400, Kent Overstreet wrote:
> That's the sort of thing that process is supposed to avoid. To be clear,
> you and Christoph are the two reasons I've had to harp on process in the
> past - everyone else in the kernel has been fine.

Kent, stop those attacks.  Maybe your patches are just simply not
correct?  Sometimes that might be on the eye of the beholder when it
is about code structure, but in may cases they simply are objectively
broken.

In this case you very clearly misunderstood how the FUA bit works on
reads (and clearly documented that misunderstanding in the commit log).
You've had multiple people explain to you how it is wrong, and the
maintainer reject it for that reason.  What other amount of arguments
to you want?  If you need another one: FUA is not just use NVMe and
SCSI where it is supported on reads even if not in the way you think,
but also for all kinds of other protocols.  Even if we ended up thinking
REQ_FUA on reads is a good idea (and so far no one but you does) you'd
need to audit all these to check if the behavior is valid, and most
likely add a per-driver opt-in.  But so far you've not even tried to
make the use case for your feature.

> As I said before, I'm not trying to bypass you without communicating -
> but this has gone completely off the rails.

You have a very clear pattern where you assume you're perfect, everyone
else is stupid and thus must be overridden.  Most people (including me
recently) have mostly given up arguing with your because it's so
fruitless.  Maybe we shouldn't have because that just seem to reaffirm
you in your personal universe.
