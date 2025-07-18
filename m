Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7FE291C10
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 07:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752824830; cv=none; b=fO6aj2OE4FuGnyM/HZ8G68WFBr9YwrppwGyyNyMessQW7YwrQjzYa/aunYY0oAqCwQ7+Wax595BLkJkjIhga1LQEtwAlGLyGAiIh098ptvOY70wUPTDtAPgCQzZvxaXL2GmeeBCh/cefoem1ISOI0AFR3hlEBnmJhe3l/Xd1bZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752824830; c=relaxed/simple;
	bh=5P0mmkI8IheL6hKU4l8NL+K9zY2DpKsKMSzwajvPWZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PFHQU4Q6EzjQZZWTznqTGzvkr+cKljt/4NMGIJ9cyrVDvMrmI6qOmyhD7E70zCrxW5y0RcSXOpmQwMcRQWcwU0cX0S27TO0/9M2WD+5NcJezqyjwvOKoBNF2d9bahJ0oZF+xACn/1MmLg7FPzBiv9pZuT18XeqgGvBbMnQYN92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cenIg3hz; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cenIg3hz"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-748d982e97cso1670604b3a.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 00:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752824828; x=1753429628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nL9QmwKQL3LVMymQaCdvoqLZJn4gowlC60ql62f+mG8=;
        b=cenIg3hzHt+2InhglsXOYkp4QPU5Khhs1Rhgl1NedPdJiBiXUgKuUmDwHAtrN+q7r1
         eCupDlcp3e5diU8wx/rDl9ahQbMGaw2D5HF8tTwt/Vf8LG41RlqENTDjbeBOmIVNicvR
         WvQmynsHA24iXhGSiEQRUnslpBM54x8Ey1dZEOTnBJrblptvZ0/Pnkah9eV3snwS2MoG
         F7Qdod5QgtBnL8ev39FAk6C9vygCp3YxNlzf2Fb//0jFzpnfx1m/ciaeFoTw3JwmjrJQ
         qBVsVckfG3vBrDI1JujszlRuDlydtzALvwgngss1ei7lTdh3Wi45BRz36ALDV6z3vf36
         Cr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752824828; x=1753429628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nL9QmwKQL3LVMymQaCdvoqLZJn4gowlC60ql62f+mG8=;
        b=g1rhSzUZ0ZnZpQvcMPzEbiAdNWMeJCW+PX9PT+oHhbW/U0T6SpzoaAVcH+b7nRSgGG
         cSPoLkxbJIzAFOvP9lZN+IdBrOKTd1sMhHzzvnEMsv9QalPd0XU7qY5XW8f1hmm4b7Su
         d0wk9JdSluhBMilNWk/ErR3JUTLSZWMGdC9KJoBCI7e8WEDsAF6SwfGPqsSLIeXgX1fb
         Ia/bAnLV0Gz072YK7Q/mVfzcVPfFaHOw7xLn9nWJ/AeBGvQELKu9X38+j5iCL2SPXFrY
         HmYFUDqemu/htPQMAQWyyyhYQJxwaw4/ztRvgCap1lvJLcpMPBHWzqND3XGxoQtHiMyd
         EX5A==
X-Gm-Message-State: AOJu0Yxd2s/kbLcK+yVoDJoypg7FgmSVjDiSPbOeIXOOpUr1t6LBgAJ4
	UFnemLOCR3ywuw/tK7eUSCpvVmei+7c89fAWU5BZqKIGuv2c82cMlRPo0CMJeb29
X-Gm-Gg: ASbGnct9F0pSO0wYIr7cddq6reDCqwjF3T+rDRPJ/8rzSDGjZDfBBk16uCQzORkO/TJ
	Tp1Zu4yfmEEpbaQgoegdqnyx8A/1/O5YwYppqwOO793ZBA3ku6do0H6XyiSmZDQhMvr4wfWeWNv
	jh8FiY5U2PY2y9VdFXtyzqa/wcu+S6qiYfh/jt8cWhFO/mMSzGTwuW6rnelVcA6c+wMUtMsL4qI
	8eIIhN0CTq4S4C3fb3vmyYQPdg1O59lTSW8Zd3My2UsPhkb8FZfDEouuEDuHpyeOsqjWsm4eEro
	AOTKzDk5jG2VH19NNXhBC6FD7PbOS1arIZL09K6S3O4e0idPWx8EraXs3y76nMtyHRygbWBU
X-Google-Smtp-Source: AGHT+IFQO+zpLdCX7IrzvYKCuHHxf9BYPsFJsY6hvL1XMVDBhXdhcCujXsulo1ndZ+jQ2a+03KxYgg==
X-Received: by 2002:a05:6a21:a344:b0:233:b2f8:70e with SMTP id adf61e73a8af0-23812947a1emr14387679637.25.1752824828318;
        Fri, 18 Jul 2025 00:47:08 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c89cf989sm695762b3a.37.2025.07.18.00.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 00:47:07 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Use user_backed_iter instead of iter_is_iovec
Date: Fri, 18 Jul 2025 15:47:03 +0800
Message-ID: <20250718074703.1452422-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ITER_UBUF is also from userspace

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 1f5154d9676b..6fdc477c81af 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -127,7 +127,7 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	 * the dirtying of requests that are internal from the kernel (i.e. from
 	 * loopback), because we'll deadlock on page_lock.
 	 */
-	dio->should_dirty = iter_is_iovec(iter);
+	dio->should_dirty = user_backed_iter(iter);
 
 	blk_start_plug(&plug);
 
-- 
2.48.1

