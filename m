Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BEBEEB1
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Dec 2024 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733793441; cv=none; b=drxc4zgm2gKXf1EvvWNg3P0KTioTA4TV/oTNSVrfgMd0Hff7xUAIKHWTsGcIeO8XnDA20myfVrCGj7odd0EZUwEFNxGWgvR/6eOqGxV18DUg2aGzMLpj+eccwX6k9ePocy3OROvS0jRjDDxQI9oyuwXh+vDHyuUH1Ru9fAjugIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733793441; c=relaxed/simple;
	bh=bkbJNe5QX8CgWjdJs6Kbqzb1GrEtEKYV50q+QAleIz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZr3YsiPH/w3B21qKX3vmLzP2uyiinU7KbUN6seP9R34WE8SHnvscyF0HJcBzhD/R2WU97rjEzYhJVBsvqcpllHFR10q3fHcfJJgQztuhS6UfJVBMhm8eC6F9sr9oCUn2S1vmCFFILYzDOPUGqz4liW6doZUq9GlCHGViHh5wxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zkw35rmE; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zkw35rmE"
Date: Mon, 9 Dec 2024 20:17:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733793436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O80VUglrmuDUVIPfADZzZtivOv4F1pLrJu50O44hVU0=;
	b=Zkw35rmE1OIvF5BtEy4DvshYYiII5ihnLF8TFWdXLzghREN8puMDYPIzyMrMRZfqGjArKk
	qbGn+OZYWVqpuWpc/Scdl9rSAA/ekQtGVtv4IKIpPqei+7kKNB9Smw9I4P12vd+cpHCVv1
	4LbkPADbia31+mc7CAk2lmSIomc9Xqc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "integral@archlinuxcn.org" <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: use strscpy & strscpy_pad to make string
 copying simpler & safer
Message-ID: <okjlnanwuectw4fem6o3x7mheur7ob6nvkxm26rvhw7xxawx5v@n6qix4k2w5kp>
References: <20241110064138.79527-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110064138.79527-1-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 10, 2024 at 02:41:38PM +0800, integral@archlinuxcn.org wrote:
> Use safe string copying macros (strscpy & strscpy_pad) to make string
> copying simpler & safer.
> 
> Signed-off-by: integral@archlinuxcn.org <integral@archlinuxcn.org>

No!

You're introducing nuls where there previously weren't any, and since
there are strict checks on how many padding nuls are allowed this is
broken.

I already told you this didn't need to be done; please stop.

> ---
>  fs/bcachefs/dirent.c      | 10 +++-------
>  fs/bcachefs/disk_groups.c |  5 ++---
>  fs/bcachefs/fs-ioctl.c    | 17 ++++++++---------
>  fs/bcachefs/fs.c          |  6 +-----
>  4 files changed, 14 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> index 4c22f78b0484..466fe5765739 100644
> --- a/fs/bcachefs/dirent.c
> +++ b/fs/bcachefs/dirent.c
> @@ -191,13 +191,9 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
>  
>  	dirent->v.d_type = type;
>  
> -	memcpy(dirent->v.d_name, name->name, name->len);
> -	memset(dirent->v.d_name + name->len, 0,
> -	       bkey_val_bytes(&dirent->k) -
> -	       offsetof(struct bch_dirent, d_name) -
> -	       name->len);
> -
> -	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
> +	EBUG_ON(strscpy_pad(dirent->v.d_name, name->name,
> +			    bkey_val_bytes(&dirent->k) - offsetof(struct bch_dirent, d_name))
> +		!= name->len);
>  
>  	return dirent;
>  }
> diff --git a/fs/bcachefs/disk_groups.c b/fs/bcachefs/disk_groups.c
> index 5df8de0b8c02..c2fc575e38d1 100644
> --- a/fs/bcachefs/disk_groups.c
> +++ b/fs/bcachefs/disk_groups.c
> @@ -319,9 +319,8 @@ static int __bch2_disk_group_add(struct bch_sb_handle *sb, unsigned parent,
>  
>  	g = &groups->entries[i];
>  
> -	memcpy(g->label, name, namelen);
> -	if (namelen < sizeof(g->label))
> -		g->label[namelen] = '\0';
> +	strscpy(g->label, name, namelen);
> +
>  	SET_BCH_GROUP_DELETED(g, 0);
>  	SET_BCH_GROUP_PARENT(g, parent);
>  	SET_BCH_GROUP_DATA_ALLOWED(g, ~0);
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index 15725b4ce393..4233707bec9d 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -279,26 +279,25 @@ static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
>  
>  static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
>  {
> -	int ret;
> -	size_t len;
>  	char label[BCH_SB_LABEL_SIZE];
> +	size_t len;
>  
>  	BUILD_BUG_ON(BCH_SB_LABEL_SIZE >= FSLABEL_MAX);
>  
>  	mutex_lock(&c->sb_lock);
> -	memcpy(label, c->disk_sb.sb->label, BCH_SB_LABEL_SIZE);
> +	int ret = strscpy(label, c->disk_sb.sb->label, BCH_SB_LABEL_SIZE);
>  	mutex_unlock(&c->sb_lock);
>  
> -	len = strnlen(label, BCH_SB_LABEL_SIZE);
> -	if (len == BCH_SB_LABEL_SIZE) {
> +	if (ret == -E2BIG) {
> +		len = BCH_SB_LABEL_SIZE - 1;
>  		bch_warn(c,
>  			"label is too long, return the first %zu bytes",
> -			--len);
> +			len);
> +	} else {
> +		len = ret;
>  	}
>  
> -	ret = copy_to_user(user_label, label, len);
> -
> -	return ret ? -EFAULT : 0;
> +	return copy_to_user(user_label, label, len) ? -EFAULT : 0;
>  }
>  
>  static int bch2_ioc_setlabel(struct bch_fs *c,
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 91fce04272a1..be86a36e8cfe 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1641,7 +1641,6 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
>  	subvol_inum target;
>  	u32 snapshot;
>  	struct qstr dirent_name;
> -	unsigned name_len = 0;
>  	int ret;
>  
>  	if (!S_ISDIR(dir->v.i_mode))
> @@ -1717,10 +1716,7 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
>  	goto err;
>  found:
>  	dirent_name = bch2_dirent_get_name(d);
> -
> -	name_len = min_t(unsigned, dirent_name.len, NAME_MAX);
> -	memcpy(name, dirent_name.name, name_len);
> -	name[name_len] = '\0';
> +	strscpy(name, dirent_name.name, NAME_MAX);
>  err:
>  	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
>  		goto retry;
> -- 
> 2.47.0
> 
