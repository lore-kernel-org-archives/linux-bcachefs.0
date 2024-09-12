Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7CA18BBBA;
	Thu, 12 Sep 2024 18:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726166248; cv=none; b=RhUgMnXuedRZJlew+dTUubpf2TuPLSnIYxpDC7S7rAxm/Q/l6ZxxGrHOfYj36O6Qr2tQStR/Z/0e3JTc6UZfsBrmCotNa17AsaOt4bwBt+3zxO6L7TmAeBNHhgGDzsyRman1m1lcmEh+NDnnxslYbCxEJ+kHnKEN2wbIfCXqjz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726166248; c=relaxed/simple;
	bh=h9VI/4cVCjpPZz+PqttvfZ7uAdxKgaVSdsRKM/pSxxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P5r1Fo7OO7HDUfwmofoJGUGJZEhA1aaVGqLbTZ11EUivA+an00+4gMxKI57jNQXyCMNCt2U5oPaNFn8zOjwPwOzhaozYoBahFl8cPgzkOJOGiBmK/VfNeF9ADhKKtag3t2Z38d79Bt29P8NecwZ3I2pvKTlfKfO+SOd0/ad3K0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0ylVsim; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0ylVsim"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7d4fa972cbeso1106324a12.2;
        Thu, 12 Sep 2024 11:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726166245; x=1726771045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X6YiY80ygP4PpkSg0AQtVItl/ZBN1nDKv/7F2yDP6rU=;
        b=m0ylVsimWA0OzTQELlb5RI8OMHyCmUfnsN+u06XEr4h8RS1f4LGp5wjDTikJHaKp+W
         tpkvRoWjQrZaE8UlWtu6gfEibfipJ3yI/GTYllemtbZrQd+jo0kKmuoFl6N4WLKvwK1D
         FfpymTPvruGflF6gd3nbQW5Vs80pstJZy8aQbSn1G8i64JF1TjAIPsJbDScsepvtxSVC
         7DzxqLsbQ3IXtkuoCatyhsaaOGGHd27xkx/0EUwmKPj22zUOIX5Fckycwokydf8IYy2I
         FGHnPnYkm5zsjLXinBJoCtu1ezFYU6GFXp/t+YAuCt40iPtYn0qc6qQHK2ehEzB+n9Zo
         +XmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726166245; x=1726771045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6YiY80ygP4PpkSg0AQtVItl/ZBN1nDKv/7F2yDP6rU=;
        b=kfMevG9a7bMI1Lo5AhRdBpNR05wFrGcIBiu+Z/RNS4nfsOaePRVIKu1H2xjUyBL7wm
         NMyVxFeFdVxttWwwG4pGkOZM0rk2IAOw7K+Qw2tUuqVKhVd+mXiW5xZz3qddkyE6ZA08
         N3fTH4RiBH902+l8NsMxAdqr3DJVHaDuUXxLGYtnIyLCpSMUaxZflj7hQLoCuW5IG0B4
         p2k+PXaLhx+zL9PqCW6375Fb60yXMjUnNRYgutepfWYDAQ9dvp4NLseCmaQ1rFq+Ekcr
         snzoSzGGynxEhmRbGAjbDI5rBet8OLQ1fakTS0MQtzB1d4i0zkYa0wbRU9YGi6yG/XjC
         Wd3w==
X-Forwarded-Encrypted: i=1; AJvYcCXpuhIDMpUw+ofmyCRKejgGrbJawRTFt8oV2iheUJQzlPKUyDSgNzm3HmbDReaWlDcxCoggIF8WD+iEo1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHOQsoi6CAnS6iqqSpioqfqQwcI3ns2vUGQRIUL1b31UgCViEt
	g8fh66liwPke2FJGpQtNEzyv32BHswTbMdKH2amMMziyrfQE00I7ychfoxoK
X-Google-Smtp-Source: AGHT+IF72NMI1COTrw9+8zxx2GVkI3xcbdRpskdeMzvlmYTnJuAey4CYEUJKajvjZkMgIv2mKb0ipA==
X-Received: by 2002:a05:6a20:c79a:b0:1cf:2aaa:9199 with SMTP id adf61e73a8af0-1cf75eaeaccmr4684031637.15.1726166245068;
        Thu, 12 Sep 2024 11:37:25 -0700 (PDT)
Received: from fedora.. ([106.219.162.154])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fe52ecsm4881952b3a.53.2024.09.12.11.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 11:37:24 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Riyan Dhiman <riyandhiman14@gmail.com>
Subject: [PATCH] bcachefs: Change opts param to const pointer in bch2_opts_to_text
Date: Fri, 13 Sep 2024 00:05:46 +0530
Message-ID: <20240912183545.41669-2-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert struct bch_opts opts to const struct bch_opts *opts in
bch2_opts_to_text() function paramter. This improves efficiency by
avoiding structure copying and reflects the function's read-only
access to opts.

Fixes: 283ba1b92b1c (bcachefs: bch2_opts_to_text())
Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
---
Compile tested only.

 fs/bcachefs/fs.c   | 2 +-
 fs/bcachefs/opts.c | 4 ++--
 fs/bcachefs/opts.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index e44794f7c6a0..1a2ba8472cb1 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1924,7 +1924,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 	struct bch_fs *c = root->d_sb->s_fs_info;
 	struct printbuf buf = PRINTBUF;
 
-	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
+	bch2_opts_to_text(&buf, &c->opts, c, c->disk_sb.sb,
 			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
 	printbuf_nul_terminate(&buf);
 	seq_puts(seq, buf.buf);
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 232be8a44051..6216ab5d5c81 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -444,7 +444,7 @@ void bch2_opt_to_text(struct printbuf *out,
 }
 
 void bch2_opts_to_text(struct printbuf *out,
-		       struct bch_opts opts,
+		       const struct bch_opts *opts,
 		       struct bch_fs *c, struct bch_sb *sb,
 		       unsigned show_mask, unsigned hide_mask,
 		       unsigned flags)
@@ -457,7 +457,7 @@ void bch2_opts_to_text(struct printbuf *out,
 		if ((opt->flags & hide_mask) || !(opt->flags & show_mask))
 			continue;
 
-		u64 v = bch2_opt_get_by_id(&opts, i);
+		u64 v = bch2_opt_get_by_id(opts, i);
 		if (v == bch2_opt_get_by_id(&bch2_opts_default, i))
 			continue;
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index cb2e244a2429..78e1991dc4be 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -606,7 +606,7 @@ int bch2_opt_parse(struct bch_fs *, const struct bch_option *,
 void bch2_opt_to_text(struct printbuf *, struct bch_fs *, struct bch_sb *,
 		      const struct bch_option *, u64, unsigned);
 void bch2_opts_to_text(struct printbuf *,
-		       struct bch_opts,
+		       const struct bch_opts *,
 		       struct bch_fs *, struct bch_sb *,
 		       unsigned, unsigned, unsigned);
 
-- 
2.46.0

