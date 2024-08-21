Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05614F9DA
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Aug 2024 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724257793; cv=none; b=dqZLfTg4MBAQdWB5784L//H5saf/lfsJSY1BAF307vztjsYE2LmVQmEwUIARpQMt9BTII1bc9zTq7rqh2rCols2Ytn7v/j0ahxlrFciI578zSs3Ep+ENEjK8s+ZNZTWhhs3glDIoM26R87n1Us7bX2G4dMsNc6Fw0KCx2ZjHkMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724257793; c=relaxed/simple;
	bh=+2F3YQaCGLitcTbNdWyuZTbsn8oeYp3wyShw7o+4Dfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b2oFTTf+x3xukih0AZ6hXPtkqcjddVsWKTNBIXrVX7MYN0VNUrfYhdEg1HBo+x3oEKfEJYjulJ67/vSFXGkun45PBVMVpkfSoyw0/PcI92T3FVLlUKLnvtKCU8wIDgNaC/WgjVD+IiLhNEW8YmZ+TOlCLTErx8LQZUb3Nu3wwGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=Dntg5lUS; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="Dntg5lUS"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53345fe848eso176920e87.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 21 Aug 2024 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724257790; x=1724862590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mQiMkF2LHLJ8ofvZ2BWlH/LDX2/cHbFn/G18VRaMIA0=;
        b=Dntg5lUSgD1wAJz+cQ0HICy+qFPjL26LwdcYD0DNIwJMeefaTInW2LCnWEIEI2mz74
         R/S645kfbW3SbXEtXOeI+BHv7L+eznTVFKj4Xraf0JSnCiXRJYE+WdNZfkJGRMCkHjuM
         KYRyCyQ5MwAyrLgZqeHKf8oDmgN1owmaKxgUEdArrAykAil5dOealcVWSzp1O9FgI5aM
         fJBQT0wlAWx7lMkE9VCvjVJfwB2NvjQ7LSGwZizs2ldvTIchDAnM+MyK3Eht9/2T3u3s
         YGuUVEzhG7oXvvRHjqi9ncCIjvPQeecT5uKHd/bg5poF2ncRBRV2pMaFEdG0l0PgyjOP
         AZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724257790; x=1724862590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mQiMkF2LHLJ8ofvZ2BWlH/LDX2/cHbFn/G18VRaMIA0=;
        b=PGozbCSL84glbXtdb6eMEL7LB3LK912+16nq/7NJmwar6CH8Z7NQdAB0DFy0Rkkq/I
         //Ge0YGjcTynC4DAeB/Te1Xi2vFgkLEAx1g8qsnJhiI+4X0q5IUA1Qy7ZMuJYLhKkDTj
         MG819kksj/N4s1md0fzBT7tEvJtUVAMP1+ZxXfOH+/HYAfelpSoSvOUUkuUSBamzWsfA
         05wParaKd9VKTTCo16bO1GEX1/19GWMoRCs8ujqObsJNVg7zkzLJe5lHpMlwn8F5p0EL
         483obu8y85mf6gaKQVKhssf4hDtDVfgKyVp8uMU1GRombudwbGx7LlCWG4gB58vTl/iX
         6HAg==
X-Gm-Message-State: AOJu0Yy4L/cJsnd54gGqa4/4jjcswNFmd/hKhMY47t77vrPlu2eCjHJN
	2pXFxzU3qDk6E6uQ9LtVoXxO+OXoC6piAJe9m6mG0Ydv9wJtEhPbTs/A/azKFM7ZEfuh3XqLxbR
	YmJg=
X-Google-Smtp-Source: AGHT+IFHDSmUWk0dq5DuUAdcENAjlQn2DZw21ZX5ZsRsgXG0sXCieYPYQNvWnKVi23rjGRAUfxcBeA==
X-Received: by 2002:a05:6512:b99:b0:52f:c438:883c with SMTP id 2adb3069b0e04-5334854a5cemr1026987e87.1.1724257789262;
        Wed, 21 Aug 2024 09:29:49 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8678ae3ee8sm105515666b.25.2024.08.21.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 09:29:48 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Annotate struct bucket_array with __counted_by()
Date: Wed, 21 Aug 2024 18:29:22 +0200
Message-ID: <20240821162921.86767-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __counted_by compiler attribute to the flexible array member
bucket to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/buckets_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
index c9698cdf866f..a19460a1bb7c 100644
--- a/fs/bcachefs/buckets_types.h
+++ b/fs/bcachefs/buckets_types.h
@@ -24,7 +24,7 @@ struct bucket_array {
 	u16			first_bucket;
 	size_t			nbuckets;
 	size_t			nbuckets_minus_first;
-	struct bucket		b[];
+	struct bucket		b[] __counted_by(nbuckets);
 };
 
 struct bucket_gens {
-- 
2.46.0

