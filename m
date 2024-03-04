Received: from mail-108-mta14.mxroute.com (mail-108-mta14.mxroute.com [136.175.108.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98451BA5E
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Mar 2024 06:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709532841; cv=none; b=Po1UYUehWFyiOckH0uM1rbBStEC8aZPaRgXeaWn75kL4H3h1Bvsa281ZUlVX2VVlGmXVLNwPaenyCgf5fPQEeSYCdvIY06+bHOOlIUcw4JZtrewD5++nmVAHJMCW8zwineDr0LF9BLwWVyG6kz3uUKP1lt8fnn99BcARFWCQ8hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709532841; c=relaxed/simple;
	bh=JA+ToT62ofN18tC9Y/a9EcQCQzLzVQ2/LikqbqFWxmQ=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=ihEjN4W0b3MSoMDkv9W30h4gfWeFj7HV6t1LsSzA+VSQRNVfnXFi2Jtp8siS4Sw4fpho/41pm14Mg7d+gXbPolEJcxTPSFZ+RvnblXhUZoTXlttQvElZARVMLn3uqhTBhpm03O1LRdM8q5ZZkMA1G4AHHq6NtDFWBvD75H3kj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=VehTBCH6; arc=none smtp.client-ip=136.175.108.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="VehTBCH6"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta14.mxroute.com (ZoneMTA) with ESMTPSA id 18e08143a6c0003bea.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 04 Mar 2024 06:08:47 +0000
X-Zone-Loop: 555d5018ae581a03e0251dae6dae5a6f69304ca75749
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nYqwQY5WZpB5b6Y6JJAAKQwIZSkHfM0YPUUkqlGVit8=; b=VehTBCH6AwnsY01KTB2REayOUu
	h1eNlti/BBAG8E9pYQoCgKCACBZKDWLs6WvX42i86tVb+OcCOp2TWR4pJBCT4wXU35r+TnwEpyFbv
	5PxrNXtNP+BMLlSUjwrsEej8PFqgCjpYLgcyKlyY+Tk43TZsle4eB4hbVmW2HYZkv54gNjpkSXq4D
	kjiwmv94Nb752a2YAZvRKZyUx9MCWT3QvxDF4yl74c9ZS3/DUmFJ2xh7P0vttceERpOy/uh4ZmVmR
	bFwIb5l6g/2etsUDEnsDK15Ngc2WlUws08/5NYfZClQcD1OKIbHb2K/oDAg+M2kTg6Z/awO4R1jtz
	LgDD0mAg==;
References: <20240304032203.3480001-1-lizetao1@huawei.com>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Li Zetao <lizetao1@huawei.com>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix null-ptr-deref in bch2_fs_alloc()
Date: Mon, 04 Mar 2024 13:12:07 +0800
In-reply-to: <20240304032203.3480001-1-lizetao1@huawei.com>
Message-ID: <frx6edjh.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Mon 04 Mar 2024 at 11:22, Li Zetao <lizetao1@huawei.com> wrote:

> There is a null-ptr-deref issue reported by kasan:
>
>   KASAN: null-ptr-deref in range 
>   [0x0000000000000000-0x0000000000000007]
>   Call Trace:
>     <TASK>
>     bch2_fs_alloc+0x1092/0x2170 [bcachefs]
>     bch2_fs_open+0x683/0xe10 [bcachefs]
>     ...
>
> When initializing the name of bch_fs, it needs to dynamically 
> alloc memory
> to meet the length of the name. However, when name allocation 
> failed, it
> will cause a null-ptr-deref access exception in subsequent 
> string copy.
>
bch2_printbuf_make_room() does return -ENOMEM but
bch2_prt_printf() doesn't check the return code. And there are too 
many
callers of bch2_prt_printf() don't check allocation_failure.

> Fix this issue by checking if name allocation is successful.
>
> Fixes: 401ec4db6308 ("bcachefs: Printbuf rework")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  fs/bcachefs/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 6b23e11825e6..24fa41bbe7e3 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -818,13 +818,13 @@ static struct bch_fs *bch2_fs_alloc(struct 
> bch_sb *sb, struct bch_opts opts)
>  		goto err;
>
>  	pr_uuid(&name, c->sb.user_uuid.b);
> -	strscpy(c->name, name.buf, sizeof(c->name));
> -	printbuf_exit(&name);
> -
>  	ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc 
>  : 0;
>  	if (ret)
>  		goto err;
>
IIRC, krealloc() doesn't free old pointer if new-size allocation 
failed.
There is no printbuf_exit called in label err then memory leak 
happens.

--
Su
>
> +	strscpy(c->name, name.buf, sizeof(c->name));
> +	printbuf_exit(&name);
> +
>  	/* Compat: */
>  	if (le16_to_cpu(sb->version) <= 
>  bcachefs_metadata_version_inode_v2 &&
>  	    !BCH_SB_JOURNAL_FLUSH_DELAY(sb))
