Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282E25A65D
	for <linux-bcachefs@vger.kernel.org>; Wed,  5 Feb 2025 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738722219; cv=none; b=NUJH4yOEg3oBsTVuzcPGK8QkQdsifvBga084B0lNdxrsWuEU81sl5B21gTFjvqmF49LZrTZI/YcCDJny931wkJ2RBTF+1uuhDA/HdldB5u00UbYM8jvU05OEiWULH1m69uhth/pjX3eDPMGxKEizQ3dk3f1EZ4cbv6yis89R1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738722219; c=relaxed/simple;
	bh=FQe/0BlJdUQyJ+YiYa7MZ7AQ6jbYlWXQRuOEQoV5Wkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HNm4O5DpV0RbDmeClg6YUUNRVRl4Y1h5VaUdPHQ17M0tC6ix4+6hZvSNCJa/6diHKbNlWsgPYukyyHeScQlEVXIxF3bNAZlRefdiUskWbIx8AXn04zDTc6f9eCiuuMaUT+0GD9WpNANjk6T38KvUzXhVaYbtUvqOr8IagFyS/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YnkSg6RmHz11PcH;
	Wed,  5 Feb 2025 10:19:15 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id AD10A1800D9;
	Wed,  5 Feb 2025 10:23:33 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Feb 2025 10:23:33 +0800
Message-ID: <f7f99f3a-2f1a-4e9c-ad2f-2b182142761d@huawei.com>
Date: Wed, 5 Feb 2025 10:23:32 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: BCH_IOCTL_QUERY_COUNTERS
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <20250129204950.222472-1-kent.overstreet@linux.dev>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20250129204950.222472-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/1/30 4:49, Kent Overstreet wrote:
> Add an ioctl for querying counters, the same ones provided in
> /sys/fs/bcachefs/<uuid>/counters/, but more suitable for a 'bcachefs
> top' command.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>   fs/bcachefs/bcachefs_ioctl.h | 10 ++++++++++
>   fs/bcachefs/chardev.c        | 32 ++++++++++++++++++++++++++++++++
>   fs/bcachefs/sb-counters.c    |  2 +-
>   fs/bcachefs/sb-counters.h    |  1 +
>   4 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
> index 3c23bdf788ce..f1b746fac007 100644
> --- a/fs/bcachefs/bcachefs_ioctl.h
> +++ b/fs/bcachefs/bcachefs_ioctl.h
> @@ -87,6 +87,7 @@ struct bch_ioctl_incremental {
>   #define BCH_IOCTL_FSCK_OFFLINE	_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
>   #define BCH_IOCTL_FSCK_ONLINE	_IOW(0xbc,	20,  struct bch_ioctl_fsck_online)
>   #define BCH_IOCTL_QUERY_ACCOUNTING _IOW(0xbc,	21,  struct bch_ioctl_query_accounting)
> +#define BCH_IOCTL_QUERY_COUNTERS _IOW(0xbc,	21,  struct bch_ioctl_query_counters)
>   
>   /* ioctl below act on a particular file, not the filesystem as a whole: */
>   
> @@ -443,4 +444,13 @@ struct bch_ioctl_query_accounting {
>   	struct bkey_i_accounting accounting[];
>   };
>   
> +#define BCH_IOCTL_QUERY_COUNTERS_MOUNT	(1 << 0)
> +
> +struct bch_ioctl_query_counters {
> +	__u16			nr;
> +	__u16			flags;
> +	__u32			pad;
> +	__u64			d[];
> +};
> +
>   #endif /* _BCACHEFS_IOCTL_H */
> diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> index 46e9e32105a9..c2d9efe8db53 100644
> --- a/fs/bcachefs/chardev.c
> +++ b/fs/bcachefs/chardev.c
> @@ -448,6 +448,36 @@ static long bch2_ioctl_query_accounting(struct bch_fs *c,
>   	return ret;
>   }
>   
> +static long bch2_ioctl_query_counters(struct bch_fs *c,
> +			struct bch_ioctl_query_counters __user *user_arg)
> +{
> +	struct bch_ioctl_query_counters arg;
> +	int ret = copy_from_user_errcode(&arg, user_arg, sizeof(arg));
> +	if (ret)
> +		return ret;
> +
> +	if ((arg.flags & !BCH_IOCTL_QUERY_COUNTERS_MOUNT) ||
> +	    arg.pad)
> +		return -EINVAL;
> +
> +	arg.nr = min(arg.nr, BCH_COUNTER_NR);
> +	ret = put_user(arg.nr, &user_arg->nr);
This will change the input parameter @nr (records the size of filling 
space). Instead, how about introducing the extra parameter @max to keep 
the input array size?

Thanks,
Hongbo
> +	if (ret)
> +		return ret;
> +
> +	for (unsigned i = 0; i < arg.nr; i++) {
> +		u64 v = !(arg.flags & BCH_IOCTL_QUERY_COUNTERS_MOUNT)
> +			? percpu_u64_get(&c->counters[i])
> +			: c->counters_on_mount[i];
> +
> +		ret = put_user(v, &user_arg->d[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>   /* obsolete, didn't allow for new data types: */
>   static long bch2_ioctl_dev_usage(struct bch_fs *c,
>   				 struct bch_ioctl_dev_usage __user *user_arg)
> @@ -710,6 +740,8 @@ long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
>   		BCH_IOCTL(fsck_online, struct bch_ioctl_fsck_online);
>   	case BCH_IOCTL_QUERY_ACCOUNTING:
>   		return bch2_ioctl_query_accounting(c, arg);
> +	case BCH_IOCTL_QUERY_COUNTERS:
> +		return bch2_ioctl_query_counters(c, arg);
>   	default:
>   		return -ENOTTY;
>   	}
> diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
> index 6992e7469112..67f4e7a5aa5a 100644
> --- a/fs/bcachefs/sb-counters.c
> +++ b/fs/bcachefs/sb-counters.c
> @@ -5,7 +5,7 @@
>   
>   /* BCH_SB_FIELD_counters */
>   
> -static const char * const bch2_counter_names[] = {
> +const char * const bch2_counter_names[] = {
>   #define x(t, n, ...) (#t),
>   	BCH_PERSISTENT_COUNTERS()
>   #undef x
> diff --git a/fs/bcachefs/sb-counters.h b/fs/bcachefs/sb-counters.h
> index 81f8aec9fcb1..eef7211edf42 100644
> --- a/fs/bcachefs/sb-counters.h
> +++ b/fs/bcachefs/sb-counters.h
> @@ -11,6 +11,7 @@ int bch2_sb_counters_from_cpu(struct bch_fs *);
>   void bch2_fs_counters_exit(struct bch_fs *);
>   int bch2_fs_counters_init(struct bch_fs *);
>   
> +extern const char * const bch2_counter_names[];
>   extern const struct bch_sb_field_ops bch_sb_field_ops_counters;
>   
>   #endif // _BCACHEFS_SB_COUNTERS_H
