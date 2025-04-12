Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F307C219A80;
	Sat, 12 Apr 2025 18:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744483186; cv=none; b=JfNkGjp6wI2kcm4zjmWIYWTbmfXd9An8NFhMfd0yHe+em0ET9rLzvzL/oCLn/HrGuUSym9ZicO92YIaQSqAWME0QivXS7ACbpdPARGFsEt2W4U9mhLJtTWpiyl5BwvZE/lwOpT65AKSM0ir8NXnmcVnFiRjHLgbVz5Ge1k7md/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744483186; c=relaxed/simple;
	bh=O/tfl6Fffmdz+ozvorIpjOKofE4FVth4zYUJ4og5lOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OgxkOp3VaR3J4cjVMyG3FzaJFTe7vNcDSOiYZ84Y+dT0NFDleotOBUqhpLycFdIu1V3YffIUW/TpnSuO23gAUY2J3tLiRSw8G+Kna5osngiY7raiVL1VgJ2EOm3OznF6fg024S7IulVXtEEjtpa/UpZClWeCQhZ8rrjDfPJ2jFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+sj/xOr; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+sj/xOr"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c0e135e953so328475185a.2;
        Sat, 12 Apr 2025 11:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744483181; x=1745087981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fTIhgDMBpwNYh1Q9SspngxwnwElC9+qOUW+J9Zv9RN0=;
        b=U+sj/xOrJkjJ7RuvXbsMHibQ5LbwZxq8+QVLuqVVweJBkduf2ow+fQ2rW2xOzO+alM
         OMcnX6gKXBPz+kTBrxjel3YPFW6ElnONlczaynUmw1+qTzummMRrLs49zia4gtob3b83
         0VBYmrU1/o9hfwiM+nMLQOq3NXF8kqPDMCXa5QEihgnABY70au8JYt2PW8yqXJ/MlR+y
         bQ58vZDXcxxlOlLTmHFYHyxUq84ci6HZ0e6viDmFn8WpR/iz3zOTnuUbVCUtwGBfb75i
         KCoBvu6uqlFGiXkydpOq1PhH40kda91J2M8ITN5/R4jhTCXoQdw3I0booNX9GrMhpIjp
         WW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744483181; x=1745087981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTIhgDMBpwNYh1Q9SspngxwnwElC9+qOUW+J9Zv9RN0=;
        b=PmsvUiyvOAT2JvajNDGc8sAfsS0RY2gan+m2pwbhGrPErTvWkhuMpK11hByt7Ek4t6
         Iqs2a/ycUX9rl/r+Nm3r39oKjoVrSAh+kxeFVgME9EPtYOJfSAqTJfKrXM9RWQf2T+kg
         7SfYe7li/ufgELWh4LEll9B1EoZjZyx0L/854Zlf3jVFLsNzdfUf5F7gqm2e6n2y68A9
         JKYlHpZV4VQrjmbKtGNn/BBkiSmCNTpvBZ5utwQGFEJoeu3zLwTwe9O/aC/CleERsyHO
         TkEaETC73hAitPnHclhf1TczPAzBBr3GCPvBt32vT6evjLiYbmrzNxRAhyTC2q3gX2/3
         Q2aw==
X-Forwarded-Encrypted: i=1; AJvYcCU8vev0PwnOKsKmA1+PM1QG8hCXKoux4PArcaSH+vZr2CZcxXqXfUH3GCZsmuVbRSp/ezvH3MU4UMpYsCyo@vger.kernel.org, AJvYcCXznHDii1OinlIQVOP3U4/W27R9g3Ft8VD3UF5TTcXlwe0ZdNCjP6cRjdzWCZXljt4L9fC2ZP42970xw9C1kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpydqwyJBtkSdA3ZA9j+81t2i5Z7C9juAvPgjYcrjgsH11J/pF
	RSHG2UQFPP6dF0AIFrlY94ioS7hu34hNAVuPGJqkGqyr9Mkgnoer
X-Gm-Gg: ASbGncvWHzvBrC8tRbICWrYxdYbXl3XV7YfX3IMFg7IOEsg0wBVt4OiWtIsqm2pj02q
	RrZWVTP0wqQG81XA6EMmXlUe94rwG1+b66NFzSPfam87Aso1sJmWX5l9DLvY/IRLqp1d+LmeW8n
	H6FU8GgW/ybo8geL6iEmFZpG84m7XfyW3FS/1tXJNLR3Elg4Evp8SyvxoGJ3Q+bSPk21/pZtYB3
	HKXQj3u1sBl11SCdr1Z9sytsGcqPy5SRKW1JEgeDI2m0m2TvMUCXe6BG9Q8sC5pop92Jw7NNh32
	teirxKqqfFaF7UM6n4af7wObXfx34S1uPS+OCx332KI8+/+6m1RCMN5dwvwgA86qzQGUDAqhWVY
	jLbM0KoRTr40BWkrnKsM=
X-Google-Smtp-Source: AGHT+IEIF5aKbUqiEwVOhGlNWeg3uHv6irWfXWK/eOJK5zcT9zDoQDZIfyq6saOUkPlUfXeul4WZLw==
X-Received: by 2002:a05:620a:270d:b0:7c5:96a1:16c9 with SMTP id af79cd13be357-7c7af0be2e8mr1201306285a.5.1744483180547;
        Sat, 12 Apr 2025 11:39:40 -0700 (PDT)
Received: from theriatric.mshome.net (c-73-123-232-110.hsd1.ma.comcast.net. [73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c7a8a0dc9fsm436708685a.96.2025.04.12.11.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 11:39:40 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: syzbot <syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	charmitro@posteo.net,
	skhan@linuxfoundation.org,
	kernelmentees@lists.linuxfoundation.org,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH] bcache: Prevent granting write refs when filesystem is read-only
Date: Sat, 12 Apr 2025 14:39:33 -0400
Message-ID: <20250412183933.252062-1-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a shutdown WARNING in bch2_dev_free caused by active write I/O
references (ca->io_ref[WRITE]) on a device being freed.

The problem occurs when:
- The filesystem is marked read-only (BCH_FS_rw clear in c->flags).
- A subsequent operation (e.g., error handling for device removal)
  incorrectly tries to grant write references back to a device.
- During final shutdown, the read-only flag causes the system to skip
  stopping write I/O references (bch2_dev_io_ref_stop(ca, WRITE)).
- The leftover active write reference triggers the WARN_ON in
  bch2_dev_free.

Prevent this by checking if the filesystem is read-only before
attempting to grant write references to a device in the problematic
code path. Ensure consistency between the filesystem state flag
and the device I/O reference state during shutdown.

---
Not sure what to put for the fixes tag so I omitted it. The bisection
that Syzkaller found technically is correct but only because additional
warn_on checks were added recently. The git blame shows code from 8
years ago for the specific lines being modified.

Also not sure if devices should have read and write permissions
(ca->mi.state = BCH_MEMBER_STATE_rw) when filesystem is in read-only
mode. If that is what intended, then I believe this solution works.There
could potentially be other places where a similar scenario occurs.

Reported-by: syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67f50e3e.050a0220.396535.0560.GAE@google.com/T/
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 fs/bcachefs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index b79e80a435e09..788e870bfef6a 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1757,7 +1757,8 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
 	up_write(&c->state_lock);
 	return 0;
 err:
-	if (ca->mi.state == BCH_MEMBER_STATE_rw &&
+	if (test_bit(BCH_FS_rw, &c->flags) &&
+	    ca->mi.state == BCH_MEMBER_STATE_rw &&
 	    !percpu_ref_is_zero(&ca->io_ref[READ]))
 		__bch2_dev_read_write(c, ca);
 	up_write(&c->state_lock);
-- 
2.43.0

