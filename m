Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0389B4C3AD
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gRhB0ew5"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2cc7d2c1ff0so21073471fa.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 08 Jan 2024 07:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704726427; x=1705331227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQKPykFi5OQdt1+LPbLULhNF40RQsy+u6Vm55smv85E=;
        b=gRhB0ew5TzkuchqM1loVmG89Ptj36PKM70kefH+0oIBOJ1g37XnuobddyjjC+nJykx
         Tik1WIFha9njPyYF7z70xd7m3pNBt8gjgEBuakOOJyQ75JDAkVPKHqfxsAn0A564+ySc
         uy/sPjbJdiSB0jler+BrA2joACycKuB3LRWVq8BBnSwRBuhyr2ABIe6HnSryZ77Ilt2/
         +Fevo1NGnwh92JH9LlT+iEKXLMkkIgKhA7SWCtv0Cl83w9UDIqcy0h1JQBI+m4dW37f1
         ojK8+PrREBa/uixR12HHGnC95JiZ4DE/mHwnNvZ0WZSwLJKHt1um/vcMav5u5b5Wy9PQ
         RxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704726427; x=1705331227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQKPykFi5OQdt1+LPbLULhNF40RQsy+u6Vm55smv85E=;
        b=Sf2AX1cYjfehoCefMgR0ZhSjq5hWU7xINhx3p4cl0DtFU3LE8ta4OKLn5nVwHBsak6
         SN7IB0YL3tLsoBRQG5l7GWZz55DgUilG8YBNaNBdqsmkgL2Q5qvp+A3XC0geD3lk1YGl
         KoUHXcn0xOcZAaCwmZ2HYyYShuTGzdpSYAEVWMOpGfXoHxEopRDyNwenQiyzIiN+6oMd
         08b6wtkc6XxvFp5BCX9FOMc7ozzwSfNeLydfHT45Z62hGZp/mWgQaq5U7Ko8KjO4wGXJ
         pEPbBf7ciMPSyS68jdD0YzJJllcIUN5WYY/AJ1TWq7PaPnde42YH7aEgcyQ2a2w5LnKZ
         huSA==
X-Gm-Message-State: AOJu0Yy2Q7rzD5/lU8ZNjKO/pXDmyVo6OeOS8CnefdHjLvA8AWwC/oKf
	alM4ceYjgbp3ByTreJRAzLfflAyKXwgJ8FlSxgooeIvDSro=
X-Google-Smtp-Source: AGHT+IF2gmMszBq2aoCCnzcQrhI9OPGyJ8KIMp7KV4F6dEbeBGmWe9vPbRBe6ULEt197DgZ7jxzULA==
X-Received: by 2002:a2e:be89:0:b0:2cd:1366:4aa9 with SMTP id a9-20020a2ebe89000000b002cd13664aa9mr1855949ljr.25.1704726426863;
        Mon, 08 Jan 2024 07:07:06 -0800 (PST)
Received: from localhost.localdomain ([154.21.80.13])
        by smtp.gmail.com with ESMTPSA id h4-20020a635304000000b005c6617b52e6sm5993196pgb.5.2024.01.08.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 07:07:06 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-bcachefs@vger.kernel.org
Cc: l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2] bcachefs: fix memleak in bch2_split_devs
Date: Mon,  8 Jan 2024 23:06:52 +0800
Message-ID: <20240108150652.1115576-1-glass.su@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pointer dev_name can be modified by strseq(),
then causes the memleak:

Fix it by copy pointer dev_name at beginning and free the copied
pointer at end.

Signed-off-by: Su Yue <glass.su@suse.com>
---
changelog:
v2:
    Remove the unnecessary assignment.    
---
 fs/bcachefs/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index c2ef7cddaa4f..f927c8a19e24 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -1186,7 +1186,9 @@ int bch2_split_devs(const char *_dev_name, darray_str *ret)
 {
 	darray_init(ret);
 
-	char *dev_name = kstrdup(_dev_name, GFP_KERNEL), *s = dev_name;
+	char *dev_name, *s, *orig;
+
+	dev_name = orig = kstrdup(_dev_name, GFP_KERNEL);
 	if (!dev_name)
 		return -ENOMEM;
 
@@ -1201,10 +1203,10 @@ int bch2_split_devs(const char *_dev_name, darray_str *ret)
 		}
 	}
 
-	kfree(dev_name);
+	kfree(orig);
 	return 0;
 err:
 	bch2_darray_str_exit(ret);
-	kfree(dev_name);
+	kfree(orig);
 	return -ENOMEM;
 }
-- 
2.43.0

