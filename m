Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339CE2110E;
	Tue, 27 May 2025 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367125; cv=none; b=gvIjv056hv9RExqIiVg1yVajQ3kOLUjL32+YO7X1iIU8mxYHImURBHOck6u23mWK/C8LXD2zA5OaQ0Puuh1+MjrBe5RVIkSCweeweu1dxSgVIkoPe87DrGdLFyK3+r6ZRxQk145gJH/tliGIrhcNEKSkaMVoDoxeaw3Ohq1snmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367125; c=relaxed/simple;
	bh=z1y4lIBXx8sqGSstcVy0uVM+jGntez/sgqXCJmRGMJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CqPukR+SoC2I8lJ+3wPiG+gv6BiT7PeH7Cl7iBxMiJph5z/EBUiMROUqgE/usNebknwt/29+bpFDf0I1flfcOomksD3ax30r1Mbhhf97kMA1tyZZ2Njs88KNrGgvP9jB7TNQE7Tbe4hToosMPBGVcCYog7kXtWrP1wZZ74rQKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJtobHcc; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJtobHcc"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7424ccbef4eso2774419b3a.2;
        Tue, 27 May 2025 10:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748367123; x=1748971923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lbbm3hUoPFwMLsGg9lAlj1TA3litAzcTcIwN+ScTr2U=;
        b=WJtobHccYYhZ2MhOSe0MTHmYwwxJllfnDS+c8/RcGD7RkIDmtqlQCi1DgBdqIe5wKg
         4FP8SdSWZw7LElu4ORt6JAcc9ewW4BDchxcYW+J7SMZY5PluL7CrEYQofJiiwsWfnMup
         7CFPGIDRCcTCHExdOZKQBU7/LjybzQ0oyltes6yjzfToih4YkIN1V81g65V5OtK7t+xL
         vO9LXS7WeMo/gsLSNJd+2cXy6Cr6RzTNW0VmwNV88nIx6MJiv5+KHZ5fPZluPYFctBDB
         eVftnrbKty303HI6YDQWoKLVhleb4NfOeF25utGPwRiUTLtYQ7DB3RvbsdPjHvr7gDa+
         98BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748367123; x=1748971923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lbbm3hUoPFwMLsGg9lAlj1TA3litAzcTcIwN+ScTr2U=;
        b=N2Clv6secU/09TDzDj1pvoGS6zFbQlOSd1HRAQbVuDPEBKF5r7bjofYqdoyTXJmMym
         QPW2ypiqClSSZUB9uwlak4hxhklJo+C/as07zG4R7GZ0q9V8MRoDqVmX6DQgMxvyUd/x
         tHqWV8bTgjdlpjT199rrFl/3bPmJ5zSpeynt1f8PZWfxo1IWbwBsQakC1pEZFqCp+Y1I
         +85IjdSn6iBktBbqL65EeTevLFPjQ3DNLxhTLVzeD0ZeJJm96qIF3nK/9iBmIqtYRA9/
         6BF8hlM2TM4Db64KZFCdNu3kIIviqNy5/rBqIoYh7v8mHOccj8U9IQgDrgUQP7tmntHG
         83Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUUA2RwWKkVCCFfagh/R4LnSGwRqYC0ucL+KSFKDoIVk49M3UKxJx/4sTMfpIB1mtSGpmGYI8wQjJ+Ngws0@vger.kernel.org, AJvYcCWh4nW/PdAZBctEm37d56MCwBAyzw9AzGsetZWwEn7lMF5BUyk4+BFJPm9D6Z4hKaOgy65N8K32vp79R7fbyw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGuJe1aAgx9aaoHYMYOFsH9XKcnuEzjvwnegrMA4ec0AZSrz4p
	tyeizYLzhnHOTJS38avTyGMLcCI433W0u665vVwaQosKBvYaZlMm8SvI
X-Gm-Gg: ASbGncudWQJBKIUJAg7Mq0Lm8um0SMjyADmM1rWaysr7okkWz7By7WeU1s+c34mBVj1
	W52DEeOuwv/0sQl+0zX0DjUc1bEG/aoiKcabCej2hux8UN+8wgFrZ12BHXiX0tKydgHvePjm12g
	ReGvlPL18RKfZ+ZCPqhuYQgn7dVTLkfYcNbU0ROKg0gfM1Bo45b22GoRCEgYUjro7tb52lJlv2D
	nbGgd+uObO4aLVvgtxXSLBEX7GJ5U4kHC645uPbKFzzg8uBSzEv580oXCXA9IRW/qohwdmcscaa
	EsdNSQ43zPHCXNiF6K8ZxgGgFDl+Ujy3orqFqHj0e3TVnMxD+lGw8rFXKPB7ZgCzGbwfo0LJ4TQ
	=
X-Google-Smtp-Source: AGHT+IEXm+GMlYUdlqJ6d0RVxfKqYZ6ihxDP7IUEo8woY1E1vhr/3NhmnuTA7AcTEtmQ6Dg13wF4MQ==
X-Received: by 2002:a05:6a20:c78f:b0:1f5:51d5:9ef3 with SMTP id adf61e73a8af0-2188c285486mr19738313637.20.1748367123205;
        Tue, 27 May 2025 10:32:03 -0700 (PDT)
Received: from localhost.localdomain ([122.164.224.51])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0844d3sm18878298a12.51.2025.05.27.10.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 10:32:02 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH bcachefs-testing] bcachefs: fix goto jumping over guard initializers
Date: Tue, 27 May 2025 23:01:09 +0530
Message-ID: <20250527173116.368912-2-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add scope to guard mutexes in bch2_accounting_read
and __bch2_fsck_err to prevent the unlock func
from running on an uninitialized value when
goto skips over the guard macro. This also makes
it compile on Clang 19.

Fixes: 96aae449b7083 ("bcachefs: convert percpu rwsems to guards")
Fixes: 5582ffabeae15 ("bcachefs: Replace mutex_lock() with guards")

Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/disk_accounting.c |  63 +++++-----
 fs/bcachefs/error.c           | 230 +++++++++++++++++-----------------
 2 files changed, 149 insertions(+), 144 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 825420845cb8..3650b28ad48f 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -832,44 +832,47 @@ int bch2_accounting_read(struct bch_fs *c)
 	}
 	keys->gap = keys->nr = dst - keys->data;
 
-	guard(percpu_write)(&c->mark_lock);
+	{
+		guard(percpu_write)(&c->mark_lock);
 
-	darray_for_each_reverse(acc->k, i) {
-		struct disk_accounting_pos acc_k;
-		bpos_to_disk_accounting_pos(&acc_k, i->pos);
+		darray_for_each_reverse(acc->k, i) {
+			struct disk_accounting_pos acc_k;
+			bpos_to_disk_accounting_pos(&acc_k, i->pos);
 
-		u64 v[BCH_ACCOUNTING_MAX_COUNTERS];
-		memset(v, 0, sizeof(v));
+			u64 v[BCH_ACCOUNTING_MAX_COUNTERS];
+			memset(v, 0, sizeof(v));
 
-		for (unsigned j = 0; j < i->nr_counters; j++)
-			v[j] = percpu_u64_get(i->v[0] + j);
+			for (unsigned j = 0; j < i->nr_counters; j++)
+				v[j] = percpu_u64_get(i->v[0] + j);
 
-		/*
-		 * If the entry counters are zeroed, it should be treated as
-		 * nonexistent - it might point to an invalid device.
-		 *
-		 * Remove it, so that if it's re-added it gets re-marked in the
-		 * superblock:
-		 */
-		ret = bch2_is_zero(v, sizeof(v[0]) * i->nr_counters)
-			? -BCH_ERR_remove_disk_accounting_entry
-			: bch2_disk_accounting_validate_late(trans, &acc_k, v, i->nr_counters);
-
-		if (ret == -BCH_ERR_remove_disk_accounting_entry) {
-			free_percpu(i->v[0]);
-			free_percpu(i->v[1]);
-			darray_remove_item(&acc->k, i);
-			ret = 0;
-			continue;
+			/*
+			 * If the entry counters are zeroed, it should be treated as
+			 * nonexistent - it might point to an invalid device.
+			 *
+			 * Remove it, so that if it's re-added it gets re-marked in the
+			 * superblock:
+			 */
+			ret = bch2_is_zero(v, sizeof(v[0]) * i->nr_counters) ?
+							      -BCH_ERR_remove_disk_accounting_entry :
+							      bch2_disk_accounting_validate_late(
+								      trans, &acc_k, v, i->nr_counters);
+
+			if (ret == -BCH_ERR_remove_disk_accounting_entry) {
+				free_percpu(i->v[0]);
+				free_percpu(i->v[1]);
+				darray_remove_item(&acc->k, i);
+				ret = 0;
+				continue;
+			}
+
+			if (ret)
+				goto fsck_err;
 		}
 
-		if (ret)
-			goto fsck_err;
+		eytzinger0_sort(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
+				accounting_pos_cmp, NULL);
 	}
 
-	eytzinger0_sort(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
-			accounting_pos_cmp, NULL);
-
 	scoped_guard(preempt) {
 		struct bch_fs_usage_base *usage = this_cpu_ptr(c->usage);
 
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index dc0fbc97a0e5..be16a4b56a15 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -497,131 +497,133 @@ int __bch2_fsck_err(struct bch_fs *c,
 			}
 		}
 	}
-
-	guard(mutex)(&c->fsck_error_msgs_lock);
-	bool repeat = false, print = true, suppress = false;
-	bool inconsistent = false, exiting = false;
-	struct fsck_err_state *s =
-		count_fsck_err_locked(c, err, buf.buf, &repeat, &print, &suppress);
-	if (repeat) {
-		ret = s->ret;
-		goto err;
-	}
-
-	if ((flags & FSCK_AUTOFIX) &&
-	    (c->opts.errors == BCH_ON_ERROR_continue ||
-	     c->opts.errors == BCH_ON_ERROR_fix_safe)) {
-		prt_str(out, ", ");
-		if (flags & FSCK_CAN_FIX) {
-			prt_actioning(out, action);
-			ret = -BCH_ERR_fsck_fix;
-		} else {
-			prt_str(out, ", continuing");
-			ret = -BCH_ERR_fsck_ignore;
+	{
+		guard(mutex)(&c->fsck_error_msgs_lock);
+		bool repeat = false, print = true, suppress = false;
+		bool inconsistent = false, exiting = false;
+		struct fsck_err_state *s =
+			count_fsck_err_locked(c, err, buf.buf, &repeat, &print, &suppress);
+		if (repeat) {
+			ret = s->ret;
+			goto err;
 		}
 
-		goto print;
-	} else if (!test_bit(BCH_FS_in_fsck, &c->flags)) {
-		if (c->opts.errors != BCH_ON_ERROR_continue ||
-		    !(flags & (FSCK_CAN_FIX|FSCK_CAN_IGNORE))) {
-			prt_str_indented(out, ", shutting down\n"
-					 "error not marked as autofix and not in fsck\n"
-					 "run fsck, and forward to devs so error can be marked for self-healing");
-			inconsistent = true;
-			print = true;
+		if ((flags & FSCK_AUTOFIX) &&
+		    (c->opts.errors == BCH_ON_ERROR_continue ||
+		     c->opts.errors == BCH_ON_ERROR_fix_safe)) {
+			prt_str(out, ", ");
+			if (flags & FSCK_CAN_FIX) {
+				prt_actioning(out, action);
+				ret = -BCH_ERR_fsck_fix;
+			} else {
+				prt_str(out, ", continuing");
+				ret = -BCH_ERR_fsck_ignore;
+			}
+
+			goto print;
+		} else if (!test_bit(BCH_FS_in_fsck, &c->flags)) {
+			if (c->opts.errors != BCH_ON_ERROR_continue ||
+			    !(flags & (FSCK_CAN_FIX|FSCK_CAN_IGNORE))) {
+				prt_str_indented(out, ", shutting down\n"
+						 "error not marked as autofix and not in fsck\n"
+						 "run fsck, and forward to devs so error can be marked for self-healing");
+				inconsistent = true;
+				print = true;
+				ret = -BCH_ERR_fsck_errors_not_fixed;
+			} else if (flags & FSCK_CAN_FIX) {
+				prt_str(out, ", ");
+				prt_actioning(out, action);
+				ret = -BCH_ERR_fsck_fix;
+			} else {
+				prt_str(out, ", continuing");
+				ret = -BCH_ERR_fsck_ignore;
+			}
+		} else if (c->opts.fix_errors == FSCK_FIX_exit) {
+			prt_str(out, ", exiting");
 			ret = -BCH_ERR_fsck_errors_not_fixed;
 		} else if (flags & FSCK_CAN_FIX) {
-			prt_str(out, ", ");
-			prt_actioning(out, action);
-			ret = -BCH_ERR_fsck_fix;
-		} else {
-			prt_str(out, ", continuing");
-			ret = -BCH_ERR_fsck_ignore;
+			int fix = s && s->fix
+				? s->fix
+				: c->opts.fix_errors;
+
+			if (fix == FSCK_FIX_ask) {
+				print = false;
+
+				ret = do_fsck_ask_yn(c, trans, out, action);
+				if (ret < 0)
+					goto err;
+
+				if (ret >= YN_ALLNO && s)
+					s->fix = ret == YN_ALLNO
+						? FSCK_FIX_no
+						: FSCK_FIX_yes;
+
+				ret = ret & 1
+					? -BCH_ERR_fsck_fix
+					: -BCH_ERR_fsck_ignore;
+			} else if (fix == FSCK_FIX_yes ||
+				   (c->opts.nochanges &&
+				    !(flags & FSCK_CAN_IGNORE))) {
+				prt_str(out, ", ");
+				prt_actioning(out, action);
+				ret = -BCH_ERR_fsck_fix;
+			} else {
+				prt_str(out, ", not ");
+				prt_actioning(out, action);
+			}
+		} else if (!(flags & FSCK_CAN_IGNORE)) {
+			prt_str(out, " (repair unimplemented)");
 		}
-	} else if (c->opts.fix_errors == FSCK_FIX_exit) {
-		prt_str(out, ", exiting");
-		ret = -BCH_ERR_fsck_errors_not_fixed;
-	} else if (flags & FSCK_CAN_FIX) {
-		int fix = s && s->fix
-			? s->fix
-			: c->opts.fix_errors;
-
-		if (fix == FSCK_FIX_ask) {
-			print = false;
-
-			ret = do_fsck_ask_yn(c, trans, out, action);
-			if (ret < 0)
-				goto err;
 
-			if (ret >= YN_ALLNO && s)
-				s->fix = ret == YN_ALLNO
-					? FSCK_FIX_no
-					: FSCK_FIX_yes;
-
-			ret = ret & 1
-				? -BCH_ERR_fsck_fix
-				: -BCH_ERR_fsck_ignore;
-		} else if (fix == FSCK_FIX_yes ||
-			   (c->opts.nochanges &&
-			    !(flags & FSCK_CAN_IGNORE))) {
-			prt_str(out, ", ");
-			prt_actioning(out, action);
-			ret = -BCH_ERR_fsck_fix;
-		} else {
-			prt_str(out, ", not ");
-			prt_actioning(out, action);
-		}
-	} else if (!(flags & FSCK_CAN_IGNORE)) {
-		prt_str(out, " (repair unimplemented)");
-	}
+		if (ret == -BCH_ERR_fsck_ignore &&
+		    (c->opts.fix_errors == FSCK_FIX_exit ||
+		     !(flags & FSCK_CAN_IGNORE)))
+			ret = -BCH_ERR_fsck_errors_not_fixed;
 
-	if (ret == -BCH_ERR_fsck_ignore &&
-	    (c->opts.fix_errors == FSCK_FIX_exit ||
-	     !(flags & FSCK_CAN_IGNORE)))
-		ret = -BCH_ERR_fsck_errors_not_fixed;
+		if (test_bit(BCH_FS_in_fsck, &c->flags) &&
+		    (ret != -BCH_ERR_fsck_fix &&
+		     ret != -BCH_ERR_fsck_ignore)) {
+			exiting = true;
+			print = true;
+		}
 
-	if (test_bit(BCH_FS_in_fsck, &c->flags) &&
-	    (ret != -BCH_ERR_fsck_fix &&
-	     ret != -BCH_ERR_fsck_ignore)) {
-		exiting = true;
-		print = true;
-	}
 print:
-	prt_newline(out);
-
-	if (inconsistent)
-		__bch2_inconsistent_error(c, out);
-	else if (exiting)
-		prt_printf(out, "Unable to continue, halting\n");
-	else if (suppress)
-		prt_printf(out, "Ratelimiting new instances of previous error\n");
-
-	if (print) {
-		/* possibly strip an empty line, from printbuf_indent_add */
-		while (out->pos && out->buf[out->pos - 1] == ' ')
-			--out->pos;
-		printbuf_nul_terminate(out);
-
-		if (bch2_fs_stdio_redirect(c))
-			bch2_print(c, "%s", out->buf);
-		else
-			bch2_print_str(c, KERN_ERR, out->buf);
-	}
+		prt_newline(out);
+
+		if (inconsistent)
+			__bch2_inconsistent_error(c, out);
+		else if (exiting)
+			prt_printf(out, "Unable to continue, halting\n");
+		else if (suppress)
+			prt_printf(out, "Ratelimiting new instances of previous error\n");
+
+		if (print) {
+			/* possibly strip an empty line, from printbuf_indent_add */
+			while (out->pos && out->buf[out->pos - 1] == ' ')
+				--out->pos;
+			printbuf_nul_terminate(out);
+
+			if (bch2_fs_stdio_redirect(c))
+				bch2_print(c, "%s", out->buf);
+			else
+				bch2_print_str(c, KERN_ERR, out->buf);
+		}
 
-	if (s)
-		s->ret = ret;
+		if (s)
+			s->ret = ret;
 
-	/*
-	 * We don't yet track whether the filesystem currently has errors, for
-	 * log_fsck_err()s: that would require us to track for every error type
-	 * which recovery pass corrects it, to get the fsck exit status correct:
-	 */
-	if (flags & FSCK_CAN_FIX) {
-		if (ret == -BCH_ERR_fsck_fix) {
-			set_bit(BCH_FS_errors_fixed, &c->flags);
-		} else {
-			set_bit(BCH_FS_errors_not_fixed, &c->flags);
-			set_bit(BCH_FS_error, &c->flags);
+		/*
+		 * We don't yet track whether the filesystem currently has errors, for
+		 * log_fsck_err()s: that would require us to track for every error type
+		 * which recovery pass corrects it, to get the fsck exit status correct:
+		 */
+		if (flags & FSCK_CAN_FIX) {
+			if (ret == -BCH_ERR_fsck_fix) {
+				set_bit(BCH_FS_errors_fixed, &c->flags);
+			} else {
+				set_bit(BCH_FS_errors_not_fixed, &c->flags);
+				set_bit(BCH_FS_error, &c->flags);
+			}
 		}
 	}
 err:
-- 
2.49.0

