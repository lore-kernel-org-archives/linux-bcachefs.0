Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316AA14D431
	for <linux-bcachefs@vger.kernel.org>; Tue, 23 Jul 2024 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735990; cv=none; b=lwJJhC76Ry6ku+3s/TAL7dCmf0mSt3RiPG4M6psMaQPkf5VgUetlRHZ1OH8TdrWotpKAnXucKpJiTyCNWzyg/DMAmNFGZFR6oe/T4K7vEU0nBur3SM0FAv7rO/KtzDpQfCY+nGR039zOpFIuQagh8uH4rKWcE1FGPhKbyx1fkQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735990; c=relaxed/simple;
	bh=g72uco3MmDoba/fTTr4AuoEvJFQE5ss204c7ng1Ao5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DNB56JLif7vUkR0XihckfBEw3iD/WWWF08on3zS9Sht1bCCLBzRhgIjxoqADAde83xcEpVJHFerxZiWhNuGCREdadcnwfwPBH7NqG96ptz2zcG58oeCKQZkjBIRk9sSLez0nXUN6TF6gCA/93SEsEiVXzUzo4Zv6GsGWL2XA7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WSwfS1Mt0znbnl;
	Tue, 23 Jul 2024 19:58:56 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B8CA1800A2;
	Tue, 23 Jul 2024 19:59:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 23 Jul 2024 19:59:43 +0800
Message-ID: <3b4b496d-1ac5-466b-9377-f4bb47af325a@huawei.com>
Date: Tue, 23 Jul 2024 19:59:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: prevent lookuping excessively long paths
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240709081020.3728942-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240709081020.3728942-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Hi, Kent,

Give you a friendly ping.🙂

Thanks,
Hongbo

On 2024/7/9 16:10, Hongbo Li wrote:
> The longest name length for file is BCH_NAME_MAX in bcachefs.
> When looking up a longer path, it does not check this limit. So
> we add the validation for this to avoid undetermined risk.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/fs.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index fd01a5402c28..f8da598ca9f8 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -474,6 +474,9 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
>   	struct bch_inode_info *dir = to_bch_ei(vdir);
>   	struct bch_hash_info hash = bch2_hash_info_init(c, &dir->ei_inode);
>   
> +	if (dentry->d_name.len > BCH_NAME_MAX)
> +		return ERR_PTR(-ENAMETOOLONG);
> +
>   	struct bch_inode_info *inode;
>   	bch2_trans_do(c, NULL, NULL, 0,
>   		PTR_ERR_OR_ZERO(inode = bch2_lookup_trans(trans, inode_inum(dir),
