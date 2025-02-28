Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E9E276D3B;
	Fri, 28 Feb 2025 08:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740732452; cv=none; b=QTQW6cGO+5LKCeQFJkHPHzJJrLg46eB81IlNavvwy76osjUr63HZ8lS7dK1GkjsIn54qFKcbB8FpsJCU+i19z9Cn7YxnjFkvQVcSk3fbaxM9mNlbDFVJoJ3VZq1QglpCpTOab1aVUiVebQ6wP3DGo44Rm7lvSlPpXhwpSJmLz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740732452; c=relaxed/simple;
	bh=x/XjMG1KPAhYaFtIq0lRdfHtd/pIIkg8+PbdlIeiXqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Be/KcNBw4D1ZwFxDfHrf0gsUa4WKTGkXGAl/e5AbYGuTu/SuIeAMiYoGWY3egUKkJCYhqf4LfFbF7wX/Db0dKdbdw6sqro2wLoWJDnAOilAr2wDojecr5XIJ/b8mD67hcz9JtZeXN+6QE4mYJn9nIyi5ZSxxPHwDkW4wgVjVSQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aVilvjVA; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVilvjVA"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-390ec449556so585451f8f.1;
        Fri, 28 Feb 2025 00:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740732449; x=1741337249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+qdA6TomdOLRq8WKT3V+XJclLYlnQyLXMFg1MZiiUR4=;
        b=aVilvjVAXmnLL7vFl+1uPuaZeJ38HntS9pdomYFjT5FFsdsJsBjreGEbJhs+DS66py
         N5T7cErBRJFJF3KOChzHbQf8JGZ9oHnObmPZzqQ6GtBV/UzpcU1Y69sliuRYczvBMYQT
         Q2aGTLrQNHSV41cK7k2JYFJaO2yjBPYy7stEtpHFigbcNHR8GFQxvTgBxekL6dot6/Xl
         8IuY5uC2pUPpJ4TVRLc4p4qQivKlS0kfz1oh5jEwCNfUmlzqSJQu4ZPoyA8urshg3seI
         KnDTHYm2UCmUgu3vgT5M/qy5Xn3lto1/OmGeOsA9pm9VHB6nbMKByGcbCBW6vCvrpDRD
         1RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740732449; x=1741337249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qdA6TomdOLRq8WKT3V+XJclLYlnQyLXMFg1MZiiUR4=;
        b=rWr9Of9ajJcZ5xI3tRRqzeQci+sv3iUrLdqajFW0l01mugc/bX28sb0o6WeGvQf8a9
         dHZ+qg8J0ZS5HvlD7ZZdEcxxmz7nkqmeLsq+i2ihaqwROkRtXae1jJOcbVW5j4SVEj/V
         Asxxvlvl3iw+o0b/xIpAeRKEZZgScGQ2ZT+WTAkea6r3cVn9RKOeoimvtV7VeUqiAMPG
         xhZxGiWQoRCKC+ydeBCB/fERJMswqv77X+po9tjDFaJXkXbBYE0ahooqJmMrC026abHe
         XMVo3J5f14jPvFyJbj36RgeqNvttbzVW7OrJrD9UbWTr9OYMI7UJfME1M/ncU6TBC7pj
         WS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWh56NvygmKALK9wgYOSfT+u7ZGK+mV1Ynarv0oHuU39HXUyHfwZOa2/hmy1uRBf7pj8ov9rjT8l3QhlV+IRQ==@vger.kernel.org, AJvYcCXOh9ebYqSGJ2X6qstZlpCjaYS/RXcFQuzseC5khrp/o+P2gKmQFZqAxwNrVretyp0aMOy1/h+hTSTWm7zM@vger.kernel.org
X-Gm-Message-State: AOJu0Yz10IcxRiMvRqtMHapWToYFlkpsgbpvXPqYU6R4Mwzcux3Xrld8
	oP/DZ9Qc1JzmSSqf3yMFpyGOQYNDQ1Sk88ZsgGFp17mjwaSMmiw3mrzLoOSNKp4=
X-Gm-Gg: ASbGncvabj8a4TjUN3u5Vlf1ThuKiEB+tTGq7Ty3i4CWGXnyy+ptdSRnfMlHpPD5jqe
	l8Jq+gpA9W3JU6r5N3VNV0ePQePSdJXrVBvPtS4NbpnER0DiDNinqRiHQqU0kCPoxlN60v76NIC
	lq7LzqbhAb3pH/DPaMDQiI8H9AWv+LIXXkAB0fDWZTS0fBTLDlezCMRQ7g9y3czqGEp7yxWjdWw
	pdakJqPomvCEgLbjrNCStmxXxyAWZrvIdqdzXemBZ8mGlmXHn4GZDC4JzUAQ0MWBzyS2HNICQR/
	bg1iKyPpH2CY6W56aJzk8NrVYGQ=
X-Google-Smtp-Source: AGHT+IGqVFOzWtyQnoy9GtArJtoTQSdY2Q2ngONFSicEoMRrYH7GNU0vlA0X7nizgj9PSVOWj2O5bA==
X-Received: by 2002:a5d:47ad:0:b0:38f:3791:c1df with SMTP id ffacd0b85a97d-390ec7cdcd9mr2579490f8f.15.1740732449099;
        Fri, 28 Feb 2025 00:47:29 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-390e47a7b88sm4518687f8f.40.2025.02.28.00.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 00:47:28 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] bcachefs: Fix spelling mistake "nonexistant" -> "nonexistent"
Date: Fri, 28 Feb 2025 08:46:54 +0000
Message-ID: <20250228084654.677828-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a fsck_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/bcachefs/alloc_background.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index ecad4a78c3f7..6db3482c3e19 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1407,7 +1407,7 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 
 	if (!bch2_dev_bucket_exists(c, bucket)) {
 		if (fsck_err(trans, need_discard_freespace_key_to_invalid_dev_bucket,
-			     "entry in %s btree for nonexistant dev:bucket %llu:%llu",
+			     "entry in %s btree for nonexistent dev:bucket %llu:%llu",
 			     bch2_btree_id_str(iter->btree_id), bucket.inode, bucket.offset))
 			goto delete;
 		ret = 1;
-- 
2.47.2

