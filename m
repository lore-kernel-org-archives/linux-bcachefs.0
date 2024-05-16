Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3D323A6;
	Thu, 16 May 2024 03:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715829667; cv=none; b=MV09h1TSe++RzGgcElyiatH+5Tr96mmqctIiFDUuSZHZ/po/WBym5QHSe0gNgUiVkAiuDpivF/cjeWtvMGQQbFDbd+TDxsF/U8fosMOEMbM1yVYeZfCzp0jRrVDHVn9zuAN9JbbMNCgTsO4EDP4qZAuzW0oJ1y2bYLiAfWV5sqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715829667; c=relaxed/simple;
	bh=qaMpaSvbiULWJTnySDPvvx26VQcPpbEg1arIk24D7fc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TM2M0lchXheHHj36DHz7Nnvqj6iH9Upqz1GReWNoiw5wQYND5jYcoXo2QbQIWCcpzcecz2bR+N0aJ3ASosTT+l8S2u8aFqXXwBB6g29EAFNbLekEwRtpSoHFWNiAadCEDSJ1gBx83srkvLEJSg6+QUsiDIPt+Wm2vLsY5nVGcJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jKisL3Iv; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jKisL3Iv"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-23f9d07829bso95954fac.3;
        Wed, 15 May 2024 20:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715829665; x=1716434465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T4hGieocM0GD4D8ugKQkb0PeE3WjJFXzsgOiBI9qhZ4=;
        b=jKisL3Iv02iIYGPap5RRU1XWuyfqmJTHs6JujJrcDObXbL6SUbXhZWtjOz+bE+xNZ5
         PCArlEvMuGmgW7KGFodFWfB/aP0fnHRCK/Qg9aqc362s7SJJqsBcgXMKQeXHMMNPn494
         +RAMkAYPcSCho03HfntNyl8lKKi7NI3BqmbYNP8nf4Dz1cBPysTMq+KB64HBOw2bwjT1
         syIrh9KyCJxOl4e+PsWFa+7EYflsTJiqE/70ygZU4QXe5Gd8fXhyHz8bMgXxQ+oM34Gf
         KQRfgHQD+ZqkFmuORbabOA3T9P+2ZT3sRjiQngd1pM3vVq5u5YMRJ38F3KrXzfJzGibT
         YOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715829665; x=1716434465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4hGieocM0GD4D8ugKQkb0PeE3WjJFXzsgOiBI9qhZ4=;
        b=HEAztetUF7iFpttOhkp/P5AoFEBQGfSE+4kXBAWHzn95OHPx0n475qZcWK7YfFS6jE
         bS58bzK9eTHlYhu/GKe7PLcNbkh2qOBirLRIqsHyX91l4jeZs2djvx4lL3sxNwo4Yt/F
         H6iHa2nxAqD+BrbZSQR3s1EFlE6ImXmotpmQhdQvj0YztCl+zTJWSPRd5yYp7kPbgXAy
         +sIPx0Or6GHW9aQNeKccZbkrKv6Tb5hJwh5BTBbxJ/DBlin2e6g9LENGN6LJZCLvNnew
         pJo6gg44ciPVC3q/KL8/eR90BH2WI24tuEt5w7LqxbiQkjBTudGJPbjCqm4uEjALCC6t
         EdIg==
X-Forwarded-Encrypted: i=1; AJvYcCVpnKi+YMYIDCcbFBoEq07wxiQvCaGGLgA/V8xxJEzmQaI3KbenzCT8vpc+rf0vFB6dhEvD/Rpb4TOKdJm173pgCI86MpbfJtRORifZEXHKy8EHIOB9IDExCop9R/pOgMtNkFDwiz1T4qDri2o=
X-Gm-Message-State: AOJu0Yz+lhc3oTiBUU3sco1n47GDaIGLsYTe9yAFpxVhxKaJWyuJ+21R
	wRvEsHe2SJ1Tgt9nKXNJNlMOAUb29kM1t8JlT4zfKjt+X7rDe152
X-Google-Smtp-Source: AGHT+IED3m4iOZgrPS0P/LI21BISZuGWsGUdiec8TnkCeN9GlFHM4uVJtXdrUSjHcpT2Rfm7vfADzw==
X-Received: by 2002:a05:6870:3047:b0:240:3a4e:504e with SMTP id 586e51a60fabf-24172fca27emr19952487fac.58.1715829665180;
        Wed, 15 May 2024 20:21:05 -0700 (PDT)
Received: from localhost.localdomain ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2aa01dasm12222785b3a.92.2024.05.15.20.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 20:21:04 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: fix last_seq and last_empty_seq in bch2_fs_journal_start()
Date: Wed, 15 May 2024 23:19:20 -0400
Message-Id: <20240516031919.592696-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Values were left as the next possible sequence number when there were no
entries.

The fix involves updating the last_seq initial value and
setting last_empty_seq to cur_seq - 1.

Reported-by: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index adec8e1ea73e..3835c458eec9 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1196,7 +1196,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	struct journal_replay *i, **_i;
 	struct genradix_iter iter;
 	bool had_entries = false;
-	u64 last_seq = cur_seq, nr, seq;
+	u64 last_seq = cur_seq - 1, nr, seq;
 
 	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
 		i = *_i;
@@ -1256,7 +1256,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	}
 
 	if (!had_entries)
-		j->last_empty_seq = cur_seq;
+		j->last_empty_seq = cur_seq - 1;
 
 	spin_lock(&j->lock);
 
-- 
2.34.1

