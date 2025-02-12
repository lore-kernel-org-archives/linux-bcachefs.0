Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C12B9BC
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739354794; cv=none; b=rxoC2jqAiV534JlI0CmjiGoJ2cQAw/AnHWA/AkCV/y1CmyKvee+eFWF2RPNcSbJ8Lmkd72F6TvBR+g/e4DxN2gTeo4GU5TmhH/sk696snhOzMHvSd+TP9BFhiOD21MltxxdGkUhDcfnXEGQLDz6Tj/NvzzFHYIhaydCQCw55RvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739354794; c=relaxed/simple;
	bh=0gz6lpjgL99dEkGUqVi5s5SVPEz/g8gNNHdJcec4Jpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qOOEo+6ZYDuh+86z1RdhBNZg8uubP6aqq8I2X7qG0YO8EUBq/T5W5tJcKhxV5h7ubyL/Nj5QU1AvPic6yp5NbwFR4AKCOsH4vk/G6CCpFtcAkEaDV6TOkopVT74Kpk6cEpaZHelKaT4jEikWCLozNnukt1QfcO1cNNO3O0xHsQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSIydkCj; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSIydkCj"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-471b71421afso3188171cf.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 02:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739354791; x=1739959591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eNTUUB7d70XIWaZfKQSfw7zh5igoQdRPfGQvUc/nQ2w=;
        b=QSIydkCj+CFmGAIZsAsYUKPm1pzw5BBo3CPtkqHrc9evTn/YBok4wjXjVcmmCSJD2p
         jKbn1YOVipvSq9p9OPQLTNJlvj/3W96jW9PKOsGc+WGECSR8brGcv6VEqxGpBGTpI3+L
         wAKQNEHymEU//qN0OOniGhxhnnTmaAb5womQUOAz7Hys/GaRmdKZtsDJLIg99pOJtYGF
         4AGo2OGr/USQENxHeNOXypaBAisL0CS0OwpJuzZE1+BZ8wHVdFSdw/JgPXjWrTuk/+cL
         5KduUWZxUtNXfFKlsEBtvGQRUcAfqVEUhGGP2DV1agU09B6FHm5PTIQP3iDiwC1ZSw2r
         Jl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739354791; x=1739959591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNTUUB7d70XIWaZfKQSfw7zh5igoQdRPfGQvUc/nQ2w=;
        b=YZ0GVQ3tmZ5nxLAkYZEqICX/FBcZRQ6o2JIuzne7wIN3+uxMoiXcXh9k7u8kC0pZXk
         uO4rR8UWtEddnYA+avcOboiIrcGVRx+3f9zDMYEYqAtOWQx2nQS2+HtxogIWpA01APVF
         ayHiRR5I6TrzneeiCJXQVwS67zZQR/CT/X+5PuwcieJit7pIGFGMfkMtcnhcKVfmtYp7
         FgHJHVoXJbKBSPO3E8ECkou14QjhRZ+4kYYFqgRoa+KkCQPa6NP4cYgmBY5Zfh3BHEbj
         ezsPWDxcfgtcPYjsTly6nqNtKRAzxxbvZwBeU29leCyfboZrUS7GvZCBNB2zJtmNj9h0
         Et1w==
X-Gm-Message-State: AOJu0YwrOjLotQbwmUjobwQ+LuAMfYO0L4ZTGL9R3dEWxFGAPEkkSJC9
	/BpDqTA5LH4O69TqFU5Sgb3yADR/JulhN7TrSi6V/NJ8oPxEoSJJ
X-Gm-Gg: ASbGncsU8X3187vDkN43CTLQTvpCNQdGe0/PWGXjdVfINguFiKA8gsf/DcpQRh2AwBA
	Hs6VgLK1Wh0ntC6Q6usibHoR3pwVWBJNT4P6z/kwIvxzhbnlo/kA4OubhPjqKrXNBcisWxfRVo7
	I3lmJUeMO9OB/JiE85jlijADjBUgW/Ra4OwrSKypQbnkR/eORnB91Fi2GoeX2tjnHvChfvlPYA/
	3W1ozgCG9eok9xUqSuk61XrI1LVAJs78KTOu6KVWGbXda0zHAVBKFYrmJqsm6YHEQ==
X-Google-Smtp-Source: AGHT+IEn2aSeA2rKjPhbzX3EARowU4D+3Jz+Ghkd7NaIwg8Wh5vieggYu9WC6kwCZwb7qy8ZZuwWGw==
X-Received: by 2002:a05:6214:4013:b0:6e2:2dd7:1404 with SMTP id 6a1803df08f44-6e46ed77a6dmr38559236d6.3.1739354791493;
        Wed, 12 Feb 2025 02:06:31 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e450ac6932sm57606996d6.70.2025.02.12.02.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 02:06:30 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Use alloc_percpu_gfp to avoid deadlock
Date: Wed, 12 Feb 2025 18:06:25 +0800
Message-ID: <20250212100625.55860-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cycle:

CPU0:			CPU1:
bc->lock		pcpu_alloc_mutex
pcpu_alloc_mutex	bc->lock

Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/six.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 7e7c66a1e1a6..ccdc6d496910 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -873,7 +873,7 @@ void __six_lock_init(struct six_lock *lock, const char *name,
 		 * failure if they wish by checking lock->readers, but generally
 		 * will not want to treat it as an error.
 		 */
-		lock->readers = alloc_percpu(unsigned);
+		lock->readers = alloc_percpu_gfp(unsigned, GFP_NOWAIT|__GFP_NOWARN);
 	}
 #endif
 }
-- 
2.47.0

