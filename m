Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D2C6ABB8
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Dec 2023 20:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gzBS0pDB"
Date: Thu, 14 Dec 2023 15:22:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702585365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSZp9GQD+g4WJSKv23kWdo6J8w69ubtT79h3aE3wW68=;
	b=gzBS0pDBxt4dlWU3GzFTIyI95kl5ZVTtZ0Lb4AB1Jmg9lBkEcfVsRCD3TB46S82sydTeW7
	SYRqwvc6jIZVNipclZRWtamyoBy3iPw1Li6sHOAX18XjWoqXmTplIrC9nev/fnAknBmIaR
	5gmfsdoMsFs6DLiEwUQi8EqjdrIKKJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix invalid memory access in bch2_fs_alloc()
 error path
Message-ID: <20231214202241.wbpxcnzpxuypcbfj@moria.home.lan>
References: <20231214190641.230598-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214190641.230598-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 14, 2023 at 12:06:41PM -0700, Thomas Bertschinger wrote:
> When bch2_fs_alloc() gets an error before calling
> bch2_fs_btree_iter_init(), bch2_fs_btree_iter_exit() makes an invalid
> memory access because btree_trans_list is uninitialized.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> Fixes: 6bd68ec266ad ("bcachefs: Heap allocate btree_trans")

Perfectly follows the conventions for this code, nice!

Applied :)
