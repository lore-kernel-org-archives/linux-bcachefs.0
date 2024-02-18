Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC6071B50
	for <linux-bcachefs@vger.kernel.org>; Sun, 18 Feb 2024 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708298472; cv=none; b=DL0vjRo7Jnd/ALBafVr1ZnK4bTXXMmJ4r3DG3Shy4C74RDZQJjP/GOCozttyb3/2Lyu8zgoxslOoV7TduhlfygvIzFc6yZAbPDGnFRArHAlUyEsdnoRxjrmSVJ8RrkWlciBZRm7bs0zmvrocS2s2nBT8ta9Nre+iONMB7aY6el0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708298472; c=relaxed/simple;
	bh=WWdAzWlUZDFIHeavRzMqNlCk6xI3YatnAYUU3VbKJE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4cOPa8lpDN8uGq7d0mKAip7wPD6Gz9T79FUOkIzp8eXoBwotWmzSxu4jNX2qJ6+CxvYBW0BWxLUIoJM/PCTprYNL7RCd4dOQDGZA16jh+l0u0ldyEVmoW0Q7/rJ0B4cc8pmCILVYDUujamM2UUc4IbdNKQXdZ5M0HJDymztPv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juiApqu9; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juiApqu9"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3651d6dea15so3266425ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 18 Feb 2024 15:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708298470; x=1708903270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ibxe8GEqk0Co60NYHkodJDY6hhYba1kuaYzTnI6L5g=;
        b=juiApqu9/hs+YuhS/0E/ICSx9OmfTWCesfufoF+aQSGva1ZBq6beDyMZi9jwMc2Djk
         NiQeC/QSMAP+eSVpLLiKsj38kb5Z7qD+lUScnZZMivZs6yv0fiqkL7tCmesZWt2qnAKb
         bt+Vfms1VRg14NQFWSxuzaDRRgt7OlWrh21/3VnLSolV2cteT2LMQh4/RUJd0B0lRkA6
         L63M+N6epBgI3W+qZgStKD+Gwu/jUc3PXUxn/ht6BSRu3p0RWOexX9T1VVoJc1Pym/zm
         uExGUAlUOyOTosjfJ7Ygv8H4TYxSSG21AfV4ZHA/lTt5AU84vx+oh5CBjX10Y1C47NpI
         oEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708298470; x=1708903270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Ibxe8GEqk0Co60NYHkodJDY6hhYba1kuaYzTnI6L5g=;
        b=CB5xA2MnOBif8pa1BJr1b3Xguo6XSPr2mV0NaY52be5V2RwOAumajRhzfZaEX2Fuvn
         NtNBDERYLLLtqzkKEewQQY/plrHPA2hVMmgpjgW+T/m22CIx4tgzdQqfd07XUDm+nNG2
         KGD1JcqTLPxEBZ4kIf0lmGKYcMhLjfYIqRYTGW7+ahOqy19BkP/iG4OpyRZL3ylfMI/g
         OWWpZNZxGTJNAfzAKX/z/AAHQCpmIjtFT+ZxQBtPWOdFOtOmerDlvX7V8sB8HxS0UCeq
         zGl8gr4/4AZhF87xAmCsabUKwZIu+RGU3BECu6hts5QMrcdoL6JJCoPmAlYgzADCWbIJ
         95Cw==
X-Forwarded-Encrypted: i=1; AJvYcCV81iTqjvSSoD9WwcUJ6UeJRqYmXT5YffQqGwVhmzDSlT43mmkf9ITkaZBrHlCFY6f6AP7E+3KJQPgA4pzoDD6js2ts1EbVuLpNVJ4xlqo=
X-Gm-Message-State: AOJu0Yy2ky5s43v07ktvxeRzwld4R4iX/1PNViui10w/GveAvwB+x0sl
	qqeKrA1xu5Gm1rJnDYXncTepoXlWwbRNM9kvPoQvOR3OyIDNaPyN
X-Google-Smtp-Source: AGHT+IEtiTGcoiP21+1OzlmVwQhA39ylcyyjcauN7XMr44V78lVkWQuFEHgAHM9SaYcXYk1PYn2vXw==
X-Received: by 2002:a05:6e02:1c8a:b0:365:21f9:fb22 with SMTP id w10-20020a056e021c8a00b0036521f9fb22mr2924431ill.14.1708298469591;
        Sun, 18 Feb 2024 15:21:09 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id cx13-20020a056638490d00b00473f816cec1sm1229531jab.176.2024.02.18.15.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Feb 2024 15:21:09 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] bcachefs: fix warning about alignment of bversion in bkey
Date: Sun, 18 Feb 2024 16:20:48 -0700
Message-ID: <20240218232048.33309-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This resolves a warning seen on big endian architectures where struct
bversion is misaligned when embedded within struct bkey, because
bversion has an explicit "__aligned(4)" attribute.

Because bversion's alignment in bkey is correct as-is, remove the
explicit alignment attribute when compiling for big endian.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402171108.TzcVdtks-lkp@intel.com/
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/bcachefs_format.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 00060bc6128f..ada6f66f966a 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -189,7 +189,11 @@ struct bversion {
 	__u32		hi;
 	__u64		lo;
 #endif
-} __packed __aligned(4);
+} __packed
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+__aligned(4)
+#endif
+;
 
 struct bkey {
 	/* Size of combined key and value, in u64s */
-- 
2.43.0

