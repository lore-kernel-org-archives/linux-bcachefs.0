Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94C626AD5
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426291; cv=none; b=IbmvsVflrJQTnFajd8SPsSxTRkxnz3wPC39et9aYCgD8eXAUullFbnrwkrpMtoqwPW9sem0mkzNnJ/HCivT32xPUSLqbQlPvnmQVzLDXcPZb5lkjp4dgl9Oj7Bg93/dBYJSNfiO9z0QfNSCjwAeIoeccL+4W7t4Nq4c77RCGIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426291; c=relaxed/simple;
	bh=m/Hi0P4dIIjFNHuZZiqbi8stSEkC8P8kgvgPJW9iI4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atAoPYsR3MQOFshCVVCGZUaC1ey5Tyhqu/jp+oyJRD4k0K6PqSysVTKJn3HXsxktq5P+fOXMDMxHzaUo1JpouE0pGwwACnGDIg89HtlhoTLZKsAuF1or7POeYhP/cFrI7lt6CIIPWmq9yymepesJjSmt6qu81EZJBzVuezM43YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ItDGyxN5; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ItDGyxN5"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717426280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UfG72BsOtmPhExVnYWXp+Mjjoc0D/ygjb6VPx9ZGqqs=;
	b=ItDGyxN5FggEKv0tZfatv3dDpF0blcRmhfhPFHcqruzBmsnIpQmj6jt+XBW75c+a7esJZV
	9miKscDFVyIUAx5zCJpSFS2Bika+lj2z/+MOu+DCjlhZIdNiVHF9o2kVKwI1PQ8trRsK9s
	VPPm6CWm5oq5AImgyNIe+jFXWyYv6O4=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 3 Jun 2024 10:51:15 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix the display format for show-super
Message-ID: <6mnnkb7cwyguh2blqrgh5myfysbldtvhjezvb64iewazqzoati@tswjilvhlljt>
References: <20240603132335.4027737-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603132335.4027737-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 03, 2024 at 09:23:35PM +0800, Hongbo Li wrote:
> There are three keys displayed in non-uniform format.
> Let's fix them.
> 
> [Before]
> ```
> Label:	testbcachefs
> Version:	1.9: (unknown version)
> Version upgrade complete:	0.0: (unknown version)
> ```
> 
> [After]
> ```
> Label:					testbcachefs
> Version:				1.9: (unknown version)
> Version upgrade complete:		0.0: (unknown version)
> ```
> 
> Fixes: 7423330e30ab ("bcachefs: prt_printf() now respects \r\n\t")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Thanks! Applied
