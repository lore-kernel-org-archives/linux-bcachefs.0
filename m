Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043711B85C2
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727146358; cv=none; b=tSx9+akNvH9+hmkhvVaI3rRah1GiKXJ4gdURN+s0+HmF/7NkRRjWnM/8Pnyxy8pZZTHEBN6DUS6TKOkjws2mx/c/cUpXBDaMrxg0E+GTnlGAaQOX223AnuJsFnuq4S5OBHAvlA4OD80Nnz8f2ixQXWVyYFrBarVxTJ9nMKo5bEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727146358; c=relaxed/simple;
	bh=/AMTC+LFv3NnH4++XwGOj8dYdE+MOw0Bkn/TlGWF1v4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1tyyN6H9cp9ibitQ+Mawno4yZ3DMc625iLe9it+L/ptvj5TUW8llKxLOnMdEa3dp3pzcNiXb9y/L+fo+I0ovxidg7nYfcUY5PdFGeRdMh4/c8rT0oOO/ogcO8DwUenWELTEQ91QiJwUquf7nBeT8021nIB7vazJVfrAlwH6dkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z0jxAapP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4XZcD8J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z0jxAapP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E4XZcD8J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z0jxAapP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E4XZcD8J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z0jxAapP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E4XZcD8J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 638A01FBB7;
	Tue, 24 Sep 2024 02:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727146348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CH8FkDKc0Zbt1fHLGksHLScDLcfTyBcdgV5ak+FThs4=;
	b=z0jxAapPrf+ZxYxcQFfzTrhbFtb0LfKNOEMxAW9ygl8R/sY0Ig1KpdH/hyQUAh+QKU0SbT
	nxRLwWx8torE23A2VsTNdzywuST7B34zx0/omTtDTxpUkL2s1JFdbvKJXqbOOoOplDS5ji
	B8+H7mgdOWUCMXzP/3hKJ5ClO/OMp1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727146348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CH8FkDKc0Zbt1fHLGksHLScDLcfTyBcdgV5ak+FThs4=;
	b=E4XZcD8JQNPm8fAEbD/fPfjPoluSdTovDnPaO/C3SE/SNdvYDdRMN05jxrMJybTxL8LbZj
	Es5SlT34pHkpsbDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727146348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CH8FkDKc0Zbt1fHLGksHLScDLcfTyBcdgV5ak+FThs4=;
	b=z0jxAapPrf+ZxYxcQFfzTrhbFtb0LfKNOEMxAW9ygl8R/sY0Ig1KpdH/hyQUAh+QKU0SbT
	nxRLwWx8torE23A2VsTNdzywuST7B34zx0/omTtDTxpUkL2s1JFdbvKJXqbOOoOplDS5ji
	B8+H7mgdOWUCMXzP/3hKJ5ClO/OMp1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727146348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CH8FkDKc0Zbt1fHLGksHLScDLcfTyBcdgV5ak+FThs4=;
	b=E4XZcD8JQNPm8fAEbD/fPfjPoluSdTovDnPaO/C3SE/SNdvYDdRMN05jxrMJybTxL8LbZj
	Es5SlT34pHkpsbDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F6F61386E;
	Tue, 24 Sep 2024 02:52:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5xOFMGop8mZtIQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 24 Sep 2024 02:52:26 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] bcachefs: avoid copy from NULL printbuf
Date: Tue, 24 Sep 2024 02:52:15 +0000
Message-ID: <20240924025215.29891-1-ddiss@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

printbuf.buf may be NULL if allocation_failure is set. Check for this
prior to using it as a seq_puts() source.

Fixes: fa8e94faeece1 ("bcachefs: Heap allocate printbufs")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
test test

 fs/bcachefs/fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 1aee5bafaae54..6e270bf24591d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1931,13 +1931,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct bch_fs *c = root->d_sb->s_fs_info;
 	struct printbuf buf = PRINTBUF;
+	int ret = 0;
 
 	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
 			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
 	printbuf_nul_terminate(&buf);
-	seq_puts(seq, buf.buf);
+	if (buf.allocation_failure)
+		ret = -ENOMEM;
+	else
+		seq_puts(seq, buf.buf);
 
-	int ret = buf.allocation_failure ? -ENOMEM : 0;
 	printbuf_exit(&buf);
 	return ret;
 }
-- 
2.46.1

