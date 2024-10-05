Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2031171C
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 02:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728094030; cv=none; b=uLrUxxfkmNAxk3niAn/aRLcVlB5kqgxStCgAnvGoXhSgJk3OrdS7VKBTZMlyUa1gha8Q+MbuzrgJIRzMvHwkQzbN2dtX0VtXXHDVPbYLTyv3SAA+mtpoqt5LgRHvFco0jpqF3XlR6KhLQoz4Um3ijZ/Vf3NYlvJvL3UZDTK3qQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728094030; c=relaxed/simple;
	bh=zGhbHxnVF0Zhth/WuiVakhxDBJXlhdsoWUUnF/4YDcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQQpyXsZQTjUeIVO+qS1JSEQsDSbcHCC1q4lKagZLpSK6HT4fUB30iX285zEf+D3Nu09iaZRKHxyyVWr4quttY269Ud8wDJFsGWv9MEvdk0Ur7Dg/0og4KU+w4MvwyVnVcuZRUV3xfrBZnqvyRvNuuyyoSsy5Y/ggCWutmQc7d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FUzaz3BE; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FUzaz3BE"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71b00a97734so2539647b3a.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 04 Oct 2024 19:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728094028; x=1728698828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hu2kbjjJ1NVF9kyqJkgXezO10F9lResgbFNdOhD/24U=;
        b=FUzaz3BEqr1md23jHbP5RFlywzuhf5hjyA8lhHdhIlsONA80yWIYIFzfd6OxeDsxgI
         QyP42As4382nAImER8Ys9scpozYfWAcTpSa1kmq1BKQpsNbwVGEVOFw6bDhSEPQL82hW
         y3fpoqaAyCG4hoiCLPLe4rq9q/A1u+/C6253zxkJNUDWGmEfWBUB7pjl8OP1FyJHc53O
         JeAm3SrPVCqo9t+7LkJLpILMU0Y9quT9Qn2S4ITiYzZIJgVfyHlOMcpAvQjFR2JJuqKN
         GEpGsANjHPjB964hyrSIvvMKjb2UpsK8ttdWGbA98gbag6EjjWOgSx/S6yVp6Wva5pk7
         cLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728094028; x=1728698828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hu2kbjjJ1NVF9kyqJkgXezO10F9lResgbFNdOhD/24U=;
        b=xKq6UkHhNfozDSm0G+zPbxN7jxSzFnG1AfpQH3R4Tw00zetcS+yvQDzjqWGxeyOBR9
         /69n5TXGWFwIuS9sW9jcXLrbeIcHUuNWeJDWrww3soCubpdLeLm2PKmAHpA7YmLAf7fz
         zXf8RlMegl7UGdqn3poPG+Cp617V7jnqtf2eJOV9A6dC1aA5yG6V3ozEPn5Bbwpp/SSd
         zGU5MyMeHh/Vi4AhETZXggbcPnAEWVMFULEUt7tIJTGG2/wGWSQNNaprvNifZRY4xYRN
         A2ZqBd0bx7XeZdUfnw6Q9MMOj9EKGu3JIF41L1lgWzF+usdteHOmMJlCZPqsao/NSPFs
         BecA==
X-Forwarded-Encrypted: i=1; AJvYcCXGAwCNpSSuYUscUQgnjwt5eTEplCwDscq5mL0lyBaPYXT5gyVRRWNC9fuuaUQMnNhFsAiEhpXbtD3uOSTL/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHhLtwjmzyZ+x9XwRWa4qJU5oqsf+9EbPkPkzRXcjEB4D2j6Nq
	ezfIOF3gh9bHTLkVoEGL2Ty9HbpG1Ew/dhRrA8ObIpj63WpllZVZ
X-Google-Smtp-Source: AGHT+IFFF4KnN1siK6h21W27epQYfuYo9QXSoI+/bpvZZeALjSQou8FQDiyfcXVxEGzhr3+itpqAuA==
X-Received: by 2002:a05:6a00:124a:b0:70d:33b3:2d7f with SMTP id d2e1a72fcca58-71de245f650mr6936832b3a.26.1728094027702;
        Fri, 04 Oct 2024 19:07:07 -0700 (PDT)
Received: from fedora-laptop.. ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7d09bsm540791b3a.199.2024.10.04.19.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 19:07:07 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] fuse: graceful shutdown when startup fails
Date: Fri,  4 Oct 2024 20:06:54 -0600
Message-ID: <20241005020654.93862-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When FUSE startup encounters an error after opening the filesystem--for
example because of a bad mountpoint--it exited uncleanly, which is a
bit unfriendly.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---

Another mitigation could be to check access(2) for the mountpoint before
doing any work...

 c_src/cmd_fusemount.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/c_src/cmd_fusemount.c b/c_src/cmd_fusemount.c
index f43d29f5..50d35832 100644
--- a/c_src/cmd_fusemount.c
+++ b/c_src/cmd_fusemount.c
@@ -1203,6 +1203,7 @@ int cmd_fusemount(int argc, char *argv[])
 	struct bch_opts bch_opts = bch2_opts_empty();
 	struct bf_context ctx = { 0 };
 	struct bch_fs *c = NULL;
+	struct fuse_session *se = NULL;
 	int ret = 0, i;
 
 	/* Parse arguments. */
@@ -1263,17 +1264,22 @@ int cmd_fusemount(int argc, char *argv[])
 		    bch2_err_str(PTR_ERR(c)));
 
 	/* Fuse */
-	struct fuse_session *se =
-		fuse_session_new(&args, &bcachefs_fuse_ops,
-				 sizeof(bcachefs_fuse_ops), c);
-	if (!se)
-		die("fuse_lowlevel_new err: %m");
+	se = fuse_session_new(&args, &bcachefs_fuse_ops,
+				sizeof(bcachefs_fuse_ops), c);
+	if (!se) {
+		fprintf(stderr, "fuse_lowlevel_new err: %m\n");
+		goto err;
+	}
 
-	if (fuse_set_signal_handlers(se) < 0)
-		die("fuse_set_signal_handlers err: %m");
+	if (fuse_set_signal_handlers(se) < 0) {
+		fprintf(stderr, "fuse_set_signal_handlers err: %m\n");
+		goto err;
+	}
 
-	if (fuse_session_mount(se, fuse_opts.mountpoint))
-		die("fuse_mount err: %m");
+	if (fuse_session_mount(se, fuse_opts.mountpoint)) {
+		fprintf(stderr, "fuse_mount err: %m\n");
+		goto err;
+	}
 
 	/* This print statement is a trigger for tests. */
 	printf("Fuse mount initialized.\n");
@@ -1287,17 +1293,22 @@ int cmd_fusemount(int argc, char *argv[])
 
 	ret = fuse_session_loop(se);
 
-	/* Cleanup */
-	fuse_session_unmount(se);
-	fuse_remove_signal_handlers(se);
-	fuse_session_destroy(se);
-
 out:
+	if (se) {
+		fuse_session_unmount(se);
+		fuse_remove_signal_handlers(se);
+		fuse_session_destroy(se);
+	}
+
 	free(fuse_opts.mountpoint);
 	fuse_opt_free_args(&args);
 	bf_context_free(&ctx);
 
 	return ret ? 1 : 0;
+
+err:
+	bch2_fs_stop(c);
+	goto out;
 }
 
 #endif /* BCACHEFS_FUSE */
-- 
2.46.0

