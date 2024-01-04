Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED622134E
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Jan 2024 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G1BiT5XZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704368922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SpHMmokSgGDKcmTLznbRmbtbRfFLr37rcn8JaQ+LmFQ=;
	b=G1BiT5XZsrZr98dgnXk+XK33nlcZysKamjGugrchuyU2RpVIBZYK+KR0nwF8iJwmd40Tp1
	Pxlj/gDysYjX8meQOzYdiRK+mm4zj8Ng/8i10Hx2ePS6HMk1v7+u18azN3LUJ7ovqHIO8K
	KX9C+YEjL9sBHBbBBAwar3ggV2j2Jz0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-PDy1qZMIPfiCbPD2ArBxYQ-1; Thu,
 04 Jan 2024 06:48:39 -0500
X-MC-Unique: PDy1qZMIPfiCbPD2ArBxYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBE883C1CC58;
	Thu,  4 Jan 2024 11:48:38 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.199])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 917151C060B1;
	Thu,  4 Jan 2024 11:48:38 +0000 (UTC)
Date: Thu, 4 Jan 2024 06:49:40 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kevin Hao <haokexin@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove unnecessary kthread_should_stop()
Message-ID: <ZZabVJRLBHTTcP2u@bfoster>
References: <20231216015140.2085664-1-haokexin@gmail.com>
 <ZYGUR4qD2mzr1X4F@bfoster>
 <20231219205538.5mcxzxnwt5djptjl@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219205538.5mcxzxnwt5djptjl@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, Dec 19, 2023 at 03:55:38PM -0500, Kent Overstreet wrote:
> On Tue, Dec 19, 2023 at 08:01:59AM -0500, Brian Foster wrote:
> > On Sat, Dec 16, 2023 at 09:51:40AM +0800, Kevin Hao wrote:
> > > In the macro kthread_wait_freezable(), there is already a check for
> > > kthread_should_stop(), so there is no need to pass kthread_should_stop()
> > > as a parameter to kthread_wait_freezable().
> > > 
> > > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > > ---
> > 
> > Looks right to me:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> It is technically correct, but recently the issues have been more with
> having too few kthread_should_stop() calls, not too many; I think I want
> to leave this for now, even though it's redundant it's more explicit.
> 

What recent issues do you mean? ISTM this logic serves more as a placebo
than anything. Is there a more explicit issue to dig into?

Brian

