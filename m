Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB602264A0
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Aug 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754405911; cv=none; b=BVMvACzSTdEoev1iiLr4VaBhPsdjHON/wAubTvxt6bsfzhwi0nvL0WK1wtGu7upRyIzu8apCFaS4H5oddPAghHhoT81ewlD7PM7/fqSGKVkOrP2ay+ULiNccezHr8jgrI49dVugVI2Jna1yShE546HjGu/SOrhlcxA0tQgaByEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754405911; c=relaxed/simple;
	bh=LQg6G3mFTry9w1G9BpuHp3BfPSNW7emXMSOrBTBGfjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4JwImdTftr+3LrKQVQ4Zc7QszLNpgKjIRmCMwomYWx1BnnPaQl0BYVqARitoder+ilCPUfQX4vTIhdpOEXmP770PKQNFDu2EI/wapY7fZHoAB/wqqdmmCdfBEOqvJdxuz/GyWGjsO/zq9XbtM1FwDYtUPrcMcE1enFBUCyb5L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WaK1XnyN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WaK1XnyN"
Date: Tue, 5 Aug 2025 10:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754405897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LQg6G3mFTry9w1G9BpuHp3BfPSNW7emXMSOrBTBGfjs=;
	b=WaK1XnyNeVL1M2DUTRZiAyTZxU4qoL2l8Qh07WxSjLGsuS1IovykRrfQ/JELrGzRXTXiN5
	uN+iMQ7+4W4IYFUUe2QeRO1rPyrcqcXUHhH+d+QrVFDmC6BT2IiWtqXe9y/u0CHvNwt75F
	PgATHonTNX7V5ccc2MtkLy68XnvqLU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+8f3825f100f660b04204@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in __bch2_err_trace
Message-ID: <mjzuxscbo5fo3ugow25hxbvgwkncocqurhz376qdgi7ec6rfe6@7gtdpp4pqq3t>
References: <6892033d.050a0220.7f033.0023.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6892033d.050a0220.7f033.0023.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Delete faulty read_only/nochanges check in fs_open()
