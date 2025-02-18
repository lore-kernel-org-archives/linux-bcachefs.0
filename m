Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CD17E1
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 07:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739863452; cv=none; b=N60fe9Ij3Bp6j8VV5A3oo6G8/OYiTdM3G43ZhV1eOnSzUkC12yN9IhJUCnzr9uta5pEi58CeYmL1VdPzWLzxsTRinly+Q+FCRsy/MgIkLYpKMjJS2DIWoMU76PRX1fHMaZJnLG6sjRKh/qirwBTNsdLvOV5oqHhJzXcapMlb0LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739863452; c=relaxed/simple;
	bh=qstu67XvFVwroorZpzJ4r2Nbsy4y187+5W16eFoKxEU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ofdvibdwZ+yZQ4CyX1G+0oYfDVR/+S0C9EA+ZzwrcUFvy39wUfCmokkhK7/rn1ry9vTEV09WNw3+0ax6/htj2fX0DnkQdgcG8ELsMUKXyZj7cQg1m3JU3pXMn47MHp/x5Tzlg2iw+10TeuOxXsCZ7ePrkY/WIseKeqs6WxsERMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YxrW70J8JzgdZQ;
	Tue, 18 Feb 2025 15:19:31 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id D8DDD1400DC;
	Tue, 18 Feb 2025 15:24:05 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Feb 2025 15:24:05 +0800
Message-ID: <327b80fe-f566-4836-9d31-c463d06a645d@huawei.com>
Date: Tue, 18 Feb 2025 15:24:04 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Fix fsck directory i_size checking
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <20250218003948.757888-1-kent.overstreet@linux.dev>
 <8dcc7ef6-6861-44d5-97ee-e0af154baf64@huawei.com>
In-Reply-To: <8dcc7ef6-6861-44d5-97ee-e0af154baf64@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/2/18 15:12, Hongbo Li wrote:
> 
> 
> On 2025/2/18 8:39, Kent Overstreet wrote:
>> Hongbo - please go over this thoroughly. It turns out (and I should've
>> caught this before I merged it) your check code in fsck.c was completely
>> fubar, and wouldn't ever log an error when i_size was off, so bugs
>> elsewhere would have been masked.
>>
>> -- >8 --
>>
>> Error handling was wrong, causing unhandled transaction restart errors.
>>
>> check_directory_size() was also inefficient, since keys in multiple
>> snapshots would be iterated over once for every snapshot. Convert it to
>> the same scheme used for i_sectors and subdir count checking.
>>
>> Cc: Hongbo Li <lihongbo22@huawei.com>
>> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>> ---
>>   fs/bcachefs/fsck.c | 78 ++++++++++++++++++----------------------------
>>   1 file changed, 31 insertions(+), 47 deletions(-)
>>
>> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
>> index 53a421ff136d..d406336e9a0a 100644
>> --- a/fs/bcachefs/fsck.c
>> +++ b/fs/bcachefs/fsck.c
>> @@ -823,6 +823,7 @@ struct inode_walker_entry {
>>       struct bch_inode_unpacked inode;
>>       u32            snapshot;
>>       u64            count;
>> +    u64            i_size;
>>   };
>>   struct inode_walker {
>> @@ -910,8 +911,9 @@ lookup_inode_for_snapshot(struct bch_fs *c, struct 
>> inode_walker *w, struct bkey_
>>       if (k.k->p.snapshot != i->snapshot && !is_whiteout) {
>>           struct inode_walker_entry new = *i;
>> -        new.snapshot = k.k->p.snapshot;
>> -        new.count = 0;
>> +        new.snapshot    = k.k->p.snapshot;
>> +        new.count    = 0;
>> +        new.i_size    = 0;
>>           struct printbuf buf = PRINTBUF;
>>           bch2_bkey_val_to_text(&buf, c, k);
>> @@ -1116,37 +1118,6 @@ static int get_snapshot_root_inode(struct 
>> btree_trans *trans,
>>       return ret;
>>   }
>> -static int check_directory_size(struct btree_trans *trans,
>> -                struct bch_inode_unpacked *inode_u,
>> -                struct bkey_s_c inode_k, bool *write_inode)
>> -{
>> -    struct btree_iter iter;
>> -    struct bkey_s_c k;
>> -    u64 new_size = 0;
>> -    int ret;
>> -
>> -    for_each_btree_key_max_norestart(trans, iter, BTREE_ID_dirents,
>> -            SPOS(inode_k.k->p.offset, 0, inode_k.k->p.snapshot),
>> -            POS(inode_k.k->p.offset, U64_MAX),
>> -            0, k, ret) {
>> -        if (k.k->type != KEY_TYPE_dirent)
>> -            continue;
>> -
>> -        struct bkey_s_c_dirent dirent = bkey_s_c_to_dirent(k);
>> -        struct qstr name = bch2_dirent_get_name(dirent);
>> -
>> -        new_size += dirent_occupied_size(&name);
>> -    }
>> -    bch2_trans_iter_exit(trans, &iter);
>> -
>> -    if (!ret && inode_u->bi_size != new_size) {
>> -        inode_u->bi_size = new_size;
>> -        *write_inode = true;
>> -    }
>> -
>> -    return ret;
>> -}
>> -
>>   static int check_inode(struct btree_trans *trans,
>>                  struct btree_iter *iter,
>>                  struct bkey_s_c k,
>> @@ -1335,16 +1306,6 @@ static int check_inode(struct btree_trans *trans,
>>           u.bi_journal_seq = journal_cur_seq(&c->journal);
>>           do_update = true;
>>       }
>> -
>> -    if (S_ISDIR(u.bi_mode)) {
>> -        ret = check_directory_size(trans, &u, k, &do_update);
>> -
>> -        fsck_err_on(ret,
>> -                trans, directory_size_mismatch,
>> -                "directory inode %llu:%u with the mismatch directory 
>> size",
>> -                u.bi_inum, k.k->p.snapshot);
> It only tries to fix the mismatched i_size, and only logs the error 
> during recalculating. And why the i_size will be off?
>> -        ret = 0;
>> -    }
>>   do_update:
>>       if (do_update) {
>>           ret = __bch2_fsck_write_inode(trans, &u);
>> @@ -2017,10 +1978,31 @@ static int check_subdir_count_notnested(struct 
>> btree_trans *trans, struct inode_
>>       return ret;
>>   }
>> -static int check_subdir_count(struct btree_trans *trans, struct 
>> inode_walker *w)
>> +static int check_dir_i_size_notnested(struct btree_trans *trans, 
>> struct inode_walker *w)
>> +{
>> +    struct bch_fs *c = trans->c;
>> +    int ret = 0;
>> +
>> +    darray_for_each(w->inodes, i)
>> +        if (fsck_err_on(i->inode.bi_size != i->i_size,
>> +                trans, inode_dir_wrong_nlink,
>> +                "directory %llu:%u with wrong i_nlink: got %u, should 
>> be %llu",
>> +                w->last_pos.inode, i->snapshot, i->inode.bi_nlink, 
>> i->count)) {
> This shows the wrong message. It should use directory_size_mismatch 
> error and corresponding values.
>> +            i->inode.bi_size = i->i_size;
>> +            ret = bch2_fsck_write_inode(trans, &i->inode);
>> +            if (ret)
>> +                break;
>> +        }
>> +fsck_err:
>> +    bch_err_fn(c, ret);
>> +    return ret;
>> +}
>> +
>> +static int check_subdir_dirents_count(struct btree_trans *trans, 
>> struct inode_walker *w)
>>   {
>>       u32 restart_count = trans->restart_count;
>>       return check_subdir_count_notnested(trans, w) ?:
>> +        check_dir_i_size_notnested(trans, w) ?:
>>           trans_was_restarted(trans, restart_count);
>>   }
>> @@ -2367,7 +2349,7 @@ static int check_dirent(struct btree_trans 
>> *trans, struct btree_iter *iter,
>>           goto out;
>>       if (dir->last_pos.inode != k.k->p.inode && dir->have_inodes) {
>> -        ret = check_subdir_count(trans, dir);
>> +        ret = check_subdir_dirents_count(trans, dir);
>>           if (ret)
>>               goto err;
>>       }
>> @@ -2457,9 +2439,11 @@ static int check_dirent(struct btree_trans 
>> *trans, struct btree_iter *iter,
>>       if (ret)
>>           goto err;
>> -    if (d.v->d_type == DT_DIR)
>> -        for_each_visible_inode(c, s, dir, d.k->p.snapshot, i)
>> +    for_each_visible_inode(c, s, dir, d.k->p.snapshot, i) {
>> +        if (d.v->d_type == DT_DIR)
>>               i->count++;
>> +        i->i_size += bkey_bytes(d.k);
> We cannot rely on the value of bkey_bytes of the older version (the 
> older is 0 for directory).
Sorry I am wrong, the older is not zero for directory. May be other 
problems cause the wrong results.

  The traversal order will affect the accounts
> of i_size. We should recalculate the sub-entries.
> 
> Also I did the following test:
> 
> older version without dir i_size:
> 
> ├── foo
> │   ├── MAINTAINERS
> │   ├── foo-2
> │   │   ├── MAINTAINERS
> │   │   └── profile
> │   └── profile
> └── lost+found
> 
> After fsck, it shows the i_size of foo-2 is still 0.
> 
> Thanks,
> Hongbo
> 
> 
>> +    }
>>   out:
>>   err:
>>   fsck_err:
> 
