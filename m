Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792766967;
	b=hIuQegasmNdd7ekxFsFIdOfOi7IfRixo17FVNg5mt837M+rNeuTh4joK0HYpyz0nV1AE
	 m/x1oRHXdQuz9GOFpPy/g6MTCfB9XlFn+zYIQyYnOEpUahN29YuHxj+hsLizFBPLPFtRG
	 5mzPbgrsWazyqElOnlRfGO3P5DpbZHgQ5gBfqkY3bP4NVHJHPc5RV8tAtzcjNyU9+vlSo
	 EBYebAeF0M2SXs8Gr2LQ9gkjF6izVgRZWX8eUBgc9Y2Bj/Ezv+e3rZV5CiqZ19wfan/AO
	 BF1VYeCi3menwvDXCuQSTyQIbPBRR+WqjDL9dfR6J8aRCn9PIviqe38UOTaDkFgS1hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792766967;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=CYzMEAHApivYCP8/exvzfI2CA3vBzZ00qpCpnK0G8Y8=;
	b=CbAyR8CvjHc4sqa8W6o/6MLqOWankkWLqi5qRyB/D4+TH0BEHmI20yZmA6/bi5WhdLs8
	 mH6jjkoLvVTD+IWMtA8NJIicPUPy2NSvsQHtuyb4NUlouokf11OdEtMSOPTDfSCo7nuLQ
	 mT7CKMk5zd9kdwgZrUVFXThSduc2txa6/gjJceFF7hQbA/lY14JE1MObFbIheILBe562Q
	 4JcRtdB3wVgGLx9VdT2aG4aHlbuUmemoIrk2WkW6yDc0rb4RWMyGm1JGgZvGu6Qp3Prcz
	 tgTvGocvp7KlQ0youYdFyd4RJnaCtq91n3L7hrbTzCKlP7+WeQVVwGxjG0VoHqVHHPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=AMeYNR7+;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C19606A31B;
	Fri, 23 Oct 2026 14:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87C19606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=AMeYNR7+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1792766957;
	bh=SyZaUgV/c3CuArgpdL0JMROnvDgkuW0JU2NShYNaV9Y=;
	h=From:To:Cc:Subject:Date:From;
	b=AMeYNR7+BfMAp0d9bly7MVr8nRgEc80IJlsaEBat2dwNAu5Wk7BtwLG2phY0uNJcQ
	 9Qtgu6vNvfQ/7EC0L+pljicNidLHwKAwYvEFqQy6R8vRORZ2Q+JO1SXrpuEYP24v4m
	 JKsrIeRLx/rfi2Ti/UgruEW86Jkk7MmwJ5rZzFxc7R6ZLZ4KF6k0ZZvprs4OFz4AB5
	 luP6VFhq+rU1UAfj1S4uIlw6t+50D+mkwiw1SVUi3U7tXxyCIDYsXhDhK9VZUNTOb/
	 9F7g8kUjBc+8qpEAihKQK+0MpEtkiDtUy7d8dQpN9n31Gq+/HfgK8YrNR8njT1FfgM
	 T/xnIU75fw8MQ==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 40C9F25AD9;
	Fri, 23 Oct 2026 17:49:17 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Fri, 23 Oct 2026 17:49:16 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.51.25])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jB5Wc0GzKzcFj;
	Fri, 23 Oct 2026 17:49:16 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.12] bcachefs: Drop swab code for backpointers in alloc keys
Date: Fri, 23 Oct 2026 17:45:41 +0300
Message-ID: <20261023144542.1053-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Post: <mailto:linux-bcachefs@vger.kernel.org>
List-Help: <mailto:linux-bcachefs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-bcachefs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 132 0.3.132 b92628ca234da971a1a6d61b32804bb3075f0fd2, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;new-mail.astralinux.ru:7.1.1;astralinux.ru:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 206945 [Oct 23 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/10/23 13:00:00 #28730621
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Kent Overstreet <kent.overstreet@linux.dev>

commit abff9b149dcc0a584cbadc869167e5a7199cd1ce upstream.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
The upstream commit has no description, so some context for stable:
bch2_alloc_v4_swab() is called from bch2_bkey_compat() before
bset_key_validate() when reading a btree node written with the other
endianness, so the backpointers start and count it uses come straight
from disk. With bogus values the loop byte-swaps memory past the end of
the key value, possibly past the end of the node buffer.

Backpointers stored in alloc keys are not used anymore,
__bch2_alloc_to_v4() and bch2_alloc_to_v4_mut() drop them anyway, so
removing the loop is safe.

 fs/bcachefs/alloc_background.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index c84a91572a1d..402f20eadae2 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -322,7 +322,6 @@ int bch2_alloc_v4_validate(struct bch_fs *c, struct bkey_s_c k,
 void bch2_alloc_v4_swab(struct bkey_s k)
 {
 	struct bch_alloc_v4 *a = bkey_s_to_alloc_v4(k).v;
-	struct bch_backpointer *bp, *bps;
 
 	a->journal_seq		= swab64(a->journal_seq);
 	a->flags		= swab32(a->flags);
@@ -333,13 +332,6 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 	a->stripe		= swab32(a->stripe);
 	a->nr_external_backpointers = swab32(a->nr_external_backpointers);
 	a->stripe_sectors	= swab32(a->stripe_sectors);
-
-	bps = alloc_v4_backpointers(a);
-	for (bp = bps; bp < bps + BCH_ALLOC_V4_NR_BACKPOINTERS(a); bp++) {
-		bp->bucket_offset	= swab40(bp->bucket_offset);
-		bp->bucket_len		= swab32(bp->bucket_len);
-		bch2_bpos_swab(&bp->pos);
-	}
 }
 
 void bch2_alloc_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
-- 
2.43.0

