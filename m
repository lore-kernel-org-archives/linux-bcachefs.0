Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6DA13B284
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Aug 2025 02:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754015306; cv=none; b=EFZqQyMV0LCp4WPPeU0CMhAVPKYXdC7sNLRrufcdLHZGV/AmULKkFsIMvuD9e87tcqUoma7oOhKuOYmrh2SMV4XNxmTi+DnDzZ2yYEG9PrMGDikeBPGFNImY5KX1kiUpLaj7mJMXu+xVuxF3BIgylVxlRuiFKKtP/Dswb9UntoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754015306; c=relaxed/simple;
	bh=/3xjHgGqoX9LXDA7FW8p5jRMwAaUxAk/bT5pxxzHXpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQAKJzScWJXQ2NhXzPqEQsKAXA30DuMB7Hm2wazV7MTO9NHx02+nKUu2EgbpzjmbSvBtrrQ8az/vNl3bkNcSgmfPaiK8NkuWgNCkDMqPexoLVcCDNBaOvO/1ARe4g6biOQO+Df6fG2je+7TUJfkq4LJEW5my/XJ3stOWp3dIwB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E0nHAjRY; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E0nHAjRY"
Date: Thu, 31 Jul 2025 22:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754015291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qATfYxkJ2lUUcIMB1+MnAKkLf+MKdiD0hrn8yfGwNc=;
	b=E0nHAjRYNPGoQVEt0y5uHcD9xGCGZr2/IPkrjvtE64nf0KFkpEwpgGo/8+Z/z+hFfaP5If
	p+oPNa+EODCPvWmiwDLhVc/qfKeoKurJLY10AcisdTD66xaFZNv2xv6ABWkR6oA5Dzjmv1
	AnCtXcnb4Xck9v8hUoM713Pe+7481b0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-bcachefs@vger.kernel.org, Liao Yuanhong <liaoyuanhong@vivo.com>, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: Simplify kzalloc usage
Message-ID: <hu5y7xoxtx6sqk6vegszx3jgngmu2pvqbscmk6hok3du6qrkr7@26zo2k73o5b2>
References: <20250731131551.218666-1-liaoyuanhong@vivo.com>
 <32fbb160-4888-4d57-bd16-62ece192e81c@web.de>
 <ztnjjzlx3a2cvmxnc3jx2umwlh2faetdy6rzhmuc746vppmuns@lzn33bv2smpz>
 <a3860880-acfb-41cc-98dd-0d878d9b37dd@web.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3860880-acfb-41cc-98dd-0d878d9b37dd@web.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 31, 2025 at 10:00:31PM +0200, Markus Elfring wrote:
> >>> Use the shorter variants will improves further maintainability. 
> >>> Convenient for subsequent code updates or refactoring.
> >>
> >> Please improve such a change description.
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16#n45
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.16#n941
> > 
> > The commit message is reasonable, it communicates the intent.
> 
> * I would wonder about the relevance of a shorter item here.
> 
> * Would you like to avoid wording weaknesses?
> 
> 
> Another example for previous contributions:
> https://lore.kernel.org/all/?q=%22Improve%20size%20determinations%22
> 
> 
> > I haven't decided if I want to apply it; the dereference approach is
> > better in principle but it's very far off into the weeds of "things that
> > will never, ever cause an actual problem".
> 
> Have you got development views which might be in contradiction
> to the preferred Linux coding style?

Marcus, I believe you've been warned in other subsystems, by other
maintainers - you need to cut this out. I decide what's acceptable for
patches to bcachefs, not you :)
