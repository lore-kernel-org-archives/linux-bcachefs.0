Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D120815E8B
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 May 2025 07:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747726476; cv=none; b=vAyNVkx0aGPz3zuPbFWpAcoVfgEB2j0yUE41REIa/c8NzVmpkFy0+b/LrJ6Ru+U0A/H5UxXYkh0Jwk4RKYabS09L+TXfac1IA82vVx3lQQR/oPf/fwL5zCTGtFS8dEnZTyKquht+MY86Ryk56HFnjTDD1iE/SYI3sTcI4ho2FaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747726476; c=relaxed/simple;
	bh=xWleKgqT87wuKCk1lP3WGDLIZIortaoQUUWdRO1bcMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XK2s7g1qVwxJp07krdUiSrUdC772+xZ9301MR5B+BliafmAaOrDbypSXtBZjWkUuMAwJzwQKYc51MIoRweszZ4GdFp6Wrbz2llfqia3h408pHOMSEjIBJe/LvHSznj2xNU6iznod9ku2kvljjlXQ/00v+Gpd9pdJPA7U/0YERRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FwBbxWHt; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FwBbxWHt"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b1ff9b276c2so3198815a12.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 May 2025 00:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747726474; x=1748331274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=epsbrQJTg0k/wBCp1/CBH0w1fPy4W/sTLqg/jge4Dug=;
        b=FwBbxWHt3Sx3Y2o6fgT9kC/iu0GiaykKBx+SEziH4hp6CXAorJYw/wyCzMcEXszzAL
         LjCyWdOSLOYPeuI4yQ5o7BmCnvLRJG6f0T16M26wMNJAsQ6him7DZF/UNQmeIVdOlL46
         KiM5EuhbzW88L8ExsjKcFbzGPgESRN1gLYnY+6SR/8iz7kZH8rD8miSFu+Qb1AeHVvdm
         1NVGXnYGuxVb/RuzijENDw9UX/g2AgNrzX2KfJKNC9wC61ql9/6MmrQ59I0+QtoEJudG
         lVzHZ3BFKlcoVj/PvcAbKT4eAwD7LxIdPHRioTAdNldamj1wPuTHELIWhg78SX8+NzEy
         uUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747726474; x=1748331274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=epsbrQJTg0k/wBCp1/CBH0w1fPy4W/sTLqg/jge4Dug=;
        b=Q96awR5vwfX43pr6mZHWWw/q5WWzxklwNMjvCTvpXh8o6lc1KuyYbEd3NHgs2qrL2t
         JkunVHZQBKvyXKlaBBL2uhX1568Dp3SkMX23QyezFHoAIvilcT7o0qc01pZJGsAmDXW5
         oxaEU+CQlDl/OObz9PhD8Um0UXrHgo3irgc5Gzea2/B7ncmH22IcMv+oQ/EZ4fQ3oG1i
         Ni+r3XDIXM42PXZPuWYSpy5FOJWkd8+jaU91w1yYOrDZdxlEEVeSslqYDOKkCF0tG4Ab
         nQ99EOrzwAmwHTftHHuZNFY2oB5Vo+XFOcXBaPEFZWZMH4jIbOYDvN1lH6cKmvUYm9ZO
         Vg0Q==
X-Gm-Message-State: AOJu0Yygds4ZIhyYgfxBhiqD+88I15hM/5JOI549vileg2jSa3D22Vx8
	lBxvajr0C9JOa4egbGYPJcE82JrH6dYHHkXlnqk13GJ0J9hSqjxb2uQY
X-Gm-Gg: ASbGncu3jgq7qtq5Qg/IxazEyA1RUO6lQulLD/YBhEG2nnJR/sn03zHo2+KpJXNa1Q2
	ouAKmp1Cdije/Wdh/lR8SY6+awcHESr1sfcQ3x/Xq9n48rA2+/07DvelHxrl3zQLYZstz0hpuGe
	Bkr/T5403R0DeD3LXscT5TMXNycLIRsISUfel+zoC2CjJC6YeHsKDfA78hxXL1HeimblxMRUIm3
	GL3CqzTtGzaSYYW6wKIVouFLzfN7tzAuJydTCJ5HQIUjTFzmdWXK/gNswMwAtB9GEV+KtX0juW8
	vz4dtAInDWySv7JjUJAJan/K0g==
X-Google-Smtp-Source: AGHT+IGetdw5uWzFFWwikcMnSX5zrazmF/pgDCxhI2ZvjXq4+K5kvnGMipyz6Yl6eozqRZ2mcdTzQA==
X-Received: by 2002:a17:903:3d07:b0:220:c34c:5760 with SMTP id d9443c01a7336-231d45acac2mr182784505ad.51.1747726473862;
        Tue, 20 May 2025 00:34:33 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e9713bsm70647045ad.150.2025.05.20.00.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 00:34:32 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+2c3ef91c9523c3d1a25c@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix possible console lock involved deadlock
Date: Tue, 20 May 2025 15:34:28 +0800
Message-ID: <20250520073428.675218-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Link: https://lore.kernel.org/all/6822ab02.050a0220.f2294.00cb.GAE@google.com/T/
Reported-by: syzbot+2c3ef91c9523c3d1a25c@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bcachefs.h      |  1 -
 fs/bcachefs/btree_locking.c |  2 +-
 fs/bcachefs/error.c         |  2 +-
 fs/bcachefs/super.c         | 11 +++--------
 fs/bcachefs/util.c          | 10 ++--------
 fs/bcachefs/util.h          |  2 +-
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 3077f15439cd..da70c688f54c 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -271,7 +271,6 @@ do {									\
 #define bch2_fmt(_c, fmt)		bch2_log_msg(_c, fmt "\n")
 
 void bch2_print_str(struct bch_fs *, const char *, const char *);
-void bch2_print_str_nonblocking(struct bch_fs *, const char *, const char *);
 
 __printf(2, 3)
 void bch2_print_opts(struct bch_opts *, const char *, ...);
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 6663e186a960..8a837f03a73e 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -237,7 +237,7 @@ static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle,
 			prt_newline(&buf);
 		}
 
-		bch2_print_str_nonblocking(g->g->trans->c, KERN_ERR, buf.buf);
+		bch2_print_str(g->g->trans->c, KERN_ERR, buf.buf);
 		printbuf_exit(&buf);
 		BUG();
 	}
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index a476dd2c196e..36c595059f72 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -69,7 +69,7 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 	if (trans)
 		bch2_trans_updates_to_text(&buf, trans);
 	bool ret = __bch2_inconsistent_error(c, &buf);
-	bch2_print_str_nonblocking(c, KERN_ERR, buf.buf);
+	bch2_print_str(c, KERN_ERR, buf.buf);
 
 	printbuf_exit(&buf);
 	return ret;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 24658bf450ab..9f686953c0f2 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -104,7 +104,7 @@ const char * const bch2_dev_write_refs[] = {
 #undef x
 
 static void __bch2_print_str(struct bch_fs *c, const char *prefix,
-			     const char *str, bool nonblocking)
+			     const char *str)
 {
 #ifdef __KERNEL__
 	struct stdio_redirect *stdio = bch2_fs_stdio_redirect(c);
@@ -114,17 +114,12 @@ static void __bch2_print_str(struct bch_fs *c, const char *prefix,
 		return;
 	}
 #endif
-	bch2_print_string_as_lines(KERN_ERR, str, nonblocking);
+	bch2_print_string_as_lines(KERN_ERR, str);
 }
 
 void bch2_print_str(struct bch_fs *c, const char *prefix, const char *str)
 {
-	__bch2_print_str(c, prefix, str, false);
-}
-
-void bch2_print_str_nonblocking(struct bch_fs *c, const char *prefix, const char *str)
-{
-	__bch2_print_str(c, prefix, str, true);
+	__bch2_print_str(c, prefix, str);
 }
 
 __printf(2, 0)
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index dc3817f545fa..df9a6071fe18 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -262,8 +262,7 @@ static bool string_is_spaces(const char *str)
 	return true;
 }
 
-void bch2_print_string_as_lines(const char *prefix, const char *lines,
-				bool nonblocking)
+void bch2_print_string_as_lines(const char *prefix, const char *lines)
 {
 	bool locked = false;
 	const char *p;
@@ -273,12 +272,7 @@ void bch2_print_string_as_lines(const char *prefix, const char *lines,
 		return;
 	}
 
-	if (!nonblocking) {
-		console_lock();
-		locked = true;
-	} else {
-		locked = console_trylock();
-	}
+	locked = console_trylock();
 
 	while (*lines) {
 		p = strchrnul(lines, '\n');
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 25cf61ebd40c..eca2bc30336a 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -213,7 +213,7 @@ u64 bch2_read_flag_list(const char *, const char * const[]);
 void bch2_prt_u64_base2_nbits(struct printbuf *, u64, unsigned);
 void bch2_prt_u64_base2(struct printbuf *, u64);
 
-void bch2_print_string_as_lines(const char *, const char *, bool);
+void bch2_print_string_as_lines(const char *, const char *);
 
 typedef DARRAY(unsigned long) bch_stacktrace;
 int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *, unsigned, gfp_t);
-- 
2.48.1

