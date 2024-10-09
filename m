Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AB017B500
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 23:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518008; cv=none; b=XVaCOOHUE2IGzm38GIsTmODk+RtSloEqecZkckBwtZw+DWIvbQBh9upG/HFecZE1q8kupc4PPf+YWS6nEQlFtJ3ShCYbfK5fWgXSJ5jnChvAN4CslbibzcB2fqCQu7SJbWDDB7dHmK+gT7dzKhrJ/T708VAqXmZuGbB5WVkrChw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518008; c=relaxed/simple;
	bh=WI7Ql5zQTRiGZvFBQTLjB2ox07x8nCzaNEVCu+ozaBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AtojmpYcEbFU9536kpGdhagSam3oBuStpfs/zqYdP/Tn3dzuvPAU/KQoeboH9mHRvJlitA2CKsU4jCoihPxCaRWY3HHp7Blg75NwV/Nf+AOquXVJRZ0/zSsEd1OpY1Djmm0kF8KOL9qRizgtSPTr6dsn2jem+0chK3i63VZO4D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aRyAKtRf; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aRyAKtRf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728518003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xdMgEGnAHd9YJnnpWwxNi2Jwe9UZM+GmS1e+u28A52g=;
	b=aRyAKtRfKcLy1HBJIzuLvy8YJXnXA9RmjKlZk5zLYotKIRaYGSCD8R4yutW9X/YJ7y7VrP
	4u2S4Vaheo9mAli5t+TqZCPpt2AwLKI6zQyn0JizBMo6oEN5e2niOSOJN3TAAGgJ26+EQm
	P8Kr2kTFCAs/mBDEu0vg7v0jhfrb9S8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: colyli@suse.de,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] closures: Add closure_wait_event_timeout()
Date: Wed,  9 Oct 2024 19:53:14 -0400
Message-ID: <20241009235315.2249725-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a closure version of wait_event_timeout(), with the same semantics.

The closure version is useful because unlike wait_event(), it allows
blocking code to run in the conditional expression.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/closure.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 2af44427107d..880fe85e35e9 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -454,4 +454,39 @@ do {									\
 		__closure_wait_event(waitlist, _cond);			\
 } while (0)
 
+#define __closure_wait_event_timeout(waitlist, _cond, _until)		\
+({									\
+	struct closure cl;						\
+	long _t;							\
+									\
+	closure_init_stack(&cl);					\
+									\
+	while (1) {							\
+		closure_wait(waitlist, &cl);				\
+		if (_cond) {						\
+			_t = max_t(long, 1L, _until - jiffies);		\
+			break;						\
+		}							\
+		_t = max_t(long, 0L, _until - jiffies);			\
+		if (!_t)						\
+			break;						\
+		closure_sync_timeout(&cl, _t);				\
+	}								\
+	closure_wake_up(waitlist);					\
+	closure_sync(&cl);						\
+	_t;								\
+})
+
+/*
+ * Returns 0 if timeout expired, remaining time in jiffies (at least 1) if
+ * condition became true
+ */
+#define closure_wait_event_timeout(waitlist, _cond, _timeout)		\
+({									\
+	unsigned long _until = jiffies + _timeout;			\
+	(_cond)								\
+		? max_t(long, 1L, _until - jiffies)			\
+		: __closure_wait_event_timeout(waitlist, _cond, _until);\
+})
+
 #endif /* _LINUX_CLOSURE_H */
-- 
2.45.2

