Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA2417993
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Sep 2024 06:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727160070; cv=none; b=WrvZ2UVeDD233tPtPBH/kXRjBvEBIMyuXX84uXRpMu4Xz6DSzMJbFkd6CpoJ9VRaJkHgI6kTQYYGgnfJIHHEfKgi69Ms9h6OhOJpvi/eUipfbcOcHJzd94VhesLFQ1UXuonrrc1T+tQJ/MNoaKXRcdsp2DnPqKuIGL27ZtxogUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727160070; c=relaxed/simple;
	bh=PNTcqhH5vVzku5VJHsVTzQLU4AvelZSgNc1gXC7Ga4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+kzNeaTyIqzRmcO3a0fDpNtjwqmWpy2UnLuvL4Qa+2E7HX2oESVbi3KczKEpJQT7Ew6MApmkqDrH8f2Zld3Lbu5buvOGtlWsqhbxFbcW3aVoAksWZ89rZIMmpVpZj5blnmV0egTe4uCPtAf0c9U5eqNxlSTKNu/THDDF+pAXOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mqyWYSc9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LjKH3SZR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mqyWYSc9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LjKH3SZR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mqyWYSc9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LjKH3SZR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mqyWYSc9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LjKH3SZR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 876A221AE0;
	Tue, 24 Sep 2024 06:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727160061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ViESt/gtBZCHOvglfMW7rOT5C4Tb1p3zBMDBlc7nsuE=;
	b=mqyWYSc9UmL2aSw6PO+e+P52RKTicMNvXrGTF7ei2gxVcwTeyLjG814wvs1VfWf1SVGrxh
	RPBSxGSKEIc9qSFLoB4UHlSuDUbzKOK/rgu39DAyKUhcuf7O4LSZiPp691O7H6ShvVYBAD
	CIwIEYjg6jm8WQQH7iZrtlZ1PQbYKUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727160061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ViESt/gtBZCHOvglfMW7rOT5C4Tb1p3zBMDBlc7nsuE=;
	b=LjKH3SZRR4rC6YgrhOHMp0Rtji+jkUxsTjfdPPCTyeUAY3ypznMyyoxJTcHEK+QUeAmxi0
	iTeiJ54S+g4NihAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727160061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ViESt/gtBZCHOvglfMW7rOT5C4Tb1p3zBMDBlc7nsuE=;
	b=mqyWYSc9UmL2aSw6PO+e+P52RKTicMNvXrGTF7ei2gxVcwTeyLjG814wvs1VfWf1SVGrxh
	RPBSxGSKEIc9qSFLoB4UHlSuDUbzKOK/rgu39DAyKUhcuf7O4LSZiPp691O7H6ShvVYBAD
	CIwIEYjg6jm8WQQH7iZrtlZ1PQbYKUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727160061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ViESt/gtBZCHOvglfMW7rOT5C4Tb1p3zBMDBlc7nsuE=;
	b=LjKH3SZRR4rC6YgrhOHMp0Rtji+jkUxsTjfdPPCTyeUAY3ypznMyyoxJTcHEK+QUeAmxi0
	iTeiJ54S+g4NihAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DBD21386E;
	Tue, 24 Sep 2024 06:40:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id va0oOPte8mbfVgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 24 Sep 2024 06:40:59 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] bcachefs: handle printbuf ENOMEM before use
Date: Tue, 24 Sep 2024 06:40:37 +0000
Message-ID: <20240924064037.5556-1-ddiss@suse.de>
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
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

Fixes: 9c5d38bba0342 ("bcachefs: Don't print out duplicate fsck errors")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 fs/bcachefs/error.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 95afa7bf20205..b2c188c2d4e37 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -251,6 +251,11 @@ int __bch2_fsck_err(struct bch_fs *c,
 	prt_vprintf(out, fmt, args);
 	va_end(args);
 
+	if (out->allocation_failure) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	/* Custom fix/continue/recreate/etc.? */
 	if (out->buf[out->pos - 1] == '?') {
 		const char *p = strrchr(out->buf, ',');
-- 
2.43.0

