Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AD1CA9C
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705425816; cv=none; b=tX4RptEKeh35tqvZT6Nt0wrGhqQEy0Wl2IwQg1g6AGTnVwvBe0+lBSp8jP+4wD+KLen73hP+pZ/d71cCGxBNvmnRPQj4B+0sGuD5/d8Uw1k0IpsHVxz56iSPjYXxjOuzm2g66L61bIUDHJJcopjJ6/EWKXsE8Be9fI9kc707VeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705425816; c=relaxed/simple;
	bh=Jsy4gBUPmxhSZX0JTobE+7OSZ4o8HDeGGrHe3TUksFo=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Scanned-By; b=QCLv4nC3/kNj2+y8YrgHkJhb2XTRKr9C2DZiciSMpFm8xcNUzbj+IUCi82SpfUvZmJW69u2mnQaL3jzl+s2RGPIehTZXfQqpFUZ38quj2Kavblb76mZ83Z6qvBAbprjxa7MLCgVSVo8rkZED7SdGcc+y8vAYdIW9nhjIwGW/uls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FjHE3OtZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FjHE3OtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705425813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0TcZV7JyFTrv6nMlVVEU9B3ptju+Y3aF3oOYDXFBGEA=;
	b=FjHE3OtZlhtxALjbqCM6vv8RjjKIoX3KwzCf8sJP2GUF1wurMSe+ItG90E+ZMGFFC+DSRo
	aljgnmvXOnIMDykoLws6EkwvENUgPllPIYu4UXnc8M0YeNQsNNi2hzY7VBnuU77hWOpd9Q
	G+fMZsmkjKqXb5te+vlr15xk1czuCfc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-hvfqNECyOsWfV1xKPbdMKA-1; Tue,
 16 Jan 2024 12:23:30 -0500
X-MC-Unique: hvfqNECyOsWfV1xKPbdMKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8CA428AC1E8;
	Tue, 16 Jan 2024 17:23:29 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF69B2026D6F;
	Tue, 16 Jan 2024 17:23:29 +0000 (UTC)
Date: Tue, 16 Jan 2024 12:24:48 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] general protection fault, probably for non-canonical
 address 0x280766500040001: 0000 [#1] PREEMPT SMP PTI
Message-ID: <Zaa74Ehk4idtZNwc@bfoster>
References: <ZaahtMNCEd42G3EP@bfoster>
 <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ze74khldgkvbht5ryjq2bs5rjnm7eds2xytlwc76nqurjwf7tx@rpcyvnwbkglp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Jan 16, 2024 at 12:03:09PM -0500, Kent Overstreet wrote:
> On Tue, Jan 16, 2024 at 10:33:08AM -0500, Brian Foster wrote:
> > Hi Kent,
> > 
> > JFYI, I'm seeing the following splat pretty reliably via generic/361 on
> > an 80xcpu test box. The CI doesn't seem to produce this failure for
> > whatever reason. This bisects down to commit 023f9ac9f70f ("bcachefs:
> > Delete dio read alignment check"), before which the test still fails but
> > the kernel doesn't explode.
> > 
> > Brian
> > 
> 
> Can you test the following?
> 

Still blows up... repeated a couple times to be sure.

Brian

> --- 8< ---
> Subject: [PATCH] bcachefs: bios must be 512 byte algined
> 
> Fixes: 023f9ac9f70f bcachefs: Delete dio read alignment check
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index fdd57c5785c9..e3b219e19e10 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -77,6 +77,10 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
>  
>  	bch2_inode_opts_get(&opts, c, &inode->ei_inode);
>  
> +	/* bios must be 512 byte aligned: */
> +	if ((offset|iter->count) & (SECTOR_SIZE - 1))
> +		return -EINVAL;
> +
>  	ret = min_t(loff_t, iter->count,
>  		    max_t(loff_t, 0, i_size_read(&inode->v) - offset));
>  
> 

