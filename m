Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689BF175D5C;
	Fri, 27 Sep 2024 05:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727416462; cv=none; b=j2G3iMvgXRpZCYUjwQ2fGPmnM/erd9NkZstqm17WXBcuRiyhsLKeqIMiWRPJHoZMJXg5YShfEMXal/QMo4WcPIbNeQNqfRVYeYTNza6Bbs6bi13uOx62nFsfZKiHxw+c5PLNvvV9sNydczd8pRlSKzUTfbLKSB+mlKydQZoit+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727416462; c=relaxed/simple;
	bh=21rOeuMWyci86tNah9ibRwCxMwI2ErAuGlKdNAI0jDo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tWpuql13SaIlhbceMDOlnOFJ4N8IodW4GdW/FSQUgFslDLUvT+bMRvVPcep4maACCX9O7eJUq19TOKhFj9aiqOknYyaPK5I4Nc8IU2ZAopYgIWT/eKRw7yxm8ekSqHQHrhV4fBMQAat7wRz4Htr33QZvXcOTlK6Vs4w6Lqqdwkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=GAF/FYc+; arc=none smtp.client-ip=220.197.31.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="GAF/FYc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=x+7q0
	iNAF8LoQw1qQBNKiDgLjE3xgT7R/4y/zLi7CZ0=; b=GAF/FYc+tccHrbjNxGHjf
	QR8jAQXYvymcaw5vREfx6AYDNIqbiu+TL1qud07RE2KvDHAuZoNAb4uUBdKYxVEm
	BD3awaXtbwtUx5I2LC1ctL0r8ASMoN0CtRqhweL3V0MzeWFlHwkBMwZxbfU7a0Ed
	iF356sofSA9PO2+Y/QYPGo=
Received: from localhost.localdomain (unknown [123.149.251.210])
	by gzga-smtp-mta-g2-2 (Coremail) with SMTP id _____wDXf+XsRPZm3wiQBg--.39077S2;
	Fri, 27 Sep 2024 13:38:52 +0800 (CST)
From: Zhao Mengmeng <zhaomzhao@126.com>
To: kent.overstreet@linux.dev,
	zhaomengmeng@kylinos.cn
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Fix shift-out-of-bounds in bch2_stripe_to_text
Date: Fri, 27 Sep 2024 13:38:49 +0800
Message-ID: <20240927053849.3740994-1-zhaomzhao@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXf+XsRPZm3wiQBg--.39077S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFy3Wr13CF48CrWrXw47Jwb_yoW8GryUp3
	y3tF1xGanY9w12vryjvw1UA34rJ3y5t3yrC3y2vr1jyFZFvw17Jw17tFZYqFW09rWxJFZ8
	Zryayry5X3Z5ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U-TmhUUUUU=
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbimh5nd2b2PTBShwAAsc

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

syzbot report a shift-out-of-bounds issue:
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
shift exponent 108 is too large for 32-bit type 'unsigned int'
----
Here s.csum_granularity_bits = 108, shift is impossible for unsigned
int, so modify the prt_printf() output to dump csum_granularity_bits
rather than the actual value.

Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
---
 fs/bcachefs/ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 141a4c63142f..2d5cd9d837f2 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -144,7 +144,7 @@ void bch2_stripe_to_text(struct printbuf *out, struct bch_fs *c,
 		   nr_data,
 		   s.nr_redundant);
 	bch2_prt_csum_type(out, s.csum_type);
-	prt_printf(out, " gran %u", 1U << s.csum_granularity_bits);
+	prt_printf(out, " gran 1<<%u", s.csum_granularity_bits);
 
 	for (unsigned i = 0; i < s.nr_blocks; i++) {
 		const struct bch_extent_ptr *ptr = sp->ptrs + i;
-- 
2.43.0

