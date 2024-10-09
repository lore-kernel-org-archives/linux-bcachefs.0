Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F62191F65
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 23:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518009; cv=none; b=fVKBlhLugJfA7okN1nnfeWFxi7Wqqcq7gtoXA/sIoCcp3MhnOOgMqnKFCLwd/M+2R4LivqSf9GC3DnopZz2fN+ZWbNDXCQMDppk5dLIFkWg6AGvcLtqEah30suib+EHh2MIIFXspptZP78db31TRl9/2Buy3lqSRWTUnxWn9T2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518009; c=relaxed/simple;
	bh=X0GIu8qRNSslomI+XQcgk8IwXlmLqn67H2PdS/4io1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtReq67HNHrmQ8HIbvQkN3qAaB3mIo04xd3GjSyM9ReC9FLN0XgkVGmZp3nMuPZ8yn4X4jeJmFMePPC8UpQ2rvao5qComXz47T1gUZ48abiLhJQzFw3hOdKJRpVDemNq+yPj0YRt1vTJttomPLU59FBF2N5a7cibbaSWUIGk0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xXnTy13/; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xXnTy13/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728518004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knJnSFMPZwaFbJL7AKgUA85JK2hnzY4l7uMfHap69ZU=;
	b=xXnTy13/uy1ggEVJLfqvUtW+5xh6X1B4gYMD6MOFSlbfk189gyzm9QmXWPPFjJfcYSdrwl
	uF7vMCXWaTH4IM9dYiV8UDu25gxm4Z9HCgYQINL+lLYc2uRy/aSrG0ONwqs1SlPm6eBHbA
	8rC0Tb0YlbLrt+i908JNo3g8HdqKI50=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: colyli@suse.de,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Check if stuck in journal_res_get()
Date: Wed,  9 Oct 2024 19:53:15 -0400
Message-ID: <20241009235315.2249725-2-kent.overstreet@linux.dev>
In-Reply-To: <20241009235315.2249725-1-kent.overstreet@linux.dev>
References: <20241009235315.2249725-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Like how we already do when the allocator seems to be stuck, check if
we're waiting too long for a journal reservation and print some debug
info.

This is specifically to track down
https://github.com/koverstreet/bcachefs/issues/656

which is showing up in userspace where we don't have sysfs/debugfs to
get the journal debug info.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index f5f7db50ca31..dc099f06341f 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -603,6 +603,19 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 {
 	int ret;
 
+	if (closure_wait_event_timeout(&j->async_wait,
+		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
+		   (flags & JOURNAL_RES_GET_NONBLOCK),
+		   HZ * 10))
+		return ret;
+
+	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	struct printbuf buf = PRINTBUF;
+	bch2_journal_debug_to_text(&buf, j);
+	bch_err(c, "Journal stuck? Waited for 10 seconds...\n%s",
+		buf.buf);
+	printbuf_exit(&buf);
+
 	closure_wait_event(&j->async_wait,
 		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
 		   (flags & JOURNAL_RES_GET_NONBLOCK));
-- 
2.45.2

