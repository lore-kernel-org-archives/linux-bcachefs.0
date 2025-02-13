Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B0245AF3
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472392; cv=none; b=kqUXC1zmyC3UDSpWddtzbEuo8oIMdvOnJFEn4YyRMgTMuzbyktAquSrImcgtTo3t1E9CQsnXizqqCWt5Br/I5JIsCBDU4lZEdNgj1yx/rIJ9Giw92V2BB2u0146TErjTluGqk7VQB8w66XE6tnPxLJgVbaN45T55bubiDLErDrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472392; c=relaxed/simple;
	bh=GM4uy906ioiX27fmg4ebWTLBIg5czce0VhsnVg+IRdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOC5FfXjNLkuuk9XCGbw2klWrlqq7FY3vmqQoFFFPErE9BrrDX+wtLTCrcIGs1DutyoSO5KBuNnLYV2yCgmpco0MK0+By5zB7etk4YJeJUA4RyZAJrMpTCGWSLG4+FCWab5cAV/z+1yV5HMwl4fd0OelUn7TKu4mu/qfWPLHv4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dt7rLyy4; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dt7rLyy4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xaob+qOiLozqaJHvm6PuBIwNZfpj7QcBbIe8yFAyfxI=;
	b=Dt7rLyy45jKd4PkunDh3H+Q9s+lIQZ8gaqcnOYc/48h86gLwKTFHJms5I0z2qz42z4/8QG
	BOK8UCczLuJdEtNX5xzn6JbzBT5bjzzLbnx3mzWfNgKIwZRQqkn8uLegWrEvpLNAcV2lml
	5vOJJDxjqZfoswW++eZOY5Zermil/fo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Joshua Ashton <joshua@froggi.es>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 17/18] bcachefs: Split out dirent alloc and name initialization
Date: Thu, 13 Feb 2025 13:46:02 -0500
Message-ID: <20250213184607.18237-18-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Joshua Ashton <joshua@froggi.es>

Splits out the code that allocates the dirent and initializes the name
to make things easier to implement casefolding in a future commit.

Signed-off-by: Joshua Ashton <joshua@froggi.es>

Cc: André Almeida <andrealmeid@igalia.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/dirent.c | 46 ++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 27737aaa03a6..7dcc18000726 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -163,15 +163,13 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	prt_printf(out, " type %s", bch2_d_type_str(d.v->d_type));
 }
 
-static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
-				subvol_inum dir, u8 type,
-				const struct qstr *name, u64 dst)
+static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
+				subvol_inum dir,
+				u8 type,
+				int name_len, u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name->len);
-
-	if (name->len > BCH_NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
+	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len);
 
 	BUG_ON(u64s > U8_MAX);
 
@@ -191,11 +189,35 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 
 	dirent->v.d_type = type;
 
-	memcpy(dirent->v.d_name, name->name, name->len);
-	memset(dirent->v.d_name + name->len, 0,
-	       bkey_val_bytes(&dirent->k) -
-	       offsetof(struct bch_dirent, d_name) -
-	       name->len);
+	return dirent;
+}
+
+static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
+				     const struct qstr *name)
+{
+	memcpy(&dirent->v.d_name[0], name->name, name->len);
+	memset(&dirent->v.d_name[name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_name) -
+		name->len);
+}
+
+static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
+				subvol_inum dir,
+				u8 type,
+				const struct qstr *name,
+				u64 dst)
+{
+	struct bkey_i_dirent *dirent;
+
+	if (name->len > BCH_NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	dirent = dirent_alloc_key(trans, dir, type, name->len, dst);
+	if (IS_ERR(dirent))
+		return dirent;
+
+	dirent_init_regular_name(dirent, name);
 
 	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
 
-- 
2.45.2

