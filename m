Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF79C148FE4;
	Tue, 25 Jun 2024 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340897; cv=none; b=Ccsr/f71cKbsIJBcsWaibOlE5GKuuR9/1rXRGYAmKZ4+iDlPV3bdH0odNz/4Kcz85DazNV+VnfD7/+iMlNqbtXuw73uIK2+L8OymmC8t4t7aVFI2y15Rh7adJuLZyusXH6Xloa8WR4WrBFfjjb8QhdMkl5o8g4Y6gV0l8pbOqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340897; c=relaxed/simple;
	bh=03Ii5ZBqcDwAxJr2sGNb78vUVrsKGjNeIgOrc7Ld5k8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=o5EczfJkD12M15NFYodnczSQBJq3W342J1RmazJNMyTtmxo9b5KjKN0ragdYFddH3NB2mXgjLPDpK/Ms8odEAOwP7KC14lXh6F81F8iIqtOhSlMVIwN9rIfSe9eLfeDDtwE4g02Mw4ocOKfjv3e1PG6xFTVJMuo5KECNG9W/NOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR/B5MMc; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR/B5MMc"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3d55ed47cc6so258377b6e.2;
        Tue, 25 Jun 2024 11:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719340895; x=1719945695; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3AMwpyokpH4GrRlIkNJKRT3hzfSS5/ckzDv+QdivD0A=;
        b=WR/B5MMc/CosmoF2c7kYO/yoQgTNdgkGDg4VNuKkwFc73VnLxWbYryT1SVFcZNmU/f
         ZSm6grMO18gZjDWkXrrsSeqjB+Wi0DYf+IWqsje/3UJp/caH+GGxZaX16ZgF1y5Rd0pv
         m570jgyVXbSS1jnbgJXG76hyNTwJczT6q+uAqNOu4jYnJAaI3U9BXWUgYxu36Ql8HSZX
         c8CXylrUDUFsiPsTxPyjIRzfu0/eqZsals922LRwG3ZUDRBxzgQOfgy3r5AnGiLe5BO2
         7HnetHs/1uPYfGCYVCkm8ADL1+SjF4iT/upmSkuPsRcwXmDzLDBenQrcq6cthjhiYMr7
         lxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719340895; x=1719945695;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3AMwpyokpH4GrRlIkNJKRT3hzfSS5/ckzDv+QdivD0A=;
        b=UpVhstFHoJ7P44J7fn8EqLhahaXF6XtnxgnE3xbwIO+l3UiSThJMxMyLInHnuTrUxH
         35xfBdYwxtKehY7MgAPSJmAwCkWkj4WBS7CtqplpbhI/QIjXr087sq52LjPZVi4bHqDl
         fyGAGq4Yt8FWzRGUIYVHyb3rUOzech5vJm3YTmgkg3F5afaoD+w24MLQfDo17DjC+iwC
         P3vC9jDpzNgg8HbgX2hbBtCnRZSHVKWgCHx6H/rcMi66Z4lAf+MPAHBLMX2H4qwtRu6q
         lpGe+UAJKV3PX22vOr5+01nSH+SXI3esD2enBliyHSUTKcjoly5vOGbZDmYCucjtWHzc
         NOiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEK+DpmxbMyMNpb8GyznVWLuu53yp8RFCUPOajZ7XR+rFlCHz0zRFvRUuRhJd9+umeh7ZdvUEjc8xydL2nCcNP8J9VreYYwC2cPCrn
X-Gm-Message-State: AOJu0YwrrpuZckcNHJg+WMTKhFkBG0fJw6ViS5xoOrvndoJroTAw0ifS
	7JtamI1z3Nbg1PwdLWdVTFFp4TiwQnaDZYcg8tYBoguGA1+UwFUe
X-Google-Smtp-Source: AGHT+IFTKaLZfKRwqmnD0pPplmH1O0EeZarT8/8Dq/I0YrKP9ivYuQoFSE/W/ZocNdrN0bR+16uSPA==
X-Received: by 2002:a05:6808:16a1:b0:3d5:1f50:1859 with SMTP id 5614622812f47-3d545958344mr9090166b6e.6.1719340894751;
        Tue, 25 Jun 2024 11:41:34 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d53886a628sm1826106b6e.13.2024.06.25.11.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 11:41:34 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Tue, 25 Jun 2024 11:41:29 -0700
Subject: [PATCH] bcachefs: Fix shift-out-of-bounds in
 bch2_blacklist_entries_gc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240625-bug1-v1-1-9344c68582a7@gmail.com>
X-B4-Tracking: v=1; b=H4sIAFgPe2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDMyNT3aTSdENdEyMzC5PkNMsU89QUJaDSgqLUtMwKsDHRsbW1AAGxHXV
 WAAAA
To: Kent Overstreet <kent.overstreet@linux.dev>, 
 Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org, 
 peili.dev@gmail.com, syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719340893; l=2371;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=03Ii5ZBqcDwAxJr2sGNb78vUVrsKGjNeIgOrc7Ld5k8=;
 b=5+5ziNc8NseuXKZA52LqOO6Ksmth1aDn36am6LuO2UbkNJ3Q36InElEdbAQSdFFAJeYcYPtJ2
 9gjVVOnHNapBWNGO57CqlJ9rRNtfllw2AlpsEjR17yB32CJz5K/zwWG
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

This series fix the shift-out-of-bounds issue in
bch2_blacklist_entries_gc().

Instead of passing 0 to eytzinger0_first() when iterating the entries,
we explicitly check 0 and initialize i to be 0.

syzbot has tested the proposed patch and the reproducer did not trigger
any issue:

Reported-and-tested-by: syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=835d255ad6bc7f29ee12
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
Syzbot reported the following issue:
UBSAN: shift-out-of-bounds in ./include/linux/log2.h:67:13
shift exponent 4294967295 is too large for 64-bit type 'long unsigned int'

This is because 0 is passed to __rounddown_pow_of_two(), and -1 is
returned as an unsigned integer. In 32 bit system, it will become
4294967295.

This patch fixes the issue by adding check in
bch2_blacklist_entries_gc() to avoid passing 0 into eytzinger0_first().
If we found out t->nr equals to 0, we directly use 0 to access the root
of the list.

Tested on:

commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1191153e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b9ee98d841760c
dashboard link: https://syzkaller.appspot.com/bug?extid=835d255ad6bc7f29ee12
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15ca4301980000
---
 fs/bcachefs/journal_seq_blacklist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_seq_blacklist.c b/fs/bcachefs/journal_seq_blacklist.c
index ed4846709611..1f25c111c54c 100644
--- a/fs/bcachefs/journal_seq_blacklist.c
+++ b/fs/bcachefs/journal_seq_blacklist.c
@@ -232,7 +232,7 @@ bool bch2_blacklist_entries_gc(struct bch_fs *c)
 	BUG_ON(nr != t->nr);
 
 	unsigned i;
-	for (src = bl->start, i = eytzinger0_first(t->nr);
+	for (src = bl->start, i = t->nr == 0 ? 0 : eytzinger0_first(t->nr);
 	     src < bl->start + nr;
 	     src++, i = eytzinger0_next(i, nr)) {
 		BUG_ON(t->entries[i].start	!= le64_to_cpu(src->start));

---
base-commit: 563a50672d8a86ec4b114a4a2f44d6e7ff855f5b
change-id: 20240625-bug1-42684cf9d7ed

Best regards,
-- 
Pei Li <peili.dev@gmail.com>

