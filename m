Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BDE208C9;
	Thu, 18 Jan 2024 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705568419; cv=none; b=tfrrH4RxtgSVHNKPP/vA6FCm8wrWW38NnkbSFpcz7anbVWTV8KlAbH1j61qkvq6LmNIjXovNXP/GlD09XsLETDmbw/fNYivPIqIQxv0cXLbdy6+if2t4G+/U2S2I2GmK5zsyy7QJCfN6J7HnsnhK2J3lg8aLqrrwErjK8wXhT98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705568419; c=relaxed/simple;
	bh=se7z6adz9nviIqYENvt7nq7zrehjz1+jdUJ2lRfcRxM=;
	h=Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spamd-Result:X-Spam-Level:X-Spam-Score:X-Spam-Flag; b=Ugc9bnNQsxRuWKMDEizI5/n8uTFjlu0S6CkqHRtRqgyxh+Uy7RNQgYqSizo97PLOtqpfT86o0PnkUdmyfXDz7iW5pjYgJdVkJ8A30SV19EUiY7W8TwIao/wwOQODusuIygyoxuRiLAJwctnOMDtp/T9b8Fo7+yHbIWNbKMI0+MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MFiPLupX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+KWY0Bk5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zh48p0VG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uRfGgje1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MFiPLupX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+KWY0Bk5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zh48p0VG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uRfGgje1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5AA1E1F76E;
	Thu, 18 Jan 2024 09:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705568415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B0p7urB7wmsb6dkQLoDkW2Eq0MLph5IqLA7LzKlWVtQ=;
	b=MFiPLupXoI/IjAFBOm+i8VxEFvE9hLE3jyvyjnNE/brjFelGGsBJ/qWJeTOxsVV8rbGJ/z
	d4cMfqJqapzeMt+uQ8P0Ixp8oA2xeMYKR6HRe68hrpk7+zA009qPshBkMd4AxOblvAVj0V
	0F7ICy23Y+uSdMciISIVpjhKXKBChug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705568415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B0p7urB7wmsb6dkQLoDkW2Eq0MLph5IqLA7LzKlWVtQ=;
	b=+KWY0Bk5LOi9Mi7trAeQusRxYkvp4JhbEGiwIBz0jjJjLSENlymcBTrwI72vUjgaICh6P9
	uEIwkx8t44gJ7yBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705568414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B0p7urB7wmsb6dkQLoDkW2Eq0MLph5IqLA7LzKlWVtQ=;
	b=zh48p0VG8fbrBt+T/qJYdSzf9+Zf1O3R5Ya1py1kJPTrO7LyZcWz0hChYPE3uvjR4qu21H
	68N/l7jcI5zQBHOgTCYIXFr9YHD5nx6CUXbVcGisHIYkV8GjiQPenxdne73RwqiFdvhcX6
	osVjNH5dqLBuHN2YQMS9HhEZuMoCJh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705568414;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B0p7urB7wmsb6dkQLoDkW2Eq0MLph5IqLA7LzKlWVtQ=;
	b=uRfGgje1H/VAtaqD68L+XB03JUuvQ52sO6hza1OrSr2gfeAA+fKHMNaFqkUwuldrT4qJWd
	p5a1J89zF+1IACDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DBDA136F5;
	Thu, 18 Jan 2024 09:00:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pq1aCZ3oqGVnMAAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Thu, 18 Jan 2024 09:00:13 +0000
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
Subject: [PATCH 1/1] tst_supported_fs_types: Disable FUSE bcachefs
Date: Thu, 18 Jan 2024 10:00:04 +0100
Message-ID: <20240118090004.2748107-1-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [4.54 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.36)[76.67%]
X-Spam-Level: ****
X-Spam-Score: 4.54
X-Spam-Flag: NO

bcachefs got into the kernel in 6.7 therefore it's not much useful for
testing FUSE version.

NOTE: The original purpose for this was a failure with bcachefs-tools on
kernel without bcachefs support (e.g. kernel < 6.7):

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

Suggested-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
 lib/tst_supported_fs_types.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/tst_supported_fs_types.c b/lib/tst_supported_fs_types.c
index 369836717..bbbb8df19 100644
--- a/lib/tst_supported_fs_types.c
+++ b/lib/tst_supported_fs_types.c
@@ -33,6 +33,11 @@ static const char *const fs_type_whitelist[] = {
 	NULL
 };
 
+static const char *const fs_type_fuse_blacklist[] = {
+	"bcachefs",
+	NULL,
+};
+
 static const char *fs_types[ARRAY_SIZE(fs_type_whitelist)];
 
 static int has_mkfs(const char *fs_type)
@@ -96,6 +101,11 @@ static enum tst_fs_impl has_kernel_support(const char *fs_type)
 
 	SAFE_RMDIR(template);
 
+	if (tst_fs_in_skiplist(fs_type, fs_type_fuse_blacklist)) {
+		tst_res(TINFO, "Skipping %s because of FUSE blacklist", fs_type);
+		return TST_FS_UNSUPPORTED;
+	}
+
 	/* Is FUSE supported by kernel? */
 	if (fuse_supported == -1) {
 		ret = open("/dev/fuse", O_RDWR);
-- 
2.43.0

