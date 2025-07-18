Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB9219EB
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 06:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821251; cv=none; b=MG5ds0gh4ltjzajvAaF1URZBUHcKQ+pR/8zpP7/OKzY1WcKBRqDD0QR//nruBzJSFf3Rwv0RQXd0AWiStfinlPsl5ZglAX7FvnxIM6r1MqEunx3EfOH0rbJsOdW7UDK1V/IiTIxOetoQ5G9Iil4w8Ag5RHzkZ3Xf5UWowPezCKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821251; c=relaxed/simple;
	bh=QS0ePPj/7wGzyZjqWo/9SuOWPiU4pK6AYb6f8v8BRf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO6o0iCVlp6yvAqfy9KeWeHjF0CFp7ZrwwS7TO5JvZCInxrcA8DseOMo77qQrG7XYLFY4ujKULrLnv4Z+tSzTkAioUz4iolJznUCl1fSoPymPvsCbu4ArSQ0xyh01hXpddeppgVFlnv8keR0h9+3yjKhIMEv3djvWAe9pMgeOXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OBIWY9N4; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OBIWY9N4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752821246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDEbSDbSDfemRrDz3Qn2Uw3SnKhoUcGMMTgMj9IUnIs=;
	b=OBIWY9N4R0JRVL1uUjxuKxZh632VOu+YjfNv+Ny+ZDOL8xlknqoHSaA3oMvgbV3Rn0k7+5
	Pm/8QtnfxC9p631qIvgnb/634ZvvvpG+XQWMMCaMbQrIrRiJ5JEsMyz3DHhdkPg2ixi5Oj
	hCLErFT3SagaBVGU4RBGLyuvO+cdd9Q=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] bcachefs: rereplicate flushes interior updates
Date: Fri, 18 Jul 2025 02:47:14 -0400
Message-ID: <20250718064715.333124-3-kent.overstreet@linux.dev>
In-Reply-To: <20250718064715.333124-1-kent.overstreet@linux.dev>
References: <20250718064715.333124-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We need to flush interior updates before gcing replicas entries,
otherwise we might still see replicas entries from in flight btree
updates.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 3419e406f0c7..54dd6fec81db 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -1346,6 +1346,7 @@ int bch2_data_job(struct bch_fs *c,
 				     writepoint_hashed((unsigned long) current),
 				     true,
 				     rereplicate_pred, c) ?: ret;
+		bch2_btree_interior_updates_flush(c);
 		ret = bch2_replicas_gc2(c) ?: ret;
 		break;
 	case BCH_DATA_OP_migrate:
-- 
2.50.0

