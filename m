Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0738C
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Feb 2024 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707894207; cv=none; b=C2VgCaTUMrT2fNDrwQ/UBFmD2atslidEwPBCvEBb4eL81lG+sjztPcswbuudWf8KxnPs2Mb35lsA90otL5VhQpOVkPciJiZsa/Ir5C+5a+mn/7aLZ7Dqx+h0Xr5Xp5k6ezaKkW+yXiNGichjRYeeEz3UWIgbmZuKNXwiNgVxJ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707894207; c=relaxed/simple;
	bh=Y0XdkCliAizP+k1qtfw5MGVTw06K+Y9zkqXWTZsOphg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSeXXuEsdioxP+M73y2rzC/g1INbeWM111JwIa1cgBtEHhQLKY6hh8Ih+BubiNmC4/RHgADYkqeqxXdAnf6D9psWfoLlRStb5qwIqbHiAHj75/tvZe3DG4C55UbCh1vXIn7RvQHm+MY6cakGMxZnUEA2TU55jE1XzUnZhlOUa3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2CdKpzL; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2CdKpzL"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e104a8e3f7so620557b3a.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 23:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707894205; x=1708499005; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou0GgzaeLfUTQILbSfTOdbpQvzcLLdhqpXzSWk0eOAI=;
        b=K2CdKpzLrAbcgTp7FTuM8gpoNfIYoWJvpUJUr64QVCpnlLCsIU6/99eFzmoTYT7oZ2
         nq4A/q795iLNt6H7Ggls0CK7/HmkzR5x88Nac4TcG6/PzDHpVwG/MCE1td3hcWSwonQV
         H/eYGHQQ0uN0ne0OCXWRIW92obWvpa/0G8/sA7sOzx3iC39z4q6MZ4nyxg7CP789MJiJ
         7WwLkQAMQR/9Yxh2yC7Mu7Kjaaau8OUgBCmvZI2OQlU/lvX9pwZySCmqN8isgKF7JD5n
         ZE+sXqTMjsUnxgwKgV7/XzHXRQhmMl3BnODT6qd4x6W6N7ozMwly4FKMSMInFrH6UmJE
         AIcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707894205; x=1708499005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ou0GgzaeLfUTQILbSfTOdbpQvzcLLdhqpXzSWk0eOAI=;
        b=hnWHISIqy8WIO4Lbu9oH0HAgJjmUG1P3HZSZSEDER8I3PZARM7ze1yl6MYI3JMsZfM
         zpLXc2T4urRJ/DXmXZVpa60R/0m0QCP1bs8mllD/kVoeC1w3RIHZox8jJ/omV0rqlGo3
         rOoxF1UELDVKt87+Awnu5agLjc4F1IthAXH4ocqn6fUW2qA1++1hPd0hHFNPQanqv+mV
         OnhME7QCsZAKcsDEf3VkWjhKSX8B2AxEeSXf4Ck+mkKchegWfTTDdfaYwXq2B8IMQd7n
         if7WhJybAUk/PVCohZVz+YTPuroWDrUhwHsaf4s/b4GujxXHei12tFDn12+lbLkhkF6k
         E2cg==
X-Gm-Message-State: AOJu0YyUU6w8QE4HSJ9ocbrEkQYoHAs//7KBDyvCOg/L8/rtZ6/kb1h6
	Q97f20RNt3i7KSigxFrtzN9QHNH79Zuou/FruiANd4LCXkI6KtsWcZtXPkh+JmDD5Oiq
X-Google-Smtp-Source: AGHT+IHJ5dc/ad+62ke6x822b1hoXtlh7DU4ukeL+br4ZTHzat8eIsDwxIQ/YhCxtmLJyDRmYN8B0A==
X-Received: by 2002:a05:6a20:c88d:b0:19e:a873:9253 with SMTP id hb13-20020a056a20c88d00b0019ea8739253mr2167357pzb.10.1707894204747;
        Tue, 13 Feb 2024 23:03:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV9jupLK2uutyZQXGv3cOfayBG88sY3yyM81m+uu5tdLfAI+NHyf+pGmuufakaNQGNsdp0cWmHyWxRbEyPt8tAY
Received: from localhost ([8.218.212.108])
        by smtp.gmail.com with ESMTPSA id fa3-20020a056a002d0300b006d9a38fe569sm8465892pfb.89.2024.02.13.23.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 23:03:24 -0800 (PST)
Date: Wed, 14 Feb 2024 15:03:15 +0800
From: Guoyu Ou <benogy@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, benogy@gmail.com
Subject: Re: [PATCH v3] bcachefs: skip invisible entries in empty subvolume
 checking
Message-ID: <ZcxlXyHP8evlVLUB@ousvr>
References: <20240213082004.46076-1-benogy@gmail.com>
 <bkgmhj35rvon4e2gawwn5qepeitppss4kiharvetcl46q6x2pj@3c7jrrbtxco4>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bkgmhj35rvon4e2gawwn5qepeitppss4kiharvetcl46q6x2pj@3c7jrrbtxco4>

sorry for cc linux-bcachefs...

On Tue, Feb 13, 2024 at 09:38:39PM -0500, Kent Overstreet wrote:
> On Tue, Feb 13, 2024 at 04:20:04PM +0800, Guoyu Ou wrote:
> > When we are checking whether a subvolume is empty in the specified snapshot,
> > entries that do not belong to this subvolume should be skipped.
> > 
> > This fixes the following case:
> > 
> >     $ bcachefs subvolume create ./sub
> >     $ cd sub
> >     $ bcachefs subvolume create ./sub2
> >     $ bcachefs subvolume snapshot . ./snap
> >     $ ls -a snap
> >     . ..
> >     $ rmdir snap
> >     rmdir: failed to remove 'snap': Directory not empty
> > 
> > As Kent suggested, we pass 0 in may_delete_deleted_inode() to ignore subvols
> > in the subvol we are checking, because inode.bi_subvol is only set on
> > subvolume roots, and we can't go through every inode in the subvolume and
> > change bi_subvol when taking a snapshot. It makes the check less strict, but
> > that's ok, the rest of fsck will still catch it.
> > 
> > Signed-off-by: Guoyu Ou <benogy@gmail.com>
> > ---
> >  fs/bcachefs/dirent.c | 7 +++++--
> >  fs/bcachefs/dirent.h | 2 +-
> >  fs/bcachefs/inode.c  | 2 +-
> >  3 files changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
> > index 4ae1e9f002a0..82c5bff01411 100644
> > --- a/fs/bcachefs/dirent.c
> > +++ b/fs/bcachefs/dirent.c
> > @@ -508,7 +508,7 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
> >  	return ret;
> >  }
> >  
> > -int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
> > +int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 subvol, u32 snapshot)
> >  {
> >  	struct btree_iter iter;
> >  	struct bkey_s_c k;
> > @@ -518,6 +518,9 @@ int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
> >  			   SPOS(dir, 0, snapshot),
> >  			   POS(dir, U64_MAX), 0, k, ret)
> >  		if (k.k->type == KEY_TYPE_dirent) {
> > +			struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
> > +			if (d.v->d_type == DT_SUBVOL && le32_to_cpu(d.v->d_parent_subvol) != subvol)
> > +				continue;
> 
> 
> if (d.v->d_type == DT_SUBVOL && (le32_to_cpu(d.v->d_parent_subvol) != subvol || !subvol))

If 0 is an invalid value for subvolume ids, the predicate

le32_to_cpu(d.v->d_parent_subvol) != subvol

is always true for subvol == 0 and there's no need to add !subvol.

Otherwise, I think it's better to add a flag to indicate whether we are checking subvol in
bch2_empty_dir_snapshot(), like

int bch2_empty_dir_snapshot(struct btree_trans *, u64 dir, u32 subvol, bool check_subvol, u32 snapshot)
{
    ...
        if (d.v->d_type == DT_SUBVOL && (check_subvol && le32_to_cpu(d.v->d_parent_subvol) != subvol))
}

or can we use a different helper function, rather than bch2_empty_dir_snapshot(), for may_delete_deleted_inode() ?

> 
> >  			ret = -ENOTEMPTY;
> >  			break;
> >  		}
> > @@ -531,7 +534,7 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
> >  	u32 snapshot;
> >  
> >  	return bch2_subvolume_get_snapshot(trans, dir.subvol, &snapshot) ?:
> > -		bch2_empty_dir_snapshot(trans, dir.inum, snapshot);
> > +		bch2_empty_dir_snapshot(trans, dir.inum, dir.subvol, snapshot);
> >  }
> >  
> >  int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
> > diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
> > index 21ffeb78f02e..aeb8207ca9f2 100644
> > --- a/fs/bcachefs/dirent.h
> > +++ b/fs/bcachefs/dirent.h
> > @@ -69,7 +69,7 @@ u64 bch2_dirent_lookup(struct bch_fs *, subvol_inum,
> >  		       const struct bch_hash_info *,
> >  		       const struct qstr *, subvol_inum *);
> >  
> > -int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32);
> > +int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32, u32);
> >  int bch2_empty_dir_trans(struct btree_trans *, subvol_inum);
> >  int bch2_readdir(struct bch_fs *, subvol_inum, struct dir_context *);
> >  
> > diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
> > index 086f0090b03a..84a6e5011032 100644
> > --- a/fs/bcachefs/inode.c
> > +++ b/fs/bcachefs/inode.c
> > @@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
> >  		goto out;
> >  
> >  	if (S_ISDIR(inode.bi_mode)) {
> > -		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
> > +		ret = bch2_empty_dir_snapshot(trans, pos.offset, 0, pos.snapshot);
> >  		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
> >  				"non empty directory %llu:%u in deleted_inodes btree",
> >  				pos.offset, pos.snapshot))
> > -- 
> > 2.43.0
> > 
