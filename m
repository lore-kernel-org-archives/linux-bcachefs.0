Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB472FC42
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 23:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q492hZ+S"
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bc])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD3C2
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 15:57:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700006226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y+auCEsm8spxcK7ROREwXmqBOPFexigGHt0oIGcGo7c=;
	b=q492hZ+SKepHAJz01PDaMn2JDtXl1JJ3L4aHcImpi4iOkzbdcSWe0FwtfawjpdDy7bS44d
	5zf6HcpKW4oITuiIc0R5eQQx2948D/BHi1a6hIah4USF/p+iVOODbk2YCKlHDoHIP8OgE+
	qy+Z3GdEZShn02WckE6SQFRla029BLY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: six locks: Fix lost wakeup
Date: Tue, 14 Nov 2023 18:56:57 -0500
Message-ID: <20231114235657.1277123-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In percpu reader mode, trylock() for read had a lost wakeup: on failure
to get the lock, we may have caused a writer to fail to get the lock,
because we temporarily elevated the reader count.

We need to check for waiters after decrementing the read count - not
before.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/six.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index d22826cabee0..f37d5ad2c6ff 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -163,8 +163,11 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
 		this_cpu_sub(*lock->readers, !ret);
 		preempt_enable();
 
-		if (!ret && (old & SIX_LOCK_WAITING_write))
-			ret = -1 - SIX_LOCK_write;
+		if (!ret) {
+			smp_mb();
+			if (atomic_read(&lock->state) & SIX_LOCK_WAITING_write)
+				ret = -1 - SIX_LOCK_write;
+		}
 	} else if (type == SIX_LOCK_write && lock->readers) {
 		if (try) {
 			atomic_add(SIX_LOCK_HELD_write, &lock->state);
-- 
2.42.0

