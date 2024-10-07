Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4D189BBD
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Oct 2024 21:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335082; cv=none; b=b3H+IVlYZJLIn+5mIE4KTNhsvUK58R1OWaAEsNGMasP0XXeQMBvOZ5vWSlLq8CbqsK+1+DqBL6HxGN/s06dI2ZnAZFJZT3lOPB0u7eqprGVqdH34pNbOm4LuY0AJ5y3sExh2yELF3dx5LNFBMT2RP8RQ45hwMCnolLnt2xA9MYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335082; c=relaxed/simple;
	bh=NKDyhS0TvyGHTJKH2DIC4CYN0AS6n4xo0A1mHp0OkVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G2S4Brs2l1JR1R/v+0trT+lBkiO3prbKNhmMiY/BJv3/Vt8EXZKf0F1lLRu7szKMRN6Jjh47UI8s8a0lMhirLI19ewottDcco4a2xsjc8jBwWvBl/nP9W6LRG0LOHiBWX0PZNsjqnATyk+aTuoTk/oj18lS7TUDvZW7CYQlrupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xVDaz+5C; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xVDaz+5C"
Date: Mon, 7 Oct 2024 17:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728335077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4JN3SbSbj+rvaT5IMOon+k8de/Yh9jaTHIk3VT4ZedU=;
	b=xVDaz+5C79bnf5xaHrrAE5CYVyS/BmJumRPM0BtdrMyDAGYAyZjq4HYPM7AdF3LeNUcisI
	wdDPm1BeTmjA7LdHUrSaAWBviilbmb/VlPrgdKMmy2hx5ZiKwk4ZqtZc8rp/JPdfFpfgPF
	692yCZ+rGpOmXEP5oDlHrGVdAUZFCjk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+4d24267b490e2b68a5fa@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: use mutex_trylock in
 bch2_replicas_entry_validate
Message-ID: <d6ydx3ogfkeo6vj4ntyojlupno5luna6meujk4qpag3fr5yv7d@3oertneyrl3w>
References: <20241007205430.492090-3-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007205430.492090-3-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 08:55:49PM GMT, Piotr Zalewski wrote:
> Use mutex_trylock instead of mutex_lock in bch2_replicas_entry_validate to
> prevent potential deadlock[1].
> 
> [1] https://syzkaller.appspot.com/bug?extid=4d24267b490e2b68a5fa

No good, skipping locking is not the right way to fix this.

I fixed this with the below patch - we've got a different way of
checking if a device exists when the filesystem is online.

From bf4baaa087e2be0279991f1dbf9acaa7a4c9148c Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Sat, 5 Oct 2024 17:37:02 -0400
Subject: [PATCH] bcachefs: Fix lockdep splat in bch2_accounting_read

We can't take sb_lock while holding mark_lock, so split out
replicas_entry_validate() and replicas_entry_sb_validate() -
replicas_entry_validate() now uses the normal online device interface.

00039 ========= TEST   set_option
00039
00039 WATCHDOG 30
00040 bcachefs (vdb): starting version 1.12: rebalance_work_acct_fix opts=errors=panic
00040 bcachefs (vdb): initializing new filesystem
00040 bcachefs (vdb): going read-write
00040 bcachefs (vdb): marking superblocks
00040 bcachefs (vdb): initializing freespace
00040 bcachefs (vdb): done initializing freespace
00040 bcachefs (vdb): reading snapshots table
00040 bcachefs (vdb): reading snapshots done
00040 bcachefs (vdb): done starting filesystem
00040 zstd
00041 bcachefs (vdb): shutting down
00041 bcachefs (vdb): going read-only
00041 bcachefs (vdb): finished waiting for writes to stop
00041 bcachefs (vdb): flushing journal and stopping allocators, journal seq 3
00041 bcachefs (vdb): flushing journal and stopping allocators complete, journal seq 11
00041 bcachefs (vdb): shutdown complete, journal seq 12
00041 bcachefs (vdb): marking filesystem clean
00041 bcachefs (vdb): shutdown complete
00041 Setting option on offline fs
00041 bch2_write_super(): fatal error : attempting to write superblock that wasn't version downgraded (1.12: (unknown version) > 1.10: disk_accounting_v3)
00041 fatal error - emergency read only
00041 bch2_write_super(): fatal error : attempting to write superblock that wasn't version downgraded (1.12: (unknown version) > 1.10: disk_accounting_v3)
00042 bcachefs (vdb): starting version 1.12: rebalance_work_acct_fix opts=errors=panic,compression=zstd
00042 bcachefs (vdb): recovering from clean shutdown, journal seq 12
00042 bcachefs (vdb): accounting_read...
00042
00042 ======================================================
00042 WARNING: possible circular locking dependency detected
00042 6.12.0-rc1-ktest-g805e938a8502 #6807 Not tainted
00042 ------------------------------------------------------
00042 mount.bcachefs/665 is trying to acquire lock:
00045 ffffff80cc280908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_replicas_entry_validate (fs/bcachefs/replicas.c:102)
00045
00045 but task is already holding lock:
00048 ffffff80cc284870 (&c->mark_lock){++++}-{0:0}, at: bch2_accounting_read (fs/bcachefs/disk_accounting.c:670 (discriminator 1))
00048
00048 which lock already depends on the new lock.
00048
00048
00048 the existing dependency chain (in reverse order) is:
00048
00048 -> #1 (&c->mark_lock){++++}-{0:0}:
00049 percpu_down_write (kernel/locking/percpu-rwsem.c:232)
00052 bch2_sb_replicas_to_cpu_replicas (fs/bcachefs/replicas.c:583)
00055 bch2_sb_to_fs (fs/bcachefs/super-io.c:614)
00057 bch2_fs_open (fs/bcachefs/super.c:828 fs/bcachefs/super.c:2050)
00060 bch2_fs_get_tree (fs/bcachefs/fs.c:2067)
00062 vfs_get_tree (fs/super.c:1801)
00064 path_mount (fs/namespace.c:3507 fs/namespace.c:3834)
00066 __arm64_sys_mount (fs/namespace.c:3847 fs/namespace.c:4055 fs/namespace.c:4032 fs/namespace.c:4032)
00067 invoke_syscall.constprop.0 (arch/arm64/include/asm/syscall.h:61 arch/arm64/kernel/syscall.c:54)
00068 do_el0_svc (include/linux/thread_info.h:127 (discriminator 2) arch/arm64/kernel/syscall.c:140 (discriminator 2) arch/arm64/kernel/syscall.c:151 (discriminator 2))
00069 el0_svc (arch/arm64/include/asm/irqflags.h:82 arch/arm64/include/asm/irqflags.h:123 arch/arm64/include/asm/irqflags.h:136 arch/arm64/kernel/entry-common.c:165 arch/arm64/kernel/entry-common.c:178 arch/arm64/kernel/entry-common.c:713)
00069 ========= FAILED TIMEOUT set_option in 30s

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index bcb3276747e0..797da1032318 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -66,9 +66,9 @@ void bch2_replicas_entry_to_text(struct printbuf *out,
 	prt_printf(out, "]");
 }
 
-static int bch2_replicas_entry_validate_locked(struct bch_replicas_entry_v1 *r,
-					       struct bch_sb *sb,
-					       struct printbuf *err)
+static int bch2_replicas_entry_sb_validate(struct bch_replicas_entry_v1 *r,
+					   struct bch_sb *sb,
+					   struct printbuf *err)
 {
 	if (!r->nr_devs) {
 		prt_printf(err, "no devices in entry ");
@@ -98,10 +98,28 @@ int bch2_replicas_entry_validate(struct bch_replicas_entry_v1 *r,
 				 struct bch_fs *c,
 				 struct printbuf *err)
 {
-	mutex_lock(&c->sb_lock);
-	int ret = bch2_replicas_entry_validate_locked(r, c->disk_sb.sb, err);
-	mutex_unlock(&c->sb_lock);
-	return ret;
+	if (!r->nr_devs) {
+		prt_printf(err, "no devices in entry ");
+		goto bad;
+	}
+
+	if (r->nr_required > 1 &&
+	    r->nr_required >= r->nr_devs) {
+		prt_printf(err, "bad nr_required in entry ");
+		goto bad;
+	}
+
+	for (unsigned i = 0; i < r->nr_devs; i++)
+		if (r->devs[i] != BCH_SB_MEMBER_INVALID &&
+		    !bch2_dev_exists(c, r->devs[i])) {
+			prt_printf(err, "invalid device %u in entry ", r->devs[i]);
+			goto bad;
+		}
+
+	return 0;
+bad:
+	bch2_replicas_entry_to_text(err, r);
+	return -BCH_ERR_invalid_replicas_entry;
 }
 
 void bch2_cpu_replicas_to_text(struct printbuf *out,
@@ -686,7 +704,7 @@ static int bch2_cpu_replicas_validate(struct bch_replicas_cpu *cpu_r,
 		struct bch_replicas_entry_v1 *e =
 			cpu_replicas_entry(cpu_r, i);
 
-		int ret = bch2_replicas_entry_validate_locked(e, sb, err);
+		int ret = bch2_replicas_entry_sb_validate(e, sb, err);
 		if (ret)
 			return ret;
 
