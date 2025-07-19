Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D9F1EB3D
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950306; cv=none; b=r8CGsyzjaAQdt5/mwEaYqmZb41r+JctwO/hgkSGX/wAdKwrOnalVXmzOKOOJk4woD92hdzEcF+4zKMsmgLHXhFvJUAAZ9owY79oFc9j479LYGGQ/YFPfmSBatZGBmBC2MdELcWIO7l1j3wEh7Dzny11AjpluoiYV/M/nFUERw9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950306; c=relaxed/simple;
	bh=AF3p4dcJEuGWtg0GuYj+jCfsY/ZvAbYUKXbHdJmKvyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wh6JW68NVCv8CD3eQOx+psK4KTR3ZmdiLfGiIFQGuSW/yw89n76MQbkQpjn6PXC+ketAXODOCPyKAV/4hcyP5l8n/+IG2pAL1/d5rcXCtrgcZW3IcVwfVqvBXGZUgUs4K2SFUeryEjeItmW0u6x/17HpJjWcEq8zPyGUDl2L/s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RHChGeSK; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RHChGeSK"
Date: Sat, 19 Jul 2025 14:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AF3p4dcJEuGWtg0GuYj+jCfsY/ZvAbYUKXbHdJmKvyE=;
	b=RHChGeSKF2M7hKHfmQ5CqF/IWCM3kUkhz1BZ5pC8xiL0Y1G69AB9FiARxKRis7Y8zima6q
	Qo1Vg7NsPWbpfoaysvSLxexznl2413C6bY/F7ccW7g7C/hhhMhSckgqdwi3F5nhqiGeSkJ
	zwNU+6kw5tYGp/wYOW1UB3mT+cWOBDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+397f6fe952a0defb9424@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fill_extent (2)
Message-ID: <p337gu4fd36z2ciwwuz46k44h2brymdfmdkmilbft654p44hz6@zpqhai5bubge>
References: <687605ef.050a0220.158d12.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687605ef.050a0220.158d12.0000.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix unhandled key type in fiemap_fill_extent
