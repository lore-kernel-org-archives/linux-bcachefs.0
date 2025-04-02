Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE66AA7
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743610980; cv=none; b=k2udOu6/IHAA8alhKAf3OmFu+oM1fo51uN5sCjoUHFH9LC1Y1dJX0ChcMiDeoqINsjdFx9f/N6ZggvZ4FDZNiNu/GkJwNJEkFuSOS/UOLycqFJR8tp2pM+q4XF0iPuxttL9eTGdVzG5HjnHGizULvRH/zBJ/kxtOVzjVxpkTQw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743610980; c=relaxed/simple;
	bh=pQ5817p68qc5PGlqR/zXpM88GDYnw2ZuZoUXL4I1lKE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uqHadfKaFWwuJ8DxeuesmaxQTFVcs54XYeZXwiI/2+1R4JBfu4XrgFCUp8Z/DWHEr2ml7Dy2MMa9OVKSVOF6f9yfR04m9hOd3mkySc5l1K10/Z8yolm/qxjCRUaGUyic7pU6BbQeGvyv6YRZCztTUmuaXl1x8xiMyLZTrC55GPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDRXmaKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDRXmaKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337DFC4CEF0;
	Wed,  2 Apr 2025 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743610980;
	bh=pQ5817p68qc5PGlqR/zXpM88GDYnw2ZuZoUXL4I1lKE=;
	h=From:To:Subject:Date:From;
	b=VDRXmaKZvs4OAX0wa+dOc6ItsjLVFplNbDAzhmGfUQttAKusZWvhO3c6y7mPApDLX
	 CKuzKVqe4lRoaLaZy+tAFjaIED7+hU2YXvUvjH8pF98pBNp6BrdnLpLhRZM406uwyA
	 GRcN/WTX04No+ILXjQE/xKSXN6iL8EssvXZkXvwGi5WDvRwhW0e/VZIFkKdxfbvcZi
	 UO0DFsAreDVKpRH4kt0wtap65FiHhI6IkY7WgoZmzC5OUTQrhqOtHdO/bjOhaTZUyO
	 s0BzXKSuFN7GeAf46r0KoZMJpZV5dRyiV6KI+S3MuniN1cVQ6ZoT/wCFmzqcMej1eo
	 KvcPkuAyVlCrw==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Remove unused variable from bch2_fs_encryption_init()
Date: Wed,  2 Apr 2025 09:22:56 -0700
Message-ID: <20250402162256.24122-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The 'key' local variable is no longer used, now that the key is being
written directly to the struct bch_fs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Please feel free to fold this into 
"bcachefs: use library APIs for ChaCha20 and Poly1305".

 fs/bcachefs/checksum.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 7d1e3b908eecd..d0a34a097b809 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -682,20 +682,17 @@ void bch2_fs_encryption_exit(struct bch_fs *c)
 }
 
 int bch2_fs_encryption_init(struct bch_fs *c)
 {
 	struct bch_sb_field_crypt *crypt;
-	struct bch_key key;
-	int ret = 0;
+	int ret;
 
 	crypt = bch2_sb_field_get(c->disk_sb.sb, crypt);
 	if (!crypt)
-		goto out;
+		return 0;
 
 	ret = bch2_decrypt_sb_key(c, crypt, &c->chacha20_key);
 	if (ret)
-		goto out;
+		return ret;
 	c->chacha20_key_set = true;
-out:
-	memzero_explicit(&key, sizeof(key));
-	return ret;
+	return 0;
 }

base-commit: 04c4768d24f70d457ff49681ef726d5d23c089a5
-- 
2.49.0

