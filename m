Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE61220687;
	Tue,  2 Dec 2025 17:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764696167; cv=none; b=Zadppy6SkTKZNWdIzFFCqYfrwW9n1vmdyUYVWv8SBTgfohzbPXLPBVeZSCG746+WsrHTpr8HgqQXehZ6xVj5mBuyDe5yU31rRMcE5l2qd2JXE2CwMySe5oQaGM90wER8LquHah893Hi/rkU7HNgp/chY+x2MGDsiTS4yerGoWBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764696167; c=relaxed/simple;
	bh=6G3uTpe15tnlTeX3Zb/S8zizniWEGxPgtUpSj/WJ/Ak=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gfVQzzUtqHxm1yEj/BFSKjccA7GZwhqPxmqyaXpJOrbzVmAlk0t6/FRJMDFzwQR7/E1AI3QYOZRGeGsWs2AWTwc1kY2ymJFVA9SmejE3/DGtAHZJiw2jFrPBPvN6Iu0HOxot1+BrDrgNMjPWVePI/sjuJDOTs3Ph5prwNlLM8UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=Xj0jqGIr; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="Xj0jqGIr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1764696148;
	bh=6G3uTpe15tnlTeX3Zb/S8zizniWEGxPgtUpSj/WJ/Ak=;
	h=From:To:Cc:Subject:Date:From;
	b=Xj0jqGIrVvr8Vu0/XLXZKazD3Oks4NQmax/QmImGcU+8JIeHMOaig14mo/VhMnSrU
	 6uOIiW3i5DIxDa2gWan6TGRq039rQh8LgtOe4iDKBk2/71fO6yYdm104xsd6TKdCrV
	 8Py6ay95LqYZbm05NbSgcXJwpapeO7wqkmpQN7bDFMDkpR9EBiWaiMe4o1/DuhDx8y
	 YgDG12JBVJngC1wiYu+Ux63GyjpcWAqQzj4L/aG5UOSVoL8QGEVa4iBEb+yM/HcbFj
	 N3IyM60Y9PaIaMBxF/ErcgExlHjDSSA+puE5iz5zRwYY5zVVeydE+q+uY/dwEto6/a
	 i3U8Jmy7i+pEg==
Received: from gca-msk-a-srv-ksmg01 (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 2B8C81FA4A;
	Tue,  2 Dec 2025 20:22:28 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Tue,  2 Dec 2025 20:22:27 +0300 (MSK)
Received: from rbta-msk-lt-169874.astralinux.ru.astracloud.ru (unknown [10.198.22.94])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4dLSHm71yYzSgqf;
	Tue,  2 Dec 2025 20:21:56 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] bcachefs: fix potential NULL deref in bch2_sb_members_v2_init
Date: Tue,  2 Dec 2025 20:20:46 +0300
Message-Id: <20251202172047.216045-1-mdmitrichenko@astralinux.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 81 0.3.81 2adfceff315e7344370a427642ad41a4cfd99e1f, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 198629 [Dec 02 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.20
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/12/02 10:29:00 #28001833
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

bch2_sb_members_v2_init calls bch2_sb_field_resize to allocate the
members_v2 superblock field, but does not check the returned pointer
before dereferencing it. bch2_sb_field_resize may return NULL if
superblock reallocation fails. In this case dereferencing mi2=NULL
will cause crash during superblock upgrade from members_v1 to members_v2.

Add check for bch2_sb_field_resize call result for NULL.
sb_members_v2_resize_entries function already has such check and returns
error in this case. Make bch2_sb_members_v2_init() consistent and return
the same error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 3f7b9713dae0 ("bcachefs: New superblock section members_v2")
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
 fs/bcachefs/sb/members.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/sb/members.c b/fs/bcachefs/sb/members.c
index 8bf8f5ca3470..a610426b6013 100644
--- a/fs/bcachefs/sb/members.c
+++ b/fs/bcachefs/sb/members.c
@@ -116,6 +116,9 @@ int bch2_sb_members_v2_init(struct bch_fs *c)
 				DIV_ROUND_UP(sizeof(*mi2) +
 					     sizeof(struct bch_member) * c->sb.nr_devices,
 					     sizeof(u64)));
+		if (!mi2)
+			return bch_err_throw(c, ENOSPC_sb_members_v2);
+
 		mi1 = bch2_sb_field_get(c->disk_sb.sb, members_v1);
 		memcpy(&mi2->_members[0], &mi1->_members[0],
 		       BCH_MEMBER_V1_BYTES * c->sb.nr_devices);
-- 
2.39.2

