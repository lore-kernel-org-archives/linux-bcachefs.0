Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541E43C062
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723306312; cv=none; b=exfO6LZ50SWYXayKl9KNMfdmtX27SdpF87KiKUb82VZHGpAwj7gJ6Wq1CeHE3WJJD95zilRbFHUmjZ4lnR+BXuCYJomjbc+MEqOPXCBMCTR3YDYxXlecplY7B8QR6drN0ig3BKGOZlJQ6UnbC2GYP1+97FcPnTYM+FL98wtUlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723306312; c=relaxed/simple;
	bh=8jqKqvBQDc9ZIIwYZZxsxmhXWljge/JLa3y1kquc4Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=THOSi0JeSt0e53gSgnpD3rhCMrLLy1kKvyRvKbrZqDNSktSIvRyaiwbJQ7Iz/YJgNK8EixSjLT0zNjnqb4jyWpTotIJKQ01wfWlm07E4W+OsmkkftlIJfOeSGWoUFNhmxbS5GFbqUOVLmVDsYgKCjZOmLu5jHqvdErUZeyDeLIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZHcYeIE; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZHcYeIE"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-2689e7a941fso2013199fac.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 09:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723306310; x=1723911110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zIauIvcm0UkwqalbXrhvnVUg3QDWPd5qlKovpET3swU=;
        b=MZHcYeIEebz68+Q9BAOQfL5UJgA2r7Y9T0VgBk9QaHVdtlv8xITDGBsLxIXa6xQvD6
         i2bVRIt3WYtO3tCAI4ozHLRlUQe9HHR+UE4EvVYJxTicR4OeIMNJmoPXOpLZkQZiTKC1
         HzqvqXIhe0Zidvfdk1LX/nkVtujarvHDrvXTbLUUgG8/OgjLf/jQoeNF3QofelCyR3t3
         jdysgdGayQu/WRzbA4QjobBsqkMK1Ws2wqZx9A0cJeJ6nX7/hqQAs9kC95MmqPKi1hFl
         47aZKcRfQyGsnQ8a1x2VgWCbayrpcqtlzS+KE9JHAUULjjP3VzxGcdSCFVdLzYyYeF71
         DLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723306310; x=1723911110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zIauIvcm0UkwqalbXrhvnVUg3QDWPd5qlKovpET3swU=;
        b=oWm1v14liQLdUzwg8I1v0zy9iWMA2wmKFU+m5RChZXeZiw+J6GToKxYZ3snHXg09sj
         PUK1VyH4aHagPu4rJp5IaMY/m+qg6T2w4yBUY4/NOGP5qynxvwFcbYqT6GMfEyBkHWhU
         b4gPspnPuDljR59FlXbuvfsNm1t1IVFs7tJadvUe36YY+36VFHTM+apy2hwt2oHJ9Yl0
         nmPbqhBMjCmyCZMeTfcNICWsRPW8RF64PB6Kw6m+ztqtOqXBRg5rssbQyDlAtrkH1fSm
         9uardC+LMRwpTp8iHjVPgrfIy6Z9UFFxfUhD9ESzRZ67vsNdS3rClQQ8NbjzHjL/DONo
         ZnDQ==
X-Gm-Message-State: AOJu0YwINYnWSwPxJUEqMFIZ1FyperndV5JTxDtMoaUx6bnE1ij/pH1Q
	oqTt2oc97Gv6fV+jHRFqDSu5s1lfDoKWYaUVkxHYBUNPoKcE1/JlKMoYUdcY
X-Google-Smtp-Source: AGHT+IGzbekg8jKldXAmDOZMarQHtC2OFjDlvTKFuNkCx/sEFLnUMmPSyZyDLM9dx1QsHtxqSIZiaQ==
X-Received: by 2002:a05:6870:80cb:b0:261:1177:6a62 with SMTP id 586e51a60fabf-26c62facf30mr6222816fac.49.1723306310400;
        Sat, 10 Aug 2024 09:11:50 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a82a60sm1448178b3a.149.2024.08.10.09.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 09:11:49 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Convert open-coded extra computation to helper
Date: Sun, 11 Aug 2024 00:11:46 +0800
Message-ID: <20240810161146.154113-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch replaces open-coded extra computation to eytzinger1_extra.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index b95deeb83071..e7c44f35f0c5 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -733,7 +733,7 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 		return;
 	}
 
-	t->extra = (t->size - rounddown_pow_of_two(t->size - 1)) << 1;
+	t->extra = eytzinger1_extra(t->size - 1);
 
 	/* First we figure out where the first key in each cacheline is */
 	eytzinger1_for_each(j, t->size - 1) {
-- 
2.45.2

