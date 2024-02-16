Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C8D4A0F
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 00:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708043186; cv=none; b=EDNAo9QsigEAfIpThn71EbuIT4ZUGZa2ZPnAL3SZoIfN2Tm7Gn8AiavJzll68OhU8mt8HbECI5fYnDFtARAg/nsrQlnyCK6P7T55o0qiJ8rDHxQ9wmiIbbF5zDXoUZpQTBSSd6DmuQQu/N3O6Qoq+BEmlNxzALIrhob2axv1r2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708043186; c=relaxed/simple;
	bh=P9KhkrDN1ohUbU4JmYog16/7nwWgLE1euarDkb88ILM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4q+s5BBqWBfp3h7pJxuajNzHzHErf3VLzS+htN7EbmAByQlqRevggp92ZS6WQ9w4FQrHGKwyKRnFnDxGrFoelkeGGpjpA2SbMw8nhesHQLiHU73t/uv8bwsv/0iYeBNKt+DgfPMOvpvv+ZH2wmitkMa2bfZTxuwrWvF7xQ1eho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J/BMhh1q; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J/BMhh1q"
Date: Thu, 15 Feb 2024 19:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708043182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ACHfg162jdW+x8Kh3tJ2zFM3ZOeG4l4aaTJrGWXrhV4=;
	b=J/BMhh1qxl7SlLnXMLIdyMMUBQ1Y/OxpWrc3Nm+xfYa8bBHEFIgbRUWnBPoEsTDdhp70qM
	eKB3eUAY2SkLQ94lFCH+JGl+Vhoep18eC5vyIGJo1zKYW7om8NHDdnpv3EFo5Swxu/NI0+
	ySUJsXhwZYmkXRKq+KTY5oT8NRQx5GM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Guoyu Ou <benogy@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3] bcachefs: skip invisible entries in empty subvolume
 checking
Message-ID: <w65bwhlqu6uakz63kmiz5uxp5pvifblcjdf6xyk72db4jgksss@oiichpxg52as>
References: <20240213082004.46076-1-benogy@gmail.com>
 <bkgmhj35rvon4e2gawwn5qepeitppss4kiharvetcl46q6x2pj@3c7jrrbtxco4>
 <ZcxlXyHP8evlVLUB@ousvr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcxlXyHP8evlVLUB@ousvr>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 03:03:15PM +0800, Guoyu Ou wrote:
> sorry for cc linux-bcachefs...
> 
> On Tue, Feb 13, 2024 at 09:38:39PM -0500, Kent Overstreet wrote:
> > On Tue, Feb 13, 2024 at 04:20:04PM +0800, Guoyu Ou wrote:
> > > When we are checking whether a subvolume is empty in the specified snapshot,
> > > entries that do not belong to this subvolume should be skipped.
> > > 
> > > This fixes the following case:
> > > 
> > >     $ bcachefs subvolume create ./sub
> > >     $ cd sub
> > >     $ bcachefs subvolume create ./sub2
> > >     $ bcachefs subvolume snapshot . ./snap
> > >     $ ls -a snap
> > >     . ..
> > >     $ rmdir snap
> > >     rmdir: failed to remove 'snap': Directory not empty
> > > 
> > > As Kent suggested, we pass 0 in may_delete_deleted_inode() to ignore subvols
> > > in the subvol we are checking, because inode.bi_subvol is only set on
> > > subvolume roots, and we can't go through every inode in the subvolume and
> > > change bi_subvol when taking a snapshot. It makes the check less strict, but
> > > that's ok, the rest of fsck will still catch it.
> > > 
> > > Signed-off-by: Guoyu Ou <benogy@gmail.com>
> > > ---
> > >  fs/bcachefs/dirent.c | 7 +++++--
> > >  fs/bcachefs/dirent.h | 2 +-
> > >  fs/bcachefs/inode.c  | 2 +-
> > >  3 files changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> > > index 4ae1e9f002a0..82c5bff01411 100644
> > > --- a/fs/bcachefs/dirent.c
> > > +++ b/fs/bcachefs/dirent.c
> > > @@ -508,7 +508,7 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
> > >  	return ret;
> > >  }
> > >  
> > > -int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
> > > +int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 subvol, u32 snapshot)
> > >  {
> > >  	struct btree_iter iter;
> > >  	struct bkey_s_c k;
> > > @@ -518,6 +518,9 @@ int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
> > >  			   SPOS(dir, 0, snapshot),
> > >  			   POS(dir, U64_MAX), 0, k, ret)
> > >  		if (k.k->type == KEY_TYPE_dirent) {
> > > +			struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
> > > +			if (d.v->d_type == DT_SUBVOL && le32_to_cpu(d.v->d_parent_subvol) != subvol)
> > > +				continue;
> > 
> > 
> > if (d.v->d_type == DT_SUBVOL && (le32_to_cpu(d.v->d_parent_subvol) != subvol || !subvol))
> 
> If 0 is an invalid value for subvolume ids, the predicate
> 
> le32_to_cpu(d.v->d_parent_subvol) != subvol
> 
> is always true for subvol == 0 and there's no need to add !subvol.

You're right, I think it was just late when I was staring at this the
first time.

> Otherwise, I think it's better to add a flag to indicate whether we are checking subvol in
> bch2_empty_dir_snapshot(), like
> 
> int bch2_empty_dir_snapshot(struct btree_trans *, u64 dir, u32 subvol, bool check_subvol, u32 snapshot)
> {
>     ...
>         if (d.v->d_type == DT_SUBVOL && (check_subvol && le32_to_cpu(d.v->d_parent_subvol) != subvol))
> }
> 
> or can we use a different helper function, rather than bch2_empty_dir_snapshot(), for may_delete_deleted_inode() ?

nah, let's not overcomplicate this - maybe I'll add a comment but
otherwise I'll just apply this - thanks

> 
> > 
> > >  			ret = -ENOTEMPTY;
> > >  			break;
> > >  		}
> > > @@ -531,7 +534,7 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
> > >  	u32 snapshot;
> > >  
> > >  	return bch2_subvolume_get_snapshot(trans, dir.subvol, &snapshot) ?:
> > > -		bch2_empty_dir_snapshot(trans, dir.inum, snapshot);
> > > +		bch2_empty_dir_snapshot(trans, dir.inum, dir.subvol, snapshot);
> > >  }
> > >  
> > >  int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
> > > diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
> > > index 21ffeb78f02e..aeb8207ca9f2 100644
> > > --- a/fs/bcachefs/dirent.h
> > > +++ b/fs/bcachefs/dirent.h
> > > @@ -69,7 +69,7 @@ u64 bch2_dirent_lookup(struct bch_fs *, subvol_inum,
> > >  		       const struct bch_hash_info *,
> > >  		       const struct qstr *, subvol_inum *);
> > >  
> > > -int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32);
> > > +int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32, u32);
> > >  int bch2_empty_dir_trans(struct btree_trans *, subvol_inum);
> > >  int bch2_readdir(struct bch_fs *, subvol_inum, struct dir_context *);
> > >  
> > > diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
> > > index 086f0090b03a..84a6e5011032 100644
> > > --- a/fs/bcachefs/inode.c
> > > +++ b/fs/bcachefs/inode.c
> > > @@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
> > >  		goto out;
> > >  
> > >  	if (S_ISDIR(inode.bi_mode)) {
> > > -		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
> > > +		ret = bch2_empty_dir_snapshot(trans, pos.offset, 0, pos.snapshot);
> > >  		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
> > >  				"non empty directory %llu:%u in deleted_inodes btree",
> > >  				pos.offset, pos.snapshot))
> > > -- 
> > > 2.43.0
> > > 
