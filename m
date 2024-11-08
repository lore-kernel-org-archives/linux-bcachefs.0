Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E07547F69;
	Fri,  8 Nov 2024 08:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056145; cv=none; b=dLlY9YLDC4z4yyldfmF+7Zjo7sSTOKlGLsZsTZsVwmY2QvdIfJOCjqJ9+GiZj2gdiJn+EzAjhnl8g5NGxM5xcEW5AC/RWHyXhpcO0Cw8RJxw0hZozRnY/qmcyPRvfpmSgtn167LmhpFitVNKLU/OcLQdO99dS3432c+JkZ3JIUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056145; c=relaxed/simple;
	bh=qCdYnwE3cN8KioY3mqOShKqKuq+xMII8nhVVemimPvU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OPWc35poweeIVbF1i6GcNlzbqWJEl5ejxJ3nwr3i3gldF9m9NLJ8ccgOCNp9RDd1oAaKSKnnz49gW2Wp+7HZqShzWBvCAkye1uPH6yW6y+v38o1uYPoWIrsIYGXyYw0MXfVY0/UNjZuPRQ+62OwOwOrFJCev6YfKXozdR/vofPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XE30lCVo; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XE30lCVo"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4315baec69eso17071735e9.2;
        Fri, 08 Nov 2024 00:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731056142; x=1731660942; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7ll/geJQMHA5kDfwuhq+ww/JLtvi2AN1VmrZmHWyaU=;
        b=XE30lCVoFkV5SHYwryIOx8vvmF2pMcqCY5wismNuL17zBoDutr7hFTU8DztcaVfUnc
         C9QtESTGuiPnqZesr4K2X2j3keIvcVc2Ak/QbtKUiV42Fup3w0SoBFcPpp++w1JTqYVw
         4JTxIKidHHzqB485vmQ04PhFCmFZQLw2XJlVviSA0DTmvDrEZynoDFe5tgIvWgo8xClv
         ueNczn2rtNXjsguCNCqkxidhVfyc01AXGCEHNBf2IXUQkbJQFAagEwP3d8z9vdPIkPAX
         3Xszw28oCbjdDa8I2VRkZQtZ09/dw4uHCZAc1SZDhO0So9xXu6GMvJsNQCj5EHaPsmcQ
         2GaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731056142; x=1731660942;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7ll/geJQMHA5kDfwuhq+ww/JLtvi2AN1VmrZmHWyaU=;
        b=LUxjUtUmmzDDUq0sntq9qnHw3E5oGcRMvjSq4m26yM5sKDHmY2lPLsBL0y/ndretn1
         vFtzVx7wJxgefLuhqacRnChmCEoAnQuEhtB+AClosXSsuzrSrO8YdfmqhojEU8I8r2ZX
         +bLpvy7gGNtFmbFTBBe0/ZkPbJWX2WkV35/nTlTH0BRK1IlC1pnXoayToJwvQBaPDrfU
         tBozFUM8gv+mhwerSiRSp2YwIxJEZ2ACrxL8Mjq+MlOKL+8ZkfzgdFd5xdSANWR2KKKK
         4OfKvOzaWRoj5KS2XvpeW3GXfKKFKB2Dz2Rpy9TbBHAURGyIIgftj4YqrfW3zP03xkpv
         S5kg==
X-Forwarded-Encrypted: i=1; AJvYcCXNK/cnyr+zUei0IbBEuPouUjapvN8MiHNURtsBxwZzgwi7OTivqGF8hl/gODL9MVi0O75LnHLv/n9zYO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmkrcGkjonTh7tMsXDqNqnprC1QdGj0CKAL7nyz9zjyXwao1eG
	RkmRDO3rwdmz7YFiZFbsq3QgfSR4wSVic1zSK1ZU0g/bmb+xSEQhN2YWpQ==
X-Google-Smtp-Source: AGHT+IFvNSd5+lsw2IQjc2x1Dfx1YVV08ve34jrI6PxB5s9dK6sMoMDv3QepmG4qr4+CLgcwHFq9DA==
X-Received: by 2002:a05:600c:1c98:b0:426:6edf:6597 with SMTP id 5b1f17b1804b1-432b750a358mr15188485e9.19.1731056142333;
        Fri, 08 Nov 2024 00:55:42 -0800 (PST)
Received: from [192.168.1.161] ([2a01:e34:ec0c:62c0:43a8:cbf6:d53f:a443])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed97071esm3911206f8f.12.2024.11.08.00.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 00:55:41 -0800 (PST)
From: Gabriel de Perthuis <g2p.code@gmail.com>
Date: Fri, 08 Nov 2024 08:55:15 +0000
Subject: [PATCH] bcachefs: Remove an unused label
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241108-build-fix-v1-1-ce159b306875@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPPRLWcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDQwML3aTSzJwU3bTMCt1kI0tjw2QjI2NTM3MloPqColSgMNis6NjaWgC
 q0VAAWwAAAA==
X-Change-ID: 20241108-build-fix-c2931c223567
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Gabriel de Perthuis <g2p.code@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731056141; l=1174;
 i=g2p.code@gmail.com; s=20240226; h=from:subject:message-id;
 bh=qCdYnwE3cN8KioY3mqOShKqKuq+xMII8nhVVemimPvU=;
 b=D0Jin2JwMfE5+HmtXDqcBS9DraxqyvKmo0K6a75A09jDmE8FUcyrp5HTxhBHVErCuuRlT305g
 rC8ClH/L8GXB9fJ0mw3PmkheSSsrcLwdtyqPlYlHuUYn52QiM5n54AJ
X-Developer-Key: i=g2p.code@gmail.com; a=ed25519;
 pk=iNCUUSsYvx8i030j8RjSUXbvD9xNTnyXfNZ/i7Y+cQk=

Trivial fix for an issue that triggered -Werror.

fs/bcachefs/btree_io.c: In function ‘validate_bset’:
fs/bcachefs/btree_io.c:828:1: error: label ‘out’ defined but not used [-Werror=unused-label]
  828 | out:
      | ^~~
cc1: all warnings being treated as errors

Fixes: a78c8274ea0c7ebccf2474a9c2e4a15cead79295 ("bcachefs: Fix validate_bset() repair path")

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 fs/bcachefs/btree_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index b8c723d61283891bc789dc39056a44c7dc8d0d67..839d68802e4268ff500af0ee6b0029dcf77d3313 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -824,11 +824,10 @@ static int validate_bset(struct bch_fs *c, struct bch_dev *ca,
 
 		compat_bformat(b->c.level, b->c.btree_id, version,
 			       BSET_BIG_ENDIAN(i), write,
 			       &bn->format);
 	}
-out:
 fsck_err:
 	printbuf_exit(&buf2);
 	printbuf_exit(&buf1);
 	return ret;
 }

---
base-commit: a78c8274ea0c7ebccf2474a9c2e4a15cead79295
change-id: 20241108-build-fix-c2931c223567

Best regards,
-- 
Gabriel de Perthuis

