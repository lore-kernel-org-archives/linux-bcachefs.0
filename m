Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84BB1FAF
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Dec 2023 00:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="czgySnhK"
Date: Tue, 19 Dec 2023 19:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703030404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y79cKCy512tArkP9FqU8Lbl61bO22frnXAbin0Qu5qI=;
	b=czgySnhK1oIJn6wuSHkMls+jcURk4qE7vkB6PNtHy+W3BkJhqr5Yrq7Qnk3raYm28LbBCc
	Vekh3uPH8WdkC6HlMaAph2NpKxd34suTONbv4HmhPP7Fh0cO8mNba422VCQpvpKS1T8Enf
	EK/FLCThNhKUCiKw7q7VJnvTbeHJCJM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: clean up some dead fallocate code
Message-ID: <20231220000002.ypocj6zr6pzlqmjg@moria.home.lan>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219140215.300753-3-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 19, 2023 at 09:02:15AM -0500, Brian Foster wrote:
> The have_reservation local variable in bch2_extent_fallocate() is
> initialized to false and set to true further down in the function.
> Between this two points, one branch of code checks for negative
> value and one for positive, and nothing ever checks the variable
> after it is set to true. Clean up some of the unnecessary logic and
> code.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This appears to have just been a leftover from when this code was
extracted from the loop in fs-io.c - applied.
