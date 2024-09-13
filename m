Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B2B1D58A8;
	Fri, 13 Sep 2024 10:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726224610; cv=none; b=rWLrYQXIeTonX4ANFFkmgEFgRUFJHPGWXADiRz0R7jSdzNfKuSeYSyVlPWje1zukGswWacgzTLkwq78+CEf05XjmdGTVgQHl+xzyl6mqz6b6eMepPQmM+gIae2XBD/V890d8h58hE0FjRoazcSPspZAVJPJu6Td5bz64pLnXnVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726224610; c=relaxed/simple;
	bh=L83lR63io4j6s3xsgeWE51cq/fz1EEAeJRfd02TCykM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GC/7ilBbXbyeuSMLd1rkg7mL97LXMH33j6XYh8QGb8NA4HLo773SUTWM0c9ucEO5lPbC5xdxOV5KngFOxWUxyPtNTkfubms3f7JUAg0FnV1Fbd6Io2E8BIZ1tXwoXIBIVMdN6DsD5XQAPZddIHTyPvgFQHNHj4Qthv2NIiM40Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4X4rdy1j1mzyRyb;
	Fri, 13 Sep 2024 18:49:10 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B89B18010B;
	Fri, 13 Sep 2024 18:49:58 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 18:49:57 +0800
Message-ID: <e4cb7950-c88b-478a-80cc-ef2f244bf484@huawei.com>
Date: Fri, 13 Sep 2024 18:49:57 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Change opts param to const pointer in
 bch2_opts_to_text
To: Riyan Dhiman <riyandhiman14@gmail.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240912183545.41669-2-riyandhiman14@gmail.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240912183545.41669-2-riyandhiman14@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/13 2:35, Riyan Dhiman wrote:
> Convert struct bch_opts opts to const struct bch_opts *opts in
> bch2_opts_to_text() function paramter. This improves efficiency by
> avoiding structure copying and reflects the function's read-only
> access to opts.
> 
> Fixes: 283ba1b92b1c (bcachefs: bch2_opts_to_text())
> Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
> ---
> Compile tested only.
> 
>   fs/bcachefs/fs.c   | 2 +-
>   fs/bcachefs/opts.c | 4 ++--
>   fs/bcachefs/opts.h | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index e44794f7c6a0..1a2ba8472cb1 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1924,7 +1924,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>   	struct bch_fs *c = root->d_sb->s_fs_info;
>   	struct printbuf buf = PRINTBUF;
>   
> -	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
> +	bch2_opts_to_text(&buf, &c->opts, c, c->disk_sb.sb,
>   			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>   	printbuf_nul_terminate(&buf);
>   	seq_puts(seq, buf.buf);
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 232be8a44051..6216ab5d5c81 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -444,7 +444,7 @@ void bch2_opt_to_text(struct printbuf *out,
>   }
>   
>   void bch2_opts_to_text(struct printbuf *out,
> -		       struct bch_opts opts,
> +		       const struct bch_opts *opts,
>   		       struct bch_fs *c, struct bch_sb *sb,
>   		       unsigned show_mask, unsigned hide_mask,
>   		       unsigned flags)
> @@ -457,7 +457,7 @@ void bch2_opts_to_text(struct printbuf *out,
>   		if ((opt->flags & hide_mask) || !(opt->flags & show_mask))
>   			continue;
>   
> -		u64 v = bch2_opt_get_by_id(&opts, i);
> +		u64 v = bch2_opt_get_by_id(opts, i);
>   		if (v == bch2_opt_get_by_id(&bch2_opts_default, i))
>   			continue;
>   
> diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
> index cb2e244a2429..78e1991dc4be 100644
> --- a/fs/bcachefs/opts.h
> +++ b/fs/bcachefs/opts.h
> @@ -606,7 +606,7 @@ int bch2_opt_parse(struct bch_fs *, const struct bch_option *,
>   void bch2_opt_to_text(struct printbuf *, struct bch_fs *, struct bch_sb *,
>   		      const struct bch_option *, u64, unsigned);
>   void bch2_opts_to_text(struct printbuf *,
> -		       struct bch_opts,
> +		       const struct bch_opts *,
>   		       struct bch_fs *, struct bch_sb *,
>   		       unsigned, unsigned, unsigned);
>   
