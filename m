Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C4B1803E
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Sep 2024 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726537237; cv=none; b=WiI9qObW87fFS7bzcp+24QUOTkzc1tZHEV6qEUqWeA8oY/d9lkxg4z/c+l7et5PZELDTPLx9+LaW2d1euKH76V/sOkBn5gzq1bu/BxDSfC7sLlZQiOU3ylVJLDAmqI6QT3hrDhS9GuLX/GI7weTZ8zlnlKMg3K2xyLBJ+oxnmsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726537237; c=relaxed/simple;
	bh=fgJ8hmWxmO6lyYwJXw3FAr8Ai0bOM+qZ15SsovrBFvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A0jhnX6xR4Zb7pCW2A3eqatcVZ1N6AWjNDUQ8qegj2hAf6ajbvmGXHiL0mODZOhDVPpeN1SYOef9BRxbjE2QDV1BYxEH1QJp4ZJDX6ZlqHrjR/Vm/Le4IEDoMxhJDfTr3dbd1XprqTIZD4og/QG0z8eZ2xXnaJ7lbCTRG8nLegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eYEzKE6o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aMq0ywUM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eYEzKE6o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aMq0ywUM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eYEzKE6o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aMq0ywUM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eYEzKE6o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aMq0ywUM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7DEA321E36;
	Tue, 17 Sep 2024 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726537233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MooUwaWJN+Lz29AXTiDZtMp00GCO36VGBDqmzsWShYk=;
	b=eYEzKE6oKj2T9QrELfWdVOND05QXagszK2tx2kyFRw79Uv2ky9xTclvppVLf2B5fFN7r/n
	EmYFQjDidQvxyQhX6kYSPQRThmZ9yWT9J4wR0NHE2ohIOC6zjcEODC8hfUkgYuo7tDQGDJ
	1AIQQGeLDZ3ZTPN+GufSQ6l6VMXOhpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726537233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MooUwaWJN+Lz29AXTiDZtMp00GCO36VGBDqmzsWShYk=;
	b=aMq0ywUMmkferMehA/+GmdiLAXElFAk3GwFxF+dJjGJn4/r04TyGXkqpr1gsEMKvCrzkvh
	CjVKpmrBIzJaLwBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726537233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MooUwaWJN+Lz29AXTiDZtMp00GCO36VGBDqmzsWShYk=;
	b=eYEzKE6oKj2T9QrELfWdVOND05QXagszK2tx2kyFRw79Uv2ky9xTclvppVLf2B5fFN7r/n
	EmYFQjDidQvxyQhX6kYSPQRThmZ9yWT9J4wR0NHE2ohIOC6zjcEODC8hfUkgYuo7tDQGDJ
	1AIQQGeLDZ3ZTPN+GufSQ6l6VMXOhpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726537233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MooUwaWJN+Lz29AXTiDZtMp00GCO36VGBDqmzsWShYk=;
	b=aMq0ywUMmkferMehA/+GmdiLAXElFAk3GwFxF+dJjGJn4/r04TyGXkqpr1gsEMKvCrzkvh
	CjVKpmrBIzJaLwBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9487813A79;
	Tue, 17 Sep 2024 01:40:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JiGGEQ/e6GYGaAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 17 Sep 2024 01:40:31 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>,
	Martin Doucha <martin.doucha@suse.com>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH resend v2] bcachefs: reject unknown mount options
Date: Tue, 17 Sep 2024 01:39:57 +0000
Message-ID: <20240917013957.13353-1-ddiss@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensuse.org:url,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

This is effectively a revert of commit 03ef80b469d5 ("bcachefs: Ignore
unknown mount options"), rebased atop commit 929d954330142 ("bcachefs:
use new mount API").

Contrary to the 03ef80b469d5 commit message, unknown mount options do
result in failure on other filesystems such as xfs, btrfs, ext4, etc.

Ignoring unknown options may result in unexpected behaviour: e.g. if
an application requires future-workload-specific-mount-option to work
and is run on a system without future-workload-specific-mount-option
kernel support, then it may fail without indication of the missing
kernel functionality.

This reversion may cause failures for existing users reliant on the
ignore-unknown behaviour, but it should be bearable given bcachefs is
still flagged experimental.

Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
Reported-by: Martin Doucha <martin.doucha@suse.com>
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/opts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da71b19..bc5c180878212 100644
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

