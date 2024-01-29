Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A6657C3
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706536886; cv=none; b=Z35KrmqfoTz7CtkJib7E6u5dlSTlfF6T6Tglskrca0Y4ca7kwoN4iAOc3Q5m3oX75kWsH9TYggn3MCSvpIVMlJeqVKXjU/qX8QrtEMlTSt9e6E2IwimnljUDu/0tT2/dUSnAnEqKSxX8m9CzjqDfJHo5udSOc0df4SMGYnF52eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706536886; c=relaxed/simple;
	bh=UWgSDhKosR9FGCdd6IKUFEPvSGWcGH5pubSyKyf+Nrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCrmBzw6ARrXnUuX4Yy55l0sk8xm2eI9raPe4joDgcmnieeDtFdDMsLChIqHCxbfwbAckmU8HzMEjKMiZdWlsikmxEZBfefAEjRxDJPKruxIwtz+wqhQNKT66WSdO4WUteMEIiXLe85ADAS4wMrVxJ7JPt6CcvG/5wvc2BJMyDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dGAeznSZ; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dGAeznSZ"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d043160cd1so14145011fa.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 06:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706536883; x=1707141683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Db4Va7IrNtH54GBgsvXVUPtYzE1Cf7tUcn2FCv/sF5c=;
        b=dGAeznSZ4ce79k76/x7uXdRsEBzg1CJ+VX0UtPVJUuXE7A4rUeb3SNzJRdnU4x3IAo
         6AtSdcJdezG+2PcwXyQFA5uzZ8C7ivR9wb86cevh1Lcwkf0uTxUwR345vVwDC+vek41A
         OiRFWgih71cq56rsxVw0UklFYJ9z6FG7BRJjk1x4yIpnU+zQ8Q1K1bDI1Qz612XwY8MR
         53itw9vrPHSVte1A24FcRw2hvy70JgGr32Jv/pXsi4UdSm6V/mDoSnNQw+uMAngOpYEf
         iqdE/i6Gn1SyD7IzcQR5OxCu2rYIgDLIZnt9NxunA/vn9h2k2tptDSYrFeeZis8sV2ow
         B6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706536883; x=1707141683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Db4Va7IrNtH54GBgsvXVUPtYzE1Cf7tUcn2FCv/sF5c=;
        b=AwEe0WOzYu6/kZyuyQxa5jxemHrOOHeuE0onGYbp+xqk+mfQIDvseXDalaMT6Ya2XN
         EpmNTHwtE9+qyQ6ymrvH8KeiR5AAy74LsPnh3CNmPW0uy+wv3ObjezGKcPigGwN3zABY
         F9Mr/u7x8c+li7AVsGvOjJrU470bVkpWL6YEcieBmIfb0GmugmOAQJP+h/3wR3WxUJ7j
         vjbN3F3a5Jc8l1zQTG0FM+uUh+zvqjxFbDMtJU4eD2VQYGPylCJF3i1pLIMLixlEO1Bp
         2IRjWZJxNZO3BDNaYvdz97nHnPdmuguPYT4nidQWSFXJst/lrdJoEowFshbZjTvkv5ij
         +Wgw==
X-Gm-Message-State: AOJu0YyM6ZZyXbh+DLETi9HSJcP06AbD9EXAlAsHuwZg+rrXZSaHGun8
	wNNbZy68hFxNzNZUrbMd8BTS7vXgTZHwF1djycWS6n7TrNY38T+BdXia2TEiWbw=
X-Google-Smtp-Source: AGHT+IEtDInLzbFOGOvm0JTPBrp3zDIwzNPhlVNYK0B8Au6idIXyZxbEspbXrDr6gMQ1Tr9GlD/dOA==
X-Received: by 2002:a05:651c:8b:b0:2ce:4e9:d930 with SMTP id 11-20020a05651c008b00b002ce04e9d930mr3628629ljq.45.1706536883021;
        Mon, 29 Jan 2024 06:01:23 -0800 (PST)
Received: from localhost.localdomain ([43.228.146.200])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090330c300b001d8e2618792sm1871900plc.106.2024.01.29.06.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 06:01:22 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: fstests@vger.kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 2/2] common/rc: improve block_size support for bcachefs
Date: Mon, 29 Jan 2024 22:01:01 +0800
Message-ID: <20240129140101.4259-4-l@damenly.org>
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

