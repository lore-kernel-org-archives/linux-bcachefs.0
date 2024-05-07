Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2F15E1E2;
	Tue,  7 May 2024 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715096293; cv=none; b=Otlo7vLhGy6jMa0/U6eK9J/lMjcaPZRsTpiGZI+OdLq144y5XVKWIA5oUH5RQz3o5/MtiCt71pUXRtS4WpDU0d3znj6RK0HbQQWkMfhiZsgKGp0Ukb630GXVquUdwD7MKzNcdKVK2ZwVLKTDOWCr8Kd9poe2vah0cbFoltywRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715096293; c=relaxed/simple;
	bh=xKF1H9j1MZHhQGjnP4Li4IMqEqKEwQtaBsnmRFKfjVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C7w9l3I2lcmPOiBolb/UBIXWBqQWizvseZj1b7j4ZQ1JMu/qUIPnpp1fAD4SCrPm5qXY3ayIJao/EYXBWtwOBzSf3UO4bxvQ1Ar1ipDLPeheGY6ytfUb9gD76h66v2XebQbEoKoaq0W54XUUGGGSVF1SYdjw9u1980AxmJkJs8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aMZAFd2W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UWoWzIcc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aMZAFd2W; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UWoWzIcc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aMZAFd2W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UWoWzIcc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aMZAFd2W";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UWoWzIcc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84E5F20C58;
	Tue,  7 May 2024 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715096290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s8tHyXfzGfTlsq3wnZwT9oRxMRdo1cSBYtbKiUtIQco=;
	b=aMZAFd2WDyOo3kNlkRIXgQyVXnNAfJqvvOWcSJLyMpKKneL1ttvioTqbihySrZ8/uzl1co
	U2s82NePu7LvkW/lZQvwdJPPFOk0YmX77qwhNYcrr9m1zCWJe08hDR/uERFKPo0t1jIeW3
	jsk7abCMZh5im1q4Yizd4/YW571q33I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715096290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s8tHyXfzGfTlsq3wnZwT9oRxMRdo1cSBYtbKiUtIQco=;
	b=UWoWzIcc3FV9goXAOBGFfxjWlWWh2/qs02leEd1u4ze2R6INRvtVZv0HFE3ugjv5dfJ5uG
	CZB7j9UJouyoI+Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715096290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s8tHyXfzGfTlsq3wnZwT9oRxMRdo1cSBYtbKiUtIQco=;
	b=aMZAFd2WDyOo3kNlkRIXgQyVXnNAfJqvvOWcSJLyMpKKneL1ttvioTqbihySrZ8/uzl1co
	U2s82NePu7LvkW/lZQvwdJPPFOk0YmX77qwhNYcrr9m1zCWJe08hDR/uERFKPo0t1jIeW3
	jsk7abCMZh5im1q4Yizd4/YW571q33I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715096290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s8tHyXfzGfTlsq3wnZwT9oRxMRdo1cSBYtbKiUtIQco=;
	b=UWoWzIcc3FV9goXAOBGFfxjWlWWh2/qs02leEd1u4ze2R6INRvtVZv0HFE3ugjv5dfJ5uG
	CZB7j9UJouyoI+Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EF78139CB;
	Tue,  7 May 2024 15:38:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IAEpEeFKOmZ/VwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 15:38:09 +0000
From: Petr Vorel <pvorel@suse.cz>
To: linux-bcachefs@vger.kernel.org
Cc: Petr Vorel <pvorel@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Su Yue <l@damenly.org>,
	Brian Foster <bfoster@redhat.com>,
	Coly Li <colyli@suse.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to UAPI magic.h
Date: Tue,  7 May 2024 17:37:57 +0200
Message-ID: <20240507153757.150891-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Move BCACHEFS_STATFS_MAGIC value to UAPI <linux/magic.h> under
BCACHEFS_SUPER_MAGIC definition (use common approach for name) and reuse the
definition in bcachefs_format.h BCACHEFS_STATFS_MAGIC.

There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
which use UUID_INIT() and are used only in libbcachefs. Therefore move
only BCACHEFS_STATFS_MAGIC value, which can be used outside of
libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

Suggested-by: Su Yue <l@damenly.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Changes v2->v3:
* Align tab with other entries.

Changes v1->v2 (all suggested by Brian Foster - thanks!):
* rename constant to BCACHEFS_SUPER_MAGIC,
* keep BCACHEFS_STATFS_MAGIC in bcachefs_format.h, just include
 <uapi/linux/magic.h> and use BCACHEFS_SUPER_MAGIC definition,
* move the constant to the first chunk.

Kind regards,
Petr

 fs/bcachefs/bcachefs_format.h | 3 ++-
 include/uapi/linux/magic.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index f7fbfccd2b1e..3b831415409b 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -76,6 +76,7 @@
 #include <asm/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include <uapi/linux/magic.h>
 #include "vstructs.h"
 
 #ifdef __KERNEL__
@@ -1275,7 +1276,7 @@ enum bch_compression_opts {
 	UUID_INIT(0xc68573f6, 0x66ce, 0x90a9,				\
 		  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)
 
-#define BCACHEFS_STATFS_MAGIC		0xca451a4e
+#define BCACHEFS_STATFS_MAGIC		BCACHEFS_SUPER_MAGIC
 
 #define JSET_MAGIC		__cpu_to_le64(0x245235c1a3625032ULL)
 #define BSET_MAGIC		__cpu_to_le64(0x90135c78b99e07f5ULL)
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 1b40a968ba91..bb575f3ab45e 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -37,6 +37,7 @@
 #define HOSTFS_SUPER_MAGIC	0x00c0ffee
 #define OVERLAYFS_SUPER_MAGIC	0x794c7630
 #define FUSE_SUPER_MAGIC	0x65735546
+#define BCACHEFS_SUPER_MAGIC	0xca451a4e
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
2.43.0

