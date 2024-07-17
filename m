Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80D1E889;
	Wed, 17 Jul 2024 22:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253875; cv=none; b=iQMS5jbeRy8PaDITRkz07BxhsjWIQJaW3+bKM9/37ZQ44fnHPb7FD26w9dpHsjIIIEwU0lRq+9gBN2CZnV8Wu4nIo6FHD1so1hziRRKJ9grVH+VD+UiXPsYY9KDwLZNl2xWZTihDLaXYgjOGDvyE+QnVr/usfafOjEQLKhE3/dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253875; c=relaxed/simple;
	bh=9heysHdPAAfYUYBjINGkFrzzC1PF5xW0W3PpAOMDtLE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lz5XfHWM7WO93ZWis6z+HD5ttFS+dljmuzkfFc6fgRkAxtXNC24aXYo1meVkd06GlTaH5FEv6h9YnfmE0PtM8EW0K11YnHhHM+DsGSCSHxvzpPg3L0jjbZo60fSEF+3DBrOg0h1AwUyuPrG5xGztkPORpbdUQT6ZYvm3TdLFG40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lqYFp49M; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lqYFp49M"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc566ac769so1593635ad.1;
        Wed, 17 Jul 2024 15:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721253869; x=1721858669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qJJzJBG1sBuJIYP4ytCZjApGrGsyKC+uV6BQ0w5NiXc=;
        b=lqYFp49MHJg5E2sth7z7Iom7KehcqUB4+ZRyv891fjjAQgAQ8+cOLY8lY4tbN/MaX4
         raH+z5LHxVvHJQ/P/kKFbDgqYf1wbQVgf2gjWWqyAmd9IDfBN/So1fLelF5p4vxFcwwz
         TN1OQKpRrKwZNxZEJWMlitR4yy55eTmuu/mbrQZsF1Ud/mWpv+uiunfPW4sMNwSLrnAH
         fKUTZ9xA89lykZ/rBoe5q7/Rj5VRAS5MTd9/KZSg57X+oLJheMM33Lz0QLwbWXJn/4Jl
         yQB/XY/mloFO3ikIBIWy86RWHMF3Z9b5TlBzOUW3WoBOPPVZRLNSfZmJlTcuj6GCnivv
         guGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721253869; x=1721858669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJJzJBG1sBuJIYP4ytCZjApGrGsyKC+uV6BQ0w5NiXc=;
        b=gOPH53z6iBHzzkj5FbF0vA0Zv84I+4kHQZfAVEXrkC9m5g+CFHLX76cgumQBEhi1dC
         UN9xU0Qp87eS+HfKWdCTpFADnWpC7hKljyVOj9+mNKT1F3etqojwofJVDTNrYT8qDJdR
         +Mg7/pa3N7mmfzQeGROdKhTmkym80XqX1RDv+hQe4+myTOpkBHZKmodmzqtt2GrqqIBY
         NLx8P3xClwVXsadhLIleU5Pm6BzJtEe7K16Ff0BROUka+P6z82E9t7+CyjrdLmZn2ZWq
         hVdfmkR7jfNTNU+GEuo0j+S6NFtKF8VJptlu2v9AOdH+muYYdShrCV1O/2JurRnbLJPq
         MtEg==
X-Forwarded-Encrypted: i=1; AJvYcCXAwg+DjEHVEHSee1FhrBXD3XRbJUbHv5cmPTTYDVln5uht/tF8IPjjoKs9VBIBxAfNe5YJDp1GZUk/NkIq9gHjt5igaVAiLV4f8YSqoxl0QDZjqEHWFRimOysTviiESvxYvfhEK+9MLnxLoK8=
X-Gm-Message-State: AOJu0Yyw7Xaeiglf8hG2MQFi/rRxRSCvL8bEXQG0aPzeu2SNAY/RNsuW
	olrrMPKRQPVWew3UfOy+mVf3bE1Iv21GdohZmoMR0TLhdcv1p9Lh
X-Google-Smtp-Source: AGHT+IHqspYkdBpihSMxxP5jlP95b1at34yApAcv8ktjXwpCOTl1ZgFvFv7Gni1yTtamzHb29RKzQw==
X-Received: by 2002:a17:903:22cc:b0:1fb:3e9f:ff6f with SMTP id d9443c01a7336-1fc4e688ef7mr26234275ad.40.1721253869200;
        Wed, 17 Jul 2024 15:04:29 -0700 (PDT)
Received: from localhost.localdomain (pc-66-166-104-200.cm.vtr.net. [200.104.166.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bc3a251sm79778585ad.198.2024.07.17.15.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 15:04:28 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Camila Alvarez <cam.alvarez.i@gmail.com>,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
Date: Wed, 17 Jul 2024 18:02:39 -0400
Message-Id: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

last_seq and last_empty_seq suffered from an off by one error when the
journal has no entries.

The indexes were fixed and an assertion is added to check that the
last_empty_seq is always kept under the next valid seq number.

Reported-by: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/journal.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 10b19791ec98..7bbbf4b149e9 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1201,7 +1201,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	struct journal_replay *i, **_i;
 	struct genradix_iter iter;
 	bool had_entries = false;
-	u64 last_seq = cur_seq, nr, seq;
+        u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;
 
 	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
 		i = *_i;
@@ -1209,11 +1209,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
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
@@ -1224,14 +1224,14 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
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
@@ -1261,7 +1261,10 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	}
 
 	if (!had_entries)
-		j->last_empty_seq = cur_seq;
+		j->last_empty_seq = last_seq;
+
+	WARN(j->last_empty_seq >= cur_seq, "journal startup error: last empty seq %llu is higher or equal than the next seq number to be used (%llu)",
+	      j->last_empty_seq, cur_seq);
 
 	spin_lock(&j->lock);
 
-- 
2.34.1

