Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612E4A99F
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 15:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PoQ8nHVc"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cceb5f0918so19299251fa.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 08 Jan 2024 07:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704726683; x=1705331483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iSRS8x1aQBCQcDoDR5zt0viDjnQuHB921DQcwEw1so=;
        b=PoQ8nHVcMoZTqC65MjGSDok2zNFEP2wcone6xRx/JnZ93lAwMeEHWIlNY0ISx8Akk2
         i10nUOV5afu6GEpBdxfoh6rXvvxLI/IrUMryIyLKBgmHdzdVPEGxgy41F8GC0aM+CqNx
         AdDitC1u7LJrXeomDMtJNV0letzBpe/70kTGX59lqhVQ43xQH0Nc68F17aSE+Q2iOf0r
         o7jdTCZ+auyur9Fy7MQ8GbeT2PiPfg/fAlDQBGGYoykyvqNRjiMRiYlCeJkevlb+Ao6c
         /DrM1PjZtgTSLET6EoGrldnNoE9uhgJ6jJA4I9YUXdq32zOvb1Ih60VmuHCOuLPFFR26
         TK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704726683; x=1705331483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5iSRS8x1aQBCQcDoDR5zt0viDjnQuHB921DQcwEw1so=;
        b=tGtHT0BkuJSwudxkvEPBJuHGrs6xJ4rOMS6zQq6gEvBAlw56lHJRZ6oY0k7zw52PdL
         HOiE4lYMd62esfPunkXESu1gr9jWMHDiNdBzcMOs4FfBe4iRrlOrhhlp0R4cGVSbyxo+
         pIw44cZ/bnzpK9B/LN8pUrqNellhlqtc+pJAMLCZfWG8Q7l276ibxM+6ZhEA5S4HhOi9
         WYnKKCzXpRtaoyjGSmtBDVZgEsSbRAe5BT/nD92DqWoadCcWbbb8L8yMcDBXxUDcTQqm
         OkRiFlKl5AWSj6OcyD02Q+F3DeUyfBjp2PKQALFIqlGGgEN9bTssY0FeuvCF/yJpV3dN
         OiNA==
X-Gm-Message-State: AOJu0YzRH2tMj07BiVke+6s+WyQQyeeIicFuAPZOXl6T3pBDKl0ik+Pf
	ejdyLEGqwDbB07CNTjHdbxZCXmUsY/oqbawSnEiPT3NRhsWN4Q==
X-Google-Smtp-Source: AGHT+IHxJ8urxl3wpiI2jaLGOQTjbhm6OK9zcEfJyZRrolVR2r95X26O11/PEqMdB8R8DpMAVn1uzg==
X-Received: by 2002:a05:651c:19a7:b0:2cc:6b08:77ee with SMTP id bx39-20020a05651c19a700b002cc6b0877eemr1201169ljb.88.1704726682769;
        Mon, 08 Jan 2024 07:11:22 -0800 (PST)
Received: from localhost.localdomain ([154.21.80.13])
        by smtp.gmail.com with ESMTPSA id o12-20020a17090ab88c00b0028b845f2890sm6406810pjr.33.2024.01.08.07.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 07:11:22 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-bcachefs@vger.kernel.org
Cc: l@damenly.org,
	bfoster@redhat.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3] bcachefs: fix memleak in bch2_split_devs
Date: Mon,  8 Jan 2024 23:11:08 +0800
Message-ID: <20240108151108.1115630-1-glass.su@suse.com>
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

unreferenced object 0xffff9d08a2916c80 (size 32):
  comm "mount.bcachefs", pid 9090, jiffies 4295856224 (age 17.564s)
  hex dump (first 32 bytes):
    2f 64 65 76 2f 6d 61 70 70 65 72 2f 74 65 73 74  /dev/mapper/test
    2d 30 00 00 00 00 00 00 00 00 00 00 00 00 00 00  -0..............
  backtrace:
    [<00000000c5d3be7d>] __kmem_cache_alloc_node+0x1f3/0x2c0
    [<0000000052215d26>] __kmalloc_node_track_caller+0x51/0x150
    [<0000000069fea956>] kstrdup+0x32/0x60
    [<000000000877fcf1>] bch2_split_devs+0x3f/0x150 [bcachefs]
    [<000000007ee93204>] bch2_mount+0xcb/0x640 [bcachefs]
    [<000000002dd1e04b>] legacy_get_tree+0x30/0x60
    [<000000006afc31d3>] vfs_get_tree+0x28/0xf0
    [<000000007b0c538e>] path_mount+0x475/0xb60
    [<0000000092de5882>] __x64_sys_mount+0x105/0x140
    [<0000000054fc05d8>] do_syscall_64+0x42/0xf0
    [<00000000df584910>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

Fix it by copy pointer dev_name at beginning and free the copied
pointer at end.

Signed-off-by: Su Yue <glass.su@suse.com>
---
changelog:
v3:
    Add the missing the memleak report.
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

