Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8913C25B2F4
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751287000; cv=none; b=b6iM4VCSRrrC9aHLjj3GLQjNObLwpOB2RpXMuDZyzvQPvpEFCdYKf7XSIh0ea1GVwAyMgu63d4Zj2X7DTezIVF0uzcf50pelJukFEbpByyVw5mdTy4INb+qMh1aMoifKgm1ksw4yTsemeeFL4FXtdxJz9LU/6mhYJIpdHmmj3Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751287000; c=relaxed/simple;
	bh=NEmpCzqubhlnGzUeTP/mMkasQO3gAg1wFxPV5otQUaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fgz7RwWgdgHW+7Dtvqu53Q0tgzU+7vKiKB7MVMCgYf06k54vsm/VteAojAVLt0k9Djwx2dGy9A7cp0CVNBm6Gt81exmnyqviyxm+SDZ5uFPS0Zf+yaSOI+aoicl2Ux9hUTGm/4PKHTwP3BG1ldv01qX1P98kwMYS9Kj8beN5Zac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WqsW73Ry; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqsW73Ry"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-235ef62066eso51436655ad.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 05:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751286997; x=1751891797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kLAq6DmNXWKNL2lyWZoDLGUhtMCrnbT/Lk4jjxKaWxc=;
        b=WqsW73Ryl3hil1SgxYmaLE0rt34P5H5WWVFPk9MIRdbRsTHSSUt7HOsjPmTjmr8wSk
         cMJ2cD5SBwv2QEvSDHLiZOfw6YvS+qWoCEZMr7OvsaqTQDRzxdhZ1nScECDtQ5nVWHrx
         isDSGmrDB6ph3ftlFy6atPYKQvAJbdqa9gwU/SiWEcki3Rwdgee/uGiV5FTVpTOP24Zx
         jf/4tg13/GGWUHQbDtW7BO46IhsCryDvr+QQee8nNuK2p7drweDQGMaj/91qVHRc6u9z
         viPfPRpHn52xbvyGYlEoiV/WyDxKp9HY75WBdoobRilUx6p7w6OnfNCs+I/FNQsNy4MX
         ZM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751286997; x=1751891797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLAq6DmNXWKNL2lyWZoDLGUhtMCrnbT/Lk4jjxKaWxc=;
        b=HWHy/2dnsgBiF+zA3ta9CVh1XqrsUBcchgEusrSZT9/9mPhIXHxWK4hwZUOIdpFO3P
         0rjDfnMvhGVH19yoSwI2HyLUQYirqou/q8Pj+6fC8ETQHvzx0fg58CruU59LFQaAOG3Q
         AiYhdYyFNXOZ2VXg1DjOVWXrGHFPhxuVAqzrDzJh0Gglg+qUzhhYus2ma1kU70OdMjAR
         T6EmLmUvmC4w6iVNmZs/uZRNWEUaFMWOQg+reX9RwsD79sCnhxSL41Dohb7UOFvh5wAK
         ZjblZwpv50Wj2uGsBE1Qf295xLZSg9iSzHWV6ogY5W4OTRf76bcvF8IzG8T7xViUx+IC
         uBcA==
X-Gm-Message-State: AOJu0YwRKSRnq/vQIzFO1ug6Hvm6Y7MZ59t0wgp2exbHldf5QVoP9IpS
	LofBl6fip95p2xeGQNjMwbvLr4xlsxR0bP8kCyRXSeg1TEK9KFAJrNTM
X-Gm-Gg: ASbGncsjMeBD7My6NwTlaJQlpERsBfXUmG+WBCOk8YKCiKnz3St3fIYXHK7okRQ9bSt
	tLenxu7+8BMl7xU+djmbVTC3WKrKLnwExSAO3ri7e/1zkfL1hFwyLGItY3bIuYHldRXIKcz74y7
	Numt41FYiOmAiaJjP1Y3eAkt85RVTODOgvVheYCOTbD9skjr5xTVCw9lFXUnMCW7RbsUWYHO0zd
	cYfGiSH/GXLe5R4X0qBn/JZnMj3w0tlLQv9uLfaNYCXkgM51FbUh1T2uNobICoveU+brtq6UdKn
	b+6ppXaIbZOV06BSdTXKlrcEajHc3T4662s0OqnAVLaLyKU=
X-Google-Smtp-Source: AGHT+IFOCWYyzub18BWI+kTrU28fhLXLgYhJynhWb4CiJ+9Yg/LYhXzAP/Ojb4YnyhldPn4zOlRn1g==
X-Received: by 2002:a17:903:1a8c:b0:237:f76f:ce34 with SMTP id d9443c01a7336-23ac40e02a2mr193307715ad.15.1751286996870;
        Mon, 30 Jun 2025 05:36:36 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3b7f5dsm78261425ad.179.2025.06.30.05.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 05:36:36 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix incorrect transaction restart handling
Date: Mon, 30 Jun 2025 20:36:33 +0800
Message-ID: <20250630123633.30702-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fsck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 4ceb28a6b9b1..453a5c3184ea 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2811,7 +2811,7 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 				ret = remove_backpointer(trans, &inode);
 				bch_err_msg(c, ret, "removing dirent");
 				if (ret)
-					break;
+					goto out;
 
 				ret = reattach_inode(trans, &inode);
 				bch_err_msg(c, ret, "reattaching inode %llu", inode.bi_inum);
-- 
2.48.1

