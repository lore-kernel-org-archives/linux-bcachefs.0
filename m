Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29301B85EF
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Sep 2024 07:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725692436; cv=none; b=sDJ0SD5NKTaaG5soSpW4qci5SRCRKuAB3qBjyhxLPun5zFVukerL1kVCxvB2feZaTujmdRbzXJfNi6YvaKjLpFY7GB8JhERfKteKwP2/X7rAANxNTwQVKXZrI9zo/58mtrWpCiXgYKDboZ4AJ9vn0U2SqMvipyDmCVqRZhKn6U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725692436; c=relaxed/simple;
	bh=BYwOU6JgnAfh4+zibbxiF2f1ezIPNh5tRuy/8ctOhXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bWpDQ8G9noRTtfjawApJLDKn8ek+v/Jt282zOLaEzLrDJTvXw9bbjBmsb09UveN/dZJKu6QAKlC001felAGYWWBK2W+44pv4Zane0n9Jb185w4mAWbP4RKZzv/2rWOD/zk9yRVmHMv96RmEmuoVBz6U1pn6UTr0fs5mlFU9kXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X13rP6250z2DbqB;
	Sat,  7 Sep 2024 15:00:05 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D41321A016C;
	Sat,  7 Sep 2024 15:00:29 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 7 Sep 2024 15:00:29 +0800
Message-ID: <c1a567b2-b066-4f45-870b-900324fc2df6@huawei.com>
Date: Sat, 7 Sep 2024 15:00:29 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: Replace div_u64 with div64_u64 where second
 param is u64
To: Reed Riley <reed@riley.engineer>, "linux-bcachefs@vger.kernel.org"
	<linux-bcachefs@vger.kernel.org>
References: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/7 12:06, Reed Riley wrote:
> Bcachefs often uses this function to divide by nanosecond times - which
> can easily cause problems when cast to u32. For example, `cat
> /sys/fs/bcachefs/*/internal/rebalance_status` would return invalid data
> in the `duration waited` field because dividing by the number of
> nanoseconds in a minute requires the divisor parameter to be u64.
> 
> Signed-off-by: Reed Riley <reed@riley.engineer>
> ---
> fs/bcachefs/sysfs.c | 2 +-
> fs/bcachefs/util.c | 12 ++++++------
> 2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> index f393023a3ae2..561998b2b5dc 100644
> --- a/fs/bcachefs/sysfs.c
> +++ b/fs/bcachefs/sysfs.c
> @@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct printbuf *out, struct bch_fs *c
> prt_tab_rjust(out);
> 
> prt_human_readable_u64(out, nr_extents
> - ? div_u64(sectors_uncompressed << 9, nr_extents)
> + ? div64_u64(sectors_uncompressed << 9, nr_extents)
> : 0);

ah, it seems that your code lacks indentation. But the changes you've 
made appear to be fine. May be you could add some comments in the commit 
message to explain what has been modified in v2 (just separate it with 
---) to make it more clearer. But I see that Kent has already merged 
your code. 😄

Thanks,
Hongbo

> prt_tab_rjust(out);
> prt_newline(out);
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 1b8554460af4..144d8df48b1e 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
> *res = 1;
> 
> while (p--) {
> - if (*res > div_u64(U64_MAX, n))
> + if (*res > div64_u64(U64_MAX, n))
> return -ERANGE;
> *res *= n;
> }
> @@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res)
> 
> parse_or_ret(cp, parse_unit_suffix(cp, &b));
> 
> - if (v > div_u64(U64_MAX, b))
> + if (v > div64_u64(U64_MAX, b))
> return -ERANGE;
> v *= b;
> 
> - if (f_n > div_u64(U64_MAX, b))
> + if (f_n > div64_u64(U64_MAX, b))
> return -ERANGE;
> 
> - f_n = div_u64(f_n * b, f_d);
> + f_n = div64_u64(f_n * b, f_d);
> if (v + f_n < v)
> return -ERANGE;
> v += f_n;
> @@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
> {
> const struct time_unit *u = bch2_pick_time_units(ns);
> 
> - prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
> + prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
> }
> 
> static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
> @@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
> bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> 
> u64 q = max(quantiles->entries[i].m, last_q);
> - prt_printf(out, "%llu ", div_u64(q, u->nsecs));
> + prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
> if (is_last)
> prt_newline(out);
> last_q = q;
> --
> 2.46.0
> 
