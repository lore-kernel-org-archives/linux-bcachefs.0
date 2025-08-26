Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9062C0260
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248607; cv=none; b=QksHQE60107yDQH0PWGHu14AGZBBxAQG6Wccta7v++qERaX73DaCWyo2ERlAdMyBcc3CuO5Sb+IzjbJsOdE+gV5K19K9vkJLx1FHanF1jwafo2gV8IsaoKfBLf7JZHm+r0TiWUm+2ICiiXATeBnZz+NZ8Ay6vJ9b1oygxw94gmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248607; c=relaxed/simple;
	bh=FMeATVtjv47ZeFMRUh8YYfmTRFMqo5nsnnqNxEfs6qs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KGwssciHM7GizsiHo3dZijnvXno9vWbnpLDa2KLrWBnjaRaD1TR6wS9vHAyzAd4EiNlw0XQEWgB186of/CG7DfpPUqlFS5cqEOjojMmP949J9bwrtQFH3FKUvhwk20iMteCDLlWyDDzUwQmoRgp3jRxkXPoPWymIfHwGkzu+sQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQ2ZTJtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQ2ZTJtv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A231C19424;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756248607;
	bh=FMeATVtjv47ZeFMRUh8YYfmTRFMqo5nsnnqNxEfs6qs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WQ2ZTJtvYWtiFS7AjTJdPZxtEoFGD3VN+YG4iWGIuC12KzKARfyrLfTT4fCVZMJ1i
	 A/RKNIYy9/VoNsZ8CqJ7Lc9B1EwRqV7B4WBTWtua6HDEWTupTaSUyNJ80RD6fm8X7n
	 tiMVzepNZsg2uWPKYdvWyi+prUp3rP37O1k6Nb9rLhkssTfOBkBdVl4PB4Cb//rWsk
	 +grJkwjsXrcu9d7hdMW01Gc+DViFqIB/pwG8zI+bE34/ivIRq8FsnekMARFYpfME8S
	 9J/BpWPVXuNZWpq/5xMnja+oyqkqYfeWbYbcaXPUsigJ8ihj0fkvtzmrmxMvYY4vsW
	 5384bkOnuW6Ng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF1CA0FFB;
	Tue, 26 Aug 2025 22:50:07 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Wed, 27 Aug 2025 01:49:15 +0300
Subject: [PATCH 09/12] bcachefs: Partially fix old device removal with
 unknown btrees
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-better-progress-v1-9-74c24de7988a@gmail.com>
References: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
In-Reply-To: <20250827-better-progress-v1-0-74c24de7988a@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1096; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=0parkIXY7SO5IS2HFFMEgzSsAvCaekrT6rPziZOcKFE=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWSss5LJ2nfrztwrf2UK+Ps/lvy6ZqnT9zl6yjPBz6ePC
 N/ZeYJjQ0cpC4MYF4OsmCLLhyVf/6zJtP5jKbTXEGYOKxPIEAYuTgGYyOp8hv/RM9adPRt7c351
 Wl6hj0Sj77S7okpV37d4M/I0WcWHmFxm+O8TPcf0sW7R9Zip+24V2d+qWP88KUEvRf50+rEVwW+
 NQ7gB
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Handle removal of unknown metadata only, data pointed to by unknown
btrees cannot be supported currently.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 0ef576ec45c7310423cf7cdf902cad30dba257db..d67ca56d3f431980b104ea5528cce79be88f93fb 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -121,6 +121,7 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 {
 	CLASS(btree_trans, trans)(c);
 
+	/* FIXME: this does not handle unknown btrees with data pointers */
 	for (unsigned id = 0; id < BTREE_ID_NR; id++) {
 		if (!btree_type_has_data_ptrs(id))
 			continue;
@@ -161,7 +162,7 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 	bch2_bkey_buf_init(&k);
 	closure_init_stack(&cl);
 
-	for (id = 0; id < BTREE_ID_NR; id++) {
+	for (id = 0; id < btree_id_nr_alive(c); id++) {
 		bch2_trans_node_iter_init(trans, &iter, id, POS_MIN, 0, 0,
 					  BTREE_ITER_prefetch);
 retry:

-- 
2.50.1


