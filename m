Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF7182
	for <linux-bcachefs@vger.kernel.org>; Sat,  3 Aug 2024 00:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722645918; cv=none; b=MMSyybHBeElpEe/aIKtbAZeWoiYbciONNVM7VFeU/iF467OW66+U+zLnymQ6zHLaj8kD4eMLHylPbP0/hkB/M4FYEV4NQPu3krs5oMK+eh7TmVgM+XXPlx7ENx8nxgickoPnkRztpHJYfnINl0mftqQPILVVELBoJeK4ii9p7WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722645918; c=relaxed/simple;
	bh=pOJes/KnUKW80B+BVX0cq2kO+5iq3gqlNcaHToK65j4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s/OhrUsNC5DRAAA+Y8MmXM7hwPHtMaoevW2wpIhJjhY4j7zFk//Znr27zMpgGf/wuM6TJ/gaQHSRI1iB89mCpungm5bSlAdGyZb+J1b3XCEFtR9CXAwFQ+Thx3B+0G2xENeqhgmh+UZKbeJID/D22OgPwIL8O1zPPbemIMFzxQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WbP7r3CKkzfZS3;
	Sat,  3 Aug 2024 08:43:20 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 33F2D18007C;
	Sat,  3 Aug 2024 08:45:12 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 3 Aug 2024 08:45:11 +0800
Message-ID: <3279c566-1971-4806-a62a-e6402a591b9b@huawei.com>
Date: Sat, 3 Aug 2024 08:45:11 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: prevent lookuping excessively long paths
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240709081020.3728942-1-lihongbo22@huawei.com>
 <nulcwctn566adoyulms773fhpxifop7zoqwbt67dj54wfk6qrp@6pdpcy3xntcv>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <nulcwctn566adoyulms773fhpxifop7zoqwbt67dj54wfk6qrp@6pdpcy3xntcv>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/3 0:31, Kent Overstreet wrote:
> On Tue, Jul 09, 2024 at 04:10:20PM GMT, Hongbo Li wrote:
>> The longest name length for file is BCH_NAME_MAX in bcachefs.
>> When looking up a longer path, it does not check this limit. So
>> we add the validation for this to avoid undetermined risk.
> 
> What's the actual bug this fixes?
The error code is inconsistent for this case. Actually, in internal the 
BCH_NAME_MAX is defined and used. If this don't fix, it will give the 
ENOENT error for long path.

Thanks,
Hongbo

> 
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>> ---
>>   fs/bcachefs/fs.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index fd01a5402c28..f8da598ca9f8 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -474,6 +474,9 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
>>   	struct bch_inode_info *dir = to_bch_ei(vdir);
>>   	struct bch_hash_info hash = bch2_hash_info_init(c, &dir->ei_inode);
>>   
>> +	if (dentry->d_name.len > BCH_NAME_MAX)
>> +		return ERR_PTR(-ENAMETOOLONG);
>> +
>>   	struct bch_inode_info *inode;
>>   	bch2_trans_do(c, NULL, NULL, 0,
>>   		PTR_ERR_OR_ZERO(inode = bch2_lookup_trans(trans, inode_inum(dir),
>> -- 
>> 2.34.1
>>
