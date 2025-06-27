Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C562DFA4D;
	Fri, 27 Jun 2025 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751042504; cv=none; b=XtTvmlZosjpkvKPDp3Mjop6vS5TW/IVbiG7xx4Gxvr3kL6B3oOQqENDat4CR4nkamlRzxG458mZDYmfo9PhV3KCCsGOa6Mau2cL/EPULQeZ3H1u6m6GFnC12riHq+49TerghRvAvCDv3ECqiGW75jLsEvyXKE90aAXACnxPULOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751042504; c=relaxed/simple;
	bh=ZuEQ1zQrVtuPrJ/IhK0yiaA3AB1kj94s9i4/FDqfzHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HrrWJRjDZREYnGma9NjVQO6NAvdBhaPDoxWvVx7lQh8Tq8d4uuuCtgkVWizF32uhwBOod4NJejgBvSqOkRu9rYtzZtBBy3vIpyk3hUN58YL1VW9y921q3tFGT3qpBxzCFWk3E2TjbGKW62KGh+qkqnRiREapCmozTSFLbxe4fSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evWL1ecz; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evWL1ecz"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-74931666cbcso2483664b3a.0;
        Fri, 27 Jun 2025 09:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751042503; x=1751647303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2i7605PqYhjxoEfLi96zRKazL0WE2fE/OxEmeLqdoGw=;
        b=evWL1eczoiJbcZUOJnHRTb9dZLIjKyTFQiSbdr7k9QGR3q76UlZT34JPQydoAuZh8C
         JyoH1JuNOwx9PHNKUCENDb+xAmIy93yNdAXI+G1nlFNL4XTDBhjccC0WkM+1py0Lemnk
         /q0qJSyMx/y07iDEv+D2OwW34aKS/SJzU9qN8IHPDgpJJhCIcZUmB1fGILFaSZuUq8XC
         JFhr2bkzBHkWxkoTL7dHSLfgePNYYyBagkaucRcFTL+5AnRNMZF7VlQTSfipahQC9Cga
         vtn6akQZ4ZHXv+Qbt/R2d7/3mKrUbN1EHvMMN/WL3slMLoTJXxmPBSmsMSYAo2acmApJ
         4Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751042503; x=1751647303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2i7605PqYhjxoEfLi96zRKazL0WE2fE/OxEmeLqdoGw=;
        b=xVn4DZZZxhiVKFLVSxVr5LIjWJ2aI39HQj3eDal/ty+MPFZztylhvnaQDVPUArk1i9
         0rxzsVghlveIG0tKNTA9HVqvHHMgd+ywB25zyxLnwQJIoVo2rMLCnBztaaWU0yy6yLmI
         X72/v0JqkgtvE0EHoDMtN29dPPqcq0lmjB/5av2qwK26C6nIfH5X5o2sMr02xdU/8zNP
         buoG0FQTctbMQSZKveZEUxiV5NZFIx4BXmMinQ0TPpbu78bwNty7qtWLi36Y96yq4rlq
         5axBOYmq09BVT/VwBoafjy4LJs1V3+odoic+XWs7Z/ZiK4ewFk57sXVUjN5HAU3c+Uk7
         IOXA==
X-Forwarded-Encrypted: i=1; AJvYcCUD1zp1PUqOlRKIwdQz8AtHD0w49wjNv5WFP4pB4A07MdzMBD4IIF08zk3XaUupRnxxq553IunohP+GUUhtrg==@vger.kernel.org, AJvYcCVn/AFPo03aL9AdqYPCuA8F/LbsFgMQcVDc86Rj844oySmNwgJCPTz/dS+3PVl9QUfU3tnzBcw4LiJnMuQP@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6gGeR53NN4AjlVotHQD598dnTY8W+V7DeYIEAd1cMwNXg6S3c
	3JPc7ABrK44NLXtxoVqb4UkEKzxzj311fqOfpiOCgZkMgk4waiOl2fxL
X-Gm-Gg: ASbGncv+0bZVRa3m+XzDro77SwiH1aioqS29DB9BShInyYzLqMvQV4zI8WjGRgu5w2F
	Zuy7XJlMS4nfyK5fOjSYyqbIFHJuysBCpBf15IuAPuJMO3+U+c3y87YKGgHGX4PbFdmWP+JO3qn
	8CP9bnO/4G66X4aZLoCxmfCvUy8cGlNmkUEyD5rbAVc3tnazgtHaiJ6NfLZd8DFkooGsCtMeC8i
	90QPh0Ro2JKzYpG94UnMqfS6ig4YjRxoJIfHu8+RCHSQnI8vJmmOp6mwM1SKtcvpmdrc2WnO5mj
	qDYSwTVs1YCWdqQkRSLT0//mtAunswU6TntK/Xltdpyd+hu5o7P1F0baY+S4MF5c2SGnIg==
X-Google-Smtp-Source: AGHT+IHaDj/27wSNKkgOMC54QMnSSkZsPoqTkAu/WqBajOE4jy1fA/XxncHSudIk4NwzKEBXIrs7cA==
X-Received: by 2002:a05:6a00:4fcf:b0:749:b41:2976 with SMTP id d2e1a72fcca58-74af6e631e1mr6081658b3a.3.1751042502636;
        Fri, 27 Jun 2025 09:41:42 -0700 (PDT)
Received: from archlinux ([136.185.226.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af57f7e6bsm2644083b3a.179.2025.06.27.09.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 09:41:42 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: mark invalid_btree_id autofix
Date: Fri, 27 Jun 2025 22:11:29 +0530
Message-ID: <20250627164132.25133-1-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checking for invalid IDs was introduced in 9e7cfb35e266 ("bcachefs: Check for invalid btree IDs")
to prevent an invalid shift later, but since 141526548052 ("bcachefs: Bad btree roots are now autofix")
which made btree_root_bkey_invalid autofix, the fsck_err_on call didn't
do anything.

We can mark this err type (invalid_btree_id) autofix as well, so it gets
handled.

Reported-by: syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=029d1989099aa5ae3e89
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/sb-errors_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 0641fb634bd4..d154b7651d28 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -314,7 +314,7 @@ enum bch_fsck_flags {
 	x(accounting_mismatch,					272,	FSCK_AUTOFIX)	\
 	x(accounting_replicas_not_marked,			273,	0)		\
 	x(accounting_to_invalid_device,				289,	0)		\
-	x(invalid_btree_id,					274,	0)		\
+	x(invalid_btree_id,					274,	FSCK_AUTOFIX)		\
 	x(alloc_key_io_time_bad,				275,	0)		\
 	x(alloc_key_fragmentation_lru_wrong,			276,	FSCK_AUTOFIX)	\
 	x(accounting_key_junk_at_end,				277,	FSCK_AUTOFIX)	\
-- 
2.50.0

