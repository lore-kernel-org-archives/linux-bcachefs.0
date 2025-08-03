Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E181D90DF
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Aug 2025 17:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754241533; cv=none; b=UsfYLnOSz7ZWV6p+sz+16OXLj3qJM5tGEBskW5R43IIn0k4N665VBRQcQ6AKQ1gh0Z5iy7O61b/585A39916ALgj0o/NFj4vCy3e3Gf9jRkuVVHqSTBzV7LCWKlpHQ8+yaj15uxiWX/NcWofdYLqo7CuzQ4SAyTleayVxgitqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754241533; c=relaxed/simple;
	bh=2VeUQAFsYpgUGCW3n7CfxT7zSkXN9t4OUVHM7m2rrwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLOI1nR7Daw5O7Ujw3JSkNLsp6LcjDAgFA85jEYaOagtxDQjp0cYIxUdiQDLNlIBe+dl7wS/BL4B4gzoWpimWmLyp0O+zvXXwl6L97rgC05eMtWFplVFv56I5zFDGgS8kvOu/4o3n+BQqWag+b458/E9YXqv0s6wFx2XmXgYJRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q6M8mhpz; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q6M8mhpz"
Date: Sun, 3 Aug 2025 13:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754241517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ezWtFpUA8HJ8s2mBTOH7FVKV44vryXvEpySF6TjdsUQ=;
	b=Q6M8mhpz+B7S7CAaG9Bw5ej9YPPVy0Dy8FMVHcnHAECUqymyQUdDnXry0XF/AQ7QREQk5c
	zW7wdFwkbYYwxRVsoAHQeshSL+X5bZt2xsUfdPCKFYj/f6QstEA1Ui6XPsPmI5xIGC9IGA
	TM9WJrxNQKEKXvt2fo7Wg2HAFvhVKzA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, willy@infradead.org
Subject: Re: [PATCH 1/4] bcachefs: Remove redundant __GFP_NOWARN
Message-ID: <meipfzgml62kwea63bzx2idp4asce6kbjdm5zqpskkqfcjyyfv@5smvbtt3depd>
References: <20250803102243.623705-1-rongqianfeng@vivo.com>
 <20250803102243.623705-2-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250803102243.623705-2-rongqianfeng@vivo.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 03, 2025 at 06:22:39PM +0800, Qianfeng Rong wrote:
> GFP_NOWAIT already includes __GFP_NOWARN, so let's remove
> the redundant __GFP_NOWARN.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Thanks, applied.
