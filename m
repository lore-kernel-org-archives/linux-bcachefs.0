Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56381A0BE1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912093; cv=none; b=hFwvETXApYbLTyq7m4qCyBUpByZvEyRHf/sGYk1+gY/XXN7XUTpxkUlzghCkwNXosumVPdpuoWLZiYYBsm6EmYw8+nL1GMTyZwK8DoB2L26W9a89JfQZDQWwuDa5JakpMJOoaxFXXmNOhmbAZP/clW3mm81F449fBncjDy3njzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912093; c=relaxed/simple;
	bh=eaOSIue7wvQWEkB6thLKHCyeXYQmT94njv9ABhoRjUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVVCA5eLnZLX419z1ixj4ADYo1lWwyAv5OQZfY2OT81uq7OsDLm1zjvh4CXFWk2hspsw3riicB86oTuX/Qwzm5jzQdARwUT/XZrx9Md+ZrRREF8H1K3ImkFzb3B3RNf8pbMKCHun17VVjsZEy4rqoQ3ncdYJw+uuxkObStai2FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 28/34] bcachefs: do_fsck_ask_yn()
Date: Fri, 29 Nov 2024 15:27:27 -0500
Message-ID: <20241129202736.2713679-29-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

__bch2_fsck_err() is huge, and badly needs more refactoring

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/error.c | 59 ++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 23b9ecbcf3cf..0517782ca57a 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -219,6 +219,30 @@ static const u8 fsck_flags_extra[] = {
 #undef x
 };
 
+static int do_fsck_ask_yn(struct bch_fs *c,
+			  struct btree_trans *trans,
+			  struct printbuf *question,
+			  const char *action)
+{
+	prt_str(question, ", ");
+	prt_str(question, action);
+
+	if (bch2_fs_stdio_redirect(c))
+		bch2_print(c, "%s", question->buf);
+	else
+		bch2_print_string_as_lines(KERN_ERR, question->buf);
+
+	int ask = bch2_fsck_ask_yn(c, trans);
+
+	if (trans) {
+		int ret = bch2_trans_relock(trans);
+		if (ret)
+			return ret;
+	}
+
+	return ask;
+}
+
 int __bch2_fsck_err(struct bch_fs *c,
 		  struct btree_trans *trans,
 		  enum bch_fsck_flags flags,
@@ -291,16 +315,14 @@ int __bch2_fsck_err(struct bch_fs *c,
 		 */
 		if (s->last_msg && !strcmp(buf.buf, s->last_msg)) {
 			ret = s->ret;
-			mutex_unlock(&c->fsck_error_msgs_lock);
-			goto err;
+			goto err_unlock;
 		}
 
 		kfree(s->last_msg);
 		s->last_msg = kstrdup(buf.buf, GFP_KERNEL);
 		if (!s->last_msg) {
-			mutex_unlock(&c->fsck_error_msgs_lock);
 			ret = -ENOMEM;
-			goto err;
+			goto err_unlock;
 		}
 
 		if (c->opts.ratelimit_errors &&
@@ -356,31 +378,18 @@ int __bch2_fsck_err(struct bch_fs *c,
 			: c->opts.fix_errors;
 
 		if (fix == FSCK_FIX_ask) {
-			prt_str(out, ", ");
-			prt_str(out, action);
-
-			if (bch2_fs_stdio_redirect(c))
-				bch2_print(c, "%s", out->buf);
-			else
-				bch2_print_string_as_lines(KERN_ERR, out->buf);
 			print = false;
 
-			int ask = bch2_fsck_ask_yn(c, trans);
-
-			if (trans) {
-				ret = bch2_trans_relock(trans);
-				if (ret) {
-					mutex_unlock(&c->fsck_error_msgs_lock);
-					goto err;
-				}
-			}
+			ret = do_fsck_ask_yn(c, trans, out, action);
+			if (ret < 0)
+				goto err_unlock;
 
-			if (ask >= YN_ALLNO && s)
-				s->fix = ask == YN_ALLNO
+			if (ret >= YN_ALLNO && s)
+				s->fix = ret == YN_ALLNO
 					? FSCK_FIX_no
 					: FSCK_FIX_yes;
 
-			ret = ask & 1
+			ret = ret & 1
 				? -BCH_ERR_fsck_fix
 				: -BCH_ERR_fsck_ignore;
 		} else if (fix == FSCK_FIX_yes ||
@@ -424,8 +433,6 @@ int __bch2_fsck_err(struct bch_fs *c,
 	if (s)
 		s->ret = ret;
 
-	mutex_unlock(&c->fsck_error_msgs_lock);
-
 	if (inconsistent)
 		bch2_inconsistent_error(c);
 
@@ -442,6 +449,8 @@ int __bch2_fsck_err(struct bch_fs *c,
 			set_bit(BCH_FS_error, &c->flags);
 		}
 	}
+err_unlock:
+	mutex_unlock(&c->fsck_error_msgs_lock);
 err:
 	if (action != action_orig)
 		kfree(action);
-- 
2.45.2

