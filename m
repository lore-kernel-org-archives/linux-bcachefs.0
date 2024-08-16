Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E751BDA94
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723826582; cv=none; b=lB189fOJBG+haxF4nt6ZTSfhXLK8bMrY1sH5/f7t/7eFpuHkvCBH2N9mjVsJiskWPJV6OSacSFFKBIESOJ/xS1Gnwl2Nx79j85KWfTEdyt1ONvYTwwBdKPWzgY56C2td95KzuPE0xd/5H8IdOzxBf55NEhEtwk7cgd244YLp63k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723826582; c=relaxed/simple;
	bh=kTLEHma0Q3tj6PJzKGWUCOutTgWuNN0tPuA3BXU2FcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIuLxnsN3mJDq40mzd2XaFpa/5EU9J1u3wJM6/FHBM0JFswc0XteHAMRyZ1+S3EQeSpuVJ2a121eRDcVwUeKFxJ+WboXNcVudtofbhBiz3kNHJ0raHbuRKUD7hQoDlObqhPZRKesF2sJvVEXKWq6ZRapgxNCIhfpqwS+rGAtf+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZetMNYws; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZetMNYws"
Date: Fri, 16 Aug 2024 12:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723826578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kTLEHma0Q3tj6PJzKGWUCOutTgWuNN0tPuA3BXU2FcE=;
	b=ZetMNYwsSTI4BgY+/rxTwz379j60P+SMxm9p6vwSlvh0xIkt0nC02B5AUl13uBaWIAFKwq
	2OT+I5C+RIJTz9MuYaK/eSGU9+mGvyBw5R2MJIq2mUGgKjm8+NAZUj0iay3hriDFpX1VEN
	YEkCJOkNXAo82ilF1drFp1uHLzxauCI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+510b0b28f8e6de64d307@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_lru_change (2)
Message-ID: <w3pgidwadxzj6cp2d46hstxxkxwr343nx2slgqlbysbariypdo@s5ylkeipdgth>
References: <0000000000005ee2e9061fc9e38c@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005ee2e9061fc9e38c@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: avoid overflowing LRU_TIME_BITS for cached data lru
