Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA81DA5F
	for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716750517; cv=none; b=MY47WJuLzVhNh69UBdye59mhkiGE8IIbS3SLEbmY7gAuDGsIXWU83jy1Kll/vj9GezZiet7jnQPxi+IfmuBD+TRcNJyIT/eaKtFIH0YwFPAGHT2ZKHtjRgvIpmAeli7s93rpozlPCgFffXnhlHmsJaflcYSq7R40t0l8Q0vNH50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716750517; c=relaxed/simple;
	bh=EIxm6m+MIZlnxov22KgGbn9Su9sllpWCVeJMV/B74pY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aTY3Zt2IdQZA21MUbeWG2jemA8EgSCsOa7EdOmc2cPdFIa7Wf8dQ/svSwZVWBK2Zddmwcvv8SHPWN0rh5rp7/3uWXlpg5koNfaLUqI0G2fwE7Xd21oL+Q/mrDCk2qPPn60eW6FRuWxJmXgGkqtVk1bor2AjuUmD+7Qkci9sFUJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TE40zvHk; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TE40zvHk"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7ea152611a6so74583039f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 12:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716750515; x=1717355315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkYkzJncWYezMG1erE/ZToTGQjnzNe+UGBblz2VFsLg=;
        b=TE40zvHkUvaWFhbSCqN8MtB5zrugbrdYPEIpu3b/4NUxNg7kwmoNqccjD42Tyu4u82
         6NvR4xHALVHVmOIghDiIJ8MF8eyOa9zderZve4ucif6dPWXYrTj4YdaRR9rNq43WwzAi
         uTNaF8kTk8YFUg/DrkQc/AmoowEKK4uBS7LNN1mQRgZWCUCT6ccKqALzlfw2VKlQvYM1
         JnIoxOdMhURDWGlGe/WaTqNsjdu/4NIAAsXCWQ4BiW53GoaNY7IgP8Jy0WAzUOGQ68cQ
         9LPLEdEtP5WwZNiN5l8ktdJpF/PxS5OLnP912bywFufCekW8Hq+6H0tT9x2b/7KqdBhh
         0sKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716750515; x=1717355315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZkYkzJncWYezMG1erE/ZToTGQjnzNe+UGBblz2VFsLg=;
        b=rjVzj7REj8TVqMhLD8ukDINKRIPMxkDi/4FgEd4/X5Pm1sedu86Onws5IAzZuwlvq5
         ZbadU9CX12LcdHrhOCOlgA9l69LpqKPuozvdE/m60nllSMthSkljt5qoqx7UPkKfAQ86
         jLpRamBDYkomlHWX4f78vw1ug0WlXh4eCrLb+6URAI1W/03eBnc0/ZhJBc9voBsE0uDn
         /meSXobHEqsleBlcHT/gban2vZ7MuFILiPcWJBkBOP2dDpFEUsLt8C1YGRTY8cMQSoI3
         dDf3XRJSdI3FLpWaxwpVD8BqWG7jCOxTW+lRgaeYVBIsDCH2Pji9yOsenN5i5vPDgaMQ
         009A==
X-Forwarded-Encrypted: i=1; AJvYcCWrr+ZCpJW9YmqkMib+kOeptZ92by1bEkmhy2z9C+kk59AyBbs2vtxgDabcJSfmKyUGyXH9SUeJX7B+QuUh5B4OrCKxQZR1Nti1e4E2jjs=
X-Gm-Message-State: AOJu0YxU+LZpND4C4wh8tY9ffGbAgN09mg9HXDn+866ILvMMG+6gi8P2
	aBz0bODJtkfQ64/miuusTo7vytMeKFk3sLhlF3V6I/uViNS9DfId
X-Google-Smtp-Source: AGHT+IHSw/+FTrJ+AWkYN2MNINxTkA4SK1eK1AOOwhxsmahCrEHuf5KFP5+yXLkuiucT1hE0JFXI/Q==
X-Received: by 2002:a6b:4907:0:b0:7de:da47:5ea with SMTP id ca18e2360f4ac-7e8c480b2acmr919464839f.4.1716750514546;
        Sun, 26 May 2024 12:08:34 -0700 (PDT)
Received: from fedora-laptop.. ([206.85.159.137])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03eccee6csm1656056173.148.2024.05.26.12.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 12:08:34 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 1/2] bcachefs: make offline fsck set read_only fs flag
Date: Sun, 26 May 2024 13:08:19 -0600
Message-ID: <20240526190820.606162-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A subsequent change will remove "read_only" as a mount option in favor
of the standard option "ro", meaning the userspace fsck command cannot
pass it to the fsck ioctl. Instead, in offline fsck, set "read_only"
kernel-side without trying to parse it as a mount option.

For compatibility with versions of the "bcachefs fsck" command that try
to pass the "read_only" mount opt, remove it from the mount options
string prior to parsing when it is present.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/chardev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 9e54323f0f5f..5040c584cd72 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -213,6 +213,18 @@ static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_a
 
 	if (arg.opts) {
 		char *optstr = strndup_user((char __user *)(unsigned long) arg.opts, 1 << 16);
+		char *ro, *rest;
+
+		/*
+		 * If passed a "read_only" mount option, remove it because it is
+		 * no longer a valid mount option, and the filesystem will be
+		 * set "read_only" regardless.
+		 */
+		ro = strstr(optstr, "read_only");
+		if (ro) {
+			rest = ro + strlen("read_only");
+			memmove(ro, rest, strlen(rest) + 1);
+		}
 
 		ret =   PTR_ERR_OR_ZERO(optstr) ?:
 			bch2_parse_mount_opts(NULL, &thr->opts, optstr);
@@ -223,6 +235,7 @@ static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_a
 	}
 
 	opt_set(thr->opts, stdio, (u64)(unsigned long)&thr->thr.stdio);
+	opt_set(thr->opts, read_only, 1);
 
 	/* We need request_key() to be called before we punt to kthread: */
 	opt_set(thr->opts, nostart, true);
-- 
2.45.0

