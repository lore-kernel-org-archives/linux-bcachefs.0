Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mtpmOfxL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TvCNWMLW"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C53DAF;
	Thu, 16 Nov 2023 05:55:54 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52389204FF;
	Thu, 16 Nov 2023 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1700142952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R8aHzkBksOpLVwJaPCakhyMl9QcIJs0Fforp1s1vD90=;
	b=mtpmOfxLJQKhf68p+hruq60FzfUlY/uzOS4f+rEBo5CYR/rWLrtGbBCbgWTEBtuYCRg1vl
	7EBVz2OPcomfireGgzbKNk9OUrv4WUDu5W9iWSkXPqVT/JTYShrSsPRTf8q007hTNtF86A
	ly52dIY/blUFP33FfKm1RABVSVd8fUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1700142952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R8aHzkBksOpLVwJaPCakhyMl9QcIJs0Fforp1s1vD90=;
	b=TvCNWMLWQbGV1DQa7zBydoNyAwkKs0khQiRvEv6Z4byuNFw5i4PUJbqyjJ+5RmgnMJkg/K
	c3yr5yLoJsTRunDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0BDD139C4;
	Thu, 16 Nov 2023 13:55:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 9+sPOWcfVmWQIAAAMHmgww
	(envelope-from <pvorel@suse.cz>); Thu, 16 Nov 2023 13:55:51 +0000
From: Petr Vorel <pvorel@suse.cz>
To: ltp@lists.linux.it
Cc: Petr Vorel <pvorel@suse.cz>,
	Cyril Hrubis <chrubis@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Richard Palethorpe <rpalethorpe@suse.com>,
	Jan Stancek <jstancek@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/1] lib: Add support bcachefs filesystem
Date: Thu, 16 Nov 2023 14:55:46 +0100
Message-ID: <20231116135546.2599273-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Score: 1.90
X-Spamd-Result: default: False [1.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[12];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-1.80)[93.81%]

bcachefs has been merged into v6.7-rc1 [1]. Let's add it's support to
LTP .all_filesystems = 1 and TST_ALL_FILESYSTEMS=1.

[1] https://lwn.net/Articles/934692/

Suggested-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Hi,

this should be merged after v6.7 is released.

So far I haven't tested all LTP tests on bcachefs temporary directory.
I have only tested tests which use .all_filesystems = 1 or TST_ALL_FILESYSTEMS=1.
So far it looks like there are only a few tests failing:

statvfs01.c:44: TFAIL: creat(valid_fname, 0444) failed: ENAMETOOLONG (36)

statx04.c:122: TFAIL: STATX_ATTR_COMPRESSED not supported

fanotify13.c, fanotify15.c and fanotify16.c produce many errors.

I haven't tested on machine with more NUMA nodes, thus
set_mempolicy03.c, set_mempolicy04.c has not been tested.

I also looks like preadv2() is not supported (preadv203.c).

Tested on 6.7.0-rc1-2.g86e46c2-default and bcachefs-tools-24-1.3.

Kind regards,
Petr

 lib/tst_supported_fs_types.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/tst_supported_fs_types.c b/lib/tst_supported_fs_types.c
index d4911fa3b..369836717 100644
--- a/lib/tst_supported_fs_types.c
+++ b/lib/tst_supported_fs_types.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2017 Cyril Hrubis <chrubis@suse.cz>
+ * Copyright (c) Linux Test Project, 2018-2023
  */
 
 #include <stdio.h>
@@ -24,6 +25,7 @@ static const char *const fs_type_whitelist[] = {
 	"ext4",
 	"xfs",
 	"btrfs",
+	"bcachefs",
 	"vfat",
 	"exfat",
 	"ntfs",
-- 
2.42.0

