Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C03770B
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708354220; cv=none; b=UQCG61wXofhST7moHvwuRJcpkSoaB/3NGr+QxeOVP8gP+7QPGl3Uh1cecN8LvlHp7MH3GnUc2LfAYXP3XHI+2208Q4Z98Igl04Psirro4hQKIpJsGJZd9Tmp4+ba0MlKr5EE2AFWyUkMEmFmFoIS/OB/VnTCV7lCMmu+Z8AoVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708354220; c=relaxed/simple;
	bh=4XhsvKuIisDn76Y2OblYJ4nih/NNp35OaUsC6fCKBDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAB2//Kb/bl3ILwF3Vpm8FhXoAsTF4vHViK/XXj9jASdaQjIoVi3tpB8OXTXwP1ruxwX056y4bsE1TLYEaoBna1jsdc/tpGpraOR4XDP8VL/tFyzOH1uTt+DnSD7V2iBYlaVzfPOW7lJM+L35Mrum9Z/7KtyXlVmEBhhzYu6U7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=lrOW/Rcj; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="lrOW/Rcj"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e458a77be3so202859a34.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708354218; x=1708959018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GG5kE05E5drsTHKcPR6ZLpH0kHS2xn/0jFNy/mw2JI=;
        b=lrOW/RcjIolAW/4oxNzqOP0ogdVm4HAKuYtitYLoUxQy8MQJRQMkdISJIZTDGMy2Wi
         XWTIOT9tgnAFteNwbXpzFncBJ0TMQfK7A04JD/2QzwViLZ3uJ2wtkNWcyLkzEcBi2p/V
         +A8gLvtPnjOrs+eKI1DAFIngeREcNagUkfd0zjyTKTKuDj2mVfKL4vFFAwOGm9TcXFxm
         PA2mW3r+w/GBRkk9IRhU2vqfYitjEhftpI9mQyexTtizfrqeKwXqYArLy66TyvYAMdHZ
         ieQpnxVG8i8HLDaXlkPTNOrptLopvrPT9IqeeGaA29yQOSudeGLZzP7xAFySWcOzQlAO
         P8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708354218; x=1708959018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2GG5kE05E5drsTHKcPR6ZLpH0kHS2xn/0jFNy/mw2JI=;
        b=Dh3mbnNzsY7viwgPXOQ7fDkshqKOq8ui4g63jfoC5xqZO8axQZg7qClz1tHU8pWm7f
         WCLz1qX0IKR0jyCwTtInDDe5bBQMvYJZpvd1NKwyfs2Kcv+1XTk12FSfvc6TrE8PSSQF
         n6VI4yCmdPfwTLDXNjWPMCQ3oAl28QNJ6JEfk8/cSEO5lRm2y5ujnBMZQi0CC5IuqSTw
         xw3LHE6h7VN3QmG9TRJiwrFphblsjzQ2RMsTpPkI4wHdN9sKPBZ4d6I7n8Jfy4+W+5C9
         ImM7I+OmyahOrZ7WkCOR3CD82cvDLiDnb5HTuOINeVeLGP++ai0V+qZLoWDE5diJswO2
         ox1Q==
X-Gm-Message-State: AOJu0Yx9RDqAX9AVDpJ3PT4vN8paUhDbCvff4bxm2Om4/IGbqjTh802z
	GFWVENZ7/MYwaSZesdFnJJP3w7Nz9uT1Fnwctogy3vdjscxzLcRNqDoAE5Wizdx9REIYU68/zvt
	Y
X-Google-Smtp-Source: AGHT+IFiiY9Y1Wb7ok3b0wJDI7CPHLOGbJU65mkiBkowQML12ovlFW+sqm0NXamaVDW9FFAkQK/tpQ==
X-Received: by 2002:a05:6830:148c:b0:6e2:e7f1:4b36 with SMTP id s12-20020a056830148c00b006e2e7f14b36mr15292224otq.5.1708354217753;
        Mon, 19 Feb 2024 06:50:17 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id e1-20020a63aa01000000b005c2420fb198sm4155101pgf.37.2024.02.19.06.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:50:17 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 1/3] bcachefs: alloc_v4_invalid() now checks fragmenation for consistency
Date: Tue, 20 Feb 2024 03:49:15 +1300
Message-ID: <20240219145008.915291-2-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219145008.915291-1-daniel@gluo.nz>
References: <20240219145008.915291-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to validate fragmenation_lru is consistent with sectors counts
and bucket type.

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/alloc_background.c | 18 ++++++++++++++++++
 fs/bcachefs/sb-errors_types.h  |  3 ++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 4de4036ded06..3bf2a2daad93 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -292,6 +292,24 @@ int bch2_alloc_v4_invalid(struct bch_fs *c, struct bkey_s_c k,
 	case BCH_DATA_stripe:
 		break;
 	}
+
+	/* this check fails to work during device removal evacuate etc,
+	 * so fall back to something less robust
+	 */
+	if (bch2_dev_exists2(c, a.k->p.inode)) {
+		u64 fragmentation_lru = alloc_lru_idx_fragmentation(*a.v,
+							    bch_dev_bkey_exists(c, a.k->p.inode));
+
+		bkey_fsck_err_on(a.v->fragmentation_lru != fragmentation_lru, c, err,
+				 alloc_lru_fragmentation_wrong,
+				 "bad fragmentation_lru (got %llu should be %llu)",
+				 a.v->fragmentation_lru, fragmentation_lru);
+	}
+	else
+		bkey_fsck_err_on(a.v->fragmentation_lru && !data_type_movable(a.v->data_type),
+				 c, err, alloc_lru_fragmentation_wrong,
+				 "alloc type %s is unmovabled but fragmentation_lru not 0 (%llu)",
+				 bch2_data_type_str(a.v->data_type), a.v->fragmentation_lru);
 fsck_err:
 	return ret;
 }
diff --git a/fs/bcachefs/sb-errors_types.h b/fs/bcachefs/sb-errors_types.h
index 0df4b0e7071a..cc70a93dfd0d 100644
--- a/fs/bcachefs/sb-errors_types.h
+++ b/fs/bcachefs/sb-errors_types.h
@@ -264,7 +264,8 @@
 	x(subvol_children_not_set,				256)	\
 	x(subvol_children_bad,					257)	\
 	x(subvol_loop,						258)	\
-	x(subvol_unreachable,					259)
+	x(subvol_unreachable,					259)	\
+	x(alloc_lru_fragmentation_wrong,			260)
 
 enum bch_sb_error_id {
 #define x(t, n) BCH_FSCK_ERR_##t = n,
-- 
2.43.0

