Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC527C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 14:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjHLOuY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHLOuW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 10:50:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD64B1B5
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:24 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-317c3ac7339so2470687f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691851823; x=1692456623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=65NvxT3UaWTaWbNWDX1AwEQ/snxdbSp4rbsNHvdhqdI=;
        b=V+0jFA8imnAKdyCQk1PtykxYCkPdltL1Qk053KohwEwoKEvFcvWsaXvDTOKgjh4uhw
         R+TtKxwG31462oer7bzgWJULLNbwV4UCAxAn608xJuO/WvBu4WBkKhrRP1vsWD0d3a06
         Z4zQ+1TaGLoXFIB8TL4rZ0Kr7imZi7SUyZK8rsycYO6jwozUNcre6x8kwmqW7XgswMdx
         6Em8RcXA1aluvOBIRY864RCziWYuHWZfxMKeTlcQRlyN5yyW/1auIIum3OfnESZgX+JG
         8WIuNwnb3oqe3Maye/ln99Nh5zsrspFASqyeasyc9dGlSXmpUYppV5cLygeXjlDpBp4E
         RRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691851823; x=1692456623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65NvxT3UaWTaWbNWDX1AwEQ/snxdbSp4rbsNHvdhqdI=;
        b=BB8Z662q9l5/doVXpoxqY6BCgMMp+a11GCXPe6O3iYp7URDRODhLwasMD0C8W1HQWN
         itwBC8HtUFCPcKlsxs5IyyUpxkFpXnZWOukHTiZbtwwCggNDazhihi6seUO6Shx2nWnF
         BsS4cXsOOt/NIocNbH0telcEZo/MkjGQQIHa42L65tlrqHXS6nErbXWjTQB6rpug947x
         btiFZAfPYV2vl1H3TlSnXIDbd138A/ffgiKCKFWvpNl9vA0MQYCmg2dlVAmGs7nyfX8f
         c/33A3BT/8tuFidMVsvZUn+CBzNDyFh0o2GocOxVgeq2PMCDb2UFrxFa00RJUHrZozkg
         Fwow==
X-Gm-Message-State: AOJu0YxA/YRBuH5kq7wmOX6YX1/cGjc19EUYKSxdHUwpY9+uLGgHrUG1
        cKV2L9k74R/UZKhAXoQ9E5+w42JZPooCnkNyRlk=
X-Google-Smtp-Source: AGHT+IEd5rV4LlMvewuSJOTcTWtvNRnvITeAiFJFePBu3nYHaXUiiAlY8stS7XdprHraxX4wOkz/Pw==
X-Received: by 2002:a5d:5584:0:b0:317:6ef1:7939 with SMTP id i4-20020a5d5584000000b003176ef17939mr3580199wrv.23.1691851823250;
        Sat, 12 Aug 2023 07:50:23 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id w17-20020adfee51000000b00317eee26bf0sm8771784wro.69.2023.08.12.07.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 07:50:23 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [PATCH 1/4] bcachefs: Add btree_trans* to inode_set_fn
Date:   Sat, 12 Aug 2023 15:47:45 +0100
Message-ID: <20230812145017.259609-1-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This will be used when we need to re-hash a directory tree when setting
flags.

It is not possible to have concurrent btree_trans on a thread.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/fs-io.c    | 12 ++++++++----
 fs/bcachefs/fs-ioctl.c | 11 +++++++----
 fs/bcachefs/fs.c       |  5 +++--
 fs/bcachefs/fs.h       |  3 ++-
 fs/bcachefs/xattr.c    |  3 ++-
 5 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 963c7971d495..4804e5a47ac9 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -109,7 +109,8 @@ struct inode_new_size {
 	unsigned	fields;
 };
 
-static int inode_set_size(struct bch_inode_info *inode,
+static int inode_set_size(struct btree_trans *trans,
+			  struct bch_inode_info *inode,
 			  struct bch_inode_unpacked *bi,
 			  void *p)
 {
@@ -390,7 +391,8 @@ static int bch2_extend(struct mnt_idmap *idmap,
 	return bch2_setattr_nonsize(idmap, inode, iattr);
 }
 
-static int bch2_truncate_finish_fn(struct bch_inode_info *inode,
+static int bch2_truncate_finish_fn(struct btree_trans *trans,
+				   struct bch_inode_info *inode,
 				   struct bch_inode_unpacked *bi,
 				   void *p)
 {
@@ -398,7 +400,8 @@ static int bch2_truncate_finish_fn(struct bch_inode_info *inode,
 	return 0;
 }
 
-static int bch2_truncate_start_fn(struct bch_inode_info *inode,
+static int bch2_truncate_start_fn(struct btree_trans *trans,
+				  struct bch_inode_info *inode,
 				  struct bch_inode_unpacked *bi, void *p)
 {
 	u64 *new_i_size = p;
@@ -519,7 +522,8 @@ int bch2_truncate(struct mnt_idmap *idmap,
 
 /* fallocate: */
 
-static int inode_update_times_fn(struct bch_inode_info *inode,
+static int inode_update_times_fn(struct btree_trans *trans,
+				 struct bch_inode_info *inode,
 				 struct bch_inode_unpacked *bi, void *p)
 {
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index dfa1bf73c854..141bcced031e 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -31,7 +31,8 @@ struct flags_set {
 	bool			projinherit;
 };
 
-static int bch2_inode_flags_set(struct bch_inode_info *inode,
+static int bch2_inode_flags_set(struct btree_trans *trans,
+				struct bch_inode_info *inode,
 				struct bch_inode_unpacked *bi,
 				void *p)
 {
@@ -124,7 +125,8 @@ static int bch2_ioc_fsgetxattr(struct bch_inode_info *inode,
 	return copy_to_user(arg, &fa, sizeof(fa));
 }
 
-static int fssetxattr_inode_update_fn(struct bch_inode_info *inode,
+static int fssetxattr_inode_update_fn(struct btree_trans *trans,
+				      struct bch_inode_info *inode,
 				      struct bch_inode_unpacked *bi,
 				      void *p)
 {
@@ -135,7 +137,7 @@ static int fssetxattr_inode_update_fn(struct bch_inode_info *inode,
 		bi->bi_project = s->projid;
 	}
 
-	return bch2_inode_flags_set(inode, bi, p);
+	return bch2_inode_flags_set(trans, inode, bi, p);
 }
 
 static int bch2_ioc_fssetxattr(struct bch_fs *c,
@@ -192,7 +194,8 @@ static int bch2_ioc_fssetxattr(struct bch_fs *c,
 	return ret;
 }
 
-static int bch2_reinherit_attrs_fn(struct bch_inode_info *inode,
+static int bch2_reinherit_attrs_fn(struct btree_trans *trans,
+				   struct bch_inode_info *inode,
 				   struct bch_inode_unpacked *bi,
 				   void *p)
 {
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 925f5e52029b..eb5da358871b 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -92,7 +92,7 @@ int __must_check bch2_write_inode(struct bch_fs *c,
 
 	ret   = bch2_inode_peek(&trans, &iter, &inode_u, inode_inum(inode),
 				BTREE_ITER_INTENT) ?:
-		(set ? set(inode, &inode_u, p) : 0) ?:
+		(set ? set(&trans, inode, &inode_u, p) : 0) ?:
 		bch2_inode_write(&trans, &iter, &inode_u) ?:
 		bch2_trans_commit(&trans, NULL, NULL, BTREE_INSERT_NOFAIL);
 
@@ -1414,7 +1414,8 @@ static void bch2_destroy_inode(struct inode *vinode)
 	call_rcu(&vinode->i_rcu, bch2_i_callback);
 }
 
-static int inode_update_times_fn(struct bch_inode_info *inode,
+static int inode_update_times_fn(struct btree_trans *trans,
+				 struct bch_inode_info *inode,
 				 struct bch_inode_unpacked *bi,
 				 void *p)
 {
diff --git a/fs/bcachefs/fs.h b/fs/bcachefs/fs.h
index 6170d214d648..10e11119ded2 100644
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -174,7 +174,8 @@ static inline int bch2_set_projid(struct bch_fs *c,
 struct inode *bch2_vfs_inode_get(struct bch_fs *, subvol_inum);
 
 /* returns 0 if we want to do the update, or error is passed up */
-typedef int (*inode_set_fn)(struct bch_inode_info *,
+typedef int (*inode_set_fn)(struct btree_trans *,
+			    struct bch_inode_info *,
 			    struct bch_inode_unpacked *, void *);
 
 void bch2_inode_update_after_write(struct btree_trans *,
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 70f78006daf2..6f6b3caf0607 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -494,7 +494,8 @@ struct inode_opt_set {
 	bool			defined;
 };
 
-static int inode_opt_set_fn(struct bch_inode_info *inode,
+static int inode_opt_set_fn(struct btree_trans *trans,
+			    struct bch_inode_info *inode,
 			    struct bch_inode_unpacked *bi,
 			    void *p)
 {
-- 
2.41.0

