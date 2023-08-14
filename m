Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171F2C04A6A
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 01:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjHNBZT (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 21:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjHNBYr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 21:24:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F8F5
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3159d5e409dso2839212f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691976285; x=1692581085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w29Os0whbP+QGRAWOByOJrpYHNRbRm4EUfBgz2p0L4=;
        b=FNGzfQM31iOsb5VvAlE9psR5lwZ5UqSBvc8YlDblqohDcM4p0YkM7Eq/c16tR5bdW/
         nVGX1AIbBK35UkGDVCtLcuzzaXx6FOhDsPPcSXn1LV/m1V2LCT4XdGoSp03Pe3ga00LO
         YrawrTZH+pspnHkiap5nKuPidfBQ/DLhRs+JmN/BXklU1LAtPlHFvyi2DKGePuJ/kw/T
         NRqj3jvouKeBB/d2WTZ3eSBkfTGxwpDXydKR/wItnpfeaOLCVfxwAHP4RWLkirzW9d0S
         rGSKgvQknc3ObNdLbhlkoZ8MYcALzmFJLk/v5tU++Gv9N8PPC7fTYU4z8+ot6cA7Qj5+
         v0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691976285; x=1692581085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w29Os0whbP+QGRAWOByOJrpYHNRbRm4EUfBgz2p0L4=;
        b=agdHTj2cHpGM2VvqfVFxjGELhYVXnyM3qSWS9HyIPRJbXaXsq7ckxZx+Ojl55YJUQz
         P2/RpVh6C5lNXvtd6NiKm0rUVOB7NgT9vxt51rLfAbHDHmX59OPsrEqA+7x5wXYxIOxq
         xtZc0BiWah09dWyL6e/uMWBAeUW0ctSGmqRONl0SYnCFxBnnXDUny8GTmMEZWjxfxAKY
         0RMLdowntZd7a7n55Xo0gYfg/6GNgoXXTBAHKkIN9h76MS9sOyZBSwYUXcWyXZSJdV0X
         NmEFGPXBD8Ykdebf0vK+cgpL5x6HTHABe2OeCTivTZm4ubUflq4u1N8WXFxJdk7x8lL4
         ZLPA==
X-Gm-Message-State: AOJu0Yzfj2FVLoVOLPPaev4o3fwxr+EzrGMyXbz3U/VbxUxE30uKhU+g
        6+phIpMq7/XPBY82KaE1hd+cDTpbF9AVmdyUQOk=
X-Google-Smtp-Source: AGHT+IG0DZoTg6D74GvRRe45s1n1cpAqmmkaqMUZFp60HZNV0IgRV6x8aKzgrN7cHYuP07wDfB8UrQ==
X-Received: by 2002:a5d:4350:0:b0:317:dcdd:3fa2 with SMTP id u16-20020a5d4350000000b00317dcdd3fa2mr5367680wrr.31.1691976284954;
        Sun, 13 Aug 2023 18:24:44 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d4d42000000b00317ca89f6c5sm12802076wru.107.2023.08.13.18.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 18:24:44 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v4 1/3] bcachefs: Split out dirent alloc and name initialization
Date:   Mon, 14 Aug 2023 02:24:25 +0100
Message-ID: <20230814012434.627641-2-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814012434.627641-1-joshua@froggi.es>
References: <20230814012434.627641-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Splits out the code that allocates the dirent and initializes the name
to make things easier to implement casefolding in a future commit.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/dirent.c | 46 ++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index a7559ab03802..85769d5c6b82 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -169,15 +169,13 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 	       bch2_d_type_str(d.v->d_type));
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
 
@@ -197,11 +195,35 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 
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
2.41.0

