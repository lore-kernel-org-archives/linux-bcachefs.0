Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B706172BAB
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Apr 2024 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712342543; cv=none; b=WBjqkV48V/98ZtJuaU4GMBSQbu/bgfZqeHsKtd8UKU97py0sL4pNvpESlq4WJw07SK9pQR8FFxeoxRVXHJcs9p1IXR0rsRHMDcWjVqbIwDb3t8SJHWJ+7S2AAMzOwxfu9AoCQWcNEhWLPJ/o+U3ZlE/90w05RwUVckjwWp5GLyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712342543; c=relaxed/simple;
	bh=aKzj2nNlzMJ8azIYfSPAwEduj86IzTAYqe3VzO9WswM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWDDlQ2ytANjSpLw8d3K9KeWx6v31AsxW+birPwDvsnzJF1dXgAEF5tiXsKn11K4Ux27znkNmd857Zm7xWR5oWbnKnX05x157b+yCclwBlAt03b0OFGzV3tkij4zJpdZYly0/GoHDc0R4gxeUtXxDgVKoVdCKXPQ3gIQQsNt3dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gjJR7JMP; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gjJR7JMP"
Date: Fri, 5 Apr 2024 14:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712342539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZ+uiehsJ3wgEMKI7SgICdPj63wSJBV8Zz0Zm6XtKDI=;
	b=gjJR7JMPwM69GilljNxaLsraANZiI6ZRtq1EYVMXDo+DU9QnxgReuT6F28u6Gk1vvV1aKA
	xO8AU8gk5FRrrcr5U3/R50gv77g3bYT79QBgMK3FUOm4LFJ4EkJi7ohhby7osRXx+CbPpA
	9jPo5NKxNAaopVsaY52eQbFhnH3JOS8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix ! vs ~ typo in __clear_bit_le64()
Message-ID: <ojophuwjmdwwq3ki6zi5lxzsma3xjmfgpwvutb6lden3j746sl@fe5lg43ptovd>
References: <5ecccc80-70b2-4c04-8c09-1113fef3e515@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ecccc80-70b2-4c04-8c09-1113fef3e515@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 05, 2024 at 06:01:02PM +0300, Dan Carpenter wrote:
> The ! was obviously intended to be ~.  As it is, this function does
> the equivalent to: "addr[bit / 64] = 0;".
> 
> Fixes: 27fcec6c27ca ("bcachefs: Clear recovery_passes_required as they complete without errors")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Thanks, applied
