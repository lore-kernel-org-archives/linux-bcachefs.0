Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE6F1B253B
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Sep 2024 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725891723; cv=none; b=OWfBm1QaJEK2aLNjGMJoRJg21OkcWuJ7qlY+G1Z7VRwYtnQsEFl4JLtNa3VMIqChBzS/cBR94yGmKFyx7kWR7GiMjcb5NtKVL9tR4YCYpBqad0Ghf625stciMTSXN0Fh3f3U0IWLUUKOTu0EObCSinSArMgSiB+bXYMO8IZnGG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725891723; c=relaxed/simple;
	bh=K0wVAEXdcfvlWgFDMDgwiIxrC78wygJ/jgM3w7laCnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXn7OlicjHd0fhT8DUj9fZTwip/0Cc8kKZHidrLa/hOQJ1fSETvrT3JiFoccctl9nLJLKptPD7wI5wjD57kFYecqwbAr3vzCE3CMBAj5TsZdtQFPjj54qyr49CDGmu3BInAN58yzSNBO+6EL6fZ0M41Ww2XM4DsFKP49YAjZgpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Aoi8HYeZ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Aoi8HYeZ"
Date: Mon, 9 Sep 2024 10:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725891717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJCuLeQ+nMy/9wK/UdBxQr1sgYHskXi6WeRDUBz9VGw=;
	b=Aoi8HYeZsqXagCVGNWfV3SY41G5hT5hkCbhYujWbZmJPXvflSdA51O6rgAGK+7xGNm9rbi
	Me7wRVCnBNM/yryzf6Px9F9APk+hUYubZtTGH5WyCkNJfEx72QgrjDRNUDkezzJKtU2tXK
	CHW7mbk2ltXM1IzZrDyC2k1QoPGpRnM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] bcachefs: Remove duplicated include in
 backpointers.c
Message-ID: <zp4t644voc3nlm7hlns2ni53qm7ie5fdvomxfgjexii43duagj@rkfl45vxxb7y>
References: <20240909005802.14125-1-yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909005802.14125-1-yang.lee@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 09, 2024 at 08:58:02AM GMT, Yang Li wrote:
> The header files bbpos.h is included twice in backpointers.c,
> so one inclusion of each can be removed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=10783
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Applied
