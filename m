Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9F44436E;
	Fri, 30 Aug 2024 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724981222; cv=none; b=ExAbkGLk+j6iCR1p8YydgGD8FoO6xslaXsYcH3VzmuWMa4delpRn2DFuyq9TK6IDcDRERb1RYSn87WOSGx7NmtdasnZp/AauJH+mWrPoLC5tHvGlNzi7xBseeBq6t0H/DmyXnYq+KmfEq9fSmi4Y3t7yKGz564B1vDHVCQc4OWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724981222; c=relaxed/simple;
	bh=uC92lRxRM4Bx29JBhuolM3crcaiIAvECHgifmMbH1uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LHhsVaSNPC7yrxsgSN0m+Bk+SNfPjmMWlsInTiiI72zrfT0Q912MQbBCSlVOVFT0vAbVQpGZo5OKgj5oz+eowO7gBI3bTSGM6+MKbJyzqII9JT46sIUM0MSdg+8GFyc4Ew3dx40xjBHI9ehJ9Fc7dy8CE4KevptwWln5BSnhz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Ww0qQ52Ngz1S9Qx;
	Fri, 30 Aug 2024 09:26:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id ADB1D1A0188;
	Fri, 30 Aug 2024 09:26:56 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 09:26:56 +0800
Message-ID: <9cf7c3b9-e9df-43cf-84fc-1e8a790c0763@huawei.com>
Date: Fri, 30 Aug 2024 09:26:56 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Remove duplicate included headers
Content-Language: en-US
To: Thorsten Blum <thorsten.blum@toblux.com>, <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240829154949.109402-2-thorsten.blum@toblux.com>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240829154949.109402-2-thorsten.blum@toblux.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/29 23:49, Thorsten Blum wrote:
> The header files dirent_format.h and disk_groups_format.h are included
> twice. Remove the redundant includes and the following warnings reported
> by make includecheck:
> 
>    disk_groups_format.h is included more than once
>    dirent_format.h is included more than once
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>   fs/bcachefs/bcachefs_format.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index 14ce726bf5a3..b97fd0f75831 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -499,8 +499,6 @@ struct bch_sb_field {
>   #include "disk_groups_format.h"
>   #include "extents_format.h"
>   #include "ec_format.h"
> -#include "dirent_format.h"
> -#include "disk_groups_format.h"

line 497 and line 499.

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>


>   #include "inode_format.h"
>   #include "journal_seq_blacklist_format.h"
>   #include "logged_ops_format.h"
