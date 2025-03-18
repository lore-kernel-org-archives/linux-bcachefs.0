Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D41990C7;
	Tue, 18 Mar 2025 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742278773; cv=none; b=PFXq8Y4aN/UsSYRTFAGLCzbviq37HDozXzIqbMY7UOUTfFRGRt9JdqtWXhvngwVTqwX+h4La/AFic8XB130ob6i//KZ47Izf8p7ylIwGWVWz3xamExLNMTWRKi+y+mw1L3FiVC7bara5gVd9fM7vopDknZxEMIbE7S+w7+fM1jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742278773; c=relaxed/simple;
	bh=UpxGUChqqtfdZ5LysT6nKnac+NwrU/BO/0z/bt8LTv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQbZ/Rap0ND+yd4EmtY1nQT4+tWBte65gCJG/76rQ1qDKdYhIAG5LVp68ATrlKubXoMOFyOgsDdvmR3UnsbOfCNT/pZ9bry7R4ctSTSJDI0pEoZxirxje5Dkzhl5sklw3J8pcyhQFVXchyLhh161Wx2p6hCywFWcmWQP122uJAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m0fQ4M3A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m0fQ4M3A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dMZedU8wf2ILezkBBgWGCWtIgmaZU+EG84FcrqdklwU=; b=m0fQ4M3AJcUygBjR9IFmrFHvnx
	rIarIKZu66t4z32Ce/6Fc+AQxyVf0PpORrKJh5VKfdJwR/+HZY04IlMrvazSG6bFiSQYF7HZtjjDn
	C581Lsev1Y344sIHOFDU4rnJpGnLrneu3+1FHhXNIYkogXDXrvzDp0abiAD3DIV/p/+AEjsvFyX2X
	2dM1H2DKHQOBwoNEt9ZNvXsunZtuzQ+NdTcskix2prEh4caUqYZQzrl5qV4yVJ3M4BGykTQk+XoSN
	nlfleIw9m8meKkxSEnZoaIPhvPCR0mzS+9+i4MPqdnn/KvoDEJ//5oxN9ys+2MV7F9CXxSHJPX5eg
	WK5L7Fvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tuQIV-00000004oRr-0893;
	Tue, 18 Mar 2025 06:19:31 +0000
Date: Mon, 17 Mar 2025 23:19:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9kQc6HtB05eFQd5@infradead.org>
References: <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <Z9hcpS64HDZUJ21c@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9hcpS64HDZUJ21c@kbusch-mbp.dhcp.thefacebook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 17, 2025 at 11:32:21AM -0600, Keith Busch wrote:
> I'm not even sure it makes sense to suspect the controller side, but the
> host side is considered reliable? If the media is in fact perfect, and
> if non-FUA read returns data that fails the checksum, wouldn't it be
> just as likely that the transport or host side is the problem?

From the error numbers we've seen it would in fact be much more likely
to be the host or transport side.

> Every
> NVMe SSD I've developered couldn't efficiently fill the PCIe tx-buffer
> directly from media (excluding Optane; RIP), so a read with or without
> FUA would stage the data in the very same controller-side DRAM.

Exactly.  It's an writeback+invalidate+reread operation.  A great
way to slow down the read, but it's not going to help you with
data recovery.
