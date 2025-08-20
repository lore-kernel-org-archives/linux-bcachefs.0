Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14035335A;
	Wed, 20 Aug 2025 00:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649346; cv=none; b=YHP9MdwaLPEk/C1pRNSmONExn/3oZ5npSHuWSG6ndPU56YhPQIAHLsNb5BRCPkB0Rq6qVIZjRTw7XHQaUpGhLSiohLDm7cTrje2V3E+L7rZodox3gvNNTrBebL9iysuoUWEF5i6+uyhv+ELojASlkvD6pdLhoRlk9uPMt/vmJS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649346; c=relaxed/simple;
	bh=j7Bz3dIgbk2hTE3yuiynjMTZ2+JiN+5gdbVmKWsm0Io=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BvH6QaJhAibz/ze+MV1WVEj9jviP3eNUa2wn6fTjSQclwYwkDelx1HMwHGFxDauEjEFqc7jd7pCaP9b68Gbx5P6FKtGlMPRDxFPiflTSQrhk6d3y99CMsKR62AutSG7byLy7OPRbIcQw2i8xWehfYGYcfrv1UqbcD1R4C6M/TPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YpMphjfj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YpMphjfj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b47174beccfso4973499a12.2;
        Tue, 19 Aug 2025 17:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755649345; x=1756254145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kUMKQSR0adkNlOsk3cUF2/sRit4D6/PhtB05yrEpknM=;
        b=YpMphjfj9qqGUGjY72T+jajhT5ZbCKluYPy8fc7AhKx180sePFZfKa28HJi0z9NlOw
         KB2u0Br3Edi/pTm0iQT45lPJIPTnfXm2StX30SbTA4Jl2lOLjL08hSYjEE7uDm10dZLL
         2Em8l5qJaw/iP5gcMscxA415DyGqOnK4711d2szOd48PR4XnHh8bkMPFIhfyVLlbH0JH
         55EPsHLbHQI6+yJ0VJuZEZ2j+T4YRgbJn6JSuoZfJIt4wjrMqb0ZbTscrImIO2vtg4nY
         tRMiir19lovccY89W7lwxGbL/sCY62Tx35LzQwUHfMBnaVcn2EPVPbc+WZwd5PPtcj4a
         1aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755649345; x=1756254145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUMKQSR0adkNlOsk3cUF2/sRit4D6/PhtB05yrEpknM=;
        b=GTvt8tA+9LszezgQxqA6xNCuvCnMwKl3vtn0l7ArXOcLlEdcoepRxNMjkmRie7u9Zg
         7iOvvVKaPSuIlJW1hwS5QZts6ZiVZDfHPoROa3A+3KojN1kIP/0lK7EB7C836ZTVcZKc
         W3bh3hv9AdH36LrKukN1hCKEb/62saaQ9bFvwAUDbZuAabxwrDd7PVCNL0jJp4bb9oQ6
         1ATznjxMx1puBCWbY9w7pLOazAIcrikxmDs3uN4O/wFdxch/D/8TLG0YTj0zmG07WrgZ
         KYVjq1Ef+Yax0k6slNU1knWOhMOdU+fj5axcmo+IhpuQRx/CH1qJYwAxn5HhPgLNKiEO
         iVJw==
X-Forwarded-Encrypted: i=1; AJvYcCVYqfgLYMM4Lluu/Iyo5bTUFR9loVPv5Wu2z9SwF2vPTbujv5SC/8gaBYktWyN5egaJJP/u6cQTYgoftPIQKw==@vger.kernel.org, AJvYcCVz/JxA4xHWAjq054zmH6wNy08mIV+hateyfFh2QvTeMhgjnrCM5Vn5ON12qJqAzizcwAV9m8iT7B2J@vger.kernel.org
X-Gm-Message-State: AOJu0YwqiHaoXFyul19k9O2EJoBF1SCVptArb6PLndb2MEocFOJm0Hhu
	j7UXwAoi/8EOtgSvhx+hMcKqoB1LoQNSKW3IOPqWrVju6AnntzfWskcX
X-Gm-Gg: ASbGncvzfSNnqyKdkVz6kgcUILSgjuitQmC7Mn13S8eHtgRmCZTG3tnw7aAYH3yOmUM
	BIcDTFOedb7+OD5cPaZ0O1LzF5CTzx19QmqT2keWE7FA4F/4y0JOpREaeN1QWLlA8b6RBqxcW4E
	+4Kve/yJKcQSblaGP2Xe17XNTQShscSzbjX9N4BPECv/i1DmYBPP+XVmxiva10bdiVYiUAABxNW
	pbxiLEwBMVckimhaJ+wCavI1Od103S0EXIc+ssKuJeRiSU/biHWr8qtVhSRIyZBQNKTAzH1rfHh
	bHGjKK3X6KUIXYqeN1lUOCcQHFEefSaot9GlAFelSqHwnbbBEeHjDxZ+aqTqSqDEupSiooeOy+C
	9VP0aDpJIFINBBMWd1UxCRg==
X-Google-Smtp-Source: AGHT+IHO1uYik8RTh9jRf+lj6JDz9mcYGFTxMJ5xjUF+G8cp4N9IqEZXF9vPtp1IT8GtGj5iLuVopQ==
X-Received: by 2002:a17:903:11d0:b0:21f:1202:f2f5 with SMTP id d9443c01a7336-245ef0bd650mr11740995ad.8.1755649344557;
        Tue, 19 Aug 2025 17:22:24 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed5244e4sm8713705ad.150.2025.08.19.17.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 17:22:23 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id DD2E74207D08; Wed, 20 Aug 2025 07:22:20 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] Documentation: bcachefs: Add explicit title for idle work design doc
Date: Wed, 20 Aug 2025 07:22:18 +0700
Message-ID: <20250820002218.11547-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=bagasdotme@gmail.com; h=from:subject; bh=j7Bz3dIgbk2hTE3yuiynjMTZ2+JiN+5gdbVmKWsm0Io=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBlLRfZO4dy5//eZ8j8ZR6uPOVWd2zPPa4mVWd25Xpen4 kujI5s3dZSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAilfWMDKfXcT54veG3mGXD 83WS4p1TQ5yy3ioxrJjLPJHzV6rR5tUM//1XVXhoiW9w3D1J6KJL87VuL7PLciaRzCui9zq5B3Y dYAUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Commit 9e260e4590e044 ("docs: bcachefs: idle work scheduling design doc")
adds design doc (desiderata) for idle work scheduling, but missed
explicit title, causing its two section headings to be toctree entries
instead.

Add the title.

Fixes: 9e260e4590e0 ("docs: bcachefs: idle work scheduling design doc")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/future/idle_work.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd97..30f2844c3d9e5e 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -1,4 +1,5 @@
-Idle/background work classes design doc:
+Idle/background work classes desiderata
+=======================================
 
 Right now, our behaviour at idle isn't ideal, it was designed for servers that
 would be under sustained load, to keep pending work at a "medium" level, to

base-commit: 37c52167b007d9d0bb8c5ed53dd6efc4969a1356
-- 
An old man doll... just what I always wanted! - Clara

