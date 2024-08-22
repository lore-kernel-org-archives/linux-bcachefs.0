Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367261CDFBF
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346196; cv=none; b=seF8/GEgzw2sn08bX5mptYi41ab1GMkmKY2ZMEv+hngDS/QveTxmPiuFbAJ+ljiGIiWt7a3DJ3swcvVbj5mKqoo7ogssbmu1j9KbEwUpRW2vWUTeiACY/QYwiAvsj3P9ci+XI/yg3GjqPhY8L0Aj4r0t/FuPcUhDIdM5w/CmS30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346196; c=relaxed/simple;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+whlW1taIg4LMJbEmUqc5u47IYcCBLnux/qw+0T+BCQ66zXb1yIBYc7rxfnFAV9CyxKW4y5o93PFl/yCasePJJY7MwIedL7yXyEgHzLcUJbYCf1fpdQn6qjyDhQBg10F1QArHzteYequCWkx5GLgHcg32NB9VeySIUsM/dYS+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T5kLeS14; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T5kLeS14"
Date: Thu, 22 Aug 2024 13:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724346193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	b=T5kLeS14AE075sUTQOX1iff1Sul5WCjlrRCbbte14+7g0DquSelP3vdlPtInxH+BXnpr1U
	W6wOLAT65f/2HpIW39kOYRpqHr9/zjikO7SaT6OAovNf/JU87JMeARWhY/qiS8v/KsjOk4
	2oBig5PSGRykBmOYGpqBLJUgzRk+mmU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+c816b9d76d3c2f738309@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in
 bch2_extent_crc_append
Message-ID: <h6clqqjhdqt246nwydv6ja2eyxmk7y2t5f3zlptkztarz7qffr@btx3eye7ccam>
References: <000000000000aa690a0619ea7b3d@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000aa690a0619ea7b3d@google.com>
X-Migadu-Flow: FLOW_OUT

#syz invalid
