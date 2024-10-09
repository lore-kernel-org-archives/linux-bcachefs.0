Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BCC2AF1D;
	Wed,  9 Oct 2024 05:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453546; cv=none; b=AH9mTaaOXJzso9gB/aNhTgn0ef5ZRh/z5HKXPRjBBr6jovCUm7TGBuVQMIyS6EWFNxysOmIsugr/Vbj6466YFOgJ1JdNYuCqs6SdDIoRSl/633wan17ke+pqvnaEYYm1wEPJYspJNVXJnuOFE6sU9OQqT3UhF3x5l+F5pW+BMQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453546; c=relaxed/simple;
	bh=fKfUy0cg1zAwSarzk7q5hw4n86dEih8UksVoAgIT0t4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pMIk81ty6RlQILfkM5sRpr+tZoCVCnRjQGrgMJ+DR6NVKRQ88/zcMScGrxZw+BpZnnkylrNmsPwaqUhsX5pwCfKpN0H6jtRehB0dFShgR+1eEcjqGENu85dPxiCwk0f7jyx51VMeI/PFOxkMRtOLPlvLXMq23ypcwR8hFslLPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=leyVQejR; arc=none smtp.client-ip=117.135.210.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="leyVQejR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=MmpSn
	LkXYEOfi1Rg4Kx4z9fZ134udGn2F6e6pjgL6ro=; b=leyVQejRy0odVUKqUFriU
	1JRSUiXvTK1p4PlTIYUXzejYtldsx8JrGsYVSpr0/WhbtnQ24lrc0rzt5qkRG+1f
	FaWFqiOp6LDvhYT6LO8kQts9FRh4SR04ZJoNjEd4SqnpZ5mdHYciPxbcq0oQaaVd
	jxca/3GwnLmJ4uFQ2U7ovk=
Received: from localhost.localdomain (unknown [1.198.30.91])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3X0sAGAZnkCkFAA--.15931S2;
	Wed, 09 Oct 2024 13:43:28 +0800 (CST)
From: Zhao Mengmeng <zhaomzhao@126.com>
To: kent.overstreet@linux.dev,
	zhaomengmeng@kylinos.cn,
	lihongbo22@huawei.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcachefs: Fix shift-out-of-bounds in bch2_stripe_to_text
Date: Wed,  9 Oct 2024 13:43:25 +0800
Message-ID: <20241009054325.438556-1-zhaomzhao@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X0sAGAZnkCkFAA--.15931S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFy3Wr13CF48Cw1kGr1kuFg_yoW8ur4rp3
	yfKF4xGrWkuw42yryUAw17J348G345KrW3Cw4Yq3W5ZFZI934UGr12qF93XFW0yrW8tay5
	Zw1Fyr15XFn8ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UweOAUUUUU=
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbi6BBzd2cGE+I6GgAAsM

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

syzbot report a shift-out-of-bounds issue:
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
shift exponent 108 is too large for 32-bit type 'unsigned int'
----
Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
int. To fix, add a check in bch2_stripe_validate() to bail out, it has
same checking logic with ec_stripe_key_init().

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
Suggested-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
---
 fs/bcachefs/ec.c      | 6 ++++++
 fs/bcachefs/errcode.h | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 141a4c63142f..bc5ff1331c6f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -113,6 +113,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
 	const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
 	int ret = 0;
 
+	if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
+		bch_err_ratelimited(c, "stripe csum gran bits %u too big",
+				    s->csum_granularity_bits);
+		return -BCH_ERR_stripe_csum_granularity_bits_too_big;
+	}
+
 	bkey_fsck_err_on(bkey_eq(k.k->p, POS_MIN) ||
 			 bpos_gt(k.k->p, POS(0, U32_MAX)),
 			 c, stripe_pos_bad,
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 742dcdd3e5d7..14ba6bc7a029 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -258,7 +258,8 @@
 	x(BCH_ERR_nopromote,		nopromote_no_writes)			\
 	x(BCH_ERR_nopromote,		nopromote_enomem)			\
 	x(0,				invalid_snapshot_node)			\
-	x(0,				option_needs_open_fs)
+	x(0,				option_needs_open_fs)			\
+	x(EINVAL,			stripe_csum_granularity_bits_too_big)
 
 enum bch_errcode {
 	BCH_ERR_START		= 2048,
-- 
2.43.0

