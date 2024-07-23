Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552A728E8
	for <linux-bcachefs@vger.kernel.org>; Tue, 23 Jul 2024 12:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721736031; cv=none; b=Pw6q3TdwNStDleAGxTeZamI530PfzIDr7IKv5bTMuggWvQ0iAfZ+sKoRHZVYmXXsvbCokEAQs4E3fWyl3eSuvIHWpIEb9hrDuWfP7OrGVycULONvUzSYkRY7V2uHdTzklZFO/Yz6MZH7RahCfeeJHP8uuT4Ie962HXjnS/54d/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721736031; c=relaxed/simple;
	bh=YOoGyWviMMMDcfgZ3X5tnmAvYJDW1fu6g3HLzngTGuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CzVZVo3AX2HcIgFlYOl5607+v5zWfz0hcP4zM2XthXFWuYP301ejGrrCt7Y0rq0VgcFiC7My380oOZh9ph52TqWDFze3ME/lYGhIC9LloCIb47tr3RQrwNy7FPJknt3mfuexJNSTKbSJyThbVaIPWt/YTRhiIK9ecCPxRqgRxWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WSwf45FsnzMqRq;
	Tue, 23 Jul 2024 19:58:36 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 67564180100;
	Tue, 23 Jul 2024 20:00:23 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 23 Jul 2024 20:00:23 +0800
Message-ID: <5c7d8271-9403-43ab-8020-3184aabca8a8@huawei.com>
Date: Tue, 23 Jul 2024 20:00:22 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: add FS_IOC_SETVERSION support
Content-Language: en-US
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240705071930.2768828-1-lihongbo22@huawei.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240705071930.2768828-1-lihongbo22@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Hi, Kent,

Give you a friendly ping.🙂

Thanks,
Hongbo

On 2024/7/5 15:19, Hongbo Li wrote:
> As i_generation is used in bcachefs, updating this value by ioctl
> (FS_IOC_SETVERSION) should be allowed. Here we implement this cmd
> to support modify i_generation.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/fs-ioctl.c | 53 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index aea8132d2c40..33728bbab778 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -277,6 +277,54 @@ static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
>   	return put_user(inode->v.i_generation, arg);
>   }
>   
> +static int bch2_inode_version_set(struct btree_trans *trans,
> +				  struct bch_inode_info *inode,
> +				  struct bch_inode_unpacked *bi,
> +				  void *p)
> +{
> +	struct bch_fs *c = inode->v.i_sb->s_fs_info;
> +	__u32 *generation = p;
> +
> +	inode->v.i_generation = bi->bi_generation = *generation;
> +	bi->bi_ctime = timespec_to_bch2_time(c, current_time(&inode->v));
> +
> +	return 0;
> +}
> +
> +static int bch2_ioc_setversion(struct bch_fs *c,
> +			       struct file *file,
> +			       struct bch_inode_info *inode,
> +			       void __user *arg)
> +{
> +	int ret;
> +	__u32 generation;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	inode_lock(&inode->v);
> +	if (!inode_owner_or_capable(file_mnt_idmap(file), &inode->v)) {
> +		ret = -EACCES;
> +		goto setversion_out;
> +	}
> +
> +	if (get_user(generation, (int __user *) arg)) {
> +		ret = -EFAULT;
> +		goto setversion_out;
> +	}
> +
> +	mutex_lock(&inode->ei_update_lock);
> +	ret = bch2_write_inode(c, inode, bch2_inode_version_set, &generation, ATTR_CTIME);
> +	mutex_unlock(&inode->ei_update_lock);
> +
> +setversion_out:
> +	inode_unlock(&inode->v);
> +	mnt_drop_write_file(file);
> +
> +	return ret;
> +}
> +
>   static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
>   {
>   	int ret;
> @@ -567,7 +615,7 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>   		break;
>   
>   	case FS_IOC_SETVERSION:
> -		ret = -ENOTTY;
> +		ret = bch2_ioc_setversion(c, file, inode, (int __user *) arg);
>   		break;
>   
>   	case FS_IOC_GETFSLABEL:
> @@ -622,6 +670,9 @@ long bch2_compat_fs_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>   	case FS_IOC32_GETVERSION:
>   		cmd = FS_IOC_GETVERSION;
>   		break;
> +	case FS_IOC32_SETVERSION:
> +		cmd = FS_IOC_SETVERSION;
> +		break;
>   	case FS_IOC_GETFSLABEL:
>   	case FS_IOC_SETFSLABEL:
>   		break;
