Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD11CA89
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 17:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705424595; cv=none; b=j0wexPmCJMB1WGDPl03WzVR/SvCUdBiXnnGz96miWq2TAm4xTl3dHDOzbilcEO71ApPS/+tOKBj6EMbQnT7mZcxquEC+lpfWH6DWYdsJ3Sr95OEE17RCnhTxNoBAkyDT6QevR1k2Kc86szmiudW/ZFICBSTueLlxRnGN3jOdbIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705424595; c=relaxed/simple;
	bh=CZCgXRlhL4uFWPQiUugbFdoZ34Ozxnt6IdybkT4PhQY=;
	h=Date:DKIM-Signature:X-Report-Abuse:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Migadu-Flow; b=mQrQ6aj9AobPK5ec3y7mOjfEOoJwWXVmAs4ICmdO/ec435+0ipiLtR8HPO3cEa+FsFrhm3ht4v4J1Smepsx3kpSr2xaC+oV4kLvkmtKS6ZTN8fJfi01nxHchqi72ofxhvWIB2lmTE/erFZfRRLgi0AYUhidTDV0o1PWk2fox1gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vxZC71lp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vxZC71lp"
Date: Tue, 16 Jan 2024 12:03:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705424592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=THO3Bq6WnC9RGV0gSDRHA/xkpmj4xH/CbJofHOpLrMg=;
	b=vxZC71lpllLqNjk3ZwbOK/6QTZQHZKpW3yqNPLHuDnH+1De5QnGU418imhwuIyyQJgBMfH
	I4+x3HsQxMs+27KoBBsPhgfaJIcOfneIjqx8pk4i0YxSxQ++MrdeQ2ZSDeAIkkxLPFXO6c
	BGGvdG6F4EjDdnznLL1tH64N09WBQ6o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Message-ID: <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
References: <ZaahtMNCEd42G3EP@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaahtMNCEd42G3EP@bfoster>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
> Hi Kent,
> 
> JFYI, I'm seeing the following splat pretty reliably via generic/361 on
> an 80xcpu test box. The CI doesn't seem to produce this failure for
> whatever reason. This bisects down to commit 023f9ac9f70f ("bcachefs:
> Delete dio read alignment check"), before which the test still fails but
> the kernel doesn't explode.
> 
> Brian
> 

Can you test the following?

--- 8< ---
Subject: [PATCH] bcachefs: bios must be 512 byte algined

Fixes: 023f9ac9f70f bcachefs: Delete dio read alignment check
Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index fdd57c5785c9..e3b219e19e10 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -77,6 +77,10 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 
 	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
 
+	/* bios must be 512 byte aligned: */
+	if ((offset|iter->count) & (SECTOR_SIZE - 1))
+		return -EINVAL;
+
 	ret = min_t(loff_t, iter->count,
 		    max_t(loff_t, 0, i_size_read(&inode->v) - offset));
 
