Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522C71ACDE3
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 07:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728545422; cv=none; b=AXkh/FM8YWVXZmm50XQc/39WU9GJTCtE/YwCxDBMPCdkezSQFcSiUH0ABqq4lnbNMtRFs0bqr5GqaPJYP+Hbbnn2hLNUad9F7ChLd/n531cKyP051q8tpcXqEbkgASU+7XTsNnIqjSty+xOnzbZNLYbq8MWPr/MNxxUBdMqRU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728545422; c=relaxed/simple;
	bh=0FOTLd2AIc7O3aPGd/hV1wKZLe6xNmvePtGZ0W/cGRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SgVTMzD2yffeH8stux7CG1bq1bVOsPXv2HZSyqeTaxfss/ehgVMXJ1QFLDnEmzppLmEzFuZ6tizKUMooBtH1zwkU1FxOefJ3xhByX2REmQelYUOquov4XOl+AG2fNMwiVa3x/7NckrWJt+PNuxKG5t5NiB6vmjRfUNB+VZLTlc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XPLwj0NBqz1S9Cc;
	Thu, 10 Oct 2024 15:29:09 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 056CC140360;
	Thu, 10 Oct 2024 15:30:16 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 15:30:15 +0800
Message-ID: <545a0b57-6b0c-4d60-b697-b675bcc031b6@huawei.com>
Date: Thu, 10 Oct 2024 15:30:16 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs-tools: remove double start for fs when migrate
Content-Language: en-US
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240930093957.2580253-1-lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240930093957.2580253-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)

This patch is for bcachefs-tools to solve issue: #730. :)

On 2024/9/30 17:39, Hongbo Li wrote:
> bcachefs migrate will start fs twice, it will triggle BUG_ON
> condition and other troubles. Actually, we only need to start
> fs once.
> 
> Fixes: 38b8d01c4cf8 ("Update bcachefs sources to 481b5f343248 bcachefs: Better error messages for missing inodes in fsck")
> Closes: https://github.com/koverstreet/bcachefs/issues/730
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   c_src/cmd_migrate.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/c_src/cmd_migrate.c b/c_src/cmd_migrate.c
> index a5b7786d..f8b4acc8 100644
> --- a/c_src/cmd_migrate.c
> +++ b/c_src/cmd_migrate.c
> @@ -268,10 +268,6 @@ static int migrate_fs(const char		*fs_path,
>   	if (ret)
>   		die("Error allocating buckets_nouse: %s", bch2_err_str(ret));
>   
> -	ret = bch2_fs_start(c);
> -	if (IS_ERR(c))
> -		die("Error starting new filesystem: %s", bch2_err_str(ret));
> -
>   	mark_unreserved_space(c, extents);
>   
>   	ret = bch2_fs_start(c);
