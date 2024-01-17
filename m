Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90E14270
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 09:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705483408; cv=none; b=hmCJjwluBglNula2lRS5Ia6yWsOtd7hrlo4VazjuCuQq0l/nWTpuO26v/fvIXedvhuMzQm/GttWTwm/llKE7PGqzaCPP/FpxzgKeEzS6OWxFtnWWCmdJxhe595Jp3YxvwgECFP0xEggVO/PpXj9SBEufRdGQJt+NqwOlomcDs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705483408; c=relaxed/simple;
	bh=ZAC0gMTewDsyDKK+KtO6CsLORbCsrw14QrlNvQDIlg8=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=nXT9VUNmtIlyYcdRiOIqRPHK3xVKhGdnnJGO40B76IK7jTJiRD4BlMrev2T9mHxJVKvwFYqsdAGw+QVcEHzGkAya2ffcJ6WdHkiT+WptDGJVpCASugS0q8sxa+m7SJ3rGM7MjRrundb/CkrvsxqRCxhP2E2x1o7l3PuRl3m5g+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ARb1uo4+; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ARb1uo4+"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2cd0d05838fso122364411fa.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 01:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1705483404; x=1706088204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EfI3fIB++8nw+ASq5F8fuLbZ+fGhBjFlMzRTBNAgO5A=;
        b=ARb1uo4+X1tYggKCAQgz96JkYHnGvXsVXzRaAc2yf9fM6m1Bq/QRYVB9PrwJIxWy05
         eIMf//dMrmuSLtwCLxIV/nkvn51qK4qabhZrjBKDXk86+wtavOSSss2QTWpJvdb61vNs
         tCXLnnRH3dZ/Y+FQpGUFu7uCPn5c0PDuPe6K6psaqT0ac9mQWlmT6pizYFdc0Yzzyb14
         VkAHtCvmmcfuwPDgbR+rAvv6TYmHufEEQzEA+IeGDkT6NMv2Q1BUjGaV9r7h9TeKtYzU
         Vx9yARhfrbFdAPv21aUoNsGoukilaWkm9eRym1k0CZrKotL7i8gv09ABAsYRozEjUVqU
         2kbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705483404; x=1706088204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EfI3fIB++8nw+ASq5F8fuLbZ+fGhBjFlMzRTBNAgO5A=;
        b=V1M4LN3F8j8eil1E3jsOOAKg3yqxaUiO5bz47KMiM2TDbi5Ph8vWibbeiqDgUjzLHa
         XPSYtiiWrrh7+XyYUOh+vfCmKSUVx7HYNJ+Lp+DGKrYfTOKeF1l20bSamrnAs2+iPjsJ
         2FWJBMXDElV1ouj9dp4dYL/49FuArbzag1g0bPYqOf+zBaddVREItRJIpfCHcLMMChja
         ukU1Ji26A/UXS/tN+mf5mgrzpgRu8IIOfN2lVSK1xZAcwjqAOJByLHaw93gSNWxJEO5y
         lmI6H8AZrpEQyGemTyLietkZU5BCop6FYGviKJlZcHPD2jQTTKZHraKHztHeFZKzYMX8
         oxmg==
X-Gm-Message-State: AOJu0Yx26953hi6N70UUzdo4geHFrQjl+aHB/qerKqPoLGqJisBHGmrg
	oqSk4bYyWHhe5yolezC/V5BIIEgNvwjsgqiEK7VPI7EGgcg=
X-Google-Smtp-Source: AGHT+IFb5xxEErYLOic0etNAPoIwSC6V6gnM1l8IUklYxDo3T2Ka348d5/LCSQzWyh4K+/MHAjHw2A==
X-Received: by 2002:a2e:9593:0:b0:2cd:9f94:f93a with SMTP id w19-20020a2e9593000000b002cd9f94f93amr3042130ljh.43.1705483404142;
        Wed, 17 Jan 2024 01:23:24 -0800 (PST)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090b004300b0028ceeca04a1sm13736472pjt.19.2024.01.17.01.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 01:23:23 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 1/2] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Wed, 17 Jan 2024 17:23:08 +0800
Message-ID: <20240117092309.1134595-1-glass.su@suse.com>
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
---
changelog:
v2:
    Add more details about why MKFS_BCACHEFS_PROG should contain '-f'.
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

