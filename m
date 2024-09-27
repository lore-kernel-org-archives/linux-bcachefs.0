Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7546E13633F
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727447221; cv=none; b=L9F3i6n73On0BXkC77IXx0i7v5SRbM6rOdka+mYSdDS7EvSP6bV8JtQeNWDGtRwAzZk/+5+v97WT5cTE9h+wmSMDBlKMXeJ6W4I4ipP79uo7inIgugfBIa54H1JW64Em4tX8csDWWbPvCVKO8e3GLwFbMaE59LI/PW5Ee8AJxbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727447221; c=relaxed/simple;
	bh=ZXzdDB/NvvgzGcszmaxWcPim6H11noFXklej2muwWGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NbDFbFCOMfnwzyMzYGfS0os4h7O5PCR8slpLUsOi/uz5R2GppnxoEf/JjRI+7bm18zRNESOLiXC3u6xBAIiAf96jlwDqQDzmqt/EnvXkoslb5gmngk5TRuLTKGcXMkc6YU46qSC4KaPAQvKgtsMV6PxkE5pfj0k3POasJkUkfFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HtGnu16D; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtGnu16D"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-710d77380cdso1182924a34.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 07:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727447218; x=1728052018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uWJleYR8TyIHasHMSW9G0S7GSLaqlSgEqWS7D1dg188=;
        b=HtGnu16DIZkkr6cWzPyh29mvPjcRKrAX8Ol3a+dSz1UkvhK9HyhWpNpx+eChG9t7SO
         DVL0YMHsdU8pBDn+yyTTtSBiwR4pqC5B1f+jZ16oK6gYPMpuNvYwy6fmvB03X4p8v6Q8
         s8KzMuCUMJCjtDOFmmIqnurLCTDKhlcygtvc0vgU9O/8hb2tB5lMWFDDB8pVCguBPzkE
         3GDGxsiMLoZjtDytWyNxoN2PrgkI8DSj/ZXRy8/cEMZM/dp2MWQUuERUKiPAbLK6lcm3
         7He8JmZTnuLmqDp7dsxW/1hCTf4mdmCANxgMPt8zUsDoIGQblHCO1a+JOtSIIyiXFJYn
         Ii4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727447218; x=1728052018;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uWJleYR8TyIHasHMSW9G0S7GSLaqlSgEqWS7D1dg188=;
        b=ZOe9k18oBdyhO6QdcALBuZwLdwfvgYGXqFAToaLjnfHmqxaoJdEpWVe1dVPvaxW2YM
         VA5NYm62G8YlpZkyqupl4XBj47pVtEcOC/UZUl8UxNqmdXXK0dUYbFHLEHIAv8SZV3dn
         19OybUzlltR/mHOlAUY6bwTi2iwK8tZdVsn0zgo6MdrUfWSbA/xHqQxbglJzYTsXDKGA
         wwPErj+4EDU7pL0PDwMCboMugx2OQ6k0Va2NsIypKKPRgptLIG/okGPOqGQIWqYNkWsy
         w5OXNcUk/l7xipTcrJodyf89Qir/kVErxeCVINDWu/qB7ZeLpjqrc9vQRi1xzwWCmNGx
         GY+w==
X-Gm-Message-State: AOJu0Yy12uTnEmdXM7C32p6h9pWj155Ecs+qlSwtdcHJmmqmIPMtIR61
	APkAlYauOCrM/8yqWtdcOT0dkR27xqQeooCG+Kt5/dvf6+FgeVnZ
X-Google-Smtp-Source: AGHT+IGsJ9OIDjglNeTghPd/o3DTgfr/SLzwcHtpmas76aYd0SgwTEAATc+36RPGkpqWJyb4muo0xw==
X-Received: by 2002:a05:6358:713:b0:1bc:7c89:5ff4 with SMTP id e5c5f4694b2df-1becbc51b2amr224425955d.18.1727447218353;
        Fri, 27 Sep 2024 07:26:58 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db60e3fasm1702175a12.78.2024.09.27.07.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 07:26:57 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Delete dead code
Date: Fri, 27 Sep 2024 22:26:53 +0800
Message-ID: <20240927142653.1225060-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lock_fail_root_changed has not been used since commit
0d7009d7ca99 ("bcachefs: Delete old deadlock avoidance code")

Remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.c | 2 --
 fs/bcachefs/errcode.h    | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index bfe9f0c1e1be..85fe04612454 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -748,8 +748,6 @@ static inline int btree_path_lock_root(struct btree_trans *trans,
 		ret = btree_node_lock(trans, path, &b->c,
 				      path->level, lock_type, trace_ip);
 		if (unlikely(ret)) {
-			if (bch2_err_matches(ret, BCH_ERR_lock_fail_root_changed))
-				continue;
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 				return ret;
 			BUG();
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 60b7875adada..866cfdb4d24c 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -162,7 +162,6 @@
 	x(BCH_ERR_btree_insert_fail,	btree_insert_need_journal_res)		\
 	x(BCH_ERR_btree_insert_fail,	btree_insert_need_journal_reclaim)	\
 	x(0,				backpointer_to_overwritten_btree_node)	\
-	x(0,				lock_fail_root_changed)			\
 	x(0,				journal_reclaim_would_deadlock)		\
 	x(EINVAL,			fsck)					\
 	x(BCH_ERR_fsck,			fsck_fix)				\
-- 
2.45.2

