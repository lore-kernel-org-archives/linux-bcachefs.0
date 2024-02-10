Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504BE36B02
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Feb 2024 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707574025; cv=none; b=rGKAtCiaaMOqFHfh8FHVWAgxA5AdMMOVcyQwySj8FLn+w24q9H+qolfP/Evg+dkkDvD56EMvaSGKUFnwUr35iT7OgNZ/tHPZ+bnXqAu8zD7ds+u3mGv7JeDAlWbWSpYjFmLhoKierkAoIflzQ5+Brs+FBq3/QUqkfv3yo3rZld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707574025; c=relaxed/simple;
	bh=VmGEBygE9cl2tYB0x62K2cGx+pCQwUKgV3v6dyfolLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HYj8BK4eKfkn3VFzPlfbTYNf2tvAnzfkv3gnesCxpT1g16aQXhdKEGmpmjd//Vs3gKTmLcVUXHzjxX/Q9a0PMb13sZh6SNub0TXev0kQo9xEuABI0/ZZXjPPMPUIrchd05/K8jjV8nOvmbjtdXAHlq0zgE++XeFDQXVkUWC34hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SK+XrQd4; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SK+XrQd4"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so1503500a12.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Feb 2024 06:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707574023; x=1708178823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lcdyXFygayCfZ6gV/vdeydZnb0rlJhHCyi+uDf6Gk/Y=;
        b=SK+XrQd4vT8ahocB0EOxbHmoYyOA/ieihecwhhcphRJ/W/zp7ZYgdDOu1Xp1RYRryj
         X/jIkiqElJTN9i/N8074Avkpza1GiMIeEkj3JJFy0MYRDJWnTHVZXiFB50wPKi7rZRRr
         5X+/usM0ZHZtYPgcirJDQlTUUiSGfvN3FYyccnN0O/omm5ldGDhaKFeNROQJ2iDjlZLm
         VjYqcaVnY11qcXkZFNj4u3B3JwG9Rnr/J0LK/wsY0cPtv8MrM4PxtUsy618+5xGcbWje
         Ct0VLpARqiDa/chtNel+nITcr5zPUk1qaUJwhL1VFUy6GJXEwhrKJIiTVP3oCv67tUs0
         11Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707574023; x=1708178823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lcdyXFygayCfZ6gV/vdeydZnb0rlJhHCyi+uDf6Gk/Y=;
        b=KdXTb4H1u+9Zbpv4IOCrnB074hfQKNp22Kk9rl8azfmrkeu14oltKgDbMdD83ngROl
         pp9m9gWPGd8G1acF8BgQAdU7T3IxKmhEX2Dc0nlR8lbDPAbsMeqjW0ai3pz3X5NvXIkV
         5O8/VxmriOrzL+gRw2QTxLtezDNAJODxxxpctr8Hr277DvuJ1RJOWz1NsSof0KO1Nzty
         iUoDuVK6sB/JKkVbRSo+w+InBvoG462g9iOJTvs4HhcP/TGHdGsSrWjnN77/vYULuBB4
         vPiBm0EuvtSogitduZb4vk7kZnzWdv/0uqzFqju+PqcvSvM4A8VfA9D2wubrL7WM4TRj
         GM4w==
X-Gm-Message-State: AOJu0Yyq3m62AZvOIhPss+KnMLBxqGERhMyzy9QNfjZVftQ4AJIUW1zc
	uqsVt1q4GbeAqJfpDZYvXgahcJQQEwCE+d92pnullRH/zzUrt44M
X-Google-Smtp-Source: AGHT+IG2026FIzDVCgji1sGfORsNfajphOenbg/5+tKnEhrFuiczJl9JPfX9dfLL3Vl8cWCfDsFtvw==
X-Received: by 2002:a17:902:c3d2:b0:1d8:da2c:1014 with SMTP id j18-20020a170902c3d200b001d8da2c1014mr2292608plj.9.1707574023551;
        Sat, 10 Feb 2024 06:07:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXo0oLeAYYeu0d9F5mB2a/gCZ2ERG8DvR0GcKujgB7In876MvZGMRcMWLZWGhvLd9V5btJi146VdSa9DrXLwjE4
Received: from localhost.localdomain ([163.125.192.6])
        by smtp.gmail.com with ESMTPSA id ev9-20020a17090aeac900b0029685873233sm3570977pjb.45.2024.02.10.06.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Feb 2024 06:07:03 -0800 (PST)
From: Guoyu Ou <benogy@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Guoyu Ou <benogy@gmail.com>
Subject: [PATCH] bcachefs: skip invisible entries in empty subvolume checking
Date: Sat, 10 Feb 2024 22:06:37 +0800
Message-ID: <20240210140637.87092-1-benogy@gmail.com>
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
index 086f0090b03a..8f85d0132cc2 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1088,7 +1088,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 		goto out;
 
 	if (S_ISDIR(inode.bi_mode)) {
-		ret = bch2_empty_dir_snapshot(trans, pos.offset, pos.snapshot);
+		ret = bch2_empty_dir_snapshot(trans, pos.offset, inode.bi_subvol, pos.snapshot);
 		if (fsck_err_on(ret == -ENOTEMPTY, c, deleted_inode_is_dir,
 				"non empty directory %llu:%u in deleted_inodes btree",
 				pos.offset, pos.snapshot))
-- 
2.43.0

