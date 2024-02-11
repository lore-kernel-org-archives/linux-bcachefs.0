Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433A45943
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Feb 2024 07:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707637765; cv=none; b=K1Ac/UeNJKY9i/C/Yah0hO6R15eXEMnrG9DZtkzAsqAJH/4AFl8eH5lHQA7wBqcsLMVbxPahFrWRywHn8N8vcbTrXpDxTuvpLAXDNJaCfTlSdDt+fM22gs9jh2Do/S46SkrVMX8BjCJWKwcXNBPOvI5F41dOjMWdPBj6fRPGJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707637765; c=relaxed/simple;
	bh=bM/TfFysbOxkFXDv4D2sHV/aDBPM16yXlvHamm7KZs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8SWDawu03okXq4KS4mafzn1A4cc2jPNtLMONVF45ShfjLvRfpGDFwbZ2dwwzZ5U0H6YdrYtsS6IYCXi4QmMQ5YoO0qmFeu1wIH0lvgRp+Rfn6AbrDu86oRJ2bkxunXIduwEFSm7HzpKVHcFpuECbQcQK/MAVqA7wkAT2jKvyBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlZwCA/h; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlZwCA/h"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e0d085cf59so247130b3a.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Feb 2024 23:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707637763; x=1708242563; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2h+WInkeWrlqjbssn9ZKBKtNDG3gZESz0Lxa7i10OP0=;
        b=SlZwCA/hqq/Emj+zd3ZBor+0bcSPIlWr2EJlFBBrluCsq1ISgSiprItfl+54bwhuGq
         zkLj4vb675Y7qLJRWZku/yHRRjrC+yIk/aJIsb+KIy3Y9ngjLGmA5pny4wMrRKPHQdUn
         qfKyWgalRFQMvVfUAeW3Cexk9CHtJpzRbIxO624bjwbJHaAaaxlBJaWn9HN7TyutPzVe
         aXR3BRSF1QipVHtKH00ojOABjdhdgqrSZGXk4osqVw4Wn7fP1pJHV65a2/nbbZxnS1gx
         04L5y38dLBczU9FMZNh0F8+VupgLT09CMvHzHovMXzoHdIe41qVIPwWXQZIWhSSvvq60
         v50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707637763; x=1708242563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2h+WInkeWrlqjbssn9ZKBKtNDG3gZESz0Lxa7i10OP0=;
        b=B8lQ9gKnvQzrLzJa6wVNSqdcsCBokQxx7DGb/e7az9ZgRJ3oj/JQF0u5puXfnmoJPC
         AMPS1HxNFl2W9tAGWSJIX/pyCvtHI1stpGxQTZg13ndGSlWYYuAE21bRF4v4CJpeNwQi
         Bl4RG2069+aocHXW2wTmeEcDqsMuqjSq6SFQ0eoW+ZtAOLJaI8SeWErVin7qHcYzbzlE
         0xUkr4NJ+ogv8gCUPCIms36oP9sqURLyhiaaXlgKT7nvHNfS9dO5b4NrX1WDAGKkPGzz
         V8nwM5EdgM/YKlLHdcEPuwsJ+RwUr3g+djVguoArmLoUOAh7nWppR0+0YyOg1NVMpeYe
         IEGg==
X-Gm-Message-State: AOJu0YxW31doG+kOQanqvaLEQwwNtn+Uv0zrqk359+uz/gmWLA1ww7Jb
	P+khD6NU0Lz0QCMv6zsvotvcNHhiden04SurusOvjYzmJB63WbUfoTciYo6Y2zGJXt+W
X-Google-Smtp-Source: AGHT+IEeGoCAVeMQqed7XpRFS1+ko9fIGmimxHxiSFDHQpOUMF6jMQIblBK5Y/0wMgAvMm/Q7XkS/g==
X-Received: by 2002:a05:6a00:2fc3:b0:6de:5e6:8ade with SMTP id fn3-20020a056a002fc300b006de05e68ademr3623942pfb.24.1707637763509;
        Sat, 10 Feb 2024 23:49:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNiRKl6ZWZqtjwg2w7cOYkoloo0GvYKIJfjROCcXwPCg/KahdUf8rixmcVu4LbIl99VNaPFt3XK01KrGh6Eyx5
Received: from localhost ([8.218.212.108])
        by smtp.gmail.com with ESMTPSA id z5-20020a62d105000000b006e04e58f216sm3478609pfg.137.2024.02.10.23.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Feb 2024 23:49:23 -0800 (PST)
Date: Sun, 11 Feb 2024 15:49:17 +0800
From: Guoyu Ou <benogy@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, benogy@gmail.com
Subject: Re: [PATCH] bcachefs: skip invisible entries in empty subvolume
 checking
Message-ID: <Zch7_Q9jpu79J2Z6@ousvr>
References: <20240210140637.87092-1-benogy@gmail.com>
 <3skajn5gtyfbxu2zivet2kpq62i2nwcidzzfe5jk6ovi57esa5@vnbgwdz5ypk7>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3skajn5gtyfbxu2zivet2kpq62i2nwcidzzfe5jk6ovi57esa5@vnbgwdz5ypk7>

On Sat, Feb 10, 2024 at 05:56:15PM -0500, Kent Overstreet wrote:
> On Sat, Feb 10, 2024 at 10:06:37PM +0800, Guoyu Ou wrote:
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
> > Signed-off-by: Guoyu Ou <benogy@gmail.com>
>
> So that's an interesting corner case - can you add a ktest test for it?
> https://evilpiepirate.org/git/ktest.git/
>
> If you're not using it yet, please jump on IRC and ask if you run into
> any issues getting it going;
>
> There's an issue with your fix: in may_delete_deleted_inode(), you're
> getting the subvol from inode.bi_subvol.
>
> That's incorrect, because bi_subvol is only set on subvolume roots,
> because we can't go through every inode in the subvolume and change
> bi_subvol when taking a snapshot.
>
> You're doing it right in bch2_empty_dir_trans(), which is the path that
> matters more; may_delete_deleted_inode() is only checking "did this
> filesystem get borked".
>
> I would just pass in 0 from may_delete_deleted_inode(), and then have
> empty_dir_snapshot() ignore DT_SUBVOL dirents when subvol == 0. It makes
> the check less strict, but that's ok, the rest of fsck will still catch
> it.

Got it. I will add a new test case and update this patch later.

>
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
> > index 086f0090b03a..8f85d0132cc2 100644
> > --- a/fs/bcachefs/inode.c
> > +++ b/fs/bcachefs/inode.c
> > @@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
> >  		goto out;
> >
> >  	if (S_ISDIR(inode.bi_mode)) {
> > -		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
> > +		ret = bch2_empty_dir_snapshot(trans, pos.offset, inode.bi_subvol, pos.snapshot);
> >  		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
> >  				"non empty directory %llu:%u in deleted_inodes btree",
> >  				pos.offset, pos.snapshot))
> > --
> > 2.43.0
> >
