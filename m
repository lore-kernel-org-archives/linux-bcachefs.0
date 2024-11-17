Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E492C1DE2CF
	for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 23:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731887383; cv=none; b=c1TGQiruV+nOMZeWwHWYTmxZiS2vTKeKjZhioa+xbg96/IsaDPt3q13cWhS8KkbUbojl/bT0V25sU25jFOvPKS2zHDFff34aC+1STPZ4zuiFLZyxO3GhSa0fWpfjgWstu8U6FCHvGODucBhvtBbtC5tknvdexAvpLdoNAXYoccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731887383; c=relaxed/simple;
	bh=RXy9zM4D/wtkk/3vzQbpW9uPjA0eh8924g1+lxWfxKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/TugclQHiWyTQ5HJ0QtE1RGaFq/HVRf6F47No6UIGYRazUBS5vCGcz1BR4WBeiJo4c9Bc18M9CfkId+sy+m+592CEg4pqZYhe1eajTT0z+2druXiQckt2zcOabsDi7e9xWbSY5ZV+oWqfQSuuSr6cfNs2GL6w3FCJ/tB3gEoWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cZlcw9ZN; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cZlcw9ZN"
Date: Sun, 17 Nov 2024 18:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731887375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Agxt+AwFYrRD7m03b1C+qujn1oHH+KdH2UDB7HCD1qc=;
	b=cZlcw9ZNLPwWBytyWFSWDwgTuttuToQm6D5j3CkbbJ6h8r4TBm72DQNwIsDtegBlOiNVju
	FMvMNXAqLMPvC9yHJp3BFF6AWaK7r+luT/XslxBCVN63Dg/hJnkqys3BqOfIRfJtzaAL51
	tKoKaixMwDS4Lmys4QYzXZfEbaTWOmA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: nathan@kernel.org, ndesaulniers@google.com, morbo@google.com, 
	justinstitt@google.com, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: initialize local variables in
 bch2_evacuate_bucket
Message-ID: <enjo6na4qnoamw74tyfabwriczmwo4ir3hs7hc7ma2p4eomwec@q54ebukphsiz>
References: <20241117234334.722730-4-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241117234334.722730-4-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 17, 2024 at 11:48:23PM +0000, Piotr Zalewski wrote:
> Compiling bcachefs sources with LLVM triggers uninitialized variables
> warnings.
> 
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Thanks, applied
