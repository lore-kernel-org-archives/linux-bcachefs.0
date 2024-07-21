Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E210634CDD
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721565592; cv=none; b=gF5stWuueBZN4OYoEfC9ONpiLOeF2Ua8fvpmDa1Arbf4LOm+zZiMxvPUxHZ+Xcykb+u+MjBjMyRnHNTkoBr2b5MUU+qGSpKjAobGTcHBJgKcAbAqQsitumlWZBqmIt75sULsHmD/9yJy9RF2iQlU/SBPdhkekCDEkMrLWBCU9c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721565592; c=relaxed/simple;
	bh=PzFvu34kRIVjyLFf2XIuoOJKuwAUvWYl7rI/TI5fg/g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Db6feU1+0heVYFMb2bM5XjoUiQapIzIPXMDDfM08isnyD1MbyxhY7QABNJZ3DrexrBMiWPFm5QLYK8MeerORrm9E8lrxQvZ/jSCdMkTNgXZ3UpZRATcVyyNbs4H1xr9NNI9pglId8Pbd2XcpRGuKM97DiB5/z9PQJTo6YlZJFnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eXt5hhbn; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eXt5hhbn"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5b9778bb7c8so1770511eaf.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721565589; x=1722170389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m9lr6dge5IIcuGZZbTEMRjWaNui3XFXSl6CZTNNpKlM=;
        b=eXt5hhbncKq9jART4/HIjTg0esu0SNo+xgT5WhmGFZnZvbvJSxBiOcO69JUcu53yvx
         ZFGOcIoyq8aMK/GaSEhlOWN87BHpZzMnTFuuQ6XxTJcLNTKoUGRlY/35FKZtHF67DPqd
         F0Dd7fxElj+9N2Zs7v1lO9gqdgrfAarPA/KqG5JJcXNRxuDusEVSRW6KMbg9wiR36gFD
         bcxTEIXKwj/Cq4L/H7FTAxrWvnBcsmyQLGRaQGYEBPDF7p+RCzmq16PSwSTjltfuH41x
         T0GJn382ghhAegoLJwXysouwZ/kS41I1sXARtbi/Yx1pTCC9fgS+Ga/RAVdsvQWHnKRr
         uZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721565589; x=1722170389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m9lr6dge5IIcuGZZbTEMRjWaNui3XFXSl6CZTNNpKlM=;
        b=v/EW+teQ632xD6BiJMGZcCZmOnlg8cOkeGxiSl1JqmrW48RTKehIB5JBPnciAIA0fg
         XvF83jk8chVJqMMTYaupsL323+Crfj/YnuFIo0Ww84TImNTCSlE3dyU+dwgVZnwZ+zpt
         V3r3a79E0KZjBbaB3951rlBmQ5BYMcZ95p15KU/AS/diQlYriMHE+Fjsf+Rvea7pFRdX
         NIHFz5E1vEyTwTKT2ZKlcz8COQkM1OhOa5jQxbms4dJrPNNvozT7CTZFQlJXW0aYGD7I
         EduAUvrMG3J0po8hhfjux4byVm2DkGFBrpxcGhM0ZIWYZY9fzeanwh37BcBYGkptbFN8
         wKTQ==
X-Gm-Message-State: AOJu0YytOpSs6rGTLi+EQEuvAUuiF3CSNLbGbx9e0zfU++n04tImArIc
	2kJ+WJd6GMXXEzGajkdOEm5oiMxMgAgAO19hfgHVIu8A+7Oau1XW3jxER2PFmV4=
X-Google-Smtp-Source: AGHT+IHm+uewgwA7wGFaMXCWxu2qqbLK3VJSYopvfI6o3qS8XXBvFTApjGw1N2zCgJ/LwOrc3wjyzw==
X-Received: by 2002:a05:6358:8aa:b0:1aa:c03a:51f3 with SMTP id e5c5f4694b2df-1acc5c3e5c7mr567485555d.21.1721565589058;
        Sun, 21 Jul 2024 05:39:49 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf7c7244esm5080709a91.29.2024.07.21.05.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 05:39:48 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 0/4] bcachefs: some cleanups and fix about macro
Date: Sun, 21 Jul 2024 08:39:39 -0400
Message-Id: <20240721123943.246705-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the macro definition detection tool I developed, 
several issues were identified, including unused parameters  
and unused macro definitions. Let us address these issues.

Julian Sun (4):
  bcachefs: remove unused macro definition
  bcachefs: fix macro definition allocate_dropping_locks
  bcachefs: fix macro definition allocate_dropping_locks
  bcachefs: remove the unused parameter in macro bkey_crc_next

 fs/bcachefs/btree_iter.h | 4 ++--
 fs/bcachefs/clock.h      | 9 ---------
 fs/bcachefs/extents.h    | 4 ++--
 3 files changed, 4 insertions(+), 13 deletions(-)

-- 
2.39.2

