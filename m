Received: from mail.commonsconservancy.org (mail.commonsconservancy.org [145.0.6.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772A819C54C
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.0.6.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730383583; cv=none; b=q8MGvnw62pP8vjX7T1nNGdtR9ugk88iOIFbXh/ujAQs/0VlFzdpqz2k1A6t4wFjtE34zS4vH+DSU41g660iRWBroitOmvfEMExNVYezaZHmaavBw9ND4LeLtc0rJ7rW9o/HWuBZ4M6U5uSCHQ9hDwVieRPGkN64s+LZmCl5kLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730383583; c=relaxed/simple;
	bh=BrmZNO/kWpgvjsLuKdRxk3wRQOfwVZSygNGlGElUutk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TWMHdwXWdL5i8TiH3CwQFCiOv3uW3E3UkTa6cJljFlT8ue2kicGwPZdGPcB+HpfTRggwYCTZjWk1/28NDaHZLambC8ZYY91r/6rcTkDfEFlbc515MbiC+0Zz3Xq8o56tSIm0qq8iEKSE3EHVWilaixizcdcRcva3wrVoBOVbCHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commonscaretakers.com; spf=pass smtp.mailfrom=commonsconservancy.org; dkim=pass (1024-bit key) header.d=commonscaretakers.com header.i=@commonscaretakers.com header.b=V5vPlQah; arc=none smtp.client-ip=145.0.6.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commonscaretakers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=commonsconservancy.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=commonscaretakers.com header.i=@commonscaretakers.com header.b="V5vPlQah"
From: Eric Herman <eric@commonscaretakers.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=commonscaretakers.com; s=mail; t=1730383574;
	bh=iRHl+hV/t/g80EYUW5kSTXQCPIi2pQVV8MhByWkYrzo=;
	h=From:To:Cc:Subject:Date;
	b=V5vPlQahdspCC5jhuTx7uOHijZnQjcZHncQNak3cBeCPnG7w6H0YgYOEbku3RJgvQ
	 XkG8MXkgzjUdOaHZ06ys+Gc0Lk7KdsJXLn0NAXzSP7d8cDoUUTWXEJPqKjakVN7br1
	 BynyZlC6Ft8Lgz16xteiXfGMYFs8jN8J8HV3Fxiw=
To: kent.overstreet@gmail.com
Cc: linux-bcachefs@vger.kernel.org,
	Eric Herman <eric@freesa.org>
Subject: [PATCH 1/2] ktest README.md: update location of test file
Date: Thu, 31 Oct 2024 15:06:01 +0100
Message-Id: <20241031140602.2146768-1-eric@commonscaretakers.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Herman <eric@freesa.org>

As of commit 89bba65 the .test files moved.

Signed-off-by: Eric Herman <eric@freesa.org>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 28c0801..e6a415e 100644
--- a/README.md
+++ b/README.md
@@ -43,7 +43,7 @@ Then, to build a kernel and run some tests, from your linux kernel source tree
 run
 
 ```
-build-test-kernel run -I ~/ktest/tests/bcachefs/single_device.ktest
+build-test-kernel run -I ~/ktest/tests/fs/bcachefs/single_device.ktest
 ```
 
 While virtual machine is running, you can interact with it by running various
-- 
2.39.5

