Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACA15442D;
	Fri, 13 Dec 2024 03:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734060461; cv=none; b=SX3wj598JyMaH1AQtNzgRE71J4dPs1XzitxLRTFLS+iIPMdM6Fwl/NGAwnCKh0FMqqPa5aSQFOgQVph6zANsxZQW6C7HRpc6ohtr7WIo6O4rLcRxHBgijDJtR0Ev/g/PXdtiT3i/KLnice/cHvhGnSMYnrHcd0AfHBRs2Rq+aL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734060461; c=relaxed/simple;
	bh=4/jjuC43vN8x2oeyOx4d7hEt+VL5EwzaZxHOlSTloCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Lrz4elE0l10bSh9MoJhK1H3p9enUCATi2n6aT/m9p8n/HGHxD48cdwicNQ0FLO2QVMlBg9j+uXuuJGAdlXAKNHWmrMMCm/XARYNVLeVOuAo7K8Uw2NhheQkJyU8kBfkGVO4/ljO/Jwbm4g4BNL/Ms9ghqdHrENwFqG9XtBw7GRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y8ZX04m5mz1JF7P;
	Fri, 13 Dec 2024 11:27:12 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B72D140123;
	Fri, 13 Dec 2024 11:27:29 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Dec 2024 11:27:29 +0800
Message-ID: <bf18e0fb-d436-46ea-9c8f-408e948965db@huawei.com>
Date: Fri, 13 Dec 2024 11:27:28 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix invalid declaration after label in
 str_hash.c
To: Zhou Ding <zhouding@cmss.chinamobile.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20241212104912.122899-1-zhouding@cmss.chinamobile.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241212104912.122899-1-zhouding@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2024/12/12 18:49, Zhou Ding wrote:
> We get 1 error when building kernel withW=1:
> fs/bcachefs/str_hash.c:164:2: error: a label can only be part of a statement and a declaration is not a statement
> 
> To resolve this, the code after the found: label was enclosed in a block
> to comply with C89 rules, without affecting the logic of the code.
> 
> Signed-off-by: Zhou Ding <zhouding@cmss.chinamobile.com>
> ---
>   fs/bcachefs/str_hash.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
> index ed3c852fc0be..08625947ed99 100644
> --- a/fs/bcachefs/str_hash.c
> +++ b/fs/bcachefs/str_hash.c
> @@ -160,7 +160,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
>   	bch_err(c, "%s(): inum %llu not found", __func__, inum);
>   	ret = -BCH_ERR_fsck_repair_unimplemented;
>   	goto err;
> -found:
It has been fixed in [1].:)

Thanks,
Hongbo

[1] 
https://lore.kernel.org/linux-bcachefs/qnfn3xzh6ve5cukeugxucloynbstf2itos3ddlmzu2w4sp7md7@7bkk2byif2ja/T/#t
> +found:{
>   	struct bch_inode_unpacked inode;
>   	ret = bch2_inode_unpack(k, &inode);
>   	if (ret)
> @@ -174,6 +174,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
>   			ret = -BCH_ERR_fsck_repair_unimplemented;
>   		}
>   	}
> +}
>   err:
>   	bch2_trans_iter_exit(trans, &iter);
>   	return ret;
