Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F10738387
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706727486; cv=none; b=Q5HLJm8kI+tKrvdUdjTojOmu6phP2mDKvvKmzQQP2Jn5sPKA5AAC6r4NqK7iGTfYG1T9DE9Z91HN9tsiOllC7d93b9pHOEZYEZkZL0EAZ37ZoNIwKM/leAERG7wDoJkFG+B6hsPR/vnrG9vkQykcsebrOo/p9LWPIlzYk6VI7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706727486; c=relaxed/simple;
	bh=3Ss8UdYrtA7t+yOn0FLtaroUXJUCa3jPCsNJBqfm1Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcqeSz5ZO+iGGcQeIXP3rcDC8RVtWiKOJK6bBZGrhEMNOc1VkAU1xhwof2Z++nwMZhyvNKjmLL0dx9md0KD5JM4MpXB57QAsz2B+/Vo00dJwD7yGuGutZpM/NeaDJefL7cxfiNC6YAMqT6qPD4gtAtlidhAIX2rjJa1hn3I4bQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dtn3zzeP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dtn3zzeP"
Date: Wed, 31 Jan 2024 13:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706727481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHbvroNqFpowbeScPB3hizPjxxMywb1/CoNrzrlhiPg=;
	b=Dtn3zzePWDbinc5l3+azU7p58/IIgLBykFl23JoKcW1GqPJ8l2ViEa1CKfhzRuxFKujQG0
	ndl4m7my0QmF/q0+X/1OQboUxvu5fG6x7i7DWE9jhQH3+j6yOgCSGvh+IqiB+wQu2Pqo+4
	wY3GmQ330geMtdQQXjU9paDDwKydB00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
References: <0c35596b-a280-40df-946c-c50574c3ce26@moroto.mountain>
 <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 31, 2024 at 09:43:14PM +0300, Dan Carpenter wrote:
> On Wed, Jan 31, 2024 at 10:59:13AM -0500, Kent Overstreet wrote:
> > On Wed, Jan 31, 2024 at 06:24:16PM +0300, Dan Carpenter wrote:
> > > On Wed, Jan 31, 2024 at 10:10:26AM -0500, Kent Overstreet wrote:
> > > > On Wed, Jan 31, 2024 at 05:52:11PM +0300, Dan Carpenter wrote:
> > > > > Hello Kent Overstreet,
> > > > > 
> > > > > The patch 1c6fdbd8f246: "bcachefs: Initial commit" from Mar 16, 2017
> > > > > (linux-next), leads to the following Smatch static checker warning:
> > > > > 
> > > > > fs/bcachefs/btree_io.c:1672 bch2_btree_node_read() potential NULL container_of 'bio'
> > > > > fs/bcachefs/btree_io.c:2165 __bch2_btree_node_write() potential NULL container_of 'bio_alloc_bioset()'
> > > > > fs/bcachefs/ec.c:734 ec_block_io() potential NULL container_of 'bio_alloc_bioset()'
> > > > > fs/bcachefs/fs-io-buffered.c:489 bch2_writepage_io_alloc() potential NULL container_of 'bio_alloc_bioset()'
> > > > > fs/bcachefs/fs-io.c:81 bch2_inode_flush_nocow_writes_async() potential NULL container_of 'bio_alloc_bioset()'
> > > > > fs/bcachefs/io_write.c:407 bch2_submit_wbio_replicas() potential NULL container_of 'bio_alloc_clone()'
> > > > > fs/bcachefs/fs-io-direct.c:622 bch2_direct_write() potential NULL container_of 'bio'
> > > > 
> > > > bio_alloc_bioset() is mempool backed and can't return NULL
> > > 
> > > There are three return NULL statements in bio_alloc_bioset() and the
> > > comments say it returns NULL on failure...  But it's simple enough for
> > > to delete these from the Smatch cross function DB.
> > 
> > So it doesn't seem like you're doing an critical analysis on individual
> > bugs, so perhaps these shouldn't be on the mailing list.
> > 
> > If it's just going to be bot generated and not human generated, perhaps
> > this belongs in a dashboard instead of taking up space in a
> > communications channel intended for humans.
> 
> Come on Kent, don't pretend like I haven't pointed out over a dozen
> bcachefs bugs since it was merged...  I'm just saying the comments
> weren't obvious here.

Most of them weren't real bugs, just places where I tweaked the code to
please the static analyzer; I believe the number of actual bugs was more
like 3-4.

And I also asked about getting it running locally, after spending
several days fighting with llvm incompatibilities; it turned out the
default build configuration was shipping with that option on when you
weren't even using it, as I recall, and the database stuff isn't
remotely documented - so it seems you want to be the only person who can
run your tool. Oof.

So can we please find a way to do this that's more respectful of my time
and yours, and not the most inefficient way possible?
