Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2B418D
	for <linux-bcachefs@vger.kernel.org>; Fri,  6 Sep 2024 00:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725581147; cv=none; b=RHiwRKskulLIFxKWCyuB7h1q+yamgujHJ5ejqL5j3m/ADoBIaKgeHEUxK8mrCg8JP/XdTiOuols3sHAIpyORuEPEhoSlewdW7vsSPG36vJBM549S2I/mxMZ5/s3Ca52Y+Vk7HZM8B7EJR+FANlaQ0lVNGEgx+3WxMTciXb8TiLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725581147; c=relaxed/simple;
	bh=37jx5ZsbLkymFX7CLM2nFW6mW5b2xn0Fo7SLgUap9Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YwJvBgruptKjXNrEQhnxEJjBIGlIsOVA1M/aENgx3X5BlCOW20Mjc50VbkBIYTHZz8W7SuWtihqIK22hGEoTR9r9K2VgmyW2a7GLlTAwZkgNLUFsjHxpVtuYkWCKXYetVarNZI8eIJl9xjF9ZqIBVaXg1MGmHOaneHb5QZYBMIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FDtwtRt2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OF7rPXda; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FDtwtRt2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OF7rPXda; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FDtwtRt2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OF7rPXda";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FDtwtRt2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OF7rPXda"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F6AC21A9E;
	Fri,  6 Sep 2024 00:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725581144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oYdhNZQQtjOahbNDSQl+WJcHru7dNr/S9I9if1kbJK8=;
	b=FDtwtRt2rtkN4zDt29BtHyKcurebN0ChNtMYVW55TfTYUN8DLGjBE3vegyK0rT3hvKDoTL
	d5SGw3ZUGywpPTc9mpiDnH91KO4y5xqmbdry/I7rAujB3ueexFe1pYXVHVR6PEmIBP9h+U
	6icg+EDkLu+woAGdea/0C02yn+opFRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725581144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oYdhNZQQtjOahbNDSQl+WJcHru7dNr/S9I9if1kbJK8=;
	b=OF7rPXdagmBpBqitG8QDiug8iTvr5AxWnCZEAYeB3OPio3QonzYuPcxXOdUHZEk0N+lMXL
	XiBm5Z4ydjJJFMDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725581144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oYdhNZQQtjOahbNDSQl+WJcHru7dNr/S9I9if1kbJK8=;
	b=FDtwtRt2rtkN4zDt29BtHyKcurebN0ChNtMYVW55TfTYUN8DLGjBE3vegyK0rT3hvKDoTL
	d5SGw3ZUGywpPTc9mpiDnH91KO4y5xqmbdry/I7rAujB3ueexFe1pYXVHVR6PEmIBP9h+U
	6icg+EDkLu+woAGdea/0C02yn+opFRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725581144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oYdhNZQQtjOahbNDSQl+WJcHru7dNr/S9I9if1kbJK8=;
	b=OF7rPXdagmBpBqitG8QDiug8iTvr5AxWnCZEAYeB3OPio3QonzYuPcxXOdUHZEk0N+lMXL
	XiBm5Z4ydjJJFMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 852C113A56;
	Fri,  6 Sep 2024 00:05:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BHftDVZH2mbENQAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 06 Sep 2024 00:05:42 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>,
	Martin Doucha <martin.doucha@suse.com>
Subject: [PATCH v2] bcachefs: reject unknown mount options
Date: Fri,  6 Sep 2024 00:03:47 +0000
Message-ID: <20240906000346.22939-2-ddiss@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email,suse.com:email];
	RCVD_TLS_ALL(0.00)[]
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
---
Changes since v1:
- reword commit message and add Fixes tag

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

