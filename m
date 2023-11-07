Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92AEAD5D
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 06:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86339E8
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 22:46:39 -0800 (PST)
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3b5aee410f2so688560b6e.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Nov 2023 22:46:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699339599; x=1699944399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t99IkNLk6JozD+pix5AuLrM/kz9q0JLxpd3F2LIjmkY=;
        b=PAULiagfPx9TEITPlGpsYokmffOrDr8p77TnfQnR1YYYmMAx7YgfYO2TF0fG1lp7GN
         IJBIgVHkM/p5nPahuoh98ixOqMKGW7m5AR2xVriun69jakyR7vAcdZ91Nph/cq3qoJqv
         uD833sEqM8fPhIMB1ylF4k+j5PWp06+s3Yu+XZOIOYxjllYqVtNsOBew8E5j9pGUhRFk
         hyaNuGJixK3j2Azkx/5r4eUE8d/u5H/KYf0fkUl3cMki7Cf//CazpMEkJcoxMHBsHvfX
         zZdjUja48qJGyJ4qCxs3xNfQsExD1OPKd5HnwxdCszYnjprG6RqlXc2D416Ysc/ydJyP
         VxZg==
X-Gm-Message-State: AOJu0YxsUgDAQAIYL9K0UrmUhNn0xdpWM2MKvG4LthT2U+6/NywAWQxx
	pDhxHG9cWScjjdOZ/OTTPL/ozCZabreYfg==
X-Google-Smtp-Source: AGHT+IGio399LSAfBhAv6UPz6G+PSJBGJEAhZablP+4msXOqnSQO+YwFIgMJoPt/k6HbjkZvw2v1xQ==
X-Received: by 2002:a54:4592:0:b0:3af:26e3:92e with SMTP id z18-20020a544592000000b003af26e3092emr26616878oib.28.1699339598808;
        Mon, 06 Nov 2023 22:46:38 -0800 (PST)
Received: from localhost.localdomain (144.34.241.68.16clouds.com. [144.34.241.68])
        by smtp.gmail.com with ESMTPSA id j7-20020a170902da8700b001b06c106844sm6923988plx.151.2023.11.06.22.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 22:46:38 -0800 (PST)
From: Ke Sun <sunke@kylinos.cn>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org,
	Ke Sun <sunke@kylinos.cn>,
	k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] bcachefs: Fix GCC-10 zero-length-bounds warning
Date: Tue,  7 Nov 2023 14:46:24 +0800
Message-Id: <20231107064624.2559204-1-sunke@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

fs/bcachefs/btree_update_interior.h:274:36: error: array subscript 0 is outside the bounds of an interior zero-length array ‘struct bkey_packed[0]’ [-Werror=zero-length-bounds]

fs/bcachefs/btree_trans_commit.c:702:14: error: array subscript 0 is outside the bounds of an interior zero-length array ‘struct bkey_i[0]’ [-Werror=zero-length-bounds]

fs/bcachefs/btree_trans_commit.c:694:14: error: array subscript 0 is outside the bounds of an interior zero-length array ‘struct bkey_i[0]’ [-Werror=zero-length-bounds]

fs/bcachefs/btree_trans_commit.c:686:5: error: array subscript 0 is outside the bounds of an interior zero-length array ‘struct bkey_i[0]’ [-Werror=zero-length-bounds]

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Ke Sun <sunke@kylinos.cn>
---
 fs/bcachefs/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index 0749731b9072..f3fbd1f88074 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -85,4 +85,6 @@ bcachefs-y		:=	\
 	varint.o		\
 	xattr.o
 
+subdir-ccflags-y += -Wno-zero-length-bounds
+
 obj-$(CONFIG_MEAN_AND_VARIANCE_UNIT_TEST)   += mean_and_variance_test.o
-- 
2.34.1

