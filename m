Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79E6657B3
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536880; cv=none; b=cx/ecVaNXIKqama7PqQRV8YwqgzzXI89fMmUZLKxlwppsotTKUoXd3W1gZVd4glBVcx9rDQgp2CHROYLFtTyOsCz9GgZeRoRtCKu5R86fQvrhMbKESEH8ubi1L9sZDr2V5VY6EDfWJ1lwFtBmfZ7PZlakCyooknr6N+5KIzORT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536880; c=relaxed/simple;
	bh=jsB6Fb4jKChHeHmoRxJBZsDMl8u82PA/P4RbwHxVqdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qxxERIvktH1GbvA4oujgSVbYmcIuYAmXl+3xxn6z3UfuBTQBXAUVil11ym+S03qEZtq4jXB/OBgMhL0VzeGaw2FyZWlRj9DVbt8kiim30OyOihpqSjAGnupzWD0M0k99CirAyyF/WHGGn4oZKWu82HAHKZQOCcRd5aa108qh2IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aHPkzD7Y; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aHPkzD7Y"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d04c0b1cacso11142491fa.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 06:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706536876; x=1707141676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+kk9KCNAFqv/VBIv/yGuF7QaAZ/PCtsVd4gqpBBURvg=;
        b=aHPkzD7Yzp+wRQjBe2muatN69q6MbyZDQ5pxLudBvTuxtX3TDW+mmRmgHECmuxE/+D
         E1X2GSU7601UleAeFm5kz5qtSsWvNA9sWfolnX2yFvpReimZpe4fwIlRn7nxhxIhSF6l
         h5n6dZZ6YuJtVZFsL8GzxBCsPWvj5+iRySyhwcDXPrrcCqp3J+RboJNdzxbcfjB3lUFY
         GF6wCmo6D+pOM4MUcTiexEH16G++a7EhOxLsK3DNU6yGNGB8QUJE7I5abrR0pT6rr4sR
         dmaFdps5D3CJIIFmkuVjAuQcJPaGewXbyf2PJmqDewr/EHI4Bz1UnQx1lShzquvBqGGj
         gY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536876; x=1707141676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+kk9KCNAFqv/VBIv/yGuF7QaAZ/PCtsVd4gqpBBURvg=;
        b=MwOaBmCymdZ799c5M9g/epxAjDJamooiV61RPwPD83gQS+kyATUl2A0gnsYBhSBq2d
         X/pQkY6Anlwzucvooh5iipXuLLSMb0rG/kWBeAVmwFe4I6+3ibgm20pkbZcLfMFSR2nG
         bzhNnhBx3zzGk13wcrKwnUrJA2DdBaAzwMrNzmO4X/Bo7fvrI34tYOQXAITWZDgPCVod
         8dTYfnAJxFyVffiLXMnMqBS5RCUKR29PskblHZqQq5P/gvGle+efDlu6B29i3htXwR8i
         zNkMmkH6OtxZs+8toX/JO58wu3tTYVOulER/K/L6e4/snahrkXpDYDw52Zgh/eimpSC+
         8iDQ==
X-Gm-Message-State: AOJu0YyuEK/gcmzpcRyfGHQn+tvzW8Zem6L0xSuahxkbTt/MuGDgqQnC
	eWuPIRlLOPCigVBRtOC5RRCT4IMHIvj7quNEvJ9G2/KEZyxvmv/OwB78uS0Pa7o=
X-Google-Smtp-Source: AGHT+IGpb9VKxJR1vLHwUv4xKDtNC0nqzxRwZ4Q0lmfM9SMSXAHAFdb4K05OJ+4cgO5QgMRL4r9JWQ==
X-Received: by 2002:a2e:8482:0:b0:2cf:1aa1:beaf with SMTP id b2-20020a2e8482000000b002cf1aa1beafmr4013575ljh.42.1706536875760;
        Mon, 29 Jan 2024 06:01:15 -0800 (PST)
Received: from localhost.localdomain ([43.228.146.200])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090330c300b001d8e2618792sm1871900plc.106.2024.01.29.06.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 06:01:14 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 1/2] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Mon, 29 Jan 2024 22:00:58 +0800
Message-ID: <20240129140101.4259-1-l@damenly.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

mkfs.bcachefs supports force overwrite when option '-f' is given:
$ mkfs.bcachefs --help | grep force
  -f, --force

There are some tests which call _scratch_mkfs multiple times
e.g. tests/generic/171. Without '-f' in MKFS_OPTIONS,
these tests just hang in overwrite confirmation.
After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
we don't have to add '-f' to MKFS_OPTIONS manually to make
these tests pass.

It also fixes generic/466 which unsets MKFS_OPTIONS causing
that test hangs in mfks.bcachefs waiting for confirmation of
the force overwrite.

Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
changelog:
v3:
    Add Brian's Reviewed-by.
v2:
    Add more details about why MKFS_BCACHEFS_PROG should contain '-f'.
    
 common/config |  3 ++-
 common/rc     | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/common/config b/common/config
index c9771ff934cb..1f9edceec57a 100644
--- a/common/config
+++ b/common/config
@@ -105,7 +105,7 @@ set_mkfs_prog_path_with_opts()
 	# Note: mkfs.f2fs doesn't support the --help option yet, but it doesn't
 	# matter since it also prints the help when an invalid option is given.
 	if [ "$p" != "" ] && \
-		$p --help |& grep -q "[[:space:]]-f[[:space:]|]"; then
+		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; then
 		echo "$p -f"
 	else
 		echo $p
@@ -313,6 +313,7 @@ export MKFS_REISER4_PROG=$(type -P mkfs.reiser4)
 export E2FSCK_PROG=$(type -P e2fsck)
 export TUNE2FS_PROG=$(type -P tune2fs)
 export FSCK_OVERLAY_PROG=$(type -P fsck.overlay)
+export MKFS_BCACHEFS_PROG=$(set_mkfs_prog_path_with_opts bcachefs)
 
 # SELinux adds extra xattrs which can mess up our expected output.
 # So, mount with a context, and they won't be created.
diff --git a/common/rc b/common/rc
index 524ffa02aa6a..31c21d2a8360 100644
--- a/common/rc
+++ b/common/rc
@@ -611,6 +611,9 @@ _test_mkfs()
     xfs)
 	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
 	;;
+    bcachefs)
+    $MKFS_BCACHEFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
+	;;
     *)
 	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $TEST_DEV
 	;;
@@ -753,6 +756,10 @@ _scratch_mkfs()
 		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
 		mkfs_filter="grep -v -e ^mkfs\.ocfs2"
 		;;
+    bcachefs)
+		mkfs_cmd="$MKFS_BCACHEFS_PROG"
+		mkfs_filter="cat"
+		;;
 	*)
 		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
 		mkfs_filter="cat"
@@ -1044,7 +1051,7 @@ _scratch_mkfs_sized()
 		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
 		;;
 	bcachefs)
-		$MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
+		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
 		;;
 	*)
 		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
@@ -1128,8 +1135,7 @@ _scratch_mkfs_blocksized()
 						-C $blocksize $SCRATCH_DEV
 		;;
 	bcachefs)
-		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS --block_size=$blocksize \
-								$SCRATCH_DEV
+		_scratch_mkfs --block_size=$blocksize
 		;;
 	udf)
 		_scratch_mkfs -b $blocksize
-- 
2.43.0

