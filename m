Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZZ/CALH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hVEI9LMe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZZ/CALH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hVEI9LMe"
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734DA10F7;
	Thu,  7 Dec 2023 11:40:39 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0EAAD1F750;
	Thu,  7 Dec 2023 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701978038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DwboQL/DHJSf9SD8lSKa4XQy4oebdMOBMZGqQH9yO8=;
	b=FZZ/CALHkph1b5c1SRxJdqmZNQc+KWLFOaiztbc82nBynO2SuiXAMHk6JWeMDd7rZuchoT
	9uUJkc/SqC7u5oqkw1mr6gbqGRKtnPEOFG9quL7AIr5C+yboStGkr991Df5mkmTZDm2wnw
	iahatC6iPnAPgdVI9Tfvoi5Q+UjJXSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701978038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DwboQL/DHJSf9SD8lSKa4XQy4oebdMOBMZGqQH9yO8=;
	b=hVEI9LMeECsG42Xkerv6wMgNRk+ljL53MtapbbWrI7TU7glQSBRSfIVTkJsyfu0mBsNd+c
	smG8rWRz47OK+mAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701978038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DwboQL/DHJSf9SD8lSKa4XQy4oebdMOBMZGqQH9yO8=;
	b=FZZ/CALHkph1b5c1SRxJdqmZNQc+KWLFOaiztbc82nBynO2SuiXAMHk6JWeMDd7rZuchoT
	9uUJkc/SqC7u5oqkw1mr6gbqGRKtnPEOFG9quL7AIr5C+yboStGkr991Df5mkmTZDm2wnw
	iahatC6iPnAPgdVI9Tfvoi5Q+UjJXSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701978038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DwboQL/DHJSf9SD8lSKa4XQy4oebdMOBMZGqQH9yO8=;
	b=hVEI9LMeECsG42Xkerv6wMgNRk+ljL53MtapbbWrI7TU7glQSBRSfIVTkJsyfu0mBsNd+c
	smG8rWRz47OK+mAw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C7A913B96;
	Thu,  7 Dec 2023 19:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id QDG5NLQfcmVyBQAAn2gu4w
	(envelope-from <pvorel@suse.cz>); Thu, 07 Dec 2023 19:40:36 +0000
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
	fstests@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
Date: Thu,  7 Dec 2023 20:40:11 +0100
Message-ID: <20231207194011.273027-4-pvorel@suse.cz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231207194011.273027-1-pvorel@suse.cz>
References: <20231207194011.273027-1-pvorel@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -0.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [0.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 R_RATELIMIT(0.00)[to_ip_from(RLecpkqykizks3u9s7xp6n6wei)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[14];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[suse.cz,redhat.com,suse.com,fujitsu.com,linux.dev,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[32.49%]
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.90

STATX_ATTR_COMPRESSED is not supported on Bcachefs, thus skip it
(it's already skipped on tmpfs and XFS).

Suggested-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Petr Vorel <pvorel@suse.cz>
---
New in v2

 testcases/kernel/syscalls/statx/statx04.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/testcases/kernel/syscalls/statx/statx04.c b/testcases/kernel/syscalls/statx/statx04.c
index 58296bd24..c2ed52deb 100644
--- a/testcases/kernel/syscalls/statx/statx04.c
+++ b/testcases/kernel/syscalls/statx/statx04.c
@@ -96,8 +96,9 @@ static void setup(void)
 	for (i = 0, expected_mask = 0; i < ARRAY_SIZE(attr_list); i++)
 		expected_mask |= attr_list[i].attr;
 
-	/* STATX_ATTR_COMPRESSED not supported on XFS, TMPFS */
-	if (!strcmp(tst_device->fs_type, "xfs") || !strcmp(tst_device->fs_type, "tmpfs"))
+	/* STATX_ATTR_COMPRESSED not supported on Bcachefs, TMPFS, XFS */
+	if (!strcmp(tst_device->fs_type, "bcachefs") || !strcmp(tst_device->fs_type, "tmpfs") ||
+	    !strcmp(tst_device->fs_type, "xfs"))
 		expected_mask &= ~STATX_ATTR_COMPRESSED;
 
 	/* Attribute support was added to Btrfs statx() in kernel v4.13 */
-- 
2.43.0

