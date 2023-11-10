Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0338DF2
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KItvQjYR"
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BEE3EB07
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:13 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0RPu8WaxZtmwWfVzsOY7JqDLc0sR8czY/b6xfUl63aQ=;
	b=KItvQjYRF2pkRW5Sv6VTPGic9Fb28DxYQisOV0hONlS6qu+5bKBm2Z2qPMiF4dg45aJ/ON
	1p5uoAVg7+MKhA1o2nWj+yW+WVYaXVCWscovCnizeHwDozSC6HLjxr/vKZQo+Tm3qq8VHN
	tsEK7G0eOsPfu24KGTYaNFJ9mYj48so=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 15/17] bcachefs: Improve btree write buffer tracepoints
Date: Fri, 10 Nov 2023 11:31:52 -0500
Message-ID: <20231110163157.2736111-16-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

 - add a tracepoint for write_buffer_flush_sync; this is expensive
 - fix the write_buffer_flush_slowpath tracepoint

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_write_buffer.c |  4 +++-
 fs/bcachefs/trace.h              | 31 ++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index be8308789477..74d864715b39 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -236,7 +236,7 @@ int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	bch2_journal_pin_drop(j, &pin);
 	return ret;
 slowpath:
-	trace_write_buffer_flush_slowpath(trans, i - keys, nr);
+	trace_write_buffer_flush_slowpath(trans, slowpath, nr);
 
 	/*
 	 * Now sort the rest by journal seq and bump the journal pin as we go.
@@ -275,6 +275,8 @@ int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
 		return -BCH_ERR_erofs_no_writes;
 
+	trace_write_buffer_flush_sync(trans, _RET_IP_);
+
 	bch2_trans_unlock(trans);
 	mutex_lock(&c->btree_write_buffer.flush_lock);
 	int ret = bch2_btree_write_buffer_flush_locked(trans);
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 7857671159b4..8fadf06c7dbf 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1298,21 +1298,38 @@ TRACE_EVENT(write_buffer_flush,
 		  __entry->nr, __entry->size, __entry->skipped, __entry->fast)
 );
 
+TRACE_EVENT(write_buffer_flush_sync,
+	TP_PROTO(struct btree_trans *trans, unsigned long caller_ip),
+	TP_ARGS(trans, caller_ip),
+
+	TP_STRUCT__entry(
+		__array(char,			trans_fn, 32	)
+		__field(unsigned long,		caller_ip	)
+	),
+
+	TP_fast_assign(
+		strscpy(__entry->trans_fn, trans->fn, sizeof(__entry->trans_fn));
+		__entry->caller_ip		= caller_ip;
+	),
+
+	TP_printk("%s %pS", __entry->trans_fn, (void *) __entry->caller_ip)
+);
+
 TRACE_EVENT(write_buffer_flush_slowpath,
-	TP_PROTO(struct btree_trans *trans, size_t nr, size_t size),
-	TP_ARGS(trans, nr, size),
+	TP_PROTO(struct btree_trans *trans, size_t slowpath, size_t total),
+	TP_ARGS(trans, slowpath, total),
 
 	TP_STRUCT__entry(
-		__field(size_t,		nr		)
-		__field(size_t,		size		)
+		__field(size_t,		slowpath	)
+		__field(size_t,		total		)
 	),
 
 	TP_fast_assign(
-		__entry->nr	= nr;
-		__entry->size	= size;
+		__entry->slowpath	= slowpath;
+		__entry->total		= total;
 	),
 
-	TP_printk("%zu/%zu", __entry->nr, __entry->size)
+	TP_printk("%zu/%zu", __entry->slowpath, __entry->total)
 );
 
 #endif /* _TRACE_BCACHEFS_H */
-- 
2.42.0

