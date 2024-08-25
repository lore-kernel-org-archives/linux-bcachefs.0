Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CC823CE
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 13:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724593021; cv=none; b=MH0QbhL4sxla197zMmrlNwJeX9eM8noK/9tiwE2vlKoBTcTgggjEt7+l41edpSZPJAC+fj+laeJ2dq41OcofLsLfWFJ6YVQbBtXa/I0jMHoboZnWZmjLGkSX/KR3kzRfQ4VaxX9oZF030ru28Js1CdX3vdSs6NH0iGE/XUMxj8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724593021; c=relaxed/simple;
	bh=L6ngP42zfOkPVV+HuIdFVHYtnL/4mHDfGfETE4wKx1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PR0PRis+TQdmILH9QQfudbAI6Qr4Wu0AaI6yR6wi7/3/OmAad8xNRAkqIokyA+3s3ghJCs0N8qoj6ej9LtbAGcLrClglWfdH7S07qiC8mCreEXRyufESv1Y3xAeWAqvhGfEJ/gRsLmkCyI8efki1zvxwV+znx8LRxHhB44Z95U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=lFoV0QIN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="lFoV0QIN"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5bebcdc75e9so586511a12.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 06:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724593017; x=1725197817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/KDIeVEMhAxZzstr0FQr1H4bQWyIq3mU0SsDV4tc9QY=;
        b=lFoV0QINfvg9pINSor8bDkt3ec/svs0U0kF0bCkzNaOtrPprRLeDRAGCfDXnTT4DEH
         T8IT39YIxiNuTPwxJEIN40rn1wFEC8x5dIDQE4E84qrvSBpIrMOmKPKpkHMe9NuTt0Hl
         kGl9V5lmlyuOEjNCzkboyEFAVew+Fia1RQ1ULpCDDA/YJBDCvD71EBBp5sWF9Ctm58a5
         HeKAPcuQs1rFMCz11W1f+eTj/IU675ckY/RiT6m/vzKPBpbsBfTJr1UT51Uzqn6qk9UN
         IQOI5l4vsNc4zulxAxFfekKjhnH8B7V1qnNuxrIMQa6UP286Cj3XN0wCYqZBnAH6Z4pM
         g8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724593017; x=1725197817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/KDIeVEMhAxZzstr0FQr1H4bQWyIq3mU0SsDV4tc9QY=;
        b=Iq1A1mXQyTs3vzgWHM4c8naQ2b14sBUccketzTvOGn1aOLP2l8cBRixbtZRua57yKp
         /FUs1oKJADfZ+kFzbY/uDYuBRz+w1R5zZPH+0A1f6QFDxcw3oz9ui6A1FmB6OANPaIey
         z50DvZLU3H+MGUFM72peisKRL23jG+3kTGnIX48L55r3YvHsFgTYavkA0mlwVH8IwZLh
         H7r3c1/k2J7+23eY85RcmCv9iJlASd/OFjmW/jZG9iaPC2vxlX87YancBXCdpb0hp6mO
         0u5c2wlvSobW2BwOWetPyqkWVydVITrjhQGTWADHhzxcDyMuNnHseqjozQDBU3ZGx5do
         l+YA==
X-Gm-Message-State: AOJu0YwN1ZbWbF6ecFevGXLpnUfrO98QP+gNAlaOB8vi8tDLJ4el1Knq
	mtj4/OUvI0U7PiOGo/p1DR7EssPtC5Sr6+1sAf+HBg02EX2o8jHeRVT9e5jEDO9FfXxwCQwNFPM
	s
X-Google-Smtp-Source: AGHT+IEMOTcUQEeSTW5q9HOc4QfXmnlIfa4tFWig4+ONSEhX3jHq4BkQ8lvkM4mIwRzrFgS93KJxDQ==
X-Received: by 2002:a17:907:2d07:b0:a7a:ab8a:38b with SMTP id a640c23a62f3a-a86a54b66aemr322917866b.7.1724593016936;
        Sun, 25 Aug 2024 06:36:56 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f220ce6sm545332066b.10.2024.08.25.06.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 06:36:56 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Annotate bch_replicas_entry_{v0,v1} with __counted_by()
Date: Sun, 25 Aug 2024 15:36:02 +0200
Message-ID: <20240825133601.24036-2-thorsten.blum@toblux.com>
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
adjust the array indexes accordingly.

In bch2_journal_read(), explicitly set nr_devs to 0.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/buckets.c         | 3 ++-
 fs/bcachefs/journal_io.c      | 3 ++-
 fs/bcachefs/replicas.c        | 6 +++---
 fs/bcachefs/replicas_format.h | 4 ++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index be2bbd248631..1e6badf9ddd2 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -740,7 +740,8 @@ static int __trigger_extent(struct btree_trans *trans,
 				return ret;
 		} else if (!p.has_ec) {
 			replicas_sectors       += disk_sectors;
-			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs++] = p.ptr.dev;
+			acc_replicas_key.replicas.nr_devs++;
+			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs - 1] = p.ptr.dev;
 		} else {
 			ret = bch2_trigger_stripe_ptr(trans, k, p, data_type, disk_sectors, flags);
 			if (ret)
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 7664b68e6a15..d1bd883c2c55 100644
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
+			replicas.e.devs[++replicas.e.nr_devs - 1] = ptr->dev;
 
 		bch2_replicas_entry_sort(&replicas.e);
 
diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index 1223b710755d..90d9b7d761bc 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -122,7 +122,7 @@ static void extent_to_replicas(struct bkey_s_c k,
 			continue;
 
 		if (!p.has_ec)
-			r->devs[r->nr_devs++] = p.ptr.dev;
+			r->devs[++r->nr_devs - 1] = p.ptr.dev;
 		else
 			r->nr_required = 0;
 	}
@@ -139,7 +139,7 @@ static void stripe_to_replicas(struct bkey_s_c k,
 	for (ptr = s.v->ptrs;
 	     ptr < s.v->ptrs + s.v->nr_blocks;
 	     ptr++)
-		r->devs[r->nr_devs++] = ptr->dev;
+		r->devs[++r->nr_devs - 1] = ptr->dev;
 }
 
 void bch2_bkey_to_replicas(struct bch_replicas_entry_v1 *e,
@@ -180,7 +180,7 @@ void bch2_devlist_to_replicas(struct bch_replicas_entry_v1 *e,
 	e->nr_required	= 1;
 
 	darray_for_each(devs, i)
-		e->devs[e->nr_devs++] = *i;
+		e->devs[++e->nr_devs - 1] = *i;
 
 	bch2_replicas_entry_sort(e);
 }
diff --git a/fs/bcachefs/replicas_format.h b/fs/bcachefs/replicas_format.h
index b97208195d06..d2e080d0ecb7 100644
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
-- 
2.46.0

