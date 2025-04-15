Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20E32DFA32
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 05:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695195; cv=none; b=uWLmgDaX6MPVa5vGJiqmp0Za4OavtXOLcPn84oYpP67TDvkIyVOh0tsjF0zJVrtgZzJD9GEb22S/KYgRLoiaP36uTI2HppNWqdKW9vAqJXa5owILwleUF0liyHjOSYXrt7uFaiUSxe6eQgA/gk0D28DapHJMlERmibG+inZOXTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695195; c=relaxed/simple;
	bh=nvN8RXmhTbW2eh4fgZIJmDBZa+gnMPsJhxQueMNLG6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VYSpS0Qb/0DcHAAgMweNQfg3IUwU7e4+OgeLGkrVtbRczSGb2qgRiMDqfSUOj0ZdGR2ZRfssrKG2zukcOgvsNMis0ztSw2yAgZCXm4j9pA0oLDbnAntuihYqViDuEAQoBAW4mf39g6d7xezvPczb8mdpdJbcOY2xzl2GaT1CtFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLWMntIH; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLWMntIH"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22401f4d35aso58090985ad.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Apr 2025 22:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744695193; x=1745299993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ITn+yqBcqy6cGckL0RwLpt5MnJdJ6Op+4NY1PWQUvmo=;
        b=dLWMntIHX5AWJ5/4fItLvqIMAJJYyw56QhZFgvrK6n5sgqnuRASic659yRhMbNMdls
         mVDMa1oAHsvf99AHMhge+ipMHpFv9ztUYUoylwJJbVlvNhd0ninU1fR16HIjPOGER6KT
         T6cYDodKEl5iEtsHlrGCpl88DpnFTRP8CN8Qvr7cVpCPKmd7p1oG8E5cuPdOOfKsXmJW
         aBZRvIZ49g+keCBXTmyahiH47tr3aKUqRj0MQ0IOSYKy9KTT57zjb8SjG0sJihmDhy3R
         VNixW6O7O3eCJEtqRGGOnbGNZEDPU09wGyGCp8FRmfut+sfWGK8owR8j8d7hHbapLPom
         oozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744695193; x=1745299993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITn+yqBcqy6cGckL0RwLpt5MnJdJ6Op+4NY1PWQUvmo=;
        b=eq55K+HOvGlZEotn+RHni4uQSpQGgG+dxwJQokbLB32Roj3zi02E8AFNHeSKgKz7g1
         9CIEgqwvIKRuS+Ga9MW1ESl3UpaiNwaLaghFbC5pibk2Pbuss/GxzNN0G1ygvLvuyupJ
         JIvXjv9ddUdVKbNOIcCobUD3JP0cJ5WPT4ZXcWssIQBkkfcfBKo8kg6zqumDsO8KRZQz
         yEQlVoy3FXDcmMiqfwQPCrgw6yFr2No+UybbrT5B0Owdm6nR5yS3icJ5YVNm52aGXPka
         sucMucsvouEotVmF7HPrNexvSULqymlmamntudLHKpH7HxKbljxjbYroufFnTVri39Sk
         R+ig==
X-Gm-Message-State: AOJu0YyLyWottfYfTLP91sHbK6tPoPWyyczf79zA26wAvXoKRqZlcYdj
	P15lUkpbSq+aBq8ngBO2ZJYnWRD0/KlEQsvGTMs/14paOaaSWU7Z
X-Gm-Gg: ASbGncv+f/P8JIOIRFNKGVGHxifv2tBEcDQF0u3ViK14bhnbR8uCV/6ySngj+A4bps9
	1QbUdErX9na+RczEISANk/2EyRXIyxg54uqhyIrH5ViZuywgAuElobBesRNSBcQ4zAtHg8WWUa5
	RaQe5CtPmkmQd/vjjLJRSvSZFFOR6phStuPL+BBcDDHtA04KwqqQ1MIkYPDtfWps30mQCJqFMtD
	8ALKMSJedjgqJILnTw5cFrMcLOYwozA+xyoqLDmSbCX0fJLAXeesVClNByl4af9lIuXO5EkIFe1
	CadK8IU+0jpc3GA=
X-Google-Smtp-Source: AGHT+IFbamYDu80Rzs+DCDvcJyLMy9UYqagg3FqWqv5NfA5jOC16NW161LWuK7PqgiXY4iaeX5Ldug==
X-Received: by 2002:a17:902:d481:b0:223:325c:89f6 with SMTP id d9443c01a7336-22bea4957b9mr207550935ad.10.1744695192701;
        Mon, 14 Apr 2025 22:33:12 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b8c622sm108636765ad.98.2025.04.14.22.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 22:33:12 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 0/4] bcachefs: Random cleanup
Date: Tue, 15 Apr 2025 13:33:03 +0800
Message-ID: <20250415053307.81354-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alan Huang (4):
  bcachefs: Kill bch2_trans_unlock_noassert
  bcachefs: mark_btree_node_locked_noreset ->
    mark_btree_node_locked_reset
  bcachefs: Remove spurious +1/-1 operation
  bcachefs: Simplify logic

 fs/bcachefs/btree_cache.c           |  2 +-
 fs/bcachefs/btree_io.c              |  8 ++------
 fs/bcachefs/btree_key_cache.c       |  6 +++---
 fs/bcachefs/btree_locking.c         | 13 +++----------
 fs/bcachefs/btree_locking.h         | 11 +++++------
 fs/bcachefs/btree_types.h           |  4 ++--
 fs/bcachefs/btree_update_interior.c |  4 ++--
 7 files changed, 18 insertions(+), 30 deletions(-)

-- 
2.48.1

