Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196034BA4E
	for <linux-bcachefs@vger.kernel.org>; Thu,  2 Oct 2025 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759446664; cv=none; b=RBqZgrlY0hJ+O0RZ9u8TNR7+X/1ATboWVl3NOU5do/6QEUEtncheViHe/kd9XlFMLQ+w/4KvWI3PH244akkyNOTd0MavhehIV6AB42WMeY1Krc+zi/4UxxwbiYj8f5AhokDZKPJOe6oYBV7otcMk65tr3oq5IE21k8clPwXEcjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759446664; c=relaxed/simple;
	bh=05QBzRd86DhaBHC/HzFaLKts1U4K0ZRH0JC89nOeuak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WPKmd+zfeHZb8jzKAXCyKJRqXfRXoA83oMHr35hG0cloSMfVGk5okQJrdxFd+/vFCum4HVk7AjiQXZId+E+ToE2brF7kWJPEgDtDJIlbq6QNOnrZ7Ybd+gomplgdU1zenwwqdBE8TWPHCZEmWNy7K/+a/TI6RhrFIrlHQEcR7cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8Hffaai; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8Hffaai"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b60971c17acso1422652a12.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Oct 2025 16:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759446662; x=1760051462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yFC69a6NBsLOPw5S/NgD9GIK97Ncfay1Ur+maFKsDH0=;
        b=j8Hffaai8x/QwsCo4UmjJtkbzT63gkStG3uzsDmggN1+B6GSoKyCISQ2dyJd1p41Rs
         7O+08/+jI0HBKPs3fy604HSKnTwNL4cFTwNyUnOhv2dl9nbwBu5F4MIoU8iVvjsXN/AG
         6itafzNpYIV6L6evpxRHBbLGBWs0UlRwhW/YMJg4vspwF9JuC8orGetUL5BcbVqojO2d
         HLGzzfaHG+8rbnoT+D71QCks3Lq564i258QYmD5rCLxGDPqb27syrc5bHYq51Hzdl5En
         mZoNw/Nu3zj4kMC3FEomhpC6PsODocQ2MtJp2BCPDFp2MgBiUjrINzTbiO4MlULdyFgv
         iDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759446662; x=1760051462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yFC69a6NBsLOPw5S/NgD9GIK97Ncfay1Ur+maFKsDH0=;
        b=BCNWei3Op8E/KWUTKIM1nWiUwSBCKuI1dWdOKR06GfQFriuy64PrX/mH5YukGrlSol
         CwgDoa6xo4PM6Mvh0mAMaBcPBlmhEgbKa2eTAATX7ryZ4NlWWT08+1nXCHJF8TnuWZMH
         iR0MY47AS+QbPGmD6W7c0Wjbj3geGC7XJkhh3b/40jxakc5G4sAGUl3rlsGvzeLgjWzk
         EhArSZYoDKEB5tCFaBn34ZnNN9Xsm0Q+d7vMt7dsRkIyb92NpPLVPzUYcLy8cPbAEIx+
         Cca7StbIBwUd1M1AlSE+NNkvstDhpbz5QN/7AIi9bijjir99bXvkLln+NAQWMiVtTLl0
         eecQ==
X-Gm-Message-State: AOJu0Yw13TCZMmv0TRHp/LrtzkERf/IP1u6qdMyCLajTO/EDd/jHDxh5
	ZvYCB4BA8J08ygwI/TIKAJo9N/PqZpMuYsZMQO+OHUeZJDpZUQzSDehL
X-Gm-Gg: ASbGncsAxkdocEzS2iWfLMPny26VWWyGCFP/az+qHjkif1dJTIVtWnc3t8sKSYS6ovI
	lXkr9I2EWBoT4uhm4y3bQJeKxuo+qKB6vYOFbkKWCseRfZQqGKUOVG0NRslK0NHNf41tKWu6sz5
	kBJ+pQsXSr6Bf/jYykUEg8Wbk/6AnleUZBU3oAv3hunRW9Ms5kUwwJqyciDzmqp3tMyVJlsYSBT
	ulN5QHC0Hbnk3SseE0OQM7aJyD30AeOICeiYMr7Ve0LhWL00z5aE3gTmf4Z4HrPA1R3WwJrCgel
	xckFwrVgfdW2mlho023VZqYGDQ8lQghgVbdC7C7ZyVmhPrpjeWPk4fx0oRC8q/LmMMDK262j3XW
	G0oC+u1pURMp2+tsMltUlF/CA2tL5hYVP8PI9p9gw+WCFnYUrU6Pd
X-Google-Smtp-Source: AGHT+IGUOdKa1AKW2FKiv+nG8uiNpD1FAXt7j4+A8CLzObKcsOtjM7P0Sez7FihNRKz72nbVUzDMxQ==
X-Received: by 2002:a17:902:dad0:b0:24c:c8e7:60b5 with SMTP id d9443c01a7336-28e9a58b550mr11718715ad.16.1759446661851;
        Thu, 02 Oct 2025 16:11:01 -0700 (PDT)
Received: from fedora ([119.161.98.68])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111905sm31334655ad.24.2025.10.02.16.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 16:11:01 -0700 (PDT)
From: Nirbhay Sharma <nirbhay.lkd@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>
Subject: [PATCH] bcachefs: fix use-after-free in bch2_dirent_to_text()
Date: Fri,  3 Oct 2025 04:40:33 +0530
Message-ID: <20251002231033.23810-1-nirbhay.lkd@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bounds checking before calculating pointer offsets in dirent name
accessor functions to prevent out-of-bounds memory access when
processing corrupted filesytem metadata.

When d_name_len contains a corrupted value, the pointer calculation
&d.v->d_cf_name_block.d_names[name_len] results in an offset far
outside the dirent structure, triggering KASAN use-after-free erors.

While bch2_dirent_validate() detects such corruption,
bch2_dirent_to_text() may still be called for debug output, so the
accessor functions must handle invalid data gracefully.

Fixes: c21f41f6905be4fc5059a10a5bba94105ba87269 ("bcachefs: bch2_dirent_to_text() shows casefolded dirents")
Reported-by: syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f176adb30b21606c5fc
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
---
 fs/bcachefs/dirent.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index d198001838f3..8be31b41c32b 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -58,8 +58,16 @@ static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
 {
+	unsigned int name_len, max_len;
+
 	if (d.v->d_casefold) {
-		unsigned name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
+		name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
+		max_len = bkey_val_bytes(d.k) -
+			offsetof(struct bch_dirent, d_cf_name_block.d_names);
+
+		if (name_len > max_len)
+			return (struct qstr) QSTR_INIT(NULL, 0);
+
 		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[0], name_len);
 	} else {
 		return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
@@ -68,13 +76,19 @@ struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
 
 static struct qstr bch2_dirent_get_casefold_name(struct bkey_s_c_dirent d)
 {
-	if (d.v->d_casefold) {
-		unsigned name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
-		unsigned cf_name_len = le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len);
-		return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[name_len], cf_name_len);
-	} else {
+	unsigned int name_len, cf_name_len, max_len;
+
+	if (!d.v->d_casefold)
 		return (struct qstr) QSTR_INIT(NULL, 0);
-	}
+
+	name_len = le16_to_cpu(d.v->d_cf_name_block.d_name_len);
+	cf_name_len = le16_to_cpu(d.v->d_cf_name_block.d_cf_name_len);
+	max_len = bkey_val_bytes(d.k) - offsetof(struct bch_dirent, d_cf_name_block.d_names);
+
+	if (name_len > max_len || cf_name_len > max_len || name_len + cf_name_len > max_len)
+		return (struct qstr) QSTR_INIT(NULL, 0);
+
+	return (struct qstr) QSTR_INIT(&d.v->d_cf_name_block.d_names[name_len], cf_name_len);
 }
 
 static inline struct qstr bch2_dirent_get_lookup_name(struct bkey_s_c_dirent d)
@@ -212,11 +226,18 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
 	struct qstr d_name = bch2_dirent_get_name(d);
 
+	if (!d_name.name || !d_name.len) {
+		prt_str(out, "(invalid)");
+		return;
+	}
+
 	prt_printf(out, "%.*s", d_name.len, d_name.name);
 
 	if (d.v->d_casefold) {
-		struct qstr d_name = bch2_dirent_get_lookup_name(d);
-		prt_printf(out, " (casefold %.*s)", d_name.len, d_name.name);
+		struct qstr d_cf_name = bch2_dirent_get_lookup_name(d);
+
+		if (d_cf_name.name && d_cf_name.len)
+			prt_printf(out, " (casefold %.*s)", d_name.len, d_name.name);
 	}
 
 	prt_str(out, " ->");
-- 
2.51.0

