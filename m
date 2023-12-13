Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fNSxBj8J";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="q5uAsB1z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Imxu1RF/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="USthpHul"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8352EB9
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Dec 2023 08:51:14 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3D7F225E7;
	Wed, 13 Dec 2023 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702486273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MjnSZcYc2/R6+mXiil5KbjqjW0fm464lxdVIEs0fbPs=;
	b=fNSxBj8JpKirvKLEhfBgEl0grOj1QeJE7oC7yvTIPORKQNZaEpQu23bs31KahnVHzQR0MD
	FgE6mLTX8P+OgrXGLJzmIxMh451Ag5NZZ673RpAy0XL2mtCsPbTMvHXZ6Rg6fpr6QlSBlm
	nMYYxDzqABmbWOhDb33svsvVkjB1QDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702486273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MjnSZcYc2/R6+mXiil5KbjqjW0fm464lxdVIEs0fbPs=;
	b=q5uAsB1zBDfVraAze9j8I+sKr8uknuxvS7ngSEcx7VN6+mWm6l/1LNeFChQTYLsoGZGdES
	NN0qU5L5lBLxtFCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1702486272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MjnSZcYc2/R6+mXiil5KbjqjW0fm464lxdVIEs0fbPs=;
	b=Imxu1RF/1X1rVq+qWCEiExfU0UZfM4L910aMzAmjrh/vJZlXbGLEMxf8L65W/QJ5PfaqQ8
	94mFVK7yBygOvMDe3pc0psRoaDCBWvE2LV2kfAL+x0lK8dueg1EhfAXQukFfuiKuJn6dT4
	8rjnJnXgnX0d30SQY/Ybu21b111ZNFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1702486272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MjnSZcYc2/R6+mXiil5KbjqjW0fm464lxdVIEs0fbPs=;
	b=USthpHul1CNE/Obi1vLkoxwTVnWF7cjyUV7/JC8hfVvJAF0PcsyDOKMfCbXOs8IS/izmVt
	EA/AmD9OJjoQo0BQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id C353B1391D;
	Wed, 13 Dec 2023 16:51:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id ZEFfLwDheWUCbQAAn2gu4w
	(envelope-from <jack@suse.cz>); Wed, 13 Dec 2023 16:51:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64F8AA07E0; Wed, 13 Dec 2023 17:51:08 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	Petr Vorel <pvorel@suse.cz>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] bcachefs: Fix determining required file handle length
Date: Wed, 13 Dec 2023 17:51:04 +0100
Message-Id: <20231213165104.19716-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; i=jack@suse.cz; h=from:subject; bh=qiAIQXpkDgsaS4bmtJBzQW3VN1jt0bNBPUdFhdxLpRM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBleeDybgiwIdhnwSoiqIRQiHyqW3D26jkIwQ/nwLBb qCJquUeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZXng8gAKCRCcnaoHP2RA2akVCA CrqkDRI3lQWQT4/GGX8r/PMFuU/2MxFPy2kUyCIlCosFvlqVfKmVp9n+kL9iDJIMDKm7jOOzqbcraV CTyk8XjuNyZIgU+Cw2O2Jmdz4dHRH+5GBB9h2rVZAkVUGehieIE7Dh0b6VflULfpXZEzhS/2aMrdU7 jEUswBYzSloH3rSZzcvSstI/n2Okpt4ZDHDYYoM9hhDMdYWnWLQ1FtdDmG6v6RK5BkFjZRG2QnRq1A vysuAySlxht935WYoLhShVsw+V2OBgS5eY2e52rBSPhf9JFAnYoi3q/6T+wPWsNttHtCXTJ6kOsCf/ RSo/61EzKz4AUSF2XirihGQVzLHjGs
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: 4.90
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: 3.78
X-Spamd-Result: default: False [3.78 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.12)[-0.616];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The ->encode_fh method is responsible for setting amount of space
required for storing the file handle if not enough space was provided.
bch2_encode_fh() was not setting required length in that case which
breaks e.g. fanotify. Fix it.

Reported-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bcachefs/fs.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4d51be813509..fec558343ebb 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1143,24 +1143,33 @@ static int bch2_encode_fh(struct inode *vinode, u32 *fh, int *len,
 {
 	struct bch_inode_info *inode	= to_bch_ei(vinode);
 	struct bch_inode_info *dir	= to_bch_ei(vdir);
-
-	if (*len < sizeof(struct bcachefs_fid_with_parent) / sizeof(u32))
-		return FILEID_INVALID;
+	int min_len;
 
 	if (!S_ISDIR(inode->v.i_mode) && dir) {
 		struct bcachefs_fid_with_parent *fid = (void *) fh;
 
+		min_len = sizeof(*fid) / sizeof(u32);
+		if (*len < min_len) {
+			*len = min_len;
+			return FILEID_INVALID;
+		}
+
 		fid->fid = bch2_inode_to_fid(inode);
 		fid->dir = bch2_inode_to_fid(dir);
 
-		*len = sizeof(*fid) / sizeof(u32);
+		*len = min_len;
 		return FILEID_BCACHEFS_WITH_PARENT;
 	} else {
 		struct bcachefs_fid *fid = (void *) fh;
 
+		min_len = sizeof(*fid) / sizeof(u32);
+		if (*len < min_len) {
+			*len = min_len;
+			return FILEID_INVALID;
+		}
 		*fid = bch2_inode_to_fid(inode);
 
-		*len = sizeof(*fid) / sizeof(u32);
+		*len = min_len;
 		return FILEID_BCACHEFS_WITHOUT_PARENT;
 	}
 }
-- 
2.35.3

