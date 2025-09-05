Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489B230D35
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 08:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062597; cv=none; b=gCH4N1W1KmT+apEYELAiJiSi348k4Yl/EyWGRUWWMJOxMszKdUojM34P2uMV6ZNrXQTLmeeLUJ3jECiAiVB7Nizot52YP9yYvV15gNG9xgp3sh0sz4gdDJ3CDS7B0G4YcHqXmnUlfiIE6X9xkref46O5lY9/rVmXRtYCIUVcP7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062597; c=relaxed/simple;
	bh=+T8NOI6Zv4wcxfohTwV1+3xnH7VfvfWZyIpyrCQB4GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxsUWOSp8K/UO6HOWCbIx4DIrtZm/WZ/6e/ALe3G141suwuyOu2xHA9Di6OjEFUw49NMRHenVVAoXfZmC1ZSC5tXmzfGOKDSOdhDSPgXWPAgt8CAucF51uBE3A70PgRdrChAamM0fj5ir6UzZrpw4zmtfXClDVu6InDqn3AAhl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=drVz4iOY; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="drVz4iOY"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so1390322f8f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 01:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062594; x=1757667394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGB+Qhk7R+OYFlkgwfQcrSKwGrnqjIMBZvbPxHWeZM0=;
        b=drVz4iOYS8qtwlKY0YbRg4GRTeMWcZ+emVqA4oxl0mGZ5yNHnDnS6hENcsyMxFN8nJ
         JZvUrSv3MttN3emTIOlLvdiGxxkQ9q71OTPN3bWbu7JhF+/+UeY/UBLRodJWb8eJpXhR
         /0jXFcrnolvgKcVccxSi7aeexhhAWVAWE+O7gsPRg9HzJNKDS4Qt5CG9UJ8F6LkvGrZZ
         3K/wJIYpJxysbMWvSjb7DJX9ChuSbs+RStITTCXPLFD0OvzPc6Prj2cwEv6g4KsBFfuO
         TmzUP/jW/vYVfj4jV5oQ9MyLq0KhvzBHh4Jn/9zkks1OcTyT8FU17KNCrKnGujDnWW7X
         ybGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062594; x=1757667394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGB+Qhk7R+OYFlkgwfQcrSKwGrnqjIMBZvbPxHWeZM0=;
        b=QJpYvwrkSG91Y5l+wp0yVsTY8+O0BrtljPa4kt56wb6ChJqvRASB2tNqEGfTONMihM
         Yi9gpEIOAK23dR20VQjG97Iup8vadxa0wiYUnnxP6ZDkfvtU93EtApwrJXikehBgIfSL
         o/2eInAmg+on2KUfq1M1+r4qdNvcymSXH7cRnpTBTdgokS/WoYf23iTAKChBC3xhvqC1
         C3JJ7cSK3Ql5hjriuZS/eK2Gq52xxbzeyIf+qZ74gGfMMW+VUY9P5B/3Iij8+fKydMR5
         OXzoR0X68VwPhjy6WqnlSGDNHxWBpbzm6PTll8Qnsa3qEfzdbX76YcQWH2orelLZhzke
         CI3w==
X-Forwarded-Encrypted: i=1; AJvYcCVn78fQRxul+ysM2OC+nmxpIWhGlX3PATybCSw2TcwaytumPeupdRigc9Rrumw0IlqAr26v7//9SVnIOhWbgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1MaEoCXM2AE/aHF4ZbyI0yMQLQfNrM8u6Gma/RWnurJviOBH0
	cYQ9pIKiMJtWxCcFFack8NJoTFIpaaDU8sIQsRQE+YF3zwNpX6FArXaFJGeJPil850Q=
X-Gm-Gg: ASbGncvGK0iImbZPpCantapIc1SB2MGka+iPQOqugORcsPfZJRh0Q1RlDSnnuOJN7gc
	02O0fK62v4zqNUKjkFFNgbtKmI9i3fNx7CmdNtirRsTD6ocW3P7qyuyttP4AC//QpctpI38q3hV
	n+GskdcQgxPQiFyQqAwSELAEGVPRIhBWUxov5sDQ2ph9ygYzg2rhw9LR1qluyvoP+5VWagxzrzf
	va2dwQrZuxdIYUk6jshWQi0R3CHJtEShopFSOGuKyYXvIt2mBuA7qezw7JjDPyBjwCVSPVhTxhk
	J5PGthER0Lf7+jChfLCz8mhyL/KfV7IAx7OQ+8VljtQVXNuB+vf/OCSuHK/BQLKYGwBtSTfPlnZ
	4Obn4QHiyWJk7R1HzX81FrLnJr5Q06MjMtDdkOciPo1z4ZFJ/xFV5hGZeGg==
X-Google-Smtp-Source: AGHT+IGsa0rp5MHa6kNBT4cj8hGWuR9YR74ee3KpeGkEs3kQ8djeneHdrXuQs+57ETnPU8KAwAJ6hw==
X-Received: by 2002:a05:6000:2305:b0:3e4:bd77:df12 with SMTP id ffacd0b85a97d-3e4bd77e146mr269918f8f.18.1757062594051;
        Fri, 05 Sep 2025 01:56:34 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3da13041bcasm14617492f8f.35.2025.09.05.01.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:56:33 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/1] closure: replace use of system_wq with system_percpu_wq
Date: Fri,  5 Sep 2025 10:56:25 +0200
Message-ID: <20250905085625.97367-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905085625.97367-1-marco.crivellari@suse.com>
References: <20250905085625.97367-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

system_wq is a per-CPU worqueue, yet nothing in its name tells about that
CPU affinity constraint, which is very often not required by users. Make
it clear by adding a system_percpu_wq.

queue_work() / queue_delayed_work() mod_delayed_work() will now use the
new per-cpu wq: whether the user still stick on the old name a warn will
be printed along a wq redirect to the new one.

This patch add the new system_percpu_wq except for mm, fs and net
subsystem, whom are handled in separated patches.

The old wq will be kept for a few release cylces.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 include/linux/closure.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 880fe85e35e9..959b3c584254 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -58,7 +58,7 @@
  * bio2->bi_endio = foo_endio;
  * bio_submit(bio2);
  *
- * continue_at(cl, complete_some_read, system_wq);
+ * continue_at(cl, complete_some_read, system_percpu_wq);
  *
  * If closure's refcount started at 0, complete_some_read() could run before the
  * second bio was submitted - which is almost always not what you want! More
-- 
2.51.0

