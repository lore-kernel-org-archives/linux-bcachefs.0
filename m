Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191F517F7
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731291446; cv=none; b=cJ0icjDCVKUYqsp6Xs5lgz79OVIJ/jlsFi4KeUoJRPMzBTjLdSzFDncByz7u4TWY305PjE7WClJQr9Km1gDvXP6b9afRdHuel0qni0YqYtECKDc2WbSmsRM1ccxASrin47JqajkZa15Vf6Ws/hgetaAqQezKtal3QFUsrgncoH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731291446; c=relaxed/simple;
	bh=A4ufPjDRE3yUv6OhrcSg3jJYJM9C+P741jLrPkmqkUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fFAGZhSz1ahlxjGVx67dTR5ZqX8bGhjLrr1lTsnUXnNoUxFC9EDNa9MrJcsJiB+On6Gkh3IGAn5cpniJnR8fBIlvLHwQ0AhDLLPG62Sob3wxg8fzBXOsKExmGxhcRHlLXSsLL1ENzkPHjKUGD3gS2mQdEVLjxXKdio9oumfZGtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XmtRF41Yyz1TB0f;
	Mon, 11 Nov 2024 10:14:49 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 998901800F2;
	Mon, 11 Nov 2024 10:17:15 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 10:17:15 +0800
Message-ID: <5484f8dd-da46-4d95-8a8a-e0d51778b414@huawei.com>
Date: Mon, 11 Nov 2024 10:17:13 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs-tools: add usage function for fs subcommand
Content-Language: en-US
To: Integral <integral@archlinuxcn.org>, <kent.overstreet@gmail.com>,
	<kent.overstreet@linux.dev>
CC: <mmpgouride@gmail.com>, <linux-bcachefs@vger.kernel.org>
References: <20241109185648.30536-2-integral@archlinuxcn.org>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241109185648.30536-2-integral@archlinuxcn.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/11/10 2:56, Integral wrote:
> Add the missing usage function for "fs" subcommand; when no matching
> subcommand exists, print the usage and return -EINVAL.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>
> ---
>   c_src/bcachefs.c |  9 ++++-----
>   c_src/cmd_fs.c   | 12 ++++++++++++
>   c_src/cmds.h     |  1 +
>   3 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
> index 77bf6215..e9e617e1 100644
> --- a/c_src/bcachefs.c
> +++ b/c_src/bcachefs.c
> @@ -113,14 +113,13 @@ int fs_cmds(int argc, char *argv[])
>   {
>   	char *cmd = pop_cmd(&argc, argv);
> 
> -	if (argc < 1) {
> -		bcachefs_usage();
> -		exit(EXIT_FAILURE);
> -	}
> +	if (argc < 1)
> +		return fs_usage();
>   	if (!strcmp(cmd, "usage"))
>   		return cmd_fs_usage(argc, argv);
> 
> -	return 0;
> +	fs_usage();
Your previous patch also made changes here. Perhaps you could pack them 
into a patchset or one patch which would make it more independent.
> +	return -EINVAL;
>   }
> 
>   int device_cmds(int argc, char *argv[])
> diff --git a/c_src/cmd_fs.c b/c_src/cmd_fs.c
> index 82eeceff..eb8f7d2e 100644
> --- a/c_src/cmd_fs.c
> +++ b/c_src/cmd_fs.c
> @@ -487,6 +487,18 @@ devs:
>   	bcache_fs_close(fs);
>   }
> 
> +int fs_usage(void)
> +{
> +       puts("bcachefs fs - manage a running filesystem\n"
> +            "Usage: bcachefs fs <CMD> [OPTIONS]\n"
May be the OPTIONS also should be displayed. ie like device_add_usage ...

Thanks,
Hongbo

> +            "\n"
> +            "Commands:\n"
> +            "  usage                     Display detailed filesystem usage\n"
> +            "\n"
> +            "Report bugs to <linux-bcachefs@vger.kernel.org>");
> +       return 0;
> +}
> +
>   static void fs_usage_usage(void)
>   {
>   	puts("bcachefs fs usage - display detailed filesystem usage\n"
> diff --git a/c_src/cmds.h b/c_src/cmds.h
> index 64267dc4..99016d52 100644
> --- a/c_src/cmds.h
> +++ b/c_src/cmds.h
> @@ -14,6 +14,7 @@ int cmd_show_super(int argc, char *argv[]);
>   int cmd_reset_counters(int argc, char *argv[]);
>   int cmd_set_option(int argc, char *argv[]);
> 
> +int fs_usage(void);
>   int cmd_fs_usage(int argc, char *argv[]);
> 
>   int device_usage(void);
> --
> 2.47.0
> 
