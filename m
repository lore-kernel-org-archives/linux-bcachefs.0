Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEF168B2
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Dec 2023 07:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W2JmRzd7"
Date: Wed, 20 Dec 2023 02:42:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703058171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iQBELqlRsaiuDO7WNvWnS3EgMMQXCEUjbipogtos9JM=;
	b=W2JmRzd7ETY6BtCd0OUqR6aiwK23nQNYxdAkU2E7uvLBo9loAxJWiftgJOCT71hdSImj5N
	b0rXcJf3jYA7C42txv0T5y4SdmyfrDeEPI2LeSDIaL4KCtFYacD/cz2JJKRxCulKpzEe0l
	6U20Xu3P5FdHTLV1rurkwviogAlss1k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: mean and variance: fix kernel-doc for function
 params
Message-ID: <20231220074248.u4b6y73cyo7whucz@moria.home.lan>
References: <20231220064409.12161-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220064409.12161-1-rdunlap@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 19, 2023 at 10:44:09PM -0800, Randy Dunlap wrote:
> Add missing function parameter descriptions in mean_and_variance.c.
> The also eliminates the "Excess function parameter" warnings.
> 
> Prevents these kernel-doc warnings:
> 
> mean_and_variance.c:67: warning: Function parameter or member 's' not described in 'mean_and_variance_get_mean'
> mean_and_variance.c:78: warning: Function parameter or member 's1' not described in 'mean_and_variance_get_variance'
> mean_and_variance.c:94: warning: Function parameter or member 's' not described in 'mean_and_variance_get_stddev'
> mean_and_variance.c:108: warning: Function parameter or member 's' not described in 'mean_and_variance_weighted_update'
> mean_and_variance.c:108: warning: Function parameter or member 'x' not described in 'mean_and_variance_weighted_update'
> mean_and_variance.c:108: warning: Excess function parameter 's1' description in 'mean_and_variance_weighted_update'
> mean_and_variance.c:108: warning: Excess function parameter 's2' description in 'mean_and_variance_weighted_update'
> mean_and_variance.c:134: warning: Function parameter or member 's' not described in 'mean_and_variance_weighted_get_mean'
> mean_and_variance.c:143: warning: Function parameter or member 's' not described in 'mean_and_variance_weighted_get_variance'
> mean_and_variance.c:153: warning: Function parameter or member 's' not described in 'mean_and_variance_weighted_get_stddev'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: linux-bcachefs@vger.kernel.org

Thanks, applied
