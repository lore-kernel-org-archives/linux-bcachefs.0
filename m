Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D619DF99;
	Fri, 31 Jan 2025 12:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738327685; cv=none; b=aP67X71Z6d0B0DpserqU0SojjDX3h/pZ3WOdbS+aZudG7tXkxGcQPfvZVp11A29h2VA9L5zq8+1SYs3pCTFkIvj7sLXLyPab3VXk3gFhBwnf2a6gdH2Eo4wW8TdF/GovIv+8A4hedRlF2NPw9ay1wDuNcYhmkY8exR1wmahjKJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738327685; c=relaxed/simple;
	bh=K6TusXQV6nktUqErpt35PTpw5IEQdG9mCBx02g/CTfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VRihVVILtafzdLU3cQUSvfHT9K/TVTzaY/2Fu1HR4666i1TgLDZYLcxHqlIj0AGgu/IgFxvtTiEvKH01rnGGl8aqF/Unolt7b07bI4kzFbede2dEhC6YLGVSPvbSpB970PDTM3RmyoMGm4YA2A0WEqqyXksYDdhB+NiiaAGx65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pf1ovkAg; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pf1ovkAg"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so2569085a91.2;
        Fri, 31 Jan 2025 04:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738327683; x=1738932483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ne/2olyZWrVJQQ3HJJ4gh6Jz5c37JZsWaOvGgi0J1Ug=;
        b=Pf1ovkAgWhGcayb9943yngKHVymuvY/6AWERjKJDqf3/Ga+xGUQRcIVXb0FiuBZEEu
         9moF5rE6v1puMHHEcU4y6O0vdcOPxVBze4QYB3m+Acxnea3HLhXzhM16YBYWQyw5k23z
         XIqgRL1giKqhd+phkRrSl6rxT3BkfrNEYEP6ZvKvZnmmCxhwSq1KDz38nokDIvnwupOO
         d3cs5Bb1aMC0teG0SHwzIDsGi7YIoYnt+PmkRCgx+HiqDSlZYOvMQvBWv0ah60BbxY5k
         aD+sdJfIAU7EDxY6qVGVK3KqiEVmNUsEB4GJSq95bomrLHxiVDWseroz8PxvHCSf3dpN
         J9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738327683; x=1738932483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ne/2olyZWrVJQQ3HJJ4gh6Jz5c37JZsWaOvGgi0J1Ug=;
        b=mjsulhgndZWUB3FbQQEdfSqt5aK03/BLej+2aEHi6dRivINQE6wHIl+EhNPPq1sQof
         OUgbfQynx2mVezGW/ZmoNipVItdENDmRgp7Ei3TtsDoArAHZB8xgLX//eHpXKe+CYyy+
         Y4PTKvlsdiwmiBYd1TGMFnILoOLXdvnYcUEMhVqpojcR77NVGlr4/uXwpSGQ/Ki4Dzja
         TLTktuAP4Q+XeoeZ+ovuY0P6c2Eoo1KuWoXnaBpn9J1V1RxGUd9QeLCwRHk/gVTwmjyy
         nq4ihEXuMPYx0rudPFgfjesjpAwOco1HfA2a8P4FYpRpSxKmjAxoh23xOj1YY9iGxqgy
         udVA==
X-Forwarded-Encrypted: i=1; AJvYcCXGU6QlkKonSaElvrcUnJW4BVEsB4Ja0aSgMtR7pIxPxvM8bs+0ua+37k8s5clSULX3vJ2VpCIzP2iz1U8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe/p0kjMcuBY/kCIp14BT6eL4Kh2osbe9Pl3GW8pSAvBrv0Yub
	v0Uny7xQj2VEJRPKJIbm6mvUbBMzGpmJArwWvnhif+rW5vHSdI90
X-Gm-Gg: ASbGncsgwswjOiz/ZZ3A3FJHiFzVkwuYGngrUHs6+6NB9Y+IHLSrYHJhkK819EPC8TR
	Tagp4JmBO02cmMfDDGHgSD0mbWLzIM5H6I55qtITP+Rk8BHanCFSMGyCuKb/N893Owttgat5rxs
	2Y1YZ8Jjo0R9cBYP0N9ACq4BVMI/kd6crZgQN0ZwafuC02rroN0aRgYfpIwzXhHT4KUglQTfbKG
	nVkxSKLs8hyRcOvVSPFb4Bw8KB3QxmQmL080g/xWZlNApMROQlUYVIt/8DzrJT4uGMxHdwId8VB
	FCYoSuJtbhBxjrNqhEmvtku02oDxyFKiRnGvAEJy
X-Google-Smtp-Source: AGHT+IH6CFnqgCeKYeq9GBlE1N1CeneTelZ6aAL21fH4ayik3vOkC1/uuGDodSkWMdFsBLJ/DOe+vQ==
X-Received: by 2002:a05:6a00:3910:b0:724:592d:aa5f with SMTP id d2e1a72fcca58-72fd0c5ee15mr16608281b3a.19.1738327683071;
        Fri, 31 Jan 2025 04:48:03 -0800 (PST)
Received: from localhost.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec096c62bsm2960207a12.67.2025.01.31.04.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 04:48:02 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v2] bcachefs: fix deadlock in journal_entry_open()
Date: Fri, 31 Jan 2025 21:47:50 +0900
Message-ID: <20250131124751.172123-1-aha310510@gmail.com>
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

Therefore, we need to add bch2_fs_fatal_err_on_locked() to handle fatal errors
even when journal->lock is held.

Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/error.c   |  6 ++++++
 fs/bcachefs/error.h   | 16 ++++++++++++++++
 fs/bcachefs/journal.c | 10 +++++++++-
 fs/bcachefs/journal.h |  1 +
 fs/bcachefs/super.c   | 11 +++++++++++
 fs/bcachefs/super.h   |  1 +
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 038da6a61f6b..25f51dec732d 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -50,6 +50,12 @@ void bch2_fatal_error(struct bch_fs *c)
 		bch_err(c, "fatal error - emergency read only");
 }
 
+void bch2_fatal_error_locked(struct bch_fs *c)
+{
+	if (bch2_fs_emergency_read_only_locked(c))
+		bch_err(c, "fatal error - emergency read only");
+}
+
 void bch2_io_error_work(struct work_struct *work)
 {
 	struct bch_dev *ca = container_of(work, struct bch_dev, io_error_work);
diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
index 7acf2a27ca28..760623c07e67 100644
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -189,6 +189,7 @@ do {									\
  */
 
 void bch2_fatal_error(struct bch_fs *);
+void bch2_fatal_error_locked(struct bch_fs *);
 
 #define bch2_fs_fatal_error(c, _msg, ...)				\
 do {									\
@@ -205,6 +206,21 @@ do {									\
 	_ret;								\
 })
 
+#define bch2_fs_fatal_error_locked(c, _msg, ...)		\
+do {									\
+	bch_err(c, "%s(): fatal error " _msg, __func__, ##__VA_ARGS__);	\
+	bch2_fatal_error_locked(c);					\
+} while (0)
+
+#define bch2_fs_fatal_err_on_locked(cond, c, ...)		\
+({									\
+	bool _ret = unlikely(!!(cond));					\
+									\
+	if (_ret)							\
+		bch2_fs_fatal_error_locked(c, __VA_ARGS__);		\
+	_ret;								\
+})
+
 /*
  * IO errors: either recoverable metadata IO (because we have replicas), or data
  * IO - we need to log it and print out a message, but we don't (necessarily)
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..12e3b4024494 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -320,6 +320,14 @@ void bch2_journal_halt(struct journal *j)
 	spin_unlock(&j->lock);
 }
 
+void bch2_journal_halt_locked(struct journal *j)
+{
+	__journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL, true);
+	if (!j->err_seq)
+		j->err_seq = journal_cur_seq(j);
+	journal_wake(j);
+}
+
 static bool journal_entry_want_write(struct journal *j)
 {
 	bool ret = !journal_entry_is_open(j) ||
@@ -382,7 +390,7 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
-	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
+	if (bch2_fs_fatal_err_on_locked(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
 				 c, "cannot start: journal seq overflow"))
 		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
 
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
