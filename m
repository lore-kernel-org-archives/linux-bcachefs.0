Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8E71885A5
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Jul 2025 03:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752983951; cv=none; b=De3e6FYHGf0X9RRcDZk6UXTVn4GoVsw1hoOXmeHtyvou3LcDpXdYzjTRJGAfVqzqkdvhSYSqu63aEj2CnqGwPY30/cBD5jrf1seOvwm71aTFsnpfZgWoQghfiHiO12rrXpQWzjUG5NsXYBRWKAyzUVvSSV5TCEXd0oknPLf42kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752983951; c=relaxed/simple;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqACsC18AviEYPuPys8LqkVi3jSToQgjfGEPWY6KaGRHggpLIR8jGDDOZmC2Jm+6bGnQn3TIDVVFJWsPuP+44kHCxzS4alK8Mb798rJ++ycu96mm373cca/9uW7H6bLXB/ZZadaJIydTmirAb0t4SMSpiPnhbYO4i/0802SzgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cmK6IOM1; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cmK6IOM1"
Date: Sat, 19 Jul 2025 23:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752983944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	b=cmK6IOM1uc6aK3L3uDeT7kLarCZb9jc/bMgm3iwd2+sKgwH3MBG32q9g8JaiBAA+nGYLcB
	XVO9yCFeAu/OUR1pubXEmIKBn0T4KKBnzf5mbCHA9vLVOM5alS019QEby5K1MObfhqvhdt
	tIFuWl9oQUV48bUahh5gkgjLPq56tUE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+9b7e20f8ff98aed7254e@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request
 in __bch2_bkey_unpack_key
Message-ID: <kof6sydvzhjz37rqtfiiah7bop2pbyocuodhic73qkox2zndwf@ieowah26hqq7>
References: <6835d715.a70a0220.253bc2.00b9.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6835d715.a70a0220.253bc2.00b9.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Don't build aux search tree when still repairing node
