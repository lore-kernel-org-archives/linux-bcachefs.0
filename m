Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C6F1D86D2
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Nov 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730816916; cv=none; b=H7bSed2jO1t9SvjMGazsErrK1sldSVi/zcWJHggiWE4dr+4zsyiU2LaKhVPR2BZYHhjrL6QacBbCmlGaeVzJeH9McHhARNcgPz90LchdZ0Lc83O21kJz2/XTlrnwyw5sn7NXlW5W7pnljW5FR+mfPfXQPpmh4Wrf4pEtzpM+eBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730816916; c=relaxed/simple;
	bh=xTkxF/Wp40Df0OrYZ1i8Ba/DfcyS/8OambPY7UJdu5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=owllZDxWHbbLIf0JVHXdk59R4d1wdl8vSgSrEw9usriVlaNsdFt2C1bJl7lgfXOPjafR7o0UuVyd42fK/0hi2/zJaR/tMujSIgN1/OMLIDv4s9gwTsqsojF/2EVd4cCdqTRNuCGP4O7Teuqp5QOxjvYWheiZJW8Wm3tD0K2xC2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XjVzK12H2zQsC7;
	Tue,  5 Nov 2024 22:27:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 621A21400CF;
	Tue,  5 Nov 2024 22:28:31 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 22:28:31 +0800
Message-ID: <eef1d336-65e2-4650-92ac-8f6329f89a57@huawei.com>
Date: Tue, 5 Nov 2024 22:28:29 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix io_read/write counter with wrong unit
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20241105142224.2252301-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241105142224.2252301-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/11/5 22:22, Hongbo Li wrote:
> In bcachefs, io_read and io_write counter record the amount
> of data which has been read and written. They increase in
> unit of sector, so to display correctly, they need to be
> shifted to the left by the size of a sector.
> 
> Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
> When I read one 15.7M file, the io_read sysfs interface shows:
> - Before this patch
>    - original:
>      since mount:                   0 B
>      since filesystem creation:     5.11 KiB
> 
>    - after read:
>      since mount:                   31.4 KiB
>      since filesystem creation:     36.5 KiB
> 
> - After this patch:
>    - original:
>      since mount:                   0 B
>      since filesystem creation:     18.3 MiB
> 
>    - after read:
>      since mount:                   15.7 MiB
>      since filesystem creation:     34.0 MiB
> ---
>   fs/bcachefs/sysfs.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index 97733c766948..aa46b69da4d8 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -513,6 +513,11 @@ SHOW(bch2_fs_counters)
>   		if (attr == &sysfs_##t) {					\
>   			counter             = percpu_u64_get(&c->counters[BCH_COUNTER_##t]);\
>   			counter_since_mount = counter - c->counters_on_mount[BCH_COUNTER_##t];\
> +			if (attr == &sysfs_io_read || attr == &sysfs_io_write) {\
This is not enough. For io_move, move_extent_{read, write, finish} also 
need to be shifted to the left by the size of a sector. So how about 
shifting at the first time, not in here? In this way, it will do the 
transition for the older filesystem, because the counters have been 
persisted.

Thanks,
Hongbo
> +				counter <<= 9;					\
> +				counter_since_mount <<= 9;			\
> +			}							\
> +										\
>   			prt_printf(out, "since mount:\t");			\
>   			prt_human_readable_u64(out, counter_since_mount);	\
>   			prt_newline(out);					\
