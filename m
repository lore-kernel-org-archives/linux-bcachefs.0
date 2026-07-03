Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574653C3C00;
	Fri,  3 Jul 2026 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783079322; cv=none; b=F/fX21m+dbC4zeXkgXs3JMILC7gplx5hQF0LjFFMirAmGHQIXP9IKfMw/W2C2bUJC8xoNlSAtnVf+H7DrxS0GWUV1dYTTsqpoBB436LAxn+nlWawPN6ZNRvPAZwGt+s4Wsj3/01OlRTLPYCluwEYFuSpScj8aREdBEpOwaVsNRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783079322; c=relaxed/simple;
	bh=2qmujaOaVVRwvameAxp1+bgrW1ZkyLD3rS3mOuVolrk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ckQXWWFCmNzFz/mPwPDo0PtFDO0Cfx1f0Xlh2GJeVywQmJAgxlP7YMBOs/tXTWXNhQfctpzED4sIfu/qUq8A1PeTaJpC96ssZsCFHOVR8n0i27BkRZ5HCNPABwrumQqDux+83UqBj8EFtkQFDqsY9SMUFsVJCR+/arfYshtw3CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=JiT1ywmg; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="JiT1ywmg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1783079309;
	bh=2qmujaOaVVRwvameAxp1+bgrW1ZkyLD3rS3mOuVolrk=;
	h=From:To:Cc:Subject:Date:From;
	b=JiT1ywmg4xkCZ/qEqDH7jsOSe38F8V6HakA4KDCgZOF8KpT52TvHoY2G8gKqN0luL
	 5NS83mzzLyaEcDjrLiCXE+ZbXhW9C26QzbZh3T29iwdSyklFHYIbj/CAft9bTh0lL7
	 dQJGcjYfV08lgGkg7zv9Untuo7UZa2o2obFadG6T77auQF1HDYJkhBO54yuUH5p/+t
	 WrQkYc8NtpwT/6lNLj0A5+T4p4FMLQh87f7gBTQx8VpZ3vZAXIeG9FqBCofRPHXjOa
	 K1pHGzlU/kQOTEm0BNAOTV0GHZSLQJddem/S4UBcZ4a+vcNdygMsRS1gWpvJm5QxJU
	 SnLsZKG4Cs7Hg==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 4B47B26546;
	Fri,  3 Jul 2026 14:48:29 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Fri,  3 Jul 2026 14:48:28 +0300 (MSK)
Received: from rbta-msk-lt-169874.astralinux.ru (unknown [10.198.57.102])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gsBph0FnjzhvC;
	Fri, 03 Jul 2026 14:48:28 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 6.12] bcachefs: avoid truncating fiemap extent length
Date: Fri,  3 Jul 2026 14:48:13 +0300
Message-Id: <20260703114813.113406-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/07/03 07:33:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 112 0.3.112 7c8d497b0e572fbfa504a2ee62037c045a8cb4ec, {date_rfc_vio_soft_silent}, {Tracking_uf_ne_domains}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1;evilpiepirate.org:7.1.1;new-mail.astralinux.ru:7.1.1;lore.kernel.org:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 204225 [Jul 03 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/07/03 10:45:00 #28371015
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/07/03 07:33:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

No upstream commit exists for this patch.

bkey sizes are stored in sectors as u32, while fiemap reports byte
lengths as u64. Shifting k.k->size before widening performs the
conversion in 32 bits, so an extent of 4 GiB or larger can wrap before
it is passed to fiemap_fill_next_extent().

Compute the byte length after casting the sector count to u64 and reuse
it for all bch2_fill_extent() cases.

The same issue was fixed in bcachefs-tools, but there is no Linux
upstream commit to backport to 6.12. The affected 6.12 implementation lives
in fs/bcachefs/fs.c, while the bcachefs-tools fix touches
fs/bcachefs/vfs/fiemap.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lore.kernel.org/linux-bcachefs/20260610105547.129545-1-mdmitrichenko@astralinux.ru/
Link: https://evilpiepirate.org/git/bcachefs-tools.git/commit/?id=6d9a895ed00d4b3868312df93253d2a817b0c6a3
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
 fs/bcachefs/fs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index a41d0d8a2f7b..0dc2466de3f9 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1184,6 +1184,8 @@ static int bch2_fill_extent(struct bch_fs *c,
 			    struct fiemap_extent_info *info,
 			    struct bkey_s_c k, unsigned flags)
 {
+	u64 len = (u64)k.k->size << 9;
+
 	if (bkey_extent_is_direct_data(k.k)) {
 		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 		const union bch_extent_entry *entry;
@@ -1212,7 +1214,7 @@ static int bch2_fill_extent(struct bch_fs *c,
 			ret = fiemap_fill_next_extent(info,
 						bkey_start_offset(k.k) << 9,
 						offset << 9,
-						k.k->size << 9, flags|flags2);
+						len, flags | flags2);
 			if (ret)
 				return ret;
 		}
@@ -1221,13 +1223,13 @@ static int bch2_fill_extent(struct bch_fs *c,
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
2.43.0
