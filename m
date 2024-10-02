Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A996433A9
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896003; cv=none; b=N9xcl+XPdI48nSWvU82TScVhedRAYTAll8yzzSgofYxTmXgJf0LJacc3Fo18tQMvpE6PSsIWtYusHXaGu180g/C1oo2TU7mFc3XDNKcuTw5Z+eNXywjiZmhGcJojqWE4si9SNu8oNMayOP+zepV7ebnhOWjVdcofm3j85jo0u7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896003; c=relaxed/simple;
	bh=8XcudcsOsmJc+yNymI3Ez0VlXyNPXk8KgNWd0wKniAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJHdZDkPcbG34BJ+Ijm/FUzGQp2HyQL4fg/uHlE2umGEiylD0rKC5NbhPws/33N2DKfbuc1koPS+gHUrHLJe6ae1eJ6wKUuU++KJBvOF/Ze5jH9B+nrNpy/QEI7kmkmVUTGZPN7aSDm5othNRmNM9KgKEnYVLiyvHvBfiliCC5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=deVx0QnH; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="deVx0QnH"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7198de684a7so157149b3a.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727896001; x=1728500801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnq4OSe3iOMiXR5bQbgqPstxqol9Dz/OJ354a/eysfg=;
        b=deVx0QnHABmKGlmVRIPdmZURW28wkM6cFquEtIEBQCk0SiwMWeQR+q4TUbCoEDq7A8
         JLqaTRnm6cRhVQ2cuccSl4TLsQjlXeSviHYhM1t3sFLKGIfq3TWpT5ZMHf/zM1CETrbz
         xqtukY9Ja0Fl2Av44kFsNmt07RaTWsfJ5AOX1H49YTdqXoolvAO5281yi219LMjvn2s8
         B5uRiYAWiY0ZqBGqdG5DoDEdL6uH0NmWM4uUfMVCFhYN6mdIL68Bq+WWRgSOhAffxE7I
         xxhL/+KE9d6sh1PRGGs5CnN0XOQ8cs+gdP7D1KcWflOgAHWD0peokm7Fu1LZKDgibVx1
         B8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727896001; x=1728500801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pnq4OSe3iOMiXR5bQbgqPstxqol9Dz/OJ354a/eysfg=;
        b=qr4ZvGXJ+73pMr82kkRwyWPPX3JF4mPcJlVizhnHbTtyuc5uyBv2sxBkbRJMxIlwFq
         mXbO22BEUQrQooP11uvi03mV7QxOuvMPU/QnPTN9exd3Uqb1Khg7H2c01VQhS8CjaaHL
         2ZUNNBzZlylTgoEFx8Sjq5IU1IpfyPdm45mEfrRbLM27rCwH+ijny7evuk43SmyGvoTL
         UI3oil5+c9A0oXOyCeXaiSU7WnEJdJPNfScXcOgJp7RCEdDEMGNkSNJ7/hF/KKZp7d3e
         OTuy1fPn10JMG4sNklKPQnrPUx66IIFgJ9w+vDZU+etgNr+BEtZYGnj/jru5r9HyT9LP
         TkZg==
X-Gm-Message-State: AOJu0YwEW8dt/MAWwf/O15kXTunmrar03SGjtYQlLRzlqKB8ilhma8gj
	liFt9ezlx4gI4kV3Ns1E32706dhKT5Mg7kM/ybCMhlMy5qQqSM+h+0vsvlYt
X-Google-Smtp-Source: AGHT+IE9NOs7LeeDZ7jeaX4exVN+1R4fzoHtKlsimnxe6hQ486TqaJKlVprJKkrHPx0Uao07ErKk4A==
X-Received: by 2002:a05:6a00:1742:b0:718:e188:fdf1 with SMTP id d2e1a72fcca58-71dc5d538b1mr5203615b3a.20.1727896001469;
        Wed, 02 Oct 2024 12:06:41 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2649b158sm10179975b3a.33.2024.10.02.12.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 12:06:40 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/4] bcachefs: Introduce lock_graph_pop_from
Date: Thu,  3 Oct 2024 03:06:31 +0800
Message-ID: <20241002190633.1454448-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002190633.1454448-1-mmpgouride@gmail.com>
References: <20241002190633.1454448-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces a helper function called lock_graph_pop_from,
it pops the graph from i.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 50d9366d49bd..8cc648be7d29 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -109,6 +109,12 @@ static noinline void lock_graph_pop_all(struct lock_graph *g)
 		lock_graph_up(g);
 }
 
+static noinline void lock_graph_pop_from(struct lock_graph *g, struct trans_waiting_for_lock *i)
+{
+	while (g->g + g->nr > i)
+		lock_graph_up(g);
+}
+
 static void __lock_graph_down(struct lock_graph *g, struct btree_trans *trans)
 {
 	g->g[g->nr++] = (struct trans_waiting_for_lock) {
@@ -131,8 +137,7 @@ static bool lock_graph_remove_non_waiters(struct lock_graph *g)
 	for (i = g->g + 1; i < g->g + g->nr; i++)
 		if (i->trans->locking != i->node_want ||
 		    i->trans->locking_wait.start_time != i[-1].lock_start_time) {
-			while (g->g + g->nr > i)
-				lock_graph_up(g);
+			lock_graph_pop_from(g, i);
 			return true;
 		}
 
-- 
2.45.2

