Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40101248F71
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 May 2025 18:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075473; cv=none; b=nGIdgeh33eLW1i9h+ei2jTGlwq5o2/j3PbAeNs9j/UVNUVb2JHEzyCSGh0stWJETu9DKX6/GoeLYZy1vncQCGujPxrbHxwjqok1+UKhqZl8Attb6AAnw6fZlfLro18yWA3S/bhOlXeWmmF0XYqVRIImvJoEd4a2Y/CRiFHa0E/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075473; c=relaxed/simple;
	bh=LI7k8qGPs09XAgDfdvwGwR5Wbn49tCaRe/GjNeKk6Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y3AgcWHFPjUUH1DDhA8iXWJSTqMgixd8PHH3y51oMHMu+l6a1lfCWweRC23I6+DWMwaAocj7+MtqkNUpTBiMhcd1FnNR4v5TUVBsPj+0ArDZ9uygTU6uk3brYymqzZ6G7pczSeQIlrxHjBH/NTNyMCH8AxVea5ve1tJFbj+0vVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J9QkqTpx; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9QkqTpx"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so4831411b3a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 May 2025 11:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747075471; x=1747680271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mZxSQSbICQdg35Cx8wj9QTbhv7G7OJZ3d50JxWdTi00=;
        b=J9QkqTpxK1TQzKIx1a0S/TEQcHQbP4ihTetgab114aC4PyC9PQc+UyFtzF9vErYHfo
         bancJZw/zOtQXuMbyy0GAly5hEUt8WaUkrWeFSdmk2F+9r4tbfMVn4PgTdBgtUBsuW5n
         orMMIHXCfxfJ27Tw5pE0rrBPbo7PJws/MZ2Ag1pr8TSz0yiTS/TekXYJOCKcLgGrLbMq
         EIvkHLJ/EDlUq/aV3ysgq4nu3X66wlulwHEl56ecWnmnwM8/Wofw2zqKeqPvFsELuWRY
         hLjl21QX355Or21v7dVXJACdgU291fjxsBlNH+IbwzanA6GZL/eKNsU3kk903UrpTtjl
         0gJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747075471; x=1747680271;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZxSQSbICQdg35Cx8wj9QTbhv7G7OJZ3d50JxWdTi00=;
        b=BZhw4Rccf+kjCaJW3PbIBo82pK/dCZNVLTQLAXSwtx3AXprJLa0Z0XKgTRSb1RqPtZ
         e1fD+BljAO6hY4U4vpTspcGtMCQh10RrT400n1YTNsM/1I86z37ZvX+Mya26RGXOS14m
         RUojOocTu1QYKpBKdOlPSoWMMcLro2vRLFNLimvpvaobPnlrEKN8yo8xwSj6ufiiYTSi
         x05EWOaaQJMQTxnfj1ak3TfMMECpDwh5xXJrS6qlFZWjyoFd4V/7ALSwnqPH71HEcL2K
         kMWupVtLi55DYVlRs+3tqozjh8AuHI4uI9zWEFpuUd0wBy+Z7cSqfXy9b2uakpnjjgQa
         MV7A==
X-Gm-Message-State: AOJu0YwMT0gadrZNzJMAoCL8uFtpr43W3xgwI7e4ROsIPgcKYFOzA17V
	Cn8vMVJMfEgx3HkJKSAXa0xYzZsWhv3+zH8QPyYMApj+AEQX4T4r
X-Gm-Gg: ASbGncuznwoYS4O+nE63OPcTt578JbOLwladNEwC0HDiACp1n4NlWbyl1cUgKrWT3GX
	Inf5HRD7hfUtxkXOo5pkzLQHCOpNFlJVpUNG5nwzddKuDwwEQGjKe8WhgJ6MkJ6v/0KsNXMR4+k
	npdLNfAo6iGh0vrnnrWmmZkvF7z+Fy0sDYw/QZjF1TamGGpi+fmaa8vSSCbcd9nWb0o19Cuat+l
	y+klf+iHndYmke2DW00GincX7kdc2guh7HQ649mfa76olEZRQYposggM+mofmVBBT1zHAwTk7UA
	lEbpStuTAMJbHiCsl/7lwAQSwg==
X-Google-Smtp-Source: AGHT+IF5oIjzhuWImXbBzgXKW6ETAk5Y0nkaCkm4kvHrDRiudgiIOKBs5zLMIpZE6siOJLP9Yn9jTg==
X-Received: by 2002:a17:903:946:b0:220:cb1a:da5 with SMTP id d9443c01a7336-22fc8d98a39mr211982385ad.40.1747075471335;
        Mon, 12 May 2025 11:44:31 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc7544e33sm65556025ad.16.2025.05.12.11.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:44:30 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Use bkey_eq instead of bpos_eq
Date: Tue, 13 May 2025 02:44:25 +0800
Message-ID: <20250512184426.72038-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since we are using bpos_nosnap_successor, it's more reasonable to use
bkey_eq instead of bpos_eq.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/alloc_background.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 81e2ae4bb400..ac27735c11e5 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1057,7 +1057,7 @@ static struct bkey_s_c bch2_get_key_or_hole(struct btree_trans *trans, struct bt
 		bch2_trans_copy_iter(trans, &iter2, iter);
 
 		struct btree_path *path = btree_iter_path(trans, iter);
-		if (!bpos_eq(path->l[0].b->key.k.p, SPOS_MAX))
+		if (!bkey_eq(path->l[0].b->key.k.p, POS_MAX))
 			end = bkey_min(end, bpos_nosnap_successor(path->l[0].b->key.k.p));
 
 		end = bkey_min(end, POS(iter->pos.inode, iter->pos.offset + U32_MAX - 1));
-- 
2.48.1

