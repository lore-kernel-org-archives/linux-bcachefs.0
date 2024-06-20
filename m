Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BA11CA1
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 04:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718859509; cv=none; b=h9sMvExhOCq3dTmgkSUmqNr+G6GWrUy4mwj5CzWpJ9xG9u0ZIogeb/Ia8eekuibznsKtCBqsC+A6PJJ24d/fcKyrUjt3sprnZBG36tA7jkavJuiueEUKtJeh0/a7syhqk5azlmmIQus90zcF/xZ9RgHgDF1Xi7GezonsALkgv20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718859509; c=relaxed/simple;
	bh=AtGLIPBfAZcy4323pOjf5SHSksOfXAJnzkETpPsbSsE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=pEIVskXYvkhDkBW4lwHjmWxQqY5QcWE6t2jnLChM/F7hgR5PxkbpsOLiJb7MbzdV8KpqigjJOIxZc1YfkYXxQTQqyiFW/1peLUFv4w/UMkQ7tbv5q79QOjZnuo70Gteh/iuZ+dqbQiGopGj8it0C/Q87URK9pKZXhOIFZOvgb2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fB9FZrhg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BVWBso+s; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fB9FZrhg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BVWBso+s; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fB9FZrhg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BVWBso+s";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fB9FZrhg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BVWBso+s"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C216C1F84E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 04:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718859498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3qk3OZi7/VHHvDYDHpEakXrFsNogucJq11i59pVs1fw=;
	b=fB9FZrhgF3+mNiqVBeLwXPASiMekCMoyhSeraKxslbNvhxLwQ6+qyVZCW+Ztv4wTUQSAiK
	nWaCGv05fmCTmooHluuyVdUIIi34u6kvEOKUO+RYAtTiMb90GLajoLZ+/LDr89o6LUuIht
	N0A+OTouGAlj5rfFom1Ua+dC+P0PnOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718859498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3qk3OZi7/VHHvDYDHpEakXrFsNogucJq11i59pVs1fw=;
	b=BVWBso+s0hBZlM/g2kFCDyNS6Lbx4WBk/X2K+YY2OdLY4Sg30DT/aXAJ7UeoZnPgkEevB9
	IhixSiyB+Ehhr6BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718859498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3qk3OZi7/VHHvDYDHpEakXrFsNogucJq11i59pVs1fw=;
	b=fB9FZrhgF3+mNiqVBeLwXPASiMekCMoyhSeraKxslbNvhxLwQ6+qyVZCW+Ztv4wTUQSAiK
	nWaCGv05fmCTmooHluuyVdUIIi34u6kvEOKUO+RYAtTiMb90GLajoLZ+/LDr89o6LUuIht
	N0A+OTouGAlj5rfFom1Ua+dC+P0PnOM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718859498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3qk3OZi7/VHHvDYDHpEakXrFsNogucJq11i59pVs1fw=;
	b=BVWBso+s0hBZlM/g2kFCDyNS6Lbx4WBk/X2K+YY2OdLY4Sg30DT/aXAJ7UeoZnPgkEevB9
	IhixSiyB+Ehhr6BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C31CA1369F
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 04:58:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gF33G+m2c2bvIwAAD6G6ig
	(envelope-from <ddiss@suse.de>)
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 04:58:17 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Subject: [tools PATCH 0/1] 32-bit build issues
Date: Thu, 20 Jun 2024 14:58:03 +1000
Message-Id: <20240620045804.27888-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.11 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	BAYES_HAM(-0.31)[75.16%];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensuse.org:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-bcachefs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -0.11
X-Spam-Level: 

I've run into a few 32-bit arch specific issues when attempting to
package the latest v1.9.1 tools release:
- c_long vs i64 type mixing for keyctl_search()
  * This one looks pretty straightforward, see follow-up PATCH 1/1 mail

- error[E0588]: packed type cannot transitively contain a `#[repr(align)]` type
  * maybe related to https://github.com/rust-lang/rust-bindgen/issues/2179
       --> bcachefs-tools-1.9.1/target/release/build/bch_bindgen-ea7db20b4c53ec29/out/bcachefs.rs:32702:1
        |
  32702 | pub struct bkey_inode_buf {
        | ^^^^^^^^^^^^^^^^^^^^^^^^^
        |
  note: `bch_inode_v3` has a `#[repr(align)]` attribute
       --> bcachefs-tools-1.9.1/target/release/build/bch_bindgen-ea7db20b4c53ec29/out/bcachefs.rs:8988:1
        |
  8988  | pub struct bch_inode_v3 {
        | ^^^^^^^^^^^^^^^^^^^^^^^
  note: `bkey_inode_buf` contains a field of type `bkey_i_inode_v3`
       --> bcachefs-tools-1.9.1/target/release/build/bch_bindgen-ea7db20b4c53ec29/out/bcachefs.rs:32703:9
        |
  32703 |     pub inode: bkey_i_inode_v3,
        |         ^^^^^
  note: ...which contains a field of type `bch_inode_v3`
       --> bcachefs-tools-1.9.1/target/release/build/bch_bindgen-ea7db20b4c53ec29/out/bcachefs.rs:28906:9
        |
  28906 |     pub v: bch_inode_v3,
  * see https://build.opensuse.org/public/build/home:ddiss:bcachefs_upstream_vendor/openSUSE_Tumbleweed/i586/bcachefs-tools/_log

- undefined reference to `atomic64_try_cmpxchg'
  * this looks like an arm7l specific regression from the
    atomic64_cmpxchg -> atomic64_try_cmpxchg conversion in 7d79fba1a
  * see https://build.opensuse.org/public/build/home:ddiss:bcachefs_upstream_vendor/openSUSE_Tumbleweed/armv7l/bcachefs-tools/_log

Logs for successful v1.7.0 builds can be found at
https://build.opensuse.org/public/build/filesystems/openSUSE_Tumbleweed/i586/bcachefs-tools/_log
https://build.opensuse.org/public/build/filesystems/openSUSE_Tumbleweed/armv7l/bcachefs-tools/_log

Cheers, David

