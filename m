Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6259B27E7C1
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283715; cv=none; b=noENVrtCQuCRrclItlDu3GBCCDRyM8Fv1KEESsFiJkhZHx5ygBzFFRpW6U55sTh52ziZtVNsU7ewqf9VkIZOVKyivGefc0KeNAHvQgcUx70d5xMjeMrnKyYrxF1Rv9k7y0goR/kqAMWeXjP+7hsbOj7QbjfphbNJ/YkmF8Om9z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283715; c=relaxed/simple;
	bh=8Zi+ycVUY9PPeD9FbbYr3lzhMURDZcbu8OfecXoFArY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC3Yjimk/MJnmQrklnmn/xT2L2oYA7zFQ9Alu7Nov7Cm7rAhh1Yu5JT5pqxLzISUj2b4DQZxRkjJfFK/MaOJe9u4rtEcJ8QlfXz3yCuwIN1JK782oItVvYysIL1MUd2F5IfFO8GSWOWEvQxozSNopSCA1i/BuPRIjGWUEqKycok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xaORRc3d; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xaORRc3d"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gXdm5P2tCNVAanD3d9i43I+A4/emB61pO72f3olKjDY=;
	b=xaORRc3d6wRXFeVSbkTVoVtcn1XwYsdcfz2ewQQLJpO9I9tDJL2mwy07XTtCyCPohMJbSs
	af+cwyNSUScmLQaKaUUnyju6x32IjjNzaS6aeDqBrsV6Y7xZpVZknJEFP0gNgE+wBc4U+j
	j7RU5Ha1yEh4h+e+lAmgbvpGnhimc/Y=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 35/37] bcachefs: fsck: Fix oops in key_visible_in_snapshot()
Date: Wed, 18 Jun 2025 17:54:26 -0400
Message-ID: <20250618215431.738317-36-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The normal fsck code doesn't call key_visible_in_snapshot() with an
empty list of snapshot IDs seen (the current snapshot ID will always be
on the list), but str_hash_repair_key() ->
bch2_get_snapshot_overwrites() can, and that's totally fine as long as
we check for it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 57ddc20a5cce..9920f1affc5b 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -728,14 +728,8 @@ static int snapshots_seen_update(struct bch_fs *c, struct snapshots_seen *s,
 static bool key_visible_in_snapshot(struct bch_fs *c, struct snapshots_seen *seen,
 				    u32 id, u32 ancestor)
 {
-	ssize_t i;
-
 	EBUG_ON(id > ancestor);
 
-	/* @ancestor should be the snapshot most recently added to @seen */
-	EBUG_ON(ancestor != seen->pos.snapshot);
-	EBUG_ON(ancestor != darray_last(seen->ids));
-
 	if (id == ancestor)
 		return true;
 
@@ -751,11 +745,8 @@ static bool key_visible_in_snapshot(struct bch_fs *c, struct snapshots_seen *see
 	 * numerically, since snapshot ID lists are kept sorted, so if we find
 	 * an id that's an ancestor of @id we're done:
 	 */
-
-	for (i = seen->ids.nr - 2;
-	     i >= 0 && seen->ids.data[i] >= id;
-	     --i)
-		if (bch2_snapshot_is_ancestor(c, id, seen->ids.data[i]))
+	darray_for_each_reverse(seen->ids, i)
+		if (*i != ancestor && bch2_snapshot_is_ancestor(c, id, *i))
 			return false;
 
 	return true;
-- 
2.50.0

