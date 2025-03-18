Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51745C14;
	Tue, 18 Mar 2025 06:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742277664; cv=none; b=GX9L8gjhQwDbVxggLa3I4SaImhGoaeX/1mSx/wGfUYxF9EPzmVvKPFU/m9+HLrdPJn76xA2SSjw7KCRyfWW7VOY6g9KNmLogzVjH88uzNWP28oDSq1/azNqLO2AXs4/Hu2/Ue2GpsApLOUlI1tMFa8zyA3x02x7IuyWht6lsIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742277664; c=relaxed/simple;
	bh=sBvDidm+f/Zk6SNPR5RvNj3c+/NXkBmSyB/zysnefiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfZIM1VjiDQt4a5b8bY3UHaiD9tam2jRQ2jTH0QHP87jMzZd8boCLg07sBwSHGOBwtad5s0JXY6rmEP2fKgatJCk3Na006PfCGKtVnJpzQoaJ3NSHYBVxF0YssQyaVzbOkYQvMQOR/rLAfTu2Sy8HbBNSdeNdjraIC5stJmjSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vy1mMvCI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vy1mMvCI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8+0/n4Fqz8WcfMHj1anp1zEd+Kjfl2zSLZdlh19BhWM=; b=Vy1mMvCIR3DTI3ucbMWOhh/5jY
	/UjTq5H/K7Dy/980EAA0xfCfxuoHpULyJqdRx1IOHk+u26RGXG3qqwQAzg3ms2bqhWSjqM7YN62hw
	56Ft+YzxlxvW0RhwaviMgPgx5cojeNy1/Fkf12mj4D1xIPUrBKf80dMJiyNdgpBGOLhEvkQ27BUOZ
	PlTbpiBZW1ureZ3vYXMMfQFCfJJBy/4CLZBTEmEWvAVeS2VDazwx1qdnrS30VoOnRCfFeOBS5/P6q
	LFpyBsYwcEnNKOT8xII5ID6mMi1uD/oGTPz5Gp9atcuIIlS6cmyCwf+3RtzhygzD/lShHycMF7pD5
	/JNuit+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tuQ0c-00000004mDh-4512;
	Tue, 18 Mar 2025 06:01:02 +0000
Date: Mon, 17 Mar 2025 23:01:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9kMHlFfr1gJDPyS@infradead.org>
References: <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 17, 2025 at 08:15:51AM -0400, Kent Overstreet wrote:
> On Sun, Mar 16, 2025 at 11:00:20PM -0700, Christoph Hellwig wrote:
> > On Sat, Mar 15, 2025 at 02:41:33PM -0400, Kent Overstreet wrote:
> > > That's the sort of thing that process is supposed to avoid. To be clear,
> > > you and Christoph are the two reasons I've had to harp on process in the
> > > past - everyone else in the kernel has been fine.
> 
> ...
> 
> > In this case you very clearly misunderstood how the FUA bit works on
> > reads (and clearly documented that misunderstanding in the commit log).
> 
> FUA reads are clearly documented in the NVME spec.

They are, and the semantics are as multiple people pointed out very
different from what you claim they are in the commit message.

