Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE491531E8
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226177; cv=none; b=A3TTPCvyB3y/HWnLeRgSVcVhLHaoJCQMQkaiDJKYGxban5lFP9rdnywcYXZgrWZV/SB2NO8LetHOJKW8s4YNHDrNRzTHonPShdXByPC7J/8pat+W2WqxyRLOkCi2rrC09uOIclty3mJRjJkAJwldSQtmIhTG3YpGixAzqjPiPSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226177; c=relaxed/simple;
	bh=0PlwVEgpUgI0HLsTfpsh8AFPEUd5sQwyAPv86thkT2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXGpTN+XMahMSCFqwFY6WxQjWdHUwf+GX290ODsA6JEt1MkQZXbpEbwO9JI2v1OZdKQc106zVGICpZq6vMrfjhprP5lPmA4otjNhV6Lmgs/iNqoBC9MnOlnAZx0uTIwuCa7rSQLa0QmpeB7WOw1MQ4TUQ0Z5S8OoeJ0QFyOAZUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cjUo2An3; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cjUo2An3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0uoAW1z4An7YcZZQM6C84h0/oqG0pkMMfZ6Jw5KWyW8=;
	b=cjUo2An3TCyiJks4a+zPOT0XvgBRvJMfWIE5djcV3blh7KR2wJQ7sIlNL4wK8F6nNiA82G
	vgqowbMvab7Hnd46QcgWRUhce2oqZ3J/4TsOTAkI1YVtH2p42k2Ov0LUyixZuGFbi3lYMq
	L1lkyVNgpNMEFriR/0SdqFVqweh8sZA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/9] bcachefs: fix restart handling in bch2_alloc_write_key()
Date: Fri, 18 Oct 2024 00:35:56 -0400
Message-ID: <20241018043602.4067344-7-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is ugly:

We may discover in alloc_write_key that the data type we calculated is
wrong, because BCH_DATA_need_discard is checked/set elsewhere, and the
disk accounting counters we calculated need to be updated.

But bch2_alloc_key_to_dev_counters(..., BTREE_TRIGGER_gc) is not safe
w.r.t. transaction restarts, so we need to propagate the fixup back to
our gc state in case we take a transaction restart.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_gc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 94bbd8505582..0ca3feeb42c8 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -820,12 +820,22 @@ static int bch2_alloc_write_key(struct btree_trans *trans,
 	 * fix that here:
 	 */
 	alloc_data_type_set(&gc, gc.data_type);
-
 	if (gc.data_type != old_gc.data_type ||
 	    gc.dirty_sectors != old_gc.dirty_sectors) {
 		ret = bch2_alloc_key_to_dev_counters(trans, ca, &old_gc, &gc, BTREE_TRIGGER_gc);
 		if (ret)
 			return ret;
+
+		/*
+		 * Ugly: alloc_key_to_dev_counters(..., BTREE_TRIGGER_gc) is not
+		 * safe w.r.t. transaction restarts, so fixup the gc_bucket so
+		 * we don't run it twice:
+		 */
+		percpu_down_read(&c->mark_lock);
+		struct bucket *gc_m = gc_bucket(ca, iter->pos.offset);
+		gc_m->data_type = gc.data_type;
+		gc_m->dirty_sectors = gc.dirty_sectors;
+		percpu_up_read(&c->mark_lock);
 	}
 
 	if (fsck_err_on(new.data_type != gc.data_type,
-- 
2.45.2

