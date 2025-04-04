Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991F48633F;
	Fri,  4 Apr 2025 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743730115; cv=none; b=pYYctD9/RTQt4d8EUc0k5fn9xJ0cCPw7QOO/5c4ozEpfmUSc1gp5HW+ILdxu+FfN7g3ERObB2paL2mOpYnvAsio2iMtkh0YcA6psd2Tt6m5J1wtKPKdW46OMISlr6AkWQHaul64GQq1wfce38SxGsjJC998qvaecwSXTyC5S5jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743730115; c=relaxed/simple;
	bh=ThCCTnlJqn1Oa31nv7NfH66Rmv9MGvCR0mQnVerABCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhU8Da6wbO07MD9h7mP7mSHo01ywx0LoiT79sX8eDXt+JwR1Y8lt3CZ0IpKLciklFuZiGk/89KQLeX22dHZSBC9S4Wakkva7K9IrAiALE1jsju3HnZMpacHy5MqVQDbum9sXQpaquW9RzFmX8O9nlhqfCtFUJ4gZXrMyN8iF/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0MZ8A7p; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0MZ8A7p"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c6a59a515aso98070085a.0;
        Thu, 03 Apr 2025 18:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743730112; x=1744334912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR5kIA+uWi4HUBvVSoOD2MczBGVAng4z2Yfd3q51pFs=;
        b=k0MZ8A7pi5a5TBnoCRmr4gtveDiPsMkJq8uI7mGANJq6/4okfOq5VJOPv/E/hiMUbS
         nPjUU0YM9kVCXCvpcnXjyuItxzfZSpo2DgEABIDMzYIaWE4Ue66HaGR1fjRGtt8r1tE/
         X54BOcIkzrYcN35ecI1EDpYI7zTFDG5FOGtyvXyHVN+/2yn6mRb4FzNLLdqxuYLT3In2
         bg4ak9uCDu/BM1wq/LNZxQc/tuKYMXKU0KovqMZwsmXDPzY+KHsnk6KO7rqar4kfi4k0
         xAEr4v6fPHWUuAOIstyK5Gx+zWE18IhZs+MaYGey/dTe5o6wU8jx4ammfdvx77U+rg89
         Op4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743730112; x=1744334912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR5kIA+uWi4HUBvVSoOD2MczBGVAng4z2Yfd3q51pFs=;
        b=lMC036s4wbXJ39uiuzgU6CjCe91xE35mhSG+lD2+3TrLJpjkHJU+nvaZ5tDtNy6erO
         1G0HIk366hEZMPRwQZJxv+U8NSbWoqdTvbvwx6wihPF4obxNBqRFfr43n6P1sFwOkCi7
         UD0jSWFpa3WWxgte7fcuTCf45dwMXQS/v1sKx1ounj/MJVf4cYPJXl8QAPFX9eH481Yh
         K0bFbDNzo1uYMkceWb85AuSofuWFSCd0d2MLdP95/IIu3ZN9Izog74Fsq3Xb1eOoDQSU
         76eAfKlwfv3FXmEb+4uAP/uBvXOMOI3NjpX1++JqL67pUG7wF4kFXDTnKteDxh5SIevC
         yzjg==
X-Forwarded-Encrypted: i=1; AJvYcCUIhPBLxM4NtRBaverx7YDsadjEQ512JA4BEphA25arAYgyZAvysD2ukESJCXkmIbjpP5F2tLaKEWNgJ4eI3g==@vger.kernel.org, AJvYcCWsFOG2s00zSklEa1EZMogkUazHNZRvQ6Gk/Hy/Q+WV0BuNPaEpSv9cz4EQkvZlS2yggxjHFxoXaP7d0zMd@vger.kernel.org
X-Gm-Message-State: AOJu0YwQXhZMbPowSZ0CeFfm6z36a+tiY5XGl5dwBzxiqLE0GzFLeZfM
	3IWc4LGd3/6Wa/315YHUMgw3Fi0u4KZ9qs97eIK363qPSk8aYhDs
X-Gm-Gg: ASbGncuraicPM6SYTtWNEkCTYhVQP30Ym7I9cqyxWyt8898aj+ts2cJxLSuuG8NJCk7
	OHogWFM6r0Q+cR/Liz/wm9BZQEC1Djk5vVV8EgJt+8cI1KZTaL1hSqeOWm+Jt3lB81Bf3F5r2eq
	cBwqzl7gahLiQ1QEez+NKgBsuD5sdl89scpZG3kOazeeUL5w2tGHsUelQ/oLJiN4w15eCBvcuvu
	EYZP3re8dEbBoVbGht2AHErBk1XjrM/mhsD3J3lU5joPZLF8W2n2+9vr1O7wSzT6qW65Gm7voMo
	KFvv2ScgVM36V4lqCVZBkgKSA62Wdv3xmiU5PK3RXueUDlaxGIP4jw0KOcb9Xfr1LlNojVEsL3d
	J73RgTvSSqEi/GJ2p4qS5yzk=
X-Google-Smtp-Source: AGHT+IHOiCDsx8ydbyTXKh335o3fqUmJOSL2TVK2ugwhL+DPClZKp/ZqRN3CkYK7OcZu0VtvNzqt5w==
X-Received: by 2002:a05:620a:4727:b0:7c5:3e22:616e with SMTP id af79cd13be357-7c775af1552mr137092485a.56.1743730112437;
        Thu, 03 Apr 2025 18:28:32 -0700 (PDT)
Received: from theriatric.mshome.net (c-73-123-232-110.hsd1.ma.comcast.net. [73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea58f95sm147401185a.80.2025.04.03.18.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 18:28:32 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: kent.overstreet@linux.dev
Cc: gshahrouzi@gmail.com,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH 3/3] bcachefs: Use cpu_to_le16 for dirent lengths
Date: Thu,  3 Apr 2025 21:28:22 -0400
Message-ID: <20250404012822.188485-4-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250404012822.188485-1-gshahrouzi@gmail.com>
References: <20250404012822.188485-1-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent incorrect byte ordering for big-endian systems.

Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 fs/bcachefs/dirent.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index d7f9f79318a2..82ea6c437143 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -287,8 +287,8 @@ static void dirent_init_casefolded_name(struct bkey_i_dirent *dirent,
 	EBUG_ON(!dirent->v.d_casefold);
 	EBUG_ON(!cf_name->len);
 
-	dirent->v.d_cf_name_block.d_name_len = name->len;
-	dirent->v.d_cf_name_block.d_cf_name_len = cf_name->len;
+	dirent->v.d_cf_name_block.d_name_len = cpu_to_le16(name->len);
+	dirent->v.d_cf_name_block.d_cf_name_len = cpu_to_le16(cf_name->len);
 	memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
 	memcpy(&dirent->v.d_cf_name_block.d_names[name->len], cf_name->name, cf_name->len);
 	memset(&dirent->v.d_cf_name_block.d_names[name->len + cf_name->len], 0,
-- 
2.43.0

