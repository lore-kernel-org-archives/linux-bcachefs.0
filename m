Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C41CFEB0
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727896013; cv=none; b=bd1Q+in+cvgkPj2Y+smUxl3IZaC7Ze3Hi39RCV67bbEQsuIMk7PexcXtbV1lWPN/iXDmIGVBOUKRMklMSzdXAv3Fv5KqjfkBhJCHEwAck0AsGZcUlCyBIwVtrj2bwTbVhHANbWbLFiTQNl5yBvo0A8bFgLcpiUInjYHHXRQ1xtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727896013; c=relaxed/simple;
	bh=CA4wYVN5QRGkTtet8P6e8VL0jOVYwwb/8uIeWXbXIAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ1Ht7YIXDOyEf9mDIUn0BGam5lxq9XtDQ1Shl0IbDHaPeQwiq0gaK5oIITJVLT1ImXMJwVh1b2ePog93mKfu8PDTdaMWETYCjtnWn9U3YIjhCOoVkgvhDiOsRvuWtWHCat4zMIZFWpcayC4dm1aAaiayzqheYAx/6NVHYq0Ukc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3NKQufr; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3NKQufr"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-718da0821cbso184194b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 12:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727896009; x=1728500809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRq5zypbacD+AW4hFumHcaPGjV9mQdUxCLfFzn599WU=;
        b=O3NKQufrKvWQiYLi46bKNYASvUT/owSD27d4Nv05AihfUCJ8UgmkkQA4ePEZuH7UhP
         WSbz5v10PgqJSVtOQ3CH1VE+3xfX0PAmk9hOGc4mnEFB8pXI7G+FgbeGBgRcPPvoowW7
         /bSYoUm7olZn4bLZq8SGVeoddgbRSS6gUq9vnZoNR5+48BAAg9aYcL+KCrS5usOXnS/i
         nwSfUGx115yLH4u/0BAen3K3XvdmEKCgCS8Fu/1MKbxs3rIuH4kDfzFS8P0FJbyEzqDO
         I1dKQUusNqvFWWlllMZBa9PiOsdQMHM6Xw6TSLyV5GBznITbMenNIuHKMvI0CL3fIkDr
         1pHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727896009; x=1728500809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRq5zypbacD+AW4hFumHcaPGjV9mQdUxCLfFzn599WU=;
        b=gKQuwnCVd9qQwUxS+HgB3sDB+jAON0VaZyUB5hTEwWw5RuKjF+U4sgUVbkQ4qBXcKP
         ThFwOjqRdUS5AFHo7H5I6rJQHbj4xA5iFHx/zDP5NhQuq8YhuUVQGy1aHGo2CBDjgeUF
         gG04sQLMdv8hq+bkDLAgH8Xj5KnazjqhvA9U3whRiBRQMwW6Z2+Ge2F3QmRuoHrEXiMl
         oqXVigAJtzheXWEUXHOSpSHX+cV0QH3BMOAC50xvrf/U61RT/5pwVULAS0GNSD4t+eq7
         lXloB+Zq1wbQJZsaqJIKSR0LLvVr49nI1YAbZSZ+nlYuOHC6hqBqwlQlZHaZEnDOD+dp
         woEg==
X-Gm-Message-State: AOJu0Yz4wr8mVzgp6crfVw55Np6Nwa5ZJrK8LnY2c7a70d8QOiLJ/IwO
	IgyrUKVoS1yapBrYvdsnTMWWXD0oFPWp8kCrJqEvQhySUAreREeAI2xz9dL1
X-Google-Smtp-Source: AGHT+IFyszNzvXWT/YGMTo10ub4Nh9Xt1WqOWqWDoWXe8a4C5xyHfdN11bDjxWg9ldNJ4BG8TeSo7g==
X-Received: by 2002:a05:6a00:178e:b0:714:3831:ec91 with SMTP id d2e1a72fcca58-71dc5d87c59mr5659006b3a.25.1727896009545;
        Wed, 02 Oct 2024 12:06:49 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26515eeesm10135538b3a.130.2024.10.02.12.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 12:06:49 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 4/4] bcachefs: Pop all the transactions from the abort one
Date: Thu,  3 Oct 2024 03:06:33 +0800
Message-ID: <20241002190633.1454448-4-mmpgouride@gmail.com>
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

The transaction is going to abort, so there will be no cycle involving
this transaction anymore.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 70f13ab5ba7b..bf25fd0a1cca 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -242,6 +242,8 @@ static noinline int break_cycle(struct lock_graph *g, struct printbuf *cycle,
 out:
 	if (ret)
 		lock_graph_pop_all(g);
+	else
+		lock_graph_pop_from(g, abort);
 	return ret;
 }
 
-- 
2.45.2

