Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B1E13DBB6
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 11:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721302082; cv=none; b=Wo7Sc/xFDgpXZkN/rhzb7ol7geyLcnPOn8KNfT72fHih3N0TMBRMOMiXgVkepy/31209vTO1aDvWMOEbp18Wt6kGKbz5UlTTci1SMGc68gyyD5CWK94qOkXadInh3AEs2nehrUYlntpRiKzysfjTly/OIb3uj44wHwiFnc7og5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721302082; c=relaxed/simple;
	bh=3+HTsTZQySv00VhWJwNBPnOfp5SpXuwquw994hQfxhc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=gYhXE0M6OSWsSOQw5xwoDPUGDQeSc1ZzIeOhOUfDJ/SNiIgralSWLKQbyU4m1CzxwuxLkyfXU2npe4/D9b+T4Kqlc4Yt2E+M2+EVEbF7g8mQ0PkE6p86U6xqaxFs4myY47+CzleCnFrOYJJLs/iO/OhBxOi7w7AZGOlnH7GAink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WPr5N06jNzxTJL;
	Thu, 18 Jul 2024 19:23:04 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 435931800A4;
	Thu, 18 Jul 2024 19:27:57 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 18 Jul 2024 19:27:57 +0800
Message-ID: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
Date: Thu, 18 Jul 2024 19:27:55 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libbcachefs: add support for true/false & yes/no in
 bool-type options
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
To: Integral <integral@murena.io>, <kent.overstreet@gmail.com>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240718071346.68754-3-integral@murena.io>
 <4574f022-0254-4f84-a2c8-5458956661ae@huawei.com>
In-Reply-To: <4574f022-0254-4f84-a2c8-5458956661ae@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/18 19:20, Hongbo Li wrote:
> +            } else if (!strcmp(val, "0") || !strcmp(val, "false") || 
> !strcmp(val, "no")) {
How about also parse on/off into bool type.

Thanks,
Hongbo
