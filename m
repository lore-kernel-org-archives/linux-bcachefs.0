Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A9524CC
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706572292; cv=none; b=q0cCUpt1JGDZ3gRL+hfcT7uX2NZnk0aJAKbWLSlsT2eZ8g9ko2rJ6py1VjlEBAPnLokJ1ipxqu/Mc66Ch0AMvOXgBn02YKpYRWk4FifH5OcZspx9UFWTPSqR7xgbzoGqiug+wKJNtso/J5Sef6yQoZ9e9ayFQopvbNVDiNwBB3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706572292; c=relaxed/simple;
	bh=UAmv95obHpeljHLYSpHoc6MpMzuUXb9jBy4NPRlclGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eJYIPBny95ZZXnI2mbEbMuQlO8XgPj2ljdhOGky+j7LF0/MPrqSMiO4oprK6g/qK4Y31YPOSKLS5Pr+Iq7mK0i5qNFY0ado6p2DFQrV5qZJQ6Cy/1ep/OZXVtEDB9et7OH8QnrlZ1HcXjGnrvqxfyjByxFzUBRv1GH020Diy9OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G5CLwVx4; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G5CLwVx4"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d043160cd1so21172461fa.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 15:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706572287; x=1707177087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qPF03DMZrpEk+A2boueXts4iBVUFr9a1IQP1C3/+w5Q=;
        b=G5CLwVx41QKabTbUx5NJVdZjx5TBjUdLQt+lINVeWPzi4hLMf6Zo/0U4oXLo1L4a8M
         u/BuMHFCUn7d7Z/RXlCJEx0B80Kc0xfpV9PsdmdfiCb6UPFVGcdiL4iMLcgwEhIKu9PX
         lgna7Gkt7eCyeJtH89d1oB6lWMxGN44dSz5L1b9gOziOI9s7BNtpftO1DWQasL3rORHR
         H8o0IwIwD5bfMkZZD0BasvtnC5yiQXH7dn3JJzxMzOfZrGfYFB6sMyUMBQMTWzz1Yp2f
         lkFUkphRO4xvdHgUX+OZ21KTid/b0zLctNFzny8qYiS0XLSNfYzPGlTcd2GQU1dp2xRO
         SAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706572287; x=1707177087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qPF03DMZrpEk+A2boueXts4iBVUFr9a1IQP1C3/+w5Q=;
        b=EkbozgEYnJqTkppjk5BtIi5TutTcG4V8dE8PpXzELPxup/cPueDC1W/0jCEHP1DsSx
         B3D4fmWJH0jVzTI1A1no+mFSlLuDvj2HNK+iaR/DemkOM/oi2O5p9AvK8OioUpE91HW1
         sALgRBNz8qbqvFEf8T9YJMZhVE4Ox5QIJyXfNAsDotWdMt8ARbiv7Q772+1iZkVrM1fL
         wrko29UO18o7VPeGrtVMzMJg/fVr931vL3cKHDNZKUh1oD8cLF1NPvNLUucax8e0ViEg
         L1G7tw0LYKuVwZ57W1lkaNl3P0xHgWJyfnTpjrBi53Fli5yd+f4AIQ1BMZ3HRbtXfH45
         qlVQ==
X-Gm-Message-State: AOJu0YzrtBpeIZyGYhC97//oXFf5SDHAGiJg7SvfLxIYqVb/NpUjhgiD
	V0GZnvJiLCqZoJmsQNuKoumJU3DUpXOSWjtfxkI7tgekduFJfsq8mngiyY3jfbw=
X-Google-Smtp-Source: AGHT+IGbBCWDH0aKd/gv8c6qcpv8SikUTBsEg/d3GiuUeQMe5vbA+yfGtKiAO36usD9RRvZnPhulxQ==
X-Received: by 2002:a2e:a378:0:b0:2cc:d4ae:c2ce with SMTP id i24-20020a2ea378000000b002ccd4aec2cemr4275692ljn.38.1706572287363;
        Mon, 29 Jan 2024 15:51:27 -0800 (PST)
Received: from localhost.localdomain ([195.245.241.170])
        by smtp.gmail.com with ESMTPSA id p16-20020a63e650000000b005d553239b16sm6647461pgj.20.2024.01.29.15.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 15:51:26 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v4 1/2] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Tue, 30 Jan 2024 07:51:03 +0800
Message-ID: <20240129235104.8976-1-l@damenly.org>
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
v4:
    No change.
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

