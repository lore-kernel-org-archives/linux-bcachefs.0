Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD5C63A1
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Mar 2024 00:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710461170; cv=none; b=ZrJIpfdVV2cxwrxgY3L4X/AHAkwCj99k8qNyitB/G5LTpi1eP9WVGZvTPbxui29dr56Wq60UtSG/jKmGW5cJmrEuAwKrnayPdexgpyJU/2mBPa60jxAwtm/chlNbUOnvpbW9bw4e5jsvSg1quQIfIzRsPUV6W1ETiuHimlbjxys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710461170; c=relaxed/simple;
	bh=XKD/Ec7RtHQl9YspJ3UY9SagZRH83oYatQ4PBgm7Fs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBwYP9e2Xz6Pb7u1WCE5CtH+cN1cCBv5elRZMshONFgXqtr9BoOZSbWw96FPXNXWQh3yd5hMhqI50SLnmI8+i/LOSFslY9I2y321XRbOcb4dkfwBMhL1SdbFa3qR8jIjFFRtZlFd2FspwNjHNOzdJ2KWIpNo2qHCaeuBGWTzAYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JcBUjjSm; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JcBUjjSm"
Date: Thu, 14 Mar 2024 20:05:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710461165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e8a9OotVzItbgoUzlGO1UoWNwzpAZj9Yc4NPEJWGm9U=;
	b=JcBUjjSm/fLhkF0nUyLwzHG7RGIb2HwgDOUKJxSzIi4vxR43Ly0uVD78IIIB/wKAElRyok
	yzny1YdbOlpUmL22KegITLF50/dE+LZuFcStAXDuFJ9Jtxpnh3UhHBy6T25s7WoJ6ZNTdI
	lNSPvPtjiq+2GtVtDAh1JDq1yssaJ+s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] bcachefs: create debugfs dir for each btree
Message-ID: <6sb4x4vguubv52lbdcdawinrkyxmbslqzbsgtne4ifhsj5yesi@6q6twh2lhgir>
References: <20240314160218.192135-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240314160218.192135-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 14, 2024 at 10:02:18AM -0600, Thomas Bertschinger wrote:
> This creates a subdirectory for each individual btree under the btrees/
> debugfs directory.
> 
> Directory structure, before:
> 
> /sys/kernel/debug/bcachefs/$FS_ID/btrees/
> ├── alloc
> ├── alloc-bfloat-failed
> ├── alloc-formats
> ├── backpointers
> ├── backpointers-bfloat-failed
> ├── backpointers-formats
> ...
> 
> Directory structure, after:
> 
> /sys/kernel/debug/bcachefs/$FS_ID/btrees/
> ├── alloc
> │   ├── bfloat-failed
> │   ├── formats
> │   └── nodes
> ├── backpointers
> │   ├── bfloat-failed
> │   ├── formats
> │   └── nodes

nodes should actually be keys - nodes would be showing the node
structure, only cmd_list.rs currently does that (but -formats covers it)

> ...
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  fs/bcachefs/debug.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
> index b1f147e6be4d..491ad699d558 100644
> --- a/fs/bcachefs/debug.c
> +++ b/fs/bcachefs/debug.c
> @@ -866,6 +866,20 @@ void bch2_fs_debug_exit(struct bch_fs *c)
>  		debugfs_remove_recursive(c->fs_debug_dir);
>  }
>  
> +static void bch2_fs_debug_btree_init(struct bch_fs *c, struct btree_debug *bd)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_dir(bch2_btree_id_str(bd->id), c->btree_debug_dir);
> +
> +	debugfs_create_file("nodes", 0400, d, bd, &btree_debug_ops);
> +
> +	debugfs_create_file("formats", 0400, d, bd, &btree_format_debug_ops);
> +
> +	debugfs_create_file("bfloat-failed", 0400, d, bd,
> +			    &bfloat_failed_debug_ops);
> +}
> +
>  void bch2_fs_debug_init(struct bch_fs *c)
>  {
>  	struct btree_debug *bd;
> @@ -902,21 +916,7 @@ void bch2_fs_debug_init(struct bch_fs *c)
>  	     bd < c->btree_debug + ARRAY_SIZE(c->btree_debug);
>  	     bd++) {
>  		bd->id = bd - c->btree_debug;
> -		debugfs_create_file(bch2_btree_id_str(bd->id),
> -				    0400, c->btree_debug_dir, bd,
> -				    &btree_debug_ops);
> -
> -		snprintf(name, sizeof(name), "%s-formats",
> -			 bch2_btree_id_str(bd->id));
> -
> -		debugfs_create_file(name, 0400, c->btree_debug_dir, bd,
> -				    &btree_format_debug_ops);
> -
> -		snprintf(name, sizeof(name), "%s-bfloat-failed",
> -			 bch2_btree_id_str(bd->id));
> -
> -		debugfs_create_file(name, 0400, c->btree_debug_dir, bd,
> -				    &bfloat_failed_debug_ops);
> +		bch2_fs_debug_btree_init(c, bd);
>  	}
>  }
>  
> -- 
> 2.43.2
> 
