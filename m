Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07011AC8BE
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 03:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723778271; cv=none; b=pxioTVZiRN0ZP6lQZWcZG4JNmxQtLZhacxDEVuEbMjfL9eR07n2+UsvEL4Yhw6TaooV+UZY04mqs1afHZA3ESyVB7mq2liF/g7d7qV4FXPn0p7MHdPvQ6q11qW1KcX80+PUBnPIPpxkZH6MKUrs4vB6KuH8+TU2WkuAWD8pDgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723778271; c=relaxed/simple;
	bh=i/j1OAOtheIBPvvxzUJDJVyvmWxGFyIIIdwU/LdPej8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LLEnVi7MuCnpAPHe2WWQLYTGPpafOXMrebDGfG9bgn+i/huiDXQvAFnq5uEASLXzDJPhJgw8M1hFNANap1ClBw8tXrS0YdY/dWOb5x7uRNPypnNRDGRDQS5+Lv1euBJgIQRCg79Nml9UaqilkPO1g5ZUgQ5We84cG8OWyOfmxgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WlRxF4NDSz1T7DC;
	Fri, 16 Aug 2024 11:17:05 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F23B18006C;
	Fri, 16 Aug 2024 11:17:37 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 16 Aug 2024 11:17:37 +0800
Message-ID: <fa70304b-c2b3-4142-97d1-667097cfcbd2@huawei.com>
Date: Fri, 16 Aug 2024 11:17:36 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] bcachefs: make directory i_size meaningful
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>
References: <20240705072006.2768861-1-lihongbo22@huawei.com>
 <2sjq2njetbhhqo2zuufrjuarzvo4jl2pid52idwdz45h7li4bm@throc6jwnckk>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <2sjq2njetbhhqo2zuufrjuarzvo4jl2pid52idwdz45h7li4bm@throc6jwnckk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/7/6 12:11, Kent Overstreet wrote:
> On Fri, Jul 05, 2024 at 03:20:06PM GMT, Hongbo Li wrote:
>> The isize of directory is 0 in bcachefs if the directory is empty.
>> With more child dirents created, its size ought to change. Many
>> other filesystems changed as that (ie. xfs and btrfs). And many of
>> them changed as the size of child dirent name. Although the directory
>> size may not seem to convey much, we can still give it some meaning.
>>
>> The formula of dentry size as follow:
>>      occupied_size = 40 + ALIGN(9 + namelen, 8)
>>
>> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> 
> I like it.
> 
> It's going to need more work though; it'll be a new on disk format
> version, and fsck needs to know how to sum up dirents and check i_size -
> which won't be bad, since we already have to sum up child directories
> for i_nlink.
> 
Hi Kent,

I am sorry for being busy with other things for a while, and now I have 
time to work on this.

I think we can do this by two phrases:
  - phrase one
   The main point is to ensure consistency between the old and new 
filesystem when reading the directory size. That is:
     For WRITE case (such as this case), we set the dir size for new one.
     For READ case (such as getattr), we proactively invoke the helper 
to calculate the directory size for the directory.

   - phrase two:
   Considering how to couple with fsck.

I hope I haven't misunderstood, have I?  And in bcachefs, 
KEY_TYPE_inode_v3 is the newest. So can I introduce the 
KEY_TYPE_inode_v4 for this new disk layout to distinguish when the 
directory size is meaningful?

Thanks,
Hongbo

>> ---
>>   fs/bcachefs/dirent.h    |  5 +++++
>>   fs/bcachefs/fs-common.c | 11 +++++++++++
>>   fs/bcachefs/fs.c        | 13 ++++++++-----
>>   3 files changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
>> index 24037e6e0a09..16b0c89970ac 100644
>> --- a/fs/bcachefs/dirent.h
>> +++ b/fs/bcachefs/dirent.h
>> @@ -32,6 +32,11 @@ static inline unsigned dirent_val_u64s(unsigned len)
>>   			    sizeof(u64));
>>   }
>>   
>> +static inline unsigned int dirent_occupied_size(const struct qstr *name)
>> +{
>> +	return (BKEY_U64s + dirent_val_u64s(name->len)) * sizeof(u64);
>> +}
>> +
>>   int bch2_dirent_read_target(struct btree_trans *, subvol_inum,
>>   			    struct bkey_s_c_dirent, subvol_inum *);
>>   
>> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
>> index 508d029ac53d..2d5db8c530a2 100644
>> --- a/fs/bcachefs/fs-common.c
>> +++ b/fs/bcachefs/fs-common.c
>> @@ -153,6 +153,7 @@ int bch2_create_trans(struct btree_trans *trans,
>>   		if (is_subdir_for_nlink(new_inode))
>>   			dir_u->bi_nlink++;
>>   		dir_u->bi_mtime = dir_u->bi_ctime = now;
>> +		dir_u->bi_size += dirent_occupied_size(name);
>>   
>>   		ret = bch2_inode_write(trans, &dir_iter, dir_u);
>>   		if (ret)
>> @@ -217,6 +218,7 @@ int bch2_link_trans(struct btree_trans *trans,
>>   	}
>>   
>>   	dir_u->bi_mtime = dir_u->bi_ctime = now;
>> +	dir_u->bi_size += dirent_occupied_size(name);
>>   
>>   	dir_hash = bch2_hash_info_init(c, dir_u);
>>   
>> @@ -319,6 +321,7 @@ int bch2_unlink_trans(struct btree_trans *trans,
>>   
>>   	dir_u->bi_mtime = dir_u->bi_ctime = inode_u->bi_ctime = now;
>>   	dir_u->bi_nlink -= is_subdir_for_nlink(inode_u);
>> +	dir_u->bi_size	-= dirent_occupied_size(name);
>>   
>>   	ret =   bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
>>   				    &dir_hash, &dirent_iter,
>> @@ -457,6 +460,14 @@ int bch2_rename_trans(struct btree_trans *trans,
>>   		goto err;
>>   	}
>>   
>> +	if (mode == BCH_RENAME) {
>> +		src_dir_u->bi_size -= dirent_occupied_size(src_name);
>> +		dst_dir_u->bi_size += dirent_occupied_size(dst_name);
>> +	}
>> +
>> +	if (mode == BCH_RENAME_OVERWRITE)
>> +		src_dir_u->bi_size -= dirent_occupied_size(src_name);
>> +
>>   	if (src_inode_u->bi_parent_subvol)
>>   		src_inode_u->bi_parent_subvol = dst_dir.subvol;
>>   
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index fd01a5402c28..6c7496d40521 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -65,6 +65,9 @@ void bch2_inode_update_after_write(struct btree_trans *trans,
>>   	i_gid_write(&inode->v, bi->bi_gid);
>>   	inode->v.i_mode	= bi->bi_mode;
>>   
>> +	if (fields & ATTR_SIZE)
>> +		i_size_write(&inode->v, bi->bi_size);
>> +
>>   	if (fields & ATTR_ATIME)
>>   		inode_set_atime_to_ts(&inode->v, bch2_time_to_timespec(c, bi->bi_atime));
>>   	if (fields & ATTR_MTIME)
>> @@ -369,7 +372,7 @@ __bch2_create(struct mnt_idmap *idmap,
>>   
>>   	if (!(flags & BCH_CREATE_TMPFILE)) {
>>   		bch2_inode_update_after_write(trans, dir, &dir_u,
>> -					      ATTR_MTIME|ATTR_CTIME);
>> +					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
>>   		mutex_unlock(&dir->ei_update_lock);
>>   	}
>>   
>> @@ -525,7 +528,7 @@ static int __bch2_link(struct bch_fs *c,
>>   
>>   	if (likely(!ret)) {
>>   		bch2_inode_update_after_write(trans, dir, &dir_u,
>> -					      ATTR_MTIME|ATTR_CTIME);
>> +					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
>>   		bch2_inode_update_after_write(trans, inode, &inode_u, ATTR_CTIME);
>>   	}
>>   
>> @@ -577,7 +580,7 @@ int __bch2_unlink(struct inode *vdir, struct dentry *dentry,
>>   		goto err;
>>   
>>   	bch2_inode_update_after_write(trans, dir, &dir_u,
>> -				      ATTR_MTIME|ATTR_CTIME);
>> +				      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
>>   	bch2_inode_update_after_write(trans, inode, &inode_u,
>>   				      ATTR_MTIME);
>>   
>> @@ -724,11 +727,11 @@ static int bch2_rename2(struct mnt_idmap *idmap,
>>   	       dst_inode->v.i_ino != dst_inode_u.bi_inum);
>>   
>>   	bch2_inode_update_after_write(trans, src_dir, &src_dir_u,
>> -				      ATTR_MTIME|ATTR_CTIME);
>> +				      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
>>   
>>   	if (src_dir != dst_dir)
>>   		bch2_inode_update_after_write(trans, dst_dir, &dst_dir_u,
>> -					      ATTR_MTIME|ATTR_CTIME);
>> +					      ATTR_MTIME|ATTR_CTIME|ATTR_SIZE);
>>   
>>   	bch2_inode_update_after_write(trans, src_inode, &src_inode_u,
>>   				      ATTR_CTIME);
>> -- 
>> 2.34.1
>>
