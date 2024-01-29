Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88276657D0
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536884; cv=none; b=p0tB4pTuV+xYX70P3dHhyc3LIq/mB2NEAygwzUsGW8FSW9n23vV0SrN20uAKs9vCKsZFkfcCoEmCsEBPKkxAJGzYY39ptuUxS8HoxfQCO6jrz0BhJgfYLMSZY4fUCbvgCbsRBIAzXjT/0Akw8miFTAJ69TA1dsY/BthpjFsiOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536884; c=relaxed/simple;
	bh=jsB6Fb4jKChHeHmoRxJBZsDMl8u82PA/P4RbwHxVqdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq1ntub3Bp+uDk1GKQcTmt5dt5TbkPUH4w8HpdX1nIlpLMKU1dUmekDGrnTANKogo37KWeHsuOnANdFLcY/CyCqsrdcs5wP7qVGfuykIQ6qPYOVJj8CmvDnYGojeREYpZFyKlqvOAOS1m9i4NjBVuEmchgatFbZsCNPkjAowvBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RcNOr4IP; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RcNOr4IP"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a358ec50b7cso211676766b.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 06:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706536881; x=1707141681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kk9KCNAFqv/VBIv/yGuF7QaAZ/PCtsVd4gqpBBURvg=;
        b=RcNOr4IPnQIDw8RCDnOvnZbpxMtA6QxMW2s/NvRRCEz2URX1vmLJ/g2AngsCUnNtln
         LcRPTDEXUjOq7uOAfhvoEpV/Zm2fKIu2G6EXKW4eR13nfXfZ1ZuDlYa1UmdxxyKoXWqX
         iNTweLPlLlMuJZDUx4I2rTeT4N4nNcSZiyvZMgyPMxgn7s1egZ7cFQvWcsVxrOB/NaXv
         q8P5oPoT5VPtaECkb2SjJLGSigLtzIXg0cuZiWbVkFkV5TrRkCDvP7068I30xdujMoqm
         ByWC/EhNYqSVFMJiIZ+sInBlX0zScH0v5EBVpOUZ8Hx72MF8I4410Eey+Y6FITybVRje
         4KeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536881; x=1707141681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kk9KCNAFqv/VBIv/yGuF7QaAZ/PCtsVd4gqpBBURvg=;
        b=M8b2x76OzwIDn4PZuQJcU8iwKdeOnUGDYmKZ8+R4lb8WqsCJZexKKA48YX0A5QgjeH
         gJnd/8MovJ4DKvsdvC1Vylru0FcoIe5mHgzSdlflwa3bbX7lq9HLyQ/LhukBz2baU2M4
         MrhSE3Aqgy3XmaBDmRzAV/TS6GWdUUWGi7QVkPx0/5EAfauXlMx5xFo5QHj85BZlEXaG
         2dmqrb5wTa3BDZMDpXKKiT49WydbGpuGzH8MH/87l01yaMBayggsst7xxsONHNcKfyBd
         LxH1CRcSN16FU228nqcDISilwjqLqmeV0l4jDUK9glhVslQmxxmaJtdt1B8N/oP34BK2
         ua7A==
X-Gm-Message-State: AOJu0Ywh4RH5qtTCJUI22BtvA0t8z1qJW7JJ6eK134kvoLEGCHAY35mt
	3JVeZayzMeT4GJz2HEzA3hb600Gg5cazACWGGjodGQX+Ahizu5r5NMx+VX4IGig=
X-Google-Smtp-Source: AGHT+IHjgAtkMRR57/njGjBDoByvWHzODBtr8DDofU6gHsfH8dkhVMaFuGJXRktAwisZXPjeJ7NQtg==
X-Received: by 2002:a17:906:e0cb:b0:a35:f7f4:7c44 with SMTP id gl11-20020a170906e0cb00b00a35f7f47c44mr506226ejb.15.1706536880672;
        Mon, 29 Jan 2024 06:01:20 -0800 (PST)
Received: from localhost.localdomain ([43.228.146.200])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090330c300b001d8e2618792sm1871900plc.106.2024.01.29.06.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 06:01:19 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 1/2] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Mon, 29 Jan 2024 22:01:00 +0800
Message-ID: <20240129140101.4259-3-l@damenly.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129140101.4259-1-l@damenly.org>
References: <20240129140101.4259-1-l@damenly.org>
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

