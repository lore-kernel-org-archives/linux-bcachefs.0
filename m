Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6320E6
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Mar 2024 03:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710992680; cv=none; b=IRAZokaZhl+axER4XX/plh4yI8M75Oyj6wuvTIx+NvIaEqVAFLlVvgwHqy1jU+8WNXdLq1BGHKRdXXupB9TKHs4ATrD+phxjEPDBgMa1NZbHBX/uDe2+mUXB/UTr1i6zPROnkH43zFKVA9sl/X28kPLANtGWnvHYLOChtOnmISg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710992680; c=relaxed/simple;
	bh=FzcUP+I3SnlIpLSxMy7PVp5hH3Miiek4ci9mgqPRyIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rezs2vRbaU4daGi/RxuwKZHkgo2+B8/ys1et2z7RHh8leYnUD09oYik9OSmldnLdV2vg8askeRqWocE642QMgEFJmQYyws5CHbqEEcLcNHoKqqkN/baRxKMnMmzaEB3eDm7P2/4bQuof76jga4CtjaGPFeU4tQyd40x4KXVxBXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ag34z3tH; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ag34z3tH"
Date: Wed, 20 Mar 2024 23:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710992676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0YmEWZ8Yk6RRNxTMxpMGJY+tq5nc9r+W8gL1SJmxnrg=;
	b=Ag34z3tH2Lp4mJoSL3oJIGdf2ReKjJXgrp10/GqKzajeUV3lQEWrJBusou3LYhpeJnpP43
	HBfw1SqR2AGDfZiUQylX1aZ9kEeoE8OnQjhHphVwlAXVmkKL3VtWkIRmkUt7aUfuWmHLrS
	/93ugVFSIDnc1/UjQR63nnI1bj5TK6k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] bcachefs: fix misplaced newline in
 __bch2_inode_unpacked_to_text()
Message-ID: <vr7srmms6ubhjuop6cw6dwjgkpqmrsslwgdo4jil7bcq6d4y4h@szwqk5h5r5gf>
References: <20240321034242.183717-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321034242.183717-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 09:42:42PM -0600, Thomas Bertschinger wrote:
> before:
> 
> u64s 18 type inode_v3 0:1879048192:U32_MAX len 0 ver 0:   mode=40700
>   flags= (15300000)
>   journal_seq=4
>   bi_size=0
>   bi_sectors=0
> 
>   bi_version=0bi_atime=227064388944
>   ...
> 
> after:
> 
> u64s 18 type inode_v3 0:1879048192:U32_MAX len 0 ver 0:   mode=40700
>   flags= (15300000)
>   journal_seq=4
>   bi_size=0
>   bi_sectors=0
>   bi_version=0
>   bi_atime=227064388944
>   ...
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Thanks! Applied

> ---
>  fs/bcachefs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
> index 2b5e06770ab3..ca4a066e9a54 100644
> --- a/fs/bcachefs/inode.c
> +++ b/fs/bcachefs/inode.c
> @@ -552,8 +552,8 @@ static void __bch2_inode_unpacked_to_text(struct printbuf *out,
>  	prt_printf(out, "bi_sectors=%llu", inode->bi_sectors);
>  	prt_newline(out);
>  
> -	prt_newline(out);
>  	prt_printf(out, "bi_version=%llu", inode->bi_version);
> +	prt_newline(out);
>  
>  #define x(_name, _bits)						\
>  	prt_printf(out, #_name "=%llu", (u64) inode->_name);	\
> -- 
> 2.44.0
> 
