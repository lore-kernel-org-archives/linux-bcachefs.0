Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FA922611
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728408792; cv=none; b=aGP3NSnhCBZw602zAiz1LuDFaZWtcMXtvaAFe9OiLD05Qz2qV/rF6LfvZXeTN/ZD5yTohN1Vxmt+5AiwJMuiNf1Rl5RFrwEtB2IEnACnIYwSqjrOBe0UfKaqy8jOCqznNCh6b7D7yjoP2vPCGMCwgQ0JvFxmx7077jT5M6L2lw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728408792; c=relaxed/simple;
	bh=ECpTUlHDlBL+KZOFH2ZSu07vm6n4oh+1dY4O5aL+i+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KunRbAUHTZX7eJCyq3z62yTysKItU+/ERDpUhgGPEnPwl0YolxGov5wV5USrGXKScqEHZzkgQlwkwT/JbMbQlrlQyqGhaNfvVBHYeeKFQkB84+9hPLJeEVupetmJE/pF3Ez8rFrPljila/n9g/VApNySlXR6BGgXF0dv07xkGfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqhEKNT3; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqhEKNT3"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e15fe56c9so676830b3a.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Oct 2024 10:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728408790; x=1729013590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IBiFMhv064YKLAIMaZ15fbycfGTVRSbzrqgyb9lBQVY=;
        b=YqhEKNT3szHrqrba4k3GJdZq0uPCnwnriC6bqqj92L9FtVns+bIh7l4Nmwl2xloVo2
         6Hqn6df2dk/x65fQUKp3lF/4uJSQymQ4/jq+Svx3MKHv0VRxzPYlFYWtgHXVqNiHCO94
         BYRPJ450VAmA4H9hYpdIFZhrqwWxH+VlCCt9qi3lUSAGl81xiKMnPsgXSaPrl/a6XaZG
         tTs6uLUKz5bxSD+8+0d4zSEblwTQh3XmvBms+GeOtwVtHeN7taz7xXXOhiF1DHRiXGnc
         +ml+3A2+grV/httL13W1VxnQbUTFkppZKYeQkLpTcwfdXzX/OTC9gIwpBmhapFulioct
         qYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728408790; x=1729013590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IBiFMhv064YKLAIMaZ15fbycfGTVRSbzrqgyb9lBQVY=;
        b=u3u3h5v381hirBMkgnrQZN/VDHDIgeiaEK263qo9oLfoe382nNo0eHSj0q42v1JMPM
         YYr+chJWQnOGKTjZGop2RhqSdgvqWwKhIHLG/k3PKAZHhDYF8IA/cbFWzbmJ8zs3A3mw
         ok9SNy+kXtI0K5bx+N+HCZxXmRvAlr72Wblv+UgncnqM7247r+sgwnRp+6s09WlIGLu0
         jg5UpIrRBX7euDuC3gCdo91EvXoqp56u55i8lRf9mWJM4e3aSRfKkMBdkoNI47MyAyID
         K6caF3td1lsz72f6GiVfVtKCGlDlUOvazJFwQVP0W9s7J+XOW0c5dGpdWsSVLg9dftil
         nv5Q==
X-Gm-Message-State: AOJu0Yyg5sLOd52YBqlGrBMTlKKY18pyZu2XZ05y9GZVt4RZTGf0Xr74
	iJd/Ze6zXWdvgBfc11K+Fq+zgwS1eBtAeAltl7RC2R3BBHv3K3RF
X-Google-Smtp-Source: AGHT+IH1YnQZ2k1pEQW1a5vDl9oJ3LQ60rLfKirHCfFdyPc5vIqlpZFrE6urdvRZJGCqP6bvks8tCA==
X-Received: by 2002:a05:6a20:b40a:b0:1d2:e903:432f with SMTP id adf61e73a8af0-1d6dfae338bmr20823256637.46.1728408790436;
        Tue, 08 Oct 2024 10:33:10 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f682decbsm7102368a12.45.2024.10.08.10.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 10:33:09 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix state lock involved deadlock
Date: Wed,  9 Oct 2024 01:33:05 +0800
Message-ID: <20241008173305.1736377-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We increased write ref, if the fs went to RO, that would lead to
a deadlock, it actually happens:

00171 ========= TEST   generic/279
00171
00172 bcachefs (vdb): starting version 1.12: rebalance_work_acct_fix opts=nocow
00172 bcachefs (vdb): recovering from clean shutdown, journal seq 35
00172 bcachefs (vdb): accounting_read... done
00172 bcachefs (vdb): alloc_read... done
00172 bcachefs (vdb): stripes_read... done
00172 bcachefs (vdb): snapshots_read... done
00172 bcachefs (vdb): journal_replay... done
00172 bcachefs (vdb): resume_logged_ops... done
00172 bcachefs (vdb): going read-write
00172 bcachefs (vdb): done starting filesystem
00172 FSTYP         -- bcachefs
00172 PLATFORM      -- Linux/aarch64 farm3-kvm 6.11.0-rc1-ktest-g3e290a0b8e34 #7030 SMP Tue Oct  8 14:15:12 UTC 2024
00172 MKFS_OPTIONS  -- --nocow /dev/vdc
00172 MOUNT_OPTIONS -- /dev/vdc /mnt/scratch
00172
00172 bcachefs (vdc): starting version 1.12: rebalance_work_acct_fix opts=nocow
00172 bcachefs (vdc): initializing new filesystem
00172 bcachefs (vdc): going read-write
00172 bcachefs (vdc): marking superblocks
00172 bcachefs (vdc): initializing freespace
00172 bcachefs (vdc): done initializing freespace
00172 bcachefs (vdc): reading snapshots table
00172 bcachefs (vdc): reading snapshots done
00172 bcachefs (vdc): done starting filesystem
00173 bcachefs (vdc): shutting down
00173 bcachefs (vdc): going read-only
00173 bcachefs (vdc): finished waiting for writes to stop
00173 bcachefs (vdc): flushing journal and stopping allocators, journal seq 4
00173 bcachefs (vdc): flushing journal and stopping allocators complete, journal seq 6
00173 bcachefs (vdc): shutdown complete, journal seq 7
00173 bcachefs (vdc): marking filesystem clean
00173 bcachefs (vdc): shutdown complete
00173 bcachefs (vdb): shutting down
00173 bcachefs (vdb): going read-only
00361 INFO: task umount:6180 blocked for more than 122 seconds.
00361 Not tainted 6.11.0-rc1-ktest-g3e290a0b8e34 #7030
00361 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
00361 task:umount          state:D stack:0     pid:6180  tgid:6180  ppid:6176   flags:0x00000004
00361 Call trace:
00362 __switch_to (arch/arm64/kernel/process.c:556)
00362 __schedule (kernel/sched/core.c:5191 kernel/sched/core.c:6529)
00363 schedule (include/asm-generic/bitops/generic-non-atomic.h:128 include/linux/thread_info.h:192 include/linux/sched.h:2084 kernel/sched/core.c:6608 kernel/sched/core.c:6621)
00365 bch2_fs_read_only (fs/bcachefs/super.c:346 (discriminator 41))
00367 __bch2_fs_stop (fs/bcachefs/super.c:620)
00368 bch2_put_super (fs/bcachefs/fs.c:1942)
00369 generic_shutdown_super (include/linux/list.h:373 (discriminator 2) fs/super.c:650 (discriminator 2))
00371 bch2_kill_sb (fs/bcachefs/fs.c:2170)
00372 deactivate_locked_super (fs/super.c:434 fs/super.c:475)
00373 deactivate_super (fs/super.c:508)
00374 cleanup_mnt (fs/namespace.c:250 fs/namespace.c:1374)
00376 __cleanup_mnt (fs/namespace.c:1381)
00376 task_work_run (include/linux/sched.h:2024 kernel/task_work.c:224)
00377 do_notify_resume (include/linux/resume_user_mode.h:50 arch/arm64/kernel/entry-common.c:151)
00377 el0_svc (arch/arm64/include/asm/daifflags.h:28 arch/arm64/kernel/entry-common.c:171 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:713)
00377 el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
00378 el0t_64_sync (arch/arm64/kernel/entry.S:598)
00378 INFO: task tee:6182 blocked for more than 122 seconds.
00378 Not tainted 6.11.0-rc1-ktest-g3e290a0b8e34 #7030
00378 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
00378 task:tee             state:D stack:0     pid:6182  tgid:6182  ppid:533    flags:0x00000004
00378 Call trace:
00378 __switch_to (arch/arm64/kernel/process.c:556)
00378 __schedule (kernel/sched/core.c:5191 kernel/sched/core.c:6529)
00378 schedule (include/asm-generic/bitops/generic-non-atomic.h:128 include/linux/thread_info.h:192 include/linux/sched.h:2084 kernel/sched/core.c:6608 kernel/sched/core.c:6621)
00378 schedule_preempt_disabled (kernel/sched/core.c:6680)
00379 rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073 (discriminator 1))
00379 down_read (kernel/locking/rwsem.c:1529)
00381 bch2_gc_gens (fs/bcachefs/sb-members.h:77 fs/bcachefs/sb-members.h:88 fs/bcachefs/sb-members.h:128 fs/bcachefs/btree_gc.c:1240)
00383 bch2_fs_store_inner (fs/bcachefs/sysfs.c:473)
00385 bch2_fs_internal_store (fs/bcachefs/sysfs.c:417 fs/bcachefs/sysfs.c:580 fs/bcachefs/sysfs.c:576)
00386 sysfs_kf_write (fs/sysfs/file.c:137)
00387 kernfs_fop_write_iter (fs/kernfs/file.c:334)
00389 vfs_write (fs/read_write.c:497 fs/read_write.c:590)
00390 ksys_write (fs/read_write.c:643)
00391 __arm64_sys_write (fs/read_write.c:652)
00391 invoke_syscall.constprop.0 (arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
00392 do_el0_svc (include/linux/thread_info.h:127 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2) arch/arm64/kernel/syscall.c:151 (discriminator 2))
00392 el0_svc (arch/arm64/include/asm/irqflags.h:55 arch/arm64/include/asm/irqflags.h:76 arch/arm64/kernel/entry-common.c:165 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:713)
00392 el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:731)
00392 el0t_64_sync (arch/arm64/kernel/entry.S:598)

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_gc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index b5e0692f03c6..49df621b3e99 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1225,17 +1225,20 @@ int bch2_gc_gens(struct bch_fs *c)
 	u64 b, start_time = local_clock();
 	int ret;
 
-	/*
-	 * Ideally we would be using state_lock and not gc_gens_lock here, but that
-	 * introduces a deadlock in the RO path - we currently take the state
-	 * lock at the start of going RO, thus the gc thread may get stuck:
-	 */
 	if (!mutex_trylock(&c->gc_gens_lock))
 		return 0;
 
 	trace_and_count(c, gc_gens_start, c);
 
-	down_read(&c->state_lock);
+	/*
+	 * We have to use trylock here. Otherwise, we would
+	 * introduce a deadlock in the RO path - we take the
+	 * state lock at the start of going RO.
+	 */
+	if (!down_read_trylock(&c->state_lock)) {
+		mutex_unlock(&c->gc_gens_lock);
+		return 0;
+	}
 
 	for_each_member_device(c, ca) {
 		struct bucket_gens *gens = bucket_gens(ca);
-- 
2.45.2

