Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47453158871;
	Thu, 30 May 2024 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103670; cv=none; b=PXOm+xZAg84IBGmmrC9wi09zECqO5TK8XuMxsK0kc/LvBNTEsadb1d2SeZrS7FddbUhQdS5IAtijrFgz9nFMb0Ac0Ui1ETO9RiiSYSvBrnglO82h4YV+KFQwdyWT3OVPEIEQJ07Zp9FZYaGcW23XjsyXkiGmYMcF06bJHfZe8Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103670; c=relaxed/simple;
	bh=jEGvc2kG0JZczVn6pvihG5BKfl4A/GlsjosNT9wwcjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kwM6HXUazz95N+ztdMESmMTRKmm0pb4qiV/tROTjjHn6nroRmYp4SMwqU9S6R2+6qZu6/DV49c6CRmWKY6Vvl53W+PJLrcFKVY3g3sb5rtUDOhluvp+rfurmd2r2AcP6JZWBmLqtRbEu6CPDpSvAv1vjf69K7KjizRYODYM1O10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hXifnT/U; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hXifnT/U"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42011507a54so7607685e9.0;
        Thu, 30 May 2024 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717103666; x=1717708466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1nllQw3+kNPXXMf4c2R8JJbQH93lrzTHBYdXobfU07Y=;
        b=hXifnT/UyGHsyikHKhXZZQwpsWitvi2M1ZXiU8sHf8vqar98Jdt2RR9sSqO/n7oJ+K
         pL2LUBc1657UB3pevNYZrUCK6vFP1NTThph/BIdb3UYJ9Q7Kw098SVhu9e6hbnxj9ZWg
         4gtLKah3bv1oLYRN/EJZpcQ4ktMglIDqjkwcnezYLSxFIMHC7nXNampBi8IX02p9N2bd
         j9vFXZj2WrtzvaR/40LTjotT0SWP+uAFejsIAU/8sQn6F0sEPQbkhubgUvFxr+M/oYAW
         5/s8VnPIJEtlh2LhVQlhfpjJyX4faEUkZwdkTrF4vOYCNDbnuUOe2Mr9ZVpXv2Va2xu0
         +chQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717103666; x=1717708466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nllQw3+kNPXXMf4c2R8JJbQH93lrzTHBYdXobfU07Y=;
        b=KtBaB94DzVGub8TbF/MU6KfWVT1/G6nK3zV5Dh9cJCbv27g/Qo63Ct5WD8pI7y3LVm
         7wVs7isRw/kepq+/P+9IYGWRFYx8lDOAccgq+Iv6CSGnx7AvosMhltqW75O1MT5mqRuh
         8scrol/f+RQXfUYB1nTIQttGm3A7zOJEx7OcIQVeVzK9elsaFxZ2mTncvPax8z+TN9l/
         HzvljpB6G4sRnC3/pjutWWeAOqSNvv/O9W+VrCBQgzaGFGAsSXiqYoHcVxn+1H9h2Esr
         QBwTZyCbx8GOBFhHt3/b/NPPTH6dlVJHgAECtJdgGGFlQaVP9HiroVPcAsZ/X6xjiZRB
         yb6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYyhaR8P2d36H3h9KX3jVcL5vUQNmUryRjHMFKXb8oyn8N7g5FD1BLcbUF+xYL9+fchTk/mLlTRsfk7+tnKvemToNYW/w9QihzpCvZ
X-Gm-Message-State: AOJu0YxdLsaPXEQXJzC5DaN693Fi5VELvAwHLj/A1kIJD1HKQBeVmGOy
	W64zSLF8SkzXbwpMff8oJ3e+BUJQQmbsAkqU+nKK7B2nSjlSwUJJq66kLKRv
X-Google-Smtp-Source: AGHT+IGnMCKAJtwi+rxYoj05lhu+lIEK6KuiKb8S/VeMxBAwd9RQTX05Qpw/N0IU9gKj87tAsE3xrQ==
X-Received: by 2002:a05:600c:4ece:b0:41b:e55c:8dc1 with SMTP id 5b1f17b1804b1-4212811fe12mr23893715e9.20.1717103666243;
        Thu, 30 May 2024 14:14:26 -0700 (PDT)
Received: from localhost ([2a02:2f0e:516:6100:c1bc:fdf:3ee9:2792])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421270ad598sm34770065e9.41.2024.05.30.14.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 14:14:25 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcachefs: bch2_dir_emit() - fix directory reads in the fuse driver
Date: Fri, 31 May 2024 00:13:58 +0300
Message-Id: <20240530211358.107307-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 0c0cbfdb84725e9933a24ecf47c61bdeeda06ba2 dropped the ctx->pos
update before the call to dir_emit. This breaks the userspace
implementation, causing the directory reads to be stuck in an infinite
loop. This doesn't happen in the kernel because the vfs handles the
updates to ctx->pos, but in the fuse implementation nobody updates
it.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
V1 -> V2:
- added a comment explaining why the update to ctx->pos is necessary

 fs/bcachefs/dirent.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index c67460d8205d..d743da89308e 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -534,6 +534,14 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
 static int bch2_dir_emit(struct dir_context *ctx, struct bkey_s_c_dirent d, subvol_inum target)
 {
 	struct qstr name = bch2_dirent_get_name(d);
+	/*
+	 * Although not required by the kernel code, updating ctx->pos is needed
+	 * for the bcachefs FUSE driver. Without this update, the FUSE
+	 * implementation will be stuck in an infinite loop when reading
+	 * directories (via the bcachefs_fuse_readdir callback).
+	 * In kernel space, ctx->pos is updated by the VFS code.
+	 */
+	ctx->pos = d.k->p.offset;
 	bool ret = dir_emit(ctx, name.name,
 		      name.len,
 		      target.inum,
-- 
2.34.1

