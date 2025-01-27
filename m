Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392C152E02
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951178; cv=none; b=RfSM19YYk81N+4QblYYtgg19L1VuCF2+1gnQhoCbJ1JIlf3hO7hHQQHm3egNPqYpVuB8ETXOFv3BIfNqfczWNqoUIiekUKlwnlY9oQFh0QRbEfL0AvNuZPyM2pd8Q/VPV7eBX0NqInnPXTKBrdhrb+wZze40iEVTrEXNUIzL8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951178; c=relaxed/simple;
	bh=wFj54uGOZCx/EkrgRuAPquBjwCSD0pF75g2gplsaM5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3U6Xa50S/q1P8t1Wp+9Bq/KWWQpS5NzJ6XTonwJTVmS5jthIhfALGDeBRD1C3b3pgHHqMj22/eO/+XijQlU32WUKnnDJH0VAVK2j1CksRiDhiihJ+K3/0OXpeftPlkkQjUDHLR2kipHICJIo6bV+gvtvCdsH/bEO9mhh/3X4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X24A9BbM; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X24A9BbM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mAXIhYdPqgbj5W+RM2jTa/OBpiwQ7gpPIch81R9CbQw=;
	b=X24A9BbMfvHzqmkGE5kQqCrEmVYc9PCzspBto7GVgyTfXNN66hcm8AsGTltyKG1nu6F4dT
	YQ4Ex582T41tkWdw3zBQOWvH5E+73/mCMBo+YIeXvo+2BjkUzu0Hw9iLGdZj8yLDATwfmY
	N9geUHxAXlvJJkHV107Ezd5ZbMiGqtc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/11] bcachefs: rebalance, copygc enabled are runtime opts
Date: Sun, 26 Jan 2025 23:12:32 -0500
Message-ID: <20250127041239.2693707-7-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix a regression from when these were switched to normal opts.h options.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/opts.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index e763d52e0f38..a182b5d454ba 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -476,13 +476,13 @@ enum fsck_err_opts {
 	  NULL,		"Enable nocow mode: enables runtime locking in\n"\
 			"data move path needed if nocow will ever be in use\n")\
 	x(copygc_enabled,		u8,				\
-	  OPT_FS|OPT_MOUNT,						\
+	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,			true,			\
 	  NULL,		"Enable copygc: disable for debugging, or to\n"\
 			"quiet the system when doing performance testing\n")\
 	x(rebalance_enabled,		u8,				\
-	  OPT_FS|OPT_MOUNT,						\
+	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,			true,			\
 	  NULL,		"Enable rebalance: disable for debugging, or to\n"\
-- 
2.45.2

