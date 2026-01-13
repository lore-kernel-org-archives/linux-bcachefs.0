Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA8036C0C3
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Jan 2026 20:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768335991; cv=none; b=TgwoRktVVOdZQfibUTNz0BPTX/alvJNQ3Ey8c7pVQH1egATSrXfxaeSWuBzoPK96bh3pciWb7+vcRBulGfMyc3k5zZfRyu2qbo2WNYfmfBigT0IOjvmhX25KGxnMXmyjJYDKecZyYqGeLRd6AVguX1h5DLYWSqBTsa5hYfj37K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768335991; c=relaxed/simple;
	bh=pfXGis8dsvCxMyDa+hqQlTwXQG0OHKWOJdSU4QNdLFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyYlKekkgAJhe5R3zkjjlVRwu8zJYdg8SebW9bXBi+oUHU2PNSlf4bkwFNn2CdPXOCPj/MpvDaxIL7tHJboJTIvh+Z9P70JW3ALKEiP6KeLB0E86eCOM8h4VAQh3zF7Mxj+7L9NwtM0IGW7lftNDjXvDBIrO26ckDuSQ4EWZFCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TRJykh5U; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TRJykh5U"
Date: Tue, 13 Jan 2026 15:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768335987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fG+nNFHqP++KNuD+iU2cIX2Hqf09kn1OpIu8sMNVwbw=;
	b=TRJykh5UrL2Te14IGIdtLNHWm48YBsiJnqsLdluqqohams6DP3qJSri944uvGm8q6v6oZV
	9BlT6opVN7eJ4+/aD+5oJLsIkfhWLrJTNRWKjLgroOZYVVTuTPBIfWI8P2Wmpo5Qhlgw+Z
	qj1kAV0OX2ysFAhPnKJGkLoyOhIybO4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] doc: fix spello in cmd_device.c
Message-ID: <aWaqYBhsrR2v2npL@moria.home.lan>
References: <20260113195625.73764-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113195625.73764-1-jengelh@inai.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 08:56:25PM +0100, Jan Engelhardt wrote:
> Partial revert of cd214bdc877674a8dcb21dca88851d586ffc2a3a which
> hypercorrected a percevied spello.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Thanks - applied
