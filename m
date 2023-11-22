Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A6re6fRt"
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BDA1B3
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 15:51:28 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700697087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Myq1bmeGBQIlDgNEhC6NfEwTgajaz4KUdFS8x/+ovE0=;
	b=A6re6fRtOjUFuLPZzy5AdlBTwdRPq7aLxjX6JGSBeKgnLzPIC/GD5yVCd0FuncsK/NGqOp
	7tuaaJJEUaw9FtVUiLOsADzufm1rX2U9EunUFQgJ1EW5LuRubvAKm9IXTo+TkZIcY5CZWA
	IiqZmoHO5PULFkkEhUpY6ZlHc4YKmEY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	peterz@infradead.org
Cc: boqun.feng@gmail.com,
	longman@redhat.com,
	will@kernel.org,
	mingo@redhat.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/6] bcachefs: Switch to lockdep_set_no_check_recursion()
Date: Wed, 22 Nov 2023 18:51:13 -0500
Message-ID: <20231122235113.180132-7-kent.overstreet@linux.dev>
In-Reply-To: <20231122235113.180132-1-kent.overstreet@linux.dev>
References: <20231122235113.180132-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_locking.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index ef84b0423deb..59c57c585a4c 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -10,7 +10,9 @@ void bch2_btree_lock_init(struct btree_bkey_cached_common *b,
 			  enum six_lock_init_flags flags)
 {
 	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags);
-	lockdep_set_novalidate_class(&b->lock);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_set_no_check_recursion(&b->lock.dep_map);
+#endif
 }
 
 #ifdef CONFIG_LOCKDEP
-- 
2.42.0

