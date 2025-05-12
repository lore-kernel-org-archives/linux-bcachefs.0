Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326C248F71
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 May 2025 18:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747075476; cv=none; b=H5WqxdmbvOa+eZxWrdcXxnwOcz5+8bQLYXObT+gic6/yv/pE6m7PbVRcvSlpUDyhUzT41vAAV1tg37uGAxVw5EzsKyqctCXZKHP+EG+KXRkyeOy7VEv14PQ+QvDm72tUMBVpQn3xD+n2d5GzBgIBV8m5kJn+jV+o1PPOCSlWjBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747075476; c=relaxed/simple;
	bh=zWM5CYYiAjo9Xo8fmmUECD54I/xwKdKItRPsy0FJRnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7v6lSz8V6cQzRmibL7YsK03o/wK0snG4jlODfDBsjHrFAYbq+HH6FLFqiwQnKlcnZNypGpMiY6WdpJDZgA9eIUzl9c6+ZQThgxJPhAtp6MaI4RAIBdq7tKLMqKedqXEj92WkM0oWF+1voLeRNSR34IGfNOl5DywZwPyC7yQMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SsWZcq0v; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsWZcq0v"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-72d3b48d2ffso4968833b3a.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 May 2025 11:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747075474; x=1747680274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4hqkAE+Dc4cPsgR8bxfKj8ciiyyW6f4g4Dbmt7Hobg=;
        b=SsWZcq0vT2SuhC3x+P+lGsyx1el506mtQ1S979rNiiR825TMeMioPkiHZ0x5VdaJaV
         Ti8DIFI/y0JNY/4oSqCm/dFsy8gyAYDcxCOAQPt00kGA5zDpicataKtHmrIO3qzh6csP
         8Kb595gU+3HoWmqWMlgYG927Ba9wR9BRFdXnvdnCKW4SJugei7n0UUzTYSaubsld8LyS
         djfBeWx4oTsrfIEgHBKqZRJKzPfKQmN54eky4DZeXUoaohw7HTEcv/iAs/qFlew3kKYj
         h+bAtYmRxkX8xXA+31Ag0JoPh4dweIB/8QxZ8fETgEqA6++fZ+zVQaVeHeXwORR8XX2a
         04Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747075474; x=1747680274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4hqkAE+Dc4cPsgR8bxfKj8ciiyyW6f4g4Dbmt7Hobg=;
        b=NJpKNxsofVXDEXBkqkz8nJu84ZHCbbldlwVpWUqb/sM9Z976fvF9uxIHwOq8ynnVZW
         svxn0YjZhTzcPL0YycU+oGvEgEH0SQJAAkN0UFLsYEPgBp0Jf1GwRcn4THdGePwYtaCQ
         TDQLMv5N+f06tUSN5DZpvK2ywYFgPqY8MPJUQaReludXi4PVrD7Z1eKsNQONBNbVIV06
         fRqKPo4hDJ7nK9XtEMyyz8z0nJ3KSx02LnnozbNm+DuWvassRbHmo55uSd3Oid3t7TMX
         rxXs/UbzW1VvlZ3cNQ7e8zHHTUReO4ZzMoZgI0J+zh1w8gYrVTKQ3laLodAGiP0hTGXx
         I0VQ==
X-Gm-Message-State: AOJu0YzES+8DiGUF87KxY2u16Z+Oai6mV3g4NawJngn8bP7XP8a028mh
	NVC6RDyc3Gf7sz2brMMypjNDIkLZB9uNzoUbwlKuE+HMXR6+YjL4
X-Gm-Gg: ASbGncupeuQNMrRmw54z8ADz4ByCzjqdMZnIp2UiE1VXjFCATWMwkX1LDyq2iXXu/Qp
	didxqaHdZHZYvK8DWMC3ib2cohCJc2LVMkWzA2AGlX5Lbd2SB4ppKVMvA6XFkznvFt3SzPjUEJr
	ptCqJDm0dDhJNqUmST9P1rEg/qARPsVvdj7yllD3+2iDN20bhvbXXRLnjmHzuinGmPNneo9Ftsy
	KUE7OEdXC3NQb74ibBqa9YFrKPY5EiUooBA9rjqzJ6nPAbdXnSZD8FcknMNRJr4/nBx3WnHzw0U
	sMxWI8nz69GhTscwKJxVL5II1g==
X-Google-Smtp-Source: AGHT+IFaQhZW92PUoQnyRJEyMau4wr36M6oVOoThWGZMvVhzrJQIPJcq9UucRIdpXQ2A4hnUVc6LzA==
X-Received: by 2002:a05:6a00:1915:b0:736:62a8:e52d with SMTP id d2e1a72fcca58-7423bf9bbe0mr18358977b3a.12.1747075474627;
        Mon, 12 May 2025 11:44:34 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237736e4esm6626510b3a.67.2025.05.12.11.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:44:34 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Early return to avoid unnecessary lock
Date: Tue, 13 May 2025 02:44:26 +0800
Message-ID: <20250512184426.72038-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250512184426.72038-1-mmpgouride@gmail.com>
References: <20250512184426.72038-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/alloc_background.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index ac27735c11e5..043f4814a0d0 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -2585,19 +2585,18 @@ u64 bch2_min_rw_member_capacity(struct bch_fs *c)
 static bool bch2_dev_has_open_write_point(struct bch_fs *c, struct bch_dev *ca)
 {
 	struct open_bucket *ob;
-	bool ret = false;
 
 	for (ob = c->open_buckets;
 	     ob < c->open_buckets + ARRAY_SIZE(c->open_buckets);
 	     ob++) {
-		spin_lock(&ob->lock);
-		if (ob->valid && !ob->on_partial_list &&
-		    ob->dev == ca->dev_idx)
-			ret = true;
-		spin_unlock(&ob->lock);
+		scoped_guard(spinlock, &ob->lock) {
+			if (ob->valid && !ob->on_partial_list &&
+			    ob->dev == ca->dev_idx)
+				return true;
+		}
 	}
 
-	return ret;
+	return false;
 }
 
 void bch2_dev_allocator_set_rw(struct bch_fs *c, struct bch_dev *ca, bool rw)
-- 
2.48.1

