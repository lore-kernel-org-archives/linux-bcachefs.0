Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCB731A93
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Feb 2024 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707486103; cv=none; b=twwApG1RNldHtu0WNhW4Au8QpEd4YuQwaxNSQG88uzAOq+EYU6ESwa4UMkXAaEQ5B3eqGFoUmhN8Js8dHEPF3RM1rzWzLRnP8I+IOah4ndlCx5ji+HnclTiahhxCGzQmD9c5sq0PiHzsAFZkjvbn+7330VRYJSHYQKdKYpKDNQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707486103; c=relaxed/simple;
	bh=NJSa8a/suSd16sg2eYmg5GGEftWnhhP2M6h66bkrzgE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n9GSICq8XXxLIV2TxpRDViHNVCKQXzQurhA1DytGGSk+guS6VHEj3W8U7eiC+FQg8U3tP5ow1bpGoKxKt/AGM7k+YE+lKW9ngEb3zGY5e3alraN5srY7ewncVMMKaybrst4b63edeU2d1O3w1rW0rJdO1eoIiQK6mJd2GxSwwIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gLfjYpSf; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gLfjYpSf"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5116588189aso1710314e87.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Feb 2024 05:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707486099; x=1708090899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MT3ZD9IC3aiM+RUq4QPFHgXYQjKg6Utpqfo/CQiv+2M=;
        b=gLfjYpSfv5T+Mr/dBUKWlcpWrGpy7NICswiHwUBNOe436HdsJiYQtfbiTazanPyXZa
         VoD02gn+WHsDrvNKNzg+ZT9txIO6T9NbDfllcGw17eq+VXqA6csptwcly+h3dNsuR1nv
         qBGok3ZOFnKbkMWpoAxrlvRM5nejTOocErqC+5i+W8vg9WLoNsb82lCNkJ3YSlkk5UYq
         Yv0Pb7Vbgmg/UamVjRf0eVw//1oc2ij83E8Tug2639ZmcWL/irWIQuXIRNIgQSJcE3R8
         VpyXgTXp4RU/ygDY8O2cz005qGI9dS6RLIaYV9TXCqHbmEhSKfGW+l23iQmtZK7IjWZE
         4ieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707486099; x=1708090899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MT3ZD9IC3aiM+RUq4QPFHgXYQjKg6Utpqfo/CQiv+2M=;
        b=w6DTCwf2E24qjR5fb9B1MvtwpbezXTmRdZieo2eow0ckITvc93oDssoGEepjbTWy8P
         XLgC6dh6rCuuAy/unYLtIz1gwmg/ZquxnHUhNel1KKQgGHp99eabQS98sLFL6IASRHhY
         z6xUX7LWTqUiF7llCcpk/xmAHXdMdlm8y7w+ZeOW0vfrqpFAdlfxbvRkJCJXimQEBdA7
         DsGVTXcUS50Bn7OYw038b8YG8/d2re+vvgVy/KxWWSdgfM8QQmSPaE0yG55IJtr5AIlL
         nxLKgkKS642amna5mC9j8zVL1XvIcaayjdTgVVorzURaRiWTXHzSW40cl66sTGOSvvt0
         PqiA==
X-Gm-Message-State: AOJu0Yz+xAeeuhTr3QoSNk6D+GIvy8MVFUqPH/hbPuTkaWC+tC9QaSFD
	+RUhTXKETult83IS0cynfIdujLAiGYAMhuJhny8m+Sh+6N6v2eTPRpidMLVfMCPgFlq+4wjNm1/
	KqVQ=
X-Google-Smtp-Source: AGHT+IFzw2pc2SW0ru/DKvwYvC+fITRQ7QxSoPiV9rb1COYmDqICMjxn0g/Ql8fDmPJ75C0iXCHdnA==
X-Received: by 2002:a05:651c:2114:b0:2d0:d609:d2 with SMTP id a20-20020a05651c211400b002d0d60900d2mr1574616ljq.5.1707486098819;
        Fri, 09 Feb 2024 05:41:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUySGkCBZaLK03TSxA5ywkvmGlChWaM36lggfxLCzXg/ftM8vgrmEaKrUuP/SgkM6onT3zRIHJ/dloDQitYfvdf3w==
Received: from localhost.localdomain ([2406:4440:0:105::28:a])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090b018900b00296cd82ac91sm1746130pjs.1.2024.02.09.05.41.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Feb 2024 05:41:38 -0800 (PST)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: linux-bcachefs@vger.kernel.org
Cc: l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] bcachefs: fix kmemleak in __bch2_read_super error handling path
Date: Fri,  9 Feb 2024 21:41:31 +0800
Message-Id: <20240209134131.50597-1-l@damenly.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

During xfstest tests, there are some kmemleak reports e.g. generic/051 with
if USE_KMEMLEAK=yes:

====================================================================
EXPERIMENTAL kmemleak reported some memory leaks!  Due to the way kmemleak
works, the leak might be from an earlier test, or something totally unrelated.
unreferenced object 0xffff9ef905aaf778 (size 8):
  comm "mount.bcachefs", pid 169844, jiffies 4295281209 (age 87.040s)
  hex dump (first 8 bytes):
    a5 cc cc cc cc cc cc cc                          ........
  backtrace:
    [<ffffffff87fd9a43>] __kmem_cache_alloc_node+0x1f3/0x2c0
    [<ffffffff87f49b66>] kmalloc_trace+0x26/0xb0
    [<ffffffffc0a3fefe>] __bch2_read_super+0xfe/0x4e0 [bcachefs]
    [<ffffffffc0a3ad22>] bch2_fs_open+0x262/0x1710 [bcachefs]
    [<ffffffffc09c9e24>] bch2_mount+0x4c4/0x640 [bcachefs]
    [<ffffffff88080c90>] legacy_get_tree+0x30/0x60
    [<ffffffff8802c748>] vfs_get_tree+0x28/0xf0
    [<ffffffff88061fe5>] path_mount+0x475/0xb60
    [<ffffffff880627e5>] __x64_sys_mount+0x105/0x140
    [<ffffffff88932642>] do_syscall_64+0x42/0xf0
    [<ffffffff88a000e6>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
unreferenced object 0xffff9ef96cdc4fc0 (size 32):
  comm "mount.bcachefs", pid 169844, jiffies 4295281209 (age 87.040s)
  hex dump (first 32 bytes):
    2f 64 65 76 2f 6d 61 70 70 65 72 2f 74 65 73 74  /dev/mapper/test
    2d 31 00 cc cc cc cc cc cc cc cc cc cc cc cc cc  -1..............
  backtrace:
    [<ffffffff87fd9a43>] __kmem_cache_alloc_node+0x1f3/0x2c0
    [<ffffffff87f4a081>] __kmalloc_node_track_caller+0x51/0x150
    [<ffffffff87f3adc2>] kstrdup+0x32/0x60
    [<ffffffffc0a3ff1a>] __bch2_read_super+0x11a/0x4e0 [bcachefs]
    [<ffffffffc0a3ad22>] bch2_fs_open+0x262/0x1710 [bcachefs]
    [<ffffffffc09c9e24>] bch2_mount+0x4c4/0x640 [bcachefs]
    [<ffffffff88080c90>] legacy_get_tree+0x30/0x60
    [<ffffffff8802c748>] vfs_get_tree+0x28/0xf0
    [<ffffffff88061fe5>] path_mount+0x475/0xb60
    [<ffffffff880627e5>] __x64_sys_mount+0x105/0x140
    [<ffffffff88932642>] do_syscall_64+0x42/0xf0
    [<ffffffff88a000e6>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
====================================================================

The leak happens if bdev_open_by_path() failed to open a block device
then it goes label 'out' directly without call of bch2_free_super().

Fix it by going to label 'err' instead of 'out' if bdev_open_by_path()
fails.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/bcachefs/super-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index d60c7d27a047..36988add581f 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -717,7 +717,7 @@ static int __bch2_read_super(const char *path, struct bch_opts *opts,
 
 	if (IS_ERR(sb->bdev_handle)) {
 		ret = PTR_ERR(sb->bdev_handle);
-		goto out;
+		goto err;
 	}
 	sb->bdev = sb->bdev_handle->bdev;
 
-- 
2.43.0

