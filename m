Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D816EB5D
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 10:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723457592; cv=none; b=eKZapCSifW1hOr7zMrK0EHzxbIIEFEQnnQ6EKIEuwgHvBmCYPNpODPr7LMYoZmqHfF2zNNfy3/UK9vIt5uhmhjZEmINSy2SuTKKD356SiTIbLnTyN6YGguDJ9Y7vRqwKQT+mfuySalZTsywA4nc136o1TXmBD+/3fxCcevJhgUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723457592; c=relaxed/simple;
	bh=kTSrzMPFx4soTo3s0Hit6R+ZJ4uEFL4FEC55OeHn+yk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G0nOAj30jfLwJnwWiXExyJmk1Co9QsWRZ6XuasAhO8uuVRGz7yYFeVlysDmcoDv2ZFOOOJxzAoafQyvArZ5Na2R5s+yrnsWdDc5BTGl08HBeoGwNCmQhrNarnTt4LLPu/bzXAQ86VPsO6i0hQgt3vvi0sjjsR2XWyiHjn9qAr9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbUW7eLR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbUW7eLR"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc6ee64512so28906235ad.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 03:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723457590; x=1724062390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j0/oVL1Oq+JXf69IPhgsc9sM3oWZxuBFiQoTJ58ptp4=;
        b=lbUW7eLRGxxH9cv2MnmSHJCy/roLN+ndcH04/RPlwoqr6F1hGITHT9Sq9Dt8Uru/S8
         eAgo47rN7sBgqKWBv0RoqawpJ11ZluY4+XabVe70r94hApfT/OQKIhMp47bFReM2vwp4
         wWngkDbm7lc4W8LOe69IqkCH+s7N/bWcIq9bOyAIIxtJBw+v67YJ0HlAfA9nR7rZQZm9
         ODAZJOaSE3b3BWmOlyAhelpYRsrc7haqHaerx4RSdzHY6z9KbpRRBvTAFYyrXKXdyAmr
         /YbAX+mQl1sBFwLdCaFy/60K50lN/XwMXOJsD/3rll+hpQ1sdGlpMeTQMY8tV0B288Cj
         qtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723457590; x=1724062390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0/oVL1Oq+JXf69IPhgsc9sM3oWZxuBFiQoTJ58ptp4=;
        b=lQqXH6vK5hfJnNEfGsv2Cc3D50bTdoEiAAW3eDhk1Poaqzm78Czx9scfm/QdC/i4XL
         /auPWV1CoGHkZ271J/v8wB4FsHYeTXwBmZJb9HMVL2ffcLj4Z5EwRDJ0V8phMfoyGlz3
         yLo/xnwCpK2WBGLXhpRnptdO4954Q49vmJuTYPRMuGp3Q6Lh2V5U5rk6Y3Vxw2KjKG1z
         TrfpQhB4SzlJwqyQjCbJBjAy6JZIw0TqMIkcZY21uZatRbYjlJaNI1rXsWQ6v5thQGPR
         uTwEn9hH2ZOqoOWDU+2wUiWl6vz+Kb42wJkdTKWIbcx//hp63YHTTtrF7YPwcXwEaxcK
         7kyQ==
X-Gm-Message-State: AOJu0Yw1ZJHvbiXZ7F8UgE4LoJKXD77ROktPLQcQq0v5kwB6hkt+OKxQ
	tIIw1VwFCbgdtBEuEc1cmiI/FnS8il7VIWcLF7DNlH6EEXUul+bBCNSKbX4d
X-Google-Smtp-Source: AGHT+IFxmK8IWUWqO+4tKDG4UMVjheIytCRs1rNjOzzGRAry/7eVV3LmmjiAjVqVMCnd+LstHn9Ygg==
X-Received: by 2002:a17:902:d509:b0:1fb:3b89:b11d with SMTP id d9443c01a7336-200ae4dbebdmr69786685ad.4.1723457590385;
        Mon, 12 Aug 2024 03:13:10 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9b15aasm34736115ad.124.2024.08.12.03.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 03:13:10 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 0/2] bcachefs: Minimize the search range used to
Date: Mon, 12 Aug 2024 18:13:04 +0800
Message-ID: <20240812101306.347179-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series minimize the search range used to calculate the mantissa, so
that the mantissa can have more meaningful bits which reduces the slow
path comparison when search a key.

The prev array stuff becomes useless after minimizing the search range,
so this series also removes the prev array stuff.

Alan Huang (2):
  bcachefs: Minimize the search range used to calculate the mantissa
  bcachefs: Remove the prev array stuff

 fs/bcachefs/bset.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

-- 
2.45.2

