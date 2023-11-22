Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BJsnfUsB"
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [IPv6:2001:41d0:1004:224b::aa])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA327D47
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 15:51:26 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700697085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c+NluGMH3ACG9C4v9tyqVQmooH2gf0OtbH4WLDdZuu0=;
	b=BJsnfUsB9ZLj8D6Kc7ijV5SCXDed20HLPXGuLTFxO8HCXbfj4PZyhQtvTG7tbFUx8tPTOF
	rTLXP125eU5rcyA+YdX/EbKGzKIozsWvGKwF5gD6mq4y0PelGref6XbkacJM0MZJlRTy2m
	CZJaVNKT/DluYq8juvZ9fNIjz/meEqE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	peterz@infradead.org
Cc: boqun.feng@gmail.com,
	longman@redhat.com,
	will@kernel.org,
	mingo@redhat.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/6] bcachefs: Use lock_class_is_held() for btree locking asserts
Date: Wed, 22 Nov 2023 18:51:11 -0500
Message-ID: <20231122235113.180132-5-kent.overstreet@linux.dev>
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
 fs/bcachefs/btree_locking.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 308c891ad3ca..ef84b0423deb 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -16,10 +16,7 @@ void bch2_btree_lock_init(struct btree_bkey_cached_common *b,
 #ifdef CONFIG_LOCKDEP
 void bch2_assert_btree_nodes_not_locked(void)
 {
-#if 0
-	//Re-enable when lock_class_is_held() is merged:
 	BUG_ON(lock_class_is_held(&bch2_btree_node_lock_key));
-#endif
 }
 #endif
 
-- 
2.42.0

