Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E02018DB26;
	Wed,  1 Oct 2025 00:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759278310; cv=none; b=FymzgtzB5Pvz4t4znaOIJ0kqFGxm6Nw31Baya8TPaVsJDPWMOqzFQp6OY8J7UWGxt/1APTggD8vkMGx1JhVm1i7yL+P74Hy/jhLBe7WxcaiQjav6cd6jAvXTSe+RZVaZVd2L4eBlITYHuigyaF8gkjfPoys0jpD5z5EcvBCWvg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759278310; c=relaxed/simple;
	bh=bq4yFxx1HYQIW2bfM3PlOQWATujxdL6DB7bogzXV3p0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=nkMFe5Hr5qLd/a8u1t2wU0zPi71jwJv6p2hbHznMNhAAjp9XRc+sOfTqak9j1yyawit/nbIJDsplj62rUMlqVN3OPpOWpzjssT8zplqhcOKwWvz1GpmchuPuih1BzAvBz+V2ovS516MsFuFD2xSXc6YVlhMjBaO8B4J50WFM9kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lYLR4hCZ; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lYLR4hCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1759277998; bh=qOEFdnGNyH/+56s3eWv79VZSXfiYDJ78DUr6/PPdkwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYLR4hCZWf93/fAzcFysWP8xYTS26Bbz3mjjtS33rrn54bjbLr+BEWNJrI264DDXl
	 0La6cd3QrMWPnfz+xcedZJ31J5WXyO6FC5yRSNQSvqe0Szghgd3NGn6y6CjMF6SfUG
	 g73teYayx8LABTnTkrw97ZlPjKSYvpN2/OPKV1jg=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 4F793E47; Wed, 01 Oct 2025 08:19:55 +0800
X-QQ-mid: xmsmtpt1759277995ts7e8m12j
Message-ID: <tencent_FF701BFF4BB31BF8255CBAEFBB9033779E08@qq.com>
X-QQ-XMAILINFO: NvH2zBBgt3uTiE2eZS5Fne7onYDpCzE+1Poxhq8IsKDO+pP3+IlKZaSJlYZHQ3
	 XawgWJVQljiwoIa0HK4CtnObZ5jFT2kXzTzGpNHEALhxyEcl2wdlxt25ZyUon78hfsXTr5rJtwJy
	 AAIpQ/32aGthJwo4F1BuZXsK0b9ErqMZhYdnx5rs95UXXMPkOss9i5Q3A52i3Dw14KwD59f+aW9K
	 NcEUs0BxocyJRJeIIojwwBj/hUyNdv/G5rpIcmkakURiwk0dkFCjNQpl7N/Evl12fmVpGu9b6UsT
	 jqGh20jQpFntkcFwGzP4fzgGDwqbYpHwUDKZx5SkrN2cV9L9O6zxutiHlRm6fhmcKv+Qb8V7Jd3k
	 JswvNAzM3PeKUiYV4Ii1yjKDuMlDuvITjgPCoFK6pH2RZThlc8qUaFj7xw0n6HUSZwQ9XPzAERLo
	 AJuCUvdmZ6MELWYSOgBIsHqtesa/vBQgOn6yamw2Yb0glEDpeLTm5DRThqtnNT2nPUpep+oLG/il
	 FYub6NtgIXHwsngSfxlGELfjQtPmlo3uiRrk+6hIWGvKVCVT7k53SxLDnqF+KvlJOuAyaNIN/8us
	 56z2gdV/bbOviPQMMgPKJGaXJRhTbgoCMh+UkNYyZ8mBDRZ75EZEciHFBsUO6EAZySs+ygK9aZ8J
	 SPddTMU7zftzCxzOyshPz8VYNFukyH7/3BuEaqayFrbJG999aGVGeSsC8E58z8ugkfQ722qWPY5u
	 0kL0eqJhBgqtIWY1FPMKjSZEy0i6ca4JYUN/ms7pNSYP+BqAmbamLT0xcPjn9kMnUI5zqrIcOMt2
	 gZyV2721Y5ay+8ETDAopJQMggYjHXol3IfoLjCa5eyJ6ch8WlpkG6sKoExoX0KtnrLmQTJU/InDD
	 k6ChxFkXFA3e2G23HnszG1m9o0tKWjfZD7XdFHdz7sCZDb0dumeN8QtYCDOghSZrBQ1A64J0F77V
	 zXVeVJX3LJKglDcIa5kcLyoIILoBc6pbdqCs4eKn/wENoQLIfMXhBnLQbJ6k/5gQkUDkJhguA=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: lkp@intel.com
Cc: eadavis@qq.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] bcachefs: Prevent written from exceeding sectors
Date: Wed,  1 Oct 2025 08:19:57 +0800
X-OQ-MSGID: <20251001001956.1053529-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <202510010446.t1B7jtcS-lkp@intel.com>
References: <202510010446.t1B7jtcS-lkp@intel.com>
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
V1 -> V2: change msg data type to unsigned int for btree_sectors()

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
+		     "wrong written %u, btree sectors is %u",
+		     ptr_written, btree_sectors(c));
+
 	if (b->key.k.type == KEY_TYPE_btree_ptr_v2) {
 		struct bch_btree_ptr_v2 *bp =
 			&bkey_i_to_btree_ptr_v2(&b->key)->v;
-- 
2.43.0

