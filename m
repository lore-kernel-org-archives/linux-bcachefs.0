Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65312F399
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745256216; cv=none; b=kIRvbrZqXwxcnEJbciLGc2yMqiCUlBTPlV+Bq+QJZucCgG5/3ZzpLBUtUUF2ZTII1aLHIEgKXxn+zPdEHyaxKgXT3F/+LFjbNwMIDyoCmrGI2nwOaNRothTmpPaa2fhQUn6hPzN3U3Uyyyx2sey5ntmWs27ne/FRRp7vE4Mz1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745256216; c=relaxed/simple;
	bh=oVjVfL/XYQVPuOh5ZzLym+hSBZrkYlvdSbR7adYK1js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFK4/RKv8HwosOZIGAaUvwjGCdWsBgy2v+kd2OpCRne45MALuGkS6s3ZzURuRsT6W0Lz8+BINQ04prtE0d1a8vEuTLj0ddktiBx324pdS0WU/3GJm3w1lepA53DefvdqyfOUIGX0W15WINaFmGps2nU2CFXODFdsmDMb0qnIbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=THlfL3WB; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="THlfL3WB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745256211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=paZOuvNCxBDv7oU35+7z0bqdgsQXsMgQRvQUhBeB8LE=;
	b=THlfL3WB8aa/ha/v8f+vLT4BxzRlI6StwvFzP0B3+zbTBkwhF9t9nK/mmJKACZakxLe43v
	XNXxcc6HZd1VdvxrWDrsbdTy9HcLUwXosx6swU3FOnlUqROGe7CGhWPkvTtYpMVbH9/sZ/
	eP9WdxYtJgsD+8XEWA93SbMENbIn34o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@gver.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/5] bcachefs: bch2_read_bio_to_text
Date: Mon, 21 Apr 2025 13:23:18 -0400
Message-ID: <20250421172323.1781730-3-kent.overstreet@linux.dev>
In-Reply-To: <20250421172323.1781730-1-kent.overstreet@linux.dev>
References: <20250421172323.1781730-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Pretty printer for struct bch_read_bio.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c | 18 +++++++++++++++---
 fs/bcachefs/io_read.c     | 35 +++++++++++++++++++++++++++++++++++
 fs/bcachefs/io_read.h     |  2 ++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index c3034338f9e4..9b44f11fb0d9 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -587,6 +587,10 @@ void bch2_data_update_opts_to_text(struct printbuf *out, struct bch_fs *c,
 
 	prt_str_indented(out, "extra replicas:\t");
 	prt_u64(out, data_opts->extra_replicas);
+	prt_newline(out);
+
+	prt_str_indented(out, "scrub:\t");
+	prt_u64(out, data_opts->scrub);
 }
 
 void bch2_data_update_to_text(struct printbuf *out, struct data_update *m)
@@ -607,9 +611,17 @@ void bch2_data_update_inflight_to_text(struct printbuf *out, struct data_update
 	prt_newline(out);
 	printbuf_indent_add(out, 2);
 	bch2_data_update_opts_to_text(out, m->op.c, &m->op.opts, &m->data_opts);
-	prt_printf(out, "read_done:\t%u\n", m->read_done);
-	bch2_write_op_to_text(out, &m->op);
-	printbuf_indent_sub(out, 2);
+
+	if (!m->read_done) {
+		prt_printf(out, "read:\n");
+		printbuf_indent_add(out, 2);
+		bch2_read_bio_to_text(out, &m->rbio);
+	} else {
+		prt_printf(out, "write:\n");
+		printbuf_indent_add(out, 2);
+		bch2_write_op_to_text(out, &m->op);
+	}
+	printbuf_indent_sub(out, 4);
 }
 
 int bch2_extent_drop_ptrs(struct btree_trans *trans,
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 92952799961c..acec8ddf7081 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -1482,6 +1482,41 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 	return ret;
 }
 
+static const char * const bch2_read_bio_flags[] = {
+#define x(n)	#n,
+	BCH_READ_FLAGS()
+#undef x
+	NULL
+};
+
+void bch2_read_bio_to_text(struct printbuf *out, struct bch_read_bio *rbio)
+{
+	u64 now = local_clock();
+	prt_printf(out, "start_time:\t%llu\n", rbio->start_time ? now - rbio->start_time : 0);
+	prt_printf(out, "submit_time:\t%llu\n", rbio->submit_time ? now - rbio->submit_time : 0);
+
+	if (!rbio->split)
+		prt_printf(out, "end_io:\t%ps\n", rbio->end_io);
+	else
+		prt_printf(out, "parent:\t%px\n", rbio->parent);
+
+	prt_printf(out, "bi_end_io:\t%ps\n", rbio->bio.bi_end_io);
+
+	prt_printf(out, "promote:\t%u\n",	rbio->promote);
+	prt_printf(out, "bounce:\t%u\n",	rbio->bounce);
+	prt_printf(out, "split:\t%u\n",		rbio->split);
+	prt_printf(out, "have_ioref:\t%u\n",	rbio->have_ioref);
+	prt_printf(out, "narrow_crcs:\t%u\n",	rbio->narrow_crcs);
+	prt_printf(out, "context:\t%u\n",	rbio->context);
+	prt_printf(out, "ret:\t%s\n",		bch2_err_str(rbio->ret));
+
+	prt_printf(out, "flags:\t");
+	bch2_prt_bitflags(out, bch2_read_bio_flags, rbio->flags);
+	prt_newline(out);
+
+	bch2_bio_to_text(out, &rbio->bio);
+}
+
 void bch2_fs_io_read_exit(struct bch_fs *c)
 {
 	if (c->promote_table.tbl)
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index 1a85b092fd1d..13bb68eb91c4 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -193,6 +193,8 @@ static inline struct bch_read_bio *rbio_init(struct bio *bio,
 	return rbio;
 }
 
+void bch2_read_bio_to_text(struct printbuf *, struct bch_read_bio *);
+
 void bch2_fs_io_read_exit(struct bch_fs *);
 int bch2_fs_io_read_init(struct bch_fs *);
 
-- 
2.49.0

