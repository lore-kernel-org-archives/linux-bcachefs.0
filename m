Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5659657C2
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536882; cv=none; b=LPsRXxji908w1/fammN9eBlmRiISSKuMECK+LPD2GW50lc2DyAYdUYjMDWdGtsInr+9nw5XcXl+ss2YCjLr51eSG4zaTGiJA+YKF+pB2OfLlO3W5Y+E43Q8D8NWmveDBaSmU6ycyZMZFlV0nEjdsjj5v1wQzm1DVw3TTcUP2k3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536882; c=relaxed/simple;
	bh=UWgSDhKosR9FGCdd6IKUFEPvSGWcGH5pubSyKyf+Nrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9Cp4rQbnFcezLmNhsMI4iib1e0cM7fOv3Ztw7xLWYJYLVcIr2zS1HCD5kFUeWSaX38MDr7o8kwjI31C3YwpzOw+C/tnrxeiBaEBOB0uCQ2h/myLvWe/e0IyAPnQ4+Jgi4WcGr1H+Qcu1B1waMbcXAt4ua+35V+iLDky3QYwBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IPRUjMGO; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IPRUjMGO"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cf3a0b2355so33432261fa.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 06:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706536878; x=1707141678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Db4Va7IrNtH54GBgsvXVUPtYzE1Cf7tUcn2FCv/sF5c=;
        b=IPRUjMGOkc8Zc00JSYmh3ojEMuVEe5t8wwxauVuUWI4klhOXrBBHFkkFy07akLnfAr
         1o4plSJccmIlsisU33y0qPEOp6Jj64eUkEUEIkUGfDhoIAFC1ZBWKVxvwX5LB03HUdQ8
         iRfEnsw1r/jyWhTKv7m/T1qJxB6EcgIArop1Z7IuFVK9DNuzjGTiurln+eABdBvzhWeg
         WfVwmryxlC2M+A31T2XEErv3yLORP43nLvhqC2edL6VLTuM0EXa/SPw98NtcwMnleD92
         lGEt3Tfe0PEJ+6I6wnhhvwonVN5f84hV7X+imbuJpBvNhLYcYcU2KSleQQSpUFB4YN7n
         OKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536878; x=1707141678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Db4Va7IrNtH54GBgsvXVUPtYzE1Cf7tUcn2FCv/sF5c=;
        b=El3V18wuwvwJwES9LqaD/BFzw0RY2EaxkeesXqRrz1WvFn4zD9lVDuCpjuf42su4XD
         xvDvbz/jiqHcdmhXJIvUge+lmN0zYMAN3ttxbxBh2frBaP2LAL1FpfUOcXMjtcMIjSB/
         mObQAWcoXPIKn92R0S/002/4WD9pykvSc6ZtGryvYHuEpvu4jBp52/J0lk8pZqUbTc98
         FxAH6q/ceKuwkUum84f1s9b4kq2J4qVkwockXQTDgDEDrwr0s8FLjo1AIHGSQIphrjZR
         C82mLPpcasipX9pUSNRjR9lVBFBKz5wxmv9srcVTdaUFwKTAvIOQYco3NndzsP78jyr2
         tqpg==
X-Gm-Message-State: AOJu0Yyfplu9ffvHASWoaso7exApmYvLN7aNG47eKjGUsBmryFLJhe69
	kjC16EqZPA7hHYmLl+71ZKW2xARy6Rh+ld4Ik1xKSqBBN8IWeXMcZq1l87EvkjEoMPoMxPVOvRR
	KS3s=
X-Google-Smtp-Source: AGHT+IGSGrHQAHUk7GV1sowY4IqMHOSG4oP2JlV0DtFW8S6U1pqZPiL5f/EZTZlwQ9x0woe7CSraow==
X-Received: by 2002:a2e:b8d1:0:b0:2cf:457e:61fa with SMTP id s17-20020a2eb8d1000000b002cf457e61famr4528963ljp.37.1706536878011;
        Mon, 29 Jan 2024 06:01:18 -0800 (PST)
Received: from localhost.localdomain ([43.228.146.200])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090330c300b001d8e2618792sm1871900plc.106.2024.01.29.06.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 06:01:17 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 2/2] common/rc: improve block_size support for bcachefs
Date: Mon, 29 Jan 2024 22:00:59 +0800
Message-ID: <20240129140101.4259-2-l@damenly.org>
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

mkfs.bcachefs now supports option '--block_size' to allow
custom block_size.

Add the pattern to set def_blksz if MKFS_OPTIONS contains the
option in _scratch_mkfs_sized.
Also let mkfs.bcachefs decide blocksize if no option is given in
local.config or _scratch_mkfs_sized parameter.

Signed-off-by: Su Yue <glass.su@suse.com>
---
changelog:
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
+		[ -n "$def_blksize" ] && blocksize_opt="--block_size=$def_blksize"
+		[ -n "$blocksize" ] && blocksize_opt="--block_size=$blocksize"
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

