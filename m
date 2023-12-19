Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A482E3D0B5
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 20:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aYi1b2v+"
Date: Tue, 19 Dec 2023 15:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703019340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=18wm7W0ASMk/vVkXeuTMJnho0I5OFfsjc409d49CGf8=;
	b=aYi1b2v+O8/qNr7aRQilFoL8vjPrS8BtXPwbHf6CnLK7+wsRCPr16wzLhJkhRad1elHgkB
	PAWQsE0APL6lu+t4otkvmbJfxDrIt8YL0aVvseqBG243sZBDEYRJHEXKhGd+dZylNbjWb3
	xzitGRf3wG84w+sJvHeBnDdI42t1J0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Kevin Hao <haokexin@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove unnecessary kthread_should_stop()
Message-ID: <20231219205538.5mcxzxnwt5djptjl@moria.home.lan>
References: <20231216015140.2085664-1-haokexin@gmail.com>
 <ZYGUR4qD2mzr1X4F@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYGUR4qD2mzr1X4F@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 19, 2023 at 08:01:59AM -0500, Brian Foster wrote:
> On Sat, Dec 16, 2023 at 09:51:40AM +0800, Kevin Hao wrote:
> > In the macro kthread_wait_freezable(), there is already a check for
> > kthread_should_stop(), so there is no need to pass kthread_should_stop()
> > as a parameter to kthread_wait_freezable().
> > 
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> 
> Looks right to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

It is technically correct, but recently the issues have been more with
having too few kthread_should_stop() calls, not too many; I think I want
to leave this for now, even though it's redundant it's more explicit.
