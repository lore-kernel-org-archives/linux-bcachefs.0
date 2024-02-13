Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F6D13AD4
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707810646; cv=none; b=Gl2OYTEDCE3R1/2ToAAi505YekxRUPyBFa0wlQjt70tUlFrMgYgK7VMEejGHdlGQfw6bT2ZppN5Kq58cCcfS7pPfF5RND1kFBt7PEA2z7VUF3G6Yy6wSefOzNLU+zlmxleasUgJDl2NraxNmiw8G6juszQ8EBGQjPfir/dPEwLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707810646; c=relaxed/simple;
	bh=fRnpp0pooZ9Kb6HVV2cPKZrqXg+YDAAO4UdMAyiY2IM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oMAARnj8Z0BuPI6arWuNJAyNZv1Tu46QVwpYaJDJoT5hq+BAzCKP7FaV0bf29QAxrCFSoF2hOVwChy0DnYfpYIAteHwLwYCdw7mboTf/2uGDvIIPHOmOjzfjB1b/oSpEcHfS6V7O2T8ZxVK+4E2wkO8CZRiIMYeMDFol5g/bPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtjGM6BJ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtjGM6BJ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso3776640a12.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Feb 2024 23:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707810644; x=1708415444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O/cQ3rMbG1MPBE5giriJpPq/R9YBRI5n+KI6dif493c=;
        b=VtjGM6BJ9Ply7opwxxescVkbaQ1wU46H1fHuPaE5jrVGDSjmdg+VryX/sDLvIn3rgS
         hgQXAzyc8qNETRvn0J+91m/0BrzLt+szdvcKvYyuua8LOYYesYgsR2/U4y7fooOW1T06
         suYZvGKCBHR3Sb0UPQHeuCLlArSafDksf8L/du5MJAnAR5oJtZdefqkFDPPts9gXJ3/K
         fZVUn4BY0vHD1OX7f1h375vsxlOvvWcM1mnfXKTdFiYjDHlvbUJaCTz0nHEkuoAur0TP
         mh2SyjAgJ+OoZfVCi7sc+1sgqtG6l89xuLYan0hlk+FEvOG65wzFxGiV/WfXRRymvplw
         Nn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707810644; x=1708415444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/cQ3rMbG1MPBE5giriJpPq/R9YBRI5n+KI6dif493c=;
        b=jBo7itowDaV37/RJ6YFD49C8BcMqyBleaGpZUdUyepQyzF0Me0XAjOJVevEgPWf15R
         dULi7kDz1Aw29Pk9AZyx8kOI3ay5AAmJ7Ot+ZAK7VxreGvGmyfl1bzse+dVqhYiwZtPB
         cGFJK+71+4+Yyfr9TaXVuRcslmyd+qPdSzIrhVBkoVq/cJ9tu8W3fG2QIO2XsiJimxdn
         XjVt8s+CEAnzTB39v8CLE2Z4wAm5uPVmCOwZX6fSgKzE00Zmnn1db2MCJctytzXFxvLa
         DqlKWMzKzogvH4appqz3Pwad/3uLaVbpNusSo+DDXJswD4rMElWr23MKwTqHmPtxhRew
         WCBQ==
X-Gm-Message-State: AOJu0YzRgzyIxDZRYXkiF/7Pz3XvI5gsyGXqptmWVOC6xEjjd+aQ+aFw
	ev+zo4ThyNL5WU4fVPJECs/vfaZ4Kz85Vvwiqi307vqoCrOgWbi6elw+WYZkpYwzvsiI
X-Google-Smtp-Source: AGHT+IHb344j0njiuJlcihBAXnTlt4GNLDS8v+4deR9vzmBv65Wsw4mMey5BIxVWTqaDHQ8kstLPjA==
X-Received: by 2002:a05:6a20:9f9a:b0:19e:b614:48ad with SMTP id mm26-20020a056a209f9a00b0019eb61448admr8039142pzb.5.1707810643993;
        Mon, 12 Feb 2024 23:50:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUvUNVY0SjLQfoeKChxmyYYYMN9/RyADQ13YTNNhjbnT0oC5Lj3cuicPpPHDSFRPxt5V7ZTzRRdPit1p1K4eU6V
Received: from localhost.localdomain ([8.218.212.108])
        by smtp.gmail.com with ESMTPSA id p14-20020a170902e74e00b001d9a40e204bsm1496566plf.21.2024.02.12.23.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 23:50:43 -0800 (PST)
From: Guoyu Ou <benogy@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Guoyu Ou <benogy@gmail.com>
Subject: [PATCH v2] bcachefs: skip invisible entries in empty subvolume checking
Date: Tue, 13 Feb 2024 15:50:29 +0800
Message-ID: <20240213075030.45296-1-benogy@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we are checking whether a subvolume is empty in the specified snapshot,
entries that do not belong to this subvolume should be skipped.

This fixes the following case:

    $ bcachefs subvolume create ./sub
    $ cd sub
    $ bcachefs subvolume create ./sub2
    $ bcachefs subvolume snapshot . ./snap
    $ ls -a snap
    . ..
    $ rmdir snap
    rmdir: failed to remove 'snap': Directory not empty

As Kent suggested, we pass 0 in may_delete_deleted_inode() to ignore subvols
in the subvol we want to deleted, because inode.bi_subvol is only set on
subvolume roots, and we can't go through every inode in the subvolume and
change bi_subvol when taking a snapshot. It makes the check less strict, but
that's ok, the rest of fsck will still catch it.

Signed-off-by: Guoyu Ou <benogy@gmail.com>
---
 fs/bcachefs/dirent.c | 7 +++++--
 fs/bcachefs/dirent.h | 2 +-
 fs/bcachefs/inode.c  | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 4ae1e9f002a0..82c5bff01411 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -508,7 +508,7 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
 	return ret;
 }
 
-int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
+int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 subvol, u32 snapshot)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -518,6 +518,9 @@ int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 snapshot)
 			   SPOS(dir, 0, snapshot),
 			   POS(dir, U64_MAX), 0, k, ret)
 		if (k.k->type == KEY_TYPE_dirent) {
+			struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
+			if (d.v->d_type == DT_SUBVOL && le32_to_cpu(d.v->d_parent_subvol) != subvol)
+				continue;
 			ret = -ENOTEMPTY;
 			break;
 		}
@@ -531,7 +534,7 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
 	u32 snapshot;
 
 	return bch2_subvolume_get_snapshot(trans, dir.subvol, &snapshot) ?:
-		bch2_empty_dir_snapshot(trans, dir.inum, snapshot);
+		bch2_empty_dir_snapshot(trans, dir.inum, dir.subvol, snapshot);
 }
 
 int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index 21ffeb78f02e..aeb8207ca9f2 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -69,7 +69,7 @@ u64 bch2_dirent_lookup(struct bch_fs *, subvol_inum,
 		       const struct bch_hash_info *,
 		       const struct qstr *, subvol_inum *);
 
-int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32);
+int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32, u32);
 int bch2_empty_dir_trans(struct btree_trans *, subvol_inum);
 int bch2_readdir(struct bch_fs *, subvol_inum, struct dir_context *);
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 086f0090b03a..84a6e5011032 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 		goto out;
 
 	if (S_ISDIR(inode.bi_mode)) {
-		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
+		ret = bch2_empty_dir_snapshot(trans, pos.offset, 0, pos.snapshot);
 		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
 				"non empty directory %llu:%u in deleted_inodes btree",
 				pos.offset, pos.snapshot))
-- 
2.43.0

