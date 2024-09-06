Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36E91CA8D
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Sep 2024 01:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725584594; cv=none; b=mJAl+ljUuxPraqbCofHURcNzAvdCMDYV64bk/jfQTbw4ZuCyUN+YgqcWAV+0G8w1B9IlWNuEG26Blc7/vyMF4/7yL648NEzPxs1pELmrv9iED5YszYpXWJp0tdWcpqZ4R66jlH/e88ox+V6eKzvbRJ+T3sQmlBjzU5MGgldMeEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725584594; c=relaxed/simple;
	bh=dOPosjZnUNOoXzh2SXhNmH30ncoHF90sKfzEqbRZtV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s4sHNLveeak4SA58X3hHqH5EmhHXctt7vF2WqD9Q/1KTZRD80xfRKmNN4kKHbJnbZXivDuoWfwnl1enYHoUCd8IbiX3KJ4RHfpHoFVPzR8L6KgBFAuQSuQDC7ZT1vZlv23QGrGo0PQn5oSiPQJWTpVJBdq9qc2HLmyc2602w0ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4X0HsF6hw6z69Wn;
	Fri,  6 Sep 2024 08:58:09 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 35D0814011A;
	Fri,  6 Sep 2024 09:03:09 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 09:03:08 +0800
Message-ID: <cf38cc26-acdf-45be-a681-a8eee6f183b7@huawei.com>
Date: Fri, 6 Sep 2024 09:03:08 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: reject unknown mount options
To: David Disseldorp <ddiss@suse.de>, <linux-bcachefs@vger.kernel.org>
CC: Martin Doucha <martin.doucha@suse.com>
References: <20240906000346.22939-2-ddiss@suse.de>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240906000346.22939-2-ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/6 8:03, David Disseldorp wrote:
> This is effectively a revert of commit 03ef80b469d5 ("bcachefs: Ignore
> unknown mount options"), rebased atop commit 929d954330142 ("bcachefs:
> use new mount API").
> 
> Contrary to the 03ef80b469d5 commit message, unknown mount options do
> result in failure on other filesystems such as xfs, btrfs, ext4, etc.
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
> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> Reported-by: Martin Doucha <martin.doucha@suse.com>
> Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> Changes since v1:
> - reword commit message and add Fixes tag
> 
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

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

>   
>   	if (!(bch2_opt_table[id].flags & OPT_MOUNT))
>   		goto bad_opt;
