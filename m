Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E8A17B51A
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Jul 2024 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720018974; cv=none; b=H8WwyMGZfJME+q0j4ykWrsIsFUeq48sx/R8uo8hedJLBT0X/cbzzH18WalZmCECF+Sebc4pwIUuLDpUTbNdlPz/k3+YkZJL1NVAOmsvfVw/1ndp6LU20c9g30/F7BatNeRUou9WjKQoEnpJveyfeO/AQAOePG5zMIooRCFvmp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720018974; c=relaxed/simple;
	bh=5POAQwxlEVLJLSFij3brRfCbCM8gcvTvJetfnuYqgXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZcokyFb/munWwHLmO5yOTN66iqWn2E3r2eWqTNyPFG60m11Xg3tRxUYA5Ig99CKL0hmobvQ3GBlanound12QDmRwFzj8EizuGN0mLNM3v9PJk2pBnFVmLbLUPoIy+tBbC8m+J5cfO4XPfrv30GcRSEk907rHlTBC+tABJ5jxx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R09PnS3k; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R09PnS3k"
X-Envelope-To: youling.tang@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720018970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=20ySm3U3S1LiU3m2Re7JW0Tn2z5nTSYsCoeIly2B2rk=;
	b=R09PnS3kMyIoOr4s7X4fnq6FBpzQ4zBMrLjAXO2Kg/0XrsYy/+OcvuMWndrqVELXrz9k+u
	aIrHVNrEK+AmFMUkQqUf/jpWehGraZ8IdXsqs32VbHS+t58qH9uao3VhQP6q6XWJoCF293
	omAcj6l9pt1oWwrlF0PBoMW/76oZe7Y=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Date: Wed, 3 Jul 2024 11:02:46 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Mark bch_inode_info as SLAB_ACCOUNT
Message-ID: <32comcbsxjfut3pw3jx4jlzeqarcqvy5267k7qbqlgwmfrmp7e@f3ufymzk2a2h>
References: <20240703070955.104163-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703070955.104163-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 03, 2024 at 03:09:55PM GMT, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> After commit 230e9fc28604 ("slab: add SLAB_ACCOUNT flag"), we need to mark
> the inode cache as SLAB_ACCOUNT, similar to commit 5d097056c9a0 ("kmemcg:
> account for certain kmem allocations to memcg")
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
 
 Thanks, applied
