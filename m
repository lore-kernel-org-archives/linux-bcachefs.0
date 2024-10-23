Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C52B171671;
	Wed, 23 Oct 2024 21:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729719086; cv=none; b=nqYPkDrlpligdtDRMObHOD2a1Nb1SlJ5adUwfCRcucO7n4w3/8Pulm6xsDoiX3PWavG4t1+2tSPFtGhTJgNhEC9EkQ+2m+YyLWtpNncNr0s3VTJNsSNa8qHpBIrfutu9pjWgGTbok3pkvIU866SxhjtIpR0+2QGglwZ5tbsbz1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729719086; c=relaxed/simple;
	bh=YGuJKjj52P5xltJtMulCn4iAxD2u8dA4nmFEFfG9IJs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g8ppyoTx864uvB7ytuIrtGr3GPoppkKZ2vvNJpEEsROS6R8fk56h1aNvWxIRGAQOSNzQZsWkbSv1uLvqGfM/a3AMiWl7S2A6LMX7QuN+qwTatmK4C7VX7jUgo02M0DvXNXs50s4wWe2EMUBxKbq1HeubhRYGiUaM3+6iF+qCDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ik+R+tUp; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ik+R+tUp"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a0c40849cso25522066b.3;
        Wed, 23 Oct 2024 14:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729719083; x=1730323883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NW7DXXZp8vFpCSWhhInUDnFgCyc2m6Pj55WkPjxnOM0=;
        b=ik+R+tUp3U418RaGXoAAN4B/xI2i9vO3OX+pEgthhaC7GVwKFG61XZCo6rYY8vWyPw
         801/8W3rMQaTnprYqociylHlRXzbK/tbhFfg/IADdqzbxE2nZbe6bh1OAXoxQ/5tRMjH
         kgI64oSmRbZE1/wW6swwiA6Eio9wLeQrelFxhOry227gihLjxmOREXnyHE4AjwHCoq1o
         8l4ijSq43pt3ihvIszpBcNzugxgWm6BuIi/iG5/4dPmh+wW/dapOWms61Jh4jPaqEyQs
         I7gM+VZE1nJ/o+SgeNfXKH0lQWBrDZf6F8fNKliGuIGicsTD6ub2PFUoP3FPFshRdiKF
         kCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729719083; x=1730323883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NW7DXXZp8vFpCSWhhInUDnFgCyc2m6Pj55WkPjxnOM0=;
        b=IIiqmWEfP+d4xIyQBEGO8NFwdFoCElqGYCs39M9SuFs2jw8YrN8e5atvsoc/e51XoA
         rD3Fw2wJsbZ2Xo7KVKGCq5t2fo/D6kr6bPyjjm6dQ9XS0nAe6+3Zd6TpVZ6YPrD2ddKc
         TqBB1gOdGmy9qlUL09Uki3xNFCu1gNl8A7OnzW6n50LuzR9VmIFWl4G9s6ylTdI0hYkj
         eAXOTOVJWs4ZB4IUDs17oNi4ITmCWl8KlQSvpJbNBmE0u6k48ZIc90OEtUJnHSAvBjNe
         Uq0PNLGk+vvChZGvs8PaY1VxKxG6PnAZ3KNFpLb9WqGm22Cn2f8Wjx3eYjXN2QFp9zc4
         9l8w==
X-Forwarded-Encrypted: i=1; AJvYcCUHJ1R4GJdZv9c8ObE0TOx8uOdayGb6cxdqIRPOteakJdlxE+5efSYUalI+gHkyZp66gO4FuXGphk7mD4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9G0y06BgKS2ZbLf6jLT/kR12eEEwuILte8yUTI9pk1VSzecCZ
	0IVbJltBxeg2cpkHQSapwNWiAPXB46NaRMFxrZcU/mMCWlrVTIXk
X-Google-Smtp-Source: AGHT+IGUaFt6lRyLJJ4mmA//4NU5s3TwJ12PQI1oTGd4a5DOHfI09GIiMQN6xJIQubL7AW9LmgZ5hw==
X-Received: by 2002:a17:907:980e:b0:a9a:5cf8:9e40 with SMTP id a640c23a62f3a-a9abf877f07mr322489166b.24.1729719082625;
        Wed, 23 Oct 2024 14:31:22 -0700 (PDT)
Received: from gi4n-KLVL-WXX9.. ([2a01:e11:5400:7400:ce29:8129:5435:b143])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9157258bsm527044266b.158.2024.10.23.14.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 14:31:22 -0700 (PDT)
From: Gianfranco Trad <gianf.trad@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	Gianfranco Trad <gianf.trad@gmail.com>,
	syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix invalid shift in validate_sb_layout()
Date: Wed, 23 Oct 2024 23:30:44 +0200
Message-ID: <20241023213043.47846-2-gianf.trad@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add check on layout->sb_max_size_bits against BCH_SB_LAYOUT_SIZE_BITS_MAX
to prevent UBSAN shift-out-of-bounds in validate_sb_layout().

Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
Tested-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com
Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
---
 fs/bcachefs/errcode.h  | 1 +
 fs/bcachefs/super-io.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 649263516ab1..b6cbd716000b 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -222,6 +222,7 @@
 	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_type)			\
 	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_nr_superblocks)	\
 	x(BCH_ERR_invalid_sb_layout,	invalid_sb_layout_superblocks_overlap)	\
+	x(BCH_ERR_invalid_sb_layout,    invalid_sb_layout_sb_max_size_bits)     \
 	x(BCH_ERR_invalid_sb,		invalid_sb_members_missing)		\
 	x(BCH_ERR_invalid_sb,		invalid_sb_members)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_disk_groups)			\
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index ce7410d72089..44d0ac9b00dd 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -287,6 +287,11 @@ static int validate_sb_layout(struct bch_sb_layout *layout, struct printbuf *out
 		return -BCH_ERR_invalid_sb_layout_nr_superblocks;
 	}
 
+	if (layout->sb_max_size_bits > BCH_SB_LAYOUT_SIZE_BITS_MAX) {
+		prt_printf(out, "Invalid superblock layout: max_size_bits too high");
+		return -BCH_ERR_invalid_sb_layout_sb_max_size_bits;
+	}
+
 	max_sectors = 1 << layout->sb_max_size_bits;
 
 	prev_offset = le64_to_cpu(layout->sb_offset[0]);
-- 
2.43.0

