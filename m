Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC6B1F5439
	for <linux-bcachefs@vger.kernel.org>; Tue, 21 Jan 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482485; cv=none; b=GQQjHvW3fS7i466u6N+IrlTqqRESU5iLWG89q8CyyBSVOQ4XaH0a259+z3PnWtBAQIPeHOZTdgN05J8Y8GCy9v+baPr+1glD+JwG0XYfbgoPMLclbYZ/xDJhh19G0FND2q1yHUf8HQDB3ReLm/LynwNRaYjvFVm4NOFPvOcuqWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482485; c=relaxed/simple;
	bh=Xk5oqdS2gtxgKz4ztedQElivmDBfChOqk6GXmQvNFBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnD99o1RviyXrEItM6ax/dMVvL2MxXxnVmCdTdIJIj6wXq7jNRaYJB3Vn8sC3eXh/mUo/yEuEF8ou41Ws94ZJcODrQLeiXKk9O0iAbsCFgXYD86L2NRXMubE08FcM+WPfxmU2G6hxxSut67ogt5mIXH6+omp9AThcVrXc5IjCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wCND5AuU; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wCND5AuU"
Date: Tue, 21 Jan 2025 13:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737482470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKz/Gd/6u42hVa7mYFFaxfQHUvvNmDQc2ORTqqsuSms=;
	b=wCND5AuU3harMuKXGTvPUl9pfAyQfGGeKgsTDFMmCpDoaT1nC4a5Xu2Fm4BGUJUDwRn5Mn
	0xrrvwe4U4XdYVGNa4eC5FyhurF73vk8eAXeEiVX36/NyD8g3vKc6gU+wvmHws6ENuBg/q
	/rWZLNzfhhUNe0ocNJPDnLDbsSHhYVw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kernel build error due to large stack frame in
 __bch2_str_hash_check_key
Message-ID: <cj26hlynh6wiluvn5cg5qdzlcpxxyjirzgr3oho5244k7xzy4v@3p433x77w7nf>
References: <CAG48ez3_ROkVPgh2CDqL26RdVgfMJvgtmDHB5FMSdrQ7-POeHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3_ROkVPgh2CDqL26RdVgfMJvgtmDHB5FMSdrQ7-POeHg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 21, 2025 at 05:01:26PM +0100, Jann Horn wrote:
> Hi!
> 
> I'm trying to build the mainline kernel at commit
> 95ec54a420b8f445e04a7ca0ea8deb72c51fe1d3 (upstream git master), but
> the build fails with the following error:
> 
> ```
> [...]/fs/bcachefs/str_hash.c: In function ‘__bch2_str_hash_check_key’:
> [...]/fs/bcachefs/str_hash.c:295:1: error: the frame size of 2400
> bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
>   295 | }
>       | ^
> cc1: all warnings being treated as errors
> ```
> 
> I am building with "gcc (Debian 14.2.0-3+build3) 14.2.0", using the
> attached kernel config. I think this used to work with the mainline
> kernel before the 6.14 merge window opened.

Well, your kernel config has something that doubles stack frame size,
it's 1200 bytes here.

I'm pushing this to my master branch to reduce it further, it'll be in
the next pull request.


From f917016f69ba5a0c42a3a3327792707315f2a937 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Tue, 21 Jan 2025 12:56:00 -0500
Subject: [PATCH] bcachefs: Reduce stack frame size of
 __bch2_str_hash_check_key()

We don't need all the helpers inlined here.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index 8c2c5539de2e..d78451c2a0c6 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -31,11 +31,11 @@ static int bch2_dirent_has_target(struct btree_trans *trans, struct bkey_s_c_dir
 	}
 }
 
-static int fsck_rename_dirent(struct btree_trans *trans,
-			      struct snapshots_seen *s,
-			      const struct bch_hash_desc desc,
-			      struct bch_hash_info *hash_info,
-			      struct bkey_s_c_dirent old)
+static noinline int fsck_rename_dirent(struct btree_trans *trans,
+				       struct snapshots_seen *s,
+				       const struct bch_hash_desc desc,
+				       struct bch_hash_info *hash_info,
+				       struct bkey_s_c_dirent old)
 {
 	struct qstr old_name = bch2_dirent_get_name(old);
 	struct bkey_i_dirent *new = bch2_trans_kmalloc(trans, bkey_bytes(old.k) + 32);
@@ -71,11 +71,11 @@ static int fsck_rename_dirent(struct btree_trans *trans,
 	return bch2_fsck_update_backpointers(trans, s, desc, hash_info, &new->k_i);
 }
 
-static int hash_pick_winner(struct btree_trans *trans,
-			    const struct bch_hash_desc desc,
-			    struct bch_hash_info *hash_info,
-			    struct bkey_s_c k1,
-			    struct bkey_s_c k2)
+static noinline int hash_pick_winner(struct btree_trans *trans,
+				     const struct bch_hash_desc desc,
+				     struct bch_hash_info *hash_info,
+				     struct bkey_s_c k1,
+				     struct bkey_s_c k2)
 {
 	if (bkey_val_bytes(k1.k) == bkey_val_bytes(k2.k) &&
 	    !memcmp(k1.v, k2.v, bkey_val_bytes(k1.k)))
@@ -142,8 +142,8 @@ static int repair_inode_hash_info(struct btree_trans *trans,
  * All versions of the same inode in different snapshots must have the same hash
  * seed/type: verify that the hash info we're using matches the root
  */
-static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inum,
-					      struct bch_hash_info *hash_info)
+static noinline int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inum,
+						       struct bch_hash_info *hash_info)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
