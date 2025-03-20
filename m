Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1C214A97
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506389; cv=none; b=gln/bkCvGu9iBfsX/Inhe0rQqo2yZgqjUW97+Nya54Hj89ym9NbMJOG6F7f1K0sSGMpsbBsmd8FabVXSdfhPap8EIuSzmuH1/EypOGNn9Dk5lJdxzi8wdUnZoPJwY2PeOsotFirndr5wJOvB71pBUuXSQHkpJNhW4GL5wjPDJbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506389; c=relaxed/simple;
	bh=sMMvh/Fvu4TlKJyUtJJYoKorgMYh3jkEuzjHgTF9qLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tel+Ql6/T4m5TdxXb7rkbzEZTP0dxOGH0g1XmD38WVBjIGMzC8hT6uZtxxruRsz9LZDZ0a/lLErkhxkrpknwlO+wWZRqD0CIKPft3AGtQS8dJYWEatInpdQdTMu/FYFjGZ1GlgklU/yZAZP3bJo8tlk1Jdkv2o0kHINYctju9Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kI08Xv5u; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kI08Xv5u"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeHY1Sclr/mACpyU5KdZsMG+izZAeQSfar7I3fo/L5A=;
	b=kI08Xv5uV1MNZoE/wfcr0g/OlUr49HpHCeqvLXKbQWJ/JNjzyBJqRU6JF+7FybQChqwSAv
	y7W8Vt8KS9jqSlGLF9aua9+rXBX/gM8YTIUUQMObz2Ct+lFl6MQyD+IHMuk6yR0u8yeOwR
	cj28C/SUtHeWhbMikL6Ary5DsFPTg9k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/5] bcachefs: move_bucket_key -> __packed
Date: Thu, 20 Mar 2025 17:32:53 -0400
Message-ID: <20250320213256.3359777-6-kent.overstreet@linux.dev>
In-Reply-To: <20250320213256.3359777-1-kent.overstreet@linux.dev>
References: <20250320213256.3359777-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

we appear to be tripping over a compiler/kmsan bug with padding fields -
this is an easy workaround.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/move_types.h b/fs/bcachefs/move_types.h
index 82e473ed48d2..31171a5bf0e1 100644
--- a/fs/bcachefs/move_types.h
+++ b/fs/bcachefs/move_types.h
@@ -33,7 +33,7 @@ struct bch_move_stats {
 struct move_bucket_key {
 	struct bpos		bucket;
 	u8			gen;
-};
+} __packed;
 
 struct move_bucket {
 	struct move_bucket_key	k;
-- 
2.49.0

