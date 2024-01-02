Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F35712B75
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Jan 2024 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17B32C15;
	Tue,  2 Jan 2024 06:28:58 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 684DB3F64C;
	Tue,  2 Jan 2024 06:28:11 -0800 (PST)
Date: Tue, 2 Jan 2024 14:28:04 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: make RO snapshots actually RO
Message-ID: <20240102142804.GA1028907@e124191.cambridge.arm.com>
References: <20231230195802.2220651-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231230195802.2220651-1-kent.overstreet@linux.dev>

Hi Kent,

On Sat, Dec 30, 2023 at 02:58:02PM -0500, Kent Overstreet wrote:
> Add checks to all the VFS paths for "are we in a RO snapshot?".
> 
> Note - we don't check this when setting inode options via our xattr
> interface, since those generally only affect data placement, not
> contents of data.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/acl.c       |  3 ++-
>  fs/bcachefs/fs-ioctl.c  | 12 +++++-------
>  fs/bcachefs/fs.c        | 38 +++++++++++++++++++++++++++++++++-----
>  fs/bcachefs/subvolume.c | 18 ++++++++++++++++++
>  fs/bcachefs/subvolume.h |  3 +++
>  fs/bcachefs/xattr.c     |  3 ++-
>  6 files changed, 63 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/bcachefs/acl.c b/fs/bcachefs/acl.c
> index f3809897f00a..a9f3b0817b41 100644
> --- a/fs/bcachefs/acl.c
> +++ b/fs/bcachefs/acl.c
> @@ -366,7 +366,8 @@ int bch2_set_acl(struct mnt_idmap *idmap,
>  	bch2_trans_begin(trans);
>  	acl = _acl;
>  
> -	ret = bch2_inode_peek(trans, &inode_iter, &inode_u, inode_inum(inode),
> +	ret   = bch2_subvol_is_ro_trans(trans, inode->ei_subvol);
> +		bch2_inode_peek(trans, &inode_iter, &inode_u, inode_inum(inode),
>  			      BTREE_ITER_INTENT);

Looks like this is throwing away the return value of `bch2_inode_peek`, because
the previous line ends in ';' but it should end in '?:' to match other changes
in this commit?

>  	if (ret)
>  		goto btree_err;
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index 8098a3a299d1..e0a19a73c8e1 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -100,7 +100,8 @@ static int bch2_ioc_setflags(struct bch_fs *c,
>  	}
>  
>  	mutex_lock(&inode->ei_update_lock);
> -	ret = bch2_write_inode(c, inode, bch2_inode_flags_set, &s,
> +	ret   = bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> +		bch2_write_inode(c, inode, bch2_inode_flags_set, &s,
>  			       ATTR_CTIME);
>  	mutex_unlock(&inode->ei_update_lock);
>  
> @@ -183,13 +184,10 @@ static int bch2_ioc_fssetxattr(struct bch_fs *c,
>  	}
>  
>  	mutex_lock(&inode->ei_update_lock);
> -	ret = bch2_set_projid(c, inode, fa.fsx_projid);
> -	if (ret)
> -		goto err_unlock;
> -
> -	ret = bch2_write_inode(c, inode, fssetxattr_inode_update_fn, &s,
> +	ret   = bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> +		bch2_set_projid(c, inode, fa.fsx_projid) ?:
> +		bch2_write_inode(c, inode, fssetxattr_inode_update_fn, &s,
>  			       ATTR_CTIME);
> -err_unlock:
>  	mutex_unlock(&inode->ei_update_lock);
>  err:
>  	inode_unlock(&inode->v);
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 34cb22a9c05d..0e1d709100bb 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -258,7 +258,8 @@ __bch2_create(struct mnt_idmap *idmap,
>  retry:
>  	bch2_trans_begin(trans);
>  
> -	ret   = bch2_create_trans(trans,
> +	ret   = bch2_subvol_is_ro_trans(trans, dir->ei_subvol);
> +		bch2_create_trans(trans,
>  				  inode_inum(dir), &dir_u, &inode_u,
>  				  !(flags & BCH_CREATE_TMPFILE)
>  				  ? &dentry->d_name : NULL,

Same again.

> @@ -430,7 +431,9 @@ static int bch2_link(struct dentry *old_dentry, struct inode *vdir,
>  
>  	lockdep_assert_held(&inode->v.i_rwsem);
>  
> -	ret = __bch2_link(c, inode, dir, dentry);
> +	ret   = bch2_subvol_is_ro(c, dir->ei_subvol) ?:
> +		bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> +		__bch2_link(c, inode, dir, dentry);
>  	if (unlikely(ret))
>  		return ret;
>  
> @@ -481,7 +484,11 @@ int __bch2_unlink(struct inode *vdir, struct dentry *dentry,
>  
>  static int bch2_unlink(struct inode *vdir, struct dentry *dentry)
>  {
> -	return __bch2_unlink(vdir, dentry, false);
> +	struct bch_inode_info *dir= to_bch_ei(vdir);
> +	struct bch_fs *c = dir->v.i_sb->s_fs_info;
> +
> +	return bch2_subvol_is_ro(c, dir->ei_subvol) ?:
> +		__bch2_unlink(vdir, dentry, false);
>  }
>  
>  static int bch2_symlink(struct mnt_idmap *idmap,
> @@ -562,6 +569,11 @@ static int bch2_rename2(struct mnt_idmap *idmap,
>  			 src_inode,
>  			 dst_inode);
>  
> +	ret   = bch2_subvol_is_ro_trans(trans, src_dir->ei_subvol) ?:
> +		bch2_subvol_is_ro_trans(trans, dst_dir->ei_subvol);
> +	if (ret)
> +		goto err;
> +
>  	if (inode_attr_changing(dst_dir, src_inode, Inode_opt_project)) {
>  		ret = bch2_fs_quota_transfer(c, src_inode,
>  					     dst_dir->ei_qid,
> @@ -783,11 +795,13 @@ static int bch2_setattr(struct mnt_idmap *idmap,
>  			struct dentry *dentry, struct iattr *iattr)
>  {
>  	struct bch_inode_info *inode = to_bch_ei(dentry->d_inode);
> +	struct bch_fs *c = inode->v.i_sb->s_fs_info;
>  	int ret;
>  
>  	lockdep_assert_held(&inode->v.i_rwsem);
>  
> -	ret = setattr_prepare(idmap, dentry, iattr);
> +	ret   = bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> +		setattr_prepare(idmap, dentry, iattr);
>  	if (ret)
>  		return ret;
>  
> @@ -1008,12 +1022,26 @@ static int bch2_vfs_readdir(struct file *file, struct dir_context *ctx)
>  	return bch2_err_class(ret);
>  }
>  
> +static int bch2_open(struct inode *vinode, struct file *file)
> +{
> +	if (file->f_flags & (O_WRONLY|O_RDWR)) {
> +		struct bch_inode_info *inode = to_bch_ei(vinode);
> +		struct bch_fs *c = inode->v.i_sb->s_fs_info;
> +
> +		int ret = bch2_subvol_is_ro(c, inode->ei_subvol);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return generic_file_open(vinode, file);
> +}
> +
>  static const struct file_operations bch_file_operations = {
> +	.open		= bch2_open,
>  	.llseek		= bch2_llseek,
>  	.read_iter	= bch2_read_iter,
>  	.write_iter	= bch2_write_iter,
>  	.mmap		= bch2_mmap,
> -	.open		= generic_file_open,
>  	.fsync		= bch2_fsync,
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
> diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
> index 9e7164c2363b..7c67c28d3ef8 100644
> --- a/fs/bcachefs/subvolume.c
> +++ b/fs/bcachefs/subvolume.c
> @@ -138,6 +138,24 @@ int bch2_subvolume_get(struct btree_trans *trans, unsigned subvol,
>  	return bch2_subvolume_get_inlined(trans, subvol, inconsistent_if_not_found, iter_flags, s);
>  }
>  
> +int bch2_subvol_is_ro_trans(struct btree_trans *trans, u32 subvol)
> +{
> +	struct bch_subvolume s;
> +	int ret = bch2_subvolume_get_inlined(trans, subvol, true, 0, &s);
> +	if (ret)
> +		return ret;
> +
> +	if (BCH_SUBVOLUME_RO(&s))
> +		return -EROFS;
> +	return 0;
> +}
> +
> +int bch2_subvol_is_ro(struct bch_fs *c, u32 subvol)
> +{
> +	return bch2_trans_do(c, NULL, NULL, 0,
> +		bch2_subvol_is_ro_trans(trans, subvol));
> +}
> +
>  int bch2_snapshot_get_subvol(struct btree_trans *trans, u32 snapshot,
>  			     struct bch_subvolume *subvol)
>  {
> diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
> index a1003d30ab0a..a6f56f66e27c 100644
> --- a/fs/bcachefs/subvolume.h
> +++ b/fs/bcachefs/subvolume.h
> @@ -23,6 +23,9 @@ int bch2_subvolume_get(struct btree_trans *, unsigned,
>  		       bool, int, struct bch_subvolume *);
>  int bch2_subvolume_get_snapshot(struct btree_trans *, u32, u32 *);
>  
> +int bch2_subvol_is_ro_trans(struct btree_trans *, u32);
> +int bch2_subvol_is_ro(struct bch_fs *, u32);
> +
>  int bch2_delete_dead_snapshots(struct bch_fs *);
>  void bch2_delete_dead_snapshots_async(struct bch_fs *);
>  
> diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> index 79d982674c18..5a1858fb9879 100644
> --- a/fs/bcachefs/xattr.c
> +++ b/fs/bcachefs/xattr.c
> @@ -176,7 +176,8 @@ int bch2_xattr_set(struct btree_trans *trans, subvol_inum inum,
>  	struct btree_iter inode_iter = { NULL };
>  	int ret;
>  
> -	ret = bch2_inode_peek(trans, &inode_iter, inode_u, inum, BTREE_ITER_INTENT);
> +	ret   = bch2_subvol_is_ro_trans(trans, inum.subvol) ?:
> +		bch2_inode_peek(trans, &inode_iter, inode_u, inum, BTREE_ITER_INTENT);
>  	if (ret)
>  		return ret;

Thanks,
Joey
