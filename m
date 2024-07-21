Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074C96FD3
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721565954; cv=none; b=iVVOR1WUJ4bNWaBh61Xfb2hOf4zrcKmQ2FfSR+a1e3AO4SwRVcKOaH7zDdqkOtfDUXCCCRAdZ9/SGdDwWeRvFGulNz77fUPNAkALRsESO6NVyrWM0GFVhSyYDUPPOxhfzpx9YprQna/NVhtxDRWhqXb+3yHbgAMCWhurDYUXsJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721565954; c=relaxed/simple;
	bh=Zxnvq/nU9JaRVQVdO5+SVvhs1X/Ji1uTaPevZfLtM6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KITXPlKKCp9BUSOO+moN4E1hH10IlkXnbhVjNALT27+7BLqyWSRsljipH9z5d82aBAPR3qvnThyYdNSKXF3LzorwemKX0YPwwRoEYrUiD3rScPThWDJeXeLsClNzLILmJLE6ypKCHOwRLX2bROOao/ynxHSYy0Ote/DAFNto4Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsDEOp8V; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsDEOp8V"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3d853e31de8so2098027b6e.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721565951; x=1722170751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jdo2bP/+v32vqfC4zSav+aI/P3Uy0Ha4vJ4GjDQbBJ4=;
        b=hsDEOp8VHJbapFssMEKBnulZ1P0HAtVwThN5tkFdo66jx/FHoOrXVidm04zCrPKQrA
         I3V4vS4QE9DN6VyfKp0HZ7byXY9nF3H2eBf6zB9oosDkcW/+QBOi5Kf8tqE6gPob4vaC
         nF+UdKs+tfHKzSM0pxpi2LxxqW2KMxo8x/ingaoc3eZXlDurFIgQTbKXIq9LWYxZfwc7
         uIz2w3vOeyJZI79ZpTPHFt7LpNgB07oX7myoEBA0mCm4bMEPzanRgSj0pPO654Jba8+x
         D6LJqLVRUt3pzF0cqvwB7jyr6KUvM4ww6oJuehsFkSKNGZrNye6tlwnvovxE3LXkwpj1
         w9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721565951; x=1722170751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jdo2bP/+v32vqfC4zSav+aI/P3Uy0Ha4vJ4GjDQbBJ4=;
        b=XHTgC/fhu5dAfRp6UDVVTf+p1ZBuKvvie04XE5mstfZG1ZGAEqFVznb7zy58uLkCWS
         9ChKYFkGfUsyoUPqNFH7Bv8q4uWyvBtz7+yfZ2X2t9lvTEi9Qcp583NVdtTY6dhBM8ky
         s8tJqp8cjD/XcWi625/9GaY4L0cXttgp+QxQZ9fS9eEtHeajSParv00v7VF/SglC+ymn
         sQkW98TN+Nbwaf8QYyY8pv53RNcF3GWdka/8AdjSHwMxYSMcmELMopaAO2r+Y0vV+G+r
         czMz/yvB/q0eRnL/o8ZO6tdQnZzVvsUCm1gbXqaVzbOyLF74PY4Tmcg6H7d8Uj2yafJM
         /u4w==
X-Gm-Message-State: AOJu0YzmY1qTJYL8aIlkF8mkilZcl6QEGa1tSQWldfbb+wKdLE2Urr+0
	cvC+dIvAYOZ3yjWzhoC+zi+/wz0V//UubvhoFlTtCx3WHIgn4wd3Ko9RyepZves=
X-Google-Smtp-Source: AGHT+IF7vdyfJDwy7B6uBYB75VqqWokuxxNhknKPfISaTD/RWzwoaardfYVSU2OJnbBya2a1TNpUGA==
X-Received: by 2002:a05:6358:419d:b0:1a4:7f4e:d843 with SMTP id e5c5f4694b2df-1acc5c82a39mr503597255d.25.1721565951493;
        Sun, 21 Jul 2024 05:45:51 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f42fd1dsm35750865ad.183.2024.07.21.05.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 05:45:51 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 3/4] bcachefs: fix macro definition allocate_dropping_locks
Date: Sun, 21 Jul 2024 08:45:47 -0400
Message-Id: <20240721124548.248742-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macro allocate_dropping_locks accepts a parameter _trans,
but it was not used, rather the variable trans was directly used,
which may be a local variable inside a function that calls the macros.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/bcachefs/btree_iter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 489004173d28..b4e71b590bc9 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -860,7 +860,7 @@ __bch2_btree_iter_peek_and_restart(struct btree_trans *trans,
 	_ret = 0;							\
 	if (unlikely(!_p)) {						\
 		_gfp = GFP_KERNEL;					\
-		_ret = drop_locks_do(trans, ((_p = _do), 0));		\
+		_ret = drop_locks_do(_trans, ((_p = _do), 0));		\
 	}								\
 	_p;								\
 })
-- 
2.39.2

