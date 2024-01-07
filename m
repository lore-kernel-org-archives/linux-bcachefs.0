Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B4612B61
	for <linux-bcachefs@vger.kernel.org>; Sun,  7 Jan 2024 07:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V8WdNvDK"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a28da6285c1so156425866b.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 06 Jan 2024 23:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704611173; x=1705215973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=89X4x1fBEoXou95U9ccfplIG157jG38y+Fo99Sr18NM=;
        b=V8WdNvDKJvkXC0fcA7kPwg6nasUPMJ+Hp8wp1A/LzRAvqSU8497zDkmyL85iTU7ak3
         oh9oOnqXCKvmFV4EtoPxNEL6bPiYbro8XmC6owmWrZggYEe0wn+uAUkM+aJ69tPPyXlA
         q6R5PdhDQ7DwRgNH+lY/BzIpaQvjE7l6a6lKLr8gEgNYRqD0v8ony3SwQX7odsklMYZR
         2ZdQg/YIrh6eqip/9hTVLENW9PcN8Uud60Oy4zTn0mu4VCxPFBftxWcw3Wfkwy/OwB30
         WR0J6svbCBb4RL/C1QdIBcGdZ5iXSuLgo9vw/AVZ1CZc8xTTGB+TVnPAHNI5+J7kYl87
         JwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704611173; x=1705215973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89X4x1fBEoXou95U9ccfplIG157jG38y+Fo99Sr18NM=;
        b=rhgB5K/2VA12LDwN19ATq9k/HTYlnSlUKx3uB2fgaX0rBbKmFqr62n3sm9iYrEYBnt
         lql1AXDrO5kWrhJp0LTStFymvdKvxjTAX0NYfK5FJQlMD4q9iskmBhJYALeI+DXffAfi
         mW5a7dve+hFulXiLQ+3i1RT5Ye+qEVleImIPoDscGIVALoKpyHvZ4nhdxIwXYALRBn5j
         xHVsNTb2LuJ9ISaYg86xYthpMyNeSY19jVt/v1WrqSi67e39YRQ4tKhje+qUB+h6Fl0u
         FSOfsAPFfW5/B1Q+zY8pJLM31EopDL7NShICMxAl7FSe1YUhRjbqeDWIIisO7K+GfjbO
         dK+w==
X-Gm-Message-State: AOJu0YzfNR0s5ZJGDN5pBg2kKqtZ38Aclw2+G842cXeqA2v+/DOFsQy1
	ZmPx50FjgmmQdO/CTTjQSBJrtK0/AuLfKR69f98jY/USu6alWg==
X-Google-Smtp-Source: AGHT+IGe5IJXbE30ZRGolun/kx8tjy3yyPm7p3AHjFbwVk+dKDseYHkwHPYlM3AID6N2LqsNOMH8wg==
X-Received: by 2002:a17:906:1c08:b0:a28:d309:549a with SMTP id k8-20020a1709061c0800b00a28d309549amr4605196ejg.18.1704611172738;
        Sat, 06 Jan 2024 23:06:12 -0800 (PST)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b001d33e6521b9sm3988714plz.14.2024.01.06.23.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jan 2024 23:06:12 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-bcachefs@vger.kernel.org
Cc: l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] bcachefs: fix memleak in bch2_split_devs
Date: Sun,  7 Jan 2024 15:05:59 +0800
Message-ID: <20240107070559.1097718-1-glass.su@suse.com>
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

Fix it by copying pointer dev_name at beginning then freeing the copied
pointer at end.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/bcachefs/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index c2ef7cddaa4f..789953c14f55 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -1186,7 +1186,9 @@ int bch2_split_devs(const char *_dev_name, darray_str *ret)
 {
 	darray_init(ret);
 
-	char *dev_name = kstrdup(_dev_name, GFP_KERNEL), *s = dev_name;
+	char *dev_name = kstrdup(_dev_name, GFP_KERNEL);
+	char *s = dev_name, *orig = dev_name;
+
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

