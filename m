Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66A4314A78
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390597; cv=none; b=MlINvzClah4f9q4ij9Ia9FDhP0UAXhIsn2kTdtHvYEKrjv7GXyL93E2pf1JxMJQXX6jxlyUID8z4ZAjnlyB4KCnd7bT6zjrK3aHC+Uk5AM4fSg8MtUyHtXJ6zKa7ddnX802m7ZO2J2JdmW9JWMurLRTP8h6srk/wa4XBJNCJ210=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390597; c=relaxed/simple;
	bh=ifdpNcMey2Q85pcafRa0vyZmTq9MWSUVg2wkhpoG4Uk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aFPZCENzL+5RwGbkx2fRmiwqqwendYE6Cg8mfb+9tDsxi+bcVdzygmIlcaIMReMjLmp86C//1M5fHEAQwIjr/9NZEFE7W+Nd6zbKxW4wjcuqobChJXvCxgU8ppXjCxanJeKZ9Hd6YfuZTeEPi+UKWDuilrTRd3PddTYCGtBcKKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRlxpCVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRlxpCVk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA329C4CEF8;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756390597;
	bh=ifdpNcMey2Q85pcafRa0vyZmTq9MWSUVg2wkhpoG4Uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aRlxpCVkeIkZw+Gk1R8cL2PqlwpHpP8BH1lISYY8XaTc8TKQKZQrn3U6BB9OEchJt
	 n99ALYQzBgy6rIqSBdkoCRXjoHxDT9rFc5EmMbocsigoIidoNiRQB6k/LCDMwCmKL+
	 OHuSEZr0Z2K5FqAZsexccucg4EMmA4UCTHizCYeXHGK4+OxniIa4YKNHbIggbyxa1s
	 tkBZfqfor2lAJcknpPMDvh8YVCYjLwmx7GAswxEOVUpTZPfcEsYNxjdOG2g7t2sgf7
	 tLEasJAUXDf5nr5cwuoUUzXVwgtmiqFVlyXxagiBF36xYa5se2iqpNhFVY3j3RqVBq
	 IbSX0wf7MtWPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14DBCA0FFE;
	Thu, 28 Aug 2025 14:16:37 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 28 Aug 2025 17:16:15 +0300
Subject: [PATCH v2 13/15] bcachefs: Use explicit node counts in progress
 reporting
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250828-better-progress-v2-13-c088a2003940@gmail.com>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1742; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=W0+LRH5XYqdB0aj9wQSy1UVKyJFpf8VMp390jsXj01M=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWRsSDkUoHNwgqzBvhvHkzzCeDnMHqeZBW2S8vz6/rEdP
 z/HhcyrHaUsDGJcDLJiiiwflnz9sybT+o+l0F5DmDmsTCBDGLg4BWAi670YGTb1TlKwizf9pe0i
 16s+81DELq8Hc+wavFLu1R5r7pV9u4uR4WLlfZ82zWM5LyX/nRIzWrpWbo/pYpG9Xp+LGv4vXfa
 0nR8A
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Also, consider the metadata_replicas option when better
accounting is not available.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 541ee951d1c9fc3f11b5a5ac40f1d366829a5c97..8181f6d2ca3808f57bef179383bd969d9a375d5f 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -12,6 +12,10 @@ void bch2_progress_init(struct progress_indicator_state *s,
 
 	s->next_print = jiffies + HZ * 10;
 
+	/* This is only an estimation: nodes can have different replica counts */
+	const u32 expected_node_disk_sectors =
+		READ_ONCE(c->opts.metadata_replicas) * btree_sectors(c);
+
 	for (unsigned i = 0; i < btree_id_nr_alive(c); i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
@@ -19,9 +23,23 @@ void bch2_progress_init(struct progress_indicator_state *s,
 		struct disk_accounting_pos acc;
 		disk_accounting_key_init(acc, btree, .id = i);
 
-		u64 v;
-		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc), &v, 1);
-		s->nodes_total += div64_ul(v, btree_sectors(c));
+		struct {
+			u64 disk_sectors;
+			u64 total_nodes;
+			u64 inner_nodes;
+		} v = {0};
+		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc),
+			(u64 *)&v, sizeof(v) / sizeof(u64));
+
+		/*
+		 * We check for zeros to degrade gracefully when run
+		 * with un-upgraded accounting info (missing some counters).
+		 */
+
+		if (v.total_nodes != 0)
+			s->nodes_total += v.total_nodes - v.inner_nodes;
+		else
+			s->nodes_total += div_u64(v.disk_sectors, expected_node_disk_sectors);
 	}
 }
 

-- 
2.50.1


