Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E487E59A;
	Tue, 22 Oct 2024 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563987; cv=none; b=MHo5wabNPKxcpMFuHRioPztvfheif7+JBqEbBzla4VhHOz6leRbGHrYnwyz/XgFVNTz+y7Crh5aOxRCBNL1MGqD7E9kz+AiWIp9s+oQ6cJNwO+nn2JGtfTolWwpsUwx5wDm6677E7edcK+mKhUEeW142AOTkuCUl1sqL+UC2T4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563987; c=relaxed/simple;
	bh=0hlYTnNTnCF4BX/BH09e+Ij5K2036mUnfhKmC6OSMQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OUjrMs6CptQPgXYf9VX/0TZsliXQ2/9d88XfoyCmo47ZO3f49po+9R/7geuTLGW3x3u0MP4o+0gU0W9jxATJFDzT5j8BJv05z6CtLklpveXsN1w2/SRkqaKUjh4Dqtp+/3wnQtvK91P//NZqAY2tmbxzdaDKI0WXUpRP0rkhP/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XXbcp2T59z20qjm;
	Tue, 22 Oct 2024 10:25:30 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A0BD8140360;
	Tue, 22 Oct 2024 10:26:20 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 10:26:20 +0800
Message-ID: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
Date: Tue, 22 Oct 2024 10:26:18 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Content-Language: en-US
To: Jeongjun Park <aha310510@gmail.com>, <kent.overstreet@linux.dev>,
	<mmpgouride@gmail.com>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>
References: <20241021154356.38221-1-aha310510@gmail.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241021154356.38221-1-aha310510@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/21 23:43, Jeongjun Park wrote:
> The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
> To fix this, we need to add validation on a.data_type in
> alloc_lru_idx_fragmentation().
> 
> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
>   fs/bcachefs/alloc_background.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
> index f8e87c6721b1..163a67b97a40 100644
> --- a/fs/bcachefs/alloc_background.h
> +++ b/fs/bcachefs/alloc_background.h
> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
>   static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>   					      struct bch_dev *ca)
>   {
> +	if (a.data_type >= BCH_DATA_NR)
> +		return 0;
> +

oh, I found I have done the same thing in [1]("Re: [syzbot] [bcachefs?] 
UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But in my humble 
opinion, the validation changes also should be added. And in addition, 
move the condition about a.data_type into data_type_movable will be 
better. Just my personal opinion.:)

[1] https://www.spinics.net/lists/kernel/msg5412619.html

Thanks,
Hongbo

>   	if (!data_type_movable(a.data_type) ||
>   	    !bch2_bucket_sectors_fragmented(ca, a))
>   		return 0;
> --
> 
