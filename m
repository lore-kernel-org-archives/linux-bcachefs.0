Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679A912C7F9
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 22:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721342368; cv=none; b=ol8cmIc6ApmC+KanmY2GAMRogN/Bsl+jQB6JRcJDO02Ltiitp74GN7xfmztGA/xo+0QQ02PPE8d0JMHdq7hAlsMHJhMduL+rOPMO105Cm4f6DLtxh45biFiacCFAssLMyjmA+9QBLGJ5WSig+T+2OMYDOnsARTIViat3PmafK/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721342368; c=relaxed/simple;
	bh=3/n3hqexCUhIPyC0OepqcONnGIWCcXsweqjkJ0x0Iy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTbWxOcVMleJJVio7wxFBulqyDaVOYjkmb1zqO28auGXHzlgB/fBq3uGYp/l989o6QAw3Lqi0SgCQ8bhQ+MDqW3DKWspXIGD8nO2JJq81gPWFK1iWapykLjFInU7KD/eaXQ6lQM2IDUrkhbfmloixJYJvX3GneFO6wbg24btyyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DrA0NmBE; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DrA0NmBE"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721342364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lmmKWB3Dz9hMOvLV3wohg3QzInVJKOCGmRHDDKEs7o8=;
	b=DrA0NmBEipxq0vjUqz13GSKiikSB1W35Rc0Nb4Rbyc/kwAa0Y7HYkIdIeKQDcc0jEohcTW
	Bt3ca2/Z89MQIlvDh38oJHQ+PydOkf3mWKd/maVy1W66hagDyV1x3UJkUY1CsTMnrzdgxc
	HzrAsbCtsEoBo27Tt3IpsXSWWyrPnnQ=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2024 18:39:20 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.11, v2
Message-ID: <k63qtejb5ufc52uvwpmqpjugnsjcta6ucyyn4lj6h3q2s3jvje@2oztma4odvn2>
References: <73rweeabpoypzqwyxa7hld7tnkskkaotuo3jjfxnpgn6gg47ly@admkywnz4fsp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73rweeabpoypzqwyxa7hld7tnkskkaotuo3jjfxnpgn6gg47ly@admkywnz4fsp>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 06:36:50PM GMT, Kent Overstreet wrote:
> Ok, version 2:
> 
> The following changes since commit 0c3836482481200ead7b416ca80c68a29cfdaabd:
> 
>   Linux 6.10 (2024-07-14 15:43:32 -0700)
> 
> are available in the Git repository at:
> 
>   https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-07-18

Sorry, I'm fat fingering everything today, that tag doesn't include the
lockdep comments patch. Pull from

https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-07-18.2
