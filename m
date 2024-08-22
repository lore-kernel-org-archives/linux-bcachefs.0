Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE681B28A
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724296031; cv=none; b=oR4olr7cxB0p+Fn7e0Q+hEoPK/uYHMeKaHIF0/dRyEcMp0Havw1kUecQryTWkks5ueuBKGAnRzKGcMRT1EtFSS6kI0QOpMpFOsV3nuCIRCz7QrnjYI+neCw0yIcarKXU3EKVj1ZK10EY/ENb8eD9wmBR9xVXTcW5iqO8dbP/lnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724296031; c=relaxed/simple;
	bh=o2dtl2JT6nrj+9GJIMSkKJjAr/7Xcve0erpuXfg/EDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDf7OJSIMKXXd9/SdLOk05qeuJGTxK7Y7DFgEvAvvIi+mLl4mu6USJnDNp8wVRQcZdQCbNLB8hCQmB7Ut4M+ecINkBHJRYMJTLfBsKHppjJrizoaBhv7WyZ0+j8O4FF+v/TtdO6ConuZ6T3mp5m4zDQdwTqatUrJh62GeI0qMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c8NnB9un; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c8NnB9un"
Date: Wed, 21 Aug 2024 23:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724296026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o2dtl2JT6nrj+9GJIMSkKJjAr/7Xcve0erpuXfg/EDs=;
	b=c8NnB9unkmWNH97qzvmj+YNQeTZ3BV3KNh59HK4alOx2VYkidL7DErk1H1/xuJgQH3kMkm
	dMfBG51+gFtGkvBG5siAfi07NgtwX4pM5fV/bCJzwPkFUZnZ1k5zwg45zZf0axF5UnIKRm
	hMS1Op9V7KcPMxwGVHbBG0HS9MmiFq8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+50bcc3c92dc2516c4ca7@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in __replicas_deltas_realloc
Message-ID: <thnmgxo6aa3zbxirxa2pkdmgcw6tl3hkgiijowzkhzxdfnsvzn@clwx5pjpghfs>
References: <0000000000007b5313061d7b897d@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000007b5313061d7b897d@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Disk space accounting rewrite
