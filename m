Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E0139D0A;
	Wed,  2 Apr 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743610254; cv=none; b=ayEEiKquUaIDqgd49Thq6V4HxJ7ppcbj+cQUHlytb7gh241dRAGR3sAzbESmAA3vF34jsSTrVJ3r97u3wplj03ayczPDiqhFMa7IZGugoF1QHO/L+X8nLM0cjmeDfh1XOiOPg52MdG32rjrvzHfQ26+a6YW8IfRMbY8MbFaolRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743610254; c=relaxed/simple;
	bh=OIVqJJNsFrMiqu/uq1QlcvPuIL4Ese/KYrI1dezFYZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZGWhC1OsJYeiy7oOk28llBzJnZ7ZkHDZOS1j59iTsfJTG1aqVATR3c8/G7Nf0m0TGNV0PMEkfo4l70gjSumFXVcTG3gkY/RMc4UWP2va5MldWHKwWYO5BwMlanGQ7w2E8/tNz+EmrIFAVPGG4X9RwTOYv91fRXqiZmq2lyvFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PdOe+IRl; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PdOe+IRl"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-227cf12df27so125ad.0;
        Wed, 02 Apr 2025 09:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743610252; x=1744215052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIIr79S8E8NybYY6gtYpu9PlGyNiRm8JHaUp3As1v3w=;
        b=PdOe+IRljOzZiEWsDLjzCg01V4TCzZQLejqRLzKitHTMHKMO9laG/f4MV3YXY3Mm8e
         d94moG71M6WHSginUZxh9/Dtr52QUe/8oCz31O9Gth5VLoS8PxGn1K07tgkQ+q4kwjQ7
         ba7RUM9c7/zHGEQdJ6gTOdCUz3DK5mPEW3Tc6HHTz0kBkxZCULKommk+tDOJy7J9z4bU
         Xkv+5WCnjpdYs457uld2ZXu49Wi7BQvCbNjBJ7ba+fscul8st5zB0yEwZaAxzYqEfLsb
         4v4BveVUdoC7fzdvcz2lOEUYuRHSd0KSu6dX9SmRCKZsMCBIOV238STCZjOtVa/EmFij
         bWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743610252; x=1744215052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIIr79S8E8NybYY6gtYpu9PlGyNiRm8JHaUp3As1v3w=;
        b=wQXztwVRbVyluMk8zKHummeE3Zw7JMTP1qdJ/avF/AKHuZIWLnIpbX3utm8yNx1RBR
         nGj6UbNvHUVK313cY8vwzjc979xQ5G2UUi19NhPM3WBkCEdrpjWHNGMRDaxgHxmQZso3
         /lH0IW7CbJ9FYeqFUeb9wAEg3tsweSoqmW8QPrj16xB2PB3PzPSGMIn645My/lk3NUKr
         BBo/gMFc6FB9cIjCC0K2457pbIDcOba+c1f1YgDJuKvhLW+UCsXtg/N2vTxWf4uiY9rw
         GlLXx7JEXaUnC8bvNKUXJ37GiN6c0ClG4ZwVI/MCP5DrKNCxyxbzPVTK5MrERq6MZwDf
         M6ew==
X-Forwarded-Encrypted: i=1; AJvYcCU2rZSw8fH8z/ukIge3e4NFqX6xm+BotkdMEydbCEqpjEUpkXlnuKMohudf4JhfcpP0y6RSuPcEOPe31PfK@vger.kernel.org, AJvYcCXNnWJMntgc8zQ0y2DD/hiOHub6Ysz2CQj3llqn1CjMwlbknVkXJb7KHWtWOctPbPf++0SN8CUOqSblNnxG7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyP5YCHoUsXuGlL1Nilb3IgiHg0V3CJuq+dUbOPuQYBp4d9yXkE
	A2Iv5GJaScy/TS2XA5L5ltyUiZAxf55IZmc/Vn8L5UXLhkYnu5TK
X-Gm-Gg: ASbGncvfW4kVKuYfSQGNXYXZlJIev5x9vyPxfYLgGe/VofSMl1XoXo2s4EbEzvwqhY0
	mjm2JZMd0S49yPkSP4oM5h/MirmMzTZ8ijqy1QBEBEkZ9dN0PzRYtWPFlOge/U4GuEBFJPioksN
	/33TCiVcWtTbUbWHslABdfsnk+Jam1cIOzkzo3WQSBxsoJpDOXsuzHRdTxBlaMPDnsknHW02aFX
	Jngb1s9gRrvwlYwBAd/ZQtSBGsfCeoUCcjbvhozVTMnlVgNcOXVYAJ6h7EHDwU3MK/49HwoZ0T7
	4HMb65acdKTBvdrJycr92FitfSMb5gUvVSnDKAVqYFopjTOP0rL1lHH1qclVHqFArA==
X-Google-Smtp-Source: AGHT+IE7ktB2KWY480DsrcKFnuDQRmNlfL3ZQiO+dZdrtj8/7tTzLyWkyo/QVitSv9v+OWHDkn89lg==
X-Received: by 2002:a17:903:1b27:b0:223:4d5e:76a6 with SMTP id d9443c01a7336-229765ba827mr1321195ad.1.1743610252117;
        Wed, 02 Apr 2025 09:10:52 -0700 (PDT)
Received: from localhost.localdomain ([14.139.69.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2291f1fa0a5sm110205435ad.240.2025.04.02.09.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 09:10:51 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: don't call sleeping funcs when handling inconsistency errors
Date: Wed,  2 Apr 2025 21:40:40 +0530
Message-ID: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In bch2_bkey_pick_read_device, we're in an RCU lock. So, we can't call
any potentially-sleeping functions. However, we call bch2_dev_rcu,
which calls bch2_fs_inconsistent in its error case. That then calls
bch2_prt_print on a non-atomic printbuf, as well as uses the blocking
variant of bch2_print_string_as_lines, both of which lead to calls to
potentially-sleeping functions, namely krealloc with GFP_KERNEL
and console_lock respectively.

Give a nonzero atomic to the printbuf, and use the nonblocking variant
of bch2_print_string_as_lines.

Reported-by: syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c82cd2906e2f192410bb
Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/error.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index d4dfd13a8076..6f0f2f12c004 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -60,6 +60,8 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 {
 	struct printbuf buf = PRINTBUF;
 
+	buf.atomic++;
+
 	bch2_log_msg_start(c, &buf);
 
 	prt_vprintf(&buf, fmt, args);
@@ -68,7 +70,9 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 	if (trans)
 		bch2_trans_updates_to_text(&buf, trans);
 	bool ret = __bch2_inconsistent_error(c, &buf);
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_string_as_lines_nonblocking(KERN_ERR, buf.buf);
+
+	buf.atomic--;
 
 	printbuf_exit(&buf);
 	return ret;
-- 
2.49.0

