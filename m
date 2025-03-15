Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0488EAD51
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 07:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742024389; cv=none; b=ALWbyGbdk9SbIIEqmvDjqECzeJyepkuVESb9NTDOJW83ds52hiH5WN3eQTdqIKAW3LAhHXt5zPIlVpPRNKX49/aJVZRNtYTgi6VP4di/W/4ArzKcwYHgE8gdHO3nCW4y0lHKVARamE8dbhMV3zM7TCFTuAN3Vua4TsEtT0bpO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742024389; c=relaxed/simple;
	bh=BuNbskW/+h3AcWFeaYJtyBTcw5oxBrN5qnOMmz2Z89s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f60tyzgvnUtRNGbK5hZj+lC8waRJvbICt4aXbtYu4CSnYPvo/1gCNoFZSM+6hKVNjSWYIvCW7AnpJY1h7sqdVB7h+hweLtQ6qeMC0W4Wsi7JeCC9UOvm84pSXpWus5vmvB4dlbIbpaiBFWSGfQmtW7DYrWJwpNz3jjTE1yK7nzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8WpGOHA; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8WpGOHA"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2241053582dso67086975ad.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 00:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742024387; x=1742629187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XnW17qxTWFP32PggvsuDObAaIjPsYTObRV/17eeUpZg=;
        b=j8WpGOHA5pxJwijJc5xugJGo42Zz8gjbvHnJi8ol2rNvLw7z15/JG3TaJN2V7TQsoC
         h2vf2ABIo9FlNnXkU/H7brwDNaTWjHr0sBAkRNwbBbT+dAA8+7TRi8MiWcTgysOKouPu
         Mf/Ar1zR1Wwe5gN3eJX1LJLW7a+2n3y+9HBYYCg3yNFxvw8Wk85rLIgAh0qlaYErjNGU
         D8/00tUTOySJpyuIulhAdGGaKbwXxopjWsTChS0hWo7bueIbZXz4RMLxGh2SH25XzmuQ
         5D8kuAV7m81SA+RUY84AZoL7+xkhssu8dC/nKzPrXkiRmuDcl0uvUt11PppbfchQgc5U
         j+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742024387; x=1742629187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XnW17qxTWFP32PggvsuDObAaIjPsYTObRV/17eeUpZg=;
        b=GS9teA3ptP9TGtYWC/e2VVVNOHjcG7pJ6oEnyKHkrmZx38DN8hP0d1FqNYhyMQc9p7
         p7K8fMEwh6WSk052hQK007yRqpDMpB3pQaV7ZXb7El6XPsE4XP4CRYZXyME7dDIDs+EZ
         LabWFSpwOaM97YLFoZuXsZbqAgz5N9rrkQKklsFKYdMRE5snovCLaFaoAUgS6nRtf/j9
         29SDFanUDzi8HK9T4iDLl02/dj4Q2H82kbj7Puzf/0OKO/xlmuAfZgV0kFsJU+lPVPal
         rWUf+CxOwosamonLeA8bhcNDhTIHF0jHiKP8mKYajXkCzDmN7vGU0tVbH4NtVYaRZgDz
         9jLQ==
X-Gm-Message-State: AOJu0Yw65sGTZjqG80V59i79ASpvJ1rs7wiGwxREFh5I8RDGYwXLg1HR
	Ghcj4YmaJYucRop7unRp3o3ZgSmB2uXN/dvjLf+lHTXTdFQL9iu8
X-Gm-Gg: ASbGncsl3FBbog424hN0JBv3DKoN1MFg/nEYmLrEq7/BMjJoKhN67g/xKk2Q7em92El
	imY6ksxA4hJkbKHuVGmrDJCeH+fxY1MVrEn/PfSMN+j99bL0KXeQHP9EFXndwAL6oDKgD2jKZTC
	kVWfky8pFD7GtOoEK7TuB/3QKiU9DdzIJAymTdrR+fDQnnNYURqVEGme0SwibAvdUj/hvdd4GuY
	Ifi3DuHr9mlCO1tI2sYZIiFpiGM1iLWFgGODAujULnMNt13E9sKCPJ2TKLCh54Lf5kX1s+PFKQv
	6C2RTKJsyWmi7kWToJU=
X-Google-Smtp-Source: AGHT+IHL/ZNlEwyoXPsU+zuE1DzlZTyBoPQ1XOpc8AMmjAS8qFvbmLe6TJO9IsXGjOkObYfs6bjJ/Q==
X-Received: by 2002:a17:903:1d0:b0:21f:6c81:f63 with SMTP id d9443c01a7336-225e0a89e29mr57080005ad.16.1742024387368;
        Sat, 15 Mar 2025 00:39:47 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bd5a61sm39343425ad.250.2025.03.15.00.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 00:39:46 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Increase blacklist range
Date: Sat, 15 Mar 2025 15:39:42 +0800
Message-ID: <20250315073942.1909895-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now there are 16 journal buffers, 8 is too small to be enough.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/recovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 71c786cdb192..a6e26733854d 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 	 * journal sequence numbers:
 	 */
 	if (!c->sb.clean)
-		journal_seq += 8;
+		journal_seq += JOURNAL_BUF_NR * 4;
 
 	if (blacklist_seq != journal_seq) {
 		ret =   bch2_journal_log_msg(c, "blacklisting entries %llu-%llu",
-- 
2.48.1

