Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7498F507
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 02:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725502288; cv=none; b=YpDOBHMPUX2/oGAlVWaFTldvdrgl3UuMCV0YT9i3LpedgoZ9Gv4tMaeAJpNCOi64UzC4osLqslvFFxF+esW3PVsd5oTvB2C+y9GN90R0BsDSQN2dz/tMwtvvnD/BSPlXUILCqq0TNiH8U0J4hpwLn4C8E18bf0aQ+aTfOGzmskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725502288; c=relaxed/simple;
	bh=cRz3MRM7m7YUfhVubLwnq/DbmNgMy8INFBDvEvE1aUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RoPMxZkzkbkfCkuhYEaJfe2uTvTOiXodjP4tS/iB4t4cWFxh6SaRT+dcw8GINnUhqJSzkNh6o1gQJKEHu/rancYVLiStifVR+zZZd2SYPM/mZE2Skm0KZWY5PeFrFV9EW1Crzdeb8JaPhzWJk4gn3EocfWEXzX+9NGlTBRwA6Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D4/U8hMq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o5LtT2SN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D4/U8hMq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=o5LtT2SN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D4/U8hMq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o5LtT2SN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D4/U8hMq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="o5LtT2SN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3E4921904;
	Thu,  5 Sep 2024 02:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725502283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0pJU2dfm2YP4OelIPL+5Y8QXYjagi1JmQDO9ggWbC1c=;
	b=D4/U8hMqnRQyvU9bXZRTXfDAz4r/5iDXq5xKbI6f6xBOmTkM6MXdARgb6d6gwD84Pl7gob
	3H5JTM3NAcLmSnqSEPIFcQzzXz0OasvrnPdqkADNfK+ZDrTioV0NJDZoNXncUHj66uQbW7
	YTSOTjKlypI0XAVvLVnnMvemkwebzYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725502283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0pJU2dfm2YP4OelIPL+5Y8QXYjagi1JmQDO9ggWbC1c=;
	b=o5LtT2SNUbMFzebwr49y29kvRfgh4d8mC3CeTKz/zy/tAP7HNaR3450i2XYWEKexLGxGWU
	jAPEqe99dgar45Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="D4/U8hMq";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o5LtT2SN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725502283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0pJU2dfm2YP4OelIPL+5Y8QXYjagi1JmQDO9ggWbC1c=;
	b=D4/U8hMqnRQyvU9bXZRTXfDAz4r/5iDXq5xKbI6f6xBOmTkM6MXdARgb6d6gwD84Pl7gob
	3H5JTM3NAcLmSnqSEPIFcQzzXz0OasvrnPdqkADNfK+ZDrTioV0NJDZoNXncUHj66uQbW7
	YTSOTjKlypI0XAVvLVnnMvemkwebzYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725502283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0pJU2dfm2YP4OelIPL+5Y8QXYjagi1JmQDO9ggWbC1c=;
	b=o5LtT2SNUbMFzebwr49y29kvRfgh4d8mC3CeTKz/zy/tAP7HNaR3450i2XYWEKexLGxGWU
	jAPEqe99dgar45Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DD55139D2;
	Thu,  5 Sep 2024 02:11:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TPjBL0kT2WZ3OgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 05 Sep 2024 02:11:21 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>,
	Martin Doucha <martin.doucha@suse.com>
Subject: [PATCH] Revert "bcachefs: Ignore unknown mount options"
Date: Thu,  5 Sep 2024 02:09:56 +0000
Message-ID: <20240905020956.29821-1-ddiss@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3E4921904
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:email,suse.de:dkim,suse.de:mid,opensuse.org:url];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO

This reverts commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b.

Contrary to the commit message, unknown mount options do result in
failure on other filesystems such as xfs, btrfs, ext4, etc.

Ignoring unknown options may result in unexpected behaviour: e.g. if
an application requires future-workload-specific-mount-option to work
and is run on a system without future-workload-specific-mount-option
kernel support, then it may fail without indication of the missing
kernel functionality.

This reversion may cause failures for existing users reliant on the
ignore-unknown behaviour, but it should be bearable given bcachefs is
still flagged experimental.

Reported-by: Martin Doucha <martin.doucha@suse.com>
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 fs/bcachefs/opts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da71b1..bc5c18087821 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -482,9 +482,8 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 		val = "0";
 	}
 
-	/* Unknown options are ignored: */
 	if (id < 0)
-		return 0;
+		goto bad_opt;
 
 	if (!(bch2_opt_table[id].flags & OPT_MOUNT))
 		goto bad_opt;
-- 
2.43.0

