Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDA0286439
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754326286; cv=none; b=kJNs9mSzLrc9yE1ZXwoToj1D/roX/04Ic0DR3etfWyK8IRS7v6ojwyAsmdiHmXTVeJ6L6t6utkTJuPc3cG+deISX7F+nyF+dNdoi9O6OWPFCMUF5DtZlzZmUUML9VN+naL5AlUlvRvb/mW1OBf97LH1FbxbbKzYdD7G9cGUm5Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754326286; c=relaxed/simple;
	bh=AqcPPVKAFiDEqs7IeuMwfLPCDANnUMyqmUS0XYab7zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ja7flRdHsqI2dX44xBxh10b73WaePMLOR+eXArXfv/OxyPVMyvo3Cq+ERgQzxYUgXWmGYLPOKhsMxucC4dew3I28K229GL9juIHi6hH9omKahduMpxnEeeuPUQRoJ8L6Y//f6aLhQuFlzG/DQuS1zFH13FMQTezdHkOw+LGBnMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CHW0brDg; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CHW0brDg"
Date: Mon, 4 Aug 2025 12:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754326276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9y+lgqOQs9297y6789cubqB+C82Ps5kh2nfJwEoM1Q=;
	b=CHW0brDguedWfjDgNLu4R2De6hrvgMbhBlnhrA/PpBj8AuFfpXPAJ6zlsaDLdBah+m943y
	zKeSBRmVQPLzRMeaXT4VYi2qMW+860SrzLxyq1KM/h0xopL325tVJjXmMwoyhNqOwup7WL
	OwDmSilB2p+NErMt6rSiSqkXXSuuJ+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: Ignore accounting key type larger than
 BCH_DISK_ACCOUNTING_TYPE_NR
Message-ID: <32j33muxezudjmd5yvy5uem7qm2mwah7alfznfmyirpqfxr2jv@ybfwyuc2ktah>
References: <20250804164105.253084-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804164105.253084-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 12:41:05AM +0800, Alan Huang wrote:
> Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/disk_accounting.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index f96530c70262..5944ad6d0f8d 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -184,6 +184,9 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
>  	void *end = &acc_k + 1;
>  	int ret = 0;
>  
> +	if (acc_k.type >= BCH_DISK_ACCOUNTING_TYPE_NR)
> +		return 0;
> +
>  	bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
>  			 bversion_zero(k.k->bversion),
>  			 c, accounting_key_version_0,
> -- 
> 2.49.0
> 
