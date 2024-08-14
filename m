Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970951B3721
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723645217; cv=none; b=X65IBIRvgTG4rY0xPM/wI5E0s5JbJRWlkrjspAQSXmlJjWxx3m120AV6W8v6d4sxpbZ+K2JLgRmHfr+ubFI14MLIrR3EMzGb3hsEsqSdu+7J+nmEqatkhpArCsEJMBQlD51sfT1Y8KcTQyO01sDEv4L3PgHzgA+CC0wWPsgxBhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723645217; c=relaxed/simple;
	bh=H5L7BuM6j2QBkXZK8Qq060WApcVxWvrusU71uE25Ek0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=thuCU1nwEjFUEHCJ8BKTnnzza/DM+NQ2ZQVUoUiWmklILw8CiiCI+0wTs1N9V/5V3ayswBJkNmJtrNS9i7N5aX5URHJ7tTefp2MMIStX0CDtRIuYNlg4sY/j51t00NVH4mJeuUW2GpeYuOnRt/ft2WzcUdC0QBvvcxmTVsCN7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dFbdBTcf; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFbdBTcf"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fc587361b6so56789565ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Aug 2024 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723645215; x=1724250015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u9YYZBeOW5YQEvGW8tM/IB5F5qW+lea7LWu5dxO2Vsg=;
        b=dFbdBTcfZZLICWpu/Ko3B22Ze/t4wFjbyjaZtyDPyZ7brdlhvbS8b/AShypr6Jy6AQ
         TMfeo9jZAGKfeMii2l/bM8LZVS1q74SLRONR2P9SfTlJ3Qcg8eAelfiwZ0mvli/rKAAg
         G+BS6CK7r/WpencIVzqIxAwoImBwFxWo5X/Ig5nhuI70QZvN3KBWPl6csQVBwymcRwNl
         /FKEgjgN7wiCb8KOIxu2ZDr0rC4XiVqvDTJK/8ElkT3HFEQP6OLQEbI4Ch6tXJw3yulK
         FTr9MicwqVmpTeJhIdcG9/5stHR5BDPaPhxz9CkgxQuOXaapwTDg5BZ2U8IefxKzEqRy
         qepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723645215; x=1724250015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u9YYZBeOW5YQEvGW8tM/IB5F5qW+lea7LWu5dxO2Vsg=;
        b=t9L1Aryc0OTzDNgE6JYI4AB3hqmUCoT1MCp3nNGzmn8jsPbzLimAUAHeNK6RrsMebo
         TOIBICRJIgK0BXGOF0sp3YqN8aBQPTlOdE1ksgdilKcloJyXDkydHiBUOWiZR1g+HVsn
         JgYHgw9f2+aJmPparv7tiIDZQbYKbolOElu1+y4SUTayMTlq8DU4UU8HbxYggHVSWNqw
         KYPgxGFaiGeS0lkDytpVeDwzX4RrLzMpnrn+S2NfsoBjOhL4dJLAfXZcR5G8qemoCldd
         djrUWO5l8j5rRA1z6KvbgOmAQxWIwn0olTDWIVljwxGnlJOa99t6sNmgc59BDHyYIGMD
         P+kw==
X-Gm-Message-State: AOJu0YzubIB1ENs9gQ77gaxG323SJnGb6fqlAszblG5R7ZqGLr26K/Cl
	ziICmd/3WaRFEeSUdcQVWNxMrv4HBSkVgsKbfpPPg34NFIzpMNcf
X-Google-Smtp-Source: AGHT+IFaG31jmC+z0Xs2klYVZ9DHzRsC+N7Tad4I0/y+9znyOfXdyufx13FhKS0znSCTCHCpqvoyfA==
X-Received: by 2002:a17:902:cec9:b0:1fb:7435:c2c5 with SMTP id d9443c01a7336-201d64a5befmr37801115ad.46.1723645214681;
        Wed, 14 Aug 2024 07:20:14 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd14c58bsm30203925ad.72.2024.08.14.07.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 07:20:14 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Remove unused parameter
Date: Wed, 14 Aug 2024 22:20:07 +0800
Message-ID: <20240814142007.430009-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iter here is unused, remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c               | 1 -
 fs/bcachefs/bset.h               | 4 ++--
 fs/bcachefs/btree_trans_commit.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 0ccc1d962428..1b66b2c7e018 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -969,7 +969,6 @@ static void bch2_bset_fix_lookup_table(struct btree *b,
 }
 
 void bch2_bset_insert(struct btree *b,
-		      struct btree_node_iter *iter,
 		      struct bkey_packed *where,
 		      struct bkey_i *insert,
 		      unsigned clobber_u64s)
diff --git a/fs/bcachefs/bset.h b/fs/bcachefs/bset.h
index 5c6c7a14fa0f..6953d55b72cc 100644
--- a/fs/bcachefs/bset.h
+++ b/fs/bcachefs/bset.h
@@ -270,8 +270,8 @@ void bch2_bset_init_first(struct btree *, struct bset *);
 void bch2_bset_init_next(struct btree *, struct btree_node_entry *);
 void bch2_bset_build_aux_tree(struct btree *, struct bset_tree *, bool);
 
-void bch2_bset_insert(struct btree *, struct btree_node_iter *,
-		     struct bkey_packed *, struct bkey_i *, unsigned);
+void bch2_bset_insert(struct btree *, struct bkey_packed *, struct bkey_i *,
+		      unsigned);
 void bch2_bset_delete(struct btree *, struct bkey_packed *, unsigned);
 
 /* Bkey utility code */
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index ac0c92683aad..8b0b9e5ce72e 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -214,7 +214,7 @@ bool bch2_btree_bset_insert_key(struct btree_trans *trans,
 
 	k = bch2_btree_node_iter_bset_pos(node_iter, b, bset_tree_last(b));
 overwrite:
-	bch2_bset_insert(b, node_iter, k, insert, clobber_u64s);
+	bch2_bset_insert(b, k, insert, clobber_u64s);
 	new_u64s = k->u64s;
 fix_iter:
 	if (clobber_u64s != new_u64s)
-- 
2.45.2

