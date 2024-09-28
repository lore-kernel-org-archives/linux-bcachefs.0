Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13389111A8
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Sep 2024 01:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727485998; cv=none; b=JkzRHDDN7YU7kVgn9bUxQ6dW1e0g9kp30g+n8RIJ60YdtcgTXEW3EcRSKvoEsduCLi//JMDX1rjFJ/xEp9piVo9TKuWYQ0EYTiyQwCO1oqSQsZCt3jHFCW7Tc1RoOMdQiY+9vCiipvFHOVKHn/RpZojlTPUBqVhg2xXCAnMtlwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727485998; c=relaxed/simple;
	bh=6CHsZge4wP83xNoPeqWmUHspuP2FskkfM+uQm5y5YyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vpb29HgWdyKbblUMDKaXxjflLG/rFpTTn0ELpWqPOv29dZ2bIJOYb8C5uZbjqOWpWEjIdZHIrbbcHR7TpyvHyBKoD6Tl87W7DMH3jFWCkIOHIdpGjQqmBzoT7sY2kGv/Ho62CeqjbO+5pmFNVxiOyKtCFBgjM5azhllnbLSBWWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dw2DeWOf; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dw2DeWOf"
Date: Fri, 27 Sep 2024 21:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727485992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zs5wklDGRxDqk+Fu4F/AGrJ/LAeCd/hYgo0/4dBHPjo=;
	b=Dw2DeWOfn/mfT6yTsVtBsoAZrCiFmvfXX66rDNjW40FpYhJQ857W2JoRL2w3QSnYme5rQn
	Y5jUIGgrIQTLeACp3dTO9m/DsuRRHLr1YuzX8BOxhwMEhzTfbFZ01+Em9js3TphB+bXsj0
	KdgegVLF83nTysTmd1yJ61WQC7NzNaU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Delete dead code
Message-ID: <ptrabqttmbpmsqs6jpxl2rz37fhlrc4ewfsaveiedoxs7nghh5@fq5vqewqugjh>
References: <20240927142653.1225060-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927142653.1225060-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 27, 2024 at 10:26:53PM GMT, Alan Huang wrote:
> lock_fail_root_changed has not been used since commit
> 0d7009d7ca99 ("bcachefs: Delete old deadlock avoidance code")
> 
> Remove it.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

applied
