Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85A62F5A0E
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Aug 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786594316; cv=none; b=F9wACeQ1Qjl7/8AdiJy3Ron8wi8OLz2zB5gBuPCpUmj+jgqoYIndbaKZk7ZFamMgJbZ59NSXCEFgOaC+oqJwTQrAldkg9ExtEL6RgZTqALPf05b+//q3K6wnwDUu5AlpaCGRWvUQHXst3JeIxqlizAHkKzIWtqR9RjwzPdJhYW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786594316; c=relaxed/simple;
	bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8sSDrmqDXkJBG7IRG1d5pS+nC+/kUhg8NvJgdFKuzMYtmwrpwiExQ+LlviPZuLNvNbPuzNQLR6Ype6KCZpt3BPvMLrOzGQL3dRc/u/WsvlUz8m+G39CI2qPShLbj5JCd8oSvv9CinDvmUKAfNZbCoyBbllsdDxjOB1KprZPDx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sVMbCfDl; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVMbCfDl"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3900e39d935so368321a91.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Aug 2026 21:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786594314; x=1787199114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
        b=sVMbCfDlTfIv4/xVpIItYsFiNHw9hjA8pH5oWjb2SVG7QOhoY//S7FxxUdNlsngf7h
         rB/7Voc650rDZACEqxOozA+FecWj63KbnyIcxgFqYsWICZlpAVDfq5sQdsBpuBrhQb2S
         4pXvE47jxM+z/hnBhkw37LpTFNEdiydf8D8ud07xzbBL34AEkvJ7i3VTgWUulws9gvwy
         lRkmfWfo2gZefxcDRoL6yR76/pVjgmTjPw4/3LC/tSPtf3YMTDnZP/wihMDtsrYL9tSc
         8Lje0WR8kXCSeZjk/+YK9r9Iv+ENPWKz7SKiJ/w2nK8nB//Q1fjvM5JemGrysvF9gsAB
         4Mvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786594314; x=1787199114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gnzg7LxLmW/AaeD3Pv1ryB6Tex49wbpWBcRevOIJ/7s=;
        b=cS6Pkqd/YlncF+OVkCJQeGqPIBthP+3WB3iTixbg9TVBZ0VAfhLPSqEU1vt41vLsS2
         L7Lf/V0A1GxXOZPpuW1pZqJ0bdxhduoitv7qx5tAK7QighdfBS9NsOod0DDUnsqPIXT3
         P8m+Xr/KtYoq2y/2+9PaH3zUvTqyArZ+Nb42maNLtg6Ecp40GsUj/vcFYRyFCcAuC5NS
         tO4rElVNqsExmfwOxKpIuNRxuVGrlxeK/GalwkRt8JVYX6bkYrLNYFCAioq74apXbQjG
         eY4RGS0Jo5mvOhDz9lEyiUsC4uG2RtmbtHiR5PsV42ng61VtnvQovuI8fK+x5I6iQc19
         xoeQ==
X-Forwarded-Encrypted: i=1; AHgh+RoFlSmn5KsbsFbnQhsPqm9ZhEr3JiCAq5hWXxe9w/wECqDf+EgcR7QtLVvxa6Lz7p9LJr0vuDS22sV+WjfMgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYggEagL2Ernh8Wq7dMkriM0As35hkipAuMRtk7lAaRgY0/zw9
	8blKFn0QrBJ4vVy2GZdNHIu8NZxvd6jSygqbEHd2u6UNMBHSqJZGNJMm
X-Gm-Gg: AR+sD10P0kWGxblyIsrNJeqC25UA2zrRlOkRuH2uwaut8Dm2BvXFhDm9+82JHHap1AS
	Ptc/k/YQSNg33X2S4l8vXTBL7FUy0KLFDkyZ1t15HdpUNKYcgAtzXD02N34pFkWa1On1nWTSqzY
	qCcq1pQqUxai7z3PAFY0uIfjitmI7haCxmesV+wIZj1H9HuaUd+GAGE2K0LC8HRDbFfih7hxuCc
	7lUXBS2rLF4robo7WkVeg/qoVrx+7r27g31SwngZFbEsF/XxnFNZZaZ8Tbj/G80VWg/YBSy5j0S
	6GPLQlgHGv6oQW8talV06rMzwm/eJl+uWuC2LoAEBb9qsV3q/SSwZcxubZZ+7pVD7R+OeX/mYNf
	NsBh3a9Zulg2kP2FyOH6Md6dhf5flSbO83JJVG8Wrvn2noDEbYI7r6/zSfmnHYOMonFW5UMByH9
	XjvKUXwUIlZowy9qFSqlZF6nZWpYSU6tq+3icGSJrQ+HEfPRF/Pafqv1BBXjuC1jLdsf+3FvIcy
	5n5XnSCbhU15f+HUf0oupVG0xcBJeJvmKcSVXxiK7e+Dnaf/KwHv1tRbFDYz+JgsibO+hVrZRHj
	BcvgD3KSd33yId1Vg+8eJzqqRNyPQ+TM+G7+HzI9KKCKrog11TS9
X-Received: by 2002:a17:90b:3846:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-3931e2a32bbmr3024404a91.15.1786594313939;
        Wed, 12 Aug 2026 21:11:53 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931f478658sm1127538a91.17.2026.08.12.21.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 21:11:53 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: syzbot+b3fba2e269970207b61d@syzkaller.appspotmail.com
Cc: brauner@kernel.org,
	cem@kernel.org,
	gregkh@linuxfoundation.org,
	jack@suse.cz,
	jfs-discussion@lists.sourceforge.net,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	shaggy@kernel.org,
	syzkaller-bugs@googlegroups.com,
	tj@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [kernfs?] [ext4?] INFO: task hung in sb_start_write (2)
Date: Thu, 13 Aug 2026 12:11:48 +0800
Message-ID: <20260813041148.2302176-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>
References: <6a75a39e.01d0871a.3a0d52.0042.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The C reproducer neither demonstrates a kernel bug nor matches the
crashes already collected in this bucket:
https://syzkaller.appspot.com/bug?extid=b3fba2e269970207b61d

It lowers hung_task_timeout_secs to 15, issues ioctl(FIFREEZE) on the
root filesystem, then forks a child that opens an O_TMPFILE there.
The child blocks in sb_start_write, as any write must while the
filesystem is frozen. The reproducer sleeps for 60 seconds before
thawing, so the hung-task report fires only because it shortened the
timeout below its own sleep. The default 120s timeout would not
trigger. Any CAP_SYS_ADMIN process can produce this report on any
kernel: this is fsfreeze working as designed. Whether a task waiting
for thaw should be exempt from hung-task reporting is a separate,
older question.

The pre-existing crashes differ. In the 2025-08-01, 2025-08-23 and
2026-08-02 instances, the blocked task waits on the sb_writers of a
filesystem the fuzzer mounted from an image: lockdep classes
sb_writers#31, sb_writers#13 and sb_writers#20 respectively. In the
same reports, the root filesystem's writers class appears separately
with a low number (sb_writers#5 held by udevd and others). The
reproducer instead reports sb_writers#4, the root filesystem that it
froze itself.

The captured console logs for the three organic crashes contain no
FIFREEZE call. One contains a single stray FITHAW, so a freeze before
the captured log window cannot be excluded, but that must be
established before treating this reproducer as the explanation. If a
fuzzer-issued FIFREEZE on a mounted image caused the hangs, the fix
is for syzkaller to sanitise FIFREEZE, and the bug is still not in the
kernel. Otherwise, something wedged those superblocks' writer gates
with no fsfreeze in sight, which is a real bug that closing this
report on the strength of the reproducer would bury. The mix of image
filesystems mounted by those runs also explains why the subsystem
guesses span kernfs, ext4, jfs, xfs and bcachefs.

I therefore suggest treating this reproducer as matching the
signature, not the cause. A previous generic-signature hung-task
bucket, "task hung in do_rmdir"
(https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d),
contained a real ext4 livelock. It was fixed by commit 54b6bd40898d
("ext4: stop retrying saturated xattr cache entries") in the ext4
tree:
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=54b6bd40898d

Such buckets can hide real bugs behind an uninformative victim stack;
the per-instance reports contain the distinguishing evidence.
