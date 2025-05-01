Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E5920C476
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 May 2025 20:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746130124; cv=none; b=V6h2QyWIo4BGvk0mFn6X1vEA4NWOm/qzYc9il4W+kT35Kt1VcK4v5aKhy7QX6tGZKJRRtdNS0Kz7IxjsFRh/Y1XP7V+UKF31pKq7bsSpPqcnQzsG3Zxf3v45e7pZUo3iTZY27P4qcPd2hVi/rDLvUNcNYgpQaWyWd2//D48teUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746130124; c=relaxed/simple;
	bh=zIT82q0xOWN2Kfxl78y1LoY6g39Aaj5yrr5D5afBc6A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ir6M5ufswurVTHy7f5HKRburDpXkFvHiDxI1IytPoF8Bz3NJWu8bLagzVxq1sDiZDib0i8rtDuTgD9mlSJbfmn9KFy8VoOnQTBVlfQSstvIgIf0Wz5OmN1fGSg30cZWdGdq8Dom1riQv4ObRXnEThXGP1STeqTjKOvyF2PGn5p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=neIReg5d; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="neIReg5d"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746130109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBPt1lsPWxu7zJxsnqvH2FKn0STz5XFj+pS6Scgq+Ug=;
	b=neIReg5diK6P893HuCjyEtF6FUxtmKc99ooVzmqWL38G6z8DNez4SGspQgr/CcgGZzi/Fq
	2tSqgA1Xd78EAnVs7V0TkG927H6qT8U9XYs45YDHIEV6CP0dtOaFBeCPBrgk7tUNIaLgW5
	6oOxIufITBiubIvzH7Jxa01x+7KK1ak=
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.2\))
Subject: Re: [PATCH 1/2] bcachefs: Remove incorrect __counted_by annotation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20250501200132.216859-1-mmpgouride@gmail.com>
Date: Thu, 1 May 2025 22:08:16 +0200
Cc: kent.overstreet@linux.dev,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9BACA2F2-D306-46BA-ACBE-E06460E11FA0@linux.dev>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
To: Alan Huang <mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 1. May 2025, at 22:01, Alan Huang wrote:
> +	/*
> +	 * x_name contains the name and value counted by
> +	 * x_name_len + x_val_len. The introduction of
> +	 * __counted_by(x_name_len) caused a false positive
> +	 * detection of an out of bounds write.
> +	 */

Instead of removing it, would __counted_by(x_name_len + x_val_len) work?

Best,
Thorsten

