Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894F524B1
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 23:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706572295; cv=none; b=P0xAVifxJtl81jc7RQyhhZVnaPbUak7KSNMtVc0GWac8pINjHF0XCJQ1NnapjQ1NtCRFn1yQh2gYsmYE7DMcU7jmzV4eN0nmFqMWf4IYSmLkDAtT2Dw4Ak2jt25cezRwTFf2XhLzQqjdgcwWYT4792/JTL9IVQS+QQb8wO81Ps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706572295; c=relaxed/simple;
	bh=SU0CqfslUXtACWTN3IMUkZ0xB47POlH2DFf5arjPCoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB1b4fGRvj1ZXY7T21+d1PHGDBvZ+J3ru58Cdf2MX6gwOjd8EdJHDAsRQs4j19wUvpa8ZOINOfvYy7I3s/LhroAp3TmlFTb8QgNICyPPdjdqpzzAg+iV63Nelol73HAaziPeKfGIjHLGJttEjWH9AApKSlHZvS8G9d3+ayecTCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LWm5G1QE; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LWm5G1QE"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-55f19a3ca7aso1768369a12.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 15:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706572291; x=1707177091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5m1vjwxT4TQE5HTtWJoDUz6KmsauuZH42eQOOd5rJq4=;
        b=LWm5G1QExEFVP9+LU/XUcL8+gECt9iq4CTnAv1yzVk4y58ZvqMe469UkAw4pgzag8g
         Q5ZIf8WIyXvHfihgNwE4u5pFEg5XExFwanP6wFefRpASz/BMfKKkp4XzE7e26YgVzgkA
         tYx6YxsBvoseMaL6BKzAaQBITFXiayg7dbxG2VDOKC0jzMzuxUafSH/GdtSnfzMoaYM5
         jRnTW0/DEPLrqx2c2dryqTSf+AOJRV86CuxsmdfOJJTewzZeirB0yRpOToojbKYNLfUQ
         Qlci7ghElKMeCUzZaHqIy8tFj5se00lmLmYsdksimnG3x6jqjpuXHd0vWro2DFFyPKSu
         yerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706572291; x=1707177091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m1vjwxT4TQE5HTtWJoDUz6KmsauuZH42eQOOd5rJq4=;
        b=qP8R8rqi4eJk/ZG0iR9YCm2y+iG9gUGP+rUgoKzu7LzT89ku5bgosILulsnbBNPiGM
         JTyUod5QrrlGduZ60BEVVaE+6zVoLgIqp4lWIMGsXOZkZrq9bcAxD1olvG0jAGKLmbzW
         RMunKpMy47poLR1FaSX1507lrzk0NUHba2RpzfzUdEXYfvhMQi5VkUFOk5p3BWu8QbZg
         Umml3Q3tU8Qtf9hu0S8hnJg79kJYtNR+Fw+OpHDW46aGwPPwcYmMV/7EHjAQFOAC5ORy
         wn+iLBTfjwEtqvn7Q39rqxCwS2Tor5L5H1BePlkXz/G/FcTDGftbzRJv0lcRGlP1SMkR
         TAWA==
X-Gm-Message-State: AOJu0YzzelfydH73W0dtX0QT3AW1AvEYwRQiUw8b5iGsEYg7k5fWv95s
	FmiWmEuZdUBVqJNZGoMdLeVrCc5jwzbsdr6r2Ua1rP+s9Fhd0E5wi9vHnzsDIOk=
X-Google-Smtp-Source: AGHT+IEnYXhyyuKsC/0NSkZCtoKUFfXBjKBPQuSgAYvITeucwFqYdJ0cIN+o7BBGP3LzL1cLSZ/JbQ==
X-Received: by 2002:a17:907:8e8b:b0:a31:8c73:f42d with SMTP id tx11-20020a1709078e8b00b00a318c73f42dmr72167ejc.28.1706572290857;
        Mon, 29 Jan 2024 15:51:30 -0800 (PST)
Received: from localhost.localdomain ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id p16-20020a63e650000000b005d553239b16sm6647461pgj.20.2024.01.29.15.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 15:51:30 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v4 2/2] common/rc: improve block_size support for bcachefs
Date: Tue, 30 Jan 2024 07:51:04 +0800
Message-ID: <20240129235104.8976-2-l@damenly.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129235104.8976-1-l@damenly.org>
References: <20240129235104.8976-1-l@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

mkfs.bcachefs now supports option '--block_size' to allow
custom block_size.

Add the pattern to set def_blksz if MKFS_OPTIONS contains the
option in _scratch_mkfs_sized.
Also let mkfs.bcachefs decide blocksize if no option is given in
MKFS_OPTIONS or _scratch_mkfs_sized parameter.

Signed-off-by: Su Yue <glass.su@suse.com>
---
changelog:
v4:
    Respect block_size in MKFS_OPTIONS. 
v3:
    Add logic to Let mkfs.bcachefs decide blocksize if no option is given in
    local.config or _scratch_mkfs_sized parameter.
v2:
    Born.
---
 common/rc | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 31c21d2a8360..315a2413f963 100644
--- a/common/rc
+++ b/common/rc
@@ -930,6 +930,7 @@ _scratch_mkfs_sized()
 	local fssize=$1
 	local blocksize=$2
 	local def_blksz
+	local blocksize_opt
 
 	case $FSTYP in
 	xfs)
@@ -950,6 +951,13 @@ _scratch_mkfs_sized()
 	jfs)
 		def_blksz=4096
 		;;
+	bcachefs)
+		def_blksz=`echo $MKFS_OPTIONS | sed -rn 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
+		[ -n "$blocksize" ] && blocksize_opt="--block_size=$blocksize"
+		[ -n "$def_blksize" ] && blocksize_opt="--block_size=$def_blksize"
+		# If no block size is given by local.confg or parameter, blocksize_opt is empty.
+		# Let MKFS_BCACHEFS_PROG decide block size on its own.
+		;;
 	esac
 
 	[ -n "$def_blksz" ] && blocksize=$def_blksz
@@ -1051,7 +1059,7 @@ _scratch_mkfs_sized()
 		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
 		;;
 	bcachefs)
-		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
+		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
 		;;
 	*)
 		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
-- 
2.43.0

