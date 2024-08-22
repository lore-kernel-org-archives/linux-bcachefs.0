Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DA318AEA
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295821; cv=none; b=diIGkML0UglgMbpwtYoq/g+62n+Gr3Vjhygh1LUIc05ltcPEKSj8HfJ4d7lm0e74cqgy8chY1by0Cofr9+8wQu4TQIbnvBPkTwVKOgrsKehYQYZjqwp8CWBzRcK5iMMqSVDiUjbqPjvlUazgQSmaBAg5kakKpG8oVEbo7MumRkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295821; c=relaxed/simple;
	bh=l12OZtzbmMQS3Ep9CoLmE1rli/fH10kTxO2s7q+hv9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MV9bsZYjsjEq3aAz+eggZfkz8bjiyzwLSRROI8q0264DCWmYoaSK+URDes3ai3DbOO6eBl2YQTmPEV+vlNx1q+zBgGS0MJ6/NTRQVt4ZQFk9ojOXGemGdBdMoWob6a+jpZFX+ZL0btCsZV6+zrLZJXC7zaT9fVPnI153NjWlc30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jrpsJGnP; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jrpsJGnP"
Date: Wed, 21 Aug 2024 23:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724295817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l12OZtzbmMQS3Ep9CoLmE1rli/fH10kTxO2s7q+hv9w=;
	b=jrpsJGnPD6osXOTX4fF7LnR8hkmv0vcbpsT6wArkjIPkizrJEBOg3lP3aO9VdoI5gVjSmS
	pPMlTBK0dMKsRSkxqTwXXy8c2bjo/Vi4Tj7/alDFvWrl1d1IyheLjARoMRG2umReeKRKFN
	d41ZhkHi/AZNiRixc6EfxqjG9+yeC2c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Write in
 bch2_dev_journal_init
Message-ID: <h4gag7jchx2iirjj4nipeju46bep5vi4qi3cyudmny6a4r6mxu@dkkujl5op2r7>
References: <00000000000071b7c5061ff83639@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000071b7c5061ff83639@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix missing validation in bch2_sb_journal_v2_validate()
