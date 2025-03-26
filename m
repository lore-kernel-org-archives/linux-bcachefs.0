Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459C31ADFE3
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742996497; cv=none; b=q6zwB99WS0W9+UhZURG+w1fU6WJCof+1wIAyGdFVywDQhVZNq18cDIc6Xy6QONDp0CHpGMyaKj79QKJOAxGlazzADq5vSJbaheUYtSKHSqoHpIf2OeDJNDKBm5659Y6CIdwEyClNKWAspsewtxB22kS93CkFZWhIPPmlHa8VGVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742996497; c=relaxed/simple;
	bh=gFD9eTqNpDMmHM5F5v3qAGKknThwWt+KWcQMFFICEJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ot7jrBRSGidc/zrIAJSfRVLK9wxzP3pAGZSGT/H1oCJE36UJHRxSjyfRtYbPYxBbwTzmzmexxMmfODaC9ahOafRz406uqet27icSZGTaWRXHHwM5OIMZD8UTEYU1p89B5+iz3LhZZ1ed/i9G/GVLTIA35ZCtohOYkFrlt+pZrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bzACR+6R; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bzACR+6R"
Date: Wed, 26 Mar 2025 09:41:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742996492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v2Lsez95kt5KsAtlXUgjw5qq03QcJELvgj+uLw5WoT8=;
	b=bzACR+6RNZvUWENHT+R7HUyJpBLQYVgCukbVm74Pg0OECRgnv05w4PK4cPCSev33mlZ7eu
	tuQKCcqsfzGDDAbCJUpCmsfB7jaMBhgIHIpjQttBxQsknvGir5pJNhLyvqTlo23y/acBQs
	akHBJiLIKjCFGTDqAmDDoJgJXBq414U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, 
	linux-bcachefs@vger.kernel.org, mmpgouride@gmail.com
Subject: Re: [PATCH] bcachefs-tools: fix build failure by fixing of C header
 filename
Message-ID: <2g64pfi7pcwsz2uf246zng3yszd7adav6g3viix5irdfprg3ke@3qfhueni622o>
References: <20250326081828.120893-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326081828.120893-1-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 04:18:28PM +0800, Integral wrote:
> C header filename in `c_src/cmd_fusemount.c` hasn't been updated after renaming
> `libbcachefs/fs-common.h`. Updating the filename to fix build failure.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Applied
