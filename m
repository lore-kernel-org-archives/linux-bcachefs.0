Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C884A5E;
	Mon, 23 Sep 2024 22:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727130201; cv=none; b=T6cRMPNxJOEDWrEDBrS96lMa/GR8oqpghF4i6zLurpBdec58mO9wlqOKzcyDW+r7hb6sWXv4FaEvPvAOgXykbrZqvjmbhtq66lQNx4Y6f9FDdXuOeb6ENy7wnIDqVyH7KSps24jv8By+WRUaGYwp5oUYfd5RgHpLw2Z9jo5TH4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727130201; c=relaxed/simple;
	bh=+IRU5MvoXdAZd41b966UC1JOfxDMpRGlFZYIaL5dSPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P41z+qrFJRaV8HAZMCCqtGvSolkmFdfUkoFejYlobYKBj46GQqIZEQO/UDEmYCOwvgme9VyZRy8ovtJTetC4hgUo5p0yrrEiVzDW8N+HllQZu0Dd8JSqft45KR0YYaamY1c7LmtX3t0berGCDBLoAz607FzKQeK+gxF5YCLeL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=deru6eWe; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="deru6eWe"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-501269674daso1408401e0c.0;
        Mon, 23 Sep 2024 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727130197; x=1727734997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QymWD1IrtknSkAA2lmTqG0YpoY1LO6eanvSL27b8XIM=;
        b=deru6eWerlvYD7TP99FGkr4+oez/3sGZZ0Or9qf0Ktk6clrwoXUall5GyNIaDKLgyd
         JybEIh0i7q8sR3Yr8LQCDwBr9G2rOZqKOZTz+EF6ShjmIMCt+sy+xsULA+4NKpJtAXiO
         /EtDtgaMAk3VJ0sdfo4epivz2cC7BO5Xq/XylEdPKt4AkhLRJJ/Garwe67MFvwQUGK0b
         9dI4K9MREKc2MeKPrr7JR2fZlIUJnFsEZwQXnBjtWOlaB8X1WqjqtO86xxtVVJ+bF++b
         eNJyfEy/7JsgCcTQYIvprUG4vc/HovxdWHDJiK3mtZCq6D77JaTHIEii62GEb46hS9Np
         94jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727130197; x=1727734997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QymWD1IrtknSkAA2lmTqG0YpoY1LO6eanvSL27b8XIM=;
        b=Gt3hJGi/BmHm/V1cc8uFQ5FxAUFLm0uLLR4MEs9pJdY9Ck8rOON2piq7v/vQPAMZ7Q
         b4bC5OiPUewSvyy2kYl6TNwBZm41Q9UoifJI8zrgCCqB0lSr5FINu6D4plKr+CzwkMRY
         rORUpRTlbQ7PdF93WO+NVYAy4rh9uqXces73a95qx3o565WLG/X87mhsIF/NwL0D7CjK
         ps9R4GiyGylTxm0iZzt1gtpvgQOu0fi1GhbJ0u57CYz36E02iumRMYJ8UrRg7m00SQdj
         qeD5x0PZjcc9YM1kTk37JY6a3sPKbgfSzn8PhmVqKgDMixCjFq7gARMJEiH/y6GJvThN
         nXtg==
X-Forwarded-Encrypted: i=1; AJvYcCVOKYWWksgSco1jUkz1R+igygyhY13iG6XNlYkljwXIi48WBfNJ2RZ6NLwBD2QDy6S3AVcUZlmKsy1pVe2r@vger.kernel.org, AJvYcCX20fz5Rd+81ZnRMBFwWqjsZgbEbfIS/5q4vKyql5TTolBriXZFU7blFlUm3BswfY7Qmld+1QCrw8xnpaSKlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzoFTQS2PLRHqnTBrZZEkNWxTwlzNDkYtad/OcGPwRAj1rfb7iX
	cFjh2T+WLjsjfrZ7P3JItMboETWHuqpvlrTN7c3bpo1W7UnjPOU9
X-Google-Smtp-Source: AGHT+IH5f45ouRi0DUtEDTvrxo5pc+E6m40jFG6QrHhEYFQQOvkf08AU0lsDiEKLhyNVNI98qIdvJg==
X-Received: by 2002:a05:6122:3b12:b0:4f5:1ea3:736f with SMTP id 71dfb90a1353d-503e0580dc0mr7628307e0c.13.1727130197543;
        Mon, 23 Sep 2024 15:23:17 -0700 (PDT)
Received: from diogo-jahchan-ASUS-TUF-Gaming-A15-FA507RM-FA507RM.. ([200.4.98.112])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-505a9f3ef8bsm180382e0c.17.2024.09.23.15.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 15:23:16 -0700 (PDT)
From: Diogo Jahchan Koike <djahchankoike@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Diogo Jahchan Koike <djahchankoike@gmail.com>,
	syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: assign return error when iterating through layout
Date: Mon, 23 Sep 2024 19:22:14 -0300
Message-ID: <20240923222305.128344-1-djahchankoike@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a null ptr deref in __copy_user [0]

In __bch2_read_super, when a corrupt backup superblock matches the
default opts offset, no error is assigned to ret and the freed superblock
gets through, possibly being assigned as the best sb in bch2_fs_open and
being later dereferenced, causing a fault. Assign EINVALID to ret when
iterating through layout.

[0]: https://syzkaller.appspot.com/bug?extid=18a5c5e8a9c856944876

Reported-by: syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18a5c5e8a9c856944876
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
---
 fs/bcachefs/super-io.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index c8c2ccbdfbb5..fbca0bd302db 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -796,8 +796,10 @@ static int __bch2_read_super(const char *path, struct bch_opts *opts,
 	     i < layout.sb_offset + layout.nr_superblocks; i++) {
 		offset = le64_to_cpu(*i);
 
-		if (offset == opt_get(*opts, sb))
+		if (offset == opt_get(*opts, sb)) {
+			ret = -BCH_ERR_invalid;
 			continue;
+		}
 
 		ret = read_one_super(sb, offset, &err);
 		if (!ret)
-- 
2.43.0

