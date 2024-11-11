Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0211BCA0F
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 21:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359124; cv=none; b=GKYaKuyL5FzwPwB2PbmgIGijCHlhoP8jImjn2zUvBu3Hi103i3ePLEQPyG4faeoWdCefA7qsh22f+sW94wROzfFGdyptOpr1EE8DAfTabXLoDZEbGqrmLeSfcJN4m8QzcfjEt7HL830OcMKwcBt+HWgHcwBoU1oTfSQBgn/3S3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359124; c=relaxed/simple;
	bh=oHuphlH42QaiFDwkgAbm5CEWHrJKMCMELWiNhAicNLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rreMsXvvpuNDrepzRQqFcGdLTIclpcg3SFAO7KdAJU27S7V/PO+eZNCR7VkU6re1k9Bw0RnfFwwJpH8V+gzO5RPCBzizDJ1YO2YlB9yLwQgjayXZZiLh70Ccm3TtUnYQ0AlrXUL+hmY5cxfP5lBbS8SR6IrqYjpvckUoOk+GvzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qdgXEhCF; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qdgXEhCF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731359119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MJZjK2IS/+Mh9HnPgkVJ6sZFNZviHKu2Xzjd0E8Klog=;
	b=qdgXEhCFrrkb2wPnpSS8rm25rNEUC3cE4q95w7u+N5PvJg0h7BVIlsswl4/huE3Hb/Wjs3
	4pvYiXGXcDkX9D9W7tUEyyMsAG7FnsjuWI9XzfxgrRSIiQCN3bChQ5waQKg4chCVyuQWts
	W+3yx5IBfkfEKODPj4GkTjDZPLmBUfY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix journal_entry_dev_usage_to_text() overrun
Date: Mon, 11 Nov 2024 16:05:09 -0500
Message-ID: <20241111210509.1335970-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the jset_entry_dev_usage is malformed, and too small, our nr_entries
calculation will be incorrect - just bail out.

Reported-by: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 667a2bb9e20b..768a3b950997 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -711,6 +711,9 @@ static void journal_entry_dev_usage_to_text(struct printbuf *out, struct bch_fs
 		container_of(entry, struct jset_entry_dev_usage, entry);
 	unsigned i, nr_types = jset_entry_dev_usage_nr_types(u);
 
+	if (vstruct_bytes(entry) < sizeof(*u))
+		return;
+
 	prt_printf(out, "dev=%u", le32_to_cpu(u->dev));
 
 	printbuf_indent_add(out, 2);
-- 
2.45.2

