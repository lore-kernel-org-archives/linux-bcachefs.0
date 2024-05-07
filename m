Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D569914D422;
	Tue,  7 May 2024 11:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715080299; cv=none; b=jM24PzCwdjOCNHndEFIns4c36gtyFqHwmO2Zh0tPsYj6MEIgNrzMUx3oqtDuhuKeBE0YWAl1tjAPZ9/hwWqEohWafFTwIUseDBV+fxQ5WGtv3iKHaXNfGpjMTyGPIDgygU5Ewnwmo5xZl95jYk6ctW8wAo9civUy1YO1Xup6v+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715080299; c=relaxed/simple;
	bh=EPXcVGr6PwUD5WRAgidbvP7YMy/o/6CVibICU7SLOn0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lXguKlcyKg+wBo9tq/tkK882SIH7VK4BYNhbIzYHJa0qeTNfnwXVdiwaiqmSEJVadlnDvGV6pxc92GBK1Z3Ido1bGPiniwl/yKxG/IP/a1tr6CzfOzlM7gGD4GSMS9jysgEcFeOlt2e9F7QsTrnseOHYeEX060Z4vlO7UHLTA0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nAemReb/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wjevTgEp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lNzi4kVX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LBHNSDSO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nAemReb/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wjevTgEp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lNzi4kVX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LBHNSDSO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D61A20872;
	Tue,  7 May 2024 11:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715080289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cj2y7/ZChHRcGGAkj7MJnNzcMCYrE/qSziKzgQGJwow=;
	b=nAemReb/sccs0n4omRlAj9Cz38UdlYA0nxSrerEsLIKn03VteA+kKQvD35b3xYzBun3Z8w
	3cw8mCLiMuVJJ51nAj/bgvnjRyQc1bTjNqOZ5tVlqfWBBoFLPWitiVBTCCfuY+OYxVql9Z
	XfW5vgdFUc6vbo6om1gJT9TZvsYScdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715080289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cj2y7/ZChHRcGGAkj7MJnNzcMCYrE/qSziKzgQGJwow=;
	b=wjevTgEpUnUCtj7EiW48wxK0gY4WxMdVgmtU3YQB+di694IIqJiKjeQYUIpaHlYX2fAr/p
	njUrZGT20qIuV6Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1715080288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cj2y7/ZChHRcGGAkj7MJnNzcMCYrE/qSziKzgQGJwow=;
	b=lNzi4kVXPlUmDHChd7wQvSpk7qQ1MQLLZYERbB8MkdHbKxDnB750hIfPr9Do76HK96ZMfb
	Svex3W2pFWqPvZ4iL7tQXom7U1hvBXiDXBw0+ebrDMrmdLDq2O8Gi0VGGOhHBIwIPf5L4H
	tT8lg56mZ48YREMCmOq9P2CjkNwCrD0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1715080288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cj2y7/ZChHRcGGAkj7MJnNzcMCYrE/qSziKzgQGJwow=;
	b=LBHNSDSOqX01lHn+/3vWNN+eB0IbjJxqQpJEL2GCuDIjNxkIjI5lK6R4vMnf1SjZhuGk6C
	q0MA6Ly7DXspbLDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50601139CB;
	Tue,  7 May 2024 11:11:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0JBnEWAMOmazdQAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Tue, 07 May 2024 11:11:28 +0000
From: Petr Vorel <pvorel@suse.cz>
To: linux-bcachefs@vger.kernel.org
Cc: Petr Vorel <pvorel@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Su Yue <l@damenly.org>,
	Brian Foster <bfoster@redhat.com>,
	Coly Li <colyli@suse.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] bcachefs: Move BCACHEFS_STATFS_MAGIC to UAPI magic.h
Date: Tue,  7 May 2024 13:11:24 +0200
Message-ID: <20240507111124.118520-1-pvorel@suse.cz>
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
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,damenly.org:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[]

There are other bcachefs magic definitions: BCACHE_MAGIC, BCHFS_MAGIC,
which use UUID_INIT() and are used only in libbcachefs. Therefore move
to <linux/magic.h> only BCACHEFS_STATFS_MAGIC, which can be used outside
of libbcachefs for f_type field in struct statfs in statfs() or fstatfs().

Keeping non-standard name BCACHEFS_STATFS_MAGIC instead of renaming it
to more generic BCACHEFS_MAGIC to not confuse with the other bcachefs
definitions.

Suggested-by: Su Yue <l@damenly.org>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
 fs/bcachefs/bcachefs_format.h | 2 --
 fs/bcachefs/fs.c              | 1 +
 include/uapi/linux/magic.h    | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index f7fbfccd2b1e..52e03f13b780 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1275,8 +1275,6 @@ enum bch_compression_opts {
 	UUID_INIT(0xc68573f6, 0x66ce, 0x90a9,				\
 		  0xd9, 0x6a, 0x60, 0xcf, 0x80, 0x3d, 0xf7, 0xef)
 
-#define BCACHEFS_STATFS_MAGIC		0xca451a4e
-
 #define JSET_MAGIC		__cpu_to_le64(0x245235c1a3625032ULL)
 #define BSET_MAGIC		__cpu_to_le64(0x90135c78b99e07f5ULL)
 
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index fce690007edf..1c856ae2b0e2 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -27,6 +27,7 @@
 #include "super.h"
 #include "xattr.h"
 
+#include <uapi/linux/magic.h>
 #include <linux/aio.h>
 #include <linux/backing-dev.h>
 #include <linux/exportfs.h>
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 1b40a968ba91..45c8f4916167 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,4 +103,6 @@
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
 
+#define BCACHEFS_STATFS_MAGIC		0xca451a4e
+
 #endif /* __LINUX_MAGIC_H__ */
-- 
2.43.0

