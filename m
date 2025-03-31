Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460DB155725
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743440075; cv=none; b=aNNfqF94tRUuWsuFw/KQEJjyQrruJ4xS4i8PDsHlmcuGSZ7fGpQrL8Lbuef2gJbdkRLOF1ezYm12hABd7XwbheoR2D9nEZ6kn7ge7JJMigvrT55+ApfjHLHY7fyh2d/RL8fPMygFXwZDjRrxTC5+iIuVKSvDtcaZLNy4q44N0SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743440075; c=relaxed/simple;
	bh=xVjNvjB6Hpd4KsF62pIY+HBtPD+KesHOQJdnItK2jnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F90jWBn6FwZU7kOswAy9o2InHNV6EmJZOTSY0a2zej4BIHvtLhipSwOZhHGOoxXz1Ml18YZheIf4duYbtMKil1hj5JV5QZYlpkwE2HiSpAiN7owwBYBBQNbjW/Ap3dF5/uGHskwggBG+5k6qN2dwF2ZS4wnuc9DeBhHs4285XDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a59TwZL2; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a59TwZL2"
Date: Mon, 31 Mar 2025 12:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743440071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kcfkPMPAqngcpsdr2aByvDuONet2R8KpVIKN65+6yeQ=;
	b=a59TwZL27ozbWEO23e3jLq8Rkbd6PCn2c8nhBcJuQFnE+tf1wMSjTiOPaO2ueBhSrmUf/y
	+YlauZARZG9uMDuQjEvYAlBXG7WPdrgTFpBlbWorT7E7nNk5Fy1cYyoLsPvaeLuT7mFha+
	AmYgrGXHSoIJPOIDAGI1tAckt4IxEHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas =?utf-8?Q?M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 4/5] refactor: `cargo clippy --fix -- -W clippy::pedantic
 && cargo fmt`
Message-ID: <k7nktvs5exwk74u3h4lidmwpkhr6ylpk2ee76kqkbt6rbiviyx@x72vskcqna6w>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
 <20250331143509.157528-5-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250331143509.157528-5-tmuehlbacher@posteo.net>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 02:35:08PM +0000, Thomas Mühlbacher wrote:
> Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
> ---
>  bch_bindgen/src/bcachefs.rs | 12 ++++++++++--
>  bch_bindgen/src/bkey.rs     | 29 +++++++++++++++++++++++++----
>  bch_bindgen/src/btree.rs    | 31 ++++++++++++++++++-------------
>  bch_bindgen/src/errcode.rs  |  2 +-
>  bch_bindgen/src/lib.rs      | 10 ++++++----
>  bch_bindgen/src/sb_io.rs    |  2 +-
>  src/commands/mount.rs       | 12 ++++++------
>  src/key.rs                  |  9 +++++----
>  src/wrappers/handle.rs      |  4 +++-
>  9 files changed, 75 insertions(+), 36 deletions(-)
> 
> diff --git a/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
> index 8f6d41a4..fbbac5ed 100644
> --- a/bch_bindgen/src/bcachefs.rs
> +++ b/bch_bindgen/src/bcachefs.rs
> @@ -20,6 +20,7 @@ bitfield! {
>  }
>  use std::mem::offset_of;
>  impl bch_sb_field_crypt {
> +    #[must_use]
>      pub fn scrypt_flags(&self) -> Option<bch_scrypt_flags> {
>          use std::convert::TryInto;
>          match bch_kdf_types(bch_crypt_flags(self.flags).TYPE().try_into().ok()?) {
> @@ -27,6 +28,7 @@ impl bch_sb_field_crypt {
>              _ => None,
>          }
>      }
> +    #[must_use]
>      pub fn key(&self) -> &bch_encrypted_key {
>          &self.key
>      }
> @@ -43,29 +45,33 @@ impl PartialEq for bch_sb {
>  }
>  
>  impl bch_sb {
> +    #[must_use]
>      pub fn crypt(&self) -> Option<&bch_sb_field_crypt> {
>          unsafe {
>              let ptr = bch2_sb_field_get_id(
> -                self as *const _ as *mut _,
> +                std::ptr::from_ref(self).cast_mut(),
>                  bch_sb_field_type::BCH_SB_FIELD_crypt,
>              ) as *const u8;
>              if ptr.is_null() {
>                  None
>              } else {
>                  let offset = offset_of!(bch_sb_field_crypt, field);
> -                Some(&*((ptr.sub(offset)) as *const _))
> +                Some(&*(ptr.sub(offset)).cast())
>              }
>          }
>      }
> +    #[must_use]
>      pub fn uuid(&self) -> uuid::Uuid {
>          uuid::Uuid::from_bytes(self.user_uuid.b)
>      }
>  
> +    #[must_use]
>      pub fn number_of_devices(&self) -> u32 {
>          unsafe { c::bch2_sb_nr_devices(self) }
>      }
>  
>      /// Get the nonce used to encrypt the superblock
> +    #[must_use]
>      pub fn nonce(&self) -> nonce {
>          let [a, b, c, d, e, f, g, h, _rest @ ..] = self.uuid.b;
>          let dword1 = u32::from_le_bytes([a, b, c, d]);
> @@ -76,10 +82,12 @@ impl bch_sb {
>      }
>  }
>  impl bch_sb_handle {
> +    #[must_use]
>      pub fn sb(&self) -> &bch_sb {
>          unsafe { &*self.sb }
>      }
>  
> +    #[must_use]
>      pub fn bdev(&self) -> &block_device {
>          unsafe { &*self.bdev }
>      }
> diff --git a/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
> index 77e05900..af109167 100644
> --- a/bch_bindgen/src/bkey.rs
> +++ b/bch_bindgen/src/bkey.rs
> @@ -61,16 +61,37 @@ impl<'a, 'b> BkeySC<'a> {
>          }
>      }
>  
> +    #[must_use]
>      pub fn to_text(&'a self, fs: &'b Fs) -> BkeySCToText<'a, 'b> {
>          BkeySCToText { k: self, fs }
>      }
>  
> +    #[must_use]
>      pub fn v(&'a self) -> BkeyValC<'a> {
>          unsafe {
> -            let ty: c::bch_bkey_type = transmute(self.k.type_ as u32);
> +            let ty: c::bch_bkey_type = transmute(u32::from(self.k.type_));
>  
> -            use c::bch_bkey_type::*;
> -            use BkeyValC::*;
> +            use c::bch_bkey_type::{
> +                KEY_TYPE_accounting, KEY_TYPE_alloc, KEY_TYPE_alloc_v2, KEY_TYPE_alloc_v3,
> +                KEY_TYPE_alloc_v4, KEY_TYPE_backpointer, KEY_TYPE_btree_ptr, KEY_TYPE_btree_ptr_v2,
> +                KEY_TYPE_bucket_gens, KEY_TYPE_cookie, KEY_TYPE_deleted, KEY_TYPE_dirent,
> +                KEY_TYPE_error, KEY_TYPE_extent, KEY_TYPE_hash_whiteout,
> +                KEY_TYPE_indirect_inline_data, KEY_TYPE_inline_data, KEY_TYPE_inode,
> +                KEY_TYPE_inode_alloc_cursor, KEY_TYPE_inode_generation, KEY_TYPE_inode_v2,
> +                KEY_TYPE_inode_v3, KEY_TYPE_logged_op_finsert, KEY_TYPE_logged_op_truncate,
> +                KEY_TYPE_lru, KEY_TYPE_quota, KEY_TYPE_reflink_p, KEY_TYPE_reflink_v,
> +                KEY_TYPE_reservation, KEY_TYPE_set, KEY_TYPE_snapshot, KEY_TYPE_snapshot_tree,
> +                KEY_TYPE_stripe, KEY_TYPE_subvolume, KEY_TYPE_whiteout, KEY_TYPE_xattr,
> +                KEY_TYPE_MAX,
> +            };
> +            use BkeyValC::{
> +                accounting, alloc, alloc_v2, alloc_v4, backpointer, btree_ptr, btree_ptr_v2,
> +                bucket_gens, cookie, deleted, dirent, error, extent, hash_whiteout,
> +                indirect_inline_data, inline_data, inode, inode_alloc_cursor, inode_generation,
> +                inode_v2, inode_v3, logged_op_finsert, logged_op_truncate, lru, quota, reflink_p,
> +                reflink_v, reservation, set, snapshot, snapshot_tree, stripe, subvolume, whiteout,
> +                xattr,
> +            };
>              match ty {
>                  KEY_TYPE_deleted => deleted,
>                  KEY_TYPE_whiteout => whiteout,
> @@ -133,7 +154,7 @@ impl fmt::Display for BkeySCToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          unsafe {
>              printbuf_to_formatter(f, |buf| {
> -                c::bch2_bkey_val_to_text(buf, self.fs.raw, self.k.to_raw())
> +                c::bch2_bkey_val_to_text(buf, self.fs.raw, self.k.to_raw());
>              })
>          }
>      }
> diff --git a/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
> index ed563b95..99c2a5b5 100644
> --- a/bch_bindgen/src/btree.rs
> +++ b/bch_bindgen/src/btree.rs
> @@ -15,6 +15,7 @@ pub struct BtreeTrans<'f> {
>  }
>  
>  impl<'f> BtreeTrans<'f> {
> +    #[must_use]
>      pub fn new(fs: &'f Fs) -> BtreeTrans<'f> {
>          unsafe {
>              BtreeTrans {
> @@ -57,6 +58,7 @@ pub struct BtreeIter<'t> {
>  }
>  
>  impl<'t> BtreeIter<'t> {
> +    #[must_use]
>      pub fn new(
>          trans: &'t BtreeTrans<'t>,
>          btree: c::btree_id,
> @@ -71,7 +73,7 @@ impl<'t> BtreeIter<'t> {
>                  iter.as_mut_ptr(),
>                  btree,
>                  pos,
> -                flags.bits as u32,
> +                u32::from(flags.bits),
>              );
>  
>              BtreeIter {
> @@ -85,14 +87,14 @@ impl<'t> BtreeIter<'t> {
>          unsafe {
>              let k = c::bch2_btree_iter_peek_max(&mut self.raw, end);
>              errptr_to_result_c(k.k).map(|_| {
> -                if !k.k.is_null() {
> +                if k.k.is_null() {
> +                    None
> +                } else {
>                      Some(BkeySC {
>                          k:    &*k.k,
>                          v:    &*k.v,
>                          iter: PhantomData,
>                      })
> -                } else {
> -                    None
>                  }
>              })
>          }
> @@ -107,14 +109,14 @@ impl<'t> BtreeIter<'t> {
>              let k = c::bch2_btree_iter_peek_and_restart_outlined(&mut self.raw);
>  
>              errptr_to_result_c(k.k).map(|_| {
> -                if !k.k.is_null() {
> +                if k.k.is_null() {
> +                    None
> +                } else {
>                      Some(BkeySC {
>                          k:    &*k.k,
>                          v:    &*k.v,
>                          iter: PhantomData,
>                      })
> -                } else {
> -                    None
>                  }
>              })
>          }
> @@ -139,6 +141,7 @@ pub struct BtreeNodeIter<'t> {
>  }
>  
>  impl<'t> BtreeNodeIter<'t> {
> +    #[must_use]
>      pub fn new(
>          trans: &'t BtreeTrans<'t>,
>          btree: c::btree_id,
> @@ -156,7 +159,7 @@ impl<'t> BtreeNodeIter<'t> {
>                  pos,
>                  locks_want,
>                  depth,
> -                flags.bits as u32,
> +                u32::from(flags.bits),
>              );
>  
>              BtreeNodeIter {
> @@ -169,14 +172,14 @@ impl<'t> BtreeNodeIter<'t> {
>      pub fn peek(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_peek_node(&mut self.raw);
> -            errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
> +            errptr_to_result_c(b).map(|b| if b.is_null() { None } else { Some(&*b) })
>          }
>      }
>  
>      pub fn peek_and_restart(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_peek_node_and_restart(&mut self.raw);
> -            errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
> +            errptr_to_result_c(b).map(|b| if b.is_null() { None } else { Some(&*b) })
>          }
>      }
>  
> @@ -189,7 +192,7 @@ impl<'t> BtreeNodeIter<'t> {
>      pub fn next(&mut self) -> Result<Option<&c::btree>, bch_errcode> {
>          unsafe {
>              let b = c::bch2_btree_iter_next_node(&mut self.raw);
> -            errptr_to_result_c(b).map(|b| if !b.is_null() { Some(&*b) } else { None })
> +            errptr_to_result_c(b).map(|b| if b.is_null() { None } else { Some(&*b) })
>          }
>      }
>  }
> @@ -201,10 +204,12 @@ impl Drop for BtreeNodeIter<'_> {
>  }
>  
>  impl<'b, 'f> c::btree {
> +    #[must_use]
>      pub fn to_text(&'b self, fs: &'f Fs) -> BtreeNodeToText<'b, 'f> {
>          BtreeNodeToText { b: self, fs }
>      }
>  
> +    #[must_use]
>      pub fn ondisk_to_text(&'b self, fs: &'f Fs) -> BtreeNodeOndiskToText<'b, 'f> {
>          BtreeNodeOndiskToText { b: self, fs }
>      }
> @@ -218,7 +223,7 @@ pub struct BtreeNodeToText<'b, 'f> {
>  impl fmt::Display for BtreeNodeToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          printbuf_to_formatter(f, |buf| unsafe {
> -            c::bch2_btree_node_to_text(buf, self.fs.raw, self.b)
> +            c::bch2_btree_node_to_text(buf, self.fs.raw, self.b);
>          })
>      }
>  }
> @@ -231,7 +236,7 @@ pub struct BtreeNodeOndiskToText<'b, 'f> {
>  impl fmt::Display for BtreeNodeOndiskToText<'_, '_> {
>      fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>          printbuf_to_formatter(f, |buf| unsafe {
> -            c::bch2_btree_node_ondisk_to_text(buf, self.fs.raw, self.b)
> +            c::bch2_btree_node_ondisk_to_text(buf, self.fs.raw, self.b);
>          })
>      }
>  }
> diff --git a/bch_bindgen/src/errcode.rs b/bch_bindgen/src/errcode.rs
> index 4d75f1d2..b8d12c19 100644
> --- a/bch_bindgen/src/errcode.rs
> +++ b/bch_bindgen/src/errcode.rs
> @@ -7,7 +7,7 @@ pub use crate::c::bch_errcode;
>  impl fmt::Display for bch_errcode {
>      fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
>          let s = unsafe { CStr::from_ptr(bcachefs::bch2_err_str(*self as i32)) };
> -        write!(f, "{:?}", s)
> +        write!(f, "{s:?}")
>      }
>  }
>  
> diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
> index 7825cde1..7c313921 100644
> --- a/bch_bindgen/src/lib.rs
> +++ b/bch_bindgen/src/lib.rs
> @@ -14,14 +14,16 @@ pub mod c {
>  
>  use c::bpos as Bpos;
>  
> +#[must_use]
>  pub const fn spos(inode: u64, offset: u64, snapshot: u32) -> Bpos {
>      Bpos {
> -        inode,
> -        offset,
>          snapshot,
> +        offset,
> +        inode,

This needs to be using designated initializers, the order of these
fields in different on big and little endian

>      }
>  }
>  
> +#[must_use]
>  pub const fn pos(inode: u64, offset: u64) -> Bpos {
>      spos(inode, offset, 0)
>  }
> @@ -69,7 +71,7 @@ impl fmt::Display for c::btree_id {
>      fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
>          let s = unsafe { CStr::from_ptr(c::bch2_btree_id_str(*self)) };
>          let s = s.to_str().unwrap();
> -        write!(f, "{}", s)
> +        write!(f, "{s}")
>      }
>  }
>  
> @@ -158,7 +160,7 @@ impl fmt::Display for Bpos {
>  
>          let s = unsafe { CStr::from_ptr(buf.buf) };
>          let s = s.to_str().unwrap();
> -        write!(f, "{}", s)
> +        write!(f, "{s}")
>      }
>  }
>  
> diff --git a/bch_bindgen/src/sb_io.rs b/bch_bindgen/src/sb_io.rs
> index 46e17673..de6ee4ad 100644
> --- a/bch_bindgen/src/sb_io.rs
> +++ b/bch_bindgen/src/sb_io.rs
> @@ -1,5 +1,5 @@
>  use crate::bcachefs;
> -use crate::bcachefs::*;
> +use crate::bcachefs::{bch_opts, bch_sb_handle};
>  use crate::errcode::bch_errcode;
>  use crate::path_to_cstr;
>  use anyhow::anyhow;
> diff --git a/src/commands/mount.rs b/src/commands/mount.rs
> index 148d686e..07354d89 100644
> --- a/src/commands/mount.rs
> +++ b/src/commands/mount.rs
> @@ -74,7 +74,7 @@ fn mount_inner(
>                  src
>              );
>          } else {
> -            eprintln!("mount: {}: {}", src, e);
> +            eprintln!("mount: {src}: {e}");
>          }
>  
>          Err(e.into())
> @@ -211,15 +211,15 @@ fn get_devices_by_uuid(
>      opts: &bch_opts
>  ) -> anyhow::Result<Vec<(PathBuf, bch_sb_handle)>> {
>      let devices = {
> -        if !udev_bcachefs.is_empty() {
> +        if udev_bcachefs.is_empty() {
> +            get_all_block_devnodes()?
> +        } else {
>              let uuid_string = uuid.hyphenated().to_string();
>              if let Some(devices) = udev_bcachefs.get(&uuid_string) {
>                  devices.clone()
>              } else {
>                  Vec::new()
>              }
> -        } else {
> -            get_all_block_devnodes()?
>          }
>      };
>  
> @@ -351,7 +351,7 @@ pub struct Cli {
>      /// Path to passphrase file
>      ///
>      /// This can be used to optionally specify a file to read the passphrase
> -    /// from. An explictly specified key_location/unlock_policy overrides this
> +    /// from. An explictly specified `key_location/unlock_policy` overrides this
>      /// argument.
>      #[arg(short = 'f', long)]
>      passphrase_file: Option<PathBuf>,
> @@ -399,7 +399,7 @@ pub fn mount(mut argv: Vec<String>, symlink_cmd: Option<&str>) -> std::process::
>      logging::setup(cli.verbose, cli.colorize);
>  
>      match cmd_mount_inner(&cli) {
> -        Ok(_) => std::process::ExitCode::SUCCESS,
> +        Ok(()) => std::process::ExitCode::SUCCESS,
>          Err(e) => {
>              error!("Mount failed: {e}");
>              std::process::ExitCode::FAILURE
> diff --git a/src/key.rs b/src/key.rs
> index 8cf4f124..50cae47c 100644
> --- a/src/key.rs
> +++ b/src/key.rs
> @@ -175,9 +175,10 @@ impl Passphrase {
>  
>      // blocks indefinitely if no input is available on stdin
>      pub fn new_from_prompt(uuid: &Uuid) -> Result<Self> {
> -        match Self::new_from_askpassword(uuid) {
> -            Ok(phrase) => return phrase,
> -            Err(_) => debug!("Failed to start systemd-ask-password, doing the prompt ourselves"),
> +        if let Ok(phrase) = Self::new_from_askpassword(uuid) {
> +            return phrase;
> +        } else {
> +            debug!("Failed to start systemd-ask-password, doing the prompt ourselves")
>          }
>          let old = termios::tcgetattr(stdin())?;
>          let mut new = old.clone();
> @@ -219,7 +220,7 @@ impl Passphrase {
>      }
>  
>      fn derive(&self, crypt: &bch_sb_field_crypt) -> bch_key {
> -        let crypt_ptr = (crypt as *const bch_sb_field_crypt).cast_mut();
> +        let crypt_ptr = std::ptr::from_ref::<bch_sb_field_crypt>(crypt).cast_mut();
>  
>          unsafe { bcachefs::derive_passphrase(crypt_ptr, self.get().as_ptr()) }
>      }
> diff --git a/src/wrappers/handle.rs b/src/wrappers/handle.rs
> index b9a4a63d..3aec53ef 100644
> --- a/src/wrappers/handle.rs
> +++ b/src/wrappers/handle.rs
> @@ -42,7 +42,9 @@ pub enum BcachefsIoctlPayload {
>  impl From<&BcachefsIoctlPayload> for *const libc::c_void {
>      fn from(value: &BcachefsIoctlPayload) -> Self {
>          match value {
> -            BcachefsIoctlPayload::Subvolume(p) => (p as *const bch_ioctl_subvolume).cast(),
> +            BcachefsIoctlPayload::Subvolume(p) => {
> +                std::ptr::from_ref::<bch_ioctl_subvolume>(p).cast()
> +            }
>          }
>      }
>  }
> -- 
> 2.48.1
> 
