Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8481A7AF1;
	Tue, 10 Sep 2024 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726003185; cv=none; b=KaHijv9ymeEUBJzf6iqfO7thHuYTwn8oqDvE2O9rFWZfwV8BjoVk6yu9y3rnP9gwTyh7/FeQYmeB6tOAN3vYT3YLZB13+JsNXUMocRyBmajFFTEkifVxKBHMwXZizxsngPhmSYJEcu0bkno1V5MYtJ7N3S3iVDjIFjRV7IyxdsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726003185; c=relaxed/simple;
	bh=E+xdl0TthoZACrhXIPsd5jvQdHV9M4f37aX3XmmA+3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suPofsG8hGbgVUC/K2wPHlggwmGeD5s3BWq+PzPTxkDHWSECeJnarFl50Hl15L976XFwVYiwP9DpvHYm5Mdf8YLrhgWaV5Jot/4aoVf0B7lXQjR+IZpOgvXoH8AqO4A+CKUCtLga/dt74VteWqSPivmUVzN3UmECKewyAXIIxHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mMKQ4ivp; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMKQ4ivp"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-717849c0dcaso5563994b3a.3;
        Tue, 10 Sep 2024 14:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726003183; x=1726607983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrHbrbavD4EX4WQfLkuORJ8Fd32mNBv/SCJAPE1O1J0=;
        b=mMKQ4ivpoDo0G/EPkJnYSdFJHAJCi9Px24gPi3ryiNCfELmseq3646OQJ0hcbW+oMb
         9Jy7E7x/HU5HzXW/Z9Q6xf3ndgyzjWVhO/LwtOXLcendA9/gGOiUfw6wo1CnSS2DPA50
         3+J60eBLbEFimrUuJI7RlQh9Bdl6bvG7J66QC5fAYw3SUX+AJiMXTbDrMN+WhULvozUc
         vhDalSGUjvVSS874Xxc1/MtWu6qJi1yG0G1C9YSJsH4bbRj53UB0Q6o8mQqRI2H69DTB
         eZpGWnZXWXP3Gc1sA7MNHre2ifSncYYXWuAkfsnWAY9RKuhnEizv9meqmcGWcrZupYaX
         2M5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726003183; x=1726607983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZrHbrbavD4EX4WQfLkuORJ8Fd32mNBv/SCJAPE1O1J0=;
        b=DmpL1+GEOwl5AvLFbwvMjT3x3v2Wfb0y3nV4XJwjFodt+3eJWKo2RWvGT4O6783OHQ
         MJEgD5aAH9R22YWJhhwyES/bw6POqCt7/xHfHv7QFDB6Ww/72OGtQXAjBE9gJMhGNzfS
         aMw2bctMuAKpL8M092Rl4tMTgQ3tiOf8FWD+pOKYiL9wtYcjtlIZJJCU3BDZc2TCYPmk
         ASg8fbFjIOOOUQrhFDUFbLVMV8hukXHWwKY+RECyjdU/HZgyS3UeGLvxrMOko2wYNGqg
         mJKz8SjSLSHmJs2VYdH9Kst+7lqIXjxRsNkFoaswp1GKHDolxBt1iZD/47qEzXOZYA06
         xIvw==
X-Forwarded-Encrypted: i=1; AJvYcCUJpG1fptvyViXT3rFQTGmhWxUGVO8z+HGwy7xexwcsKPyK5qBCQz1qmRzMnAtK5pQK+f9SHMm4R0d/gydX@vger.kernel.org, AJvYcCX3YXAChrDEwPj0VNym+B89Fd0Jx4C2+Dh8Y3VeGJcMGlifB2FVm+4d1wTos/Moz+JTEsxFEsi5fG//I2J0gg==@vger.kernel.org
X-Gm-Message-State: AOJu0YybwoL1j6YIczFH7k0MSm7NCp9Qvd14qOhrgCfdBuFbJGYz0oFn
	PpYRRNtGHSX9s1y6s/Da92ctovhnCtD5aKdgXKZpOVb28q1fGVQO
X-Google-Smtp-Source: AGHT+IFuWqS6MHNrO9qAdx2DtxmyoU8z+Ui8i42PVeM5z86pkhLPu48dpbgS281r9Om+G0v3dy0qsg==
X-Received: by 2002:a05:6a00:3e1a:b0:717:e01d:312f with SMTP id d2e1a72fcca58-718d5f67bf4mr14839114b3a.27.1726003183240;
        Tue, 10 Sep 2024 14:19:43 -0700 (PDT)
Received: from diogo-jahchan-ASUS-TUF-Gaming-A15-FA507RM-FA507RM.. ([200.4.98.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719090cbca6sm1774431b3a.197.2024.09.10.14.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 14:19:42 -0700 (PDT)
From: Diogo Jahchan Koike <djahchankoike@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Diogo Jahchan Koike <djahchankoike@gmail.com>,
	syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: return err ptr instead of null in read sb clean
Date: Tue, 10 Sep 2024 18:18:34 -0300
Message-ID: <20240910211912.96356-1-djahchankoike@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a null-ptr-deref in bch2_fs_start. [0]

When a sb is marked clear but doesn't have a clean section
bch2_read_superblock_clean returns NULL which PTR_ERR_OR_ZERO
lets through, eventually leading to a null ptr dereference down
the line. Adjust read sb clean to return an ERR_PTR indicating the
invalid clean section.

[0] https://syzkaller.appspot.com/bug?extid=1cecc37d87c4286e5543

Reported-by: syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1cecc37d87c4286e5543
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
---
 fs/bcachefs/sb-clean.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
index c57d42bb8d1b..025848a9c4c0 100644
--- a/fs/bcachefs/sb-clean.c
+++ b/fs/bcachefs/sb-clean.c
@@ -155,7 +155,7 @@ struct bch_sb_field_clean *bch2_read_superblock_clean(struct bch_fs *c)
 		SET_BCH_SB_CLEAN(c->disk_sb.sb, false);
 		c->sb.clean = false;
 		mutex_unlock(&c->sb_lock);
-		return NULL;
+		return ERR_PTR(-BCH_ERR_invalid_sb_clean);
 	}
 
 	clean = kmemdup(sb_clean, vstruct_bytes(&sb_clean->field),
-- 
2.43.0

