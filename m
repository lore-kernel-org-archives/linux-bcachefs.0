Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D02C2AF06
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930110; cv=none; b=G63988n5i/i70T2jMkO83ILrlMRXkG2sjTm9WJVkTmUmUqDuhh6XBGKPBsqoJ4kxqXaYJ8wk+P9bFNuy5aqZd076pwJRbz4p03vD0WH8wvFZg4xcR8KkzUnGlaWMlJFpy3jVqSM7UUKpUrryYrkhFAf8nIXzqA/pF6OtsjXAk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930110; c=relaxed/simple;
	bh=8EbxaY/nkFiFhpZR4CZcT6aQlTtalW99VviR9Fbw5CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlJB8K+520xzyFZaY4O3Yx7yzbxSNJnmP7dYGIVfDyJ3V5sWr3JqiW6SUV/JmG3F1BSt0ThgwNaMcXgUkqsGrHO8kfWS3U0Eh0hw1md7o4eE3jfjapvZ9T5W7SjwSgETzRj6ilwJyXbxirKROw2ZzAIPXd94wEK8Owo6JdSVUdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s5RWbci1; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s5RWbci1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4UOIPIXTJ3jRnEXjlXq8+5tvpwd38nAnC3/6Clw8Mzg=;
	b=s5RWbci14+VtdMGoI0kBLC+Bj4/ptunSB55Oyu/UJpPVh9z++aHbjrjuxy7aIxulgcPyly
	enRTonbbzASuvxTIbcRbxkLYGTU2Zdy/kPNVGW8QOxQ8egpoGKERnQqp9AFbk8kpIGdT1x
	TcVOLIEkxos4EttrFDZPZ1/PrWCFalY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/4] bcachefs: list_pop_entry()
Date: Fri, 29 Nov 2024 20:28:07 -0500
Message-ID: <20241130012812.3135521-2-kent.overstreet@linux.dev>
In-Reply-To: <20241130012812.3135521-1-kent.overstreet@linux.dev>
References: <20241130012812.3135521-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/ec.c       |  6 ++----
 fs/bcachefs/io_write.c |  4 +---
 fs/bcachefs/util.h     | 13 +++++++++++++
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 7d6c33f04092..250e73897d95 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2465,11 +2465,9 @@ void bch2_fs_ec_exit(struct bch_fs *c)
 
 	while (1) {
 		mutex_lock(&c->ec_stripe_head_lock);
-		h = list_first_entry_or_null(&c->ec_stripe_head_list,
-					     struct ec_stripe_head, list);
-		if (h)
-			list_del(&h->list);
+		h = list_pop_entry(&c->ec_stripe_head_list, struct ec_stripe_head, list);
 		mutex_unlock(&c->ec_stripe_head_lock);
+
 		if (!h)
 			break;
 
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 91be9e9abb71..20da357e389a 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -637,9 +637,7 @@ void bch2_write_point_do_index_updates(struct work_struct *work)
 
 	while (1) {
 		spin_lock_irq(&wp->writes_lock);
-		op = list_first_entry_or_null(&wp->writes, struct bch_write_op, wp_list);
-		if (op)
-			list_del(&op->wp_list);
+		op = list_pop_entry(&wp->writes, struct bch_write_op, wp_list);
 		wp_update_state(wp, op != NULL);
 		spin_unlock_irq(&wp->writes_lock);
 
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index fb02c1c36004..5e4820c8fa44 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -317,6 +317,19 @@ do {									\
 	_ptr ? container_of(_ptr, type, member) : NULL;			\
 })
 
+static inline struct list_head *list_pop(struct list_head *head)
+{
+	if (list_empty(head))
+		return NULL;
+
+	struct list_head *ret = head->next;
+	list_del_init(ret);
+	return ret;
+}
+
+#define list_pop_entry(head, type, member)		\
+	container_of_or_null(list_pop(head), type, member)
+
 /* Does linear interpolation between powers of two */
 static inline unsigned fract_exp_two(unsigned x, unsigned fract_bits)
 {
-- 
2.45.2

