Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68970C14F;
	Thu, 30 May 2024 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717092212; cv=none; b=UHU6SX8Ww2OaGWAVsWQuJq3ZrPfZEf0slBsHDQt9VwbMENAPE5evdLVqy8avxzuaqxD97Gz9aPONhGZpb29dJHtl0j6rCNvTmEwByrmCYEYRXlNfUtShc6z3ijeJDAck6magrgR6dGXVga9wSA2hONe02opP9o4sU93pSk3dyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717092212; c=relaxed/simple;
	bh=dYwoWT7q/wUT+guv6j7Ne6TG9RdQSAxhGeQm3X860/s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XySed8yKBq/2EZisRgB3xDUlMT7gjQnfmr1BveRCdzCvSN07xweJ1MOtTond0bDlkrq/4i/AcUKTh8f5pJBzZMolwZeE2A0e8zfpRecv4iyyMBsG7SAgZT7WH3/5NFvd3vL9ETRA/Cf8DFSsaivwPLFAyzKEPIcorwdrxJJPG8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/Qh+m0+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/Qh+m0+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-421208c97a2so11760595e9.1;
        Thu, 30 May 2024 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717092208; x=1717697008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XTWVCt6/XCS0l83oDcJrI/j9rDkuJpx2ei84/kCHYNc=;
        b=K/Qh+m0+qTCuYefk2CNrjVooqQZc3dJK2OlLpGYOhga9k7G6AdFB+fj68kbYwng0uu
         0bp4+uN24vRfd+LieLklFmAbTLHtkZyECiD0CYTXl4FlCoRqJQfbgk3uMN2XBQ8ronXW
         6WwM7IEZcyULy0mFkgEgq30emjz51BljpPJ/2hMl3Sf4UmXhN5mGLWJ/X8tz4Fc5oA7q
         z+v0ftDT88e4pJsV2bLfIGTJJdPkMPak/nTQIxQwGcUkutVJWe/4sDbeVly9NxiM9NDd
         z039POwYN9ZE5b5yYMSzPhMCq4feCCskksPDuMJczBf4ajk5ZmkXzQkqk2hROhzOWYi3
         JXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717092208; x=1717697008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XTWVCt6/XCS0l83oDcJrI/j9rDkuJpx2ei84/kCHYNc=;
        b=okspOFWdHfotDE6HBSOH+0zBPB7Sa1POuPu37cr/t+6lHe4P6gLPtW8N+oxrqJ68Oo
         1xIgJDtpQlTciFoSB+MSz0Atj5WgHvrPDVGaV1Ma3hTnIQEi02IsOj46aPEFZg5C9tO8
         bG2VBfKIEkfHaRGNScZJURMqJLbEfYNBRELUJWH90fjI8gahdYEahbCobw+Vh83wCKZl
         8NU55gXKscT/3PZ8uJ+lR7pe58PlOKSqNsMqpCmiJFS2uSOHpUYnitvQNsMKXuObt570
         PwvVRV3qy+XUDRz7Tmq/jc/aZHVrQcGxFEOoWHfE3acewtsEWRwK/ScvxSTcuuReg7r4
         CtRg==
X-Forwarded-Encrypted: i=1; AJvYcCVwmeZA+X6O5wyTNjIGc4Mir9Mahr+SVObAWSYvFMrCA9195pT8P3oa+w3xEFgE4/JC2W+spgUhSLJCvUMTexiGYN7o6vbRPzYYo27Q
X-Gm-Message-State: AOJu0YzKzaixwiHYHz6rUARWhgb7J/9Ybe7tziRl08ZG4xrobmXx6YdU
	R0qK0Q6yJ9AbWa8qwyRrpiFMaQb/MAdEMQOyHWY3gCP+UuOy0ewyIjsisRo+
X-Google-Smtp-Source: AGHT+IHRIt9JLA7u5E8hxE19vRUERc8ZUHNnT5bd8joCzqk+J3dW0AZAxQwijT1N6qJNT6vb5C0dTA==
X-Received: by 2002:a05:600c:1c84:b0:41f:d662:65f6 with SMTP id 5b1f17b1804b1-42127e3c03cmr27306665e9.3.1717092208315;
        Thu, 30 May 2024 11:03:28 -0700 (PDT)
Received: from localhost ([2a02:2f0e:516:6100:11c:5ba6:7b12:5dbc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212b8b5747sm1630865e9.45.2024.05.30.11.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 11:03:27 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: bch2_dir_emit() - fix directory reads in the fuse driver
Date: Thu, 30 May 2024 21:03:12 +0300
Message-Id: <20240530180312.921308-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 0c0cbfdb84725e9933a24ecf47c61bdeeda06ba2 dropped the ctx->pos
update before the call to dir_emit. This breaks the userspace
implementation, causing the directory reads to be stuck in an infinite
loop. This doesn't happen in the kernel because the vfs handles the
updates to ctx->pos, but in the fuse implementation nobody updates
it.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 fs/bcachefs/dirent.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index c67460d8205d..f1d5ee19e5ea 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -534,6 +534,7 @@ int bch2_empty_dir_trans(struct btree_trans *trans, subvol_inum dir)
 static int bch2_dir_emit(struct dir_context *ctx, struct bkey_s_c_dirent d, subvol_inum target)
 {
 	struct qstr name = bch2_dirent_get_name(d);
+	ctx->pos = d.k->p.offset;
 	bool ret = dir_emit(ctx, name.name,
 		      name.len,
 		      target.inum,
-- 
2.34.1

