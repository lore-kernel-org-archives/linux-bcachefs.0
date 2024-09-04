Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9C91E8B97
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481782; cv=none; b=G9IswbPC2XHXBI9vVBO6jdTQRU6O8tGVsLPEYio6loGOA7Yq1AQLSB+NV5jmC0wqFIUEufGop9nucOfQ5ivh+oOt0RKkbth+rfXK/JdX62/BcVpOFXT48HeT7UIUlApwyK3gXLrX1G0u6g331nf7FcX1pe1qZXgYjGSSKSSWuaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481782; c=relaxed/simple;
	bh=v+fnUlVkBveqAbvI7nBD4gzaysdb8UjtocYcN6UQfDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7MdXFYDaYW+5zloqr3qUDVI1GgvcInUJL0y0qHq81CGE2esDZ29CUvB4kJy2DPXs6fHHqwNF6hBilSdfAqxueQqmX+eayHm8xHVO/yQan8QffHjdYY/G/lDfJcE04HOQYnU6r6S6klzei4vNrqBvNcoHNvMTyED0JTxk1V2O1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=xozlLTnA; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="xozlLTnA"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6c35334dfb1so182326d6.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481779; x=1726086579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWEHhx5O7UFZKYepru/YJGo3B9Ht5vMlNzII31DWFDk=;
        b=xozlLTnAjOeOnOKBTmkEKY5eiNLyE1DduiUA6ApFLdwrnnvNFW1nGyubeZi+xjwymX
         C4qovljpGP7v9hCBKEe66utga9gbgkPNgls1hAucRI3DGMQ7wVf7ZdfWfxm2EeRwxTK/
         rb7w/8gMh+e2Bt9XBgFDDrnL9tBGOY6cMgHQpFe4J0KMtRQ6uGZY2qUErkA1aEJyYnAE
         sr+0/XNRKG0Lc7tSg9WV5aLIxBSWkjf1zmsxeFXP0E6T+evTvA4VVTQuMyIrrnAXQOUf
         L2820uYw7Y06pf5Gq01lZqyjnNAuT9oKF4B6CUJIU0mkG49qIM3OkLJsjM+bLOrNSAOi
         3twg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481779; x=1726086579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWEHhx5O7UFZKYepru/YJGo3B9Ht5vMlNzII31DWFDk=;
        b=EPqGJT2O95n764XEsvp9AtDkA9zUCNHjz2Wd99oPZcPHJHmGNZ2iIzK685SPg50w2s
         RKALdfL5jvN+9UJLz7aLijvl2KD+wZFjkSQNDmrMn2jxR7jskPGMEcqdjGto4HxKT6tg
         aSuUbfq1mLf9JRExzt77IzI++i7DYWMXzGW92kGC76/dbBtafOB6kbzrtj6ItCKupjOB
         uERc4TrFwcITNkayBrBGXsnLdiFGI+c6RYa8NNGO1gKpvsMrI8wQAiZnOkt6NTJ+usgb
         bi/OVKPQo+DrO+eYZo8AfqXdt/HSd/HSUaTWRiObaXiQpMJ97ZkNHT+DuozU7z60TAg0
         mvJg==
X-Forwarded-Encrypted: i=1; AJvYcCW6Au35s/opTmZrtM/NTwX3tOXsZNMENeZgZlbKih2GkyxMr0t4msfbdqGCJAKDGp9Z4I6qYS3OVb7HltAOAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGzYjJo6mEB6YzSzDE91UgjNKCjeziAuCY039h9JeVMrGlWjVy
	F4OpM85uude7Sq2P6DiuyCNcr/nFn4rc9QusEdwuockMlwW8zCVs5asj7aAiqKk=
X-Google-Smtp-Source: AGHT+IGNwdiKO4Frv0IpCUzBFB05rGHrErtdGiSxtnVsPoIgc9Az5OOPtCc2jc4JjLzRxF9YRhdyFw==
X-Received: by 2002:a05:6214:498b:b0:6c3:5c0e:2bbd with SMTP id 6a1803df08f44-6c35c0e3262mr134228936d6.50.1725481779673;
        Wed, 04 Sep 2024 13:29:39 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c52041874asm1535256d6.113.2024.09.04.13.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:39 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH v5 15/18] bcachefs: add pre-content fsnotify hook to fault
Date: Wed,  4 Sep 2024 16:28:05 -0400
Message-ID: <89d4bd31a6faa634b9de4cb486498601f042bd7b.1725481503.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725481503.git.josef@toxicpanda.com>
References: <cover.1725481503.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bcachefs has its own locking around filemap_fault, so we have to make
sure we do the fsnotify hook before the locking.  Add the check to emit
the event before the locking and return VM_FAULT_RETRY to retrigger the
fault once the event has been emitted.

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/bcachefs/fs-io-pagecache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index a9cc5cad9cc9..ce7968e4fd2f 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -570,6 +570,10 @@ vm_fault_t bch2_page_fault(struct vm_fault *vmf)
 	if (fdm == mapping)
 		return VM_FAULT_SIGBUS;
 
+	ret = filemap_fsnotify_fault(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	/* Lock ordering: */
 	if (fdm > mapping) {
 		struct bch_inode_info *fdm_host = to_bch_ei(fdm->host);
-- 
2.43.0

