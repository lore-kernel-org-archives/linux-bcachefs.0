Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9787B8468
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 03:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714017309; cv=none; b=HbMdppOlzMowlN3KGcUvGLzks4WKtl6XH7emkM4IODQQe8t7q2JTcLhigZXkA2kevRkPuNexWrMbkI7pnLClK2FTVkzgL5onDatkRX7sJxilGMsfdHH6b4knwtJHGyurewW1sG9HOqllo7ngDvz8LvW5t7Pj3AqYt6GwsVqU+as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714017309; c=relaxed/simple;
	bh=di130JifMbtgY0qrzdIZuJyIsloJhRD7CM3iMHFUiu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uzSoQFsrlMalSbLylWqj/6axbUZUMG4NBzaqEjS3RBmHQZhlYDXLr7aATbeohiP8vsKFp0w9C2ZtFuix8uxjEGg1oCtWUVZyCCWUO/e85Ef0j/eycdbAB/5K9oe6R0ccPz4Nimjst9VTOc2nrST8Sj8n+YJ7JhRlpAgYBPwDDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VQ2612PNMz1HBjL;
	Thu, 25 Apr 2024 11:54:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EF5E1400D6;
	Thu, 25 Apr 2024 11:55:03 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 11:55:03 +0800
Message-ID: <dead760c-e8f3-45c6-97e2-61040488a55c@huawei.com>
Date: Thu, 25 Apr 2024 11:55:02 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] bcachefs: eliminate the uninitialized compilation
 warning in bch2_reconstruct_snapshots
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
 <20240419074851.1583392-2-lihongbo22@huawei.com>
 <iugrlvi6jpwhcliq54e2cxjzfikhm2mpx7hj22sy455xrv6ho2@ch3lbvaeiztz>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <iugrlvi6jpwhcliq54e2cxjzfikhm2mpx7hj22sy455xrv6ho2@ch3lbvaeiztz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/4/25 11:34, Kent Overstreet wrote:
> On Fri, Apr 19, 2024 at 03:48:50PM +0800, Hongbo Li wrote:
>> [BUG]
>> When compiling the bcachefs-tools, the following compilation warning
>> is reported:
>>      libbcachefs/snapshot.c: In function ‘bch2_reconstruct_snapshots’:
>>      libbcachefs/snapshot.c:915:19: warning: ‘tree_id’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>        915 |  snapshot->v.tree = cpu_to_le32(tree_id);
>>      libbcachefs/snapshot.c:903:6: note: ‘tree_id’ was declared here
>>        903 |  u32 tree_id;
>>         |      ^~~~~~~
>>
>> [CAUSE]
>> This is a false alert, because @tree_id is changed in
>> bch2_snapshot_tree_create after it returns 0. And if this function
>> returns other value, @tree_id wouldn't be used. Thus there should
>> be nothing wrong in logical.
>>
>> [FIX]
>> Although the report itself is a false alert, we can still make it more
>> explicit by:
>>    - check the input parameter 'u32 *tree_id' with WARN_ON_ONCE
>>    - initialize @tree_id to U32_MAX
>>    - add extra WARN_ON_ONCE to make sure @tree_id is updated
>>
>> Fixes: a292be3b68f3 ("bcachefs: Reconstruct missing snapshot nodes")
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/bcachefs/snapshot.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
>> index 0b26dee17a5a..cad3408903b2 100644
>> --- a/fs/bcachefs/snapshot.c
>> +++ b/fs/bcachefs/snapshot.c
>> @@ -78,6 +78,7 @@ __bch2_snapshot_tree_create(struct btree_trans *trans)
>>   static int bch2_snapshot_tree_create(struct btree_trans *trans,
>>   				u32 root_id, u32 subvol_id, u32 *tree_id)
>>   {
>> +	WARN_ON_ONCE(!tree_id);
> 
> There's no point checking for a null pointer like that; the oops from a
> null ptr deref gives us exactly the same information.
> 
>>   	struct bkey_i_snapshot_tree *n_tree =
>>   		__bch2_snapshot_tree_create(trans);
>>   
>> @@ -900,7 +901,7 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
>>   	if (bch2_snapshot_equiv(c, id))
>>   		return 0;
>>   
>> -	u32 tree_id;
>> +	u32 tree_id = U32_MAX;
> 
> Just initialize it to 0. 0 is an invalid tree ID, so it'll be caught by
> snapshot_tree_invalid() if it's not set.
> 
>>   	int ret = bch2_snapshot_tree_create(trans, id, 0, &tree_id);
>>   	if (ret)
>>   		return ret;
>> @@ -910,6 +911,8 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
>>   	if (ret)
>>   		return ret;
>>   
>> +	/* bch2_snapshot_tree_create returned 0, @tree_id must be updated. */
>> +	WARN_ON_ONCE(tree_id == U32_MAX);
> 
> Nix this as well.
This is to ensure that the tree_id is modified.
> 
>>   	bkey_snapshot_init(&snapshot->k_i);
>>   	snapshot->k.p		= POS(0, id);
>>   	snapshot->v.tree	= cpu_to_le32(tree_id);
>> -- 
>> 2.34.1
>>
