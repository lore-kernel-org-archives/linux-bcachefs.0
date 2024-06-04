Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300331411FD
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 07:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717487026; cv=none; b=rvAsx/DL4Ij+m2Xxh4jyjVrTr8av++j5BhNKPwGLBIFORqouRXQgD0Ca7lvJ8TuZ2rnLUz3HGa1oML4H/UBnmvud6YWVepEkLQ1pJqCtZefK9Ye6o5n0Y7Jf+7ENOcEUlfF4CtKsSG+7KJ+vNJ4FdvIXidvFt6c6smbtFKpHu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717487026; c=relaxed/simple;
	bh=zHgs/oU7yLu3yXtYUvACaUWOIcpQP5jdAiU1J9VFNvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=liQXYXNDsVA0wcDwYjLx+yhuKjbo9caXIEO3bG5t+HmKxyqLc85/9y2Lgj4YIxYYz5qqYWkI3mNicc2OzBoFeubmQk3fu3uBXxsxRPicvJKFu+enuz+AVJ9PJxvftjJPfy/y2CrK2dLCwHYzpJpy0BSfJvbIhJVSIzmXB7XOXN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WDEGEBsz; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WDEGEBsz"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6266ffdba8so67998266b.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Jun 2024 00:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717487023; x=1718091823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zlZ3iSGUtS3y+wx9fVpXuIl0CwitrmUXqAXXOexK3GU=;
        b=WDEGEBsz3y3y41P/Oi6D//ub/hmL5jpCo2aLOatHshdnN7H+EhBqzVCalMANbEjDby
         CEC8FTEqfBG3qvf6NHsYi2U1S44MwWeyzuRl0L0FWhoP0Cl4FH+d0vSr9ZS13gcXuuG3
         6yBnvnGrJVS9Dhf3SzQuxobZCkClak51uQdP64L5o1XURv8XEhvOknanDPQjxW8aZ9ia
         I+Qi6RA1TwZTmsWkaWT0BvODCxTY7FnWb7DwYhyjreWQXUS0O4wrxK6590uJjsvv/kB7
         4aYJaTewyGXOGDtQLPuYIwrzqLrYMAi5Vcabn8M9C1dV4dApHu+oziGCqYCp3oADEtCo
         CRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717487023; x=1718091823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zlZ3iSGUtS3y+wx9fVpXuIl0CwitrmUXqAXXOexK3GU=;
        b=AU/6H+gh1j31W6CdHVGjqdQHWwjyXTlSJVzNyHkjhm+gLRBUM9ZxtmALCltTNRTC+A
         MgC9xvoTOptKE0qEIw/lEM+M/jqQKLOIoosqRGcFrhXMHw0rrynWH5KMPPhE+0RnEba8
         T0LA9kOKtZ9Ou0jgBZ8d+OurOqpXZrTxSWd/BUgVfZb08jjiPKoB0RLngqOJD0nwmdwo
         bYEsYSsyRpPvhUOGYnByIQA6rc9gDdkcCOLix2UETAOfAUn2rfLvgB2Ao17Pwy+b6xEJ
         tPfhXvIZ83wLTSaewW6zyp+pBGyRTEjF4ZIN3SwZsnnqUB3E0QWFJP2NBacWaV8yPc1f
         QsGA==
X-Gm-Message-State: AOJu0YxYtqaPtFy/KFVTO0aWHXHaCBmCkKxnoDdOKuhAVD+qPfO3srdv
	4q4pufkdWrDWAZXdTAOlLJcFLtCPltJnYJFmodlCYmyI6brgsGHoQSDiJpOd
X-Google-Smtp-Source: AGHT+IHAHY12JalcG/yAWvpQdVMs4kCk7/deIh8k3EAhMP3i6mbszBAItoTO/LM28AbwhpKOaybeIA==
X-Received: by 2002:a17:907:984d:b0:a68:c7dc:baec with SMTP id a640c23a62f3a-a68c7dcc258mr471554266b.39.1717487022904;
        Tue, 04 Jun 2024 00:43:42 -0700 (PDT)
Received: from localhost ([109.166.137.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68e2d1333fsm381245066b.219.2024.06.04.00.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 00:43:42 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH 4/4] Preserve directory {a,m,c} times by calling copy_times() after the recursion
Date: Tue,  4 Jun 2024 10:43:25 +0300
Message-Id: <20240604074325.798349-4-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240604074325.798349-1-ariel.miculas@gmail.com>
References: <20240604074325.798349-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise the directory {a,m,c} times will be modified by the recursive
copy of the directory tree.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index 52105be1..d4899605 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -360,7 +360,6 @@ static void copy_dir(struct copy_fs_state *s,
 		if (dst_inum)
 			*dst_inum = inode.bi_inum;
 
-		copy_times(c, &inode, &stat);
 		copy_xattrs(c, &inode, d->d_name);
 
 		/* copy xattrs */
@@ -395,6 +394,7 @@ static void copy_dir(struct copy_fs_state *s,
 			BUG();
 		}
 
+		copy_times(c, &inode, &stat);
 		update_inode(c, &inode);
 next:
 		free(child_path);
-- 
2.34.1

