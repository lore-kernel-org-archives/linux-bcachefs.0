Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KLDlFEbK"
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A81A5
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 12:33:25 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701894803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6Z+qtf0J2K+kcTmOmCa+fyqiJE8yrtEIXb+xXYGI1Q=;
	b=KLDlFEbKuKwm3bU9KB2AuhrcYWSqOPOq08ALvOuC1xHkhVQK+vgpLuRAoEWQJirSLqwpML
	LvDRILcRxSwyLlzy+8cM2tlzBxT+pU04sJMMF0Fh8XNWDgOpy1fSicifVzLf5q173R4zQl
	HlcZrUoErZRHVGEDBNDKeB2eq3tT3rU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	djwong@kernel.org
Subject: [PATCH 4/6] bcachefs: bch2_run_online_recovery_passes()
Date: Wed,  6 Dec 2023 15:33:08 -0500
Message-ID: <20231206203313.2197302-5-kent.overstreet@linux.dev>
In-Reply-To: <20231206203313.2197302-1-kent.overstreet@linux.dev>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper for running online recovery passes - i.e. online fsck.
This is a subset of our normal recovery passes, and does not - for now -
use or follow c->curr_recovery_pass.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |  7 ++++++
 fs/bcachefs/recovery.c | 51 ++++++++++++++++++++++++++++--------------
 fs/bcachefs/recovery.h |  1 +
 3 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 4689a6d6233b..83ef5d29c226 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -1038,6 +1038,13 @@ struct bch_fs {
 	/* RECOVERY */
 	u64			journal_replay_seq_start;
 	u64			journal_replay_seq_end;
+	/*
+	 * Two different uses:
+	 * "Has this fsck pass?" - i.e. should this type of error be an
+	 * emergency read-only
+	 * And, in certain situations fsck will rewind to an earlier pass: used
+	 * for signaling to the toplevel code which pass we want to run now.
+	 */
 	enum bch_recovery_pass	curr_recovery_pass;
 	/* bitmap of explicitly enabled recovery passes: */
 	u64			recovery_passes_explicit;
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 585b4928964f..262c923b2f1a 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -634,7 +634,7 @@ u64 bch2_fsck_recovery_passes(void)
 
 static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
-	struct recovery_pass_fn *p = recovery_pass_fns + c->curr_recovery_pass;
+	struct recovery_pass_fn *p = recovery_pass_fns + pass;
 
 	if (c->opts.norecovery && pass > BCH_RECOVERY_PASS_snapshots_read)
 		return false;
@@ -651,39 +651,56 @@ static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pa
 
 static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
+	struct recovery_pass_fn *p = recovery_pass_fns + pass;
 	int ret;
 
-	c->curr_recovery_pass = pass;
+	if (!(p->when & PASS_SILENT))
+		printk(KERN_INFO bch2_log_msg(c, "%s..."),
+		       bch2_recovery_passes[pass]);
+	ret = p->fn(c);
+	if (ret)
+		return ret;
+	if (!(p->when & PASS_SILENT))
+		printk(KERN_CONT " done\n");
 
-	if (should_run_recovery_pass(c, pass)) {
-		struct recovery_pass_fn *p = recovery_pass_fns + pass;
+	return 0;
+}
 
-		if (!(p->when & PASS_SILENT))
-			printk(KERN_INFO bch2_log_msg(c, "%s..."),
-			       bch2_recovery_passes[pass]);
-		ret = p->fn(c);
-		if (ret)
-			return ret;
-		if (!(p->when & PASS_SILENT))
-			printk(KERN_CONT " done\n");
+static int bch2_run_recovery_passes(struct bch_fs *c)
+{
+	int ret = 0;
 
-		c->recovery_passes_complete |= BIT_ULL(pass);
+	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
+		if (should_run_recovery_pass(c, c->curr_recovery_pass)) {
+			ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
+			if (bch2_err_matches(ret, BCH_ERR_restart_recovery))
+				continue;
+			if (ret)
+				break;
+
+			c->recovery_passes_complete |= BIT_ULL(c->curr_recovery_pass);
+		}
+		c->curr_recovery_pass++;
 	}
 
-	return 0;
+	return ret;
 }
 
-static int bch2_run_recovery_passes(struct bch_fs *c)
+int bch2_run_online_recovery_passes(struct bch_fs *c)
 {
 	int ret = 0;
 
-	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
+	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++) {
+		struct recovery_pass_fn *p = recovery_pass_fns + c->curr_recovery_pass;
+
+		if (!(p->when & PASS_ONLINE))
+			continue;
+
 		ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
 		if (bch2_err_matches(ret, BCH_ERR_restart_recovery))
 			continue;
 		if (ret)
 			break;
-		c->curr_recovery_pass++;
 	}
 
 	return ret;
diff --git a/fs/bcachefs/recovery.h b/fs/bcachefs/recovery.h
index 852d30567da9..447590f60609 100644
--- a/fs/bcachefs/recovery.h
+++ b/fs/bcachefs/recovery.h
@@ -25,6 +25,7 @@ static inline int bch2_run_explicit_recovery_pass(struct bch_fs *c,
 	}
 }
 
+int bch2_run_online_recovery_passes(struct bch_fs *);
 u64 bch2_fsck_recovery_passes(void);
 
 int bch2_fs_recovery(struct bch_fs *);
-- 
2.42.0

