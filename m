Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788391CD23
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Mar 2024 02:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505751; cv=none; b=TOHCI8w/JUGa90YEDXDCkpvgLWPdu8id9QmXsIic3pvxlxkZVsBJYOIM9VrGtpMdn5TGOiQ/wIldHD41mFWJaY/AThFRZDPyWrcAbQrieAPN+U7xwGhBbl87wKhb/RJhrPM9opi5bB3/UrdvXqf7C51LA4m9CFXenF/yLWZhSUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505751; c=relaxed/simple;
	bh=DKRSY9/brAWDyc4pTCdRJT3G5DRXfbGeYvcdHUGDpxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Nwr1bz+ky93TREmIQWwtEy3SUO2ImKBjwcvF+Jer+FP26GRouW4yF4AMjPRQKgsZ2ZpfLxtelGSHLFM8zZZRlQBol3Qr7zDV1YFnR3rV+6vn8oeCo122jBjDlBfnlzcPY77mACsO6WKCrbP4yTSzF66xTH1tQKwBpU+0hKbmTfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V49Fj5P2Mz1xsdm;
	Wed, 27 Mar 2024 10:13:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D145D1A0172;
	Wed, 27 Mar 2024 10:15:45 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 10:15:45 +0800
Message-ID: <b8c146f1-9640-4616-b94f-11089b4a4b89@huawei.com>
Date: Wed, 27 Mar 2024 10:15:45 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: fix the count of nr_freed_pcpu after changing
 bc->freed_nonpcpu list
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240326040456.2587357-1-lihongbo22@huawei.com>
 <663jlo5maeoh5dctbepsrnzbk7p5fwjfqaeshhb43ujcnjccdw@22vssecpk7jx>
 <b61e1609-9a6e-4f4b-9143-83ce36f11dfa@huawei.com>
 <qi575tzztivxaaau4hj553qucn5cp4wdv6ou52ruuhks3h2r6o@zasfehlnwehw>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <qi575tzztivxaaau4hj553qucn5cp4wdv6ou52ruuhks3h2r6o@zasfehlnwehw>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/3/27 3:40, Kent Overstreet wrote:
> On Tue, Mar 26, 2024 at 02:04:50PM +0800, Hongbo Li wrote:
>> Do you mean to add these assertions at the end of
>> bkey_cached_move_to_freelist and bkey_cached_alloc?
> 
> Assertions like this I generally put in the shutdown path - would that
> have caught this bug?
> 
> If it wouldn't, we could make it a debug mode assertion - probably also
> randomly 1/128th of the time or somoesuch, this will be a bit of an
> expensive one otherwise
> 

I found this by code review on this part. Do you mean I should add some 
code like:

#ifdef CONFIG_BCACHEFS_DEBUG
     BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
     BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);
#endif

after every time when the nr_freed_pcpu/nr_freed_nonpcpu changed?

Surely, It's a bit difficult for me to reproduce this problem without a 
deep understand about this procedure now. And I have tried constructing 
a case to call bkey_cached_alloc, but is is difficult to ensure that 
bkey_cached is allocated from the bc->freed_pcpu list.

>>
>> On 2024/3/26 12:17, Kent Overstreet wrote:
>>> On Tue, Mar 26, 2024 at 12:04:56PM +0800, Hongbo Li wrote:
>>>> When allocating bkey_cached from bc->freed_pcpu list, it missed
>>>> decreasing the count of nr_freed_pcpu which would cause the mismatch
>>>> between the value of nr_freed_pcpu and the list items. This problem
>>>> also exists in moving new bkey_cached to bc->freed_pcpu list.
>>>> If these happened, the bug info may appear in
>>>> bch2_fs_btree_key_cache_exit by the follow code:
>>>>
>>>>      BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
>>>>      BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);
>>>
>>> Please include the assertions too :)
>>>
>>>> Fixes: c65c13f0eac6 ("bcachefs: Run btree key cache shrinker less aggressively")
>>>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>>>> ---
>>>>    fs/bcachefs/btree_key_cache.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
>>>> index 581edcb0911b..e1031b9ba3f4 100644
>>>> --- a/fs/bcachefs/btree_key_cache.c
>>>> +++ b/fs/bcachefs/btree_key_cache.c
>>>> @@ -169,6 +169,7 @@ static void bkey_cached_move_to_freelist(struct btree_key_cache *bc,
>>>>    	} else {
>>>>    		mutex_lock(&bc->lock);
>>>>    		list_move_tail(&ck->list, &bc->freed_pcpu);
>>>> +		bc->nr_freed_pcpu++;
>>>>    		mutex_unlock(&bc->lock);
>>>>    	}
>>>>    }
>>>> @@ -245,6 +246,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path,
>>>>    		if (!list_empty(&bc->freed_pcpu)) {
>>>>    			ck = list_last_entry(&bc->freed_pcpu, struct bkey_cached, list);
>>>>    			list_del_init(&ck->list);
>>>> +			bc->nr_freed_pcpu--;
>>>>    		}
>>>>    		mutex_unlock(&bc->lock);
>>>>    	}
>>>> -- 
>>>> 2.34.1
>>>>
>>>
