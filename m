Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FADA94F
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560270; cv=none; b=Gbvjp/EWUVE1/SFmkg/OCakVuHHoIRn8O1ikENKTyk1OaQAMgS5YIbMxisPnMu+m90rV2zuhj03IhK8EBBKKupVpOUMf72n64+nFFedkqXS3Xg0gAXTk2xOKgR4O7Uz3Ar3m19zcsk8RTQlSRt95Pw7YuNE6pgaScxVn3ySkIDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560270; c=relaxed/simple;
	bh=4WKkWotYZ1Oazo/PiLbdh34LV4deHtqfIISRRq7ZkH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJdFFNhLH2Gvbf9Soo36cabRLizfSCZQYjHlkRy9BuoEtcmMLc+3Xzvu+rBfPvKP0hxGffcdadROaFJCLxcCX3R5eKmLTu//DuF5mnmSFPfekCDCFIvsfrIqouq4QDgbpLxNCXKby2sPQPXtED11YSH+OihWPbxE/Zrug4qzydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TIMkT15W; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TIMkT15W"
Date: Wed, 21 Feb 2024 19:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708560266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DacZQ2bgLZrPyV3TE+Kd66Fku/+A0+dgRbmVjv/psVo=;
	b=TIMkT15Wa83yuKPGA7xJBGstG2DmQTXX6m46kts3xS2DRGpqIxD0qfriZ6Uj8+J3aTLC7Q
	S6zwVQOMpY4HUNWunGEpmApf7YuNFrH33khwHIE+k2HD/Nd2OVamTuJeO+x5YYbufH81xm
	9C6yHywEYXYfmMNWDGv86G2xOms2uFI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: remove redundant assignment to variable
 ret
Message-ID: <3qaoftjgf7p2ugutl524b3yin7pqpjrkftjx3frunhduf3so66@tjhcdoq6unk3>
References: <20240221115203.3413554-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221115203.3413554-1-colin.i.king@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 21, 2024 at 11:52:03AM +0000, Colin Ian King wrote:
> Variable ret is being assigned a value that is never read, it is
> being re-assigned a couple of statements later on. The assignment
> is redundant and can be removed.
> 
> Cleans up clang scan build warning:
> fs/bcachefs/super-io.c:806:2: warning: Value stored to 'ret' is
> never read [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

I'll take this, but - entirely too much of the traffic on this list is
getting taken up by static analyzer bullshit, we need to cut down on
this
