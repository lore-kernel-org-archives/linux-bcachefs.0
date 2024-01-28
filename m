Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16751DDA5
	for <linux-bcachefs@vger.kernel.org>; Sun, 28 Jan 2024 08:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706431595; cv=none; b=RFw6XtZmo0aKBDD+ATVOf/2rj9iaNg3u1cSRPuW7OreIs7U9fddukNhP/YNY7N5KoJ9Yk/HG1I5Z7LVQLxp4K0j/2/oNW84YqQrZY6ZzSk+oDam/JafpQBAb0ayyz75vVGiNVKVmjBB/3HBcVvwvLwSlDzLYpmHEgy9Zpj+9piA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706431595; c=relaxed/simple;
	bh=sWcA4vq4dELgnmpuck9GmvRQbLoyCozWTOdtI6rbXDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NyRzhaqUwvrxFIna7eAwp5y9S3+jYIoYdZ1vh7R1eIhiRItsQLL61k9H6mHSbntrTuc4VdqXoZpT3RcHVXtcqxQ5xQXXPaeHBfopzXMHMwB2wCyXwxiyhH6khkajBaoEwEMxt35xTdCNG/thS4zd297VVWpCfwlGdeJ5RzJHVl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LbSBRvTg; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LbSBRvTg"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6dc20b4595bso1745400a34.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 28 Jan 2024 00:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706431593; x=1707036393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aML3G8USSFyMNcBLGlckX4g/sSCdHko1ADe8d06KmNI=;
        b=LbSBRvTgQ5Qunv0Rl4rU6D+N+5HuGdbcuFIwoJ3/6VZkM2pZ9tKtvV+FB++UvJ6bK1
         9VcoP+pRq9qX9oRXXP0Bjp4upHfZQE8+ZJqg9hg9OiPK1C6moWsDIogCf7XIiSZjuDZw
         9D8QgU847gIj8uyvoAeVylq/J+Qec2NQn4shgLxpRAO3UVzULjGnnbnjhV4/j9ukZ+lT
         LZQX7A4crMF1bpb4XiRn0lg5TiNwaOMzoXlw4TWa/TPE1Kyu+rUHfnJL/2hbA/NU/kGI
         LK1Yz+UCb80LbG1cP7QGx8FmkFzYqNeIdUyWRUQrkeUG/TLOpOiRgxho0khj/AqcP7l/
         b4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706431593; x=1707036393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aML3G8USSFyMNcBLGlckX4g/sSCdHko1ADe8d06KmNI=;
        b=mOdb3P8TC+mPnkSi7cdqhvnjEghTJjOj4dRRairwDrhXUcljKD9DosCtXskwB8bwnh
         +O2ohiyMSKfo0LKlP90b3aKCISqNgIzi9IsLlhBBh1Du+xB0+n3OrefdwRHJc+lJGFmi
         DkQhsbtuXHFi593dOES7aLCTqZ6ECMh+SeVNnMWJnVPWOT/0y6oKMOM9RW0hhWft13OG
         qgV9JzYDQcossXJ8dalHhI5eTIRen0gXBa+aDV+iIrfiBavT6JxdempRSplEkl2Kj1Mc
         9OZGJFdJa6NGCzGwNeNrXwkrN3SvQN9Us6fzoq1gjPfPg3pyX8VRc818R6QBwKOcruBf
         gw6g==
X-Gm-Message-State: AOJu0YzQeYdRwHSSD3O9sGBZHCg+x1HHb33CPFakfJwfD3ndoe9bzf76
	UwfFRs1MYVfoGj7Y0FnWRBgRQ762JBFatNL0hGoZ2MsVoQtODvhI
X-Google-Smtp-Source: AGHT+IESXdl/cCecZpSJ2JpIAuBfFTf8JeYoBxDjTjHhwXYAn+sCBvPo5rxaDfAZJw/pYTcN4/BLug==
X-Received: by 2002:a05:6358:e919:b0:176:485a:5df5 with SMTP id gk25-20020a056358e91900b00176485a5df5mr2830420rwb.39.1706431592873;
        Sun, 28 Jan 2024 00:46:32 -0800 (PST)
Received: from localhost ([163.125.244.247])
        by smtp.gmail.com with ESMTPSA id mm11-20020a1709030a0b00b001d8b3c8c758sm2010136plb.66.2024.01.28.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jan 2024 00:46:32 -0800 (PST)
From: Guoyu Ou <benogy@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Guoyu Ou <benogy@gmail.com>
Subject: [PATCH] bcachefs: unlock parent dir if entry is not found in subvolume deletion
Date: Sun, 28 Jan 2024 16:46:17 +0800
Message-ID: <20240128084617.244234-1-benogy@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Parent dir is locked by user_path_locked_at() before validating the
required dentry. It should be unlocked if we can not perform the
deletion.

This fixes the problem:

$ bcachefs subvolume delete not-exist-entry
BCH_IOCTL_SUBVOLUME_DESTROY ioctl error: No such file or directory
$ bcachefs subvolume delete not-exist-entry

the second will stuck because the parent dir is locked in the previous
deletion.

Signed-off-by: Guoyu Ou <benogy@gmail.com>
---
 fs/bcachefs/fs-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 3a4c24c28e7f..3dc8630ff9fe 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -455,6 +455,7 @@ static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
 	if (IS_ERR(victim))
 		return PTR_ERR(victim);
 
+	dir = d_inode(path.dentry);
 	if (victim->d_sb->s_fs_info != c) {
 		ret = -EXDEV;
 		goto err;
@@ -463,14 +464,13 @@ static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
 		ret = -ENOENT;
 		goto err;
 	}
-	dir = d_inode(path.dentry);
 	ret = __bch2_unlink(dir, victim, true);
 	if (!ret) {
 		fsnotify_rmdir(dir, victim);
 		d_delete(victim);
 	}
-	inode_unlock(dir);
 err:
+	inode_unlock(dir);
 	dput(victim);
 	path_put(&path);
 	return ret;
-- 
2.43.0

