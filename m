Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9228822F02
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 01:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709085076; cv=none; b=YXP9KoqJgvwjqrizTOoxU/hq7a1emQZKI3faOUf/CjLHD9DmEVI9MD+X/qt118ve9fKAJ5jH+s10Djn1vn79zKFEnFdAjNPvhHtiFXin7eejtlVh2eJHuonENDtsFza2KW81nqD9rkRAp+RpE09GRkLNFuAFCAqBYDIqN8SLtWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709085076; c=relaxed/simple;
	bh=4eF7s7e/k2QRVSrRui8SLb7kYl7DWfypixaWLBxatjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqp1klZYGl4kfAJ/irIB3s55cMcONuQRTTZ2Q6G1+Qtqcr8tt75Zzn5K+nE8cN96lCyu2FYXzQLmrDEHlVrP75ZHXRz9tWM+4W5OOSTUfAxweez1nzH+ACSGBIGWR1OQ0JZIPPYx2UCp3QHuJSY0jMrZxnbDFh6HPqgE6tldQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtH4+m9F; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtH4+m9F"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7bade847536so284054439f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Feb 2024 17:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709085073; x=1709689873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s/de+O1QRsWjBRC2V7KW4gglpAWh2kmwn7hIoH+7yDo=;
        b=FtH4+m9F2Zviyy/AbH5ZNhnsBkr0akdcPKYQzQJXnNoR5oByWnSc6WNpmT9DGoMFTj
         Dbg3iuiY9iKHkEVsn2o5Vqi6yZmLfRUEORMiz/s/2hhW7en8sVJMemp8JPkyrRK567M6
         tpdURDrQgdfcwEjsgklcvmd5HMlq75xrPkqD5gMgayFFi2BcUKxJQ6bGt/7dvGboT/5y
         5IKcFPbJNanQJ48NdSaCFhAXzAlI4qaSJBc4rphPfU7SBQl7MQquS12gk/hHpJc6a8HD
         jkSSQPxS9xCaIGknRhgN78YCDI1xFbeKeySHt4kd/jmTad4dF0xRr67waYfHAc/rtqje
         Ez6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709085073; x=1709689873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/de+O1QRsWjBRC2V7KW4gglpAWh2kmwn7hIoH+7yDo=;
        b=rC5UqZZqhQ21mcXxkINkw/Ao8vabCk9nSQ4TS5dMgPe1E+0C8jrG7zKpKB32mr2gXo
         peh+K5DfVHoMN//LXtBlpoVKCtM7HurX9c8hmN3nxzrxL4NwN2IvOqEdflMh4w6qdBZt
         7g9qmdz/e3covShKJ62JDLErTYHJrEI896VzPA7IsXQLDKZNIGTJNdA7NsjEMToSBROO
         mQIAXotWps/90hmzHfY4gWWNn2rCeTlkUAKumSr9ByRO8McQ+yrODu0eHcy15nbvdKm/
         oqjkqggSnhxvEZAFuyD+5+fgGNRgF4y/e70+bkWH/mGohjegWw0GK+JBv1seNE7El+o7
         f/lA==
X-Forwarded-Encrypted: i=1; AJvYcCV20gKYRUEgBymr8p9rgChsApke8segui+Hk3/jxLzCjUeKl5IBBSw+/clyv+755pymxqDWu5wLGrI9N3/4DBI/7cBlcE5EJxswx2AUiTU=
X-Gm-Message-State: AOJu0Yxb4QdJvyN4eY0M0Wxywnb+XwgON3EKsHVFT+Ri/HlIyN3kL5ii
	oMo93C897cfEyYo9+o907vDYfQ4tn055unp3nc7EQfSmT4cnqQwD
X-Google-Smtp-Source: AGHT+IEReYi3Dy7vOt0KTHxXLAEyQXCAvrOPUwMvCnZsDZVNFCB9MSmaaqCt2SVmff3tmhi/dEElOg==
X-Received: by 2002:a05:6602:1231:b0:7c7:e8fa:ff2d with SMTP id z17-20020a056602123100b007c7e8faff2dmr3473537iot.3.1709085073459;
        Tue, 27 Feb 2024 17:51:13 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id c21-20020a02c9d5000000b00473c5fe7571sm2040923jap.161.2024.02.27.17.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 17:51:12 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] add Makefile target for Rust bch_bindgen tests
Date: Tue, 27 Feb 2024 18:50:09 -0700
Message-ID: <20240228015009.83502-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use:

$ make rust_tests
or
$ make tests

to run the bindgen tests.

Currently there are no Rust tests under src/. However, if any are added,
they can be added to this Make target.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 37101af..395a526 100644
--- a/Makefile
+++ b/Makefile
@@ -153,7 +153,11 @@ debug: CFLAGS+=-Werror -DCONFIG_BCACHEFS_DEBUG=y -DCONFIG_VALGRIND=y
 debug: bcachefs
 
 .PHONY: tests
-tests: tests/test_helper
+tests: tests/test_helper rust_tests
+
+rust_tests:
+	$(Q)$(CARGO) test -p bch_bindgen
+
 
 .PHONY: TAGS tags
 TAGS:
-- 
2.43.0

