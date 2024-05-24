Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37D925757
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 19:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716579992; cv=none; b=DuGKlRDw0Hpem5boIceKBIAoJ68C0UiR3IzJbNzsuU0d6A5BSwl/cLQeO2sGjgP0fUsTHX5Wm29WVbzkL0OQpjzaeOOziIqDpYD5GuyFth7RJASd2GXu7XJI/agOwUtxWPaSIiMl7OKb//z6JaJ08W/E2sSDNrxm2/IWq4IBk0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716579992; c=relaxed/simple;
	bh=JKHmSxpCU/V5g1XPD4fILqvr25vE6mw3StQaoCrPP6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ilU8Cg/Ts5fsD1lgi1IWhCX9AEhK2T7RnnvLi1UnqScSObi3zWsM/If0XEQG7/r8wkJAQRKZ14yUyveSpoFObhCd+wBqLrpoVzDF/mNZGgG2xRd/o/u5Hgb8djmVbqkFBzYZyvb1k7BRjnJVZIpmulfOZAfMpIRZE8qzaBS3Qtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jOIIdH1l; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jOIIdH1l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9pvBqqdg/BrMyLEAoAeVd+jHFzeRYB+4lgF/k4nPqic=; b=jOIIdH1lRZxNVWsEGgI0T/cKCI
	zjmxTwO8rGmySF8oIhGI0u0GK2rYcJx5Z7vIOHo3A5wXEzkYwFe04DDc08xnFgubFWMnc31X9s52u
	76jZvKXau1B5szUzbHO+DJX+7DD7ToAls5dU6QilqJnh6LujVEfDRlADnFkkEdcP03Na+KADgBuKk
	jk2EeoZce9eZQ+EHtbb0C7xXKU9shfp+n2pjlvS9QfwI4jZ/PhS+FnDf2CQTbUy2UmcRvVCHRC1/i
	BrkVCmTvmb2eynLJwYVRMzRBV2oDOTb59lWzXiLeNZ4TJFqCHVBgkW+UQgQ3raNEY/St9KPcoPr74
	+ewrHuDg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAas0-00000002zB2-20IN;
	Fri, 24 May 2024 19:46:28 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Use copy_folio_from_iter_atomic()
Date: Fri, 24 May 2024 20:46:25 +0100
Message-ID: <20240524194627.711814-1-willy@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

copy_page_from_iter_atomic() will be removed at some point.
Also fixup a comment for folios.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/bcachefs/fs-io-buffered.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index b0a33fabadf8..c7b48ef3c637 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -437,8 +437,8 @@ static void bch2_writepage_io_done(struct bch_write_op *op)
 	 */
 
 	/*
-	 * PageWriteback is effectively our ref on the inode - fixup i_blocks
-	 * before calling end_page_writeback:
+	 * The writeback flag is effectively our ref on the inode -
+	 * fixup i_blocks before calling folio_end_writeback:
 	 */
 	bch2_i_sectors_acct(c, io->inode, NULL, io->op.i_sectors_delta);
 
@@ -898,7 +898,7 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	darray_for_each(fs, fi) {
 		f = *fi;
 		f_len = min(end, folio_end_pos(f)) - f_pos;
-		f_copied = copy_page_from_iter_atomic(&f->page, f_offset, f_len, iter);
+		f_copied = copy_folio_from_iter_atomic(f, f_offset, f_len, iter);
 		if (!f_copied) {
 			folios_trunc(&fs, fi);
 			break;
-- 
2.43.0

