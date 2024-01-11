Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271773C48D;
	Thu, 11 Jan 2024 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cwwC4wzz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8F9unIkU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cwwC4wzz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8F9unIkU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B3E221FA2;
	Thu, 11 Jan 2024 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704985558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7aS2PlMmCiryfDitmcL1Cpo6Mq4SnSFnam7+9jfCSKY=;
	b=cwwC4wzzhaS2W8TrOrefafXYQUJWF+LsVrLsHixvjo/Zg7NzxJUc48GiuhwT68YqB23QsB
	XSSpRikRCCGc3Dvw4j9XQByMdTjeiD73rbHtKf70W9bAa+1On1+QPxKuRKo1hj5r24Ynnu
	ic5SNdGJItApES/0JJsEigKUjUrIkDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704985558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7aS2PlMmCiryfDitmcL1Cpo6Mq4SnSFnam7+9jfCSKY=;
	b=8F9unIkUQdFYxSz8VnMLjHmwfUIeSRPJTm0NH5yfeLRQ9lSW/RODtE7C2Z2djOXFM2nzBB
	B9tfyRH82RDgDoBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1704985558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7aS2PlMmCiryfDitmcL1Cpo6Mq4SnSFnam7+9jfCSKY=;
	b=cwwC4wzzhaS2W8TrOrefafXYQUJWF+LsVrLsHixvjo/Zg7NzxJUc48GiuhwT68YqB23QsB
	XSSpRikRCCGc3Dvw4j9XQByMdTjeiD73rbHtKf70W9bAa+1On1+QPxKuRKo1hj5r24Ynnu
	ic5SNdGJItApES/0JJsEigKUjUrIkDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1704985558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7aS2PlMmCiryfDitmcL1Cpo6Mq4SnSFnam7+9jfCSKY=;
	b=8F9unIkUQdFYxSz8VnMLjHmwfUIeSRPJTm0NH5yfeLRQ9lSW/RODtE7C2Z2djOXFM2nzBB
	B9tfyRH82RDgDoBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 829A8132CF;
	Thu, 11 Jan 2024 15:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UL71HdUDoGUdRwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Thu, 11 Jan 2024 15:05:57 +0000
From: Petr Vorel <pvorel@suse.cz>
To: ltp@lists.linux.it
Cc: Petr Vorel <pvorel@suse.cz>,
	Cyril Hrubis <chrubis@suse.cz>,
	Li Wang <liwang@redhat.com>,
	Jan Stancek <jstancek@redhat.com>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/1] safe_macros: Fix bcachefs failure old kernel
Date: Thu, 11 Jan 2024 16:05:53 +0100
Message-ID: <20240111150553.1923767-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: *
X-Spamd-Bar: +
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cwwC4wzz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8F9unIkU
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [1.94 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.cz:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.05)[59.67%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCVD_DKIM_ARC_DNSWL_HI(-1.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_IN_DNSWL_HI(-0.50)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_TLS_ALL(0.00)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Score: 1.94
X-Rspamd-Queue-Id: 0B3E221FA2
X-Spam-Flag: NO

LTP with bcachefs-tools and kernel < 6.7 fails (more tests):

    # LTP_SINGLE_FS_TYPE=bcachefs ./chdir01
    ...
    tst_supported_fs_types.c:57: TINFO: mkfs.bcachefs does exist
    tst_test.c:1669: TINFO: === Testing on bcachefs ===
    tst_test.c:1117: TINFO: Formatting /dev/loop0 with bcachefs opts=''
    extra opts=''
    tst_test.c:1131: TINFO: Mounting /dev/loop0 to
    /tmp/LTP_chdwqhGtZ/mntpoint fstyp=bcachefs flags=0
    tst_test.c:1131: TBROK: mount(/dev/loop0, mntpoint, bcachefs, 0, (nil))
    failed: ENODEV (19)

The problem is that on FUSE support we expect there is FUSE bcachefs
implementation. bcachefs supports fusemount, but let's skip testing atm.

Fixes: 94802606e ("lib: Add support bcachefs filesystem to .all_filesystems")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
Hi all,

I'm sorry, although man bcachefs(8) mentions fusemount, I haven't
figured out how to mount filesystem. Am I missing something?

Also, maybe for the start I would prefer to to test just kernel
functionality (no fuse).

Kind regards,
Petr

 lib/tst_supported_fs_types.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/tst_supported_fs_types.c b/lib/tst_supported_fs_types.c
index 369836717..21765c370 100644
--- a/lib/tst_supported_fs_types.c
+++ b/lib/tst_supported_fs_types.c
@@ -96,6 +96,11 @@ static enum tst_fs_impl has_kernel_support(const char *fs_type)
 
 	SAFE_RMDIR(template);
 
+	if (!strcmp(fs_type, "bcachefs") && tst_kvercmp(6, 7, 0) < 0) {
+		tst_res(TINFO, "bcachefs skipped on kernel < 6.7");
+		return TST_FS_UNSUPPORTED;
+	}
+
 	/* Is FUSE supported by kernel? */
 	if (fuse_supported == -1) {
 		ret = open("/dev/fuse", O_RDWR);
-- 
2.43.0

