Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B891412D750
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426325; cv=none; b=eS4TJGoiSVydlT52WWslIKbvzTvDyX0RRZkEo7Tey+Hu1LIXPEycelBTxqw2W5wcoek9trhjYt8j+iU1v5t4J6gFYCSOm40kfawrEZCz3b3HI93Ob2YU5yfJMfM29e5LRVRyUhyzCalIH1sw2VWDZS0d+my1m+Ua7YXBpC1M7D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426325; c=relaxed/simple;
	bh=dK57Nl27MpWALPJBZHvzFxgumMug8ufQCkca0+q/fCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kq3MVDaOuxDqfvJ40tXQZsvVsz/xk2jlGJuowcEKO3ZpllcuEM921Ah6UIwEXMTmoFiG1fKE5s7UM751s9JAN/EVv/+vltdMxZWjhKPzllfEp25hbqH0bDVeZ7XnYvCo+3cojBBbAFlsm6Ue5vL7BeQJ68l75J7y2soPk9bpH9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nBBOBwEz; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nBBOBwEz"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717426319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mPcLnM0Rsrq/Tr30dYjuQKBf+w8b2Wkb9PiYSGNeKao=;
	b=nBBOBwEzYa2NH4tO99wzjjji8ASmDt+ZyLxWYCEs6kGKqN/mHX1oOCN2L1RaGjvhfkeVsH
	oqx3KPW8r5ogRA6Di/LFGh8CBNPRDt3JolksxzimIVPz07yoF5tz89gH4gMCI16VqQJaF9
	N02n9Fq5jcalCVHA+tfTPSyiuSLfSmk=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 3 Jun 2024 10:51:56 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/3] introduce getversion, getfslabel, setfslabel ioctls
Message-ID: <dhpzubzlwesj2ei4pcjq2anyqtndcqoygyttllfqzso6qwlpel@si2eokry4i5m>
References: <20240603132620.4027906-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603132620.4027906-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 09:26:17PM +0800, Hongbo Li wrote:
> GETVERSION: to support lsattr command.
> GETFSLABEL: to get fslabel by ioctl.
> SETFSLABEL: to set fslabel by ioctl.
> 
> Hongbo Li (3):
>   bcachefs: implement FS_IOC_GETVERSION to support lsattr
>   bcachefs: support get fs label
>   bcachefs: support FS_IOC_SETFSLABEL
> 
>  fs/bcachefs/fs-ioctl.c | 80 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 79 insertions(+), 1 deletion(-)

Applied
