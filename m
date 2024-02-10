Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB8259B
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Feb 2024 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707605788; cv=none; b=dFBxmK8phSZNrLlMPr2dv+SuYYMsBbG+bW0UWy9cb1ani2uD8BHDQ5bqSZXzOlTi5ed9LihYMnXVbIsxIJBDAmDEVwhZzJGPODbwgSveyu137uxHNfXXXeupntHGy8Q5QCInlvpvTkMSAtWD9C6K/q8Yjvu/2ZrTQ9NDMRGXbwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707605788; c=relaxed/simple;
	bh=tADe9YlmJS4LsvEfolA16lV5G925048Nl/CcT7kvz2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhbDS6EY4ybrZPiTk2EEb6tkf4mdjv9o2XLAMYgrD5rWygEap1hzLOoBcl0P7I+m7pEMaPxdsa+sgEM7x2vr7S2XvaXEuA7u7WiVH9e5PSOoJnPM5lZz9WilabBk0k5LDP9jLxqP5hHlgpJI+eTC2JERYLqBI3DKJq4TGFQDxi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgktsX7f; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgktsX7f"
Date: Sat, 10 Feb 2024 17:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707605782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJ2mdN7YgrqAapMaHGTcXBevcBwVN7E/w/AD69Ncan8=;
	b=dgktsX7fZN2ExmLjkwQ8+FdKrSjH/2TOeesaulG8Z7WNq9G2gxNFtDn2hpWsY/COH2UMXw
	Ltdz8+5ubBC/2vrocTq9ka7yZYGps11t1cRDPTrw7Os7CKDhvj6Df3lHGgmqCnvGajS831
	iiRXAc7kuA2l2FxBrsEGVs1TubQliTg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Guoyu Ou <benogy@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: skip invisible entries in empty subvolume
 checking
Message-ID: <3skajn5gtyfbxu2zivet2kpq62i2nwcidzzfe5jk6ovi57esa5@vnbgwdz5ypk7>
References: <20240210140637.87092-1-benogy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240210140637.87092-1-benogy@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 10, 2024 at 10:06:37PM +0800, Guoyu Ou wrote:
> When we are checking whether a subvolume is empty in the specified snapshot,
> entries that do not belong to this subvolume should be skipped.
> 
> This fixes the following case:
> 
>     $ bcachefs subvolume create ./sub
>     $ cd sub
>     $ bcachefs subvolume create ./sub2
>     $ bcachefs subvolume snapshot . ./snap
>     $ ls -a snap
>     . ..
>     $ rmdir snap
>     rmdir: failed to remove 'snap': Directory not empty
> 
> Signed-off-by: Guoyu Ou <benogy@gmail.com>

So that's an interesting corner case - can you add a ktest test for it?
https://evilpiepirate.org/git/ktest.git/

If you're not using it yet, please jump on IRC and ask if you run into
any issues getting it going; 

There's an issue with your fix: in may_delete_deleted_inode(), you're
getting the subvol from inode.bi_subvol.

That's incorrect, because bi_subvol is only set on subvolume roots,
because we can't go through every inode in the subvolume and change
bi_subvol when taking a snapshot.

You're doing it right in bch2_empty_dir_trans(), which is the path that
matters more; may_delete_deleted_inode() is only checking "did this
filesystem get borked".

I would just pass in 0 from may_delete_deleted_inode(), and then have
empty_dir_snapshot() ignore DT_SUBVOL dirents when subvol == 0. It makes
the check less strict, but that's ok, the rest of fsck will still catch
it.

> ---
>  fs/bcachefs/dirent.c | 7 +++++--
>  fs/bcachefs/dirent.h | 2 +-
>  fs/bcachefs/inode.c  | 2 +-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> index 4ae1e9f002a0..82c5bff01411 100644
> --- a/fs/bcachefs/dirent.c
> +++ b/fs/bcachefs/dirent.c
> @@ -508,7 +508,7 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
>  	return ret;
>  }
>  
> -int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
> +int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 subvol, u32 snapshot)
>  {
>  	struct btree_iter iter;
>  	struct bkey_s_c k;
> @@ -518,6 +518,9 @@ int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
>  			   SPOS(dir, 0, snapshot),
>  			   POS(dir, U64_MAX), 0, k, ret)
>  		if (k.k->type == KEY_TYPE_dirent) {
> +			struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
> +			if (d.v->d_type == DT_SUBVOL && le32_to_cpu(d.v->d_parent_subvol) != subvol)
> +				continue;
>  			ret = -ENOTEMPTY;
>  			break;
>  		}
> @@ -531,7 +534,7 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
>  	u32 snapshot;
>  
>  	return bch2_subvolume_get_snapshot(trans, dir.subvol, &snapshot) ?:
> -		bch2_empty_dir_snapshot(trans, dir.inum, snapshot);
> +		bch2_empty_dir_snapshot(trans, dir.inum, dir.subvol, snapshot);
>  }
>  
>  int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
> diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
> index 21ffeb78f02e..aeb8207ca9f2 100644
> --- a/fs/bcachefs/dirent.h
> +++ b/fs/bcachefs/dirent.h
> @@ -69,7 +69,7 @@ u64 bch2_dirent_lookup(struct bch_fs *, subvol_inum,
>  		       const struct bch_hash_info *,
>  		       const struct qstr *, subvol_inum *);
>  
> -int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32);
> +int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32, u32);
>  int bch2_empty_dir_trans(struct btree_trans *, subvol_inum);
>  int bch2_readdir(struct bch_fs *, subvol_inum, struct dir_context *);
>  
> diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
> index 086f0090b03a..8f85d0132cc2 100644
> --- a/fs/bcachefs/inode.c
> +++ b/fs/bcachefs/inode.c
> @@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
>  		goto out;
>  
>  	if (S_ISDIR(inode.bi_mode)) {
> -		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
> +		ret = bch2_empty_dir_snapshot(trans, pos.offset, inode.bi_subvol, pos.snapshot);
>  		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
>  				"non empty directory %llu:%u in deleted_inodes btree",
>  				pos.offset, pos.snapshot))
> -- 
> 2.43.0
> 
