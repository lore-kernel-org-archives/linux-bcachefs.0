Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39EC1116
	for <linux-bcachefs@vger.kernel.org>; Sat, 16 Dec 2023 01:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/qVg5Bt"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9fa2714e828so150721666b.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Dec 2023 17:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702691525; x=1703296325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3cxoxaPrtKsSbYI7asOBZd3GehQsBcvrIo1Wwj0Sox8=;
        b=m/qVg5Btgbes0R/rh7hSMwXflcJHAZDiXTJxH0foXN57MU85+31luC3wMK0GbuKraF
         JWaD8yq6tvwnjANQJYjjjnmTd4TSTQjmYUy/Prb4amvM85YHeGYxCit4ONOeiN/UdA8v
         9U/67PfIEcTuKORvVYfKDeALHNAgECbvdAWBGgeKa/BuFnmWflIxwyYH0Lml9rdKR2aG
         gCr20LESI36IccXWa3c/AJlgwy5JOnhlVAike71eqjNYFHHBBy1O/HPjjLgLV+sdQCPB
         1rFjFYKi6RTMQG4gTFBj6eSgs+5AmVA+JYEMwFGvVltStoMN1R9FF4W1cv0Qhrig8oLQ
         7xjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702691525; x=1703296325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3cxoxaPrtKsSbYI7asOBZd3GehQsBcvrIo1Wwj0Sox8=;
        b=tpQzzLWZh7G5FK+G4dwcoV6rkum17MHRFcRJmMDKYQ133FrtrlZs3JykCZeHK8q7rT
         c6GRultWbVnu/D3mI3wYSIrNZxKGT/zPI5S5ejoR2w1N31E/ZR40WLLo/fT1ZGTEDQ/r
         tgjeTur7ujWJr6l8AzqGlzDIuzMcXT/RBDQYHux8+uJX4yeCYeeJ+S/ynXLryw2VUBdk
         j8j+KEuV36halEeN0iJlfnJoKhrCzAmMvA0l2uQJkgp3xgojyItxkBzVXPUeU25CVYXI
         3Gj+bVOAFfAmVt9xyamXQoFavo2SfjeXqEgjlgUftWZFKvsmCqcrOA/iHpQq30SiH5PS
         RY0g==
X-Gm-Message-State: AOJu0Yyk3bWIPK4bz27VxEdvd5AjELzkdIermx/+n8IKLbZ0oZWv0/A1
	CK96wm8ynKy/TDwfw0ZLoJYlvCIhDWM=
X-Google-Smtp-Source: AGHT+IHSgWfQq4FF+IKQn8u9r3Emmy27jbW7qEtk6yN6ajb49nwHSHwmvuwaSP+oQMI8a0Tm7IkHEg==
X-Received: by 2002:a17:906:3f56:b0:9e5:df25:4b57 with SMTP id f22-20020a1709063f5600b009e5df254b57mr5703916ejj.23.1702691524859;
        Fri, 15 Dec 2023 17:52:04 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id tl12-20020a170907c30c00b009fd585a2155sm11242824ejc.0.2023.12.15.17.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 17:52:04 -0800 (PST)
From: Kevin Hao <haokexin@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>
Subject: [PATCH] bcachefs: Remove unnecessary kthread_should_stop()
Date: Sat, 16 Dec 2023 09:51:40 +0800
Message-Id: <20231216015140.2085664-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the macro kthread_wait_freezable(), there is already a check for
kthread_should_stop(), so there is no need to pass kthread_should_stop()
as a parameter to kthread_wait_freezable().

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 fs/bcachefs/movinggc.c  | 3 +--
 fs/bcachefs/rebalance.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index fd239a261aca..bc1ec877a66b 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -345,8 +345,7 @@ static int bch2_copygc_thread(void *arg)
 
 		if (!c->copy_gc_enabled) {
 			move_buckets_wait(&ctxt, buckets, true);
-			kthread_wait_freezable(c->copy_gc_enabled ||
-					       kthread_should_stop());
+			kthread_wait_freezable(c->copy_gc_enabled);
 		}
 
 		if (unlikely(freezing(current))) {
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index ee452aa51a26..b83dd613e247 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -334,8 +334,7 @@ static int do_rebalance(struct moving_context *ctxt)
 	while (!bch2_move_ratelimit(ctxt)) {
 		if (!r->enabled) {
 			bch2_moving_ctxt_flush_all(ctxt);
-			kthread_wait_freezable(r->enabled ||
-					       kthread_should_stop());
+			kthread_wait_freezable(r->enabled);
 		}
 
 		if (kthread_should_stop())
-- 
2.39.2

