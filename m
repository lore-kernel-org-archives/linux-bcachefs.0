Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9687E
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jan 2024 04:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZuqLTdoz"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cd1ca52f31so89083911fa.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 13 Jan 2024 20:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705207294; x=1705812094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6U2f+w2O9S+yoYqv+rungy5KCSJbcHIyBEOzRka1yyY=;
        b=ZuqLTdozkPvVgIa52QprobGhxuJgu8FYfFts7L7Qqu7oKBKIVKKJGy5UDWhUkWzfq6
         ZSPdVLhRM+iNozRnQhMJ5BEVknq22OHT9FsLWf/H90DRA3Qs0sfMl7or3k8WifBokDMm
         OiUhfMs2vfojaubR8O34YVPLc2cLGGh63jTmKqt+Ql1pC4fxUm7ialEsm0p2GOySxScG
         3kXGFND+zmSK8HgyMSLMDfvJPp0zANAQ4ulhs5S12Qe0pn0sKmOugbVJSZDxO+RDfRvv
         xGqVvyluqNfTAK45oHtICjaSOwHWSxyaSihCO9YgTga9RjQGlQu56sDTS+Ik8j1g5vbb
         HVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705207294; x=1705812094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6U2f+w2O9S+yoYqv+rungy5KCSJbcHIyBEOzRka1yyY=;
        b=hAW7o6ZhWBDQbStqLMH/wP4DLRAQYK7y/b3+hZp7iPmSLN1V3eFx0U9wVeduopdzD6
         RTln0iNf3MGYAPO0ulyEFMd+EAcTHKRZNow0pDkxMm5tLbucqqe2WOsLbymRHo/8zsAF
         xowKst1+W7n0aw7zstce/NwYZB0AwG9wTabuH7EHQy6ON9crR2t5CHTma3hfxCoX+8fD
         JRh445S19kFJ7V4SmPXFtPgSNnSpvwWrPg62FV+h8uTk/ju85IDSmyxDwrvM6yJDp774
         V4/zRmcG/E79BE5ZyMSUKtfpFaYTn9uzHqOrzvEJhwMg5Zwe2hAvSZpWDQK2ABNuJE2t
         wYLQ==
X-Gm-Message-State: AOJu0YxFDV8RIMS0b9Um0FtDXlPC2rwTaTiQBkz62fRDNWh0i8zfjhmI
	D42mxjf8tBVv5D6H0g/Uo3HzLGNRfv57Kg==
X-Google-Smtp-Source: AGHT+IHln/RL+qs32IcJayDhWnRtC6Qito8UvNhpg5LasgQ1ncf/7R0sEPRVTQdccdYlkMVXkhY07w==
X-Received: by 2002:a2e:5c44:0:b0:2cd:1d6e:74c9 with SMTP id q65-20020a2e5c44000000b002cd1d6e74c9mr1517874ljb.48.1705207293777;
        Sat, 13 Jan 2024 20:41:33 -0800 (PST)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id eu15-20020a17090af94f00b0028b845f2890sm9330832pjb.33.2024.01.13.20.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jan 2024 20:41:33 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Sun, 14 Jan 2024 12:41:20 +0800
Message-ID: <20240114044120.140111-1-glass.su@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mkfs.bcachefs supports force overwrite when option '-f' is given:
$ mkfs.bcachefs --help | grep force
  -f, --force
After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
we don't have to add '-f' to $MKFS_OPTIONS manually.

It also fixes generic/466 which unsets MKFS_OPTIONS causing
that test hangs in mfks.bcachefs waiting for confirmation of
the force overwrite.

Signed-off-by: Su Yue <glass.su@suse.com>
---
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
index cc92fe0681d6..f2e900bf1166 100644
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

