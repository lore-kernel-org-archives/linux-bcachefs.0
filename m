Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0514F9D9
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 23:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729294540; cv=none; b=rknu9jUQmsHb5ufZSNRK29MTmphvciOfUMMLrudhPiWToZLbSZkj3eUmp1vIy1wqjpjFd3uZ2k+TchWOce87Pvt6rM3ahApwstKV0LnrXe4A5Ynsc6eW/d0oXZzlT5W6EAiG8huM9/AOD3fmZVleVsojFMc1/VkjkbQgb6Uqs1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729294540; c=relaxed/simple;
	bh=4H6/2XF11SN1tjXCDsonmAjioOjjMj2T1xcvYyFy/yI=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=YI1mZrSaCJGrfVNIfjgoQXUx3RvTr9fvnE9yMeZRF8jKQ+++AZYyMbX+lHIddsW6ejmCo142GlvC0LPEyWMuKfKdLOw3KGQJyM1fG6HASpy7JgxeuiwUuBJnICVBVeC0J73Gae2Y/i99XlRcR6WJ64j2gCEauLVLzA9gPshp1pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com; spf=pass smtp.mailfrom=kwiius.com; dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b=kNS+Nk7c; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bMWmEeVI; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kwiius.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kwiius.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kwiius.com header.i=@kwiius.com header.b="kNS+Nk7c";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bMWmEeVI"
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2E6B511401CD
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 19:35:36 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Oct 2024 19:35:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kwiius.com; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1729294536; x=1729380936; bh=lz/DoGpu6L
	vlGfUa5BSdfpyWAfn1EuZYJpBQIjeLOZo=; b=kNS+Nk7cHjXohB2HAh4ab1/Tbf
	xE2ZAMiVTbgJtt+QPwKArX/uzr5nTYrsyZ4epl7xi0iXdkFEEJoVv5piyw2KETKT
	JJ+eljeIttykGS+Qt36yzWBy6Th7slSGcQMcgiIlDVeJz/Vi/2GXAUR7+BiP4VpP
	nJuFjZD0FblCRxNZi8RTomupVx30gtd4lYnwfhI/Bqbu5RYhQAjKYdShV270ov1G
	E0xgklK9+zAUhQp0FPyCNiS88wRzkrVMyyHcrmlMgFhl0/BYVHsjlnbCzG5EPBbv
	q2emYnzGMrPt37Z42JS73cC9h54lauucj3R6g6Qo4An5mM5yftYDqRYA0bYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1729294536; x=1729380936; bh=lz/DoGpu6LvlGfUa5BSdfpyWAfn1
	EuZYJpBQIjeLOZo=; b=bMWmEeVIIcHO2jKICvY2IJ/NoCLGxgRz/xFF3F4ddAnh
	fGe+kNNZdWovi8T9uM4oq9aAawbsF0QUOMwNA9zNT/2xCryKCV2ccXmBxAO9YThJ
	cqB7ZR86v2HHDoEEMGZXbqIvm+K5fKSk5uVMvv4/O3sm5s+hDnuXdl/EHhgtCVXA
	HASEzmlpLQgz7wQdbW84Wn3TJGg9ypQUo2AvJEjI1LpAY+YeM2OE5KD6IALOFo5h
	w6GmLr0H2M9Bf0WQBcGSe5F6LX/bfwAgyIr6il0VCg+69pDBvrtQOKay4x/tjhWp
	rigZJv855nvLW5BnofRaC47z478NG7D7LO5O7bIseg==
X-ME-Sender: <xms:x_ASZx3SpAebJZTsCe1eD4O15nbr0TsSTzk-461fGFH0R4PtYu6-wQ>
    <xme:x_ASZ4GgpXa7-2kbbl18qbYPc-82UfkoeiJNSaYlJwEVPO9uppTwopqFAHSYAX2yx
    AR_erC5SpCnq1K2-g>
X-ME-Received: <xmr:x_ASZx6VBR9B0SMlxIwIHvtuL5Ao7WX1UNQ6UOSAgFpRrYpMWlHTz5yVn-QnVxzk-20>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehgedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefhtgfggg
    fukfffvffosehtqhhmtdhhtddvnecuhfhrohhmpeflrghmihgvucfotgevlhihmhhonhht
    uceojhgrmhhivgeskhifihhiuhhsrdgtohhmqeenucggtffrrghtthgvrhhnpedtudevge
    ejkefhjeeuvddufeegudehffefvddtgeejleejtedttdegveejhfejvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjrghmihgvsehkfihiih
    hushdrtghomhdpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:x_ASZ-3d5PnFvG2l6MjPkOH-yrOkj_L9EVI-HGLoAGYNeOZulAgN8A>
    <xmx:x_ASZ0EwlV5dxGH7bXz1MEx6iCGzfW8szXWhdBMGkMpDa0dK4yrgmg>
    <xmx:x_ASZ_-NsqlTnfSZHDT3L6Px3EeZ4VDMm4o1P2PEzVV_sZCQMixqsg>
    <xmx:x_ASZxkhSyjYtBwDsMFo-5qMMEP4RyNYA7EI-IbXwe3bJDJCHKsgQA>
    <xmx:yPASZ-PZ7r0b3QiNxOqugVq2mvcN5L1dkjfFznzQ6BJNtwlwiwxmJzlX>
Feedback-ID: i0a19459c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 19:35:34 -0400 (EDT)
From: Jamie McClymont <jamie@kwiius.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: "accounting not marked in superblock replicas"
Message-Id: <2C607C54-0D65-458B-83B2-9C769216CC23@kwiius.com>
Date: Sat, 19 Oct 2024 10:35:21 +1100
To: linux-bcachefs@vger.kernel.org
X-Mailer: Apple Mail (2.3818.100.11.1.3)

Hello Kent et al.

My machine running 6.12-rc1 has a failing data-only (no btree) drive.

The failure seems to occur while seeking while appearing to run smoothly =
on linear reads, so after listening to some awful noises while running =
the `evacuate` subcommand for a few minutes I decided it would be wise =
to instead mount the rest of the filesystem as very_degraded without the =
failing drive, and image the disk into a file on the filesystem =
(allowing me to later loop this image for a non-degraded =
mount+evacuate).

During this imaging process, the machine crashed and rebooted of its own =
accord (journalctl recorded `watchdog: Watchdog detected hard LOCKUP on =
cpu 6`; unclear if this is related to bcachefs), and since the reboot, =
the filesystem cannot mount (neither as `-o very_degraded,fix_errors` =
without the bad drive, nor `-o fix_errors` with the failing drive):

bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): starting version 1.12: =
rebalance_work_acct_fix =
opts=3Dmetadata_replicas=3D2,data_replicas=3D2,metadata_target=3Doptane,fo=
reground_target=3Doptane,background_target=3Dhdd,promote_target=3Doptane,n=
opromote_whole_extents,ver>
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): recovering from unclean =
shutdown
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): journal read done, =
replaying entries 9096592-9098738
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): dropped unflushed =
entries 9098739-9098745
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): accounting_read...
accounting not marked in superblock replicas
  replicas btree: 1/2 [2 6], shutting down
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): inconsistency detected =
- emergency read only at journal seq 9098753
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_accounting_read(): =
error fsck_errors_not_fixed
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_fs_recovery(): =
error fsck_errors_not_fixed
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_fs_start(): error =
starting filesystem fsck_errors_not_fixed
bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed=20

I updated to the latest torvalds/linux.git to catch the recent =
`bcachefs: Disk accounting device validation fixes` you sent in for -rc4 =
which looked potentially relevant, but no improvement:

bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): starting version 1.13: =
inode_has_child_snapshots =
opts=3Dmetadata_replicas=3D2,data_replicas=3D2,metadata_target=3Doptane,fo=
reground_target=3Doptane,background_target=3Dhdd,promote_target=3Doptane,n=
opromote_whole_extents,very_degraded,journal_flush_disabled,journal_reclai=
m_delay=3D200,fix_errors=3Dyes
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): recovering from unclean =
shutdown
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): superblock requires =
following recovery passes to be run:
  check_inodes
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): Version upgrade from =
1.12: rebalance_work_acct_fix to 1.13: inode_has_child_snapshots =
incomplete
Doing compatible version upgrade from 1.12: rebalance_work_acct_fix to =
1.13: inode_has_child_snapshots

bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): journal read done, =
replaying entries 9096592-9098738
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): dropped unflushed =
entries 9098739-9098745
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): accounting_read...
accounting not marked in superblock replicas
  replicas btree: 1/2 [2 6], shutting down
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): inconsistency detected =
- emergency read only at journal seq 9098753
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_accounting_read(): =
error fsck_errors_not_fixed
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_fs_recovery(): =
error fsck_errors_not_fixed
bcachefs (b7f3ad1a-1a17-487d-a670-333e0aaee6e2): bch2_fs_start(): error =
starting filesystem fsck_errors_not_fixed
bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed

Any ideas?

Thanks
- Jamie McClymont=
