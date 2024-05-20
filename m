Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED014A33;
	Mon, 20 May 2024 03:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716174625; cv=none; b=AoiYOJ+S+k2Vu1LE7yFkRLNk1V1mWfjJKif5/BYKZW3A9zzHWBGH54PDbZf7WVtc1iO6s8DE2k2RvCwb9Vio47i8Y4/yw3qt6lju+bzrLQFZ2olafRwXfICbFyeK+E+HlFhXYWZ7I79d4JPzU7s51TLzzW7p/94flMnyowfCTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716174625; c=relaxed/simple;
	bh=4WqhMvI3Pf3B3fMZIlMXwBxz5QbKYJjAVHBs1SLNECg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MO7bGXANqqA5LibOyZmKaD0YyW3wxROPjMYg/YirYK2rlLgqzOdaGpJPZbqjAbaJISIMo746CF50IKjF9QvvWcGQGxf7OPWNvw5HDS+umL7yQIuRoS+Eo47NcahkPc+Pmy/T01IiNOHgTosFnQFXV602zoZdmvb4Exjp3k3HWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDGxVKOz; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDGxVKOz"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c996526c69so1612657b6e.1;
        Sun, 19 May 2024 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716174623; x=1716779423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVgUzdTRON7x3qceRHjQMiQNT1s+DpVTz0XvEqqtJsY=;
        b=iDGxVKOzt6mOUEaXu3Ng8R7MIPOVxiRAxwcpVrI5V2n5s1MfM1idawAKLYifyUWMkV
         JPCUvWj42NhJWd1BYR7GuHM0JVB50yR3qk5+R06MQ76rE90pUJYtX6LojO+VR09G9W06
         t23wp8bHrwFYwkIot2IbsRFKw8rCp7yqmEovcpj+K1CE3l6HuDyDqNhyogrJvSTrmvgI
         iVM6yGqSlb2NNMcYu+70fCH34LfsrtlYL5Fpgp8gRn8CVByPHnPrjbLsmNuJ1O+zq+rt
         wcGV7eT6SnFkwol+mHVrlUus4c/8DjRfUqrL336oh9q6UAu4v0WgwDAi9meu7YiwxOPN
         6y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716174623; x=1716779423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVgUzdTRON7x3qceRHjQMiQNT1s+DpVTz0XvEqqtJsY=;
        b=CvNnwOIdW8LlxsUjFcVPkLY2y4+4903xNSp+hpQCGQn0aIP/OWCIt1Lw/9/kCH6y7Y
         /lSCuDD0LRCLnR+s1fnZmd3vlZClSj9pk76fFI1cWFNnxEZKqKqZh5ZhDSsPBhGVgrah
         emKN1inr5JjesaJBlEBbm3/xXC92sj9QYSlSKhCotevz0ua3hkHvgwEijXQD3JEooZ3m
         QL/x2EBUlSKc6vX/gnqfykdRGmQdhDKeDXMlC+eZD21WhHdgu/EolrqiQHVMAQaVYvz8
         6Yd1dC/5VWuWMdxATY+iHU6tl6YGOyYT6kXNbMcppNZjjqsK+D39vRac9xy7X874Ntnm
         2Yww==
X-Forwarded-Encrypted: i=1; AJvYcCXQl0eQdXphrWS9OhOV5ExIJuo0ZtTCRwmis3+M47F9r5ivyetS8BBRLokF7bQ/eIKZ2UZr/mYatcjh6/SqqKEWzVgJFINBy4ObTgDIOzRfk5Nge31RW65OPplzdSUf0dq0bVcE/jWZu+kaPJ8=
X-Gm-Message-State: AOJu0Yz6Hn3dlWIPAsFo+TfrAehybSG9ibfjCLdfSDx4dkLyq6RnjgcN
	9usDgHJUXSgSRBpo1hi33DGgF5j+Bz8aY4AfIun4w8bp5r1prZm+
X-Google-Smtp-Source: AGHT+IFcNGeYibn9vUd3PD/7IACDV3sLjPwIWkOLh5cZH4E2fUvUZxpCD+PJCEkiIrzBabpjwWNhig==
X-Received: by 2002:a05:6808:2188:b0:3c9:93f1:c7b0 with SMTP id 5614622812f47-3c99705587fmr35557515b6e.20.1716174623126;
        Sun, 19 May 2024 20:10:23 -0700 (PDT)
Received: from localhost.localdomain ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4f2cdedb7sm14541111b3a.52.2024.05.19.20.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 May 2024 20:10:22 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: fix last_seq and last_empty_seq in bch2_fs_journal_start()
Date: Sun, 19 May 2024 22:57:34 -0400
Message-Id: <20240520025733.688425-1-cam.alvarez.i@gmail.com>
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
Changes in v2:
- Introduce a new variable to distinguish the last sequence number, from
  the last written sequence number
- Abstract `cur_seq - 1` into a variable named `last_seq`
- Reference to the last sequence number are changed from `cur_seq - 1`
  to `last_seq`
---
 fs/bcachefs/journal.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index adec8e1ea73e..99fc32f0382d 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1195,8 +1195,8 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	struct journal_entry_pin_list *p;
 	struct journal_replay *i, **_i;
 	struct genradix_iter iter;
-	bool had_entries = false;
-	u64 last_seq = cur_seq, nr, seq;
+	bool had_entries = false;	
+	u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;
 
 	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
 		i = *_i;
@@ -1204,11 +1204,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 		if (journal_replay_ignore(i))
 			continue;
 
-		last_seq = le64_to_cpu(i->j.last_seq);
+		last_written_seq = le64_to_cpu(i->j.last_seq);
 		break;
 	}
 
-	nr = cur_seq - last_seq;
+	nr = cur_seq - last_written_seq;
 
 	if (nr + 1 > j->pin.size) {
 		free_fifo(&j->pin);
@@ -1219,14 +1219,14 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 		}
 	}
 
-	j->replay_journal_seq	= last_seq;
+	j->replay_journal_seq	= last_written_seq;
 	j->replay_journal_seq_end = cur_seq;
-	j->last_seq_ondisk	= last_seq;
-	j->flushed_seq_ondisk	= cur_seq - 1;
-	j->seq_ondisk		= cur_seq - 1;
-	j->pin.front		= last_seq;
+	j->last_seq_ondisk	= last_written_seq;
+	j->flushed_seq_ondisk	= last_seq;
+	j->seq_ondisk		= last_seq;
+	j->pin.front		= last_written_seq;
 	j->pin.back		= cur_seq;
-	atomic64_set(&j->seq, cur_seq - 1);
+	atomic64_set(&j->seq, last_seq);
 
 	fifo_for_each_entry_ptr(p, &j->pin, seq)
 		journal_pin_list_init(p, 1);
@@ -1256,7 +1256,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	}
 
 	if (!had_entries)
-		j->last_empty_seq = cur_seq;
+		j->last_empty_seq = last_seq;
 
 	spin_lock(&j->lock);
 
-- 
2.34.1

