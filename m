Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156AF1DAC95
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 06:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754461564; cv=none; b=LZQWXranGg3teTk9bax7Ou6ol1z6+WvC7Eg2dnZKQ3vTW9TCmRYaeK2MC71kqMn4fqMlsZJCTi0rAblt8SrY6BcdBtAcd/gG36+ZEPq0ZF/5CtRgR8vMrlVOu0B77VP/AXLARBR9r7FBCI55JXys2MaDep1p+RaOMmDC3FZ/Twc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754461564; c=relaxed/simple;
	bh=HkTGt4D2GzR0x1ylg7so6mcAFLtvF8A6c6eztWcxenE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZibNElDUlbjlVuHHtL+r6mwhCVOjqtc1lDsPvf8pzdkPxroLboNfpMNTezhm6XWEZSG9JpABnzVofssTG2/2JlJB/xrHO+OzVI6go9Xp16EPOlxP22YwisOpRmxl/fYvoXCqLnwBo2pRmM5hs+ZbnnYHjsM78h75RfIxcp7dta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WkXGDMWU; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkXGDMWU"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2406fe901fcso52735265ad.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Aug 2025 23:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754461562; x=1755066362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8XaxEoBafXlrMIKoO5ZSYRS+1LxZw8W8OkP06im8vO4=;
        b=WkXGDMWUZL+MOSRoK/Wes+vlOwm+NHy3FvZvAzMuBQCWJYhWdgGec6se0YlVn5EngT
         QdvpPzGEYaueixnJJdOMMz4rlIRPreW6CWO9DAlgXGyeFKaJ0eOeRiItAemZOw9xqkoj
         uUBkn7ChFy/UjXTSMr4+kUCJ+5Q7L9hTVHbbn36CvW7TtOjnZO+/EHeQw8emuZX1yvPL
         RcrEQKmshMB4xsYX7GKKlMQ8ixPwxNRg4CWfJ9FH6rHUzazOnmQ8u8GZrALAOnPC/lpE
         TW4Q01U074tjFWe0P/LK1V7vrwqYlAaG8IUcMK4fYsP0MWLsHyRsfhAjHaYgii8lTGOS
         XDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754461562; x=1755066362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8XaxEoBafXlrMIKoO5ZSYRS+1LxZw8W8OkP06im8vO4=;
        b=VN9MaMLaBfz9tKXBf1g7wYtpZL/6rF8uMZf/D4p2CpvZBicy5ypzxH9iK20mL3rzb9
         RsR9VFqTcY0NPOeI447VJADjvt+gYhnxqrzJGaFWo/72i5NLFvsZVz2BmrDUR+JPJCsf
         1MZrhylDgPzmIwNiPwYrqn9NpsdVjf5ViSgHTgUq0Mk3xIvRxL8DUd7ycnCHNeIAC4n9
         kp1+vBxGGeo3HA0ZoKRKaPZTtYnksYTy8x4Szvpfck71mmNoPQRKBbHa14KWcP9JQmFu
         tbpi95aaEEr4AARfhLfM7cwBDfSGj7Hgz75mPBdRQw+jkCM9xyyxrIaRtEKtg4oVUpZx
         KFsA==
X-Gm-Message-State: AOJu0YxsMlF3UjIkTpvVQEWjJi8KrJuCDIY63Hnhgz/3g88GjI/tvGg2
	9BDCSunTcdGvZSmTyaej9w89M+RohPtrcXsBeLUhtRzvaGwRfxowH6mM
X-Gm-Gg: ASbGnctEAJ2Cw/WhQZc7aXvFeUKcKt7akMDkIM3TC5CTyvtixyvO2+aMgsCxAaM6Ues
	Lldu42bm+e6xTvChpTx07bB9BqRr2wXY5isv62oNZDyaCylu8khWbpMJp9E8PjX6qBHCTtho/Il
	k3XldKnShkCAGTlOxhTm6Az/lolTi18y6Bdyc5iKEJPlbXmPGK5zhQQOJ6I3wOJ0Y7YuR4ofPXF
	UorSfNTutD1Qb3/aijgkPcOVRcSRL+xAIeXirsyT60JAOodGk6nqbSn3ZVZVZedMRPPFbsEilmF
	7yfC+7QMBuk59HIUlYn/zXBpcBwG6w6Cs9bLecb0x7sfd3laDGauU0Awuo3iDBDn7J/Ony4Q
X-Google-Smtp-Source: AGHT+IHr0juFgDfoNJDDcINs3YumAIjSNprm4vsj5Ltp2OWRkAmBLiOBNQqkKDt08fHscj1RRCXC9g==
X-Received: by 2002:a17:903:124d:b0:235:f70:fd37 with SMTP id d9443c01a7336-242a0aa6a40mr19924445ad.19.1754461562214;
        Tue, 05 Aug 2025 23:26:02 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8976879sm150520435ad.76.2025.08.05.23.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 23:26:01 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2 0/2] bcachefs: Fix readahead involved deadlock
Date: Wed,  6 Aug 2025 14:25:55 +0800
Message-ID: <20250806062557.458303-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
 - Revert the readahead status so that caller could handle it correctly.
 - Factor out readpages_iter_folio_revert to simplify code.

Alan Huang (2):
  bcachefs: Fix readahead involved deadlock
  bcachefs: Factor out readpages_iter_folio_revert

 fs/bcachefs/fs-io-buffered.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

-- 
2.49.0

