Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1420374F9
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351391; cv=none; b=NyH8t0oyIVx5qL+5UUGgYki7M2UK6NtylO/t15iNGiNzOyNWzVhufm4W3a997CZNhfDrv+WdZUHE/4kYrWoPhSup56I8BqxuK9FO9XvCM7RUnhAyHcp0Y2paUeV1eSbxbtxIYtR2GMOfAnL+MYIXGM3NMvbyzTqiA0zkWy7GQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351391; c=relaxed/simple;
	bh=ajKt7ah6hm/WvclI0T9Pd3fLukRGvUn/hLB2drGHp8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKrrShvFjBXsRnSQfVedCGL1VVwAOh57ori0Edu7CPjlPAA16JjUzJ6kWxBMQ7BSRR5AflZucuTqGcv0YlinjYusnblpYnV+OZE92mOv7V6sV3XxH90QCyfEB8MsK10vxOlezruhzwVIW3Sc4ZqOOk/owpc/fsSKym5keUc0OEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=rz9ll/0H; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="rz9ll/0H"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dba94f9201so25253045ad.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351389; x=1708956189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEye9aEzcYZkki9miuyiEn69GBrxs5mPw1bVZRSYCag=;
        b=rz9ll/0Hr8DJGWZlUBZ1tSSMzsdC1yeCL0SWRNXbVR8vfllRQt3NwUgYt4Kz1KGERk
         Kq9jeZcLDigbxGrhmIIBBocmrFyYws5Oe2guMhXiO57/Ar8xvUegyqYjzyTHLqrrxGWg
         LnDwX2cC+aZl1bbYxSdpEfXgQiT1BqgbS3zDebLsRxfjZHbrtJaaByzr413O1Oth3UqV
         bkh/AlgknL6QxiAKqicwuJS7gm0UOnkSHVoR7HowyppkxmQc5SY80DTLBErucJtc3DFC
         aAaJZNOomOoNZxTvOan3Dp5bwc8IzKePIWXivsEdoFSzmX/iTJKBJ9At87RLcUPDxBk0
         omNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351389; x=1708956189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LEye9aEzcYZkki9miuyiEn69GBrxs5mPw1bVZRSYCag=;
        b=XA8PkE4nGDrzSYU1scCasvdzmivlKVIA1wLCgDwRJUOqD7b272T9x2ko3SL+R85Vs9
         rzBYx7eBilDOcvT4uxnZJOFQDotODCFW45j9/rM01PjYDpiDqJUcIKsSMATJW8ZkvrMK
         tnLGSH9S5NfgjQcb4+vrVl+S5AVbQ3lHaIJeQIGYWDMHsAwouPy/wMIIcCHqyUWwfSZR
         rRVFgzC2dJi0/oKx+V+io13tXh24yVhwBIBVSV58iFHwLvCKwlj+QpWOLS7ckOe+dKPN
         3nwyKaP4/StYi0SEyrAh/HSuNx/cvC9fQql1vchoLFzvRI1BmlB08t2aChJbPpOmc0Wm
         SWWA==
X-Gm-Message-State: AOJu0Yxo3o0rNU4CVECSm3P2c2gjMRBkDOBBDz9LrY5/OrYibEbqDree
	BLt7xpJXZAMevIb+8YtBpbaLR7rmLAWYK8gMtSZSDLM/SnqajrxoVsXeipnWWU/0Mt+OHOYTVSS
	x
X-Google-Smtp-Source: AGHT+IEgSIps3YWD9Iv9RMmWyTnUQcRvHxGgVhtH1ZldJQ9HL75zMF7mR/zBqYcD4lfbC/n5hIAu+A==
X-Received: by 2002:a17:902:e84e:b0:1db:de64:ffd0 with SMTP id t14-20020a170902e84e00b001dbde64ffd0mr6904337plg.23.1708351388708;
        Mon, 19 Feb 2024 06:03:08 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id kj4-20020a17090306c400b001d6f29c12f7sm4456722plb.135.2024.02.19.06.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:03:08 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 2/3] bcachefs: improve evacuate_bucket tracepoints
Date: Tue, 20 Feb 2024 03:01:57 +1300
Message-ID: <20240219140230.897597-3-daniel@gluo.nz>
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
 fs/bcachefs/move.c  | 11 +++++++++--
 fs/bcachefs/trace.h | 12 +++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 40a8305b3860..fe8660ed50f7 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -711,8 +711,9 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	u64 fragmentation;
 	struct bpos bp_pos = POS_MIN;
 	int ret = 0;
+	struct printbuf buf = PRINTBUF;
 
-	trace_bucket_evacuate(c, &bucket);
+	trace_evacuate_bucket_start(c, &bucket);
 
 	bch2_bkey_buf_init(&sk);
 
@@ -843,8 +844,14 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		bp_pos = bpos_nosnap_successor(bp_pos);
 	}
 
-	trace_evacuate_bucket(c, &bucket, dirty_sectors, bucket_size, fragmentation, ret);
+	trace_evacuate_bucket_finish(c, &bucket, gen, dirty_sectors,
+				     bucket_size, fragmentation, ret);
+	goto exit;
 err:
+	prt_printf(&buf, "%llu:%llu ret %s", bucket.inode, bucket.offset, bch2_err_str(ret));
+	trace_evacuate_bucket_fail(c, buf.buf);
+exit:
+	printbuf_exit(&buf);
 	bch2_bkey_buf_exit(&sk, c);
 	return ret;
 }
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index f48c727d89aa..51a1f47b310c 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -791,7 +791,7 @@ TRACE_EVENT(bucket_invalidate,
 
 /* Moving IO */
 
-TRACE_EVENT(bucket_evacuate,
+TRACE_EVENT(evacuate_bucket_start,
 	TP_PROTO(struct bch_fs *c, struct bpos *bucket),
 	TP_ARGS(c, bucket),
 
@@ -812,6 +812,11 @@ TRACE_EVENT(bucket_evacuate,
 		  __entry->dev_idx, __entry->bucket)
 );
 
+DEFINE_EVENT(fs_str, evacuate_bucket_fail,
+	     TP_PROTO(struct bch_fs *c, const char *k),
+	     TP_ARGS(c, k)
+);
+
 DEFINE_EVENT(fs_str, move_extent,
 	TP_PROTO(struct bch_fs *c, const char *str),
 	TP_ARGS(c, str)
@@ -902,15 +907,16 @@ TRACE_EVENT(evacuate_bucket_finish,
 		__entry->dev			= c->dev;
 		__entry->member			= bucket->inode;
 		__entry->bucket			= bucket->offset;
+		__entry->gen			= gen;
 		__entry->sectors		= sectors;
 		__entry->bucket_size		= bucket_size;
 		__entry->fragmentation		= fragmentation;
 		__entry->ret			= ret;
 	),
 
-	TP_printk("%d,%d %llu:%llu sectors %u/%u fragmentation %llu ret %i",
+	TP_printk("%d,%d %llu:%llu gen %u sectors %u/%u fragmentation %llu ret %i",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->member, __entry->bucket,
+		  __entry->member, __entry->bucket, __entry->gen,
 		  __entry->sectors, __entry->bucket_size,
 		  __entry->fragmentation, __entry->ret)
 );
-- 
2.43.0

