Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DAF147C7E
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Apr 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712834965; cv=none; b=N57mFi9OOKMVKZFuOTQgiJVyi2PFYtUj9fnBTV8fWHMOZbEp95vK3ttGL4tSvXFqiysHN4B/UUgfN/tAKdgUCHPTNT65xpTa6Pah+dBjzx/RATpxuzVC4Cs7IgMobRjk8p2EcUY1fllr8rnyN0h/DR1Ryp01KEr69FzO2sQxE3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712834965; c=relaxed/simple;
	bh=kDjkeuBmdTOXy3gV6ST2xlU7ToVmgn8e+CDL8boAiLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pxwxxeZqwOveUXAhbQlBn+pnIywp5JvG74TNaXMUBEywpomzfCL2YsaQfmOPlb6aK8yXJZiWN4OV1JRkAKNBGZgU8LEjzGXndQ8IO34ijAjLpssZXqZp7YEcspvXAPZ/TZGK8AdqUIn3ZIEP+n6rlvgSt7CJsOLQ/qiiuNfi2lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VFcrw3rMxz1GGjw;
	Thu, 11 Apr 2024 19:28:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id BA1BA18002F;
	Thu, 11 Apr 2024 19:29:19 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 19:29:19 +0800
Message-ID: <a021f61e-dc98-4324-916c-c65c6d979cc0@huawei.com>
Date: Thu, 11 Apr 2024 19:29:19 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix error path of __bch2_read_super()
To: Chao Yu <chao@kernel.org>, <kent.overstreet@linux.dev>,
	<bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240411100829.1729332-1-chao@kernel.org>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240411100829.1729332-1-chao@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/4/11 18:08, Chao Yu wrote:
> In __bch2_read_super(), if kstrdup() fails, it needs to release memory
> in sb->holder, fix to call bch2_free_super() in the error path.
> 
> Signed-off-by: Chao Yu <chao@kernel.org>
> ---
>   fs/bcachefs/super-io.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index ad28e370b640..cec1470c2dd9 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -698,8 +698,10 @@ static int __bch2_read_super(const char *path, struct bch_opts *opts,
>   		return -ENOMEM;
>   
>   	sb->sb_name = kstrdup(path, GFP_KERNEL);
> -	if (!sb->sb_name)
> -		return -ENOMEM;
> +	if (!sb->sb_name) {
> +		ret = -ENOMEM;
maybe you should fill err with message info by prt_printf(xxx), because 
err with no message info when printed in bch2_print_opts.
> +		goto err;
> +	}
>   
>   #ifndef __KERNEL__
>   	if (opt_get(*opts, direct_io) == false)
