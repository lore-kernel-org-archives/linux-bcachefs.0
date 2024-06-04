Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF36938B
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717468829; cv=none; b=T0tW+7vqIBd05E4Qhn8/OdGy7kS+MwdGRmtyQ/yJ4R7clhsl5swn7kgMXOOomIaht2fd39nEz8KRWo2nANx4kg9JA46WYR9l+/Grl9WZ4sTcdWSzuRT2vCmc1KQHETSTz/I11RN3ftCzZkiGP8+jVkL8VpgqmsrvpL6fdyT0yzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717468829; c=relaxed/simple;
	bh=K0NTO9obWoBQXHJIAaGdRnn1QhbVwSlVPQSH/5CTvgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uKiJymrU6itVi3k0lRDKOzpwXR9/CmR5heYlgadUU7lvt0wBGm6xWgfxIYWIl4qDRyJfxaMC6+1mSBjnrIsLFiiz/7w/ebYBR2V/6doZ+6CauHzAlfvHjgoaC75LKcot2GS6CYZickl0XwTHAAga56opvV5gnkWfaJ7XB0UZxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtZTN6WBXzmXfX;
	Tue,  4 Jun 2024 10:35:52 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 18C41180085;
	Tue,  4 Jun 2024 10:40:24 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Jun 2024 10:40:23 +0800
Message-ID: <1516053d-edff-45c4-b17c-b116395ef018@huawei.com>
Date: Tue, 4 Jun 2024 10:40:23 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: memcpy failed when __bch2_accounting_mem_mod_slowpath
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: Brian Foster <bfoster@redhat.com>, <linux-bcachefs@vger.kernel.org>
References: <2d978ffc-ed7b-4039-a713-c885dc8f4d00@huawei.com>
 <zeoohvw5qd7ooy5d4ruvoxojylkb5rous7u2nsuoev4b56r7qa@k7b3cijpf6zl>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <zeoohvw5qd7ooy5d4ruvoxojylkb5rous7u2nsuoev4b56r7qa@k7b3cijpf6zl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/6/4 10:01, Kent Overstreet wrote:
> On Tue, Jun 04, 2024 at 09:22:51AM +0800, Hongbo Li wrote:
>> I found the following issue on:
>>
>> HEAD commit: 587f7f5a4765a76f9ea05159963d14f8967cb45b(cmd_list_journal: open
>> with noexcl, so we can work on mounted filesystems)
>>
>> git tree: master
>> git repo: https://github.com/koverstreet/bcachefs-tools.git
>> util-linux: 2.37.2
>>
>> IMPORTANT: If someone fix this issue, please kindly add the following tag to
>> the commit:
>>
>> Reported-by: Hongbo Li <lihongbo22@huawei.com>
>>
>> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): mounting version 1.9:
>> disk_accounting_v2
>> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): initializing new filesystem
>> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): going read-write
>> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): marking superblocks
>> [Tue Jun  4 09:16:44 2024] ------------[ cut here ]------------
>> [Tue Jun  4 09:16:44 2024] memcpy: detected field-spanning write (size 4) of
>> single field "r" at fs/bcachefs/disk_accounting.c:185 (size 3)
>> [Tue Jun  4 09:16:44 2024] WARNING: CPU: 6 PID: 11 at
> 
> Thanks, this just needs an unsafe_memcpy() annotation
> 
> 
> commit 1c39379a4cddbf8d68c588ac9df7149840b9e4ff
> Author: Kent Overstreet <kent.overstreet@linux.dev>
> Date:   Mon Jun 3 22:01:25 2024 -0400
> 
>      fixup! bcachefs: Disk space accounting rewrite
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index 48d68db286a3..f118d5614e3a 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -182,7 +182,9 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc
>   
>   	switch (acc_k.type) {
>   	case BCH_DISK_ACCOUNTING_replicas:
> -		memcpy(r, &acc_k.replicas, replicas_entry_bytes(&acc_k.replicas));
> +		unsafe_memcpy(r, &acc_k.replicas,
> +			      replicas_entry_bytes(&acc_k.replicas),
> +			      "variable length struct");

I have tested it on this patch. It Looks good! Feel free to add:

Reported-by: Hongbo Li <lihongbo22@huawei.com> and Tested-by: Hongbo Li 
<lihongbo22@huawei.com>

Thanks,
Hongbo

>   		return true;
>   	default:
>   		return false;
> 
