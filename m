Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7CA3E866B;
	Wed, 10 Jun 2026 10:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781089039; cv=none; b=cuoiIRI0gkBDaF3zTY/bYCUVZM8cLMzFL14cBvlyCMTftgyDyVFTz5iGRi6iJjd6++tOrhCIixNH3DeRAMYFhwdPNpYr97EoJ93/IFaSoAesB3hC2Pg/C/pyOxuNvajsDM2294PZdfodIF0GntWVAkXvdcdEF9peQ7zlpH86/Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781089039; c=relaxed/simple;
	bh=GNdX8HFLFqeXXilN+lbubxclr9EThJIaNFCvQB7lVOE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oznf8bsY13R42qTMnZxlV2IkkbSh66GXCjwoq3u9YWXW73AKUClNhWTgWbHgvtZEHiis+p5wqGgmOREv3N5BnL3UoDoiB1amqllk1eDKtR599W6R19Y0PUg9M9ursWOW9O9WSZcIUTM51qIpX55p4uA2erYtIQSkp20O237WzTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=EtY+lM2T; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="EtY+lM2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1781089028;
	bh=GNdX8HFLFqeXXilN+lbubxclr9EThJIaNFCvQB7lVOE=;
	h=From:To:Cc:Subject:Date:From;
	b=EtY+lM2TtR1QSRqtXVMznVkXdm79k28J0oF/oya3wh/kWrtEGRFswYDQoPkKCcgj7
	 SSNHzu/ut21kgGX7ryTLDbtfRHLTO6gH1UnPiP5R3ScqLHTzKzqQkmBPSHlHow9z5o
	 Cx6j6K/VdKBBnQmB82mn7kRcsNu/qa4LrSjw0223n4sZfXACy1o8a8wotO/5sK1HVW
	 RjbOIosG5ZTN8i9KhSR4PSW5hc6ORyEIT9ZREjUa8kSRNTJVLNSNO7I8EQo62Ukl4c
	 N/tVVSqdUswLO6/LydNCWsUVXEIOScJK4QoQApmdPxG+iSbory29HU1dhlfY2HtFKt
	 B88NRRnGsTgGA==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 31E8F2508A;
	Wed, 10 Jun 2026 13:57:08 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Wed, 10 Jun 2026 13:57:07 +0300 (MSK)
Received: from rbta-msk-lt-169874.astralinux.ru (unknown [10.198.16.108])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gb2m25rL7zJnx6;
	Wed, 10 Jun 2026 13:57:06 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] bcachefs: avoid truncating fiemap extent length
Date: Wed, 10 Jun 2026 13:55:47 +0300
Message-Id: <20260610105547.129545-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 107 0.3.107 575e75fe8e3b9d45c142d144823c5de38605099e, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 203779 [Jun 10 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/06/10 09:23:00 #28226538
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

bkey sizes are stored in sectors as u32, while fiemap reports byte
lengths as u64. Shifting k.k->size before widening performs the
conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
it is passed to fiemap_fill_next_extent().

Compute the byte length after casting the sector count to u64 and reuse
it for all bch2_fill_extent() cases.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
 fs/bcachefs/vfs/fiemap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/vfs/fiemap.c b/fs/bcachefs/vfs/fiemap.c
index 067e191cf8d0..18a44622a7b0 100644
--- a/fs/bcachefs/vfs/fiemap.c
+++ b/fs/bcachefs/vfs/fiemap.c
@@ -23,6 +23,7 @@ static int bch2_fill_extent(struct bch_fs *c,
 			    struct bch_fiemap_extent *fe)
 {
 	struct bkey_s_c k = bkey_i_to_s_c(fe->kbuf.k);
+	u64 len = (u64) k.k->size << 9;
 	unsigned flags = fe->flags;
 
 	BUG_ON(!k.k->size);
@@ -54,20 +55,20 @@ static int bch2_fill_extent(struct bch_fs *c,
 			try(fiemap_fill_next_extent(info,
 						bkey_start_offset(k.k) << 9,
 						offset << 9,
-						k.k->size << 9, flags|flags2));
+						len, flags|flags2));
 		}
 
 		return 0;
 	} else if (bkey_extent_is_inline_data(k.k)) {
 		return fiemap_fill_next_extent(info,
 					       bkey_start_offset(k.k) << 9,
-					       0, k.k->size << 9,
+					       0, len,
 					       flags|
 					       FIEMAP_EXTENT_DATA_INLINE);
 	} else if (k.k->type == KEY_TYPE_reservation) {
 		return fiemap_fill_next_extent(info,
 					       bkey_start_offset(k.k) << 9,
-					       0, k.k->size << 9,
+					       0, len,
 					       flags|
 					       FIEMAP_EXTENT_DELALLOC|
 					       FIEMAP_EXTENT_UNWRITTEN);
-- 
2.54.0.windows.1

