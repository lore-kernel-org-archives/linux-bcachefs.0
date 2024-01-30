Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C6537E8
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Jan 2024 07:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706598257; cv=none; b=Uo/Be+Hbwmd2sCcKDdfNm7YGgpZp1KRwg7mCXbZc4HOAGaxURFrqb2yzwfkK0U3BXDJz7o6KHAgWW6u663NSz9ColaJJrij5lqPn9JcaD0GeMftVEsPfFXlweKhznL5jf4X9oA/cWvkPF1dRWjnVsxOvIYkLZaptfX0kXqKGXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706598257; c=relaxed/simple;
	bh=j+lgubaaknf9K7vI1RUGLzp8z5b3TYHGJmFe3QSC6UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=pdojkQE4LVhglzqTeJpdXtEFC8SjOj7xA44/tZ42KvfJyvEPIg5YUdIBXAqBorsZxW+BfnbU54/JwGKaeZ02ZPFyxLFHuAwOh4dCtWVkUtYo2BtMY8ZXx+cbKrIqT0JHp/g6jdjqh0wtiX3KPpDZwQC82MSoHDEX8oDl7C31dHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RwR7Q29s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Na5KMQ4H; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MXj4q7YK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3hu0iFx2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RwR7Q29s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Na5KMQ4H";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MXj4q7YK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3hu0iFx2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B27942209E;
	Tue, 30 Jan 2024 07:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706598252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkPsvj2EZucpyFKEV3cFW/vn/9j5m5tOCAP12lyErME=;
	b=RwR7Q29sRBwYtIkNabUVLZN2wM40+KfYKTCXb3FAp5UO4aDbP6zxEwyM5CjmDJt2hQAI7e
	UzRTBdQlh7E2G7QvHuzVgXF/TE+ASJ738cP67YwzlCdaW0iLb+r9tXnP24+tnQOyq7hi3m
	yetu8xa8Qy/MXLiXzf5byXdIoY4hZnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706598252;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkPsvj2EZucpyFKEV3cFW/vn/9j5m5tOCAP12lyErME=;
	b=Na5KMQ4HBqYH1MQM6S4cWl4dpuPDhSS8LnNZvrSr5qqqZhIdW0p5TgP3M3/MRvnIDUPz6I
	W5Lkaiy1cA7xoXCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706598251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkPsvj2EZucpyFKEV3cFW/vn/9j5m5tOCAP12lyErME=;
	b=MXj4q7YK3Zbfrjt8okZj/fvDvvZBPLLkSKnNUjJKdukOFPybquB61Fet5bbna77jAXk5Eu
	5fthx0jCcv2ptPiLzx1dMBu7wk72COMt5UHqRLW4n1HhnVgXIOxnKZAXCcdJZQi5nWq+Zq
	RkZZfujZEBztUekC9o2WGyQbPhHoahw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706598251;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkPsvj2EZucpyFKEV3cFW/vn/9j5m5tOCAP12lyErME=;
	b=3hu0iFx2keNSm6gcLhtTlb/+ipjCotPwuCSMPTTF0Q3VGbcnu01s+oQXX9lVD4uPbSy1sX
	OgDVtBXy9KgT9IBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E7E812FF7;
	Tue, 30 Jan 2024 07:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q+3WB2qfuGV/AwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 30 Jan 2024 07:04:10 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-bcachefs@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>
Subject: [PATCH] make-release-tarball.sh: run cargo audit
Date: Tue, 30 Jan 2024 18:03:56 +1100
Message-Id: <20240130070356.8174-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MXj4q7YK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3hu0iFx2
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-0.51 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.00)[43.70%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -0.51
X-Rspamd-Queue-Id: B27942209E
X-Spam-Flag: NO

cargo audit can be used to check bcachefs dependencies for
vulnerabilities published in the advisory database at
https://github.com/RustSec/advisory-db.git

Given the significant size of dependency sources (currently ~292M),
manual audit is mostly unviable, so rely on this for now.

Audit failure will halt tarball generation with e.g. v1.4.1:
    Fetching advisory database from `https://github.com/RustSec/advisory-db.git`
      Loaded 595 security advisories (from /home/david/.cargo/advisory-db)
    Updating crates.io index
    Scanning rust-src/Cargo.lock for vulnerabilities (98 crate dependencies)
Crate:     shlex
Version:   1.2.0
Title:     Multiple issues involving quote API
Date:      2024-01-21
ID:        RUSTSEC-2024-0006
URL:       https://rustsec.org/advisories/RUSTSEC-2024-0006
Solution:  Upgrade to >=1.3.0
Dependency tree:
shlex 1.2.0
└── bindgen 0.64.0
    └── bch_bindgen 0.1.0
        └── bcachefs-rust 0.3.1

Crate:     atty
Version:   0.2.14
Warning:   unsound
Title:     Potential unaligned read
Date:      2021-07-04
ID:        RUSTSEC-2021-0145
URL:       https://rustsec.org/advisories/RUSTSEC-2021-0145
Dependency tree:
atty 0.2.14
└── bcachefs-rust 0.3.1

error: 1 vulnerability found!
warning: 1 allowed warning found

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 make-release-tarball.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/make-release-tarball.sh b/make-release-tarball.sh
index c468da7..51875b0 100755
--- a/make-release-tarball.sh
+++ b/make-release-tarball.sh
@@ -7,6 +7,8 @@ version=$1
 git checkout v$version
 git clean -xfd
 
+cargo audit
+
 cargo license > COPYING.rust-dependencies
 
 git ls-files|
-- 
2.35.3

