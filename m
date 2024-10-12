Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7BF41C6E
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 03:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728704258; cv=none; b=BC/D7Tj6KWORt6vcNZFnbfKliVp+FpgrjHiHIoAlTv7zTesVRAwADp2hdSPCe59phRYipTmgqyYhTArLiM9Pd9M56VlPoq+XzD6bZwRAbMysihv8uOPhcYYMCMyvG9ZV8CL4UwuOCzAzgXqwPkbmJZujzrYFoYm4fQ4pOG+E/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728704258; c=relaxed/simple;
	bh=Ty3fSbVQwFvxelSpLbInp4ii2L8l1adukIfbZFVv9Bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UtbVLE5Ye8K3QEZvzDlFwbQSLPO8hBL3pgfrUhHv8xBoZuh802clhd9v83U5mT7l4T6tw5KVWB9ViVHbpjUjR04neh24splBTMroZkO41W4ei4cvsi3i4BuNsVMP482kmvpduwROgVr+tgFZw3JJSjiIJyARZpKNqZE3SJ+ZNHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XQTfN07Xlz1T7xV;
	Sat, 12 Oct 2024 11:35:40 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id DBF7614011F;
	Sat, 12 Oct 2024 11:37:26 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 12 Oct 2024 11:37:26 +0800
Message-ID: <e15d904d-1a0b-4492-94e4-8fe6db6a22ac@huawei.com>
Date: Sat, 12 Oct 2024 11:37:27 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Fix invalid shift in member_to_text()
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
CC: <syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com>
References: <20241012020953.3306834-1-kent.overstreet@linux.dev>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241012020953.3306834-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/12 10:09, Kent Overstreet wrote:
> Reported-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>   fs/bcachefs/sb-members.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index 02bcde3c1b02..b06ba1d0d037 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -247,7 +247,10 @@ static void member_to_text(struct printbuf *out,
>   	prt_newline(out);
>   
>   	prt_printf(out, "Btree allocated bitmap blocksize:\t");
> -	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> +	if (m.btree_bitmap_shift < 64)
> +		prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> +	else
> +		prt_printf(out, "(invalid shift %u)", m.btree_bitmap_shift);

I wonder why we don't check in .validate, like the former 
csum_granularity_bits does.

Thanks,
Hongbo

>   	prt_newline(out);
>   
>   	prt_printf(out, "Btree allocated bitmap:\t");
