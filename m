Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65579433A9
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 19:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727895999; cv=none; b=EQMCZKy0gE4cCIsdDDTbg5XSBqeunIg9BPwYtXuXzTtwDSV9XlfaGJG+gICokbvLwZIJfqKSdDeh3v47EEKxnhIen89aDEJCRuLRtgETcIEoihwF5izP2GhJ2xPbYfUrs1K8a3f6D2rQZoMfKP0LJFtOGYHtscADslnb0Pe/oSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727895999; c=relaxed/simple;
	bh=2jCsnchFiJDKPsjmiRia0b1POb0p41oXVSJ98nmj3k8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qc4vHfN3m1fnqas6oP9dwfnz5ORMBIiJk/hRF4BMFnDbtcwBLCvGbOMCpuGqat0XUEV0+htAZyVAzQDPe9jl9q59ws5JD69Zx3Fijxl0Ntu3WeL+5N5lSsd+Tod9cnR9t2YNOkzG9FiKqRSgTedBUlnlkaJ1bTIyDPxL+VWqVWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuUi0bWe; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuUi0bWe"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71788bfe60eso167235b3a.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727895998; x=1728500798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EVpys+9PmDd+oxUXzYz6ugE6lNzdqGIoh29HNno5An8=;
        b=DuUi0bWetwsfJ9TGUTBIC4jjFb7T5KQ3WDfy0YKP8hXJaIrPiuNf/fCiBxTVYAGybB
         Dn+95/XmzFBUiilhh2DQbquVWc3W54jrGoUYRaXBqbPfJzUA2VSjWgOu9PffzFcudI82
         xe1EOsi4PQY7tjZ2ZLbNHaLo3uJibdbLZtikrDdcas9isPD3yWEqMN2Vc13MgJGXEj+e
         EeSzEUjkKf3WrqffBzwAaRyq912pLY5Dwl90MAk5HYy9q+GlmZIVX18lNHhDqzB62Rvb
         dpvhiX3TgUHUfP6N/eSiXnCW8DBqlKpJX4mQ+WoOi04nekBQycv+URX6B6BbV5tHKPHK
         athQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727895998; x=1728500798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EVpys+9PmDd+oxUXzYz6ugE6lNzdqGIoh29HNno5An8=;
        b=smYddmFbvaexfOgTEFqpv23ixswe1nCkX0eFmaOXE6RkIuzUMecgl2cP5jV1qhF0lx
         biI3Yg8U0LR4upcVzbN96PSXgMGOKLKsAwR2eVYlQu94+X7bffqiX1p7fSA6Iyv6Jrmw
         jCf05r3pN9La5URFyJDqxsgtY3hMA0qHJ2idKo3XnIacv3tPNhEl4FNt+qk7rlcrZRXw
         s+YxW5RQeMb3jRj/XFhDvAiLqP56vx9xKewns9wMybwjFl1HXQV6E4Ju6pFG+5WSCCx3
         8xP4RAZ0P8RJ9Wp2+GG1HXduneHAZzNsNODlX5ZnKeEREyJvZfdMyN47mZ/DEQgvpvbd
         w4Xg==
X-Gm-Message-State: AOJu0YyNvPwTQY5ofyWkL2umC+dgVbepULv8i9zoQFjesUdnNAhWnql5
	78nC7z/zjAeF5SwvKnNs+l33nJXha2xY0Un6rDQxOnQFH+HaQqDIsEhA0r1o
X-Google-Smtp-Source: AGHT+IHB9CTbnvNvmjkoALpnIfc41bJOTSm7ByZ+KZtCFNU1f1jz9Su/Oq9/4X3l6lBWWNC4nYLqKA==
X-Received: by 2002:a05:6a00:4fcb:b0:714:241d:a323 with SMTP id d2e1a72fcca58-71dc5d5102bmr6486894b3a.17.1727895997652;
        Wed, 02 Oct 2024 12:06:37 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2649bed5sm10190692b3a.24.2024.10.02.12.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 12:06:37 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/4] bcachefs: Convert open-coded lock_graph_pop_all to helper
Date: Thu,  3 Oct 2024 03:06:30 +0800
Message-ID: <20241002190633.1454448-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 617478fd5351..50d9366d49bd 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -229,8 +229,7 @@ static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle)
 	ret = abort_lock(g, abort);
 out:
 	if (ret)
-		while (g->nr)
-			lock_graph_up(g);
+		lock_graph_pop_all(g);
 	return ret;
 }
 
@@ -252,8 +251,7 @@ static int lock_graph_descend(struct lock_graph *g, struct btree_trans *trans,
 		if (orig_trans->lock_may_not_fail)
 			return 0;
 
-		while (g->nr)
-			lock_graph_up(g);
+		lock_graph_pop_all(g);
 
 		if (cycle)
 			return 0;
-- 
2.45.2

