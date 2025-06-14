Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8BA23814C;
	Sat, 14 Jun 2025 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749927615; cv=none; b=lzIgtR0237kaSbvBcEf/5YqJEJPWKWztHJAlSOoJr6xBQXTSGMnF2SQxW1HsmaIPnAToYsSlVFxcbAdHUmbYb17dYTndM7ZpkIsplizheJY4yaWVYHp5byJPDAecoU4NF3GjWGs4FUTy7ypcu2rWI4YMiHGXPM8kKrnKGZwBhaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749927615; c=relaxed/simple;
	bh=dyw0wQTRbXjxi+0VWV/JMJdHvbVqiKc1LJw7c+OmfAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X8DGANl3OBk3D9mXt+OVsGpO94/h/IHv6WXH6zIrkEHG29lTV7V+eJu4/0tP+19mzbUPgm2HUv/DFuO/wXUx5W4eQi1GP0A4bMsaHVabDSPBGN8d3ZI1AXqInOApbhez0xmrj4nhsKutyg/AxKT4nGehMAabP0dk6YkZ4A4RCe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+dG6MDd; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+dG6MDd"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-312e747d2d8so3633587a91.0;
        Sat, 14 Jun 2025 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749927612; x=1750532412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=00PmhWqs3GR4JJ/AcsoM8Cgv6mtpTVTNbyQtFPJciNU=;
        b=g+dG6MDdeeqvUTDgIGAOgkXi9D1z0U/UA64xgyk6sMR3PIXMcgfMQ3TDRaiIk57oru
         7mPSURqJisDZiVYXPtRFimzxi61cbRG5mtNKtNQX9x1x5i7C5MxLc2jxvkEViGO6GXI5
         +aBVnyfOzbN57Mv07jxsvxv1x82jlVVA3MwaIS6zHuOZ4nmSAL6mOX8UN+lWkI6dSHxB
         bE65ZFiGfmGXTKs8hTeptXNw3JoHpCwLGcecym2PjCKxUCpWaX7yoQiM4yQf68JlXKmL
         H9knylih//peyCf/YsOgoQ/2Ahnf6Yz/a2U8l2Su8EL9KvEhtBbZ7iiHuOzwHkrqHaJL
         GASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749927612; x=1750532412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=00PmhWqs3GR4JJ/AcsoM8Cgv6mtpTVTNbyQtFPJciNU=;
        b=VjxT0UR0q3Zt1uaO6omEJ8m8shxJUPn4I/Q7dsUIllHh/2HgSliV07N/XNSKn0odnD
         FuC+Gz2YrJHMCfc+FTT98Ux8n/eBxzeUK2mtqKJPEbJWJAd8ebeaFZRaUSWz9FnjSanz
         vydY+dszmaEL5D7Sr9scOUnJ0OQvUogvoJpqLCI9OuI/bcvLzjrN0bWeLZdYLJMiuz0G
         ST/8jz3WB5YIB5qyRJ89rGd9XL9iJU/ikoLCPg9+ZuIKw2WO6nEYmB/EJvd8FipCWSqc
         OxAsRlLUd63tB2wXKDLyqpS6Nl6pJSqJcQhWH7C6bc1APqHb6SJjsyfz+N72JFI3W6pJ
         WLtw==
X-Forwarded-Encrypted: i=1; AJvYcCWLuzmyy5Ea2wdJNA2Pe2TP03mcoi88Zb3nR7maH4mof7QnEDtdjco/pppEvebG0gIYwMD4d821uAEQMd53@vger.kernel.org, AJvYcCXVuERHu44tqSWZPyTpPz3khH+z4YNcwPBSxLwZsOG5q+AkjPfzxoXY0/I1G8mqZEqIBCOoVuO9XnJ7pP8HMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvootZYGqcR6F3H8pyRknkRpLlt0KUfeIYoBljLuRmubxYpCXy
	Z3Yosg2gaXxeUJm0SeVnMi3gKDSlQGU7DKjzIPQQTqua1ldfGaJLKqH/
X-Gm-Gg: ASbGncsfBgMhNT4Db8ZhC+1DR7PSc2bTAGSWgdio6wDGWxm+cat3Upcauc1B2+UKuEY
	J7omGEtL7QMaVUmtXuvpuYe4zEL9knq9X74uCqo1h2PPe+cUEnr/n9pA89jpUrqFlWCC4D+MPaQ
	EejovQNZfjEsQBh6xDho3ma8Ahp/oFnB+qozNmjBgE0bUaM91INv0X58hS2akCPfKv7uvHfpYd0
	txuW5s58NvTyPpZpGq8xHxufZWLhO11FtTTKmPO+8ErcPxX7di+cwPZnzNzkecniNBs5XArhK2P
	8jKaAMiYhSkBhQ8/p51cMSPG+GSAZC5TyodNv+y77UBNa2awUN08lgZfyoqmU304G2sBkE+FpE7
	9V2GZKhjgUfCsoPkS1pU=
X-Google-Smtp-Source: AGHT+IGMc1Tc/8jLJ/4AwpFgVCHjKd5rypH8VsIzJvSnR0TgQFtjv6rIwGGpuu4mWH25Z4bdJGbyBQ==
X-Received: by 2002:a17:90b:4e90:b0:30e:3737:7c87 with SMTP id 98e67ed59e1d1-313f1bfebf6mr5605657a91.5.1749927611957;
        Sat, 14 Jun 2025 12:00:11 -0700 (PDT)
Received: from localhost.localdomain ([223.230.56.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbc9bsm5457987a91.9.2025.06.14.12.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 12:00:11 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: don't return early from __btree_err for bad or incompatible node read errors
Date: Sun, 15 Jun 2025 00:27:40 +0530
Message-ID: <20250614185743.657564-1-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After cd3cdb1ef706 ("Single err message for btree node reads"),
all errors caused __btree_err to return BCH_ERR_fsck_fix no matter what
the actual error type was if the recovery pass was scanning for btree
nodes. This lead to the code continuing despite things like bad node
formats when they earlier would have caused a jump to fsck_err, because
btree_err only jumps when the return from __btree_err does not match
fsck_fix. Ultimately this lead to undefined behavior by attempting to
unpack a key based on an invalid format.

Make errors of type BCH_ERR_btree_node_read_err_bad_node (only if
__bch2_topology_error) or BCH_ERR_btree_node_read_err_incompatible go
through the full __btree_err function instead of returning fsck_fix even
when we are in that recovery phase.

Reported-by: syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Fixes: cd3cdb1ef706 ("bcachefs: Single err message for btree node reads")
Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/btree_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index d8f3c4c65e90..e010ae94f1e1 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -556,7 +556,10 @@ static int __btree_err(int ret,
 		       struct printbuf *err_msg,
 		       const char *fmt, ...)
 {
-	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
+	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes &&
+	    !(ret == -BCH_ERR_btree_node_read_err_bad_node &&
+	      __bch2_topology_error(c, err_msg)) &&
+	    ret != -BCH_ERR_btree_node_read_err_incompatible)
 		return bch_err_throw(c, fsck_fix);
 
 	bool have_retry = false;
-- 
2.49.0

