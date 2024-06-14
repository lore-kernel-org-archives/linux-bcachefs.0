Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6573349638
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718390845; cv=none; b=aa/FH0vpGSNnv36IQ/qoh8XAyl1JuclCGAvz2qt8nQleIRjKhvovaZrY0Dz6M1ehDr6D2DF8IR3OW4W1qzNQgVEL11qgyuwBrS7WC3/FiCgnSk7Oy9Tttt6h89v0XrcP+6kTLkiSVj/G2QQ+dwopDiWxgsyIXUYsao/Ru64oOgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718390845; c=relaxed/simple;
	bh=iJErmR6ufL2v2BwF3ShA2OVVhVemeKY8kZcyQcvEF3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1lAKttmnrW3KSw33ELEl90hyb9dUly9HGQ6z1sFkJgctuypPmKcu6mgTVVmaHSRjVIIOsqbdlJUUcY4xS3M4q5AaWB/mRmzRj8aEMaIN/hugZWZnq9Qxg7draKtn3ZT/7LZ4IA326Cwu+BtyJ0GfodpX+F1k0xtLjUGNFbImmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BbuQxeZm; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BbuQxeZm"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebd421a931so24152761fa.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 11:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718390841; x=1718995641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yV8Hx0YOUpGbvoc6iRPe9nKtRegLLhMFfcdOeX/LF4U=;
        b=BbuQxeZmkiVSDKKJnquTpEt+YQqIUJ4vRvFKb4pPZOO/LOJhsGDUmAnTZwpEkNAh6I
         bqNBCURFU0ZYf0l0KWwCYE1uvF+eFXxC4UzLKz5lDQWk1bKLVjWu55vBWK+WROYP33n+
         tUfwSTqjEkBaaZ2MvAQWHNmdnswrIzabHv50LKS4U6IXN8S7B5sme53G+XBsxw4xMGup
         kDrTMNV+PMOr8PCVGNHlbbv5lCnZd0EPC2Gn5C2CWegKw6gF3ET+8vxuUqDh931xMdMJ
         7i+ExThaJIEpRQFaRmM5OluemO8MuNspuYAMOUrcS4R+Z39SgoTIiynUiYUKVEjwJCCr
         Ry5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718390841; x=1718995641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yV8Hx0YOUpGbvoc6iRPe9nKtRegLLhMFfcdOeX/LF4U=;
        b=kJ6pVNrS+M1GuHoUrUxsM3kvQEhbM8fTkb66K/UcIMZWBXdgJDweLUlmg+geaNMKbW
         V4L48kAALqWIChlb6zJyyQB/sPWZlXt6jseZXbOT9WBdYJmFDt54hHIcWS7Y7+XgEjnV
         OtiNS05swuFwMJDeYOlobFoNOhNAedgQ/ZnVcZM/W9EycoTgtvabVL04z75fyj4OWBTi
         17W4C7dVeHAUjVJHF6YdFbi/polppbv+HnBR9xAHXGEXwI56RfCnv75DcNaKge7eNE7L
         0KXNqrEKvcHxi2oCGsMmx8QG/AREq/3eaQlBV7Pr0F/ykiFpwU2ZwfyvrbRrXc030ecg
         6JEg==
X-Gm-Message-State: AOJu0YxqUDvgLzWK+mhqG4hEM087svMaHVPCO1UqthDvIATBzh4/p646
	ofnb5yfX82lEGMcsSaFM0RZs70g2E0bg+7PXie9PKTWLG4d50/nLbcwT7utu
X-Google-Smtp-Source: AGHT+IEbMaMSh7WHhBZQHQpd6gNNRsPPGa+kjnB4MqxLIv4jp26XC0UWCQO8QiukscbDsKazVuK0dQ==
X-Received: by 2002:a05:651c:1057:b0:2eb:f231:244e with SMTP id 38308e7fff4ca-2ec0e5b587bmr21608641fa.9.1718390840949;
        Fri, 14 Jun 2024 11:47:20 -0700 (PDT)
Received: from localhost ([2a02:2f0e:615:a300:e591:7f5f:c9d3:c3f5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cbe89005asm1455783a12.10.2024.06.14.11.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 11:47:20 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH v2 2/4] Fix performance regression of update_inode
Date: Fri, 14 Jun 2024 21:46:51 +0300
Message-Id: <20240614184653.276043-2-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614184653.276043-1-ariel.miculas@gmail.com>
References: <20240614184653.276043-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This kernel commit: 65bd442397274347e721a89c2c4882a392bae982 removes
BTREE_ITER_cached from bch2_btree_insert_trans, which causes the
update_inode function to take a long time (~20s). Add this flag back in
the update_inode function.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index ee0e300f..131913d1 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -19,7 +19,7 @@ void update_inode(struct bch_fs *c,
 	bch2_inode_pack(&packed, inode);
 	packed.inode.k.p.snapshot = U32_MAX;
 	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed.inode.k_i,
-				NULL, 0, 0);
+				NULL, 0, BTREE_ITER_cached);
 	if (ret)
 		die("error updating inode: %s", bch2_err_str(ret));
 }
-- 
2.34.1

