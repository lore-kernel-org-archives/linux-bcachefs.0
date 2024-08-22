Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5408ED299
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 00:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286394; cv=none; b=ZIEqRGe1nyqsv75Ye9E98Kmke8+MQcjKnFk+ieagAsJm3d9EX9JVsrXBA9Jmv7n1YUXljZ/sr0vFca32Vpq1V3V8lGm/KPCTxLN/94z6da0HqrsKQV0/LtIcLZOav5ZZkarinnYSvKyxyvEECSK8HLw3kJgvYZL86OZYUNCuLEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286394; c=relaxed/simple;
	bh=3DQSNpD6PvZsucLGclD3so1o3rWUjpmgnJjKAITxAS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7i8qSE4u3rI16SCzd81raFCXO9QGfNoHKzO76cDGlF2ipxXRJhPcLViF71HlUr7NoGbjQsBf+S1EHPwqWqcd4sK8Q8PpfSB7InklXb4BWQbpZo6WUDhyO8Z8jO/7zdRyI2sahhlnwtVshYqzswO4NjwnIrwwEmhzUseWDkzCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FVxmG/if; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FVxmG/if"
Date: Wed, 21 Aug 2024 20:26:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724286390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9D1rF5QXpZDrYeEUQ3LBganeQOJRJMQcTH8m+DIo0s=;
	b=FVxmG/iff4VrDFQvslVDXivcfHy4sD5qKLQJdXDlIZYm5ND5tvAbhegtqrR4J8y5w2W2Xd
	d3cyPw/fjuaFTq1i8sz0tHAZCj7ihCtHgwGCNp9+xVQgJYCnt2IQqnIxFXGRlrVXkWJYsI
	h02Tn9mAI5Bl89KFDHSz6BQ5dia+gdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] bcachefs: Fix format specifier in
 bch2_btree_key_cache_to_text()
Message-ID: <tuafglatdir4stthjop2wm7adm37lf5ivw53dxd3lcbjfyqfag@zgj5ekgupxck>
References: <20240821-bch2_btree_key_cache_to_text-fix-specifier-v1-1-2d9b89b15fdd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821-bch2_btree_key_cache_to_text-fix-specifier-v1-1-2d9b89b15fdd@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 21, 2024 at 01:43:03PM GMT, Nathan Chancellor wrote:
> When building for a 32-bit architecture, for which 'size_t' is
> 'unsigned int', there is a compiler warning due to use of '%lu':
> 
>   In file included from fs/bcachefs/vstructs.h:5,
>                    from fs/bcachefs/bcachefs_format.h:80,
>                    from fs/bcachefs/bcachefs.h:207,
>                    from fs/bcachefs/btree_key_cache.c:3:
>   fs/bcachefs/btree_key_cache.c: In function 'bch2_btree_key_cache_to_text':
>   fs/bcachefs/btree_key_cache.c:795:25: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
>     795 |         prt_printf(out, "pending:\t%lu\r\n",            per_cpu_sum(bc->nr_pending));
>         |                         ^~~~~~~~~~~~~~~~~~~
>   fs/bcachefs/util.h:78:63: note: in definition of macro 'prt_printf'
>      78 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
>         |                                                               ^~~~~~~~~~~
>   fs/bcachefs/btree_key_cache.c:795:38: note: format string is defined here
>     795 |         prt_printf(out, "pending:\t%lu\r\n",            per_cpu_sum(bc->nr_pending));
>         |                                    ~~^
>         |                                      |
>         |                                      long unsigned int
>         |                                    %u
>   cc1: all warnings being treated as errors
> 
> Use the proper specifier, '%zu', to resolve the warning.
> 
> Fixes: e447e49977b8 ("bcachefs: key cache can now allocate from pending")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied
