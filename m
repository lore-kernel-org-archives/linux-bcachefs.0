Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6DF2046A1
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352491; cv=none; b=Rqu4baBK8PVRetI7dv8OqLEtrE1yTpa+BC7In2If1bV43xwEn+kTgSmatF8CAR4gND59wGxA9Wqek+E2DMHDh+Zsvn+ibDEne742CDdQORvPE3/piHKmLwB2h+v+uhneu7/yCrCmzvW9SiFcmHb0vNq0lmJPuLK4t64C7Vr5kUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352491; c=relaxed/simple;
	bh=9emDWYG0WkVi8DI+5O/qFqyhmyROUJbvmgFcdV080no=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E9V35S/qyGLU//o6nENHZxYZIEynJKv3DWOA5iqOTXKLdF7gd5MQ692De9vQ2pR/rz4qxgfBXkPHQ7Lscsv8ExtB8U9AqH0DxezR+lXVIFwrwNQwq3Boj8zg9JGdtDMMLrHn/CdNK9DBSpk1ZRiAwrzb/HXTiQ68OKNpJa2nmyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FEzGA6RJ; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FEzGA6RJ"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6e4468b7099so57716816d6.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 01:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739352488; x=1739957288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K8JUNe2k6v019JleHlSR+PZR5jhqD9n3Nov4ZwA5ohA=;
        b=FEzGA6RJOmMlL7O/Eb08crYuNSMK3LeTB5GSdYg+na47SeRh3ez+HpRXBcUGeJi3vE
         hTvfForrzUqg/3dcO1GqSnuS/MRMq3lISq6+it0Wij3uVyuEN6cjf85NpeYn4UM+cFo6
         3+U4DNt3x1HmAs1cM+MKOJW1tT9KY4I0EpJKSs6oUoLB/bK4HSz/o0UKPaYVUMErhJhO
         ga0GDmzSzromkDbxyWqaVbxgVhA3Rbo4Xbfva0SpZ9IyJnSZEY29jQHeOKFlh6mStlSf
         98vYJUbkf+cuueovPRi83E6SZeJr15pNMyx4J/xMRoXjsGjhWfWzbUfnkz02RCTmASaC
         BJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739352488; x=1739957288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K8JUNe2k6v019JleHlSR+PZR5jhqD9n3Nov4ZwA5ohA=;
        b=JxfQGGtGJxyu2yXAEMC0avos/34AWAgxxWE/YRth4+ulTwa/UQPBnNBJFb6jWmdU7t
         ft4Gj2fL20fZdEveAmUFUqFeomWK/bn130EBLn59vbycRif3JPXg0KXqkv/obPS2+Nw7
         StbaFMlLbxMlV8qIvpWOa5lkA8bZTlgEzhLaZZVHBfmAKPA/TNUZGH1WBqsAQpDozjjq
         a0zfGt7wU+vAQD3tnq/VujLpAjt2XsK6PVD1ToIbOmmU0I4owdBND1tZHHL4ONuEyPx8
         ZS4ot8/jaHo3RJsmE9zLPWuz012vT8f8rtxqnRHqz3OxuWbQ+H1t+pmklrJt95/P15nu
         gzZQ==
X-Gm-Message-State: AOJu0YwizyVheyIzPl60+Xu37wthBol1Xi+5o7BXgR1hDAjXcpJBEJgP
	DK2b+I2KcVP6mnKoCcByKohyD0Iqp+FEFjhMu0AlSMOjfFBCsBpK
X-Gm-Gg: ASbGncvGUFvNC7eqUTtKKmWlay5HeKKL6RraQr+NKdRTRQ22VT+D8F3OiBk0J3CAShe
	4F/MCLO1wNDnHG83zjdTRmn7hK8NKGFO9UubXx/jJr6WJgTkVz6JIUQwUJBsnD/g2VnPZFEzxhY
	2QbkS/VEOBHCR+I8f4mcjq6Sd00hqJUjFKBGRJndIC0Pg4j1yUiLDt0pDfnt35mGtCFvsn7x2F+
	yBC9kNvzCPVXpNQ3hswYj1TxuZ0Qxq/ppc/Qo/ou3DhMpBacfgu9vHDCcR+FsMoTg==
X-Google-Smtp-Source: AGHT+IGdgGvfupJxv3z5QL15Q76hncZIpmPCzl/i+0zUFztM8mCuLi3G9t3+aUAA+ss/KmPtWT5Wmg==
X-Received: by 2002:a05:6214:d4b:b0:6e4:2872:45f5 with SMTP id 6a1803df08f44-6e46ed8a944mr46347076d6.25.1739352488345;
        Wed, 12 Feb 2025 01:28:08 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e453819913sm55166766d6.16.2025.02.12.01.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 01:28:07 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Reuse transaction
Date: Wed, 12 Feb 2025 17:27:51 +0800
Message-ID: <20250212092751.52241-1-mmpgouride@gmail.com>
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
 fs/bcachefs/io_write.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index d363a6e730a2..16618bbc46ce 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -406,6 +406,16 @@ static void __bch2_write_op_error(struct printbuf *out, struct bch_write_op *op,
 		   op->flags & BCH_WRITE_move ? "(internal move)" : "");
 }
 
+static void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
+				      struct bch_write_op *op, u64 offset)
+{
+	bch2_inum_offset_err_msg_trans(trans, out,
+				       (subvol_inum) { op->subvol, op->pos.inode, },
+				       offset << 9);
+	prt_printf(out, "write error%s: ",
+		   op->flags & BCH_WRITE_move ? "(internal move)" : "");
+}
+
 static void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op)
 {
 	__bch2_write_op_error(out, op, op->pos.offset);
@@ -1193,7 +1203,7 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
 			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
 
 			struct printbuf buf = PRINTBUF;
-			__bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k));
+			bch2_write_op_error_trans(trans, &buf, op, bkey_start_offset(&insert->k));
 			prt_printf(&buf, "btree update error: %s", bch2_err_str(ret));
 			bch_err_ratelimited(c, "%s", buf.buf);
 			printbuf_exit(&buf);
-- 
2.47.0

