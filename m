Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4415729A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Aug 2024 04:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521740; cv=none; b=JjF+c6Gu7G+XHSFwXUms5gK5a/qzBSdJJhCDCVv4O0ID1iCIl7N9gLni7DWpCKD9BANXPQf+yook0erz3Er8Eyxgmwc5eEgHv6iKfj0D2jkfPpZh3JrzIzYPOljLxRVmdQ/id6nXeU+5PwBOrU/R2ipa1uaocJFZNTU8WuLBp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521740; c=relaxed/simple;
	bh=sxsFGQAWO0BXpMTKctnDbMQ3O6J5pBHWmIi02vg5lZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NZdmGx6HGy/578ds+YRGK6MlNHnSxP9E6hWyDo+/5LSPSEioWc1vO/7gRcdwClsL1TPeMk11WlslT5lkK02RGsluFh+pXrHOF+1bQuBTUtCvrybw6X0osSD0FlmEpkXy6H6AcE2yNCQNxqxBvnpYcprN7hqyxn49zX3Wq5LK09w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OeDLBBqk; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeDLBBqk"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3db50abf929so3776088b6e.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 21:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723521738; x=1724126538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ja/bT5X/sDfQkECbkajhZKWiVKo292PoIcZ7nG+v9J0=;
        b=OeDLBBqkvsp0gceWnfMUklmXDPXK0F1RT8hzQmQxTOEz6jZcr0OyL0y8y3w2pFFSPQ
         98WOWV13aXnCt0C0Bk/HdOXAxY4U3DSXC8HjtLDyHLdFa15DHUV7vN3+PvJV4WeQGtgn
         47yfsOcxFu2q5YJ1E1o1owvmOzN2+3O40TAiT+lPu48gSIrDdZuufQ6yBU0MTR3qfUWp
         Oh0azo5cjNjPnLE83x7uCWG3ehq5dtQobimxC3xHNnfqPBRFqhiQG2JcUbILJ4Wa/Bo3
         K6TCTy3EluxBtUQduv6DeQw39iX9G/uBIDQBJx/5HTiAS5HLJzvHMgyuli7JXx8kZypr
         Fv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521738; x=1724126538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ja/bT5X/sDfQkECbkajhZKWiVKo292PoIcZ7nG+v9J0=;
        b=BfynmF9SGq1BM5Fy/DckptGo75Y4ZIl396GCTBW7aE/cHbvW4BuS660j0YcS1oOSwT
         5UBhtZSEGDqlZrlWeFgDYjjLx+UeHBR/YQ+acTSSosYrJEGaIfQz0EfZsyfQ0V1tlEVD
         YrQF/2SsvTI5HWrLEBgCGpC90sXFFqSMFn5daqV+B3wilvRlwH8F5PrMvMpyQ/2r94Wx
         IUdBQotfUzq2env/p5Y/3FVDkGqAEQDNFeO6I/YJmzp2UzgJqNX/KS5+1tnoQ5IBU5aR
         D26BaIpXaay5MBjHMP1MG/Z7pnXuNsoPIsiSU/sV3r+ro6dgvhVo9Mm2mC49I7oxzVbl
         hqGQ==
X-Gm-Message-State: AOJu0Yz7Ua9KbEBaBPqFmuNa62H8gTHFIoxZ7L8uvMeRQV5PuxxtDFnS
	UA8DChD4RcvyNI4N0PJ6HQUmBq6EShRVOLnLHqLaxiTQUBDcaEoRW3l9aSed
X-Google-Smtp-Source: AGHT+IFtZVA1T8mX2FSmP+y3hV3KFKAgqMYtpnzQkTTeO0REGhx5vHHgpxNUdM6eVoBEIrUButEWIg==
X-Received: by 2002:a05:6808:2f08:b0:3da:57b8:22c1 with SMTP id 5614622812f47-3dd1eec4ab0mr3090271b6e.35.1723521738300;
        Mon, 12 Aug 2024 21:02:18 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58cb168sm4898177b3a.95.2024.08.12.21.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 21:02:17 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2 0/2] Minimize the search range used
Date: Tue, 13 Aug 2024 12:01:57 +0800
Message-ID: <20240813040159.375953-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Changes in v2:
- In v1, bset_aux_tree_buf_end still includes the size of the prev array
  when calculating the buffer end, v2 removes it.

This series minimize the search range used to calculate the mantissa, so
that the mantissa can have more meaningful bits which reduces the slow
path comparison when search a key.

The prev array stuff becomes useless after minimizing the search range,
so this series also removes the prev array stuff.

Alan Huang (2):
  bcachefs: Minimize the search range used to calculate the mantissa
  bcachefs: Remove the prev array stuff

 fs/bcachefs/bset.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

-- 
2.45.2

