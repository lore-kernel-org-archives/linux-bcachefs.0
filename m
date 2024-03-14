Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BF87317D
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710432150; cv=none; b=QNvs5FU1HNXpV2efyrOclMKLR900l8ibjTxpxD+Cv55VfECZkb5f4I0SiRfxVILq7J3BSdNh+PIiIiAjnyLtwjfm8BgvPZxdFYrxBTItJltbRtxKc671/ejnHBht75+VTc94M22H2tCPSYMz0/hlQY/Hu4OmjZMfN1hqHPYiNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710432150; c=relaxed/simple;
	bh=fkb+Y1o9mFRyMV0l6Q6aEfRjSrd/e/Qtp1UMUvnK9v4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NZyGUm9Kq4vX8OsI3m0qIX/qWPmRafrxcqTaGanP0gKTm+rFHUtFfF2xIO1c7FeHEzh1Ev3beG8whj2ihX0xxPDYrOWlaNQ/sAlLf7L9KR4udiZcEgDswKlYjgMVBqjecXljWJzZr60LC+WV8pcY+b3+B8KUsHNUep9DiXvFKRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bz3/XVcC; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bz3/XVcC"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36660d8547eso5046545ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Mar 2024 09:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710432147; x=1711036947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UCvo46xAm1BP9RIgX7dSFBNlQt8Vhs+YURLvSQrpn+s=;
        b=Bz3/XVcCiNkU+ajWPNodpgG8/cjNdc1cABzuPwKd/uD0GJYJEf/MuX/lHZ2D/CokvS
         yoC2VTgtEvQUfbKZYgDlbwAcpQvDxHKXzhX24QoOTZNmI5u8c5Z1Z4hd6iKFw6FXzn09
         4KXFBlOl30J1x7QQGoInfe/IYk7RJhcTME5kAB0QfPJB5DNEfwMlZ1XaqjOVmOrinSeI
         p+QMK5cAl03mst0+4agROJr9sMVpUwET93oCIHWe/Y5YYiQJDuuWhjPD1wuIJ2tlpASO
         q2+3zGgUbqiyZIMZTi2+wHDJht6Ch/CdkyC1rn+/yOV0xPDYeoRpAbhXET8WKi19CcjB
         fEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710432147; x=1711036947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCvo46xAm1BP9RIgX7dSFBNlQt8Vhs+YURLvSQrpn+s=;
        b=waewsjQ2p1GPny2QMZdIn6/yUSPRk1R8W2R1wE6UhOsiAGs4xOTUzDll6dlZHF7VAX
         EzvfU9SysGMkQJshm6fvhvBHXbqJ9KW9f6m5t7loyUpNA57W5jxyPvygKoCHvmUt4qI5
         5OxPZ/lpY7p+yN1g6FNc5H78HySWiGfOsvQEkl9ygx4G0FYXgr0MBmRQeuJcORkMROAw
         RxDHc2jJiGcoTTFDktQBMQk3OCProBImXEemHO1hef2hGGXldNVDFyzszOclJW+9rGYk
         Anu1NBBBHxSp+Yg6ecySTrm/yrc68GNuic2f4Ob5UlbsvZxf8+kajgCv/dvFaRmmBp1H
         yxWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfreT5OWibv8xGaltymlmKzEzkP01u/yNowAdLnK8TesCKVrBvRu8qb7utBGxjSN7jGtdTvO+3gG4boo+wbi8D58QO+TjpBxxOVgsbP1o=
X-Gm-Message-State: AOJu0YyJsMKB2FSQnhzvWp+Nge1LJUVx1X69Qp7Kd9ov8wuNGRiv7iFi
	0zQ5zScLGQVgVvGyMnunq5y3VmXDfmy4/ajsBUzcnFM1DyLav+I0jyvnK36D
X-Google-Smtp-Source: AGHT+IFW0/uBmVZDIcZIREHk/clMG8VI5TdwB4TahDrUVPvVVGA8gofHdMOW8/pRcq+BYJU7M9QG6Q==
X-Received: by 2002:a6b:7409:0:b0:7c8:6303:1bd4 with SMTP id s9-20020a6b7409000000b007c863031bd4mr643816iog.6.1710432147478;
        Thu, 14 Mar 2024 09:02:27 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id z8-20020a023448000000b00474f0fe1b44sm234815jaz.15.2024.03.14.09.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 09:02:26 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: create debugfs dir for each btree
Date: Thu, 14 Mar 2024 10:02:18 -0600
Message-ID: <20240314160218.192135-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This creates a subdirectory for each individual btree under the btrees/
debugfs directory.

Directory structure, before:

/sys/kernel/debug/bcachefs/$FS_ID/btrees/
├── alloc
├── alloc-bfloat-failed
├── alloc-formats
├── backpointers
├── backpointers-bfloat-failed
├── backpointers-formats
...

Directory structure, after:

/sys/kernel/debug/bcachefs/$FS_ID/btrees/
├── alloc
│   ├── bfloat-failed
│   ├── formats
│   └── nodes
├── backpointers
│   ├── bfloat-failed
│   ├── formats
│   └── nodes
...

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/debug.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index b1f147e6be4d..491ad699d558 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -866,6 +866,20 @@ void bch2_fs_debug_exit(struct bch_fs *c)
 		debugfs_remove_recursive(c->fs_debug_dir);
 }
 
+static void bch2_fs_debug_btree_init(struct bch_fs *c, struct btree_debug *bd)
+{
+	struct dentry *d;
+
+	d = debugfs_create_dir(bch2_btree_id_str(bd->id), c->btree_debug_dir);
+
+	debugfs_create_file("nodes", 0400, d, bd, &btree_debug_ops);
+
+	debugfs_create_file("formats", 0400, d, bd, &btree_format_debug_ops);
+
+	debugfs_create_file("bfloat-failed", 0400, d, bd,
+			    &bfloat_failed_debug_ops);
+}
+
 void bch2_fs_debug_init(struct bch_fs *c)
 {
 	struct btree_debug *bd;
@@ -902,21 +916,7 @@ void bch2_fs_debug_init(struct bch_fs *c)
 	     bd < c->btree_debug + ARRAY_SIZE(c->btree_debug);
 	     bd++) {
 		bd->id = bd - c->btree_debug;
-		debugfs_create_file(bch2_btree_id_str(bd->id),
-				    0400, c->btree_debug_dir, bd,
-				    &btree_debug_ops);
-
-		snprintf(name, sizeof(name), "%s-formats",
-			 bch2_btree_id_str(bd->id));
-
-		debugfs_create_file(name, 0400, c->btree_debug_dir, bd,
-				    &btree_format_debug_ops);
-
-		snprintf(name, sizeof(name), "%s-bfloat-failed",
-			 bch2_btree_id_str(bd->id));
-
-		debugfs_create_file(name, 0400, c->btree_debug_dir, bd,
-				    &bfloat_failed_debug_ops);
+		bch2_fs_debug_btree_init(c, bd);
 	}
 }
 
-- 
2.43.2

