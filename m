Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC1D1877
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Mar 2024 02:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710986447; cv=none; b=sWMhZMyE4DMbsiipuz6ByRfy3gh/c+va43j7U1MXj7NNPDB4kcGUn8cw+dkHBAUCYlTsfsndxzPMf0Kz487U5Mc0MjXO0c3lEZez8HGydXgA8bTwz+uifeSV2O/OE7r8xJiVQpIo3xGDrHH8K3N0VSbmJCSqv3Mv1ZCk2iIVizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710986447; c=relaxed/simple;
	bh=TGbBRzeZtSgJpbYTfoOyV+seC1/CPOHk/H8hNmOkyiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TOecR+nxCjoWU2XHGh80nH+rgA/xcl8Mq3NdKu+45U7/IfCOutubv7r5n/8sRDVc/P1KvVEd7y/CRxZahx2s2/wy2hC3EKnxaJcEXdLxYA59wqOBo28Z3x+mOs5B3qccI2z900EiHvd7Yyc6SOo9dGeLJO7fLZn6pv8VDb8ar/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V0TCF4R3dz1xs7J;
	Thu, 21 Mar 2024 09:58:49 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 30AC0140259;
	Thu, 21 Mar 2024 10:00:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 10:00:42 +0800
Message-ID: <0e7dcf73-e9de-4085-98be-b131b1ca5b93@huawei.com>
Date: Thu, 21 Mar 2024 10:00:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/2] bcachefs: refactoring of btree_path status
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <6njzwe66jtwnwg3ewxmop74iongp5nuqk2736ggatolqz4tbkw@mggb3ecmvpq5>
 <6ji2r4vsxucyj6i6kfve2nwk5bmwozzevpr47jtnryzjb3ggrt@hyddohv2cia5>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <6ji2r4vsxucyj6i6kfve2nwk5bmwozzevpr47jtnryzjb3ggrt@hyddohv2cia5>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Do you mean I provide my git repo? If so, what format should it be? 
(such as ${repo_url}?branch=${branch_name}?).

On 2024/3/21 3:55, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 03:43:44PM -0400, Kent Overstreet wrote:
>> On Wed, Mar 20, 2024 at 02:29:21PM +0800, Hongbo Li wrote:
>>> To enhance the code readability about btree_path structure, we did
>>> some refactoring on the relevant code based on my understanding.
>>>
>>> Hongbo Li (2):
>>>    bcachefs: use btree_path_state to represent btree_path status
>>>    bcachefs: optimize btree_path status representation
>>
>> you've got some things to look at here:
>>
>> https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap
> 
> sorry, wrong thread, but post your git repo and I'll add you to the CI
