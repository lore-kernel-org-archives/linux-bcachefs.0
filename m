Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141A32236F2
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739381364; cv=none; b=K5L8cxYEBjTndz+ZhEddJQP1dmOJ9QUGbgxVCfmejqYIJFuak7qWrWD11crbWflQfPyXIYPidliP3axn2AmX560eqc5jPmhGffN/iBa0B9PvV0ppr0jKUftT/YrU1d8tTzYlDkCwxnrsie0GTskkjLr7HUwg6zOBMmLeKpdTaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739381364; c=relaxed/simple;
	bh=9Fr2CBSaxAVVT9oKoky2JSAyl+VjecAgvEJNhEsqhkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=imw6JdTcNSIYxfwQ0/GiruS7I7ajoSq5I3JzKWa4SACI+M23INA7TQn0AR8j3xRGtgNE+bRUNUIJVyY7caurkECUQyqaXdUh2iNMrYSXRuSwWr6d5NCvTduyRvD0UZiHpfzsIxyiM7RI9z8F3OwcMY8Zam5acwpuaaCPlQmZMtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kv2v5Nng; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kv2v5Nng"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6e41e18137bso261526d6.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 09:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739381362; x=1739986162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YgH1Nx9d5kXk3xnm+Qo8x93zpK0KGSpO+HHNXSup7bE=;
        b=kv2v5NngVK9vwX9JEBrXN8ivA8WohJbXQAr3gQ62STEpolza7q1VDqOsKG3Dx5tnwu
         GYoe9xeHC2pnoP7YgvnfORCbeMtjpiB0Q+be50OrqEFd41qQcxnIgWtdI71kN6YsFiE1
         ytOB+uv7pSZ1kQKT1v4Qi3EgOl2OxNX+jIrrFIpRfJjt0d4PO32KfFpfkdYZ0zuQYa30
         jOGss6MQpEnXNSH9KxHCzHtkaWoLSBfdLt6vU5Ca4VH0eGhj7lan0X4JoB0EqmPOg3fq
         JjVgV6k/1nUO4S468tVIb5KBuSxAOxuUh5Zuzzzr5xoWJy3JMyaqV+EB3TX/lXjryJlP
         1L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739381362; x=1739986162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgH1Nx9d5kXk3xnm+Qo8x93zpK0KGSpO+HHNXSup7bE=;
        b=srvDWXoTLwvUqQIZzrM09UEx7tuo9SrtRNUXRNCohiWC/oSy0IyNZLpwBooh+6CP/o
         Jz+6kFEwjZI3AUe/3ZAHv+3JSmDg6fUVFqUhhz6BVouMud+t0K+O3iKY8Pvik//oo5Tq
         gb02GVB6CIHOqxuPOYoMi2QJPfEsx//v+NJ5qaYEMXlxj7Lz1vVoALOTyhlkwOT5b7pu
         M7B1xWs9YfU3oRbjVC0JyqjFh8pI7XZSpEcxWBxu6gd5Ac2Qft8OfJQcK5x7XF3Htj4k
         yUlRAoMv2YlYqtNYWEBY1Cloau+7xkqwlxyNwOZW7wJ0+GTads6I3GGZ55o2xd+WB4Nz
         qV6g==
X-Gm-Message-State: AOJu0Yx023At9iLMGoUksMeVI+iGbUPgxqjYhQqNv5uEtk+J7TM1QKya
	mO6msp6BV0n7WYomNZNziKQBTan8NSSV4TuyYhW1+Q+0cmz66QeU
X-Gm-Gg: ASbGncsJVtgtOooJu0+L+oybrDgvRJR2S7eJNTiazoypTh6FdSH5YjJlZ/7TWg5URJ0
	D3QuNN8K2b2pL/fR4R6Zz7dPcB5KtLE2w2LpjUIzqvlgOjy/5AlUy8z8ONO2I3LfJL1wohvIgw0
	2NULXon8fWKRlxnpe7121jipg+s+a+gJR+nflYWp0BWdAdwQSwQNnlC4jSXOC6Y6gxPdB3q8YUr
	Jl4DmZ97xqLRF3ruys4uWYvJT4ow8TqWekQM84UvvvJ2opoEb2oO0rwZMR4f3tV6g==
X-Google-Smtp-Source: AGHT+IGy/n80o3MxJz+rWFax3B4S9ETpedkbfd5yjqq08xqN5icQKvWKS8z/96hv/uyky4sGSbhA7Q==
X-Received: by 2002:ad4:594b:0:b0:6d8:8f14:2f5c with SMTP id 6a1803df08f44-6e46ed8ae6dmr71354106d6.23.1739381361709;
        Wed, 12 Feb 2025 09:29:21 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e4605dbff4sm46135846d6.110.2025.02.12.09.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 09:29:21 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Reuse transaction
Date: Thu, 13 Feb 2025 01:29:16 +0800
Message-ID: <20250212172916.137891-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch2_nocow_write_convert_unwritten is already in transaction context:

00191 ========= TEST   generic/648
00242 kernel BUG at fs/bcachefs/btree_iter.c:3332!
00242 Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
00242 Modules linked in:
00242 CPU: 4 UID: 0 PID: 2593 Comm: fsstress Not tainted 6.13.0-rc3-ktest-g345af8f855b7 #14403
00242 Hardware name: linux,dummy-virt (DT)
00242 pstate: 60001005 (nZCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
00242 pc : __bch2_trans_get+0x120/0x410
00242 lr : __bch2_trans_get+0xcc/0x410
00242 sp : ffffff80d89af600
00242 x29: ffffff80d89af600 x28: ffffff80ddb23000 x27: 00000000fffff705
00242 x26: ffffff80ddb23028 x25: ffffff80d8903fe0 x24: ffffff80ebb30168
00242 x23: ffffff80c8aeb500 x22: 000000000000005d x21: ffffff80d8904078
00242 x20: ffffff80d8900000 x19: ffffff80da9e8000 x18: 0000000000000000
00242 x17: 64747568735f6c61 x16: 6e72756f6a20726f x15: 0000000000000028
00242 x14: 0000000000000004 x13: 000000000000f787 x12: ffffffc081bbcdc8
00242 x11: 0000000000000000 x10: 0000000000000003 x9 : ffffffc08094efbc
00242 x8 : 000000001092c111 x7 : 000000000000000c x6 : ffffffc083c31fc4
00242 x5 : ffffffc083c31f28 x4 : ffffff80c8aeb500 x3 : ffffff80ebb30000
00242 x2 : 0000000000000001 x1 : 0000000000000a21 x0 : 000000000000028e
00242 Call trace:
00242  __bch2_trans_get+0x120/0x410 (P)
00242  bch2_inum_offset_err_msg+0x48/0xb0
00242  bch2_nocow_write_convert_unwritten+0x3d0/0x530
00242  bch2_nocow_write+0xeb0/0x1000
00242  __bch2_write+0x330/0x4e8
00242  bch2_write+0x1f0/0x530
00242  bch2_direct_write+0x530/0xc00
00242  bch2_write_iter+0x160/0xbe0
00242  vfs_write+0x1cc/0x360
00242  ksys_write+0x5c/0xf0
00242  __arm64_sys_write+0x20/0x30
00242  invoke_syscall.constprop.0+0x54/0xe8
00242  do_el0_svc+0x44/0xc0
00242  el0_svc+0x34/0xa0
00242  el0t_64_sync_handler+0x104/0x130
00242  el0t_64_sync+0x154/0x158
00242 Code: 6b01001f 54ffff01 79408460 3617fec0 (d4210000)
00242 ---[ end trace 0000000000000000 ]---
00242 Kernel panic - not syncing: Oops - BUG: Fatal exception

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/io_write.c | 33 +++++++++++++++++++++++++++++++--
 fs/bcachefs/io_write.h |  4 ++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 0d4a7e58251a..738bdbfbdb14 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -396,6 +396,35 @@ static int bch2_write_index_default(struct bch_write_op *op)
 
 /* Writes */
 
+void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
+			       struct bch_write_op *op, u64 offset, const char *fmt, ...)
+{
+	if (op->subvol)
+		lockrestart_do(trans,
+			bch2_inum_offset_err_msg_trans(trans, out,
+						       (subvol_inum) { op->subvol, op->pos.inode, },
+						       offset << 9));
+	else {
+		struct bpos pos = op->pos;
+		pos.offset = offset;
+		lockrestart_do(trans, bch2_inum_snap_offset_err_msg_trans(trans, out, pos));
+	}
+
+	prt_str(out, "write error: ");
+
+	va_list args;
+	va_start(args, fmt);
+	prt_vprintf(out, fmt, args);
+	va_end(args);
+
+	if (op->flags & BCH_WRITE_move) {
+		struct data_update *u = container_of(op, struct data_update, op);
+
+		prt_printf(out, "\n  from internal move ");
+		bch2_bkey_val_to_text(out, op->c, bkey_i_to_s_c(u->k.k));
+	}
+}
+
 void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64 offset,
 			 const char *fmt, ...)
 {
@@ -1214,8 +1243,8 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
 			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
 
 			struct printbuf buf = PRINTBUF;
-			bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k),
-					    "btree update error: %s", bch2_err_str(ret));
+			bch2_write_op_error_trans(trans, &buf, op, bkey_start_offset(&insert->k),
+						  "btree update error: %s", bch2_err_str(ret));
 			bch_err_ratelimited(c, "%s", buf.buf);
 			printbuf_exit(&buf);
 		}
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 2d12ffb94736..bf942566a8eb 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -20,6 +20,10 @@ static inline void bch2_latency_acct(struct bch_dev *ca, u64 submit_time, int rw
 void bch2_submit_wbio_replicas(struct bch_write_bio *, struct bch_fs *,
 			       enum bch_data_type, const struct bkey_i *, bool);
 
+__printf(5, 6)
+void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
+			       struct bch_write_op *op, u64, const char *, ...);
+
 __printf(4, 5)
 void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64,
 			 const char *, ...);
-- 
2.47.0

