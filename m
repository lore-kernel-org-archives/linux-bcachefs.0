Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFEE21CA0D
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283685; cv=none; b=k6KRvNh3HhZDenWlZtH2MSrGPyk+IjYqxxkuBJaGofxcai3UqiiEx8rJ+GcnwOOY75xJMNYC/M8h/ZUvwtBn/ANmiFfyGYpZbYAxMu4uNemL+r5nHSlY4HF6Qhm4lHzsPPHyT/aNsc9yeAUmCcDIk2KzM4t2BIx2rlbavDybWAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283685; c=relaxed/simple;
	bh=1WP9F2gOPcY8TZa32hQfP2wN086pHTCsHbqtl3Oc6eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIkFcGcDsYQ4s/Hq4LRRMxjpiv5OcP4VXFknQNlMWfjvAVXB9pQ43ORveEfQ7JE2tO7glgb5mgxaGqss0ZLUs2kIYjp3FwBHGVSuJrNQjKADtsovy59c/GWCFh+EU3SKccHFRNZss7P8CYyluMVVakGhU21DSi55wHqQmxCAm5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jQa1N9o0; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jQa1N9o0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=onkzI0trjLINg1SoPkijt1fVBBbUat4fwLPC8ragRAo=;
	b=jQa1N9o0B4XJPlWJZEDPpk9W+Tib4HRaf4LownRGA97RLjaySGbgZoPC/f/Im1e4Ri/205
	Znc+5aVxlR7mPwNec8y/0RuRxC7VmUESAiVCGebqOLe11atHGlvNSsAJ/08OS/7YOswfnh
	iA/afkQgAG8bpzPvi2tHUAMQIjVygdY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/37] bcachefs: trace_extent_trim_atomic
Date: Wed, 18 Jun 2025 17:53:52 -0400
Message-ID: <20250618215431.738317-2-kent.overstreet@linux.dev>
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

Add a tracepoint for when we insert only part of an extent, due to too
many overwrites.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extent_update.c | 13 ++++++++++++-
 fs/bcachefs/trace.h         |  5 +++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/extent_update.c b/fs/bcachefs/extent_update.c
index b899ee75f5b9..e76e58a568bf 100644
--- a/fs/bcachefs/extent_update.c
+++ b/fs/bcachefs/extent_update.c
@@ -139,6 +139,17 @@ int bch2_extent_trim_atomic(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	bch2_cut_back(end, k);
+	/* tracepoint */
+
+	if (bpos_lt(end, k->k.p)) {
+		if (trace_extent_trim_atomic_enabled()) {
+			CLASS(printbuf, buf)();
+			bch2_bpos_to_text(&buf, end);
+			prt_newline(&buf);
+			bch2_bkey_val_to_text(&buf, trans->c, bkey_i_to_s_c(k));
+			trace_extent_trim_atomic(trans->c, buf.buf);
+		}
+		bch2_cut_back(end, k);
+	}
 	return 0;
 }
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index dc09532796af..41efebdd06ef 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1490,6 +1490,11 @@ DEFINE_EVENT(fs_str, io_move_evacuate_bucket,
 	TP_ARGS(c, str)
 );
 
+DEFINE_EVENT(fs_str, extent_trim_atomic,
+	TP_PROTO(struct bch_fs *c, const char *str),
+	TP_ARGS(c, str)
+);
+
 #ifdef CONFIG_BCACHEFS_PATH_TRACEPOINTS
 
 TRACE_EVENT(update_by_path,
-- 
2.50.0

