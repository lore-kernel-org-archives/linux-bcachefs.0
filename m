Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD571DED47
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Jul 2025 02:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751338665; cv=none; b=urS1450SM1NCv1npBO6/amHOwmYB0O6N9FWpaRnRY9GQq3an+O4uUq+0TPMah8Q1Pxr5REiGnGQY658GAUFr/ujWsqAQtyvURmO9hX3z3Uvswqku6/X5tnv6iKjMeR6fxT8Qn8+3YEk1lrq3vxQXIhcjsbuQuBF0vhjeeWhZCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751338665; c=relaxed/simple;
	bh=660RTuWSZUv1o9YIDhF3FUQy876ScbpYHBpQf1XvoMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NxwzCX3NMoPbNq6gzOCC4ot36faBsBcbHsDV+M3LljC7DPTi6AZ+HSLLHCn5ukuIckkmK2xy9TyYJKcd+Ysu1gClaxnwltsdtjivgsIlWyAb1waOSWJX4DVAmHyt2piIoSj8PSPd2si1OeVzGJAz/jbyc9aVM/yQOVn88Zgd9Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=muJzkZ7b; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="muJzkZ7b"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7481600130eso3561109b3a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 19:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751338663; x=1751943463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gzbVoXGFIt9KBx66S0VrYv9duydc3Tpg0h5JEyZAb+8=;
        b=muJzkZ7bhsVwoMMbCMSiKqydi1o+v8UTh0WbSx42elGwrYypNcKVPanxsJFv0XG4xS
         pfZcqXB18VZ4r+1O+7546lMY+7Im54ckSNuRmtYUcGNW9qO8tNlzBrFeyjYYy8ZpGz9o
         UKCbQMGZ7uOll6SQl343dUqdYvEAxlbg9vgi1SSarN72qGeJ3UmA9palbVyoKD5FNWNc
         LhpHvfeHF97iVffejR5IMrCXS+URDs0SyFg0XqTy1tk8wHGBbaF4jp/9hNa5W5UGn115
         mk7r0HG7HeQBjSyV+WNv2H7QPwr8aAHlHEkptBOTLSDwBkuGJb0M0kPVeNUd7ZYTWm3N
         AzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751338663; x=1751943463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gzbVoXGFIt9KBx66S0VrYv9duydc3Tpg0h5JEyZAb+8=;
        b=uN5XFTwa46R62PBcv/1fSg0Wa8JGetd5bd7T5zrn1NG44We4NEA+qoypFvEeYhrziR
         92qfMLifYL5zzYqScKS6do42djb1IKpkdWGR9PMW4i+FJoxPUS7TxXTqaEnT71idv+Q0
         HljbFC1YcT/nlu4OZya9qPePR2oZuHl7TezhjDMtvVFI0N42CHbueJ+1shEBCxRzcAtK
         +pU2ygOJasERD5+ydUda243ggYuHArOx1ETfz49u5L7uBUbSZO4dFYAEf6ogJBfV5Ca6
         EQxkuyZ+Lj2qQsVGbB6VTL+Jp8RIAN0iXAeGmBXCaFmwWDsyhe5QM+SI6MpwLM9zeFmk
         RanQ==
X-Gm-Message-State: AOJu0YyDhNcwAe7gZUF3EMfns5L7p1NHcCs6toFmsWmtobpDexVUAVwQ
	RLyFZFo9P7H51TXFg1yNje/ZyXAQeEI4lGV2dO7h27RflZpU7HsN0rdw
X-Gm-Gg: ASbGncsLM5huTSUgbjEtmn2wxT+6ftcUv6kt2zCwOHOugjv80vRexoxwtb3KCSjnczd
	Wc3ue0OF+4/LlQc7/utfv86SxhUVCOuC37h+LMjIEdM3aKGEzCbavVT/gZnt5HtYJVpG/gUqDlj
	xJJ6SMZs6pHs7Uw2jWFG3a1DYWYEIiXvaimee34DBt16vv8s5bPYnvNl7Cb5FJdg/RuBP5aei0Q
	04WRQyRFtxjj2WNDm2lslgpf5faGnHaMKGHprb83mX4PM5ZZR8eloq9gnu0/6N0HMzzFseHABNK
	m+WFy9gpDMkYdsX1BPCkdWjJwlHUJdltPtvl
X-Google-Smtp-Source: AGHT+IGQeqi4axIhGc1j5tsjgQHCvL4oq/yT7z96+v7x6gAr4JOzQUg30CAe+BEcVrBlzx17WYA0ig==
X-Received: by 2002:a05:6a00:2d25:b0:748:e1e4:71d9 with SMTP id d2e1a72fcca58-74af70a7d37mr20399343b3a.22.1751338663389;
        Mon, 30 Jun 2025 19:57:43 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af541e797sm10396889b3a.55.2025.06.30.19.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 19:57:42 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Don't lock exec_update_lock
Date: Tue,  1 Jul 2025 10:57:38 +0800
Message-ID: <20250701025738.46423-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

exec_update_lock is used to check permissions, no need here.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/util.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 05b40debf211..7a4436fd4441 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -299,17 +299,12 @@ int bch2_save_backtrace(bch_stacktrace *stack, struct task_struct *task, unsigne
 	if (ret)
 		return ret;
 
-	if (!down_read_trylock(&task->signal->exec_update_lock))
-		return -1;
-
 	do {
 		nr_entries = stack_trace_save_tsk(task, stack->data, stack->size, skipnr + 1);
 	} while (nr_entries == stack->size &&
 		 !(ret = darray_make_room_gfp(stack, stack->size * 2, gfp)));
 
 	stack->nr = nr_entries;
-	up_read(&task->signal->exec_update_lock);
-
 	return ret;
 #else
 	return 0;
-- 
2.48.1

