Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5E8187332;
	Mon,  7 Oct 2024 08:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728288686; cv=none; b=YWO00qWZPKXnrzZnifaR+WO5TPvFxQlbxA2T/RpQhKRiao0RBOUn5TWIPn56T6KXzUIjukbeffr1tpxXCjRlafWjNCPj37CHO97oD0/jweUrS7f90+dymrXvG33lple9L00erN1jcrPS4I3rX5P7tLNkep0AYxAsuhpvV6iVgBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728288686; c=relaxed/simple;
	bh=3sqmMeubWK8c+VIiH5OXyMZqgtPt8xlcut+1tWOMtZ4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DEc5PQShSkTW9PZ6pyYGer66DrLLvja7lkdB5yGbxV39HFhmnKsrdjZWcnuSy2SAhU0GMa/WvzJcGl37NryZN3H9vG8wBtzf/K4JaFE8JxVmxj21Vv4iHoeSnzTRoK9TExDmdGsYPWiyXYris1bB8q9mJrM/0Tqa57sIpyYF+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOqnrMh3; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOqnrMh3"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c8784e3bc8so5743224a12.1;
        Mon, 07 Oct 2024 01:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728288683; x=1728893483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=geqeaUFO7KX1Ee2XSQkPu7NYB2zlplkOMmq6CUE7T/s=;
        b=eOqnrMh3hVNvJne0KZUlNtsYrUVg+K+1KrK0t4dcv2hvPs48BUAmNXg3lQJoDxvRaw
         8VSVQQiYoKuJjPCFj5Q3rIVwWMYbXPJxrtgte8Bcn2iToNBB6spPLMiuvP1zg0A7dVB4
         +DLlz/g8ai50l0TXYYcbhIsPC4wBkI07ZmanIB0gBXbpSvSr0qFgjuwD8gsHPv777Avm
         uypzzOfr1wzH0+c9LsCSJhRIVUKxKOL8oOIlo7aqtfV6wnM5GKyi64cBGz07q4gRhNtI
         ns1gLUGUQ1BM83fwD5khmPCE4G3X58CFVnErLpEjh4r/zPWWtFBKjxLZYKcT8pyuOn80
         Ozsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728288683; x=1728893483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=geqeaUFO7KX1Ee2XSQkPu7NYB2zlplkOMmq6CUE7T/s=;
        b=Zi+jdCKlNvHBZI5qr3+/LcZtRIIFOpME1WbCBtoaxxQzRtUkeDbgSGLaIryPek3h4d
         Olxrg79xAvC6ZCR+/4vg9YKasMj4qXlNS2z/WLM24HSrUURTjgTg5yjfh+gfsyZ2mcLi
         6wq5qE1bIZVwlumREixtAGRlVw4D4Gvxmb1nou4UX4Dt+KvqY7SJ9uu88NpfeBsiX6D2
         weIPeRSZ2utzwDiG2VjXQEkimwsJU5DQBCpH7t778H54o48QBUgmPGsXStGUfBBDn6d4
         a+FwsMVbSL4etXMxI/fG1SwEoUeo48Wk8YfogPhi6XeePW91u7LpXpgi1XjDHt5tVXSJ
         qaUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLNsmelSX2v8IUASQU7KwdB2btCkDIM3tO8kNsg9p1JZ8OH/Kau/0K/xFaLhQJbNXgGhcxfA4QTAsgmq5LCQ==@vger.kernel.org, AJvYcCWZdLl7G4JWaJCpPw16NIL+Op/4OMNKyZGr9O2ydIphPYg01SfeoJbAzqjS3DJ1ouNbUWYs/WoEAsRoVakS@vger.kernel.org
X-Gm-Message-State: AOJu0YxdjL7BPuxvzCTvlz20WKSzmni3Q95m2brxCbF6+5pyNekDgv5L
	Kze7poxx6hPkMkFIWnoqeYSm2jyqYUQFfjPJTkRFyYFvLHbsBosG
X-Google-Smtp-Source: AGHT+IGzM8UejuTiQAumZPmn6GXZ43ToodEeHdSc4nLatypqtcMe2yCCCq1OxC0Qazaw0HgsP53T6A==
X-Received: by 2002:a17:907:3f96:b0:a99:4262:cc16 with SMTP id a640c23a62f3a-a994262cce4mr658311166b.27.1728288682713;
        Mon, 07 Oct 2024 01:11:22 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9935ee4594sm324632166b.189.2024.10.07.01.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 01:11:22 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH][next] bcachefs: remove superfluous ; after statements
Date: Mon,  7 Oct 2024 09:11:21 +0100
Message-Id: <20241007081121.1166346-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There are a several statements with two following semicolons, replace
these with just one semicolon.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/bcachefs/btree_update.c | 2 +-
 fs/bcachefs/ec.c           | 2 +-
 fs/bcachefs/super.c        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 514df618548e..39fc7778f15f 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -144,7 +144,7 @@ int __bch2_insert_snapshot_whiteouts(struct btree_trans *trans,
 	       !(ret = bkey_err(old_k)) &&
 	       bkey_eq(old_pos, old_k.k->p)) {
 		struct bpos whiteout_pos =
-			SPOS(new_pos.inode, new_pos.offset, old_k.k->p.snapshot);;
+			SPOS(new_pos.inode, new_pos.offset, old_k.k->p.snapshot);
 
 		if (!bch2_snapshot_is_ancestor(c, old_k.k->p.snapshot, old_pos.snapshot) ||
 		    snapshot_list_has_ancestor(c, &s, old_k.k->p.snapshot))
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 1587c6e1866a..f4fc4f08a2de 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -900,7 +900,7 @@ int bch2_ec_read_extent(struct btree_trans *trans, struct bch_read_bio *rbio,
 	bch2_bkey_val_to_text(&msgbuf, c, orig_k);
 	bch_err_ratelimited(c,
 			    "error doing reconstruct read: %s\n  %s", msg, msgbuf.buf);
-	printbuf_exit(&msgbuf);;
+	printbuf_exit(&msgbuf);
 	ret = -BCH_ERR_stripe_reconstruct;
 	goto out;
 }
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 873e4be7e1dc..32cc7a4bfa25 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1120,12 +1120,12 @@ static int bch2_dev_in_fs(struct bch_sb_handle *fs,
 
 		prt_bdevname(&buf, fs->bdev);
 		prt_char(&buf, ' ');
-		bch2_prt_datetime(&buf, le64_to_cpu(fs->sb->write_time));;
+		bch2_prt_datetime(&buf, le64_to_cpu(fs->sb->write_time));
 		prt_newline(&buf);
 
 		prt_bdevname(&buf, sb->bdev);
 		prt_char(&buf, ' ');
-		bch2_prt_datetime(&buf, le64_to_cpu(sb->sb->write_time));;
+		bch2_prt_datetime(&buf, le64_to_cpu(sb->sb->write_time));
 		prt_newline(&buf);
 
 		if (!opts->no_splitbrain_check)
-- 
2.39.5

