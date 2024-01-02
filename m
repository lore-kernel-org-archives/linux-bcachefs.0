Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B77314A9A
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Jan 2024 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rCeVdf1+"
Date: Tue, 2 Jan 2024 10:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704211165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lP7mSk3Qvihir4BFOTD7brqhLvx7VKJEPTNj8uSx69A=;
	b=rCeVdf1+4p30D3rT9gZ3PjvX8ggfNd+ZjlRvFyIb1Pfy1uXVIBFLvZtC9/JTF1OcmBLNRd
	ZeB6JKSEEPGRrcN+CqtMY2IWIaMgojbiQnWfgr7U/61g37d/e9jogkNDgJlmxgVZ+kqlh+
	BkzX2NBlDvxqOSANcWbYgdBmcngM6OA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: make RO snapshots actually RO
Message-ID: <gsutet5eavxirguinw6pfvbpnfdgl3d6m5oqoorwh7zgnmrwhq@el5tle57tnis>
References: <20231230195802.2220651-1-kent.overstreet@linux.dev>
 <20240102142804.GA1028907@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240102142804.GA1028907@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 02, 2024 at 02:28:04PM +0000, Joey Gouly wrote:
> Hi Kent,
> 
> On Sat, Dec 30, 2023 at 02:58:02PM -0500, Kent Overstreet wrote:
> > Add checks to all the VFS paths for "are we in a RO snapshot?".
> > 
> > Note - we don't check this when setting inode options via our xattr
> > interface, since those generally only affect data placement, not
> > contents of data.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  fs/bcachefs/acl.c       |  3 ++-
> >  fs/bcachefs/fs-ioctl.c  | 12 +++++-------
> >  fs/bcachefs/fs.c        | 38 +++++++++++++++++++++++++++++++++-----
> >  fs/bcachefs/subvolume.c | 18 ++++++++++++++++++
> >  fs/bcachefs/subvolume.h |  3 +++
> >  fs/bcachefs/xattr.c     |  3 ++-
> >  6 files changed, 63 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/bcachefs/acl.c b/fs/bcachefs/acl.c
> > index f3809897f00a..a9f3b0817b41 100644
> > --- a/fs/bcachefs/acl.c
> > +++ b/fs/bcachefs/acl.c
> > @@ -366,7 +366,8 @@ int bch2_set_acl(struct mnt_idmap *idmap,
> >  	bch2_trans_begin(trans);
> >  	acl = _acl;
> >  
> > -	ret = bch2_inode_peek(trans, &inode_iter, &inode_u, inode_inum(inode),
> > +	ret   = bch2_subvol_is_ro_trans(trans, inode->ei_subvol);
> > +		bch2_inode_peek(trans, &inode_iter, &inode_u, inode_inum(inode),
> >  			      BTREE_ITER_INTENT);
> 
> Looks like this is throwing away the return value of `bch2_inode_peek`, because
> the previous line ends in ';' but it should end in '?:' to match other changes
> in this commit?
> 
> >  	if (ret)
> >  		goto btree_err;
> > diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> > index 8098a3a299d1..e0a19a73c8e1 100644
> > --- a/fs/bcachefs/fs-ioctl.c
> > +++ b/fs/bcachefs/fs-ioctl.c
> > @@ -100,7 +100,8 @@ static int bch2_ioc_setflags(struct bch_fs *c,
> >  	}
> >  
> >  	mutex_lock(&inode->ei_update_lock);
> > -	ret = bch2_write_inode(c, inode, bch2_inode_flags_set, &s,
> > +	ret   = bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> > +		bch2_write_inode(c, inode, bch2_inode_flags_set, &s,
> >  			       ATTR_CTIME);
> >  	mutex_unlock(&inode->ei_update_lock);
> >  
> > @@ -183,13 +184,10 @@ static int bch2_ioc_fssetxattr(struct bch_fs *c,
> >  	}
> >  
> >  	mutex_lock(&inode->ei_update_lock);
> > -	ret = bch2_set_projid(c, inode, fa.fsx_projid);
> > -	if (ret)
> > -		goto err_unlock;
> > -
> > -	ret = bch2_write_inode(c, inode, fssetxattr_inode_update_fn, &s,
> > +	ret   = bch2_subvol_is_ro(c, inode->ei_subvol) ?:
> > +		bch2_set_projid(c, inode, fa.fsx_projid) ?:
> > +		bch2_write_inode(c, inode, fssetxattr_inode_update_fn, &s,
> >  			       ATTR_CTIME);
> > -err_unlock:
> >  	mutex_unlock(&inode->ei_update_lock);
> >  err:
> >  	inode_unlock(&inode->v);
> > diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> > index 34cb22a9c05d..0e1d709100bb 100644
> > --- a/fs/bcachefs/fs.c
> > +++ b/fs/bcachefs/fs.c
> > @@ -258,7 +258,8 @@ __bch2_create(struct mnt_idmap *idmap,
> >  retry:
> >  	bch2_trans_begin(trans);
> >  
> > -	ret   = bch2_create_trans(trans,
> > +	ret   = bch2_subvol_is_ro_trans(trans, dir->ei_subvol);
> > +		bch2_create_trans(trans,
> >  				  inode_inum(dir), &dir_u, &inode_u,
> >  				  !(flags & BCH_CREATE_TMPFILE)
> >  				  ? &dentry->d_name : NULL,
> 
> Same again.

yup, they were fortunately spotted before the pull request went out
