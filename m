Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9918936B;
	Tue, 30 Sep 2025 05:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759209597; cv=none; b=g2wi88+9q1inU6A0+BHS0tGeUjQ9PT3yo+LHPFZmsPgqucnkMbTeG0zMTHkVHTRBiYrdy7AdCcc9iARnQYCS4EYvvW441I127oKck8f0Vf1fmSOxlvEHsLs8TcD/Yr+0GN9lTIDgiRfufYwDpJevGzwgmvPngfLUHxRdFZu9DIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759209597; c=relaxed/simple;
	bh=DuklGLC7UrBKTu5wUD8KeFUFj4Z623WIfI+Jr8pXq+w=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=DxLBPRiItFdpKNq8RML9iZPP5sSkA1s3CV1667RaWxgFQSRfdRYdA8UDaglh78zy+E+OCzx+I0pkBBY4Vm/mBdErUIvtgXe0EFwRiEb4JR1gG5FqaSu2DenuURTG424+2nwFLripHyPXwCIBzaW/kHx4ua9YBXxJZlg4lnUXEJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=kQyLhnqb; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="kQyLhnqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1759209583; bh=kSgALnXA4MtGBcy4oviW1G3MNZ7IQrar9mHUOA6xBMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQyLhnqbB16KWkfW0kFXVQLUnGQyI6TFAXA/BaSJ836p0FTI8GCFBq5GSUO4Zt06m
	 v51PGsVBjC95sSnuVCiUMbQAfhzipeN6OhmlzT3K25HaC2WWy43YEEMPQoX0QB6qZ+
	 xP/2AC6+JbAlEBQsEQgxGxI3jLVpZsZXN5OADJAw=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 2D31D285; Tue, 30 Sep 2025 13:11:19 +0800
X-QQ-mid: xmsmtpt1759209079tovwnj446
Message-ID: <tencent_68D8E912EEDECFF079226E202DFD6E70950A@qq.com>
X-QQ-XMAILINFO: NvH2zBBgt3uTVGnr+yr9M7FKbmm6i9aU+FQH6/3Az0sC7FqSuDge2y95JkZ6Pv
	 1Jqf5Ep2Z7nwDPKqzrF0W6EIjdM0z5e0PSq4yFrxcitZSlnLuQxG7ctbDNlZxYlnTa83vOs570dn
	 Tz0iKXvrewwxAIdW9nOzmpMyuHF+1zyi1j8EZ+2QNMAi8vGnLCdn2OA3VmqtHiUrMOn1FEI4lpkc
	 RFYb+cYThk5u8xwyuY1GKqNrSDs2xCIwq1TXJxDU9rYgEBJCiMWajveSoP9072zpsEG5/2CAEfbN
	 gp8xh4bL5x/48lL4GuHAIGvU3ys3MOQ4w+iAVME5R0RhFlAenpqfALAHm5EcLYuLpOLvirNuoKGa
	 52S+PS0lEaffKx7vBohoxBr8WT9iVtaP0wJNmG2YOmbJTcWTOHTafBL4hyNlPmnMUmWZ+tazcRly
	 1BnRkLL1JC3m6k6ZaAo4P1zk+oSZwHL/MzaUrOVE8VfQ0Rx8b2h7vpnxmEoKz1EPS0Gc5NjxhT3a
	 Dv68GBwIrzVP5awzMMcET4Z+jPEJZ66KgnzStq5u99dK/m6rGewD88Jwfe4wsWCobB/E3ZHKAoNj
	 tfOkr4L/ieHAs/GOmruSwGqO1bgQMxlrSZR/IhgONTEkr1HEnwnjfH8LqL+Ju3O1YB2Qoo6O0QPc
	 0kCV63+aYLv9wvMU2BFBFHmkVL8n4gmOg3CqD2NTaO2EGWf2leE5lsnNfNj9awljNLECMtV2YpX+
	 klvhNG9M5PjQdYa8te7XQLB+RwYrhiyHJKLon86Yj61NQmN8hqRAVqC8hCBSx/EIQlAGv/wljIeu
	 3IoN4NYjdsYSNFkiVOEzatbYvpohdJcbOodxLMjXxpg4Uk04ZpL9CSQ0vpwbs3SN/vUCCYUOncG2
	 YTiwYpF20sjyi1cxmZApysgdEYpTBa6n7bVFz7+zjfYyGlv4nHtLMZY459WBGRNwGcNpDzu37I9x
	 e0cxr/0C/GCa/hHuxNaBPI6eqLHqm+5+kRpNdLuEkbvrIirNE8xMoCuOvMgWBT
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: Prevent written from exceeding sectors
Date: Tue, 30 Sep 2025 13:11:20 +0800
X-OQ-MSGID: <20250930051119.455435-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <68dad4bb.a70a0220.10c4b.0086.GAE@google.com>
References: <68dad4bb.a70a0220.10c4b.0086.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported btree node oob in bch2_btree_node_read_done. [1]

Add sanity check for written, avoid exceeding the allowed access limits
for btree node.

[1]
BUG: KASAN: slab-out-of-bounds in bch2_btree_node_read_done+0x950/0x5550 fs/bcachefs/btree_io.c:1128
Call Trace:
 bch2_btree_node_read_done+0x950/0x5550 fs/bcachefs/btree_io.c:1128
 btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
 bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
 read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
 bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808

Reported-by: syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ba71155d3eacc8f42477
Tested-by: syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/btree_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 590cd29f3e86..ab14fff1452f 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1087,6 +1087,13 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 		     "bad magic: want %llx, got %llx",
 		     bset_magic(c), le64_to_cpu(b->data->magic));
 
+	btree_err_on(ptr_written >= btree_sectors(c),
+		     -BCH_ERR_btree_node_read_err_must_retry,
+		     c, ca, b, NULL, NULL,
+		     btree_node_bad_magic,
+		     "wrong written %u, btree sectors is %lu",
+		     ptr_written, btree_sectors(c));
+
 	if (b->key.k.type == KEY_TYPE_btree_ptr_v2) {
 		struct bch_btree_ptr_v2 *bp =
 			&bkey_i_to_btree_ptr_v2(&b->key)->v;
-- 
2.43.0

