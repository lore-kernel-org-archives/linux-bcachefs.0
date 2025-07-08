Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182CE1C5499
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Jul 2025 12:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979075; cv=none; b=GM1fev2wbeFGiwUEUyAIp/o5a5M7xGA1Ihu2M/pLKQ170Kkg8scgpLoBEtnjcO0eDKEUnBh3ViAi849Nb2TV1FTlO38GsQDu6hCwd4XuHfSw708NxlQJmedNuPTl/lccXXlUXGMLtRAHfPwhK6gYaT0qbRepaGmHH4qGw176c8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979075; c=relaxed/simple;
	bh=QOFYPrp8fx065K2ZfqSqKamPxKcxM2CbqK5FTx2WjTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPsAxjEYidmnic2QTml+4ZXARuZTnexdqfZ9YimCGg4OnK/CiC1A0qQWzUG6i073+aR+usIhc5lXXd5RT5ic8zfJuczGXzGWxofGDMDdd40KfnbYB1huPgedyhPQzJP3aaT9gFk7OCt0BO3HAVbk/gbw3xtIlofAKr2Kyk3Ez9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zl8jawXZ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zl8jawXZ"
Date: Tue, 8 Jul 2025 08:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751979070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EuWJac7bIMMbrDLP0jqOSz/nHOanSt+qlzS+K+3StRk=;
	b=Zl8jawXZGHb2uwXHn5g/nzkV/spbb+A/yXlqkajRWj+ZZvyEODkFM1MYqp+rLP8Q7HS2Ev
	EteHOIk4f1LgGF2qsw7xV5ZYZ7OF7GCpRdQSO6gNccrV8tAW/p9DVCaqMns9HJaNhulJjY
	7J/dZFsKzygfuxYXyQ6WP5Ykl5vdZEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: George Hu <integral@archlinux.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] bcachefs: use union for bch_compression_opt to
 make encode & decode easier
Message-ID: <c32zfpyool2mpjibvxp4rloegtsqfazuphxz5wqrdmjcnfnc7l@fyc5hjd7pmfo>
References: <20250617070036.10685-1-integral@archlinux.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617070036.10685-1-integral@archlinux.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 17, 2025 at 03:00:36PM +0800, George Hu wrote:
> Eliminate redundant encode & decode function by using union for
> bch_compression_opt, which reduces code complexity.
> 
> Signed-off-by: George Hu <integral@archlinux.org>

Applied to testing
