Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00967264A74
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724137; cv=none; b=BfERfHZZxVhkpMkjQfO/MQfXFcce+zOJGpNSM6IH8LJs8LIvt+Lm3L2wj2sMCA8pG3RY/tlUmptaupg9Uu9DQaGTGGvs3Ep1IdPFLGbxWX0VcDldUYcjY1io1zGB6BZRAI/4OnChAYomZJ0kpJQBBh/F4FtMZhMIuAjAz6K66EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724137; c=relaxed/simple;
	bh=2plaVHcY+FEEine8QqhiZj6gLttUasCIu7Q4oBxJ4Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0q3DDS9ruboSyb4BjUCHN5VEaFI+RYbKFTIRFUKc7kgFCqHzQRCetfSUlSYx1ZNH9iHI6X6tGQon3SXIfPEuW28aADf7morEtZsFXv04B10WlMzsl1qFe+4D6PKb1ECAVhg+8MQ+jkRMldL2dMLmcGUQaJcMzTQQY9r+F3QdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RSferdkd; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RSferdkd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izCBdoiB9LATnQiFVgKMUDUNZdeITKyCOMEWZk8qUkg=;
	b=RSferdkdISDiX++pypWd4qHFCqrIEboLE6pl1k9mVHS+M0nBoUegHb/94BBOfp8eL5acN2
	v24ofgy/P+4lItY50yKxG0znzVqe3h5w9LHl0LVd3jotqM/vWgsdOLm5BFDokfqBrofwkD
	tANPadq+q//Yr2+iVAhbGSAQ46BoEdE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/14] bcachefs: Print message on successful read retry
Date: Tue, 11 Mar 2025 16:15:08 -0400
Message-ID: <20250311201518.3573009-7-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Users have been asking for this, and now that errors are returned to the
top level read retry path - we can.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 8764e88ef574..61fb3e558450 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -488,6 +488,9 @@ static void bch2_rbio_retry(struct work_struct *work)
 		rbio->ret		= 0;
 	}
 
+	unsigned subvol		= rbio->subvol;
+	struct bpos read_pos	= rbio->read_pos;
+
 	rbio = bch2_rbio_free(rbio);
 
 	flags |= BCH_READ_in_retry;
@@ -502,6 +505,19 @@ static void bch2_rbio_retry(struct work_struct *work)
 	if (ret) {
 		rbio->ret = ret;
 		rbio->bio.bi_status = BLK_STS_IOERR;
+	} else {
+		struct printbuf buf = PRINTBUF;
+
+		bch2_trans_do(c,
+			bch2_inum_offset_err_msg_trans(trans, &buf,
+					(subvol_inum) { subvol, read_pos.inode },
+					read_pos.offset << 9));
+		if (rbio->flags & BCH_READ_data_update)
+			prt_str(&buf, "(internal move) ");
+		prt_str(&buf, "successful retry");
+
+		bch_err_ratelimited(c, "%s", buf.buf);
+		printbuf_exit(&buf);
 	}
 
 	bch2_rbio_done(rbio);
-- 
2.47.2

