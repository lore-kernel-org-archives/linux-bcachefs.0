Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A41B610B;
	Thu, 21 Aug 2025 00:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755737202; cv=none; b=JJ9r8YXG/Lm9v9s6vJIGAwBz5EyIYDPctPY974W2t9BbXY55EzrbDEkhdahRzPkcJU3yxT+fExbSkw9HmSGsEbyRc92FAQnhnX3Pq1Vr3rA7K8sMHUfm6YiNz5o1YOHd7O6zuBX6G4vbdPilMxeexUsVTNIctXbkZhBgTBsdTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755737202; c=relaxed/simple;
	bh=ZYe5JE5AzYcba781Xa+Tyj5qUu469y8s0aRLOaLmMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qz9YyLWrPT76Z08oKjA+RBCL+sfq/lZjAloO0nR8UiLks8/Bb18xAkasMAb8f4+W5huaU7Jqxbr5quJHOenwWhn/sZD4Gy5IqXlYL1exqQ8gicrhbyTwFUjLrT7fOq0109Y1WMxbH78ZThDoYTZfSBqz9i6h2NLS3VvD4lWgVc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kYLLNtjG; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYLLNtjG"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b476cfc2670so266359a12.3;
        Wed, 20 Aug 2025 17:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755737201; x=1756342001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kMVT+kKZTHe2OyEbS0gfrhGsxk3Z5Axh7St6QKerpQg=;
        b=kYLLNtjGH3j4FCOsq5zsAXHtOoPD5q/+ss50m3nTZ2foM/TSChBAn2yQJ9FwySYrGr
         2Fz2lF8W7FACuHyF9I4zTCUJjiO61xR00o65pJnFCJ3us0PA6R3M+FQp23JPI+/f36KP
         O6vUtSrd68mxDFUPquxKcqYDjAEsgD5PtYA9Izi+TgIIoBqUqCyRAYYNRmBOrfMf8iDw
         7HFqcxLSKaM/27I+pUswGQHEglU1zckyzpGvTwz8UheGh23sVY0CV5XEV4ozkUzWQuvf
         yV7WtgvcJhOYmAxKE52za3BhYtg+EWayQ6/VIT1EJYMjsJkEORzPpcLSmPYa1vCFlqzS
         PtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755737201; x=1756342001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMVT+kKZTHe2OyEbS0gfrhGsxk3Z5Axh7St6QKerpQg=;
        b=U6ng+ParioBoUrpQXZYApgpDyDkVUgq/OqMJJAbXd7ZGYWFsoE15V6sRtYolOp7MPZ
         2PXLYTaJXaaFWuC9HRMjRw/pj8oujaAJEVgamvmj/vY1vdrecpYrd0gcoYPae75zAPIK
         EiaSzczietew9T2bEvJdqjh5+KtD3wLNo7f+fbEb1o8PWIWvj6WJ/5yZgR9KoQTHAaOB
         h2mhuxvSrT/sLzaYyrEdoVC7jGLHH2UPCxRTK0OW/0BgrktLdc5Axu5LE3i+h7BXsXwW
         Gofi3Fy4/C3AcIG8S3Z0DYvGt21Ib5hanagiwggwGrHXRq/Ee+QxnfECrjK7UI9stm4R
         /5jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbSPDK3ukwdje3q8CQwhiEBNtrSoH5bR6L298Las4I/EUmXh1BcE22jYSpPCcHVqPbLWMLI74bOGsV1GR3mQ==@vger.kernel.org, AJvYcCWqvSOcRgCyV1Uomkp7SxKEqof+C6JneVkYOgqV/tPsiTeVVWU4wHays2zuS2Qn/HkWBtbGVHGxeyOx@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe4+9llmf52wnT95/3pywNmECq4xzQkh1NkSWHuXHLRsCxPdBd
	LeO23rUkZQ6eX1r5CDVcnSSenefK03dno8K3YeXAXRQSPRxkeYGK4YGi
X-Gm-Gg: ASbGnctL7jEgZUESCxnGKQnqDoGu6cxEWCTQxvNBLDDVZ+tP8oOBRV6ytPNifBAbhZe
	/gv69sFMnNmc0Z07vIa0fj2VFPqPkIiRmfkhkJsOIuGD6JxnFH1dQKOo5xcEmX3EC3naWrKYSYw
	6fZX3iq55a3oa0R3VQHyXvjHSzt3QkU6/eLMTjduiVSjUwZJQt/NENvU74P0CqwKQKfe+xMXGaZ
	bZcFwtde4X/JaCQ486IYqVMy2fchajWaf3MispxHITGHIwkQsBt0vM8BnvD+5GB0QdxiUc8XEZp
	qVxcuUIZ/bv5yQFHj3MlhAKN8hAQN2Awp6EANxSl4UXWWS5PGasA17liMJJjhN41hF1ZoRVJd+P
	0sRpt//4LjkPSkCXGM6tGNA==
X-Google-Smtp-Source: AGHT+IG5X1O4EUAyYLH751+5LmCK1uRJZoilG8Hq5W9rsLq9nVtEeldXX2hkyouM0xAPeeSn9g8YEw==
X-Received: by 2002:a17:902:ce12:b0:240:981d:a4f5 with SMTP id d9443c01a7336-245fedb8cdamr8288585ad.42.1755737200526;
        Wed, 20 Aug 2025 17:46:40 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed35a632sm38471705ad.38.2025.08.20.17.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 17:46:39 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 8A083419B2BE; Thu, 21 Aug 2025 07:46:37 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2] Documentation: bcachefs: Add explicit title for idle work design doc
Date: Thu, 21 Aug 2025 07:46:21 +0700
Message-ID: <20250821004620.10772-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1368; i=bagasdotme@gmail.com; h=from:subject; bh=ZYe5JE5AzYcba781Xa+Tyj5qUu469y8s0aRLOaLmMDw=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnLskueXZ7H6PBuxYnd30onX2+beivsVOBDxQXrTLh6O m5d9NzJ31HKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJzLvKyDBFrWtmQPLWT42t 8QpfQyS2TZh4OmrSIdZ4ZY69jZ/8DTsYGdYVm8sbTD9xZb7Ing3BryWDbj+ZKFG2j9U/TVT2mJl nNh8A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Commit 9e260e4590e044 ("docs: bcachefs: idle work scheduling design
doc") adds design doc for idle work scheduling, but misses explicit
title heading, causing its two section headings to be toctree entries
instead.

Add the title.

Fixes: 9e260e4590e0 ("docs: bcachefs: idle work scheduling design doc")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
Changes since v1 [1]:

  * Keep original "design doc" title (Kent)

[1]: https://lore.kernel.org/linux-doc/20250820002218.11547-1-bagasdotme@gmail.com/

 Documentation/filesystems/bcachefs/future/idle_work.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd97..8519fdcaa5ff49 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -1,4 +1,5 @@
-Idle/background work classes design doc:
+Idle/background work classes design doc
+=======================================
 
 Right now, our behaviour at idle isn't ideal, it was designed for servers that
 would be under sustained load, to keep pending work at a "medium" level, to

base-commit: 37c52167b007d9d0bb8c5ed53dd6efc4969a1356
-- 
An old man doll... just what I always wanted! - Clara

