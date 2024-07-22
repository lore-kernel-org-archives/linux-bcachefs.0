Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751E42F26
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 03:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721618695; cv=none; b=tVbU5XcY6RRXSAJqJTJRq5fZqFDILn6kmjEsGzgvKbzXon4Tq5Rv9qBBwFGTaCkpkTDBdnQzdessX/Xx0u9OyyjD2Gf3LtHB2VMOG2qgy8+BnyShweCq5lpLiISwmRWdEz+rt99cSuWXLQJZghQAF0WBerR+ulKkx1asxhOesfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721618695; c=relaxed/simple;
	bh=erocp5hemjBJvd4moYvZjB+KJxh005nvs/o3cvh5LwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Wo1nQvqdQ6jscNiLeQ7b0Kd+RGs34X7kPmZ+MRzl1ELLDtpwJk0SdJkbGS4DBGkibqNOiQW5O+fdHoWD1CqbYErRqWLvHNNujpF+8eMaEQoExfTRdvzoXqOWNzD/F6UMNjp0uzIQ+PoTsZ4exPV1YyphnYmrrhnFNXQhov5yLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WS5B36QYPzyN4L;
	Mon, 22 Jul 2024 11:19:55 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id EA76F140154;
	Mon, 22 Jul 2024 11:24:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 11:24:43 +0800
Message-ID: <591b47c7-7a5a-4d09-873e-722ce3ab97f1@huawei.com>
Date: Mon, 22 Jul 2024 11:24:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] bcachefs: some cleanups and fix about macro
To: Julian Sun <sunjunchao2870@gmail.com>, <linux-bcachefs@vger.kernel.org>
CC: <kent.overstreet@linux.dev>
References: <20240721123943.246705-1-sunjunchao2870@gmail.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20240721123943.246705-1-sunjunchao2870@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/21 20:39, Julian Sun wrote:
> In the macro definition detection tool I developed,
Is it commonly used in the kernel?

Thanks,
Hongbo

> several issues were identified, including unused parameters
> and unused macro definitions. Let us address these issues.
> 
> Julian Sun (4):
>    bcachefs: remove unused macro definition
>    bcachefs: fix macro definition allocate_dropping_locks
>    bcachefs: fix macro definition allocate_dropping_locks
>    bcachefs: remove the unused parameter in macro bkey_crc_next
> 
>   fs/bcachefs/btree_iter.h | 4 ++--
>   fs/bcachefs/clock.h      | 9 ---------
>   fs/bcachefs/extents.h    | 4 ++--
>   3 files changed, 4 insertions(+), 13 deletions(-)
> 
