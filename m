Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70F17991
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894311; cv=none; b=BWfWv0zOK56YCJqgMCA//Ug06V+peu12mnsw8UKZ9rPhfuFK84TjC1b/hY9UYhfPldqXDz3fc9ba6KWN6ZsHPy1mDhXRMNcFpvO+6mlDxHHEzC75C8LekNB5ju3cRbKRTUX5cIJybWF02X7Nj593DwuOgGNNx4yuOHZDajnWL6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894311; c=relaxed/simple;
	bh=Vn2rOgn4eLs7j1jE5ISey6fIqMvceHD4cuyu9RTmENQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldI0PpXSgP2nAMHVbtlxU57bWgemOBe7IZwOh2FcfpXgCaIHSfZ/IxXTkmlDc4mKaHLTQGcSssf6yLkTcDGZFWSWeThL2KqNeKGGe/iwE1mLCSMNQa89O3GmA2cJ9AZThuBWMDGP4ALFilTqfNAfRJsPj4Y4ttR6fG9x7OQoiH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hsQwcqkE; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hsQwcqkE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e4Frc5RcmUOn6t5F+pYnLHrala9DfBNnV8kFQQ1v+Jg=;
	b=hsQwcqkEqlVlRTPPz5y87spfWwjoDoSQmwVXAvY/mjgBLC7HkkZfcyhbrJuUKnuuvv6Qai
	6JWzphGd539qXZ6T8GvRDLhtQ1AF6/XW9oUaM//d1WhsnozMZrPJlzMF/dJQZAtfE+BWqD
	0yZWMHxp8Q3mvKdey0vR6hgStAY8WZ4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/7] bcachefs: fix bp_pos_to_bucket_nodev_noerror
Date: Sun, 17 Nov 2024 20:44:42 -0500
Message-ID: <20241118014451.2275941-2-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

_noerror means don't produce inconsistent errors, so it should be using
bch2_dev_rcu_noerror().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 74c96aee713e..eda3a78a5e2b 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -46,7 +46,7 @@ static inline struct bpos bp_pos_to_bucket(const struct bch_dev *ca, struct bpos
 static inline bool bp_pos_to_bucket_nodev_noerror(struct bch_fs *c, struct bpos bp_pos, struct bpos *bucket)
 {
 	rcu_read_lock();
-	struct bch_dev *ca = bch2_dev_rcu(c, bp_pos.inode);
+	struct bch_dev *ca = bch2_dev_rcu_noerror(c, bp_pos.inode);
 	if (ca)
 		*bucket = bp_pos_to_bucket(ca, bp_pos);
 	rcu_read_unlock();
-- 
2.45.2

