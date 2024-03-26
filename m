Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAFE12AACF
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Mar 2024 06:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711433104; cv=none; b=L37Caf3/JunuzMIe1zqP9NyNp4Uu4W+1M/T2dGGfkYoqj/pTkzNvSsP+J+0EF2YOtzxO9WIOMG6srKJ8xXUr9wPUnuJwfr0OK3aDFR9FuXXG5kRhz6iE/5ZPU0TjLX0VE84oTCTkzIJf0XKhTStsciMSx5mvwyxtKyvYAiobUfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711433104; c=relaxed/simple;
	bh=VxUsMycJAmH33vOce2FVoFyXYhGbY9xmRv8BE1glI8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bVEzZztENRRQtZhOfSuASQbYjjIGO6IDdatrMUXnDtmo1TE2ad3bTg5LUIjRBk0EZQXDywCnu1lXlB1iD/vPlsIQVfegCseTE4t/BVYSnITjkkuPRsP7ftBH+FVJVgSGiq9kioWso9XhkNZfGctGoZGa/ySzqQrjM02f0tE7a8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4V3fN32T9hztQgG;
	Tue, 26 Mar 2024 14:02:27 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 154381400DD;
	Tue, 26 Mar 2024 14:04:51 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 14:04:50 +0800
Message-ID: <b61e1609-9a6e-4f4b-9143-83ce36f11dfa@huawei.com>
Date: Tue, 26 Mar 2024 14:04:50 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix the count of nr_freed_pcpu after changing
 bc->freed_nonpcpu list
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240326040456.2587357-1-lihongbo22@huawei.com>
 <663jlo5maeoh5dctbepsrnzbk7p5fwjfqaeshhb43ujcnjccdw@22vssecpk7jx>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <663jlo5maeoh5dctbepsrnzbk7p5fwjfqaeshhb43ujcnjccdw@22vssecpk7jx>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Do you mean to add these assertions at the end of 
bkey_cached_move_to_freelist and bkey_cached_alloc?

On 2024/3/26 12:17, Kent Overstreet wrote:
> On Tue, Mar 26, 2024 at 12:04:56PM +0800, Hongbo Li wrote:
>> When allocating bkey_cached from bc->freed_pcpu list, it missed
>> decreasing the count of nr_freed_pcpu which would cause the mismatch
>> between the value of nr_freed_pcpu and the list items. This problem
>> also exists in moving new bkey_cached to bc->freed_pcpu list.
>> If these happened, the bug info may appear in
>> bch2_fs_btree_key_cache_exit by the follow code:
>>
>>     BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
>>     BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);
> 
> Please include the assertions too :)
> 
>> Fixes: c65c13f0eac6 ("bcachefs: Run btree key cache shrinker less aggressively")
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/bcachefs/btree_key_cache.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
>> index 581edcb0911b..e1031b9ba3f4 100644
>> --- a/fs/bcachefs/btree_key_cache.c
>> +++ b/fs/bcachefs/btree_key_cache.c
>> @@ -169,6 +169,7 @@ static void bkey_cached_move_to_freelist(struct btree_key_cache *bc,
>>   	} else {
>>   		mutex_lock(&bc->lock);
>>   		list_move_tail(&ck->list, &bc->freed_pcpu);
>> +		bc->nr_freed_pcpu++;
>>   		mutex_unlock(&bc->lock);
>>   	}
>>   }
>> @@ -245,6 +246,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path,
>>   		if (!list_empty(&bc->freed_pcpu)) {
>>   			ck = list_last_entry(&bc->freed_pcpu, struct bkey_cached, list);
>>   			list_del_init(&ck->list);
>> +			bc->nr_freed_pcpu--;
>>   		}
>>   		mutex_unlock(&bc->lock);
>>   	}
>> -- 
>> 2.34.1
>>
> 
