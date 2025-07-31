Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076E227B88
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Jul 2025 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753989719; cv=none; b=us5+3fdpnC30UfKKfyLRP9idycAuxqlk3U91Zb+8di4Znx+TiUk5aHtNL4jrODweevg+RAf6G6WVdVTOjuX32lGAAwhz0xkAUPlRUUBBXpJF8z99VxAOCndjWK7DMA/YFzkXIIZ5EJ+kvSMeqsGXASe2sqCAY0EnPAT4Npr96xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753989719; c=relaxed/simple;
	bh=aoMoJLjeHMeC/J0E28LF9T5kBbh1Fmen21pPyjxU4TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcPKIB+LbGeffPwLViDMTqKWvhv0G7nKMxd8KIVJtO2Bpj70UeCgoi7VlAyx9MG47G52Nc8UEmEzY7WNFXHH84UDzSySS8az7Cz2wXJ9DLkarkbe+O+A1ftE+oJbuTjMClGpJDeW3vxMjQDSnRPqWflvGo2zulsdo+XqdSAbfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hdLanQI8; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hdLanQI8"
Date: Thu, 31 Jul 2025 15:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753989713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k0NFCBhQ28oULzGZkHa9Yng4QvTnOswYPtP0b8nGevw=;
	b=hdLanQI8eEftlYTeBfOhrCjhJUyDKzKtSeekQXLqByZZTp7RPAqstGTs66yu3p/75XTN4Z
	ozKNQCoPPT/pCT4Vz3JvZD+9d11zRC68ouszCPK5KhX2yYwrNSUHWv375Hld9YYHBQYA1a
	OJxPARKlKnEgOFFGjjpFXrfMCZm7n1U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [koverstreet-bcachefs:master 219/231]
 fs/bcachefs/dirent.c:765:1: warning: the frame size of 1344 bytes is larger
 than 1280 bytes
Message-ID: <bs6zfkf7si336ked6hfnj27o25oioaiy24vgz5m7izdbc7u5g2@nkzzojhbxx6o>
References: <202507312248.dWPpIFt3-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507312248.dWPpIFt3-lkp@intel.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 31, 2025 at 10:46:17PM +0800, kernel test robot wrote:
> tree:   https://github.com/koverstreet/bcachefs master
> head:   53def8896bdc4b3f7a15affd6f867cbc6f64dc14
> commit: 8cf424e23e76826583cef06af21ada70f22ff85f [219/231] bcachefs: CLASS(btree_iter)
> config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20250731/202507312248.dWPpIFt3-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507312248.dWPpIFt3-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507312248.dWPpIFt3-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    fs/bcachefs/dirent.c: In function 'bch2_fsck_remove_dirent':
> >> fs/bcachefs/dirent.c:765:1: warning: the frame size of 1344 bytes is larger than 1280 bytes [-Wframe-larger-than=]
>      765 | }
>          | ^
> 
> 
> vim +765 fs/bcachefs/dirent.c
> 
> 758ea4ff812b4d Kent Overstreet 2025-03-20  743  
> 758ea4ff812b4d Kent Overstreet 2025-03-20  744  int bch2_fsck_remove_dirent(struct btree_trans *trans, struct bpos pos)
> 758ea4ff812b4d Kent Overstreet 2025-03-20  745  {
> 758ea4ff812b4d Kent Overstreet 2025-03-20  746  	struct bch_fs *c = trans->c;
> 758ea4ff812b4d Kent Overstreet 2025-03-20  747  	struct bch_inode_unpacked dir_inode;
> 758ea4ff812b4d Kent Overstreet 2025-03-20  748  	struct bch_hash_info dir_hash_info;
> 758ea4ff812b4d Kent Overstreet 2025-03-20  749  
> 8cf424e23e7682 Kent Overstreet 2025-07-30  750  	int ret = lookup_first_inode(trans, pos.inode, &dir_inode);
> 758ea4ff812b4d Kent Overstreet 2025-03-20  751  	if (ret)
> 758ea4ff812b4d Kent Overstreet 2025-03-20  752  		goto err;
> 758ea4ff812b4d Kent Overstreet 2025-03-20  753  
> 758ea4ff812b4d Kent Overstreet 2025-03-20  754  	dir_hash_info = bch2_hash_info_init(c, &dir_inode);
> 758ea4ff812b4d Kent Overstreet 2025-03-20  755  
> 8cf424e23e7682 Kent Overstreet 2025-07-30  756  	CLASS(btree_iter, iter)(trans, BTREE_ID_dirents, pos, BTREE_ITER_intent);
> 758ea4ff812b4d Kent Overstreet 2025-03-20  757  
> 25201eae7abed7 Kent Overstreet 2025-07-30  758  	ret =   bch2_btree_iter_traverse(&iter) ?:
> 758ea4ff812b4d Kent Overstreet 2025-03-20  759  		bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
> 758ea4ff812b4d Kent Overstreet 2025-03-20  760  				    &dir_hash_info, &iter,
> 758ea4ff812b4d Kent Overstreet 2025-03-20  761  				    BTREE_UPDATE_internal_snapshot_node);
> 758ea4ff812b4d Kent Overstreet 2025-03-20  762  err:
> 758ea4ff812b4d Kent Overstreet 2025-03-20  763  	bch_err_fn(c, ret);
> 758ea4ff812b4d Kent Overstreet 2025-03-20  764  	return ret;
> 758ea4ff812b4d Kent Overstreet 2025-03-20 @765  }
> 
> :::::: The code at line 765 was first introduced by commit
> :::::: 758ea4ff812b4dfd4cef6dba0eb4b0025a7b147e bcachefs: Move bch2_check_dirent_target() to namei.c
> 
> :::::: TO: Kent Overstreet <kent.overstreet@linux.dev>
> :::::: CC: Kent Overstreet <kent.overstreet@linux.dev>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

If someone wants to do some pa-holing (or show the idiot how), I've
never been able to figure out how get it to show the stack frame layout.

The variables in this function add up to ~300 bytes, I have no idea
where that's turning into 1344 bytes.
