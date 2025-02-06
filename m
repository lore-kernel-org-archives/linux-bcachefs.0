Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB44729CE7
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805359; cv=none; b=Zp36Tpssnzz4ZYtSG0k0veQPz1kaFuxhIzJvQs1ig4ET79ykYtHmzDoll5MuR6pR4GxC/AJVOt5t0kqO/yC0abC3RTdfniXHS8zJ8ZF0QUi45ghjuiaPXtVrqkD6jRPbF89XsT/XPagnSP+bmfFkunvh7fRQkFeBZBg4JOMEI8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805359; c=relaxed/simple;
	bh=vd0l0CkvmObEt89cmTUfnnkYtkU5E1IU2zDwBIsA/NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyQRAgPT1bcwey0UCjCzLbgY3msgV7LD3kGfR135BGYmoL5HKZVzbbuvQBM8WlwvqfIz2d0J/xdI2MUTk1OcArFqQ0ZlLTuXOW7KBM4HpOJwUQvHiHhfElYWqJtduxAxGYcv5EKO96GZoidzJhGkCBnvxmk3+AI85B/8vzYw2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PtSKN/Vu; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PtSKN/Vu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bdYvvjq6i2A8kpe/NB1OCIca+rJxuxOuIFtWzW2wd+0=;
	b=PtSKN/VupSpOAVe29gv5FsaJzuDRPCHpAzDwu5jdrr7SvCPcOjAjFcrQRS+V5w355sdMKv
	1uwPlVHvBRQbwtpalZcpX8xdk8b6+cnF7itQrbFVO2SKwcXUGb/8rW2MgsuFO3Gv0Ry0FD
	XFAg7Hmm7a4GVyeewh+RS2+rf7pxeho=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/5] bcachefs: Don't touch journal_buf->data->seq in journal_res_get
Date: Wed,  5 Feb 2025 20:28:48 -0500
Message-ID: <20250206012852.1658754-4-kent.overstreet@linux.dev>
In-Reply-To: <20250206012852.1658754-1-kent.overstreet@linux.dev>
References: <20250206012852.1658754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is a small optimization, reducing the number of cachelines we touch
in the fast path - and it's also necessary for the next patch that
increases JOURNAL_BUF_NR.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 1e5fcfe3624a..e514d664b8ae 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -364,7 +364,10 @@ static inline int journal_res_get_fast(struct journal *j,
 
 	res->ref	= true;
 	res->offset	= old.cur_entry_offset;
-	res->seq	= le64_to_cpu(j->buf[old.idx].data->seq);
+	res->seq	= journal_cur_seq(j);
+	res->seq -= (res->seq - old.idx) & JOURNAL_BUF_MASK;
+
+	EBUG_ON(res->seq != le64_to_cpu(j->buf[old.idx].data->seq));
 	return 1;
 }
 
-- 
2.45.2

