Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018A12E36F7
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 19:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752952661; cv=none; b=qXL1e1YMj/j5CpfGGSCrqOhHoywn7Bk9QVlu+9eeo5xQ5jzjp0hvTdsiT6FUPvBV/VSSAVT7cTvENkTmAU1HseEcsRVmUD60SssTOMwQmo7IYDXlcqh4EhhhEwocatgxx9r6Y4YY58SRZz9tMONIA+NJpkyKbtf/WxyFJnn4ALE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752952661; c=relaxed/simple;
	bh=OL4UjvTVM/5x3bsVR+xXj20LtMQMJDkHAGwOkWiiy+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZYj0SNv5ZVCYEsyGUnBr4QEsCHBwLavvvlNA/8TU5Gk8UAnYzNIvE0rSwMddGsQuw/yd6VHrlSRiMbogqhOkfn7FiQkGxA4c8MheYLA2MZXrm63i5uWYBzuyv/MQVIFl5GM3lvb4A+pzVKHfkJtBQCA930csYmjPWBSW+zadoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WZV7gaOr; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WZV7gaOr"
Date: Sat, 19 Jul 2025 15:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752952654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OL4UjvTVM/5x3bsVR+xXj20LtMQMJDkHAGwOkWiiy+E=;
	b=WZV7gaOrsf1Lte1xGsV4PUBGempj/s1tAsaP0akAEuEOifkVvCiQzHI6Q7AtEfvyV+KV8r
	Of5dpnDFKcfoNqDAB5N/DUXJu8jasl0FfJlmQ6Io/QQJ5AkrSYNd0cAaIti+Xhy8Re6Rvk
	ssvP4O3oGn/2rGitsbuDpe1aniCxRMo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in
 check_extent_overbig
Message-ID: <sjfeetvht5t2f2th5a6vswqiirtqnbrhhy7kimb624lkjgt2tt@um3vc7jgondh>
References: <6751e9fb.050a0220.b4160.01e2.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6751e9fb.050a0220.b4160.01e2.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: fix check_extent_overbig() call
