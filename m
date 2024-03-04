Received: from mail-108-mta162.mxroute.com (mail-108-mta162.mxroute.com [136.175.108.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C4CB654
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Mar 2024 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709550247; cv=none; b=dUQxFyTIBHW63HAoPMV3yKDkGiEBQDVjfGQUYrsndW4Fh4uFjY0/N4zvKLz7K1gnylkLJo5N3/pIpFIzTV+cs6lh6qKHpwtx9wsuBLiYHi+PjnbGi0RarJw7H5W9D8TxQf3G2062MyK42+1An5p7JkAo+YalJVvD+71bw6Wg3i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709550247; c=relaxed/simple;
	bh=ABUoXqb4QcK+r5diPiS8LiJQ/RSUu4on3uLn1QJNZcw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=LAtlwfX836Caj6mGG7j5hT/Hka+6fb2mBJXlAtGdbWDY2SW+ViWeDMDzyU5fbtKhda29lV7mzyV9YRvU4pXfNqFFgk1xtS/ecev3QZ7iItzdxOIGmsMYVN7difowXznZLIXR/Z5v0TbYigHM0ddLJOvmwo+9rxZY7rX/zjhJVWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=WbY6V3Aj; arc=none smtp.client-ip=136.175.108.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="WbY6V3Aj"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta162.mxroute.com (ZoneMTA) with ESMTPSA id 18e091dda850003bea.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 04 Mar 2024 10:58:55 +0000
X-Zone-Loop: 3a0759f50025f37a672c356c25d8355e0a93ded91971
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1UHzGpZdyo1LjOM2X4xUat1TELrdDB5G2pictjBphhE=; b=WbY6V3AjRRB67xfHdY9ToSWf/A
	iyAsRRXYbHErJ2EpvW0vKvDz7xup68uZuW5A5psDgsDbjWB/LSo0SMhsnChCO7JphKL/advlksyOp
	j3fCR2AOEiNzzJMN5L5pxB8LPMtGIxU8GM5RjzPz30RBZ0Cmwm5yNRnbYCxv9RHXyUXg7oD8JW7z+
	1WwjGpN7gFsUZK7Etbiv276r4yPtfw/BqgiLw2DK5XSIou0SFASie8y6zVf2UnG39DvcKw/5vLoBy
	DukPlxn8VBxeRqPZgDzeAi7aSb8WEyie3ajr2DIZI0gnV+NXH5o7wh+UO7RlIpAvA3+6ErAdHTVV0
	NGVy0iwg==;
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 04 Mar 2024 10:58:53 +0000
From: l@damenly.org
To: Li Zetao <lizetao1@huawei.com>
Cc: kent.overstreet@linux.dev, bfoster@redhat.com,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix null-ptr-deref in bch2_fs_alloc()
In-Reply-To: <f472dffa-d888-1566-e1e2-313f4eb842c2@huawei.com>
References: <20240304032203.3480001-1-lizetao1@huawei.com>
 <frx6edjh.fsf@damenly.org> <f472dffa-d888-1566-e1e2-313f4eb842c2@huawei.com>
Message-ID: <c7a48c2f58f409b3446de7655ce59a42@damenly.org>
X-Sender: l@damenly.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: l@damenly.org

On 2024-03-04 09:47, Li Zetao wrote:
> On 2024/3/4 13:12, Su Yue wrote:
>> 
>> On Mon 04 Mar 2024 at 11:22, Li Zetao <lizetao1@huawei.com> wrote:
>> 
>>> There is a null-ptr-deref issue reported by kasan:
>>> 
>>>   KASAN: null-ptr-deref in range   
>>> [0x0000000000000000-0x0000000000000007]
>>>   Call Trace:
>>>     <TASK>
>>>     bch2_fs_alloc+0x1092/0x2170 [bcachefs]
>>>     bch2_fs_open+0x683/0xe10 [bcachefs]
>>>     ...
>>> 
>>> When initializing the name of bch_fs, it needs to dynamically alloc 
>>> memory
>>> to meet the length of the name. However, when name allocation failed, 
>>> it
>>> will cause a null-ptr-deref access exception in subsequent string 
>>> copy.
>>> 
>> bch2_printbuf_make_room() does return -ENOMEM but
>> bch2_prt_printf() doesn't check the return code. And there are too 
>> many
>> callers of bch2_prt_printf() don't check allocation_failure.
> Indeed, too many callers do not check whether name allocation is 
> successful, which may cause hidden dangers. Maybe it is neccssary to 
> use somethings like __GFP_NOFAIL flag here?

No need of this as printbuf is not critical for using __GFP_NOFAIL. 
__GFP_NOFAIL should be used carefully.
It's just my nags. IOW, a fix as your fix is fine to me unless someone 
sends 100+ patches to fix places like this.

>> 
>>> Fix this issue by checking if name allocation is successful.
>>> 
>>> Fixes: 401ec4db6308 ("bcachefs: Printbuf rework")
>>> Signed-off-by: Li Zetao <lizetao1@huawei.com>
>>> ---
>>>  fs/bcachefs/super.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>> 
>>> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
>>> index 6b23e11825e6..24fa41bbe7e3 100644
>>> --- a/fs/bcachefs/super.c
>>> +++ b/fs/bcachefs/super.c
>>> @@ -818,13 +818,13 @@ static struct bch_fs *bch2_fs_alloc(struct 
>>> bch_sb *sb, struct bch_opts opts)
>>>          goto err;
>>> 
>>>      pr_uuid(&name, c->sb.user_uuid.b);
>>> -    strscpy(c->name, name.buf, sizeof(c->name));
>>> -    printbuf_exit(&name);
>>> -
>>>      ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc  : 
>>> 0;
>>>      if (ret)
>>>          goto err;
>>> 
>> IIRC, krealloc() doesn't free old pointer if new-size allocation 
>> failed.
>> There is no printbuf_exit called in label err then memory leak 
>> happens.
>> 
> Here krealloc() is a bit complicated:
> 1.if name allocation failure happens on the first time, the old pointer 
> will be NULL, which cause a null-ptr-deref issue.

But kfree(NULL) is safe, right?

mm/slub.c:
/**
  * kfree - free previously allocated memory
  * @object: pointer returned by kmalloc() or kmem_cache_alloc()
  *
  * If @object is NULL, no operation is performed.
  */
void kfree(const void *object)


-- 
Su
> 2.if name allocation failure don't happens on the first time, the old 
> pointer will be available and need to free.
> 
> So the correct modification should be something like this:
>     pr_uuid(&name, c->sb.user_uuid.b);
>     if (unlikely(!name.buf)) {
>         ret = -BCH_ERR_ENOMEM_fs_name_alloc;
>         goto err;
>     }
> 
>     strscpy(c->name, name.buf, sizeof(c->name));
>     printbuf_exit(&name);
> 
>     ret = name.allocation_failure ? -BCH_ERR_ENOMEM_fs_name_alloc  : 0;
>     if (ret)
>         goto err;
>> -- Su
>>> 
>>> +    strscpy(c->name, name.buf, sizeof(c->name));
>>> +    printbuf_exit(&name);
>>> +
>>>      /* Compat: */
>>>      if (le16_to_cpu(sb->version) <= 
>>>  bcachefs_metadata_version_inode_v2 &&
>>>          !BCH_SB_JOURNAL_FLUSH_DELAY(sb))
> 
> Best regards,
> --
> Li Zetao
