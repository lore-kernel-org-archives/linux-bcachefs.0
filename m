Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8B2946F
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 02:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727230924; cv=none; b=unlfxT3XCKFT/FlraEYB+S03o+cru0VQVBvoc/IfFbtlDbGUVgKEXRJFPi9tCAFcFXC2DK2TjJvbiRvOLFI2qJ1EVdE8ygBgtq0pxyoelGJU8IIESrLmRVNVEhzUVoIm3uSxu73qO6y7LLx8uQlBZ86ZBHGfBtQ3iye9X3CVx0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727230924; c=relaxed/simple;
	bh=ajvJce1F1PDV72wDMVs/rtsoUH7SM/++mpXIPjnuZ+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HYnin6q8rSh7iQ23bR/7f0gU7eJsFW5XHLym5zghLMzp+oyoLTuSEOBnQVloT/j0ApnVTqXqfR0phILc06NMpaI9lZpNmMHliyyvNVMumHpPXJcdD/RoSlTJEotXGL0m9Dsy8DSK2+XbAaH59Nq+5PRonFCyCt9SelNSEpMOK4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XD0pH3jBjz1SBbl
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 10:21:11 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 05557140158
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 10:21:59 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 25 Sep 2024 10:21:58 +0800
Message-ID: <9136cbac-7603-4732-b8fe-b0cc89cb9e50@huawei.com>
Date: Wed, 25 Sep 2024 10:21:58 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: avoid copy from NULL printbuf
To: David Disseldorp <ddiss@suse.de>, <linux-bcachefs@vger.kernel.org>
References: <20240924025215.29891-1-ddiss@suse.de>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240924025215.29891-1-ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/24 10:52, David Disseldorp wrote:
> printbuf.buf may be NULL if allocation_failure is set. Check for this
> prior to using it as a seq_puts() source.
> 
> Fixes: fa8e94faeece1 ("bcachefs: Heap allocate printbufs")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> test test
> 
>   fs/bcachefs/fs.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 1aee5bafaae54..6e270bf24591d 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1931,13 +1931,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>   {
>   	struct bch_fs *c = root->d_sb->s_fs_info;
>   	struct printbuf buf = PRINTBUF;
> +	int ret = 0;
>   
>   	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
>   			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>   	printbuf_nul_terminate(&buf);
> -	seq_puts(seq, buf.buf);
> +	if (buf.allocation_failure)
> +		ret = -ENOMEM;
> +	else
> +		seq_puts(seq, buf.buf);
>   
May I fix here in the last patch "bcachefs: fix incorrect show_options 
results" in v2, and add you as co-author?

Thanks,
Hongbo

> -	int ret = buf.allocation_failure ? -ENOMEM : 0;
>   	printbuf_exit(&buf);
>   	return ret;
>   }
