Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFA228DA0;
	Tue,  9 Jul 2024 02:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720490691; cv=none; b=A9z8Cv3leN86HeT6vuJzveJpS++dMzzbqanITpIkkGMri2kpxMujZzo/hUevLsGqTLMjveRsAuM6nJ3gmGlkdg61OI8xPcGp5Nj88MfPOLFB/VQE69ugYO9ZSsknZERlIqtQ2OJ5VZw/UOGZjNyqeVuK4+1edpzOwJI/YXvZ7Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720490691; c=relaxed/simple;
	bh=n8hb/CNphIAny4wEPf7GOM3MtNj+ieqshN3i4LQsPhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W9DHTZZTvHCSrgc7tivvoefjjNLCZC+LHTiidUUd2MU6xUS2iDR8rPsAXu9AVk+WgQesXvL5pceI4Z9tc10LONUFqeb7BO45p4qPFL29+pBZzE0KErLYDuCH9ySMkKKiqpCzXIVEKmAbKw7DCuT/Yx6JuHuxGwXYBCtufzHlpVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WJ42q2wnpz1yvCd;
	Tue,  9 Jul 2024 10:00:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C3FB140257;
	Tue,  9 Jul 2024 10:04:45 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 10:04:45 +0800
Message-ID: <8a1b37b5-450c-4f12-978e-25d691fbf21b@huawei.com>
Date: Tue, 9 Jul 2024 10:04:44 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: Add support for FS_IOC_GETFSSYSFSPATH
To: Youling Tang <youling.tang@linux.dev>, Kent Overstreet
	<kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240709011134.79954-1-youling.tang@linux.dev>
 <20240709011134.79954-2-youling.tang@linux.dev>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240709011134.79954-2-youling.tang@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/9 9:11, Youling Tang wrote:
> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> [TEST]:
> ```
> $ cat ioctl_getsysfspath.c
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <fcntl.h>
>   #include <sys/ioctl.h>
>   #include <linux/fs.h>
>   #include <unistd.h>
> 
>   int main(int argc, char *argv[]) {
>       int fd;
>       struct fs_sysfs_path sysfs_path = {};
> 
>       if (argc != 2) {
>           fprintf(stderr, "Usage: %s <path_to_file_or_directory>\n", argv[0]);
>           exit(EXIT_FAILURE);
>       }
> 
>       fd = open(argv[1], O_RDONLY);
>       if (fd == -1) {
>           perror("open");
>           exit(EXIT_FAILURE);
>       }
> 
>       if (ioctl(fd, FS_IOC_GETFSSYSFSPATH, &sysfs_path) == -1) {
>           perror("ioctl FS_IOC_GETFSSYSFSPATH");
>           close(fd);
>           exit(EXIT_FAILURE);
>       }
> 
>       printf("FS_IOC_GETFSSYSFSPATH: %s\n", sysfs_path.name);
>       close(fd);
>       return 0;
>   }
> 
> $ gcc ioctl_getsysfspath.c
> $ sudo bcachefs format /dev/sda
> $ sudo mount.bcachefs /dev/sda /mnt
> $ sudo ./a.out /mnt
>    FS_IOC_GETFSSYSFSPATH: bcachefs/c380b4ab-fbb6-41d2-b805-7a89cae9cadb
> ```
> 
> Original patch link:
> [1]: https://lore.kernel.org/all/20240207025624.1019754-8-kent.overstreet@linux.dev/
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Youling Tang <youling.tang@linux.dev>
> ---
>   fs/bcachefs/fs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 011ee5075a52..8699770398d1 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1978,6 +1978,7 @@ static int bch2_fs_get_tree(struct fs_context *fc)
>   	sb->s_time_min		= div_s64(S64_MIN, c->sb.time_units_per_sec) + 1;
>   	sb->s_time_max		= div_s64(S64_MAX, c->sb.time_units_per_sec);
>   	super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
> +	super_set_sysfs_name_uuid(sb);

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

It's quite strange that other commits have been merged, but the ones for 
bcachefs have not been merged.

Thanks,
Hongbo

>   	sb->s_shrink->seeks	= 0;
>   	c->vfs_sb		= sb;
>   	strscpy(sb->s_id, c->name, sizeof(sb->s_id));
