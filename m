Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9451DDC33
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740189588; cv=none; b=ROK2oG+16KKS0OqphNAwqIiUEns5LJvzJnILuPowIwkeIpg+lgSkm8breLR7HCyjTzhGVhGV5hZOQnyXfb6KK8OoYZK0h2uQ1UdUSNo0yXWdyyPWGbU0Fl8ecRrYtUHoY31bjmG4hwaq8xkfLH9UsPOhkscD763YRsmHpA08lck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740189588; c=relaxed/simple;
	bh=vbleC6H7jQXMikxmB22lTk8yDTl44r5AIsU9gVJxpj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ecvjidsYhrIMgb24+7j34boRNzXrLzySFBNYqPI6r3+BUsFYYP0J4JF2CqP0llIAynDUyNSPgZq8/7SRd9w+MrccJARyqYAPeLUrzAnKF4Z4bm643jIlFJJ7uJZ/o6GHjvy6wqyq8c/GP1Jqb3XDBua5Gp0r6gxydi9pKdA0AOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z097h3nMbz2JYYw;
	Sat, 22 Feb 2025 09:55:44 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id A6F5F140489;
	Sat, 22 Feb 2025 09:59:42 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Feb 2025 09:59:42 +0800
Message-ID: <67c29878-b3e7-4995-acce-c535c8ce4d59@huawei.com>
Date: Sat, 22 Feb 2025 09:59:41 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix directory i_size checking for the last
 entry
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20250222012412.460211-1-lihongbo22@huawei.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20250222012412.460211-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/2/22 9:24, Hongbo Li wrote:
> Checking the i_size of the last directory entry when fsck.
> 
> Fixes: b9ddb3e1a8aa ("bcachefs: Fix fsck directory i_size checking")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/fsck.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index 9bf316e7b845..a9480bb308b2 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -2470,7 +2470,8 @@ int bch2_check_dirents(struct bch_fs *c)
>   				POS(BCACHEFS_ROOT_INO, 0),
>   				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
>   			check_dirent(trans, &iter, k, &hash_info, &dir, &target, &s)) ?:
> -		check_subdir_count_notnested(trans, &dir));
> +		check_subdir_count_notnested(trans, &dir) ?:
> +		check_dir_i_size_notnested(trans, &dir));
>   
Hi, Kent
   I mentioned this issue in [1], and it needs to be fixed.:)

[1] 
https://lore.kernel.org/linux-bcachefs/be487d83-14ab-46f8-a5d8-f923bc7f7a2a@huawei.com/T/#t

>   	snapshots_seen_exit(&s);
>   	inode_walker_exit(&dir);
