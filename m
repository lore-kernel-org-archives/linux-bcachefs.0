Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D582E7167
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167690; cv=none; b=JS87IywOTWPbjgrQvOl7Yx1B6Us1ii3EpPb9binhxL0AvCAcFTdZx29qBELKBn8ygWX4ZQJI0MzOAbUY8E6eN/3HYK2+mKFjhmFZ5NySJadc2PkIHwDPaKdwHbChmyRhNZNbw7UvOLPvQ+7WDw8ZF6Kw69yyy8aeshJutdhEYWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167690; c=relaxed/simple;
	bh=HrO8lxt3LBt/AWADIEh5uZQ4mKKsaoNO1gAWGUkXYhM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EgYwyixOmK/Oj5slH2fIGbTDifCaLBsb7XAY++uZ0Tksu0mnvivASc+N2OWloGjXQXKQ9P0AYPl3TWUqKwWqyJiVxc8gTIqgwwmixv8hkYsp++cFynOa34+at0cXW8lcupRqU7WkvzoWYiqiIusuof7KXvyQpUEv9HW6kila7Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hExaoHu5; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hExaoHu5"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235e1d710d8so70448625ad.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 06:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750167687; x=1750772487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IHsQDpxWPUefcRM3L/XKDZaVWFn7gw3H5defpON5D0k=;
        b=hExaoHu58qJh7As+qCVFbfvD++HT9Ez2jDNxEouLvTxac4WrCRFEAgunnajj+7vGbR
         0pzAeu+/4URD6UhYdO7wVguiBh9ko/YH1SI6PC0/3jxqNpZBxJlwjtQlLnXIAniRZKD3
         HBHdE8fMTug3EcBzO2YslHlFUcYZC5IJk8mdAqz3wDvcV4tACHT97/1/prXGUrm74Wbp
         EwLUADkD8P1UNfjQDvCSwW51gXBfLU24UH8GoDkR0O+YsvjT5H8bEtc1RC+lSlwuAFim
         aXdLNNtwRXYGoCjlKuDw8fhg45AnTWU4+3fuftQh+Mq46pdJ3ZyyMUxb/2tu1yT5+dYo
         Yglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750167687; x=1750772487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHsQDpxWPUefcRM3L/XKDZaVWFn7gw3H5defpON5D0k=;
        b=YJnl12G/7niEnW4FYI3HTe8c1+jMfzYW721CC+VNM+VAGqwFQADkc4subT5knJAXRm
         F0VlAwNa3HX4CuFAwhhUmadrUpmOj8N07gIaEiTsqaWVeBXdGCJ4HWG7Kdr/JspYsEaB
         KrQNP5vRFe15yDhxhBGhVigYOGGYlfFYO+N1fuxgM8zl20C8DVRVRDYE7Ml0CAGr/z6R
         mChFX1B0M/eeSMcDFhAVrCjd8LajnGOskXRO9zeQiZdZ8bJDxNvz85hnq5d3dqmynpOp
         2JNBxnIDHvJJTAzWwyuKhDGsvPuCrFihz74zIrCvljwVb4V/GpkCLRW0yN/5VAHyOdPf
         e0uA==
X-Gm-Message-State: AOJu0Yzsnom8ZlU31FQvkdrLcoB+bGXs9VGTbB6w0qIBJngM1WifbRP8
	TkBF+VFFhwX/+SQ2an2xaD+S05/mdPC59WnofWOdhYfWDpASshYIk6e3CfWxb76Ieb6I4Q==
X-Gm-Gg: ASbGncsE9ZG4vewk+49Y2Z6UaKHGot+8nf8psNpo+RUPMuYdZwlF8LKJy4qCf4TCDH/
	XTxIp9LxHI8DPgYL4W5yAFV+vlS8TDxJv97d3moUKf0jd6YJR6BfkbGFeHXctgL96jbeQSnIYkS
	AFfVRf9H4bz0tN4Riz1HjqdNICK7Uza7SxT0cpW8LCN3niKYNW38BvApp6s+TwYRh+HVKxxS1+2
	ibMO2QMnpIYLFsL426o3KwO6q7I2lYabaVbG5K3RulCT0Ul3MufVvlGtAyrQXLFGI7XKumcPNLD
	egC69+AcHwBwoh14yYyomqFGVvc+SSVSzxKtDpeLJha9Wrq7FFjzMQU9yg42uA/ihk9gp/zvW7d
	m
X-Google-Smtp-Source: AGHT+IFs6mtXTgeYdA98LmW75mTApZjajvGw58XlXCylxmv1I+X7eLi5Idp6LTMIl5Mi3x5UJnfd5A==
X-Received: by 2002:a17:902:ebd2:b0:234:cb4a:bc48 with SMTP id d9443c01a7336-2366b3de5e5mr189518845ad.31.1750167686449;
        Tue, 17 Jun 2025 06:41:26 -0700 (PDT)
Received: from localhost ([36.110.131.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2369d2eafedsm1636025ad.133.2025.06.17.06.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 06:41:26 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Return EROFS for BCH_IOCTL_DATA ioctl requests in ro mount mode.
Date: Tue, 17 Jun 2025 21:41:20 +0800
Message-Id: <20250617134120.102668-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently, syzkaller reported the following issue:

BUG: kernel NULL pointer dereference, address: 0000000000000000
Call Trace:
 <TASK>
 mempool_alloc_noprof+0x1a7/0x510 mm/mempool.c:402
 bch2_btree_update_start+0x549/0x1480 fs/bcachefs/btree_update_interior.c:1194
 bch2_btree_node_rewrite+0x17e/0x1120 fs/bcachefs/btree_update_interior.c:2208
 bch2_move_btree+0x6f0/0xc70 fs/bcachefs/move.c:1093
 bch2_scan_old_btree_nodes+0x95/0x240 fs/bcachefs/move.c:1215
 bch2_data_job+0x646/0x910 fs/bcachefs/move.c:1354
 bch2_data_thread+0x8f/0x1d0 fs/bcachefs/chardev.c:315
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

This is because after commit d4d71b58e513 ("bcachefs: RO mounts now use less memory"),
read-only mounts no longer initialize btree_interior_update_pool, which is required for
processing BCH_IOCTL_DATA requests.

Since all BCH_IOCTL_DATA requests involve writing data, EROFS should be returned in this scenario.

Reported-by: syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/683bede4.a00a0220.d8eae.002a.GAE@google.com
Fixes: d4d71b58e513 ("bcachefs: RO mounts now use less memory")
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/bcachefs/chardev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index fde3c2380e28..ba9859fc9f24 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -384,6 +384,9 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	if (arg.op >= BCH_DATA_OP_NR || arg.flags)
 		return -EINVAL;
 
+	if (c->vfs_sb->s_flags & SB_RDONLY)
+		return -EROFS;
+
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
-- 
2.39.5

