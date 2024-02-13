Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4FB210FE
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 08:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707812420; cv=none; b=sCvZqR6IXhoV90SmC5cQ/Arha95d5tBJ7uEIdUBT3XAoOHDwT8S1HqfNmeOFeUYozbQQuvAiNKaRq6tV0E5TmJs2fLAnFXXVQ+IEG8AtkxXYKq2e5enrjVwZ0f/lPXulF/TBtpW2l9fU4HZZqT2/0JvnBJbgIibR5wiNJAGHRHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707812420; c=relaxed/simple;
	bh=z1nkkZuIszGU/mfIKWriNESoFLzivI3OqjAvipp47S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D0dksqfH+8C4nEp3XriV2Yar7GQFUW19HY/UrNG/wnPKW3j6TzOJ6S0+eBP5N2WsD9P5BhNhtRd3oG1eMwqho0MO/hxlyuGMdGN/CqYdpy8Ve4i8UUmfaVWASfoJLxeHcXZBz9WMb8R3LWo2/cR+0CnZxFuLIoSdjEPKDPZxmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NHrvUeVL; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHrvUeVL"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e0dcf0a936so871617b3a.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 00:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707812418; x=1708417218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/tsEFWIqo4hvmQzNGXCuZ67oLIokvD6xZvHnFm4wixM=;
        b=NHrvUeVLgmbXkP4TtoStMNqT/ydPbCkyXJ8TsNfT9drmVuXSQmJ1lkAKDYNzV+qFpK
         amqWlOtr3pC4ZyFCVQQZt0YqGoMtQeeDQtlltgwWWScCskhE5+6bAdOtjXTewYolYQkQ
         s/Tu6gei6S4Ac5qU2x22tHWs8DSFz21+dFqJVOkpgEejtQpmIFtmKVG1J3Agfkz3ZthH
         n/oN+02y8TgYcqdzVtH0XJg/GXJ2I0LA7H1saQ6HQ95TV9qvZFL9+Od9bjUWi6QZh+Si
         CdkE+iEtdm+DAYkDpfKMlDpb772PFfE009xlUA2uds1NFR5fauiL7fT7ZKApmzMQMBdc
         JBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707812418; x=1708417218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tsEFWIqo4hvmQzNGXCuZ67oLIokvD6xZvHnFm4wixM=;
        b=cqWugEa0bQRau+j3D9ba2FKuCqphhBnR3Kjf0HAwUXZjxt5Ha6AB6U9EHiNlJtqgpn
         HXZpsstoECiCc0QyTlVjTGzxWRKXoniN2PM1XNOmiJQPaX77rezuGKHw/ZN48WEzoe2K
         xm50YS12mwSch80hYi5LRDnt50XqbV1F2qJml7zmdbv2K8b0IrVY7zzaFM4u1iTwbqp9
         Ce3nJ3n49DnD/AdcEWTv5FjRbsb2PhCf1IZHl+3FKormVE1A2hBR3S0RTfDrIOVdlEGJ
         cq2JUjl/oQNCEUhJJQsssLKLjDAzbFGgqtyGbRAnz5MNGVcAiMu/Al0oxAV70dpzw93m
         d7/Q==
X-Gm-Message-State: AOJu0YysxgeXU5DdHDT5m29LPOQ0ZU1C9FaJ5JXyU/QXjiqCFN5SqcfQ
	HpeQXn6Z+kyj99zWG7m06R/8gsC0iS1WGLDJdsO8ZAPGCTvhO61X
X-Google-Smtp-Source: AGHT+IFu6jj2VeUz76eUOHMciybulww+RV6SUAtFQVRmjWrZiHVNDde8QEke9EphBhbhHYeXJ2A1NA==
X-Received: by 2002:a05:6a00:181f:b0:6e0:4c77:661a with SMTP id y31-20020a056a00181f00b006e04c77661amr2779829pfa.11.1707812418402;
        Tue, 13 Feb 2024 00:20:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVHwfXKrS9x9DVVjOWkkk5P4azk02isCuTMn6ehubkJVvbbw8fUI5p9TauJLOxjppfNdbiWlSua9yJ2k1cZBNrm
Received: from localhost.localdomain ([8.218.212.108])
        by smtp.gmail.com with ESMTPSA id y63-20020a62ce42000000b006e048853e1esm7095881pfg.215.2024.02.13.00.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 00:20:17 -0800 (PST)
From: Guoyu Ou <benogy@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Guoyu Ou <benogy@gmail.com>
Subject: [PATCH v3] bcachefs: skip invisible entries in empty subvolume checking
Date: Tue, 13 Feb 2024 16:20:04 +0800
Message-ID: <20240213082004.46076-1-benogy@gmail.com>
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
in the subvol we are checking, because inode.bi_subvol is only set on
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

