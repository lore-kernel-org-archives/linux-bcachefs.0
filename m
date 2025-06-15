Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C74227452
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 04:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749960335; cv=none; b=VSne4FGjuV8NJRNmMVVkfrHye2REhmpPSZaTTSq33eih0tjfuAwOMNtzzZOLIphyrpoyyq7oaNSYGEI+PglTzX0Ocrs3W5d4eoQJpTprULncY7Sx9uCWhk9XW3frVxrOboQNBwhow32RwWglj2h7CXu79bOKVeAvtyjr9QokMJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749960335; c=relaxed/simple;
	bh=jw4qHmUOv7/xH8IQc7rIz3ysFecORuFuleU6A1wUUd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUzSZgevgdF52trO4nGT7aweI0CY+VWjg6cxFDll5cJBh2/jPrOfNdZnGr2yyublz/1kc11H5aF9zn21g+p/R9bDAKFSvcINlG6ArH07dObthoOmtX363/HaYkiF3WlL8ISVeqhYOvUX5Hi3ob5c4qUhBvq5TZydg0XLl5xYSVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lw/O55Bt; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lw/O55Bt"
Date: Sun, 15 Jun 2025 00:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749960330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzLFwetTi+Nbi+0Z0hteaMuJ78ybkMZ4x3/D+HcwB3o=;
	b=lw/O55BtzNDfNNkX6qH4BdoyFt1a5ojuRBkSs6vtZXuW66WLuTgXSTKAaGPoX+hlW1GlJq
	YhT/7+H5Pi+GujTTZel/pjsayBqRtE7e1PrDDlrO3WXJZQ5IdjTIcpVFb5z5EQtVGa4Bp7
	4ueB1Ht5RJy+mmiwuv8i0L+a7J+ASk8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aaron Friel <mayreply@aaronfriel.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Message-ID: <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
References: <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 15, 2025 at 03:02:47AM +0000, Aaron Friel wrote:
> Hey Kent,
> 
> I reported an issue on Reddit with bcachefs, attempting to set durability > 1 on an additional device in the pool. Not having the best luck!
> 
> https://www.reddit.com/r/bcachefs/comments/1lbpxvs/unable_to_set_durability_on_new_devices_segfault/
> 
> It looks like Fedora 42 is still on 6.14, so maybe this is fixed with
> a kernel bump or a new version of the tools? I hope so - would really
> like to make use of it for a tiered array.

It's a tools bug. Check if it's still happening with the latest tools,
and if it is I'll have a look.

Durability needs to be changed via sysfs, we don't have a commandline
tool for setting device options (and I suppose we should, for
consistency).

Also, reddit's been working out surprisingly well for bug reports, since
it's the place that gets the most engagement from users. Bug tracker is
still good for things that need to be filed so they don't get lost, but
it's been a pleasant surprise :)
