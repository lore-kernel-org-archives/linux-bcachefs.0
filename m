Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3527B218E96
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742224950; cv=none; b=nnOq7lyucpWnuoXkPSZ39MK2eIlL1HvDMUTmT2XpXF09fyEo2YkxcDcH7RiJsbHetX5i1FzWGnaPxC0ZYDYL8bMl4nQhrHm78eOn8sQO40WMUJ+fNRjjBWHH1GmcjIR2wzFAEaOKbGi4ClIa0j9nZ9Z+2jULZgxceztKMRO+FV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742224950; c=relaxed/simple;
	bh=/3U2fSE64qzk1eoSDBneJHmrMk4WHhchS3rSZ3Yq7/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5A2aQ16svtYQzOJUASgpp49mQhrr29DIBp9ahNV2sRj10tTNenZwQPHscBSbvH63bzzW8eRQsiF/8uPUEnyrvdtuvw2bnwhDcV9QmdXlZzKAiJKz1A7+8KiOi5cwg7/7YomMs5II6+j27HdBUP7BT5I2jSy1liuV2fLIvPj0Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tNQROqHb; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tNQROqHb"
Date: Mon, 17 Mar 2025 11:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742224936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QcIsuYBz+55ESZ1hBvmbeg1/Wn+/VrbfBkZhBx7J4SE=;
	b=tNQROqHbjmHa57fHutK+TRSjwAbvmLnIAbDMlykrWXCcjQ/5Sqg6N/vzCRC2+Mlh+gKdII
	XI3EaiWW3Rk3hVn444DPLVVjlSFm0d6xHWwLT7Gy9JhOWR1QVdwEU8Q9QrJmKO24bxdSJT
	VB29cFf1BH1p2Ali/DSBc5i5JzUB5W4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <esal7jywq7ft5krza556nfz5arzq4og4hwqggxuto3myus6rju@24mee7zxctgh>
References: <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <ro2padvzarj6v2bsh6xlsz36qs67z6ubomsvaw77dw4elfqqu7@4acij7zk6g7z>
 <Z9g8eO4Ngvagw2XP@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9g8eO4Ngvagw2XP@kbusch-mbp.dhcp.thefacebook.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 09:15:04AM -0600, Keith Busch wrote:
> On Mon, Mar 17, 2025 at 10:49:55AM -0400, Kent Overstreet wrote:
> > But we do absolutely require checking for transient read errors, and we
> > will miss things and corrupt data unnecessarily without FUA reads that
> > bypass the controller cache.
> 
> Read FUA doesn't "bypass the controller cache". This is a "flush cache
> first, then read the result" operation. That description seems
> consistent for nvme, ata, and scsi.

Quoting from your previous email,

> 2) read the data and metadata, if any, from non-volatile medium.

That's pretty specific.
 
> You are only interested in the case where the read doesn't overlap with
> any dirty cache, so the "flush" part isn't a factor. Okay fine, but I'm
> still curious if you have actually seen a case where read data was
> corrupt in cache but correct with FUA?

No.

It's completely typical and expected to code defensively against errors
which we have not observed but know are possible.

Is bit corruption possible in the device cache? You betcha, it's
hardware.

Are we going to have to test for correct implementation of READ|FUA in
the future? Given all the devices that don't even get flushes right,
again yes.

Are we still going to go ahead and do it? Yes, and I'd even say it's a
prerequisite for complaining to manufacturers that don't get this right.
