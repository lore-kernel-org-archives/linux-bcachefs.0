Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15B10E0
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Sep 2024 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725587172; cv=none; b=MXs7kZfSj0Kv+742mJc7h+qtV3dLfbSEsYkWCuJXBMrugP6iRxOPwR3NHOD+CdsPA1RH2J9NOcBAX7o/XimgLGKF2uebegGgR0EwQ7oT7U+DpzQwWDKF/BmA2KMnphIRS5rxNfzooJLQsXrljTnD1i5OdpFFRjkLMa3n+GI3aN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725587172; c=relaxed/simple;
	bh=LkF3z1gatDEOLVsOIFzI99ZvCmMomPJcoRLm4hdJhwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GECVoOnLRAUEysj2H6JNLKQhn23JsgKx/oO+IwZ6qPNoALT//77gFS6V4cjpV+ciKmmuk5L9wdDLGJWDXtUsg2KCqPQI3OTOfr/iMLp3FYwAjV84H82RKctmma6Dbn7KwgduauBLrykfp56VbjxZKi6+k20nqy8KfB3QYr+hSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X0Jpp6Twrz20nZB;
	Fri,  6 Sep 2024 09:41:06 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C15711A0188;
	Fri,  6 Sep 2024 09:46:05 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 09:46:05 +0800
Message-ID: <834720f7-6b85-42d8-b4f5-347897bd638a@huawei.com>
Date: Fri, 6 Sep 2024 09:46:04 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Replace div_u64 with div64_u64 where second param is u64
Content-Language: en-US
To: Reed Riley <reed@riley.engineer>, "linux-bcachefs@vger.kernel.org"
	<linux-bcachefs@vger.kernel.org>
References: <4sKBZZw48nEZjT1jQupVR2UFURIlwWmUkFK5KtEPZosBIeWn00r0lcENgqQiGqzfOgOvnvi_xhOR_-P8aHiY_KtW4ANW_Awf7xUjCEpEMUY=@riley.engineer>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <4sKBZZw48nEZjT1jQupVR2UFURIlwWmUkFK5KtEPZosBIeWn00r0lcENgqQiGqzfOgOvnvi_xhOR_-P8aHiY_KtW4ANW_Awf7xUjCEpEMUY=@riley.engineer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/6 0:59, Reed Riley wrote:
> Bcachefs often uses this function to divide by nanosecond times - which
> can easily cause problems when cast to u32.  For example, `cat
> /sys/fs/bcachefs/*/internal/rebalance_status` would return invalid data
> in the `duration waited` field because dividing by the number of
> nanoseconds in a minute requires the divisor parameter to be u64.
> 
> Signed-off-by: Reed Riley <reed@riley.engineer>
> ---
>   fs/bcachefs/super-io.c |  2 +-
>   fs/bcachefs/sysfs.c    |  2 +-
>   fs/bcachefs/util.c     | 12 ++++++------
>   3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
> index c8c2ccbdfbb5..6f71e8cef7ea 100644
> --- a/fs/bcachefs/super-io.c
> +++ b/fs/bcachefs/super-io.c
> @@ -521,7 +521,7 @@ static void bch2_sb_update(struct bch_fs *c)
>   	c->sb.time_units_per_sec = NSEC_PER_SEC / c->sb.nsec_per_time_unit;
>   
>   	/* XXX this is wrong, we need a 96 or 128 bit integer type */
> -	c->sb.time_base_lo	= div_u64(le64_to_cpu(src->time_base_lo),
> +	c->sb.time_base_lo	= div64_u64(le64_to_cpu(src->time_base_lo),
>   					  c->sb.nsec_per_time_unit);
may be div_u64 is enough, c->sb.nsec_per_time_unit is unsigned type.

Thanks,
Hongbo
>   	c->sb.time_base_hi	= le32_to_cpu(src->time_base_hi);
>   
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index f393023a3ae2..561998b2b5dc 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct printbuf *out, struct bch_fs *c
>   		prt_tab_rjust(out);
>   
>   		prt_human_readable_u64(out, nr_extents
> -				       ? div_u64(sectors_uncompressed << 9, nr_extents)
> +				       ? div64_u64(sectors_uncompressed << 9, nr_extents)
>   				       : 0);
>   		prt_tab_rjust(out);
>   		prt_newline(out);
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 1b8554460af4..144d8df48b1e 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
>   	*res = 1;
>   
>   	while (p--) {
> -		if (*res > div_u64(U64_MAX, n))
> +		if (*res > div64_u64(U64_MAX, n))
>   			return -ERANGE;
>   		*res *= n;
>   	}
> @@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res)
>   
>   	parse_or_ret(cp, parse_unit_suffix(cp, &b));
>   
> -	if (v > div_u64(U64_MAX, b))
> +	if (v > div64_u64(U64_MAX, b))
>   		return -ERANGE;
>   	v *= b;
>   
> -	if (f_n > div_u64(U64_MAX, b))
> +	if (f_n > div64_u64(U64_MAX, b))
>   		return -ERANGE;
>   
> -	f_n = div_u64(f_n * b, f_d);
> +	f_n = div64_u64(f_n * b, f_d);
>   	if (v + f_n < v)
>   		return -ERANGE;
>   	v += f_n;
> @@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
>   {
>   	const struct time_unit *u = bch2_pick_time_units(ns);
>   
> -	prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
> +	prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
>   }
>   
>   static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
> @@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
>   			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
>   
>   			u64 q = max(quantiles->entries[i].m, last_q);
> -			prt_printf(out, "%llu ", div_u64(q, u->nsecs));
> +			prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
>   			if (is_last)
>   				prt_newline(out);
>   			last_q = q;
