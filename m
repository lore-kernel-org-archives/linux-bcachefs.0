Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973683CC1
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 07:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725521328; cv=none; b=fBVMnxKywfuFyNXEIPPHoYsbQVJC23fV7HKAzeZfVzcSJKc6NeZJ1w4sA2yKJPS1XIaWvyIpn/0WITCV381zrIkdesCrAtoyw/o7M0LHK0rVOXvV4sRL5o0cVtNBFvte1cQVGs+br9w8J6wuM27azomCmEo5nmrwRP5Z+NG3+ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725521328; c=relaxed/simple;
	bh=QW8+D6WMjJkLB2imbVv6KdvjI7lN05NJQX56hfcVlis=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YsX5Koln7ZXy7tJ5vrNbYRenbwnZarh7jLrNwSSFeRrBQv17w+nE+WyBbHpccYBk9fl7bsNBdG83NSyI4yH0HZMqIi2bEfVZBRwLcGOBlDbryLiaJpQT3jCzhqAMivJ7dIJjBibvx+W9/jNXotDBXHnn9sHnzMtOjGyFIyJaadY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzrWv5c2Qzfbhv;
	Thu,  5 Sep 2024 15:26:35 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EC5A18005F;
	Thu,  5 Sep 2024 15:28:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 15:28:43 +0800
Message-ID: <b696e5c8-6f79-492d-8b66-fd012f5d69c5@huawei.com>
Date: Thu, 5 Sep 2024 15:28:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "bcachefs: Ignore unknown mount options"
Content-Language: en-US
To: David Disseldorp <ddiss@suse.de>, <linux-bcachefs@vger.kernel.org>
CC: Martin Doucha <martin.doucha@suse.com>
References: <20240905020956.29821-1-ddiss@suse.de>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240905020956.29821-1-ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/5 10:09, David Disseldorp wrote:
> This reverts commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b.
> 
May be the subject should be Fix .... The original commit 
03ef80b469d5d83530ce1ce15be78a40e5300f9b has been changed by other change.
> Contrary to the commit message, unknown mount options do result in
> failure on other filesystems such as xfs, btrfs, ext4, etc.
> 
> Ignoring unknown options may result in unexpected behaviour: e.g. if
> an application requires future-workload-specific-mount-option to work
> and is run on a system without future-workload-specific-mount-option
> kernel support, then it may fail without indication of the missing
> kernel functionality.
> 
> This reversion may cause failures for existing users reliant on the
> ignore-unknown behaviour, but it should be bearable given bcachefs is
> still flagged experimental.
> 
> Reported-by: Martin Doucha <martin.doucha@suse.com>
> Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   fs/bcachefs/opts.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index e10fc1da71b1..bc5c18087821 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -482,9 +482,8 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
>   		val = "0";
>   	}
>   
> -	/* Unknown options are ignored: */
>   	if (id < 0)
> -		return 0;
> +		goto bad_opt;
As other filesystem done, for unknown options, it prints the `Unknown 
parameter` to hint the user. May be goto bad_opt is not reasonable.

Thanks,
Hongbo

>   
>   	if (!(bch2_opt_table[id].flags & OPT_MOUNT))
>   		goto bad_opt;
