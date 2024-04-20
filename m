Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39594205E28
	for <linux-bcachefs@vger.kernel.org>; Sat, 20 Apr 2024 03:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713582255; cv=none; b=Shk8l2fzL3+u8mhHhEuDvh2mxURfRlNmq4K9Om15Oej9h7AO06PR8xc9t/wtBCSnoDe2TJ67fuVa7HRrr2Y4rVaZjlpM3KKTfQzEJQNKj4bHtFLZjC3juNEVhlAEKSz+8mRRHvA9l4reIjjm79OtPG+9MeHvLg46eh0m1vxhvzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713582255; c=relaxed/simple;
	bh=WwYoZoJd1BRy9sS4coZ5uu1WFlGXO9/NrJfzl029N90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdJkraBzaREvu6zS5HY7jnM4hqzXBUxL84WbetJ2lI9xqn9g+HqKRS4dO4dZRYTdIpBaAAbosY2XLTtAsQCZ4mUTagKRwOM1dG9uhKaXL1OLyUvXN6PcspPy8R9fvJJtS+U/7FdjmD0KBAU1xwt6NS5nvZ9ZUok5SG/uWcDV/70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nz24+NzA; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nz24+NzA"
Date: Fri, 19 Apr 2024 23:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713582251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k0HmzjL+lE24FXiE+j7IGhFf9AYZYrfM6qxjfiUMu70=;
	b=nz24+NzA7mN+E9X1Fyt8FwcCQ5j/uafETIfe3hSnCH1EISxCLrVlhYs1hFxfBWrUkFcbnR
	dquAShDp5VatZugZ5MIGEr5ipJ73ETShnbyiKWvfSZGUbFiYmEw4uaTAXcKk1KzssBcIhs
	RHpCfpVi3WvVMPw46vZUrXf5wySB3CU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 06/30] bcachefs: Remove calls to folio_set_error
Message-ID: <cauccmcr2jh2obrt3f7t47jnk77ygpki6ihxtqsw5pfol24zhf@wd5rnfc7ougu>
References: <20240420025029.2166544-1-willy@infradead.org>
 <20240420025029.2166544-7-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420025029.2166544-7-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 20, 2024 at 03:50:01AM +0100, Matthew Wilcox (Oracle) wrote:
> Common code doesn't test the error flag, so we don't need to set it in
> bcachefs.  We can use folio_end_read() to combine the setting (or not)
> of the uptodate flag and clearing the lock flag.
> 
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: linux-bcachefs@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

applied
