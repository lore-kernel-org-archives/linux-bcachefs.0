Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1EDC8D1
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723308754; cv=none; b=ScIu16kApgd2Be8NgTNM3FolwjINOps5D/W9XstOd95gdunbI0cU/AFdCe/sYIvTyCf1s/AXTdB6iAdvW0aJI9EXgUAyXE2qywaEbIoOMkwlkBv+OsnfohvFT7a6pzltcA/zBOqEBHgy45QSkewZeVrzwh/z8ilhU6JQoOJoslc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723308754; c=relaxed/simple;
	bh=f5gEJqaeof06F9Obj+0d5r4rQjYBNIqwSAjelruO0+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LQ7BPnTisR2LA+L6ZYC2+ws+xjStdpTspdKk1lrAdL/Vi0N4KmOPdjFWmDODj3eSymG32R2FH061o2rOrmENZ61toB2Kr+4jGE5yJNyavr0tNn4svFdIoq6CHBWB2/upKTSXu0pV7i6bCFyq6kg/BsgQU3zkpEL+k0K1//Egc38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1N3eP7U; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1N3eP7U"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fed72d23a7so25731275ad.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 09:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723308752; x=1723913552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3EKrLTe98Zk0C58q9V1WhtJUcyMF2poLrbgsHUDcjwk=;
        b=V1N3eP7UEhmbjl6Vk7UjqAUB73XNTUtPvs6xjpPBOY25Ncdq8WPgo/2Jyw7mRvXsz3
         5tIRkMPKerNGrDmx//oFU6CKiRazmiB6eB4pWfHsfGrpDTq8TJgJRJPPdG/tRT5SzbGf
         7YSnMw88vEVehbCmlyWfZxpnFrhK35X38PBk2IahQNduzXGa16PMiH26Ymu5pJPVPYJn
         rweKX0iUKGN4AFHFg3sINQC2epjubFVGllZUx33n/Lzuksp7f5AbTg2C8G5XFW5oDEep
         qOTnAaFrajSEHejSq//XZRPYju7KY2lrhOEN6DVAtZfLbjUPzVAY8JjZDzXsRab0NerO
         kE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723308752; x=1723913552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EKrLTe98Zk0C58q9V1WhtJUcyMF2poLrbgsHUDcjwk=;
        b=HNTgzyslWgp0fYQmILPgT3uyXKKbbP5IOFyqEon+pUQGxqLLZRciwWoMYyqbE8Lua/
         Vi61Vt9TQosevc7QojUCT/7JIOhC4Z4FRr7g/h4TAqzQAPKSMuq+h9ExzNIwApJGmYGC
         KS+04yKQQlIkm2qqt8VIjerr4kyFHgVIzQiqL6k5q+WWXOVASCAu0z2DhCe9Ir33muTm
         usXrJUOjVR5nUNWAGrm6hKL+bHPiUmMqbtVi9ilzWUpMkgAukNpEPtrnWizh6zwg5Rgv
         LZpgXhzj17XWgUU7sOjlm7qa2dr4y5tmxN8hCKWQwNuMlJWbBGaHqLGEnphxKuHRE5vp
         ha/Q==
X-Gm-Message-State: AOJu0Yzwh9MmQZab6vlnNeGmSXMdqChTenrQQpNbizD2w/ChxfuEzF39
	nUnidd38gIp5GBo9Nbz7lfOU7Kw7nuDzEfpMYFNxmdzY8OFhwPd5
X-Google-Smtp-Source: AGHT+IFYBaR83jO4ZQuA4lGgKrTSTcT9jlIt+BNxiz0bXISrJUol5VAguOpTXwZrs1ZovKxUhSEiVg==
X-Received: by 2002:a17:902:ec86:b0:1fc:f65:cd8a with SMTP id d9443c01a7336-200ae4fe2abmr40551545ad.18.1723308752423;
        Sat, 10 Aug 2024 09:52:32 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8f8f29sm13676835ad.65.2024.08.10.09.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 09:52:32 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 0/2] Remove two unused parameters
Date: Sun, 11 Aug 2024 00:52:23 +0800
Message-ID: <20240810165225.166154-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series simply removes two unused parameters.

Alan Huang (2):
  bcachefs: Remove unused parameter of bkey_mantissa
  bcachefs: Remove unused parameter of bkey_mantissa_bits_dropped

 fs/bcachefs/bset.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
2.45.2

