Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EDC839F1;
	Mon,  1 Jul 2024 00:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719792810; cv=none; b=Sj8u1DFvf0IDcDfVL5IZ0YY3sE6YW0OT6fQihJ5L8k/vPsxqUFK/9ekOA5POGPzyLpOwwovlJWnzy44gj0kV9DGVEzLtBPEMKNjYi3jSiLHJGc3ptaQnfoFBOehTq97TL00QtWdE7lYKpU70qq7P3ZnERct3fp9JIJTlPyBj1T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719792810; c=relaxed/simple;
	bh=WCQGy/U/ijeRU7bB8WVjAMraCypIXUqXckpAUc4zkIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2eFRqCR5/YhgJpfSbF5D8D5AO1mUjzBDNmVeDK3JH6HNVticrYNuJgijw7krUUna6bZaWsUPsbQkcBRFHTqw4ydauz2DQWeH7UPLB5MjoVpQP/Y5cRY8eUlN0S8NaK6X/IVX9QLNFWuWWNxehOOASJFvqkTwQqjsprr6hI9Bgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYPkihom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYPkihom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B7FC2BD10;
	Mon,  1 Jul 2024 00:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719792810;
	bh=WCQGy/U/ijeRU7bB8WVjAMraCypIXUqXckpAUc4zkIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYPkihomMICXtk1qBQPpoSOLswHs/kyYxj5HFOpnf9jWE9SfRJ08GwD8Jb3QTqRh2
	 MYX+wZoupO/ptLDb0zw47FlS2bSEXz0XFzXkfh2Qunf/sPAAZ8Jn9Ogd78otaqo+wY
	 kwtap4e1uj2e4upUYH0KH6useSzctzfTuh6FhbId5L04FGQ5IM173KwcbgTSQfOqM/
	 6kPCYALJDHiN6P2BCq8GFGAaFURR1Xm0UwAbBWVT1j5J4luQ7lm5ImV9xiwyy+Ns8l
	 nTXxUJxTRMxaYkqmBtqMRZ9FREPI8/0NFxzK8vfVd2FmRD+lpC1zqIeIZjLzfW5Mrp
	 hHuOyV44Ahd+Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 20/20] closures: Change BUG_ON() to WARN_ON()
Date: Sun, 30 Jun 2024 20:11:25 -0400
Message-ID: <20240701001209.2920293-20-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240701001209.2920293-1-sashal@kernel.org>
References: <20240701001209.2920293-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.7
Content-Transfer-Encoding: 8bit

From: Kent Overstreet <kent.overstreet@linux.dev>

[ Upstream commit 339b84ab6b1d66900c27bd999271cb2ae40ce812 ]

If a BUG_ON() can be hit in the wild, it shouldn't be a BUG_ON()

For reference, this has popped up once in the CI, and we'll need more
info to debug it:

03240 ------------[ cut here ]------------
03240 kernel BUG at lib/closure.c:21!
03240 kernel BUG at lib/closure.c:21!
03240 Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
03240 Modules linked in:
03240 CPU: 15 PID: 40534 Comm: kworker/u80:1 Not tainted 6.10.0-rc4-ktest-ga56da69799bd #25570
03240 Hardware name: linux,dummy-virt (DT)
03240 Workqueue: btree_update btree_interior_update_work
03240 pstate: 00001005 (nzcv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
03240 pc : closure_put+0x224/0x2a0
03240 lr : closure_put+0x24/0x2a0
03240 sp : ffff0000d12071c0
03240 x29: ffff0000d12071c0 x28: dfff800000000000 x27: ffff0000d1207360
03240 x26: 0000000000000040 x25: 0000000000000040 x24: 0000000000000040
03240 x23: ffff0000c1f20180 x22: 0000000000000000 x21: ffff0000c1f20168
03240 x20: 0000000040000000 x19: ffff0000c1f20140 x18: 0000000000000001
03240 x17: 0000000000003aa0 x16: 0000000000003ad0 x15: 1fffe0001c326974
03240 x14: 0000000000000a1e x13: 0000000000000000 x12: 1fffe000183e402d
03240 x11: ffff6000183e402d x10: dfff800000000000 x9 : ffff6000183e402e
03240 x8 : 0000000000000001 x7 : 00009fffe7c1bfd3 x6 : ffff0000c1f2016b
03240 x5 : ffff0000c1f20168 x4 : ffff6000183e402e x3 : ffff800081391954
03240 x2 : 0000000000000001 x1 : 0000000000000000 x0 : 00000000a8000000
03240 Call trace:
03240  closure_put+0x224/0x2a0
03240  bch2_check_for_deadlock+0x910/0x1028
03240  bch2_six_check_for_deadlock+0x1c/0x30
03240  six_lock_slowpath.isra.0+0x29c/0xed0
03240  six_lock_ip_waiter+0xa8/0xf8
03240  __bch2_btree_node_lock_write+0x14c/0x298
03240  bch2_trans_lock_write+0x6d4/0xb10
03240  __bch2_trans_commit+0x135c/0x5520
03240  btree_interior_update_work+0x1248/0x1c10
03240  process_scheduled_works+0x53c/0xd90
03240  worker_thread+0x370/0x8c8
03240  kthread+0x258/0x2e8
03240  ret_from_fork+0x10/0x20
03240 Code: aa1303e0 d63f0020 a94363f7 17ffff8c (d4210000)
03240 ---[ end trace 0000000000000000 ]---
03240 Kernel panic - not syncing: Oops - BUG: Fatal exception
03240 SMP: stopping secondary CPUs
03241 SMP: failed to stop secondary CPUs 13,15
03241 Kernel Offset: disabled
03241 CPU features: 0x00,00000003,80000008,4240500b
03241 Memory Limit: none
03241 ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
03246 ========= FAILED TIMEOUT copygc_torture_no_checksum in 7200s

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/closure.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/closure.c b/lib/closure.c
index c16540552d61b..99380d9b4aa94 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -17,12 +17,18 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 {
 	int r = flags & CLOSURE_REMAINING_MASK;
 
-	BUG_ON(flags & CLOSURE_GUARD_MASK);
-	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
+	if (WARN(flags & CLOSURE_GUARD_MASK,
+		 "closure has guard bits set: %x (%u)",
+		 flags & CLOSURE_GUARD_MASK, (unsigned) __fls(r)))
+		r &= ~CLOSURE_GUARD_MASK;
 
 	if (!r) {
 		smp_acquire__after_ctrl_dep();
 
+		WARN(flags & ~CLOSURE_DESTRUCTOR,
+		     "closure ref hit 0 with incorrect flags set: %x (%u)",
+		     flags & ~CLOSURE_DESTRUCTOR, (unsigned) __fls(flags));
+
 		cl->closure_get_happened = false;
 
 		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
-- 
2.43.0

