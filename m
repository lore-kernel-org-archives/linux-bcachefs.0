Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD119A298
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594984; cv=none; b=oEy/r/xbAFCaYU+mxZRUHNYbCCRWuGDTONrlGfCHO4Swxc+wM59qZkf/W7dRuCv6rk47QyFymuRYHlQtxU4viHWlem3WsH+XuwKIcROipOWTweZ9MIi2nSFSegFrASXj+DAVLCiTCBSFMZjwCcO9FbrwuEcld6RKWKQ7rPIhl00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594984; c=relaxed/simple;
	bh=0UAQHfd349TPzo3eOOcWzuXSxr6aL61DFjhCAWZ/56M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NouA6dHbw+z267LeEvEhXEhILbpecfyT0jNLs6VRXj72hHfy9tfIOucMIG+r69M5JNz6sRR8i5Wo9AaC03ov1qj7838ZeNCPmFJAPyIabUQQgQow9ab9hcoWbBk5ro4iq24GkozgqatgcHQfI7YHiqZxI2+mDlLno+g1HXlyGrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ooDlkr2K; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ooDlkr2K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NOkWMeH9TlvR++Dvt3SO8Oy2C0I4Z9yuK9J6yCe0uns=;
	b=ooDlkr2KBQDcYyU+PuNIf2e4XZY0DxyvWEBFbOYF1X8cfbEnOBHUUbCjGN3ZnFYNJcQO0p
	qGJfRmfXHkGGb1LGcQZsPUA0yLDIn5BMEvgwMPir8EJSVr2bMJvemM1rbmIcEvJq7jk6E4
	Q1IGo9i0V9D0VJ+lxtSI8rebubWSnaE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/11] bcachefs: printbuf_reset() handles tabstops
Date: Mon, 30 Dec 2024 16:42:44 -0500
Message-ID: <20241230214249.242966-6-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/printbuf.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/printbuf.h b/fs/bcachefs/printbuf.h
index 1d570387b77f..d0dd398baa2b 100644
--- a/fs/bcachefs/printbuf.h
+++ b/fs/bcachefs/printbuf.h
@@ -251,16 +251,23 @@ static inline void prt_hex_byte_upper(struct printbuf *out, u8 byte)
 	printbuf_nul_terminate_reserved(out);
 }
 
+static inline void printbuf_reset_keep_tabstops(struct printbuf *buf)
+{
+	buf->pos		= 0;
+	buf->allocation_failure	= 0;
+	buf->last_newline	= 0;
+	buf->last_field		= 0;
+	buf->indent		= 0;
+	buf->cur_tabstop	= 0;
+}
+
 /**
  * printbuf_reset - re-use a printbuf without freeing and re-initializing it:
  */
 static inline void printbuf_reset(struct printbuf *buf)
 {
-	buf->pos		= 0;
-	buf->allocation_failure	= 0;
-	buf->indent		= 0;
+	printbuf_reset_keep_tabstops(buf);
 	buf->nr_tabstops	= 0;
-	buf->cur_tabstop	= 0;
 }
 
 /**
-- 
2.45.2

