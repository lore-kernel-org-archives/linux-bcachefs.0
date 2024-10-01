Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1C19ABC3
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Oct 2024 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727819076; cv=none; b=Gwc833pyoKMcB8z2kxrGK9aPBXQR7t0kSGEJv2umxALppcbu5yPOICY5Kq/FfOjI3nOrPJBJOZmVzYfh3aYLiPaGZ8he3QKJAY/I+X1ink2nH64Id9KfuXSzJZakB+ceGmbYR+Dzi5njO+IjntOtZt35lyyMoyxV4UjIzlVTUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727819076; c=relaxed/simple;
	bh=dsjUD1VJV0y4eQ2Lt8bPXZYGGRS2Pi6aVOcRWav+mdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sh5ECXAfeHqg/xqTvneYjimC5bOrqHYmrfEEywhhumdHGFS2SCJV8Imjzu0EyupfrcW9F0E0dYlKPiStDOidNOv7n/8c1hNHEivIXgc7KfQFkZq/R6RmVJijOjOEwT8bUmoifSzjYbOtCsAJSoToUYYrm+g+bWG/ooKZsCPTViE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zf3vPyeH; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zf3vPyeH"
Date: Tue, 1 Oct 2024 17:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727819071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0id0PyIFpJ9sUWilf6k5bBY4kR0lcP6zF5JucLA/h7M=;
	b=Zf3vPyeHZttcsXXJ9jC2Pep5E9yGggIJS2EirfGsBTkxZAT3YA4nh2MZjOjtPqZLtu9HPV
	ha5NcNAJV78Jq751iwuCxM/1QQaCv/PXf7Ofi+xHafNrGrsG62qjXc1Ad3iEbVI+/S3D3A
	GNfHPk2W1fotvjmvxGLxt9fQdZThCKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: dirent_points_to_inode() now warns on
 mismatch
Message-ID: <l3zvg3xpwfnh4qzoyifv3o2s66qyot3elfv2vgt2arlfagnv3a@apedd44qzsq7>
References: <9a704bd8-d227-4663-b160-7265bc31e507@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a704bd8-d227-4663-b160-7265bc31e507@stanley.mountain>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 01, 2024 at 10:56:45AM GMT, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> Commit a6508079b1b6 ("bcachefs: dirent_points_to_inode() now warns on
> mismatch") from Sep 23, 2024 (linux-next), leads to the following
> Smatch static checker warning:
> 
> 	fs/bcachefs/fsck.c:38 dirent_points_to_inode_nowarn()
> 	warn: signedness bug returning '(-2157)'
> 
> fs/bcachefs/fsck.c
>     31 static bool dirent_points_to_inode_nowarn(struct bkey_s_c_dirent d,
>               ^^^^
> This is bool
> 
>     32                                    struct bch_inode_unpacked *inode)
>     33 {
>     34         if (d.v->d_type == DT_SUBVOL
>     35             ? le32_to_cpu(d.v->d_child_subvol)        == inode->bi_subvol
>     36             : le64_to_cpu(d.v->d_inum)                == inode->bi_inum)
>     37                 return 0;
> --> 38         return -BCH_ERR_ENOENT_dirent_doesnt_match_inode;

Thanks! Applied the following:


From 6bd7310a9b1c19e10b0f116c07c8b6abfd4e165f Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 1 Oct 2024 17:43:36 -0400
Subject: [PATCH] bcachefs: Fix return type of dirent_points_to_inode_nowarn()

we're returning an error code now, not a bool

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 0d8b782b63fb..c6c98ee87ec9 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -28,8 +28,8 @@ static bool inode_points_to_dirent(struct bch_inode_unpacked *inode,
 		inode->bi_dir_offset	== d.k->p.offset;
 }
 
-static bool dirent_points_to_inode_nowarn(struct bkey_s_c_dirent d,
-				   struct bch_inode_unpacked *inode)
+static int dirent_points_to_inode_nowarn(struct bkey_s_c_dirent d,
+					 struct bch_inode_unpacked *inode)
 {
 	if (d.v->d_type == DT_SUBVOL
 	    ? le32_to_cpu(d.v->d_child_subvol)	== inode->bi_subvol
