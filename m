Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A521E51D
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 07:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730358993; cv=none; b=SkyJkcIhoxoRUWLGPew+H///FDLlG5Qkky8l4DmhcdmWyxGzb0AM4HjD+CpoVj/tp6Kbge9vibibPlsH9XeYSzvdltXh5/rYqOjsnBFcURP96sv9aylu4eFkCsPeyOttx9Q/UsKgsJX/i+vWmLvKMgTvMWQ7/oRFoYflaUjKXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730358993; c=relaxed/simple;
	bh=ZSAW+WuHzgaYdT3XvcgfBa07ZBZ1V6NmgPy5pe1+/Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdpXDqACNe+e9g593R8p2uIi7leLmwV5JERG/EkozIkiedNzsgOfEE2VMD9Ui4G30OI+uCSEb5bdVdinRp009f4ie1FBYTqytS2I9+yIrXoVJ11+Tun65FTsNVT0FufHBYrX5LPLBY6Bw0ninmAVoEllzEUsaXowLz91zM1SYzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SI55oDGT; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SI55oDGT"
Date: Thu, 31 Oct 2024 03:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730358988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ubEtZmVtLGIxgrkBcF1Y7o9EE59vzwnH6kBKW8ITWBQ=;
	b=SI55oDGTKf5tB/OGM5oUDifUvW3IvTbATvP4Skzjz0tqpoxb/kNemKVAEN4ZrYAtnuMQOo
	hgxk/Irg54NCLDw/vdQvVyRG5Z70Eqhtiw76a2T/YIx9yQhZHKrACGsAoCKCBncYPfDaCU
	UmAPY8OBif900Lq1+4m3Ay7bkdqbmA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: use attribute define helper for sysfs attribute
Message-ID: <kmhksvmhd2ibmcacoeenvdxofe7bu6yrtc5kyyh3lsryilpsq7@75nqhb7s5oij>
References: <20241029125408.3013288-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029125408.3013288-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 29, 2024 at 08:54:08PM +0800, Hongbo Li wrote:
> The sysfs attribute definition has been wrapped into macro:
> rw_attribute, read_attribute and write_attribute, we can
> use these helpers to uniform the attribute definition.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Thanks - applied the whole series.
