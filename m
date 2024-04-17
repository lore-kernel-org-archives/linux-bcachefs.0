Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6B24685
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Apr 2024 02:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713320442; cv=none; b=RrA3rX/2QQfz7xAd87iHb1Z188zLp0WfMFNm1ch1Wkr2y4WV92+koE+GgE4vjkZgVDqrRUuAxGy4FsbOoHs8G/YFWHUm4UQXjj75Pf7X66cyphH/YcYtADogXxix6VUfvBHFA3iuD5uiuhyVrnN4nHJEl5WVDzKpr9TMkNfwDHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713320442; c=relaxed/simple;
	bh=JEO0ng65nZp0QZ6p164cReYxFc0+aDojLhQDMPMJqNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srBAJSun+PRtS8DY4Asbj4B+m6fHGkPCZs/b+FVUwZcEvxgjEz9KwB6iCw9yBTB6oJa5syCxspWtOaaCFz+gZxr07NmcKRN3WG3hjHL6CjxiYo0ToFO3CZEoBC2099Fs3hUYMjYmcD3fe0uurecpCAmynrpJHtSK1anaBs2kQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RdVIjrNC; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RdVIjrNC"
Date: Tue, 16 Apr 2024 22:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713320434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3y5F04Fl5zfvkzhj2El1MuWEnqWlT8gtSPmgfEeDlh4=;
	b=RdVIjrNCwkFFpawDWlb5p/go3q8DWIsZxC/YZY6MzTAeJ9IL48Qu3AuiR3aPgFsmJpOsSD
	Pk3IzGg+83ESHtVTL5NscGWI3YxbAUeyoTlR25/gHeuJtzCDSpwVmKZS3JKKi8v8vm8V2N
	R6DPONrgcXKRMroYaiolgtAP1mr2+Tc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Align the display format of
 `btrees/inodes/keys`
Message-ID: <toosz4pt2la6wf2575vwe6efebcbzsy735cq7exmlqhzrgicrf@s7g3rrbvge2l>
References: <20240417015448.84294-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417015448.84294-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 17, 2024 at 09:54:48AM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> Before patch:
> ```
>  #cat btrees/inodes/keys
>  u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
>    flags= (16300000)
> ```
> 
> After patch:
> ```
>  #cat btrees/inodes/keys
>  u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:
>    mode=40755
>    flags= (16300000)

This would print a newline for keys that don't have a value...
