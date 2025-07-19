Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8D7191484
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752962222; cv=none; b=dvT8lutedj+Fd17VY64/pDDr5CR6btDwtySJFgL6qet8OS+Khx81MSOVmmCqh5tTAt3qfa/nnI9358ZsuTCI69ZFBj8z9LcQTIe/Y/udztUruohhHGvKVHDjwoIIxKw2vqKhRg8U54mKkRT7siWkNJuACE5/IIXaJSnNHUYbKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752962222; c=relaxed/simple;
	bh=aJsUMMJNzaMTqcwDIA8kBblsnJKcFjoDqfCZeHiosRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNSQggRRddyw9ly2hmyk4usF0xeVFt3xF0mP/uhC1gKAYF1BJsi4YuQEGGj/AKdGMPiTD9MaLhMHGYVycAermGjZ9H3qeFItT2mFoUROMxD5RzhaPI8WzuW5SISInyDYEHTMUDK49pFvKGA+q+Uu1SqPPHABjy52PPdyia76VKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=arpZtTB3; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="arpZtTB3"
Date: Sat, 19 Jul 2025 17:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752962216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJsUMMJNzaMTqcwDIA8kBblsnJKcFjoDqfCZeHiosRY=;
	b=arpZtTB3BFoYK4Bv+OszCnPo+yYmaXTkq33utaeBJhE8FT1Q8Z4DpqTK9kSDEBGeZwf6Pk
	iKQJJKtnw8KIupX0eHTKt9uKbULxgDs70uqlhjTxIKZ8fwCxR4Qb5gonWzxLqOmjWHvnoH
	rVJg5H2zGjdcsgXrlH5yrWAtcXM0it4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in
 poly1305_update
Message-ID: <iuebxxmpulg77o2sznvjclghictwopvslit6vcfh75hcouavo3@j4tco5bnifrs>
References: <684c5575.a00a0220.279073.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684c5575.a00a0220.279073.0012.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Move bset size check before csum check
