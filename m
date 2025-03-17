Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A718418EFD4;
	Mon, 17 Mar 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232744; cv=none; b=eftyXhiPQQF8ALdQHoPF8ckmyuYN3ZQKnB1wLJQYFcTqquucWs/l2kQv20BMN+a7lygaysFuqlYDwYxi7tyBdt/c6XYxIePcUzs+mbxrjyej6rbON3cZGMnts3W+BBQPgLX4bGQB/LS93Pg7X0qUc7gXO/6zQptpD1x9af6LLps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232744; c=relaxed/simple;
	bh=AjWJoCR6EvWimJacmp0+Bq30yU+x6T8HEqTzBbemVvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEzK+XBHUo2YBAXohWv4wroebpoM8YVUcLngTJ2Ogih+h322OkKzFnCdWkXm9DV/lW5QjKXIqL60CpHvMzfawD5kteOseyDp7NzTiHcworfAgrQtnxnJm/2jWKyJdxe3McCMLA+yN5iSZ928kLq7SSH+8T1ouv+QqWqu0tKswac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKs3zXvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKs3zXvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC1C4CEE3;
	Mon, 17 Mar 2025 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742232744;
	bh=AjWJoCR6EvWimJacmp0+Bq30yU+x6T8HEqTzBbemVvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qKs3zXvYw3b925F1ZFXUUdisyj4ItRVxH7Vs9sE5GdATw/ODMR26lH1v+34WcL9qj
	 s5U2uPl0a44w0I5JBaJYybwb6tq9QpajnA6952GtmhD/HTgUv1Py1bMH7O5qPvlqZf
	 h7cHXju0b4WWQSUqSZDjIWsxhGuc7DIgkDWcAfKBs3lyDZKyL301an8+OGcZwdX2h/
	 fzSeBAgbU8RerCOgfe0Js/C67xr/nT02YJFeVMCJSr5lan5uDaW+I6KQORAvIdJ76G
	 uhsicd69sYA3t2pw9pBZvNth9SWdIaOOhsD8RbFtcUVJmoaqzzllBw9giVZhdzq0IJ
	 N7DLHJiU1aJ+g==
Date: Mon, 17 Mar 2025 11:32:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9hcpS64HDZUJ21c@kbusch-mbp.dhcp.thefacebook.com>
References: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>

On Mon, Mar 17, 2025 at 11:30:13AM -0400, Martin K. Petersen wrote:
> Kent is trying to address a scenario in which data in the cache is
> imperfect and the data on media is reliable. SCSI did not consider such
> a scenario because the entire access model would be fundamentally broken
> if cache contents couldn't be trusted.

I'm not even sure it makes sense to suspect the controller side, but the
host side is considered reliable? If the media is in fact perfect, and
if non-FUA read returns data that fails the checksum, wouldn't it be
just as likely that the transport or host side is the problem? Every
NVMe SSD I've developered couldn't efficiently fill the PCIe tx-buffer
directly from media (excluding Optane; RIP), so a read with or without
FUA would stage the data in the very same controller-side DRAM.
