Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761E182;
	Sat,  1 Feb 2025 19:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738439464; cv=none; b=SMUBoikUE5BCWJ7bn8fIjUeelDB1yOH8fToUNZoLH/JVqLXe/ZRQG3PGCBYT30BLY26eTZ7FOwtFxbEC1MVEH6y45FwbdqK2p3Vu9BRRTS5pMLmVT24VppkAg+2PvzwRBr1VwbozVUIYxRymsxG5xVX6OeRow83IUptvX4s4coI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738439464; c=relaxed/simple;
	bh=f3z6rJ2oNwC8POCZ1G3/0ywrHlP5N4xydfCcn2NthiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oa6KR/SVoGkKIhFAtheQnyym4lJyLG3R82PcByqxpw6zY65mrmHZOkpBTG5SHAcwuy86Y2avmEII3G9YX4Ckq1e8+bU2piVwZjFkl8wkCO+sJoF0CiljssVL+r00LcmD38zyY1rKYvXjPfHnOmWsGJ2TYwhhNI03TyNK1zDO4MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bao5HEgf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bao5HEgf"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-218c8aca5f1so56267335ad.0;
        Sat, 01 Feb 2025 11:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738439462; x=1739044262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5AzTTXm9oGH9S++jQOzxp/Y4TK/NK4fIhImw9dYlV6k=;
        b=bao5HEgfJLUQ4xS5Ho+i+MnHFi40eHE9gtQliqe8MnJOSYCjVdSrtiJ2wGY/UlYwlZ
         7if5AvUHAVVLkDljsH1SCL40dxKWlSujiPeSqj9A1uLSmxhKluSFH755fasz1z/OIXWm
         pT2Ys9ZZuggLP7wAxP1I520WfzjeHDISu6ww2FOBAoiMkf9UhD3O54J7YW6izyI5uqsd
         jU+shR1b9zZM6jMJ2WS426+GPwHSNxDez88HYnFwOfxGcI8OwJxotu/Oyy3aJuT3dxfv
         X7NPlySQiLa5UlERw5hqkxBa/oZ/WhiZwy5Ncmcx+uZkTcde1vspL/75H/IOtUipefYr
         4GuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738439462; x=1739044262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5AzTTXm9oGH9S++jQOzxp/Y4TK/NK4fIhImw9dYlV6k=;
        b=ppMSnlAcRplExu1ZfUmYuu/dloDfyJCIXy2o3Pnvsfa1wghMN/L1GLMDshDuMazl64
         NMDhfvQEOmO1Y/89g593iLZY4MQO36FUZwRumwPTiIhbsnozv6KuwiqUXEAZzEqZkVMP
         Pz/vRB0WKWBNbt0jRM6LjNlVkKKaCB3AzbVJcxCHJgipuNWWTKkbtr6Vk3Oii3Def18d
         cIPrb2BeDrrZikmRE1Z+Dx56KiMhUrkVpwI1NIljvFtw24xXXH5Ws2IN/YvOKYBYBUbN
         5JPFn+8mAQsQvEQsngchBIDiVfAbX4U6Rl/nbjBGlPEtiWDy8jr9S641df8xF7zP+h5l
         HTTg==
X-Forwarded-Encrypted: i=1; AJvYcCVGAhV38/bxjc2Z31zffFxuFqswy+yiCN91z4wdCU1fCqz1OJvh6IXsv+urv5ZVXh4IelesfX6FxFUR5Hw=@vger.kernel.org
X-Gm-Message-State: AOJu0YypWbgI0YhyzrEIOnQEwJ2TTwQK4thlMi/cKUUqpEzdc0xA9iKC
	mPDyVTk5yQ5DPcJUPND7el4ihGB3t4siooWPWX3BTZFXkTp2wmxQGWKpNYJC
X-Gm-Gg: ASbGnctqLPxpkh9e1/eD8cBb0sJZOiUoZjPD+QArfKeH8Ay45QNMA8zbX84VH6dK/hU
	wdBEu+Xm5DnHP5KzmWKLWpncvR6czAJ5IyM4FY8ZUa3ddmuRyqhhSSIFTSmShTKK6W9MKaep9FV
	V5RfnuXOz9goA129ShPb2jv3wKlkXrwz86XlXTwmsBOB4Ah5CbZFDYT+PH0uR+0k2uMQ0q7LY6C
	kvJIDGYvLLI6TErwGQUuc1B4+c0qgE7MfGPvwhtnpK3ns2TaIuQaluv1sPIE2X2505TDLUgrDyW
	WiGgivlRszO+6c2wXfSMBrY13CFHf7eereWCJ6BauGOw
X-Google-Smtp-Source: AGHT+IE+VvBtu+XYr/1PyIOzsT3r1C1UMOaRuw9/LZgEKwJUv1REjOYRZERUwksZJNtXpOXC0JHhcw==
X-Received: by 2002:a17:902:d48b:b0:215:385e:921c with SMTP id d9443c01a7336-21dd7e39d0emr230302085ad.51.1738439462423;
        Sat, 01 Feb 2025 11:51:02 -0800 (PST)
Received: from localhost.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de31ee66dsm48611055ad.50.2025.02.01.11.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2025 11:51:02 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v3] bcachefs: fix deadlock in journal_entry_open()
Date: Sun,  2 Feb 2025 04:50:44 +0900
Message-ID: <20250201195044.28007-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the previous commit b3d82c2f2761, code was added to prevent journal sequence
overflow. Among them, the code added to journal_entry_open() uses the
bch2_fs_fatal_err_on() function to handle errors.

However, __journal_res_get() , which calls journal_entry_open() , calls
journal_entry_open() while holding journal->lock , but bch2_fs_fatal_err_on()
internally tries to acquire journal->lock , which results in a deadlock.

So we need to add a locked helper like bch2_journal_halt_locked() to handle
fatal errors even when the journal->lock is held.

Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/error.c    |  6 +++---
 fs/bcachefs/fs-ioctl.c |  4 ++--
 fs/bcachefs/journal.c  | 22 +++++++++++++++++-----
 fs/bcachefs/journal.h  |  3 ++-
 fs/bcachefs/recovery.c |  2 +-
 fs/bcachefs/super.c    |  4 ++--
 fs/bcachefs/super.h    |  2 +-
 7 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 038da6a61f6b..2482eb33b1ec 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -20,7 +20,7 @@ bool bch2_inconsistent_error(struct bch_fs *c)
 		return false;
 	case BCH_ON_ERROR_fix_safe:
 	case BCH_ON_ERROR_ro:
-		if (bch2_fs_emergency_read_only(c))
+		if (bch2_fs_emergency_read_only(c, false))
 			bch_err(c, "inconsistency detected - emergency read only at journal seq %llu",
 				journal_cur_seq(&c->journal));
 		return true;
@@ -46,7 +46,7 @@ int bch2_topology_error(struct bch_fs *c)
 
 void bch2_fatal_error(struct bch_fs *c)
 {
-	if (bch2_fs_emergency_read_only(c))
+	if (bch2_fs_emergency_read_only(c, false))
 		bch_err(c, "fatal error - emergency read only");
 }
 
@@ -62,7 +62,7 @@ void bch2_io_error_work(struct work_struct *work)
 	if (dev
 	    ? __bch2_dev_set_state(c, ca, BCH_MEMBER_STATE_ro,
 				  BCH_FORCE_IF_DEGRADED)
-	    : bch2_fs_emergency_read_only(c))
+	    : bch2_fs_emergency_read_only(c, false))
 		bch_err(ca,
 			"too many IO errors, setting %s RO",
 			dev ? "device" : "filesystem");
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 15725b4ce393..92becb6ae5aa 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -354,14 +354,14 @@ static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 		if (ret)
 			break;
 		bch2_journal_flush(&c->journal);
-		bch2_fs_emergency_read_only(c);
+		bch2_fs_emergency_read_only(c, false);
 		bdev_thaw(c->vfs_sb->s_bdev);
 		break;
 	case FSOP_GOING_FLAGS_LOGFLUSH:
 		bch2_journal_flush(&c->journal);
 		fallthrough;
 	case FSOP_GOING_FLAGS_NOLOGFLUSH:
-		bch2_fs_emergency_read_only(c);
+		bch2_fs_emergency_read_only(c, false);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..4b3bdbfd7782 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -310,14 +310,23 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val, bool t
 	__bch2_journal_buf_put(j, old.idx, le64_to_cpu(buf->data->seq));
 }
 
-void bch2_journal_halt(struct journal *j)
+void bch2_journal_halt_locked(struct journal *j)
 {
-	spin_lock(&j->lock);
+	lockdep_assert_held(&j->lock);
+
 	__journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL, true);
 	if (!j->err_seq)
 		j->err_seq = journal_cur_seq(j);
 	journal_wake(j);
-	spin_unlock(&j->lock);
+}
+
+void bch2_journal_halt(struct journal *j, bool locked)
+{
+	if (!locked)
+		spin_lock(&j->lock);
+	bch2_journal_halt_locked(j);
+	if (!locked)
+		spin_unlock(&j->lock);
 }
 
 static bool journal_entry_want_write(struct journal *j)
@@ -382,9 +391,12 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
-	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
-				 c, "cannot start: journal seq overflow"))
+	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
+		bch_err(c, "cannot start: journal seq overflow");
+		if (bch2_fs_emergency_read_only(c, true))
+			bch_err(c, "fatal error - emergency read only");
 		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+	}
 
 	BUG_ON(!j->cur_entry_sectors);
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index cb0df0663946..23f5fd970b7d 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -407,7 +407,8 @@ int bch2_journal_flush(struct journal *);
 bool bch2_journal_noflush_seq(struct journal *, u64, u64);
 int bch2_journal_meta(struct journal *);
 
-void bch2_journal_halt(struct journal *);
+void bch2_journal_halt(struct journal *, bool);
+void bch2_journal_halt_locked(struct journal *);
 
 static inline int bch2_journal_error(struct journal *j)
 {
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 98825437381c..31549181888c 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1076,7 +1076,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 	return ret;
 err:
 fsck_err:
-	bch2_fs_emergency_read_only(c);
+	bch2_fs_emergency_read_only(c, false);
 	goto out;
 }
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index d97ea7bd1171..d3d11fb39632 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -400,11 +400,11 @@ static void bch2_fs_read_only_async(struct bch_fs *c)
 	queue_work(system_long_wq, &c->read_only_work);
 }
 
-bool bch2_fs_emergency_read_only(struct bch_fs *c)
+bool bch2_fs_emergency_read_only(struct bch_fs *c, bool locked)
 {
 	bool ret = !test_and_set_bit(BCH_FS_emergency_ro, &c->flags);
 
-	bch2_journal_halt(&c->journal);
+	bch2_journal_halt(&c->journal, locked);
 	bch2_fs_read_only_async(c);
 
 	wake_up(&bch2_read_only_wait);
diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
index fa6d52216510..e9ff83e06ca2 100644
--- a/fs/bcachefs/super.h
+++ b/fs/bcachefs/super.h
@@ -28,7 +28,7 @@ int bch2_dev_offline(struct bch_fs *, struct bch_dev *, int);
 int bch2_dev_resize(struct bch_fs *, struct bch_dev *, u64);
 struct bch_dev *bch2_dev_lookup(struct bch_fs *, const char *);
 
-bool bch2_fs_emergency_read_only(struct bch_fs *);
+bool bch2_fs_emergency_read_only(struct bch_fs *, bool);
 void bch2_fs_read_only(struct bch_fs *);
 
 int bch2_fs_read_write(struct bch_fs *);
--
