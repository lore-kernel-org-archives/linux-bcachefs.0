Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B01339B7
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 16:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708014034; cv=none; b=quJCKjyKRV09yKSrQh0OEhXHznO+3bxdlFrWW+Pu9TDyUp3w05KmzgOm5p1RjXCpi8Vf7JM3V5c7pdXqTe3GACRdEWOPaW368+KiJ3FjjuqFw5KDMweDiEcRRTICy1367QGN9J0D4QmOn52WB7MUZ/McyE5J/Cc0qNIeNjyV360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708014034; c=relaxed/simple;
	bh=hufNmaLA94oSy3CoWQYPqGGTJqFstVvdEhOPwarn/h4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lFfBbzzdQTV6m04rT9rDUGtSwiBOIIOrDGb85gf1J3rYEweAE0ZNhdP6kJ+MrkkEkqpOrLRVfFA6J+vp/sjTezKpehbJVSX1G8zzPKIyJ5jvc7v5pCTUptpNB/lRj3BDIsP+OcDGTry2F4lxmebJwldMxE7uK84dJpjJSvMiA9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OHlIyeyf; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OHlIyeyf"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bc332d49f6so48081339f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 08:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708014031; x=1708618831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UWBIRuNIhZE/cH1c05sHTm/42lrmePWRhyTle5Vt0AE=;
        b=OHlIyeyfVu0cqSFyyi32xTttHnorv+yCJ/z3MZHdWXAButnrd0bApx3gdl3RbiGD4v
         jGkLsHwSxCnsrsRLLTwTfQMkF+lapD/XpGKR57jcKdvdF1k7nx1mSi1fJ61400mcgIiM
         UIiLpndlxcdA/u/W1U90ob7wSbEgDQXEvxyHEOrPLPJd2KeAptKAAOiPjdO2pJ1P78/R
         mnYU31AO1Boljx53lEeM9N4vE2lUZQUJ7iA0UYqELbJOEgVWyp1MN4Vj3XEi9iYPyJt1
         5nQZvODIYO4DLssmMHC7t8Wr2xarinZNqLNaeT1WfG44GWyJQuYCuRUZ7+jm201KB5XI
         1uGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708014031; x=1708618831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UWBIRuNIhZE/cH1c05sHTm/42lrmePWRhyTle5Vt0AE=;
        b=ZTH0I/nrfyrTQd9qkwEb5P4lHKCmJ9o12OCLhon7vcyrTfhS6g67jzoKN2BkGxGzcq
         3mtIG5URfGCvVRZHHsMnViE9fgR31r3+7lN0U0CNQHLV+OyR195unwyTUToN60OHD5rn
         1RYzjzW/y90qYZ67JAOMrCah0Qljaa1BkGD9TlAF54Bsb90Hxldxp9v31NXJtUC0B+++
         jhOh6SiuCMQy79xpMXSbQdJbsNnqZOe2QiM+zjbshbLvUvenD5wrEvYIh09eQvfHbrKr
         tLC1HDBdhrhmrqhLi9/u2BlfwDevvrEYSO2mwIE2XH58EtM5WQSYuimmbOPDPx2fdF1l
         csAw==
X-Gm-Message-State: AOJu0YyLhJg6Odneo0givF7e2t49IqplICTT6ZTS/Vjr7jmcWj9cEFxj
	qC1NygSJkXXs7v+ZAv2JQdX2syXjomCdW1VUvnu9TcB8ma09CNXQgQIn41PItf4=
X-Google-Smtp-Source: AGHT+IHc00OrYA95iDwvn/WQXVMdV1sw45dkYV2NdDvmN7Ss+eDIzpS65HvKd65RIlVsX3HEMdcN5Q==
X-Received: by 2002:a5e:9803:0:b0:7c3:fb51:3cfa with SMTP id s3-20020a5e9803000000b007c3fb513cfamr2760711ioj.11.1708014031514;
        Thu, 15 Feb 2024 08:20:31 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id y25-20020a02ce99000000b00473b03983cfsm403298jaq.60.2024.02.15.08.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:20:31 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: omit alignment attribute on big endian struct bkey
Date: Thu, 15 Feb 2024 09:19:57 -0700
Message-ID: <20240215161957.112262-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed for building Rust bindings on big endian architectures
like s390x. Currently this is only done in userspace, but it might
happen in-kernel in the future. When creating a Rust binding for struct
bkey, the "packed" attribute is needed to get a type with the correct
member offsets. However, rustc does not allow types to have both a
"packed" and "align" attribute. Thus, in order to get a Rust type
compatible with the C type, on big endian systems we must omit the
"aligned" attribute in C.

This does not affect the struct's size or member offsets, only its
toplevel alignment, which should be an acceptable impact.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/bcachefs_format.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 1bb24aa73528..fc12efe8f8cd 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -222,7 +222,11 @@ struct bkey {
 
 	__u8		pad[1];
 #endif
-} __packed __aligned(8);
+} __packed
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+__aligned(8)
+#endif
+;
 
 struct bkey_packed {
 	__u64		_data[0];
-- 
2.43.0

