Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B1C1A00C9;
	Wed,  9 Oct 2024 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488335; cv=none; b=uyqnmHxwnKn4AGNtrqILeN8PeKVx3vJcE/pHKQ0PSybHzwT5bW1Ek1X2N617a8hlxZ5qTfpatTTb45o8QiDWJjeDkAZkWYbDvy6C7B76Cbne28j25aA4b5esDePfnSeM1s3YIo7bfVXHkBSIDvDcd4XGW1vuWlxcLjxSLnjvNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488335; c=relaxed/simple;
	bh=CpHDIofX8IuDq2Rqrc+T1cYEiHetNnbosu7d/9ERJ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DT6uqYw05kThlXhi6ZF5xwl0cHJna9aYYYQe++UN+LPbI2BGQicZ17mjrast/lG18XM6XxWr2ql0ttK96uBvXHUP9ifmIn8Y75dVrnU5JSFSp5qH3H9S1W97wn6qe5ouYNrhKW09WjMq6wDmDngE7VdrfsQmGUFbNVA55/jP6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=LJDB7LgX; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="LJDB7LgX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=A/LkJ
	/OjEIQAsiNGfrhwR/O5Vcm/vxghw0XRfSkCdyE=; b=LJDB7LgXqynT/jXKG4OIP
	YeDjWMaOiJPNn1A/qeJAu/y1CzVXH3csD0FnseyU/+3jir0xBFzLNo6HK3zCgTIK
	HNzOw3Go+Pib43tisBTmduq71vJTjZEshf7T8dCiMc9X/vc5x2yD5sfc3C6HLq+9
	TOsPqbLHdkRGqC090HpMGQ=
Received: from localhost.localdomain (unknown [1.198.30.91])
	by gzsmtp4 (Coremail) with SMTP id qCkvCgA31o8+jgZnCNzKAw--.43236S2;
	Wed, 09 Oct 2024 22:07:59 +0800 (CST)
From: Zhao Mengmeng <zhaomzhao@126.com>
To: kent.overstreet@linux.dev,
	zhaomengmeng@kylinos.cn,
	lihongbo22@huawei.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] bcachefs: Fix shift-out-of-bounds in bch2_stripe_to_text
Date: Wed,  9 Oct 2024 22:07:55 +0800
Message-ID: <20241009140755.725629-1-zhaomzhao@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qCkvCgA31o8+jgZnCNzKAw--.43236S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFy3Wr13CF48Cw1kGr1kuFg_yoW8ur43p3
	yfKF4fGFZ5uw42vry0kw17X348J345KrZxCw4aq3W5ZFZI93y7Jr17tF95XFW0yrW8tay5
	Zr1Skr15XFn8ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UFtCcUUUUU=
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbiEBRzd2cGgACUFQAAsg

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
 fs/bcachefs/errcode.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 564841e5a24b..f6a02123144d 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -114,6 +114,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
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
index 26990ad584d5..83659cdb93c8 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -270,7 +270,9 @@
 	x(BCH_ERR_nopromote,		nopromote_enomem)			\
 	x(0,				invalid_snapshot_node)			\
 	x(0,				option_needs_open_fs)			\
-	x(0,				remove_disk_accounting_entry)
+	x(0,				remove_disk_accounting_entry)		\
+	x(EINVAL,			stripe_csum_granularity_bits_too_big)
+
 
 enum bch_errcode {
 	BCH_ERR_START		= 2048,
-- 
2.43.0

