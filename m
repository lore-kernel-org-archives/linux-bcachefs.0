Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD963085CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283716; cv=none; b=FAUjoLS4uxwIofQ+IZ+J6UqqP3y7MSvwHSFsaA5C5PF1MW/x1OLC0RQVdWnqFhrk5HSzMhufWnZkkli5a8hyfgHDb/0/XWP5iI5HVmxXBVf8BdfMHYRjgrlX8owAj6Xc+GsUGgBMKOY8atvRr4g+mAH0r2HCPTVsX/kZPqMeLAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283716; c=relaxed/simple;
	bh=YtEmmrbi80TFHSdF5N7YWux122hxZ1hA9IFB2ptsNWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYgLPJ2PRk10+fh+CyrGtFvsLeYjl11UXt7Mm2r1kKoPs0WvL+Rb+rHJ0OZK0G45ElufNV8IfwxS0QIHypny3d04sXr3BmVErEBgjEt1i8WpYmdMdMBfugPkIwKzVFpu3mpCTTGzZuxSpVUWq7LGvnISLB3OF/IPAs3x1Nyx6Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jaZDTaek; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jaZDTaek"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0UmSPw0qitYeb0LESmLPMTjVIDyjdnDExYVY6PunxA=;
	b=jaZDTaekd9h73Ei9au1VCC9ijQPeDc1ylvCrYv5XxbTfHJMnvvNnJUQOMFba6Gi8hzdqH9
	6XFrqXgciVqqoLyK+kgIlFoEazJh2RjQFq1uAKlRvL7AcWnB/ieXwWsFwiMU15JRJvTEEE
	Z7TqWn3x8kA3Li6ocirYvLBrjN/DFRg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 37/37] bcachefs: Fix missing newlines before ero
Date: Wed, 18 Jun 2025 17:54:28 -0400
Message-ID: <20250618215431.738317-38-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 1 +
 fs/bcachefs/journal_io.c  | 5 +++--
 fs/bcachefs/recovery.c    | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 5f1174348974..e848e210a9bf 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -249,6 +249,7 @@ static int data_update_invalid_bkey(struct data_update *m,
 	bch2_bkey_val_to_text(&buf, c, k);
 	prt_str(&buf, "\nnew: ");
 	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
+	prt_newline(&buf);
 
 	bch2_fs_emergency_read_only2(c, &buf);
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index afbf12e8f0c5..dd3f3434c1b0 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1716,9 +1716,10 @@ static CLOSURE_CALLBACK(journal_write_done)
 		bch2_log_msg_start(c, &buf);
 
 		if (err == -BCH_ERR_journal_write_err)
-			prt_printf(&buf, "unable to write journal to sufficient devices");
+			prt_printf(&buf, "unable to write journal to sufficient devices\n");
 		else
-			prt_printf(&buf, "journal write error marking replicas: %s", bch2_err_str(err));
+			prt_printf(&buf, "journal write error marking replicas: %s\n",
+				   bch2_err_str(err));
 
 		bch2_fs_emergency_read_only2(c, &buf);
 
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index e0d824471bff..d0b7e3a36a54 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1142,7 +1142,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		struct printbuf buf = PRINTBUF;
 		bch2_log_msg_start(c, &buf);
 
-		prt_printf(&buf, "error in recovery: %s", bch2_err_str(ret));
+		prt_printf(&buf, "error in recovery: %s\n", bch2_err_str(ret));
 		bch2_fs_emergency_read_only2(c, &buf);
 
 		bch2_print_str(c, KERN_ERR, buf.buf);
-- 
2.50.0

