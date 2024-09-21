Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882FD219F3;
	Sat, 21 Sep 2024 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726941829; cv=none; b=rAlOpkAr8PlRFwcOEIIXleMvg8Y5cse0jM0Vj3tlZqrfgPpDzYPZ7D6D+zUS0b+IKjdhs/EmRxRrVkop2rOarm09YpuVDmBxxNfDegdnjXW40OqBJGylG1Tmjgb44ATM28JVgx/sHOUBMHDHaTkzJHcvVoV9N9ndVHLHlPlJhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726941829; c=relaxed/simple;
	bh=s6BjKCoD7TPdj9u/yS7RACblpJxlkNmvxGungZsxtrY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XmofXDI+NX5frAjwY4KkUVMXn0rHuyrmmLP7QTozHj+O1T9ZLhAlce6anYsjWPgOpkw/S+e4x5KTmJ57sws64+7A0CrD/Krm/IdqZEn4r2obLBlFtkuJ/J451US3KL7SG1XnHeIBR0Y7rBqrI1z96Ri4jgAfjRTssbnRqloXOvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d/Pr6gsI; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/Pr6gsI"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374c3400367so2666644f8f.2;
        Sat, 21 Sep 2024 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726941824; x=1727546624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9gdSn6YCnACdNv8YtrHPPBixkkVDSovFugzuG0GyV4I=;
        b=d/Pr6gsIV0XK/4jgcVZoiSOj7pR4Lk+AtWFD//0y28oSmLuoRuw/q9/g9homhEBiJd
         G1OHkYbukhBf20eGqrcsSckE4L5tEfdF2UClELQWbmasquWCZYLQ9ns8t5j9P8btfQuf
         AlDJWMqrYUaKdmoqokeCh4Z/upu56bqxCXJTM5Zhca2yW992VyBdM6/4BuM/nK1m1g6y
         hvT+kd/9sizkd5radJKdMf9wM+rTfoTs8oShLcpO7n0OFb9zO3xd4b4e3qNMy1coUOix
         NQGx05lqpiRf4zsF5TObr3e3nT5XQVK1GDDjLH1I2MXxS60ld+dzu6nT3gmuI5OplLwO
         o9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726941824; x=1727546624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9gdSn6YCnACdNv8YtrHPPBixkkVDSovFugzuG0GyV4I=;
        b=uxcMu6jid5vc/9LxomfyxelxWjTAzSjdUL5vdeZi5p1Rc9PALbjE0gVc3kIjqEk9Gt
         FREGkHTWtdp6pzR8UkEN7c1kOSKcC32LzXtRydk4E9PYsQnMCKQf8/1GjMW7VuI9FhbI
         l7kFnn0xNr2uRguOIVRD68bonI0Cga+k+Zfdu8S0DwOyuIj/pdILLInkAnWfY7MBqFae
         IPnbhOlmIaAKCzbOQD3Kzk6WyZ/eQy0w+uKsHjElxUTh0yo1lg9zDAAdb0V7J/m4ZUmp
         naiti9SLY6xGD4ar5/ANG/3mf7GgsGSrDcDXn3DZzpLGZt6Bd5UPC9rQHvP3wmmqAab7
         Imjw==
X-Forwarded-Encrypted: i=1; AJvYcCUfAckeNvm05ePU7Dy/TZXJGddzpZ5qcT4cmCnsa35XJAUesXqYUzqlA99JvKFXndR3F70QTAc0VhnbJBzGKw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9USseKsoQtDqMgc/SDy6C6bXj/v69pAQ1QXhqZHD6R4KyIpjm
	gzeSecni42hz0+mkg5dOAaHKxXgc2AKu+L9BW2Nnmc/rjMTlMJvppzzwmqAav3I=
X-Google-Smtp-Source: AGHT+IEUVShpep7FB5qP3858nspjeNeWb4i1eezbpNHrFUbpIMvWW37/2Os6UThLjuGUetpvKNvskw==
X-Received: by 2002:a5d:5447:0:b0:368:3f6a:1dea with SMTP id ffacd0b85a97d-37a42253629mr5747995f8f.6.1726941824186;
        Sat, 21 Sep 2024 11:03:44 -0700 (PDT)
Received: from localhost.localdomain ([197.35.194.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e73f99b0sm20461496f8f.60.2024.09.21.11.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 11:03:43 -0700 (PDT)
From: Ahmed Ehab <bottaawesome633@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	syzkaller@googlegroups.com,
	syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com
Subject: [PATCH] Hold read lock in bch2_snapshot_tree_oldest_subvol()
Date: Sun, 22 Sep 2024 00:00:36 +0300
Message-ID: <20240921210036.99386-1-bottaawesome633@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reports a problem that a warning is triggered due to suspicious
use of rcu_dereference_check(). That is triggered by a call of
bch2_snapshot_tree_oldest_subvol().

The cause of the warning is that inside
bch2_snapshot_tree_oldest_subvol(), snapshot_t() is called which calls
rcu_dereference() that requires a read lock to be held. Also, the call
of bch2_snapshot_tree_next() eventually calls snapshot_t().

To fix this, call rcu_read_lock() before calling snapshot_t(). Then,
release the lock after the termination of the while loop.

Reported-by: <syzbot+f7c41a878676b72c16a6@syzkaller.appspotmail.com>
Signed-off-by: Ahmed Ehab <bottaawesome633@gmail.com>
---
 fs/bcachefs/snapshot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 8b18a9b483a4..678e9fdee348 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -8,6 +8,7 @@
 #include "errcode.h"
 #include "error.h"
 #include "fs.h"
+#include "linux/rcupdate.h"
 #include "recovery_passes.h"
 #include "snapshot.h"
 
@@ -469,6 +470,7 @@ static u32 bch2_snapshot_tree_oldest_subvol(struct bch_fs *c, u32 snapshot_root)
 	u32 id = snapshot_root;
 	u32 subvol = 0, s;
 
+	rcu_read_lock();
 	while (id) {
 		s = snapshot_t(c, id)->subvol;
 
@@ -477,6 +479,7 @@ static u32 bch2_snapshot_tree_oldest_subvol(struct bch_fs *c, u32 snapshot_root)
 
 		id = bch2_snapshot_tree_next(c, id);
 	}
+	rcu_read_unlock();
 
 	return subvol;
 }
-- 
2.46.0

