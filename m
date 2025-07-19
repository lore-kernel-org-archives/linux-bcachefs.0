Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FAC19924D
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950221; cv=none; b=KMu4bG/uIvOJiL06OHX15664JNGi/CGVIkLSDd+8dzDCHqG1GEjhPZbKKw3+rUcwJnJYj0xl+iuNuCImEKc8vTVV4yZUXCZqQBCXm/X72NSJTFUR172HBymZc1u4W3TuiHMcD6cY5epeiPUobCAnOIeTphnwV7y4rx5SMG9hhTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950221; c=relaxed/simple;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MV09r/as0uSuWk37J4y07zM3Nz2reR1ECYtP+16N7gtM6DAg5PDgsHhf2MSS3SG3WH3EPiJ9L7adBLczkpoG1Trpn/sKKUu3GU5bUz3PZtyPrJqGuT/T0hvjLRtDrQAGWhxs6Vf3SA/Z8P2aWrAMM2uuw2gYuDsv7+JKBOwB6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bfAwzzOL; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bfAwzzOL"
Date: Sat, 19 Jul 2025 14:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	b=bfAwzzOLu1UoPvA8FVLn4wFRKh1B7DLuMox+dcMFW+dn2eq+elTbriYIWfXFtrz0N9vSKW
	eb9o5GnL1WRfLrX3JFie5wWfURzwFFrST2wzdkJHZQPPO5LEU9nnJIQ5shTzRnibX9esqT
	+BREM54VCP+Yu+mGw6RCP7NsPtLh+mE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+4908f37148402680dfec@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_bkey_compat
Message-ID: <eyrfxraou57woqsf4p56zqgvg6fsawaqe4tvu67am34xtg2moo@izxwy3a3fcly>
References: <684c57c4.a00a0220.279073.0015.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684c57c4.a00a0220.279073.0015.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Don't build aux search tree when still repairing node
