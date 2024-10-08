Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB15208A7;
	Tue,  8 Oct 2024 02:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728354193; cv=none; b=ZS9wEJaSoL62C0yyzljrQginH1NMh74rNGWpAM3i3Onb1AJGX5FcS/thxJO9Zj1cieuvsX6jfubI9R2WnsFzcUEAjKmi3R+D18dV5tXu/9ZLPbOEWCycNjsIWf2eSWrz/FK+8ztZn82Yg1jKlF/ONTBJivw22ELNOSMD75fjX40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728354193; c=relaxed/simple;
	bh=GHOHUfEjrbXGfCPTDqxLXpRVTda3CoPXrBP5nxkil+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JgnsiuT8Po/Xj5619mNb7WiiTjPHIX+bXY6MjTYzjfrEDGhBUI3xk67SGoTO/VfC95/3kQDkWcyXFajnXbUMOOG402SsaDgjvl+S9fCaloEK67eXplCyuB6B9TUdjfzluF9KhfhDSsy2Pgf+WqiJVBEaprSxPrb0W7REDhc0iNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XN07s0Mvmz1HKKG;
	Tue,  8 Oct 2024 10:19:05 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5224D180044;
	Tue,  8 Oct 2024 10:23:09 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Oct 2024 10:23:09 +0800
Message-ID: <f8fcc1e6-6de6-4d60-83a7-83e95a7d6b6e@huawei.com>
Date: Tue, 8 Oct 2024 10:23:08 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend v3] bcachefs: Fix NULL pointer dereference in
 bch2_opt_to_text
Content-Language: en-US
To: Mohammed Anees <pvmohammedanees2003@gmail.com>, Kent Overstreet
	<kent.overstreet@linux.dev>
CC: <syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com>, LKML
	<linux-kernel@vger.kernel.org>, "linux-bcachefs@vger.kernel.org"
	<linux-bcachefs@vger.kernel.org>
References: <20241005130229.9290-1-pvmohammedanees2003@gmail.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241005130229.9290-1-pvmohammedanees2003@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/5 21:02, Mohammed Anees wrote:
> This patch adds a bounds check to the bch2_opt_to_text function to prevent
> NULL pointer dereferences when accessing the opt->choices array. This
> ensures that the index used is within valid bounds before dereferencing.
> The new version enhances the readability.
> 
> Reported-and-tested-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
> Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> ---
> v3:
> - Moved bounds check above as default case.
> - Removed the nesterd if clauses.
> ---
>   fs/bcachefs/opts.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 232be8a44051..84097235eea9 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -427,7 +427,9 @@ void bch2_opt_to_text(struct printbuf *out,
>   			prt_printf(out, "%lli", v);
>   		break;
>   	case BCH_OPT_STR:
> -		if (flags & OPT_SHOW_FULL_LIST)
> +		if (v < opt->min || v >= opt->max - 1)
As definition, max is the right bound for value. opt->max - 1 is valid. 
May be you should remove the equals sign.

It should be no problem to just solve this null pointer issue() (How is 
this stack triggered, may be I lost something.), but this should be a 
general boundary check condition, strictly speaking, it's a check for 
the validity of the options' value.

Thanks,
Hongbo

> +			prt_printf(out, "(invalid option %lli)", v);
> +		else if (flags & OPT_SHOW_FULL_LIST)
>   			prt_string_option(out, opt->choices, v);
>   		else
>   			prt_str(out, opt->choices[v]);
