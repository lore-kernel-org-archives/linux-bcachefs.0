Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0CC12A15E
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706716766; cv=none; b=qx/ouQ0LHAiwa9XsNMC4+PVgNREdPbJWUIy68gts/TnT1bctCiWEZV4v85VF5N1T01uxUio7o+MUhGTXw+m4PtYiYXcf+0ITR7mH1z0JPx9bTZmq3vuZZiECmi5GWyPjBeqHNoByLGnwjNfTdtXk44K1tB8m9w+vPsM4HejGv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706716766; c=relaxed/simple;
	bh=O5H7++Gbh0cBN+mpjq89DlnxQLP1/ynhlFzYdbNzB8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClEawKAfEnh9KV3r1nS7nuZz+9A+zLBiqcFlaFDUTzN63N0ifylxRStQS3p2ILgw8Kwn19SEf5vMdyV1l4EG3YvtsuJnHTtMOSiZSI57qdgfFm4o2KF9yms+0P7GUPMedR167smX085LyKjCn2xgDki8lJOqvCeqUd1/MWMStSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENYgByx2; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENYgByx2"
Date: Wed, 31 Jan 2024 10:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706716756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4I61C7qGPOIiOQOfZLD8dt7RCBxeQFzuNUqAmiEeG0=;
	b=ENYgByx2BVtb+zHdEqHS7MWWhKPWNz4j8+C2Fni1fJh/YvWEtwa8lw00bmlAmeXA8YwMca
	2QYhZPFPQhHijJK8EYOPCW4AbZTx0/CTloVxZ6WR3lNylyySZAF4sI+B4S8zrzP8Lp9aMw
	jhCMmsjNE6bIp7/2PVqhF88ZKxrHp3o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 31, 2024 at 06:24:16PM +0300, Dan Carpenter wrote:
> On Wed, Jan 31, 2024 at 10:10:26AM -0500, Kent Overstreet wrote:
> > On Wed, Jan 31, 2024 at 05:52:11PM +0300, Dan Carpenter wrote:
> > > Hello Kent Overstreet,
> > > 
> > > The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
> > > (linux-next), leads to the following Smatch static checker warning:
> > > 
> > > fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
> > > fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
> > > fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
> > > fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
> > > fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
> > > fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
> > > fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'
> > 
> > bio_alloc_bioset() is mempool backed and can't return NULL
> 
> There are three return NULL statements in bio_alloc_bioset() and the
> comments say it returns NULL on failure...  But it's simple enough for
> to delete these from the Smatch cross function DB.

So it doesn't seem like you're doing an critical analysis on individual
bugs, so perhaps these shouldn't be on the mailing list.

If it's just going to be bot generated and not human generated, perhaps
this belongs in a dashboard instead of taking up space in a
communications channel intended for humans.
