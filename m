Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4326518EFD4
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 May 2025 10:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747133673; cv=none; b=PRukIFRBrP7P/a1KgedhInPXaNloCNpnhyU3U4AjlCVXbJYxAjnEyGEGyVuNmdaSU3ZjdVPJAmq/FqAfqPDsr8nfxr51Ii0ggoaGWAga3pDPNtW0g+hDEPt8TTyr2sbdmSrDkbX8rhPCjJckUx+4mfqu5lR1FVKhj5BzAdr8D9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747133673; c=relaxed/simple;
	bh=meNvXeFj1t9MejO49oUyGnNfLlfEyHEaXd6VODGG29M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WMm3f9qUzJf/uh7dM6nH8HTv8HZdQvG/T1uXrVbhZmUbpvCywbboIt2qCJxt9DWGG83uVcfUixQa0klscMq4VMe0gE58qGBkWss/8OrhPVZuFSgBKcKpVfUftRaqzZrX9LRNMJU74BATeXv19HUbpCOmnuDXz41eTGyigDNtG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mq6fnjOF; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mq6fnjOF"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30c35ac35dfso4277685a91.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 May 2025 03:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747133671; x=1747738471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hIfoMOG3phTXJ1iuBl/J+lr9iNBv9GYsqqY6CGa5XvQ=;
        b=mq6fnjOF6dg+1dShStf7SVN4g3VGH0EX5UfEvFdhYdmgEBS3j4R8uXd7DCSsWagJgb
         3Ce6j/0yl8q0IiDPCQva2/DeA2aEtuS3KwoiWkgbrv7LtjjmaI7Gt+JQrOs6RMR1QTqS
         FdIaYlw6YjYEzCjkBOxmhHJ96D0zd1hOIQ+vrwajwQLQWQTsnq80piMW9Zb25bIDvRi7
         h1Bhm/SepH6NOWljbI0R+mKKeQvJ6FXnL2xUL3tJpCZ6z3AlRmPMLA5YO8iJqqXpp5W8
         JDvzffVW3xUZBtXqDTCgn8ek0/LZ1SBfePP1R4MkKWUYKNUoxculTbZZtdsKn3ED/ayM
         nTkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747133671; x=1747738471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIfoMOG3phTXJ1iuBl/J+lr9iNBv9GYsqqY6CGa5XvQ=;
        b=utPCw0sgesQZX7I/hGMJCBUNrMjgrdoAqXQT/3i1mRvAC/3TBsD9nUiYDP6SkcvCXI
         dZzLyhL/CqLTTcLG3r4+xQwiRhpzvwwd7Fv4RwUulZkhJXyeSxDQjQxdx5C1slRQSsHn
         3wqdtpcPKmn6fwCSE6EagVJkXR6F+2/K28PmhdIW6mstREBBem+fmpe6U1VAzbysjKo6
         kfQKMPhGsZGU6c/xv86I0IhR2q8V3M9omfNw3jShCDUpUqMQSd4k+M4ZjSDa1QTxrbvU
         Bv6QcitI7J3ep4iY/vtcROGWM9Z5FO0NPKyQyFEpi58OlnU7x+VdcCeTaKWFSCMdcmT3
         /a3g==
X-Gm-Message-State: AOJu0YyjSJh4AcTAedj26sDScirK3qcVXGp97m53zhmGJ4DoRfdyFJlL
	eOBbgzi0nr0bmYRfvBJgWk5bMcAnRV2Mj96oRV20x4scGh/Sja/pPUEXTA==
X-Gm-Gg: ASbGnctSTohs90PbKRC6DILuD9BKXX6yzxGG7eqL0PpyXSM80qfvJYviPkv4SWqgrew
	kz/ms7UKMgoH0tnPm0qA2i2DX3q1tpJfC5v4dYaEo+j+F2DPoMHGk8u9O+gDidT886TYkDVjPbL
	SpXSvsCEJsQ9FBjQvjq1ZKnYLiBrZZRqHipwhXb9+hCjVU+o15LBa64g9jmGz5vfsm5r2LEwCLr
	BmojoL0A3bog6pFph2iARB1jG2fi9d9MHYZETnLMVcUiYSPq5+BnAghxNbgRj7VBSXs+R9vyc34
	IykGNNqcHKp2d586njRR2MaJrNGCco7vFPJh
X-Google-Smtp-Source: AGHT+IEze8iPSkj4BkjdaJNlmVDm4a56nXmgaDk0/GP2/+astqnFrRNr3Bo8OiqQot2pOt5DQpiHbA==
X-Received: by 2002:a17:90b:1a89:b0:30a:29be:8fe1 with SMTP id 98e67ed59e1d1-30c3cefb759mr27081410a91.9.1747133671326;
        Tue, 13 May 2025 03:54:31 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d54fc1sm10475492a91.24.2025.05.13.03.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 03:54:30 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix self deadlock
Date: Tue, 13 May 2025 18:54:26 +0800
Message-ID: <20250513105426.239043-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before invoking bch2_accounting_mem_mod_locked in
bch2_gc_accounting_done, we already write locked mark_lock,
in bch2_accounting_mem_insert, we lock mark_lock again.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/disk_accounting.c | 17 +++++++++++++++--
 fs/bcachefs/disk_accounting.h | 16 +++++++++++-----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 2dcccf1edbb9..195dc3fcec1d 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -376,6 +376,19 @@ int bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accounting a,
 	return ret;
 }
 
+int bch2_accounting_mem_insert_locked(struct bch_fs *c, struct bkey_s_c_accounting a,
+			       enum bch_accounting_mode mode)
+{
+	union bch_replicas_padded r;
+
+	if (mode != BCH_ACCOUNTING_read &&
+	    accounting_to_replicas(&r.e, a.k->p) &&
+	    !bch2_replicas_marked_locked(c, &r.e))
+		return -BCH_ERR_btree_insert_need_mark_replicas;
+
+	return __bch2_accounting_mem_insert(c, a);
+}
+
 static bool accounting_mem_entry_is_zero(struct accounting_mem_entry *e)
 {
 	for (unsigned i = 0; i < e->nr_counters; i++)
@@ -585,7 +598,7 @@ int bch2_gc_accounting_done(struct bch_fs *c)
 					accounting_key_init(&k_i.k, &acc_k, src_v, nr);
 					bch2_accounting_mem_mod_locked(trans,
 								bkey_i_to_s_c_accounting(&k_i.k),
-								BCH_ACCOUNTING_normal);
+								BCH_ACCOUNTING_normal, true);
 
 					preempt_disable();
 					struct bch_fs_usage_base *dst = this_cpu_ptr(c->usage);
@@ -614,7 +627,7 @@ static int accounting_read_key(struct btree_trans *trans, struct bkey_s_c k)
 
 	percpu_down_read(&c->mark_lock);
 	int ret = bch2_accounting_mem_mod_locked(trans, bkey_s_c_to_accounting(k),
-						 BCH_ACCOUNTING_read);
+						 BCH_ACCOUNTING_read, false);
 	percpu_up_read(&c->mark_lock);
 	return ret;
 }
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index 6524cb14a58a..54cb8a5b117d 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -136,6 +136,7 @@ enum bch_accounting_mode {
 };
 
 int bch2_accounting_mem_insert(struct bch_fs *, struct bkey_s_c_accounting, enum bch_accounting_mode);
+int bch2_accounting_mem_insert_locked(struct bch_fs *, struct bkey_s_c_accounting, enum bch_accounting_mode);
 void bch2_accounting_mem_gc(struct bch_fs *);
 
 static inline bool bch2_accounting_is_mem(struct disk_accounting_pos *acc)
@@ -150,7 +151,8 @@ static inline bool bch2_accounting_is_mem(struct disk_accounting_pos *acc)
  */
 static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 						 struct bkey_s_c_accounting a,
-						 enum bch_accounting_mode mode)
+						 enum bch_accounting_mode mode,
+						 bool write_locked)
 {
 	struct bch_fs *c = trans->c;
 	struct bch_accounting_mem *acc = &c->accounting;
@@ -189,7 +191,11 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 
 	while ((idx = eytzinger0_find(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
 				      accounting_pos_cmp, &a.k->p)) >= acc->k.nr) {
-		int ret = bch2_accounting_mem_insert(c, a, mode);
+		int ret = 0;
+		if (unlikely(write_locked))
+			ret = bch2_accounting_mem_insert_locked(c, a, mode);
+		else
+			ret = bch2_accounting_mem_insert(c, a, mode);
 		if (ret)
 			return ret;
 	}
@@ -206,7 +212,7 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 static inline int bch2_accounting_mem_add(struct btree_trans *trans, struct bkey_s_c_accounting a, bool gc)
 {
 	percpu_down_read(&trans->c->mark_lock);
-	int ret = bch2_accounting_mem_mod_locked(trans, a, gc ? BCH_ACCOUNTING_gc : BCH_ACCOUNTING_normal);
+	int ret = bch2_accounting_mem_mod_locked(trans, a, gc ? BCH_ACCOUNTING_gc : BCH_ACCOUNTING_normal, false);
 	percpu_up_read(&trans->c->mark_lock);
 	return ret;
 }
@@ -259,7 +265,7 @@ static inline int bch2_accounting_trans_commit_hook(struct btree_trans *trans,
 	EBUG_ON(bversion_zero(a->k.bversion));
 
 	return likely(!(commit_flags & BCH_TRANS_COMMIT_skip_accounting_apply))
-		? bch2_accounting_mem_mod_locked(trans, accounting_i_to_s_c(a), BCH_ACCOUNTING_normal)
+		? bch2_accounting_mem_mod_locked(trans, accounting_i_to_s_c(a), BCH_ACCOUNTING_normal, false)
 		: 0;
 }
 
@@ -271,7 +277,7 @@ static inline void bch2_accounting_trans_commit_revert(struct btree_trans *trans
 		struct bkey_s_accounting a = accounting_i_to_s(a_i);
 
 		bch2_accounting_neg(a);
-		bch2_accounting_mem_mod_locked(trans, a.c, BCH_ACCOUNTING_normal);
+		bch2_accounting_mem_mod_locked(trans, a.c, BCH_ACCOUNTING_normal, false);
 		bch2_accounting_neg(a);
 	}
 }
-- 
2.48.1

