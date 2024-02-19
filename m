Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2207F374F9
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351393; cv=none; b=gRBIkVCJxR2/TfH4AdXdec8QMFahueyE/5UPZg0iTiScttEHij0YO2gUj16mU7FcCK9cpEytFM+DIGuTdQto+tgrxdSRCzbRz0JoRkDYdZqKwQMxHPUryeJmccpgKcfE3irjUxtEr2cfJbtTxUpU1SK4nmuEoxVCXCkka+g7/wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351393; c=relaxed/simple;
	bh=HcxrUWrSBicqV56JnUnlltio7+4EuCnfjM1lBvWwRSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya1wR9TZN37EHp36ZST+ctqkHGF6uVJ1KgyEm1jqJlQIVWGVfDRcvAEmq94WShPY+1AHebhkV25ZmbAbfhnSzEFM83tbHuQecpeo/osRjOQTpgUjjbZQyp72+CO3QyBbI0u3vvR1yEoWyI9PKCLzzm+I8VtpRLv61vhLVN1CgcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=P1AOpB7d; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="P1AOpB7d"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d918008b99so35321135ad.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351391; x=1708956191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQFubVxTPQWg56vs5guERdl/PWDUBVj7saqDcYch4uY=;
        b=P1AOpB7d5bxbDIASMCxCmTTnL1hHxY0HrFUmBMGVhPGjj+30FQHu6vawgUftF1qvVu
         kGgrfGILOXSaBf5vUY8RelAcLz8+wY3Elt91dnn9xGndX6D01bzHGuPJwZTfWjUcFUAc
         Rk27i3HSQ5eppWVi56I0OXSXfDmzL3B28c3N8Aq8bWNAhKhzY4T1gUNVjuzkF6gisYBS
         7lnBa0jc8eLGW1RNm7sAWaLDysUo9CqLJgiXJY5rT0SkU7ZeySzMjyOKKkMDG2ZtJN88
         h2vwksKIStHY9QHFoBLa3/HZzwOsRI8PLBTjyYCe5y/jxoq21M8t+ujhtmZrj7NrQYo9
         NDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351391; x=1708956191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQFubVxTPQWg56vs5guERdl/PWDUBVj7saqDcYch4uY=;
        b=JcwhIvwozUuFs5/W3XjIYcNTimW+MI/dCbc5AnzVmMb5LS6Y9hVK1zZs14xdM4o/TR
         wu8Woi+DhuiQeJcm9tudUVRaItYxCTTu/qEVxNLI6T3E97L+3JlpW/MRZ/JzOH0f3SAV
         wa/Hr6U5t6cY3XhtlHUcQhDg1bu2FV6ycJxOfPgV6FOMDNPUhViCDqCvDkCNS4tPtGbe
         akv3DgyueqA9mJ9MNATILsn8hxT1gMG3JKNSVOnGdydca13u3DGtWF6KhwKRjZspYLl4
         Bx/QsjxFUNbR0s5pfsOahzJ0oJ70Mkj0RL9xKaH1WyiF2yvHnyf0K3QbtWENNS+Rll8w
         W/tA==
X-Gm-Message-State: AOJu0YwgqsdmUD5EoEFvVfk2UEgPY9bLnF0En0gleU7FNnOA7WIc9vlv
	mQ7DzpU82iU+Tqrt8bKfoHSIQw0y3VRVphWqm6YS2JOhM6VbRbuu6hiwubi5sWaZw5zt3ctu2+j
	Q
X-Google-Smtp-Source: AGHT+IGUFRcSZ+ClF+DUbDqx6KweyPgO77k6j6OsIHXFxOj/iU1AWTUYSI9XyYFWdZ7GDaz50wBRjQ==
X-Received: by 2002:a17:903:8ce:b0:1db:cca9:f751 with SMTP id lk14-20020a17090308ce00b001dbcca9f751mr5700965plb.59.1708351390717;
        Mon, 19 Feb 2024 06:03:10 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id kj4-20020a17090306c400b001d6f29c12f7sm4456722plb.135.2024.02.19.06.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:03:10 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 3/3] bcachefs: improve copygc tracepoints
Date: Tue, 20 Feb 2024 03:01:58 +1300
Message-ID: <20240219140230.897597-4-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219140230.897597-1-daniel@gluo.nz>
References: <20240219140230.897597-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/movinggc.c | 11 ++++---
 fs/bcachefs/trace.h    | 69 +++++++++++++++++++++++++++++++-----------
 2 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 69e06a84dad4..7ecb3009bed3 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -188,9 +188,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 		ret2;
 	}));
 
-	pr_debug("have: %zu (%zu) saw %zu in flight %zu not movable %zu got %zu (%zu)/%zu buckets ret %i",
-		 buckets_in_flight->nr, buckets_in_flight->sectors,
-		 saw, in_flight, not_movable, buckets->nr, sectors, nr_to_get, ret);
+	trace_copygc_get_buckets(c, buckets_in_flight->nr, nr_to_get, saw,
+				 not_movable, in_flight, buckets->nr, ret);
 
 	return ret < 0 ? ret : 0;
 }
@@ -208,6 +207,8 @@ static int bch2_copygc(struct moving_context *ctxt,
 	move_buckets buckets = { 0 };
 	struct move_bucket_in_flight *f;
 	u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
+	u64 raced = atomic64_read(&ctxt->stats->sectors_raced);
+	u64 seen = atomic64_read(&ctxt->stats->sectors_seen);
 	int ret = 0;
 
 	ret = bch2_copygc_get_buckets(ctxt, buckets_in_flight, &buckets);
@@ -247,7 +248,9 @@ static int bch2_copygc(struct moving_context *ctxt,
 		bch_err_msg(c, ret, "from bch2_move_data()");
 
 	moved = atomic64_read(&ctxt->stats->sectors_moved) - moved;
-	trace_and_count(c, copygc, c, moved, 0, 0, 0);
+	seen  = atomic64_read(&ctxt->stats->sectors_seen)  - seen;
+	raced = atomic64_read(&ctxt->stats->sectors_raced) - raced;
+	trace_and_count(c, copygc, c, moved, seen, raced);
 	return ret;
 }
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 51a1f47b310c..3876be978958 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -923,32 +923,30 @@ TRACE_EVENT(evacuate_bucket_finish,
 
 TRACE_EVENT(copygc,
 	TP_PROTO(struct bch_fs *c,
-		 u64 sectors_moved, u64 sectors_not_moved,
-		 u64 buckets_moved, u64 buckets_not_moved),
+		 u64 sectors_moved, u64 sectors_seen,
+		 u64 sectors_raced),
 	TP_ARGS(c,
-		sectors_moved, sectors_not_moved,
-		buckets_moved, buckets_not_moved),
+		sectors_moved, sectors_seen,
+		sectors_raced),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev			)
-		__field(u64,		sectors_moved		)
-		__field(u64,		sectors_not_moved	)
-		__field(u64,		buckets_moved		)
-		__field(u64,		buckets_not_moved	)
+		__field(dev_t,		dev		)
+		__field(u64,		sectors_moved	)
+		__field(u64,		sectors_seen	)
+		__field(u64,		sectors_raced	)
 	),
 
 	TP_fast_assign(
-		__entry->dev			= c->dev;
-		__entry->sectors_moved		= sectors_moved;
-		__entry->sectors_not_moved	= sectors_not_moved;
-		__entry->buckets_moved		= buckets_moved;
-		__entry->buckets_not_moved = buckets_moved;
+		__entry->dev		= c->dev;
+		__entry->sectors_moved	= sectors_moved;
+		__entry->sectors_seen	= sectors_seen;
+		__entry->sectors_raced	= sectors_raced;
 	),
 
-	TP_printk("%d,%d sectors moved %llu remain %llu buckets moved %llu remain %llu",
+	TP_printk("%d,%d sectors: moved %llu seen %llu raced %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->sectors_moved, __entry->sectors_not_moved,
-		  __entry->buckets_moved, __entry->buckets_not_moved)
+		  __entry->sectors_moved, __entry->sectors_seen,
+		  __entry->sectors_raced)
 );
 
 TRACE_EVENT(copygc_wait,
@@ -973,6 +971,43 @@ TRACE_EVENT(copygc_wait,
 		  __entry->wait_amount, __entry->until)
 );
 
+TRACE_EVENT(copygc_get_buckets,
+	TP_PROTO(struct bch_fs *c, u64 nr_in_flight, u64 nr_to_get,
+		 u64 saw, u64 not_movable, u64 in_flight, u64 nr_buckets,
+		 int ret),
+	TP_ARGS(c, nr_in_flight, nr_to_get, saw, not_movable, in_flight,
+		nr_buckets, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev			)
+		__field(u64,		nr_in_flight		)
+		__field(u64,		nr_to_get		)
+		__field(u64,		saw			)
+		__field(u64,		not_movable		)
+		__field(u64,		in_flight		)
+		__field(u64,		nr_buckets		)
+		__field(int,		ret			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= c->dev;
+		__entry->nr_in_flight	= nr_in_flight;
+		__entry->nr_to_get	= nr_to_get;
+		__entry->saw		= saw;
+		__entry->not_movable	= not_movable;
+		__entry->in_flight	= in_flight;
+		__entry->nr_buckets	= nr_buckets;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("dev %d,%u buckets_in_flight %llu nr_to_get %llu saw %llu not_movable %llu "
+		  "in_flight %llu move_buckets %llu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr_in_flight, __entry->nr_to_get, __entry->saw,
+		  __entry->not_movable, __entry->in_flight, __entry->nr_buckets,
+		  __entry->ret)
+);
+
 /* btree transactions: */
 
 DECLARE_EVENT_CLASS(transaction_event,
-- 
2.43.0

