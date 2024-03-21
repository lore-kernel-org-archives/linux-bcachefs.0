Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E3017FD
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Mar 2024 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710986019; cv=none; b=tt9IQyk/lxj2SwyPezBMy6mlD0NpXt1EHNlbwRcZmGuXPAOo3hb2gFB+NNVrNFGWNuIFTJo8PvnJKQzpZU9GHqMqqY1siOX9QorhHKlNjr0C5/Q777djTn9L/p4jE6+jJQLs06iv2lqu9fduRkPNxNVvoEWQHAV2qMNEiDx6xdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710986019; c=relaxed/simple;
	bh=C3LlyNO2LkwT/iXEfe6+4ijnMpu2ZVrxKyWvDl/eyMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BBLZfZNIJ0n+aYfSsJvcGQR6g6jFA57VB10id/73JIk84x87ngsIgfH1k6n6uddvJDGdPgVzVe2ieYmSgBQKMnVGoTP1hxLmw0iL9IzWG2lkwyD+Ug/b5xlkzG1mVz9Yt9jlBWYCnerINRy2x50Y3LLzg3l4WNppjrUHgNb88Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4V0T2y3Z6gzLpBd;
	Thu, 21 Mar 2024 09:51:38 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 71881140114;
	Thu, 21 Mar 2024 09:53:32 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 09:53:32 +0800
Message-ID: <7ff3df0b-41a0-4cd4-92dc-5df109a33845@huawei.com>
Date: Thu, 21 Mar 2024 09:53:31 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] bcachefs: optimize btree_path status
 representation
Content-Language: en-US
To: Brian Foster <bfoster@redhat.com>
CC: <kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-3-lihongbo22@huawei.com> <ZfsftT1Wd0K6daOy@bfoster>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <ZfsftT1Wd0K6daOy@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

I agree, on the other hand, I feel that these states are not independent.

On 2024/3/21 1:41, Brian Foster wrote:
> My initial thought was to wonder whether it's worth creating some macro
> helpers for each state, but after looking through the code a bit that
> seems like overkill.
