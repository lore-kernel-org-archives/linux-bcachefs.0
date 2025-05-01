Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B722FAC3;
	Thu,  1 May 2025 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746129704; cv=none; b=WQhURGCbOE9AE+my5+66eh8t9JtZg8LgaVXZat9m1FJ0JirmGnt5riWbgpyEjcOudghT/HcO5MLfLyFFlhnE2Ik/AyjCAy91Pbi384yWxAq95G3jtVYFogS/wutQFormA6Ki6zQK1XwJZei32OvS5EhJauUX37oGl8IDUJqPOLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746129704; c=relaxed/simple;
	bh=FUKNT3MbsOtF9PFisFIkTz8jinXzc0y4+0Coxy3aDAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfRgqdxRqOitLbwY7+o7ygE43Vygube227QJ5eakA+EDGkc5mlTGDmmb2pilZtenD/WtI1giuW3lsmiYU/Lo79BQyD6fX2JKIsYDD8K5B6Yn95nIo8UHD3+GQVjw4ZAOaFIwx8ICYMby0PKz4zL86IHbEIoVKsI+Jul3t0/9nGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdUJuXVc; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdUJuXVc"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-af548cb1f83so1394684a12.3;
        Thu, 01 May 2025 13:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746129702; x=1746734502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2MIc4tQj8QW7fDnJLMAFQ1Cx+Ge0NNlr+7xk0G0L8U=;
        b=hdUJuXVcgDJPE+V47d2kPs2+XHdl0fnD4MKhq7y+whzQHtF6lkCRNpsvaxiacAyliN
         0azw5rV8curu44OJwI20ODiQprFivx7dhEw5o4bl/Vwa45FKGynCTmLF6AuHUY0fvZb2
         HkPLGDd5exqDscusOx9LQuiym4FQ9m3vdBm8OCnv5w7TdBQBzo30nVkv4PZMYxE9lyUc
         9eaJ6iL9ImW0dLS7Uk1z2oyn+sPYmheqlh+JFheEkCc0y+Zz6/gu3SlD8H2XQoxdDix7
         kwcFj3QjXdsLIwU3UUjf9PdQCSvVVRKEiG9WuDCzgVEzOsRRcKjITM3NBzXVD9sVsfCI
         DyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746129702; x=1746734502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P2MIc4tQj8QW7fDnJLMAFQ1Cx+Ge0NNlr+7xk0G0L8U=;
        b=N3B/Ja6ukeoGfgyDSXyqHkO0wavCHX5ppx9siSWaQUSmFxP3a2VLQLp+ahIYgJSlzd
         jeoC2bUE38rgypgVAsajYvCjYyXCxBgAkZ7C68kGHZ48l9xrIr4cxzo5D2y+yWlsylBZ
         7nLoDNe1y8TZSL7qSt6WXEogPkVYKbEGXAioc8R5U5HMvAF5UwrA3KwfkHX6g+MZXuj6
         qm4l25RrPHTAiQVmUIaJQIytsMdFgq+l/ES1PPPhWyssK9YkmFQJA4glJVNdym7COn8Z
         XQ/QgO/NmtWXpZvKWMfesKG7bHY+TYl3n4zG9IdxQyGFggt1SGrRkQUKSx73xB2KewA0
         OsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwnXBokRvVmXc/VtlEPadqKh/pEtB6+XFMQ5+E8HXuXfiWuhQHeul6rkgsdq6+EtrUTC3/VvO9dVAOv0WCgy8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz07+YTw/qV9mLTHIyi8yUlhbpwTco6BLwafXSuuXMA7AnTj1dz
	LjQXGiTOpZsf4lKN0aIF0pXFzSoydCCXAKdXtTqnY5wqE4OeEEaz
X-Gm-Gg: ASbGncujrCT+a2qv0oniZXRqfMawger5TT3nJNTlmRIYA2yAnLB6Q/XgdXmQWNAodoh
	6157/PfvMMDIY/QeoOkingTf44DOsGrrG9kju1ZndvKY8i7Bak0EEbUaDH2vE4/OQemLvO74uy/
	9EZideBizuqYtJDOAIDpvU0pGZixQnn5D2end2qE+IjZ+xpwovEbHFhVzWO59T4hFWJTtkT+CnD
	uLsgOxP8bzPWN19GpRRz7Cj0G380mhVdbZThJd+IeM+xAV6evk7M3jbaXzytbibHlGHqf+6AZQZ
	gc8yLgGHK0Lg7DQ=
X-Google-Smtp-Source: AGHT+IHq21CS+RKUmnMEGiVQt9kBN8rB+rVUmjxokYrq73J/mlPkdCAQFDJeFreSKTL061+QBxCwhQ==
X-Received: by 2002:a17:90a:7788:b0:30a:4f0d:a6e7 with SMTP id 98e67ed59e1d1-30a4f0dad3cmr185417a91.14.1746129701991;
        Thu, 01 May 2025 13:01:41 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4745f920sm1319657a91.8.2025.05.01.13.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:01:41 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	thorsten.blum@toblux.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Rename x_name to x_name_and_value
Date: Fri,  2 May 2025 04:01:32 +0800
Message-ID: <20250501200132.216859-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250501200132.216859-1-mmpgouride@gmail.com>
References: <20250501200132.216859-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flexible array contains name and value, the x_name is misleading.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/xattr.c        | 16 ++++++++--------
 fs/bcachefs/xattr.h        |  4 ++--
 fs/bcachefs/xattr_format.h |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 3d324e485ee9..b8bc2fb04f15 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -38,7 +38,7 @@ static u64 xattr_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 	struct bkey_s_c_xattr x = bkey_s_c_to_xattr(k);
 
 	return bch2_xattr_hash(info,
-		 &X_SEARCH(x.v->x_type, x.v->x_name, x.v->x_name_len));
+		 &X_SEARCH(x.v->x_type, x.v->x_name_and_value, x.v->x_name_len));
 }
 
 static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
@@ -48,7 +48,7 @@ static bool xattr_cmp_key(struct bkey_s_c _l, const void *_r)
 
 	return l.v->x_type != r->type ||
 		l.v->x_name_len != r->name.len ||
-		memcmp(l.v->x_name, r->name.name, r->name.len);
+		memcmp(l.v->x_name_and_value, r->name.name, r->name.len);
 }
 
 static bool xattr_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
@@ -58,7 +58,7 @@ static bool xattr_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 
 	return l.v->x_type != r.v->x_type ||
 		l.v->x_name_len != r.v->x_name_len ||
-		memcmp(l.v->x_name, r.v->x_name, r.v->x_name_len);
+		memcmp(l.v->x_name_and_value, r.v->x_name_and_value, r.v->x_name_len);
 }
 
 const struct bch_hash_desc bch2_xattr_hash_desc = {
@@ -96,7 +96,7 @@ int bch2_xattr_validate(struct bch_fs *c, struct bkey_s_c k,
 			 c, xattr_invalid_type,
 			 "invalid type (%u)", xattr.v->x_type);
 
-	bkey_fsck_err_on(memchr(xattr.v->x_name, '\0', xattr.v->x_name_len),
+	bkey_fsck_err_on(memchr(xattr.v->x_name_and_value, '\0', xattr.v->x_name_len),
 			 c, xattr_name_invalid_chars,
 			 "xattr name has invalid characters");
 fsck_err:
@@ -120,13 +120,13 @@ void bch2_xattr_to_text(struct printbuf *out, struct bch_fs *c,
 	unsigned name_len = xattr.v->x_name_len;
 	unsigned val_len  = le16_to_cpu(xattr.v->x_val_len);
 	unsigned max_name_val_bytes = bkey_val_bytes(xattr.k) -
-		offsetof(struct bch_xattr, x_name);
+		offsetof(struct bch_xattr, x_name_and_value);
 
 	val_len  = min_t(int, val_len, max_name_val_bytes - name_len);
 	name_len = min(name_len, max_name_val_bytes);
 
 	prt_printf(out, "%.*s:%.*s",
-		   name_len, xattr.v->x_name,
+		   name_len, xattr.v->x_name_and_value,
 		   val_len,  (char *) xattr_val(xattr.v));
 
 	if (xattr.v->x_type == KEY_TYPE_XATTR_INDEX_POSIX_ACL_ACCESS ||
@@ -202,7 +202,7 @@ int bch2_xattr_set(struct btree_trans *trans, subvol_inum inum,
 		xattr->v.x_type		= type;
 		xattr->v.x_name_len	= namelen;
 		xattr->v.x_val_len	= cpu_to_le16(size);
-		memcpy(xattr->v.x_name, name, namelen);
+		memcpy(xattr->v.x_name_and_value, name, namelen);
 		memcpy(xattr_val(&xattr->v), value, size);
 
 		ret = bch2_hash_set(trans, bch2_xattr_hash_desc, hash_info,
@@ -270,7 +270,7 @@ static int bch2_xattr_emit(struct dentry *dentry,
 	if (!prefix)
 		return 0;
 
-	return __bch2_xattr_emit(prefix, xattr->x_name, xattr->x_name_len, buf);
+	return __bch2_xattr_emit(prefix, xattr->x_name_and_value, xattr->x_name_len, buf);
 }
 
 static int bch2_xattr_list_bcachefs(struct bch_fs *c,
diff --git a/fs/bcachefs/xattr.h b/fs/bcachefs/xattr.h
index 132fbbd15a66..1139bf345f70 100644
--- a/fs/bcachefs/xattr.h
+++ b/fs/bcachefs/xattr.h
@@ -18,12 +18,12 @@ void bch2_xattr_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 static inline unsigned xattr_val_u64s(unsigned name_len, unsigned val_len)
 {
-	return DIV_ROUND_UP(offsetof(struct bch_xattr, x_name) +
+	return DIV_ROUND_UP(offsetof(struct bch_xattr, x_name_and_value) +
 			    name_len + val_len, sizeof(u64));
 }
 
 #define xattr_val(_xattr)					\
-	((void *) (_xattr)->x_name + (_xattr)->x_name_len)
+	((void *) (_xattr)->x_name_and_value + (_xattr)->x_name_len)
 
 struct xattr_search_key {
 	u8		type;
diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
index 67426e33d04e..4121b78d9a92 100644
--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -16,10 +16,10 @@ struct bch_xattr {
 	/*
 	 * x_name contains the name and value counted by
 	 * x_name_len + x_val_len. The introduction of
-	 * __counted_by(x_name_len) caused a false positive
+	 * __counted_by(x_name_len) previously caused a false positive
 	 * detection of an out of bounds write.
 	 */
-	__u8			x_name[];
+	__u8			x_name_and_value[];
 } __packed __aligned(8);
 
 #endif /* _BCACHEFS_XATTR_FORMAT_H */
-- 
2.48.1

