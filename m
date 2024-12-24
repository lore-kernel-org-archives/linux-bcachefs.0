Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F3FCA6B
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735048595; cv=none; b=Ct5e33lMLdM6akYhR7/MkRIkKYztgdw4ap5K5AD7pXRI0JXqYyFQJ2bBW21+47rwhVOrdP6jjtec39H4vimiQLFpMxe0+hQSw8P0CNqBV8G/8M3AbamcrtNm1nJgieH146VjF9KriBWhxc/4OKH4aVU7hzA9sFUx5c/jxkg88ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735048595; c=relaxed/simple;
	bh=6KR2YK3yopzlsIB9HHpgWfZvChKnyhEpOLgqwchLVcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hbh51m+bm/UcEkSHYTZ2E9WVYCLxZ2SjySVBlo18wIWuc6CMdAf2WYJ8qqQm1ekerocTVDqrkaMJGh2FgNlsYo+Cwsd7qAha8+FInjCu5S4L6ws7m+4eCqVbwUKbe7mhxJEHss283iTkl7YDnKpim58LWznwTCp+2mT1GkKd9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=RiKHIrBj; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=tDQSn+aO; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="RiKHIrBj";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="tDQSn+aO"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:b9e2:d588:c71c:36df])
	by mail.tnxip.de (Postfix) with ESMTPS id 423F8208D6
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Dec 2024 14:50:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1735048208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XCjKyRvj0p7ixWIjAXHmj2zrryQosflUPvm4604RDws=;
	b=RiKHIrBj0o8SeSQxt+N2VVL0krhLF/xSDNZM340CU3pJtO5165tjMbjuOMUE/atYitgwVJ
	GuuemXWo405C/k2yR4D++g0EF++I7sDsfhxsJ90/gVK88Mo72raTqCbRquZxAgEo+JhAYm
	8/jn4P09itnhwqeJ4M0BvhVM57SgssU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1735048208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XCjKyRvj0p7ixWIjAXHmj2zrryQosflUPvm4604RDws=;
	b=tDQSn+aO27hvmXoK68qRRknRJVCXS098FXTVsiRv9BPvFSyDI8HgcIU7F5dlVfGvDKSKQG
	Mhk6stmmnQ4dxBDg==
Received: from highlander.lan.tnxip.de (highlander.local [IPv6:fdc7:1cc3:ec03:1:dbc0:e7a9:baaa:d776])
	by gw.tnxip.de (Postfix) with ESMTP id 04D2D70000000000029CB;
	Tue, 24 Dec 2024 14:49:57 +0100 (CET)
Authentication-Results: gw.tnxip.de;
	dkim=none;
	dmarc=temperror reason="SPF/DKIM temp error" header.from=tnxip.de (policy=temperror);
	spf=temperror (gw.tnxip.de: error in processing during lookup of malte.schroeder@tnxip.de: DNS error) smtp.mailfrom=malte.schroeder@tnxip.de
From: =?UTF-8?q?Malte=20Schr=C3=B6der?= <malte.schroeder@tnxip.de>
To: linux-bcachefs@vger.kernel.org
Cc: =?UTF-8?q?Malte=20Schr=C3=B6der?= <malte.schroeder@tnxip.de>
Subject: [RFC PATCH] Remove percentage display in backpointer progress
Date: Tue, 24 Dec 2024 14:32:13 +0100
Message-ID: <20241224133212.393470-2-malte.schroeder@tnxip.de>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.90 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	MIME_GOOD(-0.10)[text/plain];
	R_SPF_DNSFAIL(0.00)[-any];
	RCVD_COUNT_ZERO(0.00)[0];
	SURBL_MULTI_FAIL(0.00)[highlander.local:query timed out];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DMARC_DNSFAIL(0.00)[tnxip.de : SPF/DKIM temp error,reject];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[highlander.local:rdns,highlander.lan.tnxip.de:helo]
X-Rspamd-Server: starbase1
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 04D2D70000000000029CB

The progress indicator as it is now is quite confusing,
it tends to not go to 100% or it resets to 0%, probably when doing multiple
passes. This should be fixed properly, maybe also showing which pass it is
doing. But for now this patch just rips out the percentage display. No
information is better than confusing information.

Signed-off-by: Malte Schröder <malte.schroeder@tnxip.de>
---
 fs/bcachefs/backpointers.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index ebeb6a5ff9d2..c5cc3aa04868 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -767,12 +767,9 @@ static void progress_update_iter(struct btree_trans *trans,
 
 	if (progress_update_p(s)) {
 		struct printbuf buf = PRINTBUF;
-		unsigned percent = s->nodes_total
-			? div64_u64(s->nodes_seen * 100, s->nodes_total)
-			: 0;
 
-		prt_printf(&buf, "%s: %d%%, done %llu/%llu nodes, at ",
-			   msg, percent, s->nodes_seen, s->nodes_total);
+		prt_printf(&buf, "%s: done %llu/%llu nodes, at ",
+			   msg, s->nodes_seen, s->nodes_total);
 		bch2_bbpos_to_text(&buf, BBPOS(iter->btree_id, iter->pos));
 
 		bch_info(c, "%s", buf.buf);
-- 
2.47.1

