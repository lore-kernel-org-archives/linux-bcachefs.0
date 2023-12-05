Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ci8eOLWa"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5583B194
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 05:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701782625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FLyfj8qc1nfRQCLzHDRoiB+iFUGTViTmyfXLTaqyMyM=;
	b=ci8eOLWaP3Jw8vtoOFLt8v+hoodBz6k9sY/N/f8sBHBN8z2Ta/2F9WCtV72aTmnx2/seiV
	dhl5EH2clXuQRLTDtQ3VM2/BqeaZxs6p5KV1y2MlPGf3YfWtrc5Aht1FuJYXadIY0wAObO
	AcFH6KSgTNhWPmqy+UDVfd9dncwpSXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-XKx4njpPOfuI4zjReTYgxw-1; Tue, 05 Dec 2023 08:23:44 -0500
X-MC-Unique: XKx4njpPOfuI4zjReTYgxw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3271832D60
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B88AC492BE6
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: return from fsync on writeback error to avoid early shutdown
Date: Tue,  5 Dec 2023 08:24:39 -0500
Message-ID: <20231205132439.130755-3-bfoster@redhat.com>
In-Reply-To: <20231205132439.130755-1-bfoster@redhat.com>
References: <20231205132439.130755-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

When investigating transient failures of generic/441 on bcachefs, it
was determined that the cause of the failure was a combination of
unconditional emergency shutdown and racing between background
journal activity and the test switchover from a working device
mapper table to an error injecting table.

Part of the reason for this sequence of events is that bcachefs
aggressively flushes as much as possible during fsync(), regardless
of errors. While this is reasonable behavior, it is technically
unnecessary because once an error is returned from fsync(), the
caller cannot make any assumptions about the resilience of data.

Tweak the bch2_fsync() logic to return an error on failure of any of
the steps involved in the flush. Note that this change alone does
not prevent generic/441 failure, but in combination with a test
tweak to avoid racing during the dm-error table switchover it avoids
the unnecessary shutdowns and allows the test to pass reliably on
bcachefs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs-io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 31f40e587a4f..98bd5babab19 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -192,13 +192,17 @@ int bch2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	int ret, ret2, ret3;
+	int ret;
 
 	ret = file_write_and_wait_range(file, start, end);
-	ret2 = sync_inode_metadata(&inode->v, 1);
-	ret3 = bch2_flush_inode(c, inode);
-
-	return bch2_err_class(ret ?: ret2 ?: ret3);
+	if (ret)
+		goto out;
+	ret = sync_inode_metadata(&inode->v, 1);
+	if (ret)
+		goto out;
+	ret = bch2_flush_inode(c, inode);
+out:
+	return bch2_err_class(ret);
 }
 
 /* truncate: */
-- 
2.42.0

