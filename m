Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363484A26
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706713836; cv=none; b=sKY6OWFcZmyltdf+Q8QnXC41RBX0lETjxMhKEZ+PEPiGy1i3Nsf2exbIb+x8KJFEzMbDZNG1WIg4mkvFpcQYldyutAwM7xJhp9GItNhu8GdJD8lp47frkvm4SQYAsfvhYalipNid+A6nG4TlnQ+FQ8rO4P+eaQKsGovR/vOTuxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706713836; c=relaxed/simple;
	bh=Y34rMkmPugL/oMlbXSoTUY4E+fGGlJsKXPKSuBrtkM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kN9gNFGUG6Z0+GebVqVW5PgJ9KCCUMC7NE58t6c6Cn5bV84g/JGGzSDuIXFlVpS7gxla6f0GhEINS4M0V9nPaiG48/7IpQjZ4lcPlo13lTSCm0jSdcl/TLD0j64blDFyPwrtgTchlMHWFzotWyK/x+VwKERJyxFyyccvbyNz93U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J4S2R6Lo; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J4S2R6Lo"
Date: Wed, 31 Jan 2024 10:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706713830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6w8+T+K+qtxvMY7e/OJzJTSch9CV4IFWkKPqbt5qbjg=;
	b=J4S2R6LoicTneCtzMbpBS4vMO5jT+dRy+b4NqGQJlgIw8BNPpzvOYY8t13XlfW02eQ9MDA
	k/oDheopjwq9ElM9AsCy2Hwa2nVuQ5wKTzGclBC71wbT1CJH1nfZEzctjWruUvHueW338i
	rUs8JRXc6Jabmz+AMv1PnJdTqpJ5mIc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 31, 2024 at 05:52:11PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
> (linux-next), leads to the following Smatch static checker warning:
> 
> fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
> fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
> fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
> fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
> fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
> fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
> fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'

bio_alloc_bioset() is mempool backed and can't return NULL
