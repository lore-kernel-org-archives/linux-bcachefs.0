Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E5079D2
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 01:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739756977; cv=none; b=E2AmuG2Hz6cVpO6n4cO2sBo8HIOKe12q9lxykrGPlRP5VWbecmW54qgFSDNdP944l1/WCYJoBA3Ti0k2+qBTdaRYtD4qjHLZKEoF1nYm+TJlmvm18She5Y2HSd2LJV5Yj7C81QZ9Ty3YE6AiMYvDXCz12Y69TA6oiwHBW5qfUkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739756977; c=relaxed/simple;
	bh=VkMSjzn+CcGolceBQvGBTCA1xMtn1F26gnd7JBo1zAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tFj5poSaaZ+iDaP3FnIXIngkf94h7JD1z1HShzQOZnquBYvXgoH+mW13D3l5AnrJq25sq2CUxWLlOjsTIWTn4EKIaOidO9m3FsChIARK6oEUy3nDomBh4hO/o6l7caPr79gu5lH0R9oXg0FFmHnkhzMhef4EhMt9/s4kXmYRXrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Yx5FH55jFz1xty0;
	Mon, 17 Feb 2025 09:49:55 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 561181A0171;
	Mon, 17 Feb 2025 09:49:25 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Feb 2025 09:49:24 +0800
Message-ID: <7f4dd5a5-612f-4135-b259-a1f2b83b5122@huawei.com>
Date: Mon, 17 Feb 2025 09:49:23 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/18] bcachefs: Kill dirent_occupied_size()
To: Kent Overstreet <kent.overstreet@linux.dev>,
	<linux-bcachefs@vger.kernel.org>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
 <20250213184607.18237-17-kent.overstreet@linux.dev>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20250213184607.18237-17-kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/2/14 2:46, Kent Overstreet wrote:
> With the upcoming patches for casefolding, we really need to use the
> size of the dirent key itself - which is cleaner, anyways.
> 
> The size of the dirent is no longer just a function of the length of the
> name, it'll be different depending on whether the directory has
> casefolding enabled - which means the accounting in rename() has to
> change a bit.
> 
> Cc: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>   fs/bcachefs/dirent.c    | 15 +++++++++++++--
>   fs/bcachefs/dirent.h    | 11 +++--------
>   fs/bcachefs/fs-common.c | 42 ++++++++++++++++++++++-------------------
>   fs/bcachefs/fsck.c      |  5 +----
>   4 files changed, 40 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> index 600eee936f13..27737aaa03a6 100644
> --- a/fs/bcachefs/dirent.c
> +++ b/fs/bcachefs/dirent.c
> @@ -233,6 +233,7 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
>   		       const struct bch_hash_info *hash_info,
>   		       u8 type, const struct qstr *name, u64 dst_inum,
>   		       u64 *dir_offset,
> +		       u64 *i_size,
>   		       enum btree_iter_update_trigger_flags flags)
>   {
>   	struct bkey_i_dirent *dirent;
> @@ -243,6 +244,8 @@ int bch2_dirent_create(struct btree_trans *trans, subvol_inum dir,
>   	if (ret)
>   		return ret;
>   
> +	*i_size += bkey_bytes(&dirent->k);
> +
>   	ret = bch2_hash_set(trans, bch2_dirent_hash_desc, hash_info,
>   			    dir, &dirent->k_i, flags);
>   	*dir_offset = dirent->k.p.offset;
> @@ -275,8 +278,8 @@ int bch2_dirent_read_target(struct btree_trans *trans, subvol_inum dir,
>   }
>   
>   int bch2_dirent_rename(struct btree_trans *trans,
> -		subvol_inum src_dir, struct bch_hash_info *src_hash,
> -		subvol_inum dst_dir, struct bch_hash_info *dst_hash,
> +		subvol_inum src_dir, struct bch_hash_info *src_hash, u64 *src_dir_i_size,
> +		subvol_inum dst_dir, struct bch_hash_info *dst_hash, u64 *dst_dir_i_size,
>   		const struct qstr *src_name, subvol_inum *src_inum, u64 *src_offset,
>   		const struct qstr *dst_name, subvol_inum *dst_inum, u64 *dst_offset,
>   		enum bch_rename_mode mode)
> @@ -406,6 +409,14 @@ int bch2_dirent_rename(struct btree_trans *trans,
>   	    new_src->v.d_type == DT_SUBVOL)
>   		new_src->v.d_parent_subvol = cpu_to_le32(src_dir.subvol);
>   
> +	if (old_dst.k)
> +		*dst_dir_i_size -= bkey_bytes(old_dst.k);
> +	*src_dir_i_size -= bkey_bytes(old_src.k);
> +
> +	if (mode == BCH_RENAME_EXCHANGE)
> +		*src_dir_i_size += bkey_bytes(&new_src->k);
> +	*dst_dir_i_size += bkey_bytes(&new_dst->k);
> +

Ah, if I had dug into bkey_bytes, I might not have introduced 
dirent_occupied_size. The logic seems equivalent and more reasonable.

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>

Thanks,
Hongbo


>   	ret = bch2_trans_update(trans, &dst_iter, &new_dst->k_i, 0);
>   	if (ret)
>   		goto out;
> diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
> index a633f83c1ac7..37f01c1a3f7f 100644
> --- a/fs/bcachefs/dirent.h
> +++ b/fs/bcachefs/dirent.h
> @@ -31,11 +31,6 @@ static inline unsigned dirent_val_u64s(unsigned len)
>   			    sizeof(u64));
>   }
>   
> -static inline unsigned int dirent_occupied_size(const struct qstr *name)
> -{
> -	return (BKEY_U64s + dirent_val_u64s(name->len)) * sizeof(u64);
> -}
> -
>   int bch2_dirent_read_target(struct btree_trans *, subvol_inum,
>   			    struct bkey_s_c_dirent, subvol_inum *);
>   
> @@ -52,7 +47,7 @@ int bch2_dirent_create_snapshot(struct btree_trans *, u32, u64, u32,
>   			enum btree_iter_update_trigger_flags);
>   int bch2_dirent_create(struct btree_trans *, subvol_inum,
>   		       const struct bch_hash_info *, u8,
> -		       const struct qstr *, u64, u64 *,
> +		       const struct qstr *, u64, u64 *, u64 *,
>   		       enum btree_iter_update_trigger_flags);
>   
>   static inline unsigned vfs_d_type(unsigned type)
> @@ -67,8 +62,8 @@ enum bch_rename_mode {
>   };
>   
>   int bch2_dirent_rename(struct btree_trans *,
> -		       subvol_inum, struct bch_hash_info *,
> -		       subvol_inum, struct bch_hash_info *,
> +		       subvol_inum, struct bch_hash_info *, u64 *,
> +		       subvol_inum, struct bch_hash_info *, u64 *,
>   		       const struct qstr *, subvol_inum *, u64 *,
>   		       const struct qstr *, subvol_inum *, u64 *,
>   		       enum bch_rename_mode);
> diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
> index d70d9f634cea..c8afd312e601 100644
> --- a/fs/bcachefs/fs-common.c
> +++ b/fs/bcachefs/fs-common.c
> @@ -42,11 +42,14 @@ int bch2_create_trans(struct btree_trans *trans,
>   	if (ret)
>   		goto err;
>   
> -	ret = bch2_inode_peek(trans, &dir_iter, dir_u, dir,
> -			      BTREE_ITER_intent|BTREE_ITER_with_updates);
> +	ret = bch2_inode_peek(trans, &dir_iter, dir_u, dir, BTREE_ITER_intent);
>   	if (ret)
>   		goto err;
>   
> +	/* Inherit casefold state from parent. */
> +	if (S_ISDIR(mode))
> +		new_inode->bi_flags |= dir_u->bi_flags & BCH_INODE_casefolded;
> +
>   	if (!(flags & BCH_CREATE_SNAPSHOT)) {
>   		/* Normal create path - allocate a new inode: */
>   		bch2_inode_init_late(new_inode, now, uid, gid, mode, rdev, dir_u);
> @@ -152,7 +155,6 @@ int bch2_create_trans(struct btree_trans *trans,
>   		if (is_subdir_for_nlink(new_inode))
>   			dir_u->bi_nlink++;
>   		dir_u->bi_mtime = dir_u->bi_ctime = now;
> -		dir_u->bi_size += dirent_occupied_size(name);
>   
>   		ret = bch2_inode_write(trans, &dir_iter, dir_u);
>   		if (ret)
> @@ -163,7 +165,8 @@ int bch2_create_trans(struct btree_trans *trans,
>   					 name,
>   					 dir_target,
>   					 &dir_offset,
> -					 STR_HASH_must_create|BTREE_ITER_with_updates);
> +					 &dir_u->bi_size,
> +					 STR_HASH_must_create);
>   		if (ret)
>   			goto err;
>   
> @@ -221,13 +224,14 @@ int bch2_link_trans(struct btree_trans *trans,
>   	}
>   
>   	dir_u->bi_mtime = dir_u->bi_ctime = now;
> -	dir_u->bi_size += dirent_occupied_size(name);
>   
>   	dir_hash = bch2_hash_info_init(c, dir_u);
>   
>   	ret = bch2_dirent_create(trans, dir, &dir_hash,
>   				 mode_to_type(inode_u->bi_mode),
> -				 name, inum.inum, &dir_offset,
> +				 name, inum.inum,
> +				 &dir_offset,
> +				 &dir_u->bi_size,
>   				 STR_HASH_must_create);
>   	if (ret)
>   		goto err;
> @@ -266,8 +270,16 @@ int bch2_unlink_trans(struct btree_trans *trans,
>   
>   	dir_hash = bch2_hash_info_init(c, dir_u);
>   
> -	ret = bch2_dirent_lookup_trans(trans, &dirent_iter, dir, &dir_hash,
> -				       name, &inum, BTREE_ITER_intent);
> +	struct bkey_s_c dirent_k =
> +		bch2_hash_lookup(trans, &dirent_iter, bch2_dirent_hash_desc,
> +				 &dir_hash, dir, name, BTREE_ITER_intent);
> +	ret = bkey_err(dirent_k);
> +	if (ret)
> +		goto err;
> +
> +	ret = bch2_dirent_read_target(trans, dir, bkey_s_c_to_dirent(dirent_k), &inum);
> +	if (ret > 0)
> +		ret = -ENOENT;
>   	if (ret)
>   		goto err;
>   
> @@ -324,7 +336,7 @@ int bch2_unlink_trans(struct btree_trans *trans,
>   
>   	dir_u->bi_mtime = dir_u->bi_ctime = inode_u->bi_ctime = now;
>   	dir_u->bi_nlink -= is_subdir_for_nlink(inode_u);
> -	dir_u->bi_size	-= dirent_occupied_size(name);
> +	dir_u->bi_size	-= bkey_bytes(dirent_k.k);
>   
>   	ret =   bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
>   				    &dir_hash, &dirent_iter,
> @@ -420,8 +432,8 @@ int bch2_rename_trans(struct btree_trans *trans,
>   	}
>   
>   	ret = bch2_dirent_rename(trans,
> -				 src_dir, &src_hash,
> -				 dst_dir, &dst_hash,
> +				 src_dir, &src_hash, &src_dir_u->bi_size,
> +				 dst_dir, &dst_hash, &dst_dir_u->bi_size,
>   				 src_name, &src_inum, &src_offset,
>   				 dst_name, &dst_inum, &dst_offset,
>   				 mode);
> @@ -463,14 +475,6 @@ int bch2_rename_trans(struct btree_trans *trans,
>   		goto err;
>   	}
>   
> -	if (mode == BCH_RENAME) {
> -		src_dir_u->bi_size -= dirent_occupied_size(src_name);
> -		dst_dir_u->bi_size += dirent_occupied_size(dst_name);
> -	}
> -
> -	if (mode == BCH_RENAME_OVERWRITE)
> -		src_dir_u->bi_size -= dirent_occupied_size(src_name);
> -
>   	if (src_inode_u->bi_parent_subvol)
>   		src_inode_u->bi_parent_subvol = dst_dir.subvol;
>   
> diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
> index 53a421ff136d..24ad1a42d169 100644
> --- a/fs/bcachefs/fsck.c
> +++ b/fs/bcachefs/fsck.c
> @@ -1132,10 +1132,7 @@ static int check_directory_size(struct btree_trans *trans,
>   		if (k.k->type != KEY_TYPE_dirent)
>   			continue;
>   
> -		struct bkey_s_c_dirent dirent = bkey_s_c_to_dirent(k);
> -		struct qstr name = bch2_dirent_get_name(dirent);
> -
> -		new_size += dirent_occupied_size(&name);
> +		new_size += bkey_bytes(k.k);
>   	}
>   	bch2_trans_iter_exit(trans, &iter);
>   
