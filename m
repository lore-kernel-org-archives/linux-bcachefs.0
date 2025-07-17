Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488712AEF5
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 22:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752790071; cv=none; b=aso3w4+gh6hCfWSJjhcoXKzas8/o5qJpfl7Rz1nfmS+k6QBxTqzJXEZ/nmraeqOXzeOsSFLxLCbZpYiT8T7CIPtJbww/PYqlhwNpnVDiHoSGURdoeaT+KgrvzQyNn8oNjW2EyvwBvtJPqGjMHHl4zRqdMdNvRuG5Z3SkEFQNir0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752790071; c=relaxed/simple;
	bh=zFji24l43gPzWF6Qg5Yl8+JdhK/pTPqpBzanfgKgRWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M1XpcStmyji5KbmWpw4NJoWi9cmjK9Xk14ULGgn3A+on9dHMKA0jVt9WZjE8PnrIdTRv5DGl/VhFzHS+WzRO8jZlJpKAmCa+tg3dzf87vD0K4IstGu5xQYiTYZl1zExfdc8CkUeX/OxKOiQkW8l+75btsbvi2CeITNLXnrSZrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O1wcD6cg; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O1wcD6cg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752790067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q7qB8Xtqgn7HiOspK1fC4ZU5OBHeK694sfOWPmL7zN4=;
	b=O1wcD6cgYdByKDC5urTwp78hclb71ujQCxolTQhsewQTPw6HuJfnh7mFp9u9zRsGIOS8Kv
	7q3aqJZlVtdhwaEGK3fkPEMHjzWb3POUuDOdxWQWVVxq70ETre9vBSYhG6kohEDBIH4WwM
	0Ge4oVItF9qBbVjL2uiIo5Mrgnvcna8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+397f6fe952a0defb9424@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix unhandled key type in fiemap_fill_extent
Date: Thu, 17 Jul 2025 18:07:23 -0400
Message-ID: <20250717220723.84366-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KEY_TYPE_error was unhandled; also add a warning for other unhandled key
types.

Reported-by: syzbot+397f6fe952a0defb9424@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 2789b30add10..56b7126bc31d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1295,8 +1295,14 @@ static int bch2_fill_extent(struct bch_fs *c,
 					       flags|
 					       FIEMAP_EXTENT_DELALLOC|
 					       FIEMAP_EXTENT_UNWRITTEN);
+	} else if (k.k->type == KEY_TYPE_error) {
+		return 0;
 	} else {
-		BUG();
+		WARN_ONCE(1, "unhandled key type %s",
+			  k.k->type < KEY_TYPE_MAX
+			  ? bch2_bkey_types[k.k->type]
+			  : "(unknown)");
+		return 0;
 	}
 }
 
-- 
2.50.0

