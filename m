Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53891537DA
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 02:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729737479; cv=none; b=NLvoj+S1YdFS+ur+xYUBVQmcns1NXoMdkrt/m0gBMnXl+6TnFhAHYeuPUj+cwOTnL4BUW2SyCKHim3UDR1SGfix4CTDJCcbj8Izfq7iTh/P/5fM6kUcViJrkeFKowLObjhNIgXSoR2I/hMEnQTdAolN0ufs14DTiu6iouI8tLbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729737479; c=relaxed/simple;
	bh=dYG2T+EMlbUYv0xUeVXUCJLnlO3zS+S1ghfZsv4XnYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1aZI4pzsPlYBPDze573SgqfZPgT7qno1i5venpc0n8VSz3CPDcMv3i2SBql2lh/lMkj7VDo4UF9WNywZwqXCKCEX1W98uE5WOz0T30g1YLdp7VXH7yydfFzso+ZgdgQYu7jmgAbDHyTlKqk4r0A4X2tfKQB+GXXHDsvfXjWxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w4/iCes9; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w4/iCes9"
Date: Wed, 23 Oct 2024 22:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729737470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sXvm5QJgql3sbI3Zbv4p18wErlYFI2WN7u8mYBrO2mA=;
	b=w4/iCes9nlavwo81toFawsqACqtlVuvnDCPgH5sVSAmfw1qZL/BofAUB9bGSkO02LHJe7G
	9OrdwdHbFhUXARVvivTNN+SIZiuTFBfwOoBiqGCYD71vasfG5RbXZAKbm9bOsT7k5Dxyb6
	Mjpes2n2TnBbkvyrQoZDXET0DuGUntg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jeongjun Park <aha310510@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: fix null-ptr-deref in have_stripes()
Message-ID: <mu3tb4xb466rbfvnqkd7dwitbxqdkpf26oitf6lvn4j2kubpgf@evsyze7an3xd>
References: <20241023161345.80029-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023161345.80029-1-aha310510@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 24, 2024 at 01:13:45AM +0900, Jeongjun Park wrote:
> c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer dereference
> occurs, so you need to add code to check the variable.
> 
> Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
> Fixes: ("bcachefs: metadata version bucket_stripe_sectors")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

Thanks, applied
