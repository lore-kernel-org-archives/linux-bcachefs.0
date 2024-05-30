Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB02C12F5B7
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100140; cv=none; b=LeRucwGJQsNTdF/yDYN7vNW5ixmGtpVkb6KUJ9JPbLAb8kURIqbjMXZteJqEw02Sn7g16d8jVFRqJJuyjWDFMR/9yE9BVZZ2KQOqJ3w5+KrA2Z3Hz6k8JoSugqUTy13Zy26ARvemTZLvfdeVG9q1L10L2tdOvP7oTn/dOeF52Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100140; c=relaxed/simple;
	bh=MarH1PUuT3WRvTHzEKaaYBPBr4o3GTFgxBgfE+lpWwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uIxywumKeigR98AHf3zm6LXPfvgYaixdufDb4JP5HqE4efRxADKPF8UNattG5A+oNBDxOkh8Hzv8ONdew+OoiCJL+SUWWkyxq+rsyuuHAi/Zx83Krxv+whkrW+Rqow1nsuxccfqS/Nf4iyUlgQ/vVTgNuqCeoYPPbpLE/TpiQME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JboT9bCT; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JboT9bCT"
X-Envelope-To: linux-bcachefs@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717100137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FOZzjrv/8amjZcTXPh7p0KOHKZ8c63/G7hdJs/VkUVA=;
	b=JboT9bCT+lEC2KUyw0s9XZ1ElTXluKqzWsfb2cTV4A9zkSrMCwb4u29aheSmRG/pEjRqfP
	OpGcARlxvSmrezUw4cVAeSHiMU1/r5hX0PIBOwTuxTmX8rqdlnN8Ct5l2HfB5MhHhy/+cd
	2/S/aoa+7XlIUYAIxnwnlPjPm2G4Gtk=
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: kent.overstreet@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: axboe@kernel.dk,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] fork: Export create_io_thread()
Date: Thu, 30 May 2024 16:15:27 -0400
Message-ID: <20240530201528.426768-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

create_io_thread() creates a thread for doing work on behalf of some
user process - export it so it can be used in thread_with_file, which
spins up a kthread connected to a file descriptor.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 99076dbe27d8..fadf08532327 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2744,6 +2744,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 
 	return copy_process(NULL, 0, node, &args);
 }
+EXPORT_SYMBOL_GPL(create_io_thread);
 
 /*
  *  Ok, this is the main fork-routine.
-- 
2.45.1

