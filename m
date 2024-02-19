Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A61F376E4
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351756; cv=none; b=jA+2DpdJ365K9V2BkAFM+L7VVYPcALqOZuL5vslsC4aMrFaAPtdA1JkxBrSM/7++642Kwvr3Pt3aynSDGDVwF+g9tXliqPDsmzQaGKNl5CfHQ/aIGropDV+TSl6PAPyyN02tqjLLgvSXymgG8hBmjOY+CpOvlZTcasrbJ5zkx/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351756; c=relaxed/simple;
	bh=pNqrCD/XwZigrpg53HcdgHbnsH3p8EI8oqdTekFKxaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA7w6QosqN2ZX3rs1+wQ49xcsa1+wvmAsvjwBQPt/J8P858dIbj4ZK95LYjj6hP9R5VS+AQkIPqbjCCH/v+ajn2D1o74EOqHBQO7K/INXe+rxOhl9CptMQN973U+KMLSqRpUIBkZKhMcqheFfyi78JTqHkbIlkXLRZ1GRycXD58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=A/EpI02a; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="A/EpI02a"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36426a010fdso14998425ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351754; x=1708956554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOFAcmare7JMwhUjRmMuOIIGZ0OIurk96geB8aN6UEs=;
        b=A/EpI02aNc9zraScY4X5RtzPuje64lfyXMFYLo9BFxNvE2FhrosbS89YtkmTTruYYa
         B8fDisHzCvN392MkVqRTcNpr4pa857aRafWsXTtz25ZPgKTriM80x5fBDE/c1S/qA8Mf
         JO5dhVmP1YOCQ3hxLWfd3us5XMI0KZbq2j1IeHPSQB50TU2/LY6VAGpH57mowK7IH/e+
         DDM1lzMBzJEpePC8zs3a+fcOzS0g5xUgL5+Hu/D5WNLoaPsw4h0z1mZD9jsZ05CuQLjw
         0+rcbirinnSFcEc3D8hlDM11buYh7XegLs/NvP7RvaCilkezeDDnc6A7g3G4EFDZlD5E
         OD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351754; x=1708956554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOFAcmare7JMwhUjRmMuOIIGZ0OIurk96geB8aN6UEs=;
        b=OPLQSy5NLxgo4LYjNX6Fwg8oxJiMLfYdYzaHpZ4dxd5DneDD8hIcF1pksySNCVq9V7
         LsmcPJQel7JfN3U0/Ts7VXXxxVjP4Az9DeLmGCMsHrVoHXHn5+IL83F0P40MNxvjNJUx
         wosT5wKo51yEuQ7fGsi2kwF3aVWL6KWVxh0Nr4m4IETU/sxqam8C+XzV39V64DZy43Ns
         KHF03tySh9cH70TDlL0JTc7K1S/24T+ZT7gBbuqUwg9P3RtchzQSDkVCNasB693uMh5A
         uZmgZ/pY/bnR3hyoh1H1v60CwDzOBMx+8tXEVPmBOfiAOvbuuy+HVkika4sS02DbAbU6
         NEjg==
X-Gm-Message-State: AOJu0Yx4HueDigEfAC3HvK3gxKvuAyQIbTHTCcKTKZTBVFjCjnxqatKl
	tlZ5ELeJnpyxdbcyxzMinohyNSZSfFsyw1PyNXWoXUE5H6hfgLt89tIU7yM1CkcSpFHwGeV9OMm
	8
X-Google-Smtp-Source: AGHT+IHjNIad7in/cIIPhtv1SFy4vbezysBkKEvGhY1T/1tQAAJzXGvLXG38O7j63x4ceAeX/qOEbA==
X-Received: by 2002:a92:da06:0:b0:365:1dcb:fb0f with SMTP id z6-20020a92da06000000b003651dcbfb0fmr6276363ilm.9.1708351754341;
        Mon, 19 Feb 2024 06:09:14 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id dq3-20020a056a020f8300b005b7dd356f75sm3973840pgb.32.2024.02.19.06.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:09:14 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 1/1] bcachefs: copygc: remove ambiguity in bucket struct names
Date: Tue, 20 Feb 2024 03:08:42 +1300
Message-ID: <20240219140857.901012-2-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219140857.901012-1-daniel@gluo.nz>
References: <20240219140857.901012-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/movinggc.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 7ecb3009bed3..40139e6d9770 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -141,7 +141,7 @@ typedef DARRAY(struct move_bucket) move_buckets;
 
 static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 			struct buckets_in_flight *buckets_in_flight,
-			move_buckets *buckets)
+			move_buckets *move_buckets)
 {
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
@@ -177,19 +177,19 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 		else if (bucket_in_flight(buckets_in_flight, b.k))
 			in_flight++;
 		else {
-			ret2 = darray_push(buckets, b);
+			ret2 = darray_push(move_buckets, b);
 			if (ret2)
 				goto err;
 			sectors += b.sectors;
 		}
 
-		ret2 = buckets->nr >= nr_to_get;
+		ret2 = move_buckets->nr >= nr_to_get;
 err:
 		ret2;
 	}));
 
 	trace_copygc_get_buckets(c, buckets_in_flight->nr, nr_to_get, saw,
-				 not_movable, in_flight, buckets->nr, ret);
+				 not_movable, in_flight, move_buckets->nr, ret);
 
 	return ret < 0 ? ret : 0;
 }
@@ -204,18 +204,18 @@ static int bch2_copygc(struct moving_context *ctxt,
 	struct data_update_opts data_opts = {
 		.btree_insert_flags = BCH_WATERMARK_copygc,
 	};
-	move_buckets buckets = { 0 };
+	move_buckets move_buckets = { 0 };
 	struct move_bucket_in_flight *f;
 	u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
 	u64 raced = atomic64_read(&ctxt->stats->sectors_raced);
 	u64 seen = atomic64_read(&ctxt->stats->sectors_seen);
 	int ret = 0;
 
-	ret = bch2_copygc_get_buckets(ctxt, buckets_in_flight, &buckets);
+	ret = bch2_copygc_get_buckets(ctxt, buckets_in_flight, &move_buckets);
 	if (ret)
 		goto err;
 
-	darray_for_each(buckets, i) {
+	darray_for_each(move_buckets, i) {
 		if (kthread_should_stop() || freezing(current))
 			break;
 
@@ -238,7 +238,7 @@ static int bch2_copygc(struct moving_context *ctxt,
 		*did_work = true;
 	}
 err:
-	darray_exit(&buckets);
+	darray_exit(&move_buckets);
 
 	/* no entries in LRU btree found, or got to end: */
 	if (bch2_err_matches(ret, ENOENT))
@@ -313,17 +313,17 @@ static int bch2_copygc_thread(void *arg)
 	struct moving_context ctxt;
 	struct bch_move_stats move_stats;
 	struct io_clock *clock = &c->io_clock[WRITE];
-	struct buckets_in_flight *buckets;
+	struct buckets_in_flight *buckets_in_flight;
 	u64 last, wait;
 	int ret = 0;
 
-	buckets = kzalloc(sizeof(struct buckets_in_flight), GFP_KERNEL);
-	if (!buckets)
+	buckets_in_flight = kzalloc(sizeof(struct buckets_in_flight), GFP_KERNEL);
+	if (!buckets_in_flight)
 		return -ENOMEM;
-	ret = rhashtable_init(&buckets->table, &bch_move_bucket_params);
+	ret = rhashtable_init(&buckets_in_flight->table, &bch_move_bucket_params);
 	bch_err_msg(c, ret, "allocating copygc buckets in flight");
 	if (ret) {
-		kfree(buckets);
+		kfree(buckets_in_flight);
 		return ret;
 	}
 
@@ -341,13 +341,13 @@ static int bch2_copygc_thread(void *arg)
 		cond_resched();
 
 		if (!c->copy_gc_enabled) {
-			move_buckets_wait(&ctxt, buckets, true);
+			move_buckets_wait(&ctxt, buckets_in_flight, true);
 			kthread_wait_freezable(c->copy_gc_enabled ||
 					       kthread_should_stop());
 		}
 
 		if (unlikely(freezing(current))) {
-			move_buckets_wait(&ctxt, buckets, true);
+			move_buckets_wait(&ctxt, buckets_in_flight, true);
 			__refrigerator(false);
 			continue;
 		}
@@ -358,7 +358,7 @@ static int bch2_copygc_thread(void *arg)
 		if (wait > clock->max_slop) {
 			c->copygc_wait_at = last;
 			c->copygc_wait = last + wait;
-			move_buckets_wait(&ctxt, buckets, true);
+			move_buckets_wait(&ctxt, buckets_in_flight, true);
 			trace_and_count(c, copygc_wait, c, wait, last + wait);
 			bch2_kthread_io_clock_wait(clock, last + wait,
 					MAX_SCHEDULE_TIMEOUT);
@@ -368,7 +368,7 @@ static int bch2_copygc_thread(void *arg)
 		c->copygc_wait = 0;
 
 		c->copygc_running = true;
-		ret = bch2_copygc(&ctxt, buckets, &did_work);
+		ret = bch2_copygc(&ctxt, buckets_in_flight, &did_work);
 		c->copygc_running = false;
 
 		wake_up(&c->copygc_running_wq);
@@ -385,10 +385,10 @@ static int bch2_copygc_thread(void *arg)
 		}
 	}
 
-	move_buckets_wait(&ctxt, buckets, true);
+	move_buckets_wait(&ctxt, buckets_in_flight, true);
 
-	rhashtable_destroy(&buckets->table);
-	kfree(buckets);
+	rhashtable_destroy(&buckets_in_flight->table);
+	kfree(buckets_in_flight);
 	bch2_moving_ctxt_exit(&ctxt);
 	bch2_move_stats_exit(&move_stats, c);
 
-- 
2.43.0

