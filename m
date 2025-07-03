Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FCE2D46C3
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Jul 2025 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751584957; cv=none; b=QJgIPzXSwtKTBDUSbxpsjLDkaGOcWOQZQ+NuUHYY1reHvhDNe4PXt/FaFvR2evfnqnnrqBevTmgpa9nzEIqBGhVeXFUf+Ac57lBL0kBbeNQBk4aUGNTY8MjpBmdRjKT5fQc2+vit/hcOCGjBjpO+E98jQY1iLTrv6T5gXtMFzq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751584957; c=relaxed/simple;
	bh=QpPN0YU8S0RPTX4EaEtdCz1QKuh8fjHDTMpWZ68gj5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SFfA3dNKxytRuSDnOAwnoLn9EncyEFj9HzDKUtFqBMtiVQTEtJGmFCExluSLO5BvLiAfjFJnz32CAdTMJQ2PL8XOvXa1FwYGCSdFqGyVGGY3XQDkpFQq1Hl6oqafRy1nMVwsrzANYQcY9tpgoI8iGuSEbijCbcj3HOX9V+n8Kwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G4I+JEPl; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G4I+JEPl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751584951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/HNbYfZJu6++voI609KNOTNGj3JMQ/IZGqpXLtpR9Ls=;
	b=G4I+JEPlyn1gtQ6EGS0M4hEaavYa2Zs0cNMhkCWmb5WKsZlHszmcjRLbT1ngQqL6S4wSBR
	iDkDGxa4CZdHvoQvF47Efnh60y42lWEwfFKE6Qv7JMPbj+JcgFhCkSniZsZOOT55fcl8sp
	6uwUQvgOu7138fTboUPWZ+dJTyn08qE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Nikita Ofitserov <himikof@gmail.com>,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: btree read retry fixes
Date: Thu,  3 Jul 2025 19:22:28 -0400
Message-ID: <20250703232228.249023-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix btree node read retries after validate errors:

__btree_err() is the wrong place to flag a topology error: that is done
by btree_lost_data().

Additionally, some calls to bch2_bkey_pick_read_device() were not
updated in the 6.16 rework for improved log messages; we were failing to
signal that we still had a retry.

Cc: Nikita Ofitserov <himikof@gmail.com>
Cc: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 8 +++-----
 fs/bcachefs/errcode.h  | 1 -
 fs/bcachefs/error.c    | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 84e302afc8fc..ab4c93025c67 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -568,9 +568,9 @@ static int __btree_err(int ret,
 		bch2_mark_btree_validate_failure(failed, ca->dev_idx);
 
 		struct extent_ptr_decoded pick;
-		have_retry = !bch2_bkey_pick_read_device(c,
+		have_retry = bch2_bkey_pick_read_device(c,
 					bkey_i_to_s_c(&b->key),
-					failed, &pick, -1);
+					failed, &pick, -1) == 1;
 	}
 
 	if (!have_retry && ret == -BCH_ERR_btree_node_read_err_want_retry)
@@ -615,7 +615,6 @@ static int __btree_err(int ret,
 			goto out;
 		case -BCH_ERR_btree_node_read_err_bad_node:
 			prt_str(&out, ", ");
-			ret = __bch2_topology_error(c, &out);
 			break;
 		}
 
@@ -644,7 +643,6 @@ static int __btree_err(int ret,
 		goto out;
 	case -BCH_ERR_btree_node_read_err_bad_node:
 		prt_str(&out, ", ");
-		ret = __bch2_topology_error(c, &out);
 		break;
 	}
 print:
@@ -1408,7 +1406,7 @@ static void btree_node_read_work(struct work_struct *work)
 		ret = bch2_bkey_pick_read_device(c,
 					bkey_i_to_s_c(&b->key),
 					&failed, &rb->pick, -1);
-		if (ret) {
+		if (ret <= 0) {
 			set_btree_node_read_error(b);
 			break;
 		}
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index d27b94a6610a..2de0dc91a69e 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -289,7 +289,6 @@
 	x(EIO,				sb_not_downgraded)			\
 	x(EIO,				btree_node_write_all_failed)		\
 	x(EIO,				btree_node_read_error)			\
-	x(EIO,				btree_node_read_validate_error)		\
 	x(EIO,				btree_need_topology_repair)		\
 	x(EIO,				bucket_ref_update)			\
 	x(EIO,				trigger_alloc)				\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index a9a9fe193966..71649b4164b8 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -103,7 +103,7 @@ int __bch2_topology_error(struct bch_fs *c, struct printbuf *out)
 		return bch_err_throw(c, btree_need_topology_repair);
 	} else {
 		return bch2_run_explicit_recovery_pass(c, out, BCH_RECOVERY_PASS_check_topology, 0) ?:
-			bch_err_throw(c, btree_node_read_validate_error);
+			bch_err_throw(c, btree_need_topology_repair);
 	}
 }
 
-- 
2.50.0

