Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CDF17BAF;
	Tue, 16 Jul 2024 06:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721109793; cv=none; b=jH7lhYq9d+CiC0uktr+yISXEY+fZk8vOiZ42r0YJ+6UsRV4E3wqYmJeyXCrZDQEdnVnFDhSXN9yfn+sfm64399bVsCN5b0DEKcPdgi39cZOTS8n+pLzuQX6i7rcZiclM/6p7idBj1A7/Fnd9+jDY5ljkp0ZinQkBzJ27WM0MMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721109793; c=relaxed/simple;
	bh=uO+5Yp6NoxyT/hK1BZMXgDQWFdPsMeek9I4I6d/8FI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HWsaNYYWgBU9p2xsCYwxB+vM8k9qTeBknxJPLoz44AJZiFPAo78P9v0hmSHI1+M/d3r0T4UFkUoJKNbngmbvwP4JiunGIlMl0v4GpBzur6yMAi95jbeReaxFpNl+/b/uEITsaCRajyIkDIF+mKyLyV4x37Xq14Fl3zK0r39LFNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WNT3712Mpzdhwv;
	Tue, 16 Jul 2024 14:01:23 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 564AC1800A1;
	Tue, 16 Jul 2024 14:03:06 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 16 Jul 2024 14:03:06 +0800
Message-ID: <2335e293-9ef4-46ad-b1bd-4416dfeda604@huawei.com>
Date: Tue, 16 Jul 2024 14:03:04 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Convert comma to semicolon
To: Chen Ni <nichen@iscas.ac.cn>, <kent.overstreet@linux.dev>,
	<bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240716040302.684034-1-nichen@iscas.ac.cn>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240716040302.684034-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/16 12:03, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Fixes: 79032b078173 ("bcachefs: Improved topology repair checks")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>   fs/bcachefs/btree_update_interior.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
> index 31ee50184be2..51b43d75ddb6 100644
> --- a/fs/bcachefs/btree_update_interior.c
> +++ b/fs/bcachefs/btree_update_interior.c
> @@ -96,7 +96,7 @@ int bch2_btree_node_check_topology(struct btree_trans *trans, struct btree *b)
>   			bch2_topology_error(c);
>   
>   			printbuf_reset(&buf);
> -			prt_str(&buf, "end of prev node doesn't match start of next node\n"),
> +			prt_str(&buf, "end of prev node doesn't match start of next node\n");

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo
>   			prt_printf(&buf, "  in btree %s level %u node ",
>   				   bch2_btree_id_str(b->c.btree_id), b->c.level);
>   			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
