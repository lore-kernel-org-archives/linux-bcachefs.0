Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146D014F124
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727185499; cv=none; b=ogBuLy5BLhZoIH8KOpkDgNP8C8gyJf3hV0G0VkreE/V6y91IjmP9Arqh4cFRjGMjCqEL4BnMh7r9jxSRrKWfXA9NMABIm5cU/Irrpkw8ye+lmANu4yVtlzbGnclIrO1UNX9iFQMEQgxiE4300roCSLq/6pgUudNSngjXRDXHV8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727185499; c=relaxed/simple;
	bh=Y7E6ip9BOn+eTi6hYAN7FbMJMB0ffYuv9g6SnB4cVBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sWbRnVzZS8jOQ0Pdm0StRo+NKPU8F8JaloYM0jYtTxb4yso9Y9hmOPArBruX+SxQGaWO2NhKkMiHMXRZUgl0iCVtVGuBqDLdsDFyyHV08yngyRfDNrU8/p9igPLs1bh74/ptEq6ZtO5fZw0eCx6WtY4bA9uRhQMoGLc+n4VySos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XCh0l0Smdz2DcV1;
	Tue, 24 Sep 2024 21:44:07 +0800 (CST)
Received: from kwepemd100020.china.huawei.com (unknown [7.221.188.213])
	by mail.maildlp.com (Postfix) with ESMTPS id 4801C140153;
	Tue, 24 Sep 2024 21:44:53 +0800 (CST)
Received: from [10.67.110.73] (10.67.110.73) by kwepemd100020.china.huawei.com
 (7.221.188.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Sep
 2024 21:44:52 +0800
Message-ID: <05e88e7c-403e-41e7-88ed-b109f107e81c@huawei.com>
Date: Tue, 24 Sep 2024 21:44:52 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fast exit when darray_make_room failed
To: Hongbo Li <lihongbo22@huawei.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240924014224.701966-1-lihongbo22@huawei.com>
From: "zhangjianhua (E)" <chris.zjh@huawei.com>
In-Reply-To: <20240924014224.701966-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd100020.china.huawei.com (7.221.188.213)


在 2024/9/24 9:42, Hongbo Li 写道:
> In downgrade_table_extra, the return value is needed. When it
> return failed, we should exit immediately.

补丁标题讲的是函数失败后快速退出，很难理解fast的意义。

最好描述下当前代码会有什么问题，这样更有说服力。

>
> Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/sb-downgrade.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
> index c7e4cdd3f6a5..6f0493f79959 100644
> --- a/fs/bcachefs/sb-downgrade.c
> +++ b/fs/bcachefs/sb-downgrade.c
> @@ -353,7 +353,9 @@ int bch2_sb_downgrade_update(struct bch_fs *c)
>   		for (unsigned i = 0; i < src->nr_errors; i++)
>   			dst->errors[i] = cpu_to_le16(src->errors[i]);
>   
> -		downgrade_table_extra(c, &table);
> +		ret = downgrade_table_extra(c, &table);
> +		if (ret)
> +			goto out;
>   
>   		if (!dst->recovery_passes[0] &&
>   		    !dst->recovery_passes[1] &&
