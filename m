Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7D179BB;
	Thu, 19 Sep 2024 04:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726720752; cv=none; b=UzqvG6PO6wlBzUDEUkd4dShEjurucaSqMu8sQNMcdpNDdovAqd+mcXxH26VRa053oqs/7eoWbEHBuQVj/djMzFglTEFA+hZasv6sUJHHIAkjzey+wJmO/qQCqb2Php5iJJdSJxCTVWs+8TkcUfuqfviS9o8Vtlnmxcz0k5tX1u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726720752; c=relaxed/simple;
	bh=AhDDV16CAM1bIVJmnn4AjLcj0E3zKxqLPA5BuscoBfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LY5MPyqATlhLrpPBAX2U1N8AqtJ/33STCmrLXwKSeHJkqb7ABVpgdl2Dgm/LW1/DZ5YeVMn0GhX1kZeXxmfk2FtqwvSApWM3sTtas6GerDMNJ2W4YuU82XpgZ0pwtffUmL73wGixY09F24S+YoHe8JVRXXLD2lu4XTmqDsojuIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Die1KmbM; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Die1KmbM"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-374bd0da617so219483f8f.3;
        Wed, 18 Sep 2024 21:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726720749; x=1727325549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ2dAlU0FPGmL9S8I0VK6XpEgS9zDbDDtV9MJ+yKjYg=;
        b=Die1KmbMwPVHto0JnT9O9CZf6EXbYYpf6K8iSlHDqkkY0T8b+iK8M1jbsZTlm0KKle
         CtkMu6WTQ84XKTl8UptPPxJdWSoV6gWu8fsnC259wCQbXbO+kbz2lg0mJxEygAbF6Z/Z
         VItQGEpwIMs/e/F/4riFEUVjaDVEe6zwAD4vssUkzz+iTo1SqLdjstkRqUxUkvIWmaCj
         sJNBF3RxTkgEUqhbwCSErkmEZlTmNgbcYwzgwiOrOWR2x+Pwrj+59GkDvr4tcQCfLho2
         AksB7pj94yM6oNlKs66CkSktjXUthGkoDQ0TIJ03SMkMhmvWu/x2BA9eSg6yrgH9TrBu
         FiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726720749; x=1727325549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZ2dAlU0FPGmL9S8I0VK6XpEgS9zDbDDtV9MJ+yKjYg=;
        b=wnK5Wy/2MKNB7XG4LH4EaUQPeoobAa34IkszORzmaBsqlWkvgllaeHsdhv7uRu4Uu7
         4T+g6G9oZrgXdz8kRhU4XsSsjoCGoKib2eWoho/LBI59cGpf6y6tH8zA2uywkvfKmHaw
         KDne5vTrt5diFcuyxxne8IOVqZv1tLCNelAZFp0Yoft2dTBlBX6ZPDB9SQZysicsxYVh
         TbjfXlwLerOr0taZ25LLZ4udc5F+5aVrht1YDe0HPWxahiInJPMqiPYgQPDdPPMylbgj
         jitZwH4Mozygd7ZIMPcUITmnQzrvY+dXxbE87XCMDUj9lfkjQhwbs/nIFba5wYC1iAf7
         uOUg==
X-Forwarded-Encrypted: i=1; AJvYcCXkgkwDtjwrj6O8ch417gaL0u7w/emi6yM/HXWXCyS/0razOLB1hlcjw8pKu7J5IMNdbuoJFIGdgpNrfDuWlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSPounERSOZN7U5tVVnPw2U543Sn19m8J/GdAwui0Dsadk9owt
	ncicMwXWZCaWQtXTXHOxacLqeu2qXH+hp2yIs04/Az7zxiX0sW461VN8MOXdhWs=
X-Google-Smtp-Source: AGHT+IH8oED88WkaPlmY+EQSh9Lp9R1rO87lXfjjDNRsm2K00s7wzeXlQ1ZIa52G+VfsyofiDtYFLQ==
X-Received: by 2002:a5d:6a92:0:b0:378:80ab:9968 with SMTP id ffacd0b85a97d-378c2cf45d0mr11990549f8f.17.1726720748528;
        Wed, 18 Sep 2024 21:39:08 -0700 (PDT)
Received: from localhost.localdomain ([197.35.194.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e78044easm14038656f8f.91.2024.09.18.21.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:39:07 -0700 (PDT)
From: Ahmed Ehab <bottaawesome633@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	syzkaller@googlegroups.com,
	syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Relocate rcu_read_lock()/rcu_read_unlock() to snapshot_t()
Date: Thu, 19 Sep 2024 10:36:03 +0300
Message-ID: <20240919073603.1827-1-bottaawesome633@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reports a problem that a warning is triggered due to suspicious
use of rcu_dereference_check(). That is triggered by a call of
bch2_snapshot_tree_oldest_subvol().

The cause of the warning is that the rcu_read_lock() is called in wrapper
methods instead of calling it directly before calling rcu_dereference()
in snapshot_t().For example in this case, snapshot_t() is called
directly from bch2_snapshot_tree_oldest_subvol() without holding the
read lock. This also results in duplicating the rcu_read_lock()
and rcu_read_unlock() calls, which may lead to future errors in the case
of forgetting to hold the read locks as in this case.

To fix this, move rcu_read_lock() and rcu_read_unlock() to snapshot_t().
This will make sure that rcu_dereference_check() is never called without
holding the read lock.

Reported-by: <syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com>
Signed-off-by: Ahmed Ehab <bottaawesome633@gmail.com>
---
 fs/bcachefs/snapshot.h | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/snapshot.h b/fs/bcachefs/snapshot.h
index eb5ef64221d6..04f18fac56fe 100644
--- a/fs/bcachefs/snapshot.h
+++ b/fs/bcachefs/snapshot.h
@@ -42,15 +42,19 @@ static inline struct snapshot_t *__snapshot_t(struct snapshot_table *t, u32 id)
 
 static inline const struct snapshot_t *snapshot_t(struct bch_fs *c, u32 id)
 {
-	return __snapshot_t(rcu_dereference(c->snapshots), id);
+	struct snapshot_table *temp;
+
+	rcu_read_lock();
+	temp = rcu_dereference(c->snapshots);
+	rcu_read_unlock();
+
+	return __snapshot_t(temp, id);
 }
 
 static inline u32 bch2_snapshot_tree(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	const struct snapshot_t *s = snapshot_t(c, id);
 	id = s ? s->tree : 0;
-	rcu_read_unlock();
 
 	return id;
 }
@@ -63,9 +67,7 @@ static inline u32 __bch2_snapshot_parent_early(struct bch_fs *c, u32 id)
 
 static inline u32 bch2_snapshot_parent_early(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	id = __bch2_snapshot_parent_early(c, id);
-	rcu_read_unlock();
 
 	return id;
 }
@@ -89,19 +91,15 @@ static inline u32 __bch2_snapshot_parent(struct bch_fs *c, u32 id)
 
 static inline u32 bch2_snapshot_parent(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	id = __bch2_snapshot_parent(c, id);
-	rcu_read_unlock();
 
 	return id;
 }
 
 static inline u32 bch2_snapshot_nth_parent(struct bch_fs *c, u32 id, u32 n)
 {
-	rcu_read_lock();
 	while (n--)
 		id = __bch2_snapshot_parent(c, id);
-	rcu_read_unlock();
 
 	return id;
 }
@@ -112,10 +110,8 @@ static inline u32 bch2_snapshot_root(struct bch_fs *c, u32 id)
 {
 	u32 parent;
 
-	rcu_read_lock();
 	while ((parent = __bch2_snapshot_parent(c, id)))
 		id = parent;
-	rcu_read_unlock();
 
 	return id;
 }
@@ -128,19 +124,15 @@ static inline u32 __bch2_snapshot_equiv(struct bch_fs *c, u32 id)
 
 static inline u32 bch2_snapshot_equiv(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	id = __bch2_snapshot_equiv(c, id);
-	rcu_read_unlock();
 
 	return id;
 }
 
 static inline int bch2_snapshot_is_internal_node(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	const struct snapshot_t *s = snapshot_t(c, id);
 	int ret = s ? s->children[0] : -BCH_ERR_invalid_snapshot_node;
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -157,9 +149,7 @@ static inline u32 bch2_snapshot_depth(struct bch_fs *c, u32 parent)
 {
 	u32 depth;
 
-	rcu_read_lock();
 	depth = parent ? snapshot_t(c, parent)->depth + 1 : 0;
-	rcu_read_unlock();
 
 	return depth;
 }
@@ -175,10 +165,8 @@ static inline bool bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ances
 
 static inline bool bch2_snapshot_has_children(struct bch_fs *c, u32 id)
 {
-	rcu_read_lock();
 	const struct snapshot_t *t = snapshot_t(c, id);
 	bool ret = t && (t->children[0]|t->children[1]) != 0;
-	rcu_read_unlock();
 
 	return ret;
 }
-- 
2.46.0

