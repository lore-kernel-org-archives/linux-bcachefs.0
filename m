Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A4621
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Sep 2024 00:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726272707; cv=none; b=rQZliUr9QO9r/EAvXlf29cQa7qprMAGawuAKy77Fl+2F5odRgVm1PMLY7WYV6pdSPikSsVu6JQ7+4REzAPkfTyXMwHn2mWrZmMx7rYAgk6qHZRVQ6aV7hLcfhluIFv+UqvHnchx0DVe/wFKtHsxkfMH9VVqwAeUL2lRaRL0USUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726272707; c=relaxed/simple;
	bh=V/HxeAARJDEE934K9M0Um8l2URlpl4rrIOEurTsjB58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cHHl04BJQSnxhtzrIwPe4jHzdtBFbgZYjsiFSRHjujEvqS33AiPW1yHT1QbbA6gJCDHIKR6/N5wyjLLEG2fMw9686l2eFk8u9eMGsJJ9RpU7spgQlvKGRlbdeDDPRgrYCN+sMbv1xHCasfH/ltR6SviQh8gkKybHrDgJbiBGuA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvdbYkgO; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvdbYkgO"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2053a0bd0a6so27937805ad.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 17:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726272705; x=1726877505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w+etmRF9lAIi8MXNkH+uthS+MnHehSrQyhpawHP+bFE=;
        b=GvdbYkgOXUThcrXNLUYSQJUS87uqAc9+AY5WrrLv2bVrr8d5imqsQ5zIORLhe8+JkS
         Bj9x0ARMGUVmpDKR/Mq1Ho3v0Ac4RKv+t17EzmpBXNlKwgLT1WR7vLodBBPMSe5Zjhjs
         TE2AxGpqxbQAz7XkFhV8rRAJdmX2oKsY5M4uB0z2oj+e/660yzeL+SR7k/Cx1WQjJaf5
         FTLR+PuhwhgGjNqUaamLs7aJAxZ1y0Pxk4WNrzZ9T346O2D4c7buiuJh9AUvC/3gjIZv
         m9P4PGwHpP6xDynutYASmQKg4uQPYAeVDdDbn6RnbkD7A4KqF3MNMn3YQS5HwfayH2R/
         RuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726272705; x=1726877505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w+etmRF9lAIi8MXNkH+uthS+MnHehSrQyhpawHP+bFE=;
        b=Hwy/8FyZULKRszmHxmdWiAUw9NDVIZy06z1sByQbVePWC38X9YPzqmkx5tdOd48pgy
         MY314RjwznaeZu8YgYt0cakab0k9dvH0VlD+udwEKAoV3iqS/uq/hNmyYL8jdlCZ6Z9m
         TPWfzrB/cOBaU6n5J2T/JSCq/9H/Pl2GtjScYhGIS/JHYEsbZFTHc1RnA4wDEvb8Null
         0EcQLbK0MVzgS0041iJOVru6PLQ5aIQY4wO7UeAHpIPVK0x5m3PxYcAgzSsC27n1ZHOq
         Al1ZOBqtao/uzSJ0KiPiGbBSyeb5mFdV3OYtV9hBcsgO6xPGvjS+kPga6iwe+REDIFXf
         Xq4g==
X-Forwarded-Encrypted: i=1; AJvYcCVhspdzrePqEZG56L49/EdjHpIj6grZf35bz5qAd3m6PpJ40clg6rFl7hHdDSV/ARU6fXkbgMGiw+KfaYaaFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsllWZNZG7DSTAacg34EO5W6FkjzPBa76GCnI0Qay9Z0WAEhwM
	TtfgXyflJuzdre09UkCSnGS6R5MVPZ7RDjwZKyzjQXLfvNkdhSCM
X-Google-Smtp-Source: AGHT+IGzVbBIueTeUBdNnL9Z2lj8dXjjHk+fGi1kbY4GfV+Lc31g+w/tlwFD+QsAG0te16VBo3eTDw==
X-Received: by 2002:a17:902:cec1:b0:206:dc3e:6914 with SMTP id d9443c01a7336-2076e3a9912mr117879965ad.36.1726272704738;
        Fri, 13 Sep 2024 17:11:44 -0700 (PDT)
Received: from fedora-laptop.. ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207945da80fsm1687585ad.5.2024.09.13.17.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 17:11:44 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: [PATCH] bcachefs: move bch2_xattr_handlers to .rodata
Date: Fri, 13 Sep 2024 18:11:22 -0600
Message-ID: <20240914001122.119103-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A series posted previously moved all of the `struct xattr_handler`
tables to .rodata for each filesystem [1].

However, this appears to have been done shortly before bcachefs was
merged, so bcachefs was missed at that time.

Link: https://lkml.kernel.org/r/20230930050033.41174-1-wedsonaf@gmail.com [1]
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/xattr.c | 2 +-
 fs/bcachefs/xattr.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 56c8d3fe55a4..9986bc7ffe73 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -609,7 +609,7 @@ static const struct xattr_handler bch_xattr_bcachefs_effective_handler = {
 
 #endif /* NO_BCACHEFS_FS */
 
-const struct xattr_handler *bch2_xattr_handlers[] = {
+const struct xattr_handler * const bch2_xattr_handlers[] = {
 	&bch_xattr_user_handler,
 	&bch_xattr_trusted_handler,
 	&bch_xattr_security_handler,
diff --git a/fs/bcachefs/xattr.h b/fs/bcachefs/xattr.h
index c188a5ad64ce..2c96de051f3e 100644
--- a/fs/bcachefs/xattr.h
+++ b/fs/bcachefs/xattr.h
@@ -44,6 +44,6 @@ int bch2_xattr_set(struct btree_trans *, subvol_inum,
 
 ssize_t bch2_xattr_list(struct dentry *, char *, size_t);
 
-extern const struct xattr_handler *bch2_xattr_handlers[];
+extern const struct xattr_handler * const bch2_xattr_handlers[];
 
 #endif /* _BCACHEFS_XATTR_H */
-- 
2.46.0

