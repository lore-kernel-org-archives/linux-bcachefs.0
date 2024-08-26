Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F11145330
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724667229; cv=none; b=uGSCppXmF5QKvwDze496i4096H4kqaRs+WzutY7DItgUXe3pgJPPgdoeWG1lkMnGFR5JbAjR0g9JTBz95pgdL2Escaoe57pFtCzfDx1Cigv90DzSYUGoC3YE89/cEdYOxiEwwLjIzmOAg/bcUWNxJgeUoPcYN0GXX4ApewUCPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724667229; c=relaxed/simple;
	bh=TGI1HK/OW56cEnj1JPUc1WJBzzzkwO+nvRTtcy4SLXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZRtK9zbuOfxDQSHngd3UaRTq+kG83gu6RSpuxmE85zfEC8MCJZWoGRWHLDIArYHPXCz5V3+96ODMwHllYPDFfUM+4J+nMU45fAX78k1FsFtIdcv3pWQF2ib6EaHyEABokJa7Qc/QgIv0Xc1am2sgqe7UB8B4Wzhf9nrCSAiEEpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=pGLX0jLe; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="pGLX0jLe"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86939e9d7cso26065066b.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 03:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724667226; x=1725272026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z07gjud24oTcgbqCvuKd+VAijUebGTMd0Q7+OuaVxsw=;
        b=pGLX0jLeapZsQoMYDZN9EpWZqYUQfS/fj7wbqyuzMmvBFyZqlqXjwNPh4+Nq85vxkR
         /j2XngqhiHobVnXA+EQ0UKRGv7I8T8Ev6NRDH3UWbAH/ka5/Con7u/J8Q/C3zM5lR5kL
         L6FfPkLvR5HmVbRStVbji9eKJV9/Uk00nqps7h/PtB4gGUOX7lwauzDsuXLicKzsprKF
         9nV/u4FIZ7BmixnVsFFsxaNGAfwlEF4ssOWBkO0smKnTUZLjkUbZkYm17yLxF9N5M6np
         3eNEuXEASy4nKC+uxqjB/0nSZTYEh0Uxymmx+NfkbBc9q6tuHDbd4jGb7OIe2J0Yyr9/
         94Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724667226; x=1725272026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z07gjud24oTcgbqCvuKd+VAijUebGTMd0Q7+OuaVxsw=;
        b=CecYK7onKfhSrvecORe901yFiCAqj06arrFGsaqsQQAmtQnRvJD2nREqAHyBMv3i+z
         Zhs8y1xeWt5VwElNmJBVRH1WfNuIrtQQlUBcAzmVOZ814fbfDxyBQaSZZzYtnEd24Vln
         U0jGMl/my6QkO6pOw8xVhluFhktVOkMRyPl9vOVokGYh095GfvCTwYXNdhT5EBpuN37p
         1kJMuU9tVdKaQDKRaFi/AkFHVYDXRaHrKD+Ju99ZYwSRcgassSP91vbPGg1nMf7KBROb
         JtkVKseEdE1iqkLWJhGXPD7hKRMrn1NmN7vgN7F3+8UUkpLxKUKA9k78Cz9Nkv+jH1et
         dwRA==
X-Gm-Message-State: AOJu0YzX8mcwcXhajBMtCqd8JWpXRAIf0Csy5YBcHP+PvaiXYI6CQd+V
	wIIRdVHlCWJBiASWZOFRtlBxIKLlAE8tNEmzEnb2G9Ioez5OdIvmxNh9HylzTgo=
X-Google-Smtp-Source: AGHT+IEV9jpKoiiBYyVHlySZz6WD5j5YMWpJxDl5FvTQKGNhudF6LglyA82Hxz6x4bVSQON8qEJw5g==
X-Received: by 2002:a17:906:6a28:b0:a86:8000:be46 with SMTP id a640c23a62f3a-a86a52b3672mr416511666b.3.1724667226265;
        Mon, 26 Aug 2024 03:13:46 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4f459asm643856266b.198.2024.08.26.03.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 03:13:45 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH v2] bcachefs: Annotate bch_replicas_entry_{v0,v1} with __counted_by()
Date: Mon, 26 Aug 2024 12:11:36 +0200
Message-ID: <20240826101135.31482-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __counted_by compiler attribute to the flexible array members
devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Increment nr_devs before adding a new device to the devs array and
adjust the array indexes accordingly. Add a helper macro for adding a
new device.

In bch2_journal_read(), explicitly set nr_devs to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/buckets.c         | 2 +-
 fs/bcachefs/journal_io.c      | 3 ++-
 fs/bcachefs/replicas.c        | 6 +++---
 fs/bcachefs/replicas_format.h | 9 +++++++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index be2bbd248631..eda397c562f5 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -740,7 +740,7 @@ static int __trigger_extent(struct btree_trans *trans,
 				return ret;
 		} else if (!p.has_ec) {
 			replicas_sectors       += disk_sectors;
-			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs++] = p.ptr.dev;
+			replicas_entry_add_dev(&acc_replicas_key.replicas, p.ptr.dev);
 		} else {
 			ret = bch2_trigger_stripe_ptr(trans, k, p, data_type, disk_sectors, flags);
 			if (ret)
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 32b886feb2ca..30460bce04be 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1353,6 +1353,7 @@ int bch2_journal_read(struct bch_fs *c,
 	genradix_for_each(&c->journal_entries, radix_iter, _i) {
 		struct bch_replicas_padded replicas = {
 			.e.data_type = BCH_DATA_journal,
+			.e.nr_devs = 0,
 			.e.nr_required = 1,
 		};
 
@@ -1379,7 +1380,7 @@ int bch2_journal_read(struct bch_fs *c,
 			goto err;
 
 		darray_for_each(i->ptrs, ptr)
-			replicas.e.devs[replicas.e.nr_devs++] = ptr->dev;
+			replicas_entry_add_dev(&replicas.e, ptr->dev);
 
 		bch2_replicas_entry_sort(&replicas.e);
 
diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index 12b1d28b7eb4..e0880cb79345 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -122,7 +122,7 @@ static void extent_to_replicas(struct bkey_s_c k,
 			continue;
 
 		if (!p.has_ec)
-			r->devs[r->nr_devs++] = p.ptr.dev;
+			replicas_entry_add_dev(r, p.ptr.dev);
 		else
 			r->nr_required = 0;
 	}
@@ -139,7 +139,7 @@ static void stripe_to_replicas(struct bkey_s_c k,
 	for (ptr = s.v->ptrs;
 	     ptr < s.v->ptrs + s.v->nr_blocks;
 	     ptr++)
-		r->devs[r->nr_devs++] = ptr->dev;
+		replicas_entry_add_dev(r, ptr->dev);
 }
 
 void bch2_bkey_to_replicas(struct bch_replicas_entry_v1 *e,
@@ -180,7 +180,7 @@ void bch2_devlist_to_replicas(struct bch_replicas_entry_v1 *e,
 	e->nr_required	= 1;
 
 	darray_for_each(devs, i)
-		e->devs[e->nr_devs++] = *i;
+		replicas_entry_add_dev(e, *i);
 
 	bch2_replicas_entry_sort(e);
 }
diff --git a/fs/bcachefs/replicas_format.h b/fs/bcachefs/replicas_format.h
index b97208195d06..b7eff904acdb 100644
--- a/fs/bcachefs/replicas_format.h
+++ b/fs/bcachefs/replicas_format.h
@@ -5,7 +5,7 @@
 struct bch_replicas_entry_v0 {
 	__u8			data_type;
 	__u8			nr_devs;
-	__u8			devs[];
+	__u8			devs[] __counted_by(nr_devs);
 } __packed;
 
 struct bch_sb_field_replicas_v0 {
@@ -17,7 +17,7 @@ struct bch_replicas_entry_v1 {
 	__u8			data_type;
 	__u8			nr_devs;
 	__u8			nr_required;
-	__u8			devs[];
+	__u8			devs[] __counted_by(nr_devs);
 } __packed;
 
 struct bch_sb_field_replicas {
@@ -28,4 +28,9 @@ struct bch_sb_field_replicas {
 #define replicas_entry_bytes(_i)					\
 	(offsetof(typeof(*(_i)), devs) + (_i)->nr_devs)
 
+#define replicas_entry_add_dev(e, d) ({					\
+	(e)->nr_devs++;							\
+	(e)->devs[(e)->nr_devs - 1] = (d);				\
+})
+
 #endif /* _BCACHEFS_REPLICAS_FORMAT_H */
-- 
2.46.0

