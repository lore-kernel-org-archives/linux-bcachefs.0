Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E7A27EC6F
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283715; cv=none; b=foGFsyO6Tt8yBfWAQLrV+jYNfq0MMpy/OCdzMsnSGKG/Lq7SAbNB6VW8BlfDovu5Xwn6A1HgqNciy6Pu0Vk85DdML3mABK+8OFIO+knJnHBDJuZaXwDA5n1CxrqSX+wZIZz8kVkfqk0IyQVkxe5YJ6fTlCtbvn6NnyNEyWrzWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283715; c=relaxed/simple;
	bh=mAu6ASj7DxxnKF906Xn0SU9Is/D+jgg2PrSrLdbio+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUBgvAfjjNZhxyHcE9JtMuSH+PM5uSlMXKqQXndo4mJnoOMskxwpvgYTO+LTL06l4uYT7YiZO98Rca2fLyoZPZf8L1hNaONj/RwlZC52H8Jq+zojfK3ncdMlUyoRuvPQw5vVk4qObYbuQiajfX/vp5Gl186CAM0fE6jNGt0MG94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gi5s4qXY; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gi5s4qXY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3GB9RyHo1htDe+Bkk159Ilntg0/eHZRixJI72iLm1g=;
	b=Gi5s4qXYi3q00P8aFJ/fQglc0VD/nE+ntup0ws1LegtFkhjOmNKrs1wAzOigtKP0bI/3s0
	yhJsw3VyXa+p380OKJaiwMPSvbGpCH31vsmMMafEnRCKTUlD8D6iNJ59boguAAWDu+1p+v
	r/i4gSdSgubeqLZocbIwhzTeiAsmK6Y=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 36/37] bcachefs: fix spurious error in read_btree_roots()
Date: Wed, 18 Jun 2025 17:54:27 -0400
Message-ID: <20250618215431.738317-37-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index fa5d1ef5bea6..e0d824471bff 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -607,6 +607,7 @@ static int read_btree_roots(struct bch_fs *c)
 					buf.buf, bch2_err_str(ret))) {
 			if (btree_id_is_alloc(i))
 				r->error = 0;
+			ret = 0;
 		}
 	}
 
-- 
2.50.0

