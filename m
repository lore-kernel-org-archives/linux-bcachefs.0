Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CB8F6F
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 05:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749966089; cv=none; b=UM7Fzr3ZjizlQnDfgShyZz39Y8ojeVUyyH+VDzfFhzhFyZVYEz1pyMyvqozD+97lpBIhFVBY5/MVqJYhn/m719PpAAlYjOIoZpLI2MZE1GUiXmPzjrHPApecr9eftC7qxxeVRFIbKTP7LLo/KnllEYtG4Z5ix/QhMm3+8GP7U+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749966089; c=relaxed/simple;
	bh=ZTj18sssY9mu+F3WtHOOeJm/yqplNvJhWY5sOyA84Do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A9F6A1S95TSVUOiO4EWb9aqcPjRvP6WwWUVSIIKs+Hyj2Vhy6Ou/ZsOq8pyutV8uz1p1zrSRVQVvh/Rvwl09T8EWqTzSk7fyOw/FgS3c8EdFEmKrg2dhzhbfNXNfBLeOwBgeJPaMIS94gEW0b6j2Jr58ROMbNB7zeMG6dSoyqgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+5qXagf; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+5qXagf"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2fca9dc5f8so2472016a12.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 22:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749966087; x=1750570887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gG3Qqi0D7t2NAfD9eR5Yn59eFPN6Tbbyehq1sfN+JRw=;
        b=T+5qXagfxsVfX0BVPuWpXotz5vOnknwLK75HKMt9jEt4RwGXr3gsjgWsHFBrvqYYjE
         OIBO3G2DPpeK/xWfNU5D6ZRzqT82qXKMbUVA/9m5VP8esPiiNE3G/0lFH0ukkRLbpN8d
         /a+rt5IlCLTHgMBIJsToP1huVD3+tRSxUu6gL7VRy1qgeciorLIpdAEgj9ayiMopo1FB
         7hfxXHGu1LokjMoMF7jixhnH7a8SahGWRsC+QUXXa6EEQ7rseL97QnufioXS0SsenCGo
         LBpeQ46nD7HITUnsee8/Tlx+gwQ+pnnygD+WS0h6ReBBjRNYI2tOWhAqkpsmgRj091I3
         7aHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749966087; x=1750570887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gG3Qqi0D7t2NAfD9eR5Yn59eFPN6Tbbyehq1sfN+JRw=;
        b=kCTerCq52LW/JnNPIepR7w92Tsl2n5TiTZ6DPD0J0LpkA67hX701mwWQPAby+aYgtl
         3xaXofaofGo82nh0HgIOc3RHQ09vONxJ5gVaMrV+EWJ7G1WewSxNNRvSHc+23tncIWQD
         6VjR9o2CgS01pYgHaiaysZbfrWMkX5a2O8/cf09mKx58mMp+dEVuycTsDEq7xxvrCFGH
         x/tYXMMn9dKOSgkCutyJ+Kqz2YMmKe5JMyD+9+ejZcvey1lE7JAtUJJRI4r+naD/pRdb
         uqhBZ9RG3pLwyd/EuOueIAGLBp5fQILmPpKdpibeCYXn+Zl1jCVeH24FkcLJc1aEMaFe
         7smg==
X-Gm-Message-State: AOJu0YxJlaiPCFAIjUl8MwMfTppuHcTl9BfFeK/W/nI/B034g9w967qQ
	LjcBCpVPFr4rqDpWNq9Ks1ZKfNOh6C+rqJ/i4TuyPmfWjpwbWtNKSfF7+B4ukw==
X-Gm-Gg: ASbGncuPQS8ITuD2k5HlHC6lkl7wF32f40oUX0JIctpe88E37VYsP34BtxEFgnZgG1I
	8DluUFA8Gx38hUFq5ziw/UQkqf+rknCTyhPXePIx03YX68B+kgi5C4Mq64n+59vqBmENMGlpwxG
	r8TFhmSqrRwX1jIVBbNaH7jwkaELfmpwpmSuXKOQa7io6WrGseroYwdxIiDjD+sYisGIihaglJo
	FhdOs+9dYo9taRYtMWODbjLJhFEbub3z0kCRdTjeXkC1lNQxNA5jbV9FLf6EF2YzpM55fPiuaQG
	3K925hua/6GGEFTDKKshdRTtXQLCj03MaPhf
X-Google-Smtp-Source: AGHT+IEVypRqnr6uyhH8PCmBxzc3w01gqXZal6mV+NMaDvFrKx3kgoU8rxOfL74Ja4zlky5ALDRkWw==
X-Received: by 2002:a05:6a21:6481:b0:215:eac9:1ab3 with SMTP id adf61e73a8af0-21fbd634957mr6683057637.29.1749966086883;
        Sat, 14 Jun 2025 22:41:26 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm4392483b3a.133.2025.06.14.22.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 22:41:26 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: Fix pool->alloc NULL pointer dereference
Date: Sun, 15 Jun 2025 13:41:22 +0800
Message-ID: <20250615054122.587902-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btree_interior_update_pool has not been initialized before the
filesystem becomes read-write, thus mempool_alloc in bch2_btree_update_start
will trigger pool->alloc NULL pointer dereference in mempool_alloc_noprof

Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bcachefs.h |  3 ++-
 fs/bcachefs/chardev.c  | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index d0d3a68659c9..ac99a8ec21f0 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -767,7 +767,8 @@ struct btree_trans_buf {
 	x(sysfs)							\
 	x(btree_write_buffer)						\
 	x(btree_node_scrub)						\
-	x(async_recovery_passes)
+	x(async_recovery_passes)					\
+	x(ioctl_data)
 
 enum bch_write_ref {
 #define x(n) BCH_WRITE_REF_##n,
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index fde3c2380e28..5ea89aa2b0c4 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -319,6 +319,7 @@ static int bch2_data_thread(void *arg)
 		ctx->stats.ret = BCH_IOCTL_DATA_EVENT_RET_done;
 		ctx->stats.data_type = (int) DATA_PROGRESS_DATA_TYPE_done;
 	}
+	enumerated_ref_put(&ctx->c->writes, BCH_WRITE_REF_ioctl_data);
 	return 0;
 }
 
@@ -378,15 +379,24 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	struct bch_data_ctx *ctx;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (!enumerated_ref_tryget(&c->writes, BCH_WRITE_REF_ioctl_data))
+		return -EROFS;
 
-	if (arg.op >= BCH_DATA_OP_NR || arg.flags)
-		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto put_ref;
+	}
+
+	if (arg.op >= BCH_DATA_OP_NR || arg.flags) {
+		ret = -EINVAL;
+		goto put_ref;
+	}
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto put_ref;
+	}
 
 	ctx->c = c;
 	ctx->arg = arg;
@@ -395,7 +405,12 @@ static long bch2_ioctl_data(struct bch_fs *c,
 			&bcachefs_data_ops,
 			bch2_data_thread);
 	if (ret < 0)
-		kfree(ctx);
+		goto cleanup;
+	return ret;
+cleanup:
+	kfree(ctx);
+put_ref:
+	enumerated_ref_put(&c->writes, BCH_WRITE_REF_ioctl_data);
 	return ret;
 }
 
-- 
2.48.1

