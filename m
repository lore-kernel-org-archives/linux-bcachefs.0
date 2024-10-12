Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432DC133
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 02:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728699036; cv=none; b=DruK5Paw0GFm4yaDhPnx6c2ldjfWpYAJguDexhqfFApNdeoAqGwFDXU+zFN6jwndbxhXSmeQPBhg3WJ9SRAwA7Hy5+mROpZBPEc/+yzFnHN3nxe5F3hrGia1eZLtkv/2vlhDJqcFvez6N2FZuubLEct3ZvPQxOQzYO7lDGxYemo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728699036; c=relaxed/simple;
	bh=g+n8C8JdqCpw3jvxfTkRmAWjis9WTaetRI8EdZ3M0oc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8jpPJPDgWTmc/kAPdhkH2q62/F6CHXmKKUhhB3rhX2NZQFG+CWiwcXP7WoZT7v23iunD9mjJ3FlB31mc2g4wDPZ6k/JnkbNctnE9dVe+9+FEA4CJ7/3fpwSQ8dO8wYIWnbqqO/QLUQxGeN0TPrTKUyPFnWheMMaCFB31W+cY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AY6ANiMQ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AY6ANiMQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728699030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=koRdYKoZ+x5HiMhprBPanEgR3SD4Gy/ydWTjNa6LiXQ=;
	b=AY6ANiMQTr1XxnbE3cz5ANn2uXQd4/zYF82GE/oIjq7gHqMD5R4PN7F+3YFePkS67STZeS
	jHuXKLl8dcJ1ggHyYVq2clQCDbiY4yS16h/cBvfZ88YkZsRYHfC/c6DKDMU1GUPC7I4soM
	MscuTIt6x7UDnjNTeIN/DArCxT6R/Oo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix bch2_have_enough_devs() for BCH_SB_MEMBER_INVALID
Date: Fri, 11 Oct 2024 22:10:19 -0400
Message-ID: <20241012021019.3306874-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This fixes a kasan splat in the ec device removal tests.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/replicas.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index 797da1032318..477ef0997949 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -821,6 +821,11 @@ bool bch2_have_enough_devs(struct bch_fs *c, struct bch_devs_mask devs,
 
 		rcu_read_lock();
 		for (unsigned i = 0; i < e->nr_devs; i++) {
+			if (e->devs[i] == BCH_SB_MEMBER_INVALID) {
+				nr_failed++;
+				continue;
+			}
+
 			nr_online += test_bit(e->devs[i], devs.d);
 
 			struct bch_dev *ca = bch2_dev_rcu_noerror(c, e->devs[i]);
-- 
2.45.2

