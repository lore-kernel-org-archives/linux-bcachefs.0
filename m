Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6C9155725
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743440234; cv=none; b=b2UefYGXSej5FDd+y4uhR72kOyHGz+bUj9+SdR0hiUcgCGvCCqVxUEMyCawxdTFteXQ9PHqHoanyVem1H6dKhI3XsP6uCdL5flhZ3XloOuuqhZ7RQ/Pgijovh/1/rGJemT68CLXtzp4ZKnn45xenG86itvRhr6DUSwkfCzJ6Vko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743440234; c=relaxed/simple;
	bh=O3P9EBbcv7vw8C08XZ9AIhv+tw67bE6CR6qA5LBfSB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml2p6ptn3uxn/XQsBU50rlExFLU/pXjrs4TTFHcHO/HcBshQCqe/z4lVcHo/JhBHAM6qbTp5xLZeCnGyBpyhvPjDcv4Wi1m3fzpVgyjRVbisCXsW8f6evDPK50UYO1u0rql+JdU8m7nH9a5LeSyVo1HamXvrOTEE1d6epMl/CY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VQvvYKPL; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VQvvYKPL"
Date: Mon, 31 Mar 2025 12:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743440230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjA8D07dMoON+zslna93CfqAYwgo56lGd1YscJEnNrI=;
	b=VQvvYKPLEcQvnCef2gYZ5/s1a3rApHMg+ai34WDjo2LwBbkSK1ClBatBoEvtELnMd6YHeA
	m/a5v11Dekom8KfOa8ewoZlJTQRm3ioD6V211Pwq8I9SOc1cbD3L9ViHGI3AaGZyoI/9DB
	bm3kOz/0mGbYMT1/IVoNvVNjMqqtlR0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas =?utf-8?Q?M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 5/5] refactor: make bch_bindgen pass clippy
Message-ID: <aa6kjxxq27c3f3ihkiozdt3rf4lwq2fxjwdc2hkyr7pofmt5z5@f5fjfhoc4pxs>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
 <20250331143509.157528-6-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250331143509.157528-6-tmuehlbacher@posteo.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 02:35:09PM +0000, Thomas Mühlbacher wrote:
> Done through suppressing clippy lints in the generated bindings module,
> adding some transmute type annotations, changing a vec to slice type.
> 
> Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
> ---
>  bch_bindgen/src/bcachefs.rs |   5 ++
>  bch_bindgen/src/bkey.rs     | 151 ++++++++++++++++++++++++++++--------
>  bch_bindgen/src/btree.rs    |   1 +
>  bch_bindgen/src/fs.rs       |   2 +-
>  bch_bindgen/src/lib.rs      |   4 +-
>  5 files changed, 127 insertions(+), 36 deletions(-)
> 
> diff --git a/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
> index fbbac5ed..3fa0060e 100644
> --- a/bch_bindgen/src/bcachefs.rs
> +++ b/bch_bindgen/src/bcachefs.rs
> @@ -1,3 +1,8 @@
> +#![allow(clippy::missing_safety_doc)]
> +#![allow(clippy::too_many_arguments)]
> +#![allow(clippy::transmute_int_to_bool)]
> +#![allow(clippy::unnecessary_cast)]
> +#![allow(clippy::useless_transmute)]
>  #![allow(non_upper_case_globals)]
>  #![allow(non_camel_case_types)]
>  #![allow(non_snake_case)]
> diff --git a/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
> index af109167..9d38a0b9 100644
> --- a/bch_bindgen/src/bkey.rs
> +++ b/bch_bindgen/src/bkey.rs
> @@ -1,9 +1,9 @@
>  #![allow(non_camel_case_types)]
>  
>  use crate::btree::BtreeIter;
> -use crate::c;
>  use crate::fs::Fs;
>  use crate::printbuf_to_formatter;
> +use crate::{bcachefs, c};
>  use std::fmt;
>  use std::marker::PhantomData;
>  use std::mem::transmute;
> @@ -96,39 +96,124 @@ impl<'a, 'b> BkeySC<'a> {
>                  KEY_TYPE_deleted => deleted,
>                  KEY_TYPE_whiteout => whiteout,
>                  KEY_TYPE_error => error,
> -                KEY_TYPE_cookie => cookie(transmute(self.v)),
> -                KEY_TYPE_hash_whiteout => hash_whiteout(transmute(self.v)),
> -                KEY_TYPE_btree_ptr => btree_ptr(transmute(self.v)),
> -                KEY_TYPE_extent => extent(transmute(self.v)),
> -                KEY_TYPE_reservation => reservation(transmute(self.v)),
> -                KEY_TYPE_inode => inode(transmute(self.v)),
> -                KEY_TYPE_inode_generation => inode_generation(transmute(self.v)),
> -                KEY_TYPE_dirent => dirent(transmute(self.v)),
> -                KEY_TYPE_xattr => xattr(transmute(self.v)),
> -                KEY_TYPE_alloc => alloc(transmute(self.v)),
> -                KEY_TYPE_quota => quota(transmute(self.v)),
> -                KEY_TYPE_stripe => stripe(transmute(self.v)),
> -                KEY_TYPE_reflink_p => reflink_p(transmute(self.v)),
> -                KEY_TYPE_reflink_v => reflink_v(transmute(self.v)),
> -                KEY_TYPE_inline_data => inline_data(transmute(self.v)),
> -                KEY_TYPE_btree_ptr_v2 => btree_ptr_v2(transmute(self.v)),
> -                KEY_TYPE_indirect_inline_data => indirect_inline_data(transmute(self.v)),
> -                KEY_TYPE_alloc_v2 => alloc_v2(transmute(self.v)),
> -                KEY_TYPE_subvolume => subvolume(transmute(self.v)),
> -                KEY_TYPE_snapshot => snapshot(transmute(self.v)),
> -                KEY_TYPE_inode_v2 => inode_v2(transmute(self.v)),
> -                KEY_TYPE_alloc_v3 => inode_v3(transmute(self.v)),
> +                KEY_TYPE_cookie => cookie(transmute::<&bcachefs::bch_val, &bcachefs::bch_cookie>(
> +                    self.v,
> +                )),

!?!?!?!?

> +                KEY_TYPE_hash_whiteout => hash_whiteout(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_hash_whiteout,
> +                >(self.v)),
> +                KEY_TYPE_btree_ptr => btree_ptr(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_btree_ptr,
> +                >(self.v)),
> +                KEY_TYPE_extent => extent(transmute::<&bcachefs::bch_val, &bcachefs::bch_extent>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_reservation => reservation(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_reservation,
> +                >(self.v)),
> +                KEY_TYPE_inode => inode(transmute::<&bcachefs::bch_val, &bcachefs::bch_inode>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_inode_generation => inode_generation(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inode_generation,
> +                >(self.v)),
> +                KEY_TYPE_dirent => dirent(transmute::<&bcachefs::bch_val, &bcachefs::bch_dirent>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_xattr => xattr(transmute::<&bcachefs::bch_val, &bcachefs::bch_xattr>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_alloc => alloc(transmute::<&bcachefs::bch_val, &bcachefs::bch_alloc>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_quota => quota(transmute::<&bcachefs::bch_val, &bcachefs::bch_quota>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_stripe => stripe(transmute::<&bcachefs::bch_val, &bcachefs::bch_stripe>(
> +                    self.v,
> +                )),
> +                KEY_TYPE_reflink_p => reflink_p(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_reflink_p,
> +                >(self.v)),
> +                KEY_TYPE_reflink_v => reflink_v(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_reflink_v,
> +                >(self.v)),
> +                KEY_TYPE_inline_data => inline_data(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inline_data,
> +                >(self.v)),
> +                KEY_TYPE_btree_ptr_v2 => btree_ptr_v2(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_btree_ptr_v2,
> +                >(self.v)),
> +                KEY_TYPE_indirect_inline_data => indirect_inline_data(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_indirect_inline_data,
> +                >(self.v)),
> +                KEY_TYPE_alloc_v2 => alloc_v2(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_alloc_v2,
> +                >(self.v)),
> +                KEY_TYPE_subvolume => subvolume(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_subvolume,
> +                >(self.v)),
> +                KEY_TYPE_snapshot => snapshot(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_snapshot,
> +                >(self.v)),
> +                KEY_TYPE_inode_v2 => inode_v2(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inode_v2,
> +                >(self.v)),
> +                KEY_TYPE_alloc_v3 => inode_v3(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inode_v3,
> +                >(self.v)),
>                  KEY_TYPE_set => set,
> -                KEY_TYPE_lru => lru(transmute(self.v)),
> -                KEY_TYPE_alloc_v4 => alloc_v4(transmute(self.v)),
> -                KEY_TYPE_backpointer => backpointer(transmute(self.v)),
> -                KEY_TYPE_inode_v3 => inode_v3(transmute(self.v)),
> -                KEY_TYPE_bucket_gens => bucket_gens(transmute(self.v)),
> -                KEY_TYPE_snapshot_tree => snapshot_tree(transmute(self.v)),
> -                KEY_TYPE_logged_op_truncate => logged_op_truncate(transmute(self.v)),
> -                KEY_TYPE_logged_op_finsert => logged_op_finsert(transmute(self.v)),
> -                KEY_TYPE_accounting => accounting(transmute(self.v)),
> -                KEY_TYPE_inode_alloc_cursor => inode_alloc_cursor(transmute(self.v)),
> +                KEY_TYPE_lru => lru(transmute::<&bcachefs::bch_val, &bcachefs::bch_lru>(self.v)),
> +                KEY_TYPE_alloc_v4 => alloc_v4(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_alloc_v4,
> +                >(self.v)),
> +                KEY_TYPE_backpointer => backpointer(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_backpointer,
> +                >(self.v)),
> +                KEY_TYPE_inode_v3 => inode_v3(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inode_v3,
> +                >(self.v)),
> +                KEY_TYPE_bucket_gens => bucket_gens(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_bucket_gens,
> +                >(self.v)),
> +                KEY_TYPE_snapshot_tree => snapshot_tree(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_snapshot_tree,
> +                >(self.v)),
> +                KEY_TYPE_logged_op_truncate => logged_op_truncate(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_logged_op_truncate,
> +                >(self.v)),
> +                KEY_TYPE_logged_op_finsert => logged_op_finsert(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_logged_op_finsert,
> +                >(self.v)),
> +                KEY_TYPE_accounting => accounting(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_accounting,
> +                >(self.v)),
> +                KEY_TYPE_inode_alloc_cursor => inode_alloc_cursor(transmute::<
> +                    &bcachefs::bch_val,
> +                    &bcachefs::bch_inode_alloc_cursor,
> +                >(self.v)),
>                  KEY_TYPE_MAX => unreachable!(),
>              }
>          }
> diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
> index 99c2a5b5..0d8d7303 100644
> --- a/bch_bindgen/src/btree.rs
> +++ b/bch_bindgen/src/btree.rs
> @@ -189,6 +189,7 @@ impl<'t> BtreeNodeIter<'t> {
>          }
>      }
>  
> +    #[allow(clippy::should_implement_trait)]
>      pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_next_node(&mut self.raw);
> diff --git a/bch_bindgen/src/fs.rs b/bch_bindgen/src/fs.rs
> index e44fca25..2997ed8f 100644
> --- a/bch_bindgen/src/fs.rs
> +++ b/bch_bindgen/src/fs.rs
> @@ -9,7 +9,7 @@ pub struct Fs {
>  }
>  
>  impl Fs {
> -    pub fn open(devs: &Vec<PathBuf>, opts: c::bch_opts) -> Result<Fs, bch_errcode> {
> +    pub fn open(devs: &[PathBuf], opts: c::bch_opts) -> Result<Fs, bch_errcode> {
>          let devs: Vec<_> = devs
>              .iter()
>              .map(|i| CString::new(i.as_os_str().as_bytes()).unwrap().into_raw())
> diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
> index 7c313921..cc56c298 100644
> --- a/bch_bindgen/src/lib.rs
> +++ b/bch_bindgen/src/lib.rs
> @@ -114,7 +114,7 @@ impl FromStr for c::btree_id {
>          let v =
>              unsafe { c::match_string(c::__bch2_btree_ids[..].as_ptr(), (-1_isize) as usize, p) };
>          if v >= 0 {
> -            Ok(unsafe { std::mem::transmute(v) })
> +            Ok(unsafe { std::mem::transmute::<i32, bcachefs::btree_id>(v) })
>          } else {
>              Err(BchToolsErr::InvalidBtreeId)
>          }
> @@ -130,7 +130,7 @@ impl FromStr for c::bch_bkey_type {
>  
>          let v = unsafe { c::match_string(c::bch2_bkey_types[..].as_ptr(), (-1_isize) as usize, p) };
>          if v >= 0 {
> -            Ok(unsafe { std::mem::transmute(v) })
> +            Ok(unsafe { std::mem::transmute::<i32, bcachefs::bch_bkey_type>(v) })
>          } else {
>              Err(BchToolsErr::InvalidBkeyType)
>          }
> -- 
> 2.48.1
> 
