Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828C1635CF;
	Tue,  7 May 2024 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715095855; cv=none; b=nW2HpXp12ozO6D24Dunqh0dTOufPgbq9fbsmeW7cHH9am8G10FgR54pMT11Lj93rc6/SQddrEMV8ZsdEOKKiCNtOVzgSCq/OnY7FWTRs39V9XkdKiGdmGN2f1BjO/Zg7ZvK0fb+H/QJ63AYCRkWJW0RI5f6u4GuZGA1bWQkleh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715095855; c=relaxed/simple;
	bh=UHN7KPepYlX4NC0g1WmX/Ll9rKHX3M8U0VZH+gpvxzY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UonuFw+MutjISl5vrcFj8JRC/3QEho6Ms4moFZUPy/qnuTyi/rDtPxLZW7Sld0eZZAAuydRIISnzPiTzZwj1ZPVdMKnFnh23hkBboXftahni7GemhZaFYpDlL1hw3I33G33gBY00/HmPSpIpiOBku2WCORyQFBOrcvVxQQVx2lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T2nC5wrE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R8kp0ZJ7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=T2nC5wrE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R8kp0ZJ7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T2nC5wrE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R8kp0ZJ7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="T2nC5wrE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R8kp0ZJ7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9ECBD20C39;
	Tue,  7 May 2024 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715095851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxsMjifdiw/PLHI4yLGjx1ISB88He20VSWpfmVy0Lp4=;
	b=T2nC5wrEO0RHLija+0KBfAKovMv0Q0+gH8sQVu9KjQXFzTalWgQvL1TNfGOfZiLUzw79wH
	YkcaOkNLQ/EJxHF6XHdkC3X3Xp9aTr4Q6WTeg8ww79qM0NLAzwpBc1UeACGfVPXdhKEUIC
	nCyDakKqLDh/8IVnoSDMWNDaIXf3Voc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715095851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxsMjifdiw/PLHI4yLGjx1ISB88He20VSWpfmVy0Lp4=;
	b=R8kp0ZJ7oQeZwXq+pnpvRkyw8mNFaZXVzvmwxOe5p/PqoaGOKuwzTvupYuanJdo6KWwOip
	YzFBew/yBHTOWNBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T2nC5wrE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R8kp0ZJ7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715095851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxsMjifdiw/PLHI4yLGjx1ISB88He20VSWpfmVy0Lp4=;
	b=T2nC5wrEO0RHLija+0KBfAKovMv0Q0+gH8sQVu9KjQXFzTalWgQvL1TNfGOfZiLUzw79wH
	YkcaOkNLQ/EJxHF6XHdkC3X3Xp9aTr4Q6WTeg8ww79qM0NLAzwpBc1UeACGfVPXdhKEUIC
	nCyDakKqLDh/8IVnoSDMWNDaIXf3Voc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715095851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxsMjifdiw/PLHI4yLGjx1ISB88He20VSWpfmVy0Lp4=;
	b=R8kp0ZJ7oQeZwXq+pnpvRkyw8mNFaZXVzvmwxOe5p/PqoaGOKuwzTvupYuanJdo6KWwOip
	YzFBew/yBHTOWNBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE530139CB;
	Tue,  7 May 2024 15:30:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id clzaNCpJOmYUVQAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 15:30:50 +0000
From: Petr Vorel <pvorel@suse.cz>
To: linux-bcachefs@vger.kernel.org
Cc: Petr Vorel <pvorel@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Su Yue <l@damenly.org>,
	Brian Foster <bfoster@redhat.com>,
	Coly Li <colyli@suse.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC value to UAPI magic.h
Date: Tue,  7 May 2024 17:30:44 +0200
Message-ID: <20240507153044.149502-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9ECBD20C39
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

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
index 1b40a968ba91..4a59551e30c2 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -37,6 +37,7 @@
 #define HOSTFS_SUPER_MAGIC	0x00c0ffee
 #define OVERLAYFS_SUPER_MAGIC	0x794c7630
 #define FUSE_SUPER_MAGIC	0x65735546
+#define BCACHEFS_SUPER_MAGIC		0xca451a4e
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
2.43.0

