Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7617D346;
	Tue, 25 Jun 2024 20:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719345913; cv=none; b=sDlP3TBLlLSnObKN3CgpozyvYYcZuyhTqMYrkaN0i0aeOV8MKPlzKTPEHR/cSXhXGfK9PQaOF65a79K5J4V02vjI3POe91j17j/Org3lQoKNBvWsYhobhdgsJaG2F5mAEZS+yFkVfsuA1ieYpq+VeG/40jXGWxEyi04G0jMHjRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719345913; c=relaxed/simple;
	bh=0/eIjHFbSJyk0/0Ap89b+YtVz3KGN2zbRA630GUuCwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=edyRSCfol1T+y7PRdHeagIc7vW1C7k+PYnd+IEqoKa407arJf68VvW7rOL0W4hPd7Tv3Y+dKugm67rXyIbhvNSMiYnmqF5jnCCVeIQcZ99I6ky/DRj6mo+uUk1NQN5pR1pEUdVXwsClM5vzT8p7Rvoj3kgC6+LDfCsu80cPevO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAbNVICC; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAbNVICC"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dfa71ded97bso4917530276.1;
        Tue, 25 Jun 2024 13:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719345911; x=1719950711; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ68vY/Wke7mDYwV27cHzfcmwfW5Yu1v8buaPnlZQ+k=;
        b=AAbNVICC3fuiSnYXm2PxBQg6UPdEDy/rifoGHKt4DHALOGV5mF2p+FJ06c4Yy7HxIp
         C5Ped8UsIieaQ5wyukxnSBxZZU84HBvBqDbEj8EvjjBFQP/QKLdFp7AsSguZOX7/hQuj
         OtiSo7k4ebprWKb9ROI7X4MQuFRHywbk0Qs2hfyejBH9quw6+MnmNYQguHArW/BKAx9A
         B1yFaTwxh6aarU8UP6iQAzDZN2kzguvNI85zF3mnSsyudZEx1T1RJak/wzj0N+HeIKQD
         46+YDqqZsDQWKT8P3x3BBssjVsferhQ7hK8/Evj5w6jyhSt86GKoHxrpMWo2jO5eXFuG
         MPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719345911; x=1719950711;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQ68vY/Wke7mDYwV27cHzfcmwfW5Yu1v8buaPnlZQ+k=;
        b=OLIZUUFKY/KPaiGA905+O9vjEsmlMtqCnnXplt5UI4DS4tTHL0cpsNiJ46NZDYtRvc
         P5IesZVLnkOBtkm+FAAlOOKxj5UuiM6g3G9BKCQfnG/qLhsK3uViLg4VeT4L5PNzNd9U
         vYJSCVut+h/fa0fPIoRTvxP1woddWtGJ9ukdQK50BCLll6hQGyTCWnThzr2olMzEflRV
         BQyghUOaEaH0fd0MPIJkFx4NQ/MR8jrq8aW0EB0/j5FNH978vqi8NNQCiWNlT1RF1vEH
         q4EblJPSb9W9eYZU9ku9ztRmzHridBUD9hP7ZBPxRQ3EFpycHeuv+hJMUrGweAmIIIh2
         ec0w==
X-Forwarded-Encrypted: i=1; AJvYcCU3KOOiBjBtZAJMuXIqjb4io8xyRVQnm8Q6jXSBAMUrjXIbkYOUZdZwPAnooRBMn/SVHVLNh8oJEtDGsGfZV4tZLn5TlaTPh4+4pZet
X-Gm-Message-State: AOJu0Yxu6O+KDr3xsuKm27AHwVWS+tgurEeJWLTUR6+5jB00xZPre5p7
	daQ627dGROTZrzmwrSrxReG9ERkTsAhEaMiRvTm7HAaedLz3A+Hv
X-Google-Smtp-Source: AGHT+IE/n2wyIQ5QaHIPuAeQh2psTxZU+/wsKad+bYlw4eiZy+bXYQ0sXC9bfdWHErC6SiQ/7h7l1Q==
X-Received: by 2002:a25:d309:0:b0:dfb:b27:adaf with SMTP id 3f1490d57ef6-e031ba98aaamr3691967276.5.1719345910961;
        Tue, 25 Jun 2024 13:05:10 -0700 (PDT)
Received: from [127.0.1.1] (107-197-105-120.lightspeed.sntcca.sbcglobal.net. [107.197.105.120])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e02e65db5ecsm4068349276.62.2024.06.25.13.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 13:05:10 -0700 (PDT)
From: Pei Li <peili.dev@gmail.com>
Date: Tue, 25 Jun 2024 13:04:59 -0700
Subject: [PATCH] bcachefs: slab-use-after-free Read in
 bch2_sb_errors_from_cpu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240625-bug2-v1-1-73f89535d3a0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOoie2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDMyNT3aTSdCNdSxMTA1MjA8Nkk2QLJaDSgqLUtMwKsDHRsbW1AGt2rix
 WAAAA
To: Kent Overstreet <kent.overstreet@linux.dev>, 
 Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com, 
 syzbot+a2bc0e838efd7663f4d9@syzkaller.appspotmail.com, 
 Pei Li <peili.dev@gmail.com>
X-Mailer: b4 0.15-dev-13183
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719345909; l=2706;
 i=peili.dev@gmail.com; s=20240625; h=from:subject:message-id;
 bh=0/eIjHFbSJyk0/0Ap89b+YtVz3KGN2zbRA630GUuCwI=;
 b=U3y/GyRB3kQ6al/p8Qtc5pN7VmAWOyuCTSir8ryZKv1k7hjN/1++/oYwl5jzd3jaMiaVKrcNG
 0IK3cUrVLokCC8EmgozsrfO2cutjgahUgZxKTby3yPKTRcon7qb8EWe
X-Developer-Key: i=peili.dev@gmail.com; a=ed25519;
 pk=I6GWb2uGzELGH5iqJTSK9VwaErhEZ2z2abryRD6a+4Q=

Acquire fsck_error_counts_lock before accessing the critical section
protected by this lock.

syzbot has tested the proposed patch and the reproducer did not trigger
any issue.

Reported-by: syzbot+a2bc0e838efd7663f4d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2bc0e838efd7663f4d9
Signed-off-by: Pei Li <peili.dev@gmail.com>
---
Syzbot detected we are accessing free'd memory in
bch2_sb_errors_from_cpu().

It is caused by race condition when another task is freeing the array
protected by fsck_error_counts_lock.

This patch acquires fsck_error_counts_lock before accessing the entries
and get the current number of elements in the array.

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Tested on:

commit:         55027e68 Merge tag 'input-for-v6.10-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1790a501980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b9ee98d841760c
dashboard link: https://syzkaller.appspot.com/bug?extid=a2bc0e838efd7663f4d9
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1272faae980000

Note: testing is done by a robot and is best-effort only.
---
 fs/bcachefs/sb-errors.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/sb-errors.c b/fs/bcachefs/sb-errors.c
index bda33e59e226..c1270d790e43 100644
--- a/fs/bcachefs/sb-errors.c
+++ b/fs/bcachefs/sb-errors.c
@@ -110,19 +110,25 @@ void bch2_sb_error_count(struct bch_fs *c, enum bch_sb_error_id err)
 void bch2_sb_errors_from_cpu(struct bch_fs *c)
 {
 	bch_sb_errors_cpu *src = &c->fsck_error_counts;
-	struct bch_sb_field_errors *dst =
-		bch2_sb_field_resize(&c->disk_sb, errors,
-				     bch2_sb_field_errors_u64s(src->nr));
+	struct bch_sb_field_errors *dst;
 	unsigned i;
 
+	mutex_lock(&c->fsck_error_counts_lock);
+
+	dst = bch2_sb_field_resize(&c->disk_sb, errors,
+				   bch2_sb_field_errors_u64s(src->nr));
+
 	if (!dst)
-		return;
+		goto err;
 
 	for (i = 0; i < src->nr; i++) {
 		SET_BCH_SB_ERROR_ENTRY_ID(&dst->entries[i], src->data[i].id);
 		SET_BCH_SB_ERROR_ENTRY_NR(&dst->entries[i], src->data[i].nr);
 		dst->entries[i].last_error_time = cpu_to_le64(src->data[i].last_error_time);
 	}
+
+err:
+	mutex_unlock(&c->fsck_error_counts_lock);
 }
 
 static int bch2_sb_errors_to_cpu(struct bch_fs *c)

---
base-commit: 66cc544fd75c70b5ee74df87ab99acc45b835e69
change-id: 20240625-bug2-94405201c4c8

Best regards,
-- 
Pei Li <peili.dev@gmail.com>

