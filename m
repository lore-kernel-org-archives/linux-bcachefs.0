Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BC639ACC
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732914802; cv=none; b=DL4WMy/VzGIAeaGoVU2sJHXETQNMW2NezOoQETpkuhLIoshemLXyl+5QjqWl8yXcdc2mKn0QMYOO07g3Xs6sno/g2+sDmdsK5ATaMfCJcRTDv1t27SwjR0jx0bl1O0kuFRVfa/JrgkhICT8aV/Q+hS1X7DQURhBTkznkMqYqDhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732914802; c=relaxed/simple;
	bh=aCEu/OOSu+8BJVqbZ3Q3D/NrM0X0n+c5GpavA3rQrEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfC0bR6+xGM/6XNp1vk0+AZgiDdcIcQBkOgEeDcrcsRhftOS7KdR6qEjDGjQZHoBY74kYfzX5PrNA2UYmWWcFJ7pLgHJQCZukw2IeWMPqiEt2y5Km2sHyFCRax8UnxFVBJ7omsN7uAcljUPVrfk6TfdRznLvJ+oRXwP7wEXcw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 29 Nov 2024 16:13:00 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] bcache: Add missing parameter description to
 bch2_bucket_alloc_trans()
Message-ID: <kwml4bka4qyz3sh7ntoiyjtdbsqdorv23xvmb3uekwpx4duv3e@v3r5ijnkwuxv>
References: <20241129063827.90340-1-yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129063827.90340-1-yang.lee@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 29, 2024 at 02:38:27PM +0800, Yang Li wrote:
> The function bch2_bucket_alloc_trans() lacked a description for the
> nowait parameter in its documentation comment block. This patch adds the
> missing description to ensure all parameters are properly documented.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=12179
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Applied
