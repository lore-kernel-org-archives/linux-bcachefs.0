Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B714E1F91C7
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754323352; cv=none; b=Vg+BUl0AgzlQBN+Gletv5FGBTirl4McwzBJMUhZxejBY14tTKKGR2KibM+5+tIG5mF+s6y1YvUwE7qgwMx5izAqpi/YcoFFqK+Gmi6LnCudcsu2cFkcLwlkRMyBbyn0eFbUHNEiYcOYbkAgOFiVKl3O66gDwVZTdDjYe+ynpqXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754323352; c=relaxed/simple;
	bh=tyVKtmvp4r8YvUXS3u1YZLtBDKrraJG0Vud1kECMHBc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fzKqP/Oc4e0h8cBWlhmB0YH5aRAsDLK7pEWbq2DEupKS1zmItRa8O2Y2Wa6P3UeeVFCoeKTdjPfW80NIs5AMN859dhTFFEyzRy+eCebXehO0wDzFK8VJH8JznxnnEkHHS5VTgJfg421Z2P5oONudpDVR1KPFf+t71WYhKQiwr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R55raLPf; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R55raLPf"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23c8f179e1bso40857605ad.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754323350; x=1754928150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QkWvnpJ3uoZ3D3m/0csi6ln54hrOXBONSO0ONHJVx+0=;
        b=R55raLPfyK6pGsnbwu9PUeET0X5VFVkKZcmYRymjO1tN10WuLdiAsD/sJFdste/LpQ
         pup+jsw4/ra34+p0MVXq9gtA3OjYcYdlnm2JYIAPOCl+alkDhS3FBuTRbxHtOhr1gFj9
         64hcM9dVth8Mf5HPUwo0AtnfiQxovEebNFooydcbnDriSg1gr/u2c6lySw8/VXHKOF2M
         r6FIXXpCX7+Kmr0l9kOhZiEucfC3zTWr0xfyhMIIe/LPvSEuymeK1vDxRAg74AyIVw2h
         9uLd3U35OzggaeazsI+VABc9cMdVYKFPypmXz1Xs2udeft0nUiZzVJ31KpfgqrUGVLsB
         rhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754323350; x=1754928150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QkWvnpJ3uoZ3D3m/0csi6ln54hrOXBONSO0ONHJVx+0=;
        b=qx8emnO7XuSMsD6V5xgwYC91/OXUp2LM1io2FyaQwIlfzDgHocjUiLodUh0DzS0NK6
         96atTE9eYPA3RIvV6UXZVnVdjdqhFeQm9bO0UlB3cWfx8c5KfFBRqaoqybY4j1957PNF
         hyQ2rjcJNivKyX6Jkx+Tw4HxCI3U23z4VcsxrMZuxFWNax5vRhCHbbJjMiBAu4xYQcYw
         5bNZ4xTQ0UDRJUcKT/YhWpqD7jpOgvDbdrVA0fXUKfbtOuX11phpKKfCOimQbsGzWzHn
         qKvUgZL2kg9fAm7lf06BZHliwMuSsj0illpcUapaLk3zCiCo/elWTcYACpmwn54eAGwp
         tWhg==
X-Gm-Message-State: AOJu0Yzx3XvOJAH9yYWZkH9hNd3RsuFkxCjCXiODd3EfPEmM1z4maMdn
	m9bwkla+pMqYw9NV1G4av3MqbSaT6gDkthhFtzBdAX3wdOkHCgsBK/pE
X-Gm-Gg: ASbGncuuWzeIjMIKuDOzLqO2o/03UFlbT3914E09aLrfPe/1DrmOu4u13D1csTkedEZ
	B/aK8rfXhfgKsog7M0+WrHlHQ4kJzderGXj3pshBi37gG2JaQz8Qs6C4kqM+7Y1IMzXAJj/JT9s
	notL4y2ajuRBtS7GLHFAENJ8KZCUKwofGUTD83uWywEG1r/aceheZ4NFPrMQECO9lCWDgRgLp8i
	Mt3tP2Id7SdOSfKB12ZlzkebNnhnzzfrPA1Fm0yqz0Fi35g2mCcOXz46FW1u+0lP2TOqadJO7HL
	g+pO+pHcrlgrYbuE4Rs5r22y/Z9wKFVa6qksEpaY6CujbWnsqM55wrB9n+V89OSRvuhHnKkt
X-Google-Smtp-Source: AGHT+IH1gVm4T6Fmu8G1ImI4+tpPOKOh8z5/yReCaQcmvpLpufQyyikhWqqoxoFhAPNfIQMt8VkgrA==
X-Received: by 2002:a17:902:d505:b0:240:3909:5359 with SMTP id d9443c01a7336-242470303c5mr149792855ad.40.1754323349768;
        Mon, 04 Aug 2025 09:02:29 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3209a84df4csm11914334a91.37.2025.08.04.09.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 09:02:29 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Add missing accounting key type validation
Date: Tue,  5 Aug 2025 00:02:24 +0800
Message-ID: <20250804160224.189956-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/disk_accounting.c  | 5 +++++
 fs/bcachefs/sb-errors_format.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index f96530c70262..4f5b290dc8f1 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -184,6 +184,11 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 	void *end = &acc_k + 1;
 	int ret = 0;
 
+	bkey_fsck_err_on(acc_k.type >= BCH_DISK_ACCOUNTING_TYPE_NR,
+			 c, accounting_key_type_invalid,
+			 "invalid accounting type (%u >= %u)",
+			 acc_k.type, BCH_DISK_ACCOUNTING_TYPE_NR);
+
 	bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
 			 bversion_zero(k.k->bversion),
 			 c, accounting_key_version_0,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 5317b1bfe2e5..5ba28a684f51 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -328,6 +328,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(accounting_key_nr_counters_wrong,			307,	FSCK_AUTOFIX)	\
+	x(accounting_key_type_invalid,				325,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
@@ -336,7 +337,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							325,	0)
+	x(MAX,							326,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.49.0

