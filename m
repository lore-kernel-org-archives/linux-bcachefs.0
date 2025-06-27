Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC424DCF0;
	Fri, 27 Jun 2025 08:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751013684; cv=none; b=VqW+Fm/YBIkOIALO4wfK9/54wsKrUlziPngvRSyaZUykrGC2XfNdN5yd03Ux9UrnomUJguEO4GDowRPxC93icIiLxyqZ7qQOJzI3qKbS9FGHZNtHB7edxR8Wpmd7AK/J1q3YCUuapgXZfCcUh5hrpRRrrEPw+5NtcUyZsKhSLL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751013684; c=relaxed/simple;
	bh=G15TbEaaORHlH4PKFvQC5S1g2tM1QIEczD+xXH/buq8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HmVEISZbvEy8v/rn2nP9f24fBap+E673xk0pmgnv739lvkGZMWFRG7Cjz7tFlX9I0Sjw5uPDPlVizUyBARgaM357yIAxel2X7RCHqpKPZsLYcABR0YnMkMWGU+DZWN9US15DY32Cck4mX+Y8JdvUZAR7UcA7ej9Nv8J0YLV2bps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPt2GfGf; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPt2GfGf"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2360ff7ac1bso15942335ad.3;
        Fri, 27 Jun 2025 01:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751013680; x=1751618480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S7P03Am8WwxtD8ZLQtp8L4pE4xvZy13+wsAyXWAqk3w=;
        b=bPt2GfGfjMxIxxgIHEhZvQvsgrhbiuyDlZTIHBfG045VTITdFjTVfB3f+zOwA3pImH
         zprfOHgAeB+9RjdxGXztGFDNrAmfUmPHPcZFhkUKEXIuaV9vUVbi5LXlzBES3ZGjUTFc
         gaOvv7GX7t61zgrRSDq78B06MA6OyT8vxvNcwndk3q1GQO77PweGmFl7DHaKIolRXRbA
         9/orckT/QZ0i2wSHb+pv+cVaL5faxUezNTHhx+NhlT54Ld6vNwTTNOnpqOKQYAEknltP
         p7joo/gWLYOwab6UXCyIztrio/9Ypa6LiJxXEleKOncKUNJB8GxCzqCyfNk68Os+s021
         aBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751013680; x=1751618480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S7P03Am8WwxtD8ZLQtp8L4pE4xvZy13+wsAyXWAqk3w=;
        b=EmvMSOxsS0YS8UvaKUAmhuA/xE0wwf+IH2V+Eou5opo8Dz12XheeSwNuDcdDcmtCNe
         sVy9DkwaOrwTEAvJfYcXTZCtS+mYawCWYWgxR/IVac5ZGy4mhToDA4TesSzMHWUDhw85
         bq28iWRYwCElY0TCzcwKl9BCJksofZvDZ2GrftfQTQTAYajsmvQ++EsA74EGn5j9sDBz
         QqtFpNqPYHgL2VhA0dJrYKi/3DZnST8Eryz3jLnZaXTYsnQ/gw5CmH2vfqdfm7QFvvMP
         gk3mIanc3hjylB/xWwe7gOnqJHb7J3iiUDHQZHR6CwQkQ5PqfM1LL3Tm/M0qP49mcCTT
         oMSA==
X-Forwarded-Encrypted: i=1; AJvYcCWX3pH69ECmrdf5bk5wN6rptwbXmZ+yBfu0vCgAyF/rIfFafrJvCGsVO9mUees+WEvozOIpeUjDWU+xgV9Y@vger.kernel.org, AJvYcCXogkZUmf02yyPwDsT12yjvORZH7PGBpLtQyaK8zPBax0okwobmiH3rTli0u6/bHw4WMUdtTkcmWalM//vA5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YybQjAlZ1TXP27mHrIGzqDpp2vz94i1OlmpbH8+83PcbK6auESR
	kt/tlkKEYu1gZWV6uDLoGw/vLLnZ6NsmBJSZDLHJXJDi7tPZwde1J+LX
X-Gm-Gg: ASbGncvusyXuLFu+aLBCfwRraBBZYORYWILA2zCW21VJFA6Xxy0tLw18TL31sy0+h8Z
	RafQb+lsDKfgsvtuXG4O2JfVyce5h9PGWoLChg5G5NbZiMYwu46sFqO5K79Jwcx3PZ3myqL8m0S
	FeCBnvRNx5bZ5GdD5k1v1LLFVJ8IXgm8xwGuh/k6Oka+IzOXrHS2X1+Az2T++5yRTdGMkqm5b7R
	y0oTxGWy5AqhyZcoabW69QdLSklPWdAvQLfcaZOTzljrCbC6dkiCHpF5cIjsiA/r5aD7NZL3Xan
	oHF0ESpxOhxaEHF0l2r/UoJiQ23rq6qs4yf55mTb3XrBE0elJG4Db7FuW8cE9bOx+ur5TrvvWiO
	xYMB0
X-Google-Smtp-Source: AGHT+IEhtmnbYvve8P8SDXttYyhI5mB1zS1BNdn1fSZzamgnXBJXcQIUlABy/QdajF1bRdhSmyCINw==
X-Received: by 2002:a17:903:1c6:b0:236:9726:7264 with SMTP id d9443c01a7336-23ac2d8687emr45206315ad.5.1751013679650;
        Fri, 27 Jun 2025 01:41:19 -0700 (PDT)
Received: from archlinux ([136.185.226.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c9cecsm10989485ad.251.2025.06.27.01.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 01:41:19 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: use mustfix to check invalid btree IDs
Date: Fri, 27 Jun 2025 14:10:32 +0530
Message-ID: <20250627084033.614376-2-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checking for invalid IDs was introduced in 9e7cfb35e266 ("bcachefs: Check for invalid btree IDs")
to prevent an invalid shift later, but since 141526548052 ("bcachefs: Bad btree roots are now autofix")
made the parent class btree_root_bkey_invalid FSCK_AUTOFIX, fsck_err_on
no longer works for this check.

Change the condition to use mustfix_fsck_err_on instead.

Reported-by: syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=029d1989099aa5ae3e89
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/recovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index d0b7e3a36a54..abcaa0e3e2e6 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -489,7 +489,7 @@ static int journal_replay_entry_early(struct bch_fs *c,
 		if (unlikely(!entry->u64s))
 			return 0;
 
-		if (fsck_err_on(entry->btree_id >= BTREE_ID_NR_MAX,
+		if (mustfix_fsck_err_on(entry->btree_id >= BTREE_ID_NR_MAX,
 				c, invalid_btree_id,
 				"invalid btree id %u (max %u)",
 				entry->btree_id, BTREE_ID_NR_MAX))
-- 
2.50.0

