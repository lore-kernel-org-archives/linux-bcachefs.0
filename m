Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB42EFC0A
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706494916; cv=none; b=ipuCP1mOnUCci1mMsBn13gBpqyjdrexDheQODqGVV5f0dRVptL7a0JDOqO+8ZpssvySQMSoqhGWlZnFpxidb+aSjb90ADXGRTWkpY/hZIvDzTeiSKrDHNgO52JdYj/6NMSi9nns77XeQe9zRegsPTdHQXq9VbaFejFz3qNin5V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706494916; c=relaxed/simple;
	bh=A3hHoeuUV+v3ieyRaTZC3c1LcreHQzHjv2fX1bkDwgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNjylKWmpUh3GiIswm2DlM/5+BHqx2VCHkmP7y2RQ4Al6MhfkV0pwYShw31/d6SLbFUABjesKrsGblUMVW1owg2F9vD3CoOSZKCe1yaA9m8+9AyO797OdwWss9YgKvym6rr5ap9EMjJ8pCINX7pP3Whe3175JHRDlTBHR1st/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MZq2529m; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MZq2529m"
Date: Sun, 28 Jan 2024 21:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706494911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n2HlxoIFJdB4zrbSkQyH0qaPCWC9z0G2npoEI78+LOs=;
	b=MZq2529msswWwlQ+rkIVMmwVVloDS5y/eTgqtOlt5dfkt2b+mlJsYJ0L7dBiQZbgq0tXG7
	QiFC6eIgiZArCM+97N0UPH+RtAX7GJfzyM8nJexd6nxKE7e9sZQxWLPycg3W1v2cF8hCQj
	+SAk9BvxPkNzNPmgh5tN1axjKR927YY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Guoyu Ou <benogy@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: unlock parent dir if entry is not found in
 subvolume deletion
Message-ID: <ihz24ycxt7vipgup5din2y4oz74ndekkgwuyckuxnibm5bnyat@t7lggqpno26l>
References: <20240128084617.244234-1-benogy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240128084617.244234-1-benogy@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 28, 2024 at 04:46:17PM +0800, Guoyu Ou wrote:
> Parent dir is locked by user_path_locked_at() before validating the
> required dentry. It should be unlocked if we can not perform the
> deletion.
> 
> This fixes the problem:
> 
> $ bcachefs subvolume delete not-exist-entry
> BCH_IOCTL_SUBVOLUME_DESTROY ioctl error: No such file or directory
> $ bcachefs subvolume delete not-exist-entry
> 
> the second will stuck because the parent dir is locked in the previous
> deletion.

Your fix works, but having user_path_locked_at() return an object that
we have a destructor for but needs extra cleanup is not ideal, and now
that I look I'm also wondering why the dput(victim) is necessary when
path_put() also does a dput().

How do we feel about the following?

Note that my fix is incomplete (and untested); path needs to be zeroed
out everywhere it's constructed.

diff --git a/fs/namei.c b/fs/namei.c
index 4e0de939fea1..d3ef21e529b2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -559,6 +559,8 @@ EXPORT_SYMBOL(path_get);
  */
 void path_put(const struct path *path)
 {
+	if (path->locked)
+		inode_unlock(d_inode(path.dentry));
 	dput(path->dentry);
 	mntput(path->mnt);
 }
@@ -2578,6 +2580,8 @@ static struct dentry *__kern_path_locked(int dfd, struct filename *name, struct
 	struct qstr last;
 	int type, error;
 
+	memset(path, 0, sizeof(*path));
+
 	error = filename_parentat(dfd, name, 0, path, &last, &type);
 	if (error)
 		return ERR_PTR(error);
@@ -2586,11 +2590,10 @@ static struct dentry *__kern_path_locked(int dfd, struct filename *name, struct
 		return ERR_PTR(-EINVAL);
 	}
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
+	path->locked = true;
 	d = lookup_one_qstr_excl(&last, path->dentry, 0);
-	if (IS_ERR(d)) {
-		inode_unlock(path->dentry->d_inode);
+	if (IS_ERR(d))
 		path_put(path);
-	}
 	return d;
 }
 
diff --git a/include/linux/path.h b/include/linux/path.h
index 475225a03d0d..bfa489996aeb 100644
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -8,6 +8,7 @@ struct vfsmount;
 struct path {
 	struct vfsmount *mnt;
 	struct dentry *dentry;
+	bool locked;
 } __randomize_layout;
 
 extern void path_get(const struct path *);



> 
> Signed-off-by: Guoyu Ou <benogy@gmail.com>
> ---
>  fs/bcachefs/fs-ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index 3a4c24c28e7f..3dc8630ff9fe 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -455,6 +455,7 @@ static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
>  	if (IS_ERR(victim))
>  		return PTR_ERR(victim);
>  
> +	dir = d_inode(path.dentry);
>  	if (victim->d_sb->s_fs_info != c) {
>  		ret = -EXDEV;
>  		goto err;
> @@ -463,14 +464,13 @@ static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
>  		ret = -ENOENT;
>  		goto err;
>  	}
> -	dir = d_inode(path.dentry);
>  	ret = __bch2_unlink(dir, victim, true);
>  	if (!ret) {
>  		fsnotify_rmdir(dir, victim);
>  		d_delete(victim);
>  	}
> -	inode_unlock(dir);
>  err:
> +	inode_unlock(dir);
>  	dput(victim);
>  	path_put(&path);
>  	return ret;
> -- 
> 2.43.0
> 
