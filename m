Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227463AC01
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 04:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724300960; cv=none; b=LImnyETwacFBdkYk4HpJVijnCOWZnZmJGPsrCn0lS6fF0ebQPZxH6Q6V7RdpEXNJxcpteRBfA6H+NH+Lf8V7zEcgH0FLQZ+IEKjkxFY9rjIvwHzHpDsi0sb4rYFf71py3Q4p8xSTIcvmpWBCpQ/33kUiT6kXBS04lF0x7vdMaGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724300960; c=relaxed/simple;
	bh=VBVn1UNVB9UR9KxUA0zU5lBMMkeFmjLunVz7PUtOHKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVDiuskcN9r0Pxl3hhyP5g66A9BEQOZFtvvaAapWxt/Yg1CmExtJo+DBxsjJ/MYm4WyQ1x3xnmmDvziKbvsiFwPCzoyq5nyr8GZkizFiGHCwVS061Gx4OMqWZ0pctxBJaVQiRFgSqRzgnuuOpICQ6juXWIodvB9Z0+yv57MTRj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UMjTRSvS; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UMjTRSvS"
Date: Thu, 22 Aug 2024 00:29:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724300956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBVn1UNVB9UR9KxUA0zU5lBMMkeFmjLunVz7PUtOHKE=;
	b=UMjTRSvS1xKGJE6oAjaxj2RN5TaRex/j6gcyMvgMSs4R3i1jnFEvArCOP4kieMbrF5NNbD
	SnDwsJA9LeAgH1fhjvlg8qNlhrsMcGBGgUPg+v8JWTa5ipLKUImBusRobzaedIiWvNfiGR
	en6JaVqcqZzNMvpbQVA6om82NEraurQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+46405fa9afa07e6c8c40@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] BUG: MAX_LOCK_DEPTH too low! (4)
Message-ID: <wyilin4upo2najlktypsy2seqkass7y6vewjdkf743pzndyu6d@yrw6nlqqkyv7>
References: <000000000000071b6f0617ec3c17@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000071b6f0617ec3c17@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Add lockdep support for btree node locks
