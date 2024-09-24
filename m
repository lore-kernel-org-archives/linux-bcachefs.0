Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414883CD6
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 13:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727184457; cv=none; b=G1edprtyHFAqxLX0ewQ5HrX/vpb6U7jySG/lIOuF8fvkMcPGwAJyjVwudodcVv7XvM+EqaajNocjziRPMPDBP9+CRlCbNTey6FPKHuOM5mpkNrO/LMgyGFrswkcJ+fF9HT51wo50S4kri8YSYndvtEpLK/LFt3Y5k4X+mOTU8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727184457; c=relaxed/simple;
	bh=1iA2SOPMtfAM12zjijw7XuYVvps2oz0dcma6Vq8QSDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=I+bhqAkm54wIJIrJzWFM3k98v4uPoB4HsvK7edX8kr2Fnbbd4dYqLr2kegSb2yEohktzSZPkczPywxzaoVAiID17AWyJ/e0Fr75eiVFBdK2tUWwNR9qLsZm0iuu/vSSMVXidu7LOk8eQim87+fvl3vvwEifeFIxj53GEvbHBsdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XCgcQ6F6FzySK8;
	Tue, 24 Sep 2024 21:26:30 +0800 (CST)
Received: from kwepemd100020.china.huawei.com (unknown [7.221.188.213])
	by mail.maildlp.com (Postfix) with ESMTPS id EEAED180AE8;
	Tue, 24 Sep 2024 21:27:30 +0800 (CST)
Received: from [10.67.110.73] (10.67.110.73) by kwepemd100020.china.huawei.com
 (7.221.188.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Sep
 2024 21:27:30 +0800
Message-ID: <d3b52aaf-31c8-45d7-b244-761a487bfdfa@huawei.com>
Date: Tue, 24 Sep 2024 21:27:29 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix the memory leak in exception case
To: Hongbo Li <lihongbo22@huawei.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240924014146.701917-1-lihongbo22@huawei.com>
From: "zhangjianhua (E)" <chris.zjh@huawei.com>
In-Reply-To: <20240924014146.701917-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd100020.china.huawei.com (7.221.188.213)

LGTM

在 2024/9/24 9:41, Hongbo Li 写道:
> The pointer clean points the memory allocated by kmemdup, when the
> return value of bch2_sb_clean_validate_late is not zero. The memory
> pointed by clean is leaked. So we should free it in this case.
>
> Fixes: a37ad1a3aba9 ("bcachefs: sb-clean.c")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/sb-clean.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
> index 025848a9c4c0..005275281804 100644
> --- a/fs/bcachefs/sb-clean.c
> +++ b/fs/bcachefs/sb-clean.c
> @@ -167,6 +167,7 @@ struct bch_sb_field_clean *bch2_read_superblock_clean(struct bch_fs *c)
>   
>   	ret = bch2_sb_clean_validate_late(c, clean, READ);
>   	if (ret) {
> +		kfree(clean);
>   		mutex_unlock(&c->sb_lock);
>   		return ERR_PTR(ret);
>   	}
