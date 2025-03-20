Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC45A1E5205
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506387; cv=none; b=Rf5B2W5iljQ4jKqjYuPhjt6SsAVEDOxHTRpgOCgPvqUZpLRf+VGae5i4YMuLrp046AjZwdVzsfQa0Vh0EsjOiwYQM7G8GeX5vM4N7kX0w5onS2NplWjnkrVYnW+fsDQOoN4nuJfNaVQd7JnddhOUtvHiKcXAdmluvrMhaJaDC/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506387; c=relaxed/simple;
	bh=lBJsZbyowZgTb1nzk1LewJ0ojktSAxrZOxboo1dqBVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaxZAw3SScp0xwvDZDvECdzE1TTA2Y9Xul+933IS4wdWPrgh51qx813uH1OObJnW6qnoqTEAbNy5v4jfPIQi3IRFmhVDNQdWpfvA5JwKQJu7JEHwGam9J8P86IwKaSE4boh1oJuNPk/x3SiBByDgrxRdzgaieq1GwvM1w5DKA6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FMk3oZrU; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FMk3oZrU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDYITJe7XXmth4pVWcmmmFfxdaRKQbftDC7vQtOkwaw=;
	b=FMk3oZrUKyL+0f8auuHqDbYqRgUx85zY2iRfjb74LWE9eYGQAZvciuhr+v8JABopcZvyet
	ySmu/pJCUjOimCWvY9xLwLsQXGjC672pB8gnNzw5qMvMUrxmUwtkBqbYZdcf88QIfJfiFB
	NNtv48lW7IU+OVqtiZncK6Nsu1DZzgg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: Disable asm memcpys when kmsan enabled
Date: Thu, 20 Mar 2025 17:32:49 -0400
Message-ID: <20250320213256.3359777-2-kent.overstreet@linux.dev>
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

kmsan doesn't know about inline assembly, obviously; this will close a
ton of syzbot bugs.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/util.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index d41e133acc4d..7d921fc920a0 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -431,7 +431,7 @@ static inline void memcpy_u64s_small(void *dst, const void *src,
 static inline void __memcpy_u64s(void *dst, const void *src,
 				 unsigned u64s)
 {
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_KMSAN)
 	long d0, d1, d2;
 
 	asm volatile("rep ; movsq"
@@ -508,7 +508,7 @@ static inline void __memmove_u64s_up(void *_dst, const void *_src,
 	u64 *dst = (u64 *) _dst + u64s - 1;
 	u64 *src = (u64 *) _src + u64s - 1;
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_64) && !defined(CONFIG_KMSAN)
 	long d0, d1, d2;
 
 	asm volatile("std ;\n"
-- 
2.49.0

