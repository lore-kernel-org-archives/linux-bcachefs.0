Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A03FE4B
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 03:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264509; cv=none; b=bj2evLq1YeCdq+XcdlAilkpCjmoNrbLM/5EdVeJOx+gOUu3pW6HEcjrizf56RahTlbvaPRAvl/k/0am+H95ImRZwA2xF6pcdfV8Ntfs0GW4Kd9y4gmFzOCFkNpDZMWvvrnjZ8AqWviK699/Q6I2zQO3cPKIPe+4OSoaJLUz1Hw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264509; c=relaxed/simple;
	bh=qBlttmXtxXI7PEBG2j9In6qvl6xX3DgvgCTysszE2po=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SRJUwSoU0V+uIKRgJNidyJzgIDKamtYPNR9sljKxghKcbBVFdiGRcGOcyTuUGPPu0vSjoonyW0gnLDfuaTGUBOT8RwSdPkR6dR4pUd35Wm/gbI3pCpSu65TRlSlTKj3bCN8XIdMqY2u04Sa/5iH2bbzKf5Gs3k0mV54+da+DZFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TmDR90M8mz1FLWl;
	Fri,  1 Mar 2024 11:41:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 70589180061;
	Fri,  1 Mar 2024 11:41:43 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 1 Mar 2024 11:41:43 +0800
Message-ID: <8fc75160-69ae-49e1-b89a-550c2ad1e09e@huawei.com>
Date: Fri, 1 Mar 2024 11:41:43 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: avoid returning private error code in
 bch2_xattr_bcachefs_set
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, Jinjie Ruan
	<ruanjinjie@huawei.com>
CC: <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <20240301031745.1912157-1-lihongbo22@huawei.com>
 <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
 <nrmumxwn6hpgjawvwq2d4vjs2mnj3ejgvuc4ua63fxv6kif6eo@w2yrsmmhqv2d>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <nrmumxwn6hpgjawvwq2d4vjs2mnj3ejgvuc4ua63fxv6kif6eo@w2yrsmmhqv2d>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Here, ENOMEM and EINVAL are not from internal interface. So I think 
these can return directly.

On 2024/3/1 11:29, Kent Overstreet wrote:
> On Fri, Mar 01, 2024 at 11:26:51AM +0800, Jinjie Ruan wrote:
>>
>>
>> On 2024/3/1 11:17, Hongbo Li wrote:
>>> Avoid the private error code return to caller. The error code
>>> should be transformed into genernal error code.
>>>
>>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>>> ---
>>>   fs/bcachefs/xattr.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
>>> index 9c0d2316031b..754f17bba68e 100644
>>> --- a/fs/bcachefs/xattr.c
>>> +++ b/fs/bcachefs/xattr.c
>>> @@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
>>>   		kfree(buf);
>>>   
>>>   		if (ret < 0)
>>> -			return ret;
>>> +			goto err_class_exit;
>>>   
>>>   		ret = bch2_opt_check_may_set(c, opt_id, v);
>>>   		if (ret < 0)
>>> -			return ret;
>>> +			goto err_class_exit;
>>>   
>>>   		s.v = v + 1;
>>>   		s.defined = true;
>>> @@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
>>>   	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
>>>   		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
>>>   
>>> +err_class_exit:
>>>   	return bch2_err_class(ret);
>>
>> 那前面的return -ENOMEM和return -EINVAL不用转换吗
> 
> Don't follow?
