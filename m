Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F516EBE2;
	Fri, 21 Jun 2024 09:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718963217; cv=none; b=WPJKE04TMGaADSh37XXEZeICyL2UP1Y26pDGKHy7T0E8JChiqxkFGO6tW+cYXmk1T/mvFgrUELhyT2rheRx0NS0parjK1P7+Gw5CLKxvWdKe55ciXhADMrNTnno1d/cwwqnd4tytfc3MAndrIP6eiBvMIJQfb+NYguP/Cq0/Miw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718963217; c=relaxed/simple;
	bh=HJTFm3ne3G9N/E5vIgWrPP8CfAEG4zIi627y5AOehJE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjgLCNtHs0zSh/S1VW6HIPEzXkz/6ikLvLDSgSCyRiJLDgr/HAW5Zo4UO6LJjQ9CdTXl03NqplNL5NSKSgs/wNNMN5Tj8HiO4Ix2bIM6fuSZ+TKpPEEP5jfLtwPxBadzp4g2Dh1J/vSsYndy8ZjMsZZYjRVTt4fq+OJPLUM0Nqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L7PHc8026598;
	Fri, 21 Jun 2024 02:34:26 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yvrmq8p5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 21 Jun 2024 02:34:26 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 21 Jun 2024 02:34:26 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Fri, 21 Jun 2024 02:34:24 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com>
CC: <bfoster@redhat.com>, <kent.overstreet@linux.dev>,
        <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH] bcachefs: fix deadlock in bch2_gc_mark_key
Date: Fri, 21 Jun 2024 17:34:23 +0800
Message-ID: <20240621093423.1874314-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000c43781061b5fbdcd@google.com>
References: <000000000000c43781061b5fbdcd@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: eS3u-ap7tF52Pq7eMUnI8kgw38g8yCsy
X-Proofpoint-GUID: eS3u-ap7tF52Pq7eMUnI8kgw38g8yCsy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_04,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxlogscore=900 suspectscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2406140001 definitions=main-2406210071

[Syz reported]
the existing dependency chain (in reverse order) is:

-> #1 (&c->btree_root_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633
       bch2_fs_mark_clean+0x2cc/0x6d0 fs/bcachefs/sb-clean.c:376
       bch2_fs_read_only+0x1101/0x1210 fs/bcachefs/super.c:381
       __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:615
       generic_shutdown_super+0x136/0x2d0 fs/super.c:642
       bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2037
       deactivate_locked_super+0xc4/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
       task_work_run+0x24f/0x310 kernel/task_work.c:180
       ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
       ptrace_report_syscall include/linux/ptrace.h:415 [inline]
       ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
       syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
       syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
       syscall_exit_to_user_mode+0x273/0x370 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&c->sb_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_gc_mark_key+0xc66/0x1010 fs/bcachefs/btree_gc.c:600
       bch2_gc_btree fs/bcachefs/btree_gc.c:648 [inline]
       bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
       bch2_check_allocations+0x3e06/0xcca0 fs/bcachefs/btree_gc.c:1224
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
       bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
       bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
       bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1035
       bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2127
       bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2a0 fs/super.c:1780
       do_new_mount+0x2be/0xb40 fs/namespace.c:3352
       do_mount fs/namespace.c:3692 [inline]
       __do_sys_mount fs/namespace.c:3898 [inline]
       __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&c->btree_root_lock);
                               lock(&c->sb_lock);
                               lock(&c->btree_root_lock);
  lock(&c->sb_lock);

[Analysis]
bch2_btree_roots_to_journal_entries() does not need to hold sb_lock, so
we can remove sb_lock to avoid deadlock.

Reported-by: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/bcachefs/sb-clean.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
index 47f10ab57f40..7a75615ba745 100644
--- a/fs/bcachefs/sb-clean.c
+++ b/fs/bcachefs/sb-clean.c
@@ -373,6 +373,7 @@ void bch2_fs_mark_clean(struct bch_fs *c)
 
 	entry = sb_clean->start;
 	bch2_journal_super_entries_add_common(c, &entry, 0);
+	mutex_unlock(&c->sb_lock);
 	entry = bch2_btree_roots_to_journal_entries(c, entry, 0);
 	BUG_ON((void *) entry > vstruct_end(&sb_clean->field));
 
@@ -383,6 +384,7 @@ void bch2_fs_mark_clean(struct bch_fs *c)
 	 * this should be in the write path, and we should be validating every
 	 * superblock section:
 	 */
+	mutex_lock(&c->sb_lock);
 	ret = bch2_sb_clean_validate_late(c, sb_clean, WRITE);
 	if (ret) {
 		bch_err(c, "error writing marking filesystem clean: validate error");
-- 
2.43.0

