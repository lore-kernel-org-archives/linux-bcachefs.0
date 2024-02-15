Received: from mail-108-mta101.mxroute.com (mail-108-mta101.mxroute.com [136.175.108.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872E38F
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 00:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708042272; cv=none; b=hWFqmdb4nCOmkzOQK+HJ36oBlx+zrCZMeS/xVMXagkY1DIJBmX18UBHhwvnh+0ODB1FoyJV5PT+9lYA5FOcsZxaWkENeG/Zisnru51wP+1PqPZXq6Z8WpdGsHmULwFiV1+yqKs52ulr9PRujZ+zQ+99KwSx1QJuPWg1OuJ1DtiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708042272; c=relaxed/simple;
	bh=BOUX7GhBxBtZjjhmGI0AqGnFqmcfg3Y9VE7FP0pbiV4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=bga80F59bN0M/3ZNkllnbnDtSKM0dWmDqPz01uwLbzdEJNURPVzvHKk50w+Nz3pKPBSleERkpHSW2nsyHS/dpP0yOybn1n0BiWNZQoqcwIuwcHOxNO2Pgx9+GlDnKWLxWvwTsbCD731cBWzTUWfj+RSwXXu1H9gZnn6KVwvsS+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=iwh1tHxN; arc=none smtp.client-ip=136.175.108.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="iwh1tHxN"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta101.mxroute.com (ZoneMTA) with ESMTPSA id 18daf3bf91f0000466.002
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 16 Feb 2024 00:05:59 +0000
X-Zone-Loop: 5a66b1b76cf9acc80e093be0a17b5bbe33d7f8fa3675
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BxBBx8cV5lGgkE9u+HhE0lKTv5JpaiIRMjhgQ5TuTZ8=; b=iwh1tHxNas3CDPky/eWtKqs9z/
	0ljqpCdPfhp1Brr3jmlvTotnqe0qkklC61vd+QPM9pItlGI9VvLXR3tODR0LB1o1fGLr9FlJwRR3l
	YqQ4neVJ72aQ0yOSL8Ejmd/Avx/bmBXDfm2LazP9xvS75uK96mQbIYxZ9Tz9jwpAteowrDdc8WrdD
	4nQXUV3H/dLqD7te4VO0FVbMTn4Rg8H7AKONDjd05rScXRBfcT89SnzIAq1EFv9e+vMSW2KavOeWH
	vczyi6u8jPwBOe+AvroJXb6MKILtEgkgy+yaDKfLvCh081Zm7eep3ydilbsXJNhkBYaTiQsgTp+IY
	Sl/FknNg==;
References: <20240215171605.162107-1-bfoster@redhat.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: fix iov_iter count underflow on sub-block
 dio read
Date: Fri, 16 Feb 2024 07:58:34 +0800
In-reply-to: <20240215171605.162107-1-bfoster@redhat.com>
Message-ID: <34ttb7ge.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Thu 15 Feb 2024 at 12:16, Brian Foster <bfoster@redhat.com> 
wrote:

> bch2_direct_IO_read() checks the request offset and size for 
> sector
> alignment and then falls through to a couple calculations to 
> shrink
> the size of the request based on the inode size. The problem is 
> that
> these checks round up to the fs block size, which runs the risk 
> of
> underflowing iter->count if the block size happens to be large
> enough. This is triggered by fstest generic/361 with a 4k block
> size, which subsequently leads to a crash. To avoid this crash,
> check that the shorten length doesn't exceed the overall length 
> of
> the iter.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
>
LGTM.
Reviewed-by: Su Yue <glass.su@suse.com>

Since imap.google.com is blocked by GFW, I use my personal email 
address
in mu4e + emacs hosting on remote machine daily.
I am no clear what is required(gpg?) if I use my personal address 
to
give a review by in my employer address.

--
Su
> ---
>
> Ok, I think Su expressed preference for this variant over v1. 
> I'm off
> for a bit after today so I'm throwing this up onto CI in the 
> event that
> we'd like to at least get the crash problem fixed. If there's 
> more to
> look into here, let me know and I'll add it to the todo list 
> after I'm
> back..
>
> Brian
>
> v2:
> - Check for underflow instead of removing shorten entirely.
> v1: 
> https://lore.kernel.org/linux-bcachefs/20240205154814.910664-1-bfoster@redhat.com/
>
>  fs/bcachefs/fs-io-direct.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/bcachefs/fs-io-direct.c 
> b/fs/bcachefs/fs-io-direct.c
> index e3b219e19e10..33cb6da3a5ad 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -88,6 +88,8 @@ static int bch2_direct_IO_read(struct kiocb 
> *req, struct iov_iter *iter)
>  		return ret;
>
>  	shorten = iov_iter_count(iter) - round_up(ret, 
>  block_bytes(c));
> +	if (shorten >= iter->count)
> +		shorten = 0;
>  	iter->count -= shorten;
>
>  	bio = bio_alloc_bioset(NULL,
