Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A859B45BE8
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 03:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709263617; cv=none; b=jo21KXMsIJmH/8/YKL8cPuLI9r8Wrv+hp4nUry7RMb4us9w63PwlNOr/V6fuYZAuffN3W10ws2OVAJsOfAnxmRHbYk8K4wJigN+5Ji36SqyRrL1rq2Hy/NfuRXH13yIztmU/R30FJpJELPr5Vf7I7axdnQUS1vHNx7+H3TgE8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709263617; c=relaxed/simple;
	bh=Fv2ZcrdJQ0L5V10TnMxP5Ph4Lp2awefcn0mTMHKKJRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mJiXbI2pRyihvuKQ1maPHThhpL7PChdeKv0kIJJzYf/pr+RnJdJeqD7DNWDRmQnr79CsU4F153wyoEC6HngxwLddOKfkn0AwBPfm0EQfk+SbTacjzibY93HXHTLtNlY/AOwM3V4luK4h6ENWTBC82Cahhfr0V1v1UhV8fr/ZHa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TmD3R2gcSz1Q9SG;
	Fri,  1 Mar 2024 11:24:35 +0800 (CST)
Received: from kwepemi500008.china.huawei.com (unknown [7.221.188.139])
	by mail.maildlp.com (Postfix) with ESMTPS id 327D014011D;
	Fri,  1 Mar 2024 11:26:52 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 1 Mar 2024 11:26:51 +0800
Message-ID: <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
Date: Fri, 1 Mar 2024 11:26:51 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] bcachefs: avoid returning private error code in
 bch2_xattr_bcachefs_set
To: Hongbo Li <lihongbo22@huawei.com>, <kent.overstreet@linux.dev>,
	<bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240301031745.1912157-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20240301031745.1912157-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500008.china.huawei.com (7.221.188.139)



On 2024/3/1 11:17, Hongbo Li wrote:
> Avoid the private error code return to caller. The error code
> should be transformed into genernal error code.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/xattr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> index 9c0d2316031b..754f17bba68e 100644
> --- a/fs/bcachefs/xattr.c
> +++ b/fs/bcachefs/xattr.c
> @@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
>  		kfree(buf);
>  
>  		if (ret < 0)
> -			return ret;
> +			goto err_class_exit;
>  
>  		ret = bch2_opt_check_may_set(c, opt_id, v);
>  		if (ret < 0)
> -			return ret;
> +			goto err_class_exit;
>  
>  		s.v = v + 1;
>  		s.defined = true;
> @@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
>  	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
>  		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
>  
> +err_class_exit:
>  	return bch2_err_class(ret);

那前面的return -ENOMEM和return -EINVAL不用转换吗

>  }
>  
