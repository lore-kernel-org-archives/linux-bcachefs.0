Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC6D214810
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743440174; cv=none; b=QXW3+9LdC8V9unHfD1NnT1jZauIowGA430webOR3kTf2bzKCk/UL3Au8VuIVDb46YuH2Ruc7TiAKHUqXNaxTKA7ek7mDbF+HpCV+lwPft6FPlr4wIQ0VPttyvrflR9s+cWB6jkK4WJHxPYXiXNCGsFwPrPajnpM02+YRZIwZwZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743440174; c=relaxed/simple;
	bh=6gBhjahYbuOZd0cko/VD3gk83q67YTZsPhBTBoQmCDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3xYIoPK5UTmQ6czJoUU2vnRYfS4R8fxl4YHDIL6WDrMIK9RPTAjOLk2pBsMoi2pSNtWLBFv+1qReuZmkFXwdiWjtPK3Ne91CnMoEurtYoEvTbKEN0VnlSAsGZi/wd4Wz9N/Zbumr3gJ7bLyE8iH1gfnRom1hUzsOrQfIOulx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dgxAp5N+; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dgxAp5N+"
Date: Mon, 31 Mar 2025 12:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743440169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=niNSeZDh5SLm7tX6NjIZnHY5bGT70CYzPhFjUCaXZ7o=;
	b=dgxAp5N+kyfB4z8NQo0ehVgAK/QDQm053cqKfr5ZQpmYOlVmjkLx9qBDq6lUVvCgKAMjGj
	kptlB3RKzgG77qkRjHNH0YvSHFBGOAK35vq8WHdhUOBfOmr+ZXdP4Z5bzhhBbX7Pj3CH4i
	hwt8DXPlVl7nqQv0r9IAAIcPOBmCR5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas =?utf-8?Q?M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/5] refactor: `cargo clippy --fix && cargo fmt`
Message-ID: <ne25hh3eyfirgliedkkaxfhhp6q5vtzwijfr4w7dsb73l7qecw@hhlzb22c2g5o>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
 <20250331143509.157528-4-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250331143509.157528-4-tmuehlbacher@posteo.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 02:35:07PM +0000, Thomas Mühlbacher wrote:
> Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
> ---
>  bch_bindgen/src/bkey.rs  |  2 +-
>  bch_bindgen/src/btree.rs | 24 ++++++++++++------------
>  bch_bindgen/src/lib.rs   | 15 ++++-----------
>  src/commands/mount.rs    | 19 ++++++++++++++-----
>  4 files changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
> index 2a012508..77e05900 100644
> --- a/bch_bindgen/src/bkey.rs
> +++ b/bch_bindgen/src/bkey.rs
> @@ -129,7 +129,7 @@ pub struct BkeySCToText<'a, 'b> {
>      fs: &'b Fs,
>  }
>  
> -impl<'a, 'b> fmt::Display for BkeySCToText<'a, 'b> {
> +impl fmt::Display for BkeySCToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          unsafe {
>              printbuf_to_formatter(f, |buf| {
> diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
> index 1aaf3018..ed563b95 100644
> --- a/bch_bindgen/src/btree.rs
> +++ b/bch_bindgen/src/btree.rs
> @@ -25,7 +25,7 @@ impl<'f> BtreeTrans<'f> {
>      }
>  }
>  
> -impl<'f> Drop for BtreeTrans<'f> {
> +impl Drop for BtreeTrans<'_> {
>      fn drop(&mut self) {
>          unsafe { c::bch2_trans_put(&mut *self.raw) }
>      }
> @@ -81,7 +81,7 @@ impl<'t> BtreeIter<'t> {
>          }
>      }
>  
> -    pub fn peek_max<'i>(&'i mut self, end: c::bpos) -> Result<Option<BkeySC<'i>>, bch_errcode> {
> +    pub fn peek_max(&mut self, end: c::bpos) -> Result<Option<BkeySC<'_>>, bch_errcode> {
>          unsafe {
>              let k = c::bch2_btree_iter_peek_max(&mut self.raw, end);
>              errptr_to_result_c(k.k).map(|_| {
> @@ -127,7 +127,7 @@ impl<'t> BtreeIter<'t> {
>      }
>  }
>  
> -impl<'t> Drop for BtreeIter<'t> {
> +impl Drop for BtreeIter<'_> {
>      fn drop(&mut self) {
>          unsafe { c::bch2_trans_iter_exit(self.raw.trans, &mut self.raw) }
>      }
> @@ -166,27 +166,27 @@ impl<'t> BtreeNodeIter<'t> {
>          }
>      }
>  
> -    pub fn peek<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
> +    pub fn peek(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_peek_node(&mut self.raw);
>              errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
>          }
>      }
>  
> -    pub fn peek_and_restart<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
> +    pub fn peek_and_restart(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_peek_node_and_restart(&mut self.raw);
>              errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
>          }
>      }
>  
> -    pub fn advance<'i>(&'i mut self) {
> +    pub fn advance(&mut self) {
>          unsafe {
>              c::bch2_btree_iter_next_node(&mut self.raw);
>          }
>      }
>  
> -    pub fn next<'i>(&'i mut self) -> Result<Option<&'i c::btree>, bch_errcode> {
> +    pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_next_node(&mut self.raw);
>              errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
> @@ -194,7 +194,7 @@ impl<'t> BtreeNodeIter<'t> {
>      }
>  }
>  
> -impl<'t> Drop for BtreeNodeIter<'t> {
> +impl Drop for BtreeNodeIter<'_> {
>      fn drop(&mut self) {
>          unsafe { c::bch2_trans_iter_exit(self.raw.trans, &mut self.raw) }
>      }
> @@ -202,11 +202,11 @@ impl<'t> Drop for BtreeNodeIter<'t> {
>  
>  impl<'b, 'f> c::btree {
>      pub fn to_text(&'b self, fs: &'f Fs) -> BtreeNodeToText<'b, 'f> {
> -        BtreeNodeToText { b: &self, fs }
> +        BtreeNodeToText { b: self, fs }
>      }
>  
>      pub fn ondisk_to_text(&'b self, fs: &'f Fs) -> BtreeNodeOndiskToText<'b, 'f> {
> -        BtreeNodeOndiskToText { b: &self, fs }
> +        BtreeNodeOndiskToText { b: self, fs }
>      }
>  }
>  
> @@ -215,7 +215,7 @@ pub struct BtreeNodeToText<'b, 'f> {
>      fs: &'f Fs,
>  }
>  
> -impl<'b, 'f> fmt::Display for BtreeNodeToText<'b, 'f> {
> +impl fmt::Display for BtreeNodeToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          printbuf_to_formatter(f, |buf| unsafe {
>              c::bch2_btree_node_to_text(buf, self.fs.raw, self.b)
> @@ -228,7 +228,7 @@ pub struct BtreeNodeOndiskToText<'b, 'f> {
>      fs: &'f Fs,
>  }
>  
> -impl<'b, 'f> fmt::Display for BtreeNodeOndiskToText<'b, 'f> {
> +impl fmt::Display for BtreeNodeOndiskToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          printbuf_to_formatter(f, |buf| unsafe {
>              c::bch2_btree_node_ondisk_to_text(buf, self.fs.raw, self.b)
> diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
> index b68f2d9b..7825cde1 100644
> --- a/bch_bindgen/src/lib.rs
> +++ b/bch_bindgen/src/lib.rs
> @@ -109,13 +109,8 @@ impl FromStr for c::btree_id {
>          let s = CString::new(s).unwrap();
>          let p = s.as_ptr();
>  
> -        let v = unsafe {
> -            c::match_string(
> -                c::__bch2_btree_ids[..].as_ptr(),
> -                (-(1 as isize)) as usize,
> -                p,
> -            )
> -        };
> +        let v =
> +            unsafe { c::match_string(c::__bch2_btree_ids[..].as_ptr(), (-1_isize) as usize, p) };

the reformatting is getting excessive, I don't like this
