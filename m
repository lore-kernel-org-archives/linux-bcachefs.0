Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA8E1DA23;
	Sun,  2 Feb 2025 06:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738477309; cv=none; b=Z/ucObJc046HmQdr+0FR+fIEWFkQ4p3MU3B5oRWWpljd+TkWdzFdFW6NDMkK526k/Fb79PmlJYkCp8R2WssMcbLGMvgMl3CCrN8NdG9ppLsMKRw3przY0oIBHePs7iqQqVyiURZAb87q5kP+GY8USrAY+n/tYPwtFsg4e/capxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738477309; c=relaxed/simple;
	bh=DCE0B7R5i42bjocztLTE4ZGp349wX49z5Qipr1E9XCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZSetmv/vKdbbmByO6a2O2VZm28sfSyNBd5c8Ci8ICxsRN7Z1djwxU6KdjVpR/qh9P+0POoRd1Eb05Z8IqZ29r1NL6VME6auQnd02XB0SVLaidS9zL5heaI3x/zJKwBwnftu1tWO5YkDngFMoKTuaE8Rj4Odb6TO7WfuXpamwc4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a5VBmwBO; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5VBmwBO"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21636268e43so74299335ad.2;
        Sat, 01 Feb 2025 22:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738477307; x=1739082107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rzs+G9AnOJitj2iQowUEhwZSCI8nvpxvQM+2sYR2dsA=;
        b=a5VBmwBO/d9CvfXdYLI7dCNJjBhpY5Rs+w1Uxss7PyTRRk7KOpC3Ql3cfN0Xyv7lfh
         5re/aijhc1dQM1hXlOxiMa8BQEBNoQ5/nrN/iWdOmhES3O2R1hbpmgWEUsPMdK+tsOdW
         mSteClPGLlZ8TjGKZtkmxRlQ0QSVMBe0ZDNCVtCf42iPxDszujbCUaRc+z1els6EVTYJ
         7VziVJHIwjOiknhY3QC/RoCxnMNFJjnD5w3TfAUE7SdKAgcqcU/X7xiDuQiq9lKRXMAW
         YSTP9p1qzPtX+QXm4VsYzfB4cb0S5asButMTRrNNqI+hF+NE3y46+L1m+KWPBlP3k7Pl
         vdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738477307; x=1739082107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rzs+G9AnOJitj2iQowUEhwZSCI8nvpxvQM+2sYR2dsA=;
        b=edppoyRVqVj07Ck5XQ3Zht/R0Wm6Rqop955J4zbdChq4GDT6Kq+ttxdXm8ojjaaPTo
         z2UQyYgPHjXHn8Pji5/nXGUryoW5VByXmr69OnXZBKvQcJw1LndEWJeJxhiQC5cQQbex
         2dPMaJWFbQQr7qBoHMLo16uXRAIiYfkHMTORj6jP0pjmFhCssEyO3Y/tXFPQUckwRzx5
         mGZWUDOAtGUnww63fzQun9apkdo9r3hEsxanS6dUw+m5mh53IMPNyV+U+UzpOJPShUrw
         wRPAiuZIX2yysS9Maf44uYeCMvF64YyPhAtxR2ZqYbveBU6LDc+Fa3XdYKI9YKbdMRec
         dUyA==
X-Forwarded-Encrypted: i=1; AJvYcCUWVA4mDNVDXi+dm8+YGR0LMDUNbajMl1MKsxSem9Ks10OrIiYgrhljG3uzbrVrYd7F08kkQZJs7AMoeTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZEPsc7o0+xDTAsij07hH9fKnfEae/AxcPmhJVm6d8l8+oyUHC
	cEQ+3GPTlSZbp2Xk2N+8rTKWyvqTdB8EKfz9HrtxFjUOVPFvFQe61758VUUH
X-Gm-Gg: ASbGnctep2dnXRsEuPLlPr8AVsCGeR1OCxrNO+veHokwzJZ6x00N99NP/QVWVR5cHXB
	V/UnL1aZ5quI6G9FNlEpoKRNG6027p3u1wIQy8wr/YcqGcXextBRKSSJL7Iqs5TQNdr8c9NeMTW
	0h9cjwwCOzFds6tmML060frb/TMT2S04SNH7EM9vCe5k6fZnq74pJz2k6KiwgrTjsGGFNA43Eqx
	r1D1iMm+1kS54OOe1lSt4BGWS0KIrH6g9/5qnpNG0dUD4oFiEe9YtnynPcvVbZsSw++Cd+hNwwr
	h/ml+OxF8F+RNXj5VepjgN50OrnuM2stRQcd74tbSO6x
X-Google-Smtp-Source: AGHT+IEeXQRGknONs8tXl/EmUvOM3qkBB2XFLzu8Fwi6ZBc4x1NnGxwKS06W4nw4qGuQ6hywcZ+GDg==
X-Received: by 2002:a17:903:1246:b0:215:7421:262 with SMTP id d9443c01a7336-21dd7c603c5mr251983895ad.12.1738477306895;
        Sat, 01 Feb 2025 22:21:46 -0800 (PST)
Received: from localhost.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ecad9sm54095105ad.157.2025.02.01.22.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2025 22:21:46 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v4] bcachefs: fix deadlock in journal_entry_open()
Date: Sun,  2 Feb 2025 15:13:51 +0900
Message-ID: <20250202061351.36023-1-aha310510@gmail.com>
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

So we need to add a locked helper to handle fatal errors even when the
journal->lock is held.

Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/journal.c | 17 +++++++++++++++--
 fs/bcachefs/journal.h |  1 +
 fs/bcachefs/super.c   | 11 +++++++++++
 fs/bcachefs/super.h   |  1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..123b8b119c8c 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -320,6 +320,16 @@ void bch2_journal_halt(struct journal *j)
 	spin_unlock(&j->lock);
 }
 
+void bch2_journal_halt_locked(struct journal *j)
+{
+	lockdep_assert_held(&j->lock);
+
+	__journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL, true);
+	if (!j->err_seq)
+		j->err_seq = journal_cur_seq(j);
+	journal_wake(j);
+}
+
 static bool journal_entry_want_write(struct journal *j)
 {
 	bool ret = !journal_entry_is_open(j) ||
@@ -382,9 +392,12 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
-	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
-				 c, "cannot start: journal seq overflow"))
+	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
+		bch_err(c, "cannot start: journal seq overflow");
+		if (bch2_fs_emergency_read_only_locked(c))
+			bch_err(c, "fatal error - emergency read only");
 		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+	}
 
 	BUG_ON(!j->cur_entry_sectors);
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index cb0df0663946..416fbed447de 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -408,6 +408,7 @@ bool bch2_journal_noflush_seq(struct journal *, u64, u64);
 int bch2_journal_meta(struct journal *);
 
 void bch2_journal_halt(struct journal *);
+void bch2_journal_halt_locked(struct journal *);
 
 static inline int bch2_journal_error(struct journal *j)
 {
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index d97ea7bd1171..6d97d412fed9 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -411,6 +411,17 @@ bool bch2_fs_emergency_read_only(struct bch_fs *c)
 	return ret;
 }
 
+bool bch2_fs_emergency_read_only_locked(struct bch_fs *c)
+{
+	bool ret = !test_and_set_bit(BCH_FS_emergency_ro, &c->flags);
+
+	bch2_journal_halt_locked(&c->journal);
+	bch2_fs_read_only_async(c);
+
+	wake_up(&bch2_read_only_wait);
+	return ret;
+}
+
 static int bch2_fs_read_write_late(struct bch_fs *c)
 {
 	int ret;
diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
index fa6d52216510..04f8287eff5c 100644
--- a/fs/bcachefs/super.h
+++ b/fs/bcachefs/super.h
@@ -29,6 +29,7 @@ int bch2_dev_resize(struct bch_fs *, struct bch_dev *, u64);
 struct bch_dev *bch2_dev_lookup(struct bch_fs *, const char *);
 
 bool bch2_fs_emergency_read_only(struct bch_fs *);
+bool bch2_fs_emergency_read_only_locked(struct bch_fs *);
 void bch2_fs_read_only(struct bch_fs *);
 
 int bch2_fs_read_write(struct bch_fs *);
--
