Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BAA21ADAB;
	Wed, 28 May 2025 19:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748459611; cv=none; b=koTzDBVZYDnvnVDox2votI2VXzRDlooWhKN0kFSAjAA3MnAfVUVP6K6+e3bqcj+oNN0mQqzPP3ip84ZE9eXCb31HOFsPeZfGQiy7SjhBFranlTBNXNqcrGkSAh/iZC3Zd4PrSKiB7wklcM/9Nzpi3+4ffW5VtFPn5/UGkl6V48I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748459611; c=relaxed/simple;
	bh=pqlznRqGoiHsdNLMqjDHpvHDCTXvsd1kIU+sRSf7o7g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iIZ9XALYklIgZ0gmqbk9E8OoEfKGB6SxBP6H7iKVLHsmfGPUR9v4h809S16NNnk1ZvUeRS5GPIkVqNNIz/29tmB2QSOSnbr7eoanO1OYhLNhcRAORiFxycjIYRwZgH7b9FFQAutk1kqaCX0JfeUIPtlPjEiQ2bl6YMZ88Xxkksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbWwkCBN; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbWwkCBN"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a3771c0f8cso91264f8f.3;
        Wed, 28 May 2025 12:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748459608; x=1749064408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YuhDVcvTIzRoQcTgW0/uzDOCuUGCjAaE3jyHkDbI47E=;
        b=WbWwkCBNhE6l7Wh2ropgVI7GBPvGajzimphUCYC59eEk0TzqSkFRs+vVORs1xg3R6z
         di176JzJOSHJi8K1gubM+/l4Qo0YgolWTLZgzan/S71qLIFpItk1RFOzjfOQJT5rc0oD
         YSbikfaFrL1Nth6l3CFN0ofCo/XqCpysUcl6mNdAEqs6VsQK1aHGmL7GEMMqvS8fRY93
         ZLUF+21mvVBvl2nDwGFNWToPL7PWK2EBebljVZyFo+DXlktHctIzg6iEdiEwKUoHACil
         pu4zMel2ei251DCfJ87FZsQLwi4W7LhciNh7tDfvKPaClCPHb6by6q+Nlmlby1GatM5a
         +lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748459608; x=1749064408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YuhDVcvTIzRoQcTgW0/uzDOCuUGCjAaE3jyHkDbI47E=;
        b=XGFobi2rChQIcknhC9pXVFK0UmU5MnaFfg5i6HOx0yOz9j9POhFBtE2Y6f0dcbUC5j
         ezIeyihSVoTvoWnLV85KhJeGtJDiZruj/yfqL7i9gEtZ6OLJy8fXRmJJ3QnLM1HFiMnq
         vZMpZZ4sh3+6NN1shjj8ByJuDnMuCRrLJsJS1ZysUvSZ++k7PZlQulNtlXXPXSOPjl4o
         Mq6Iarz8ycq66N4ChQgf7T79jJ2u7NKXkvBJLgF7K+wtzZsPZYkDsAooI7eTeMs30hYz
         78twr9+Hipm7CIMwn2TQ+Kvb9cckNImgy4abqILVkyV9HK/mKW76npvLWAjTDSYyew8q
         9wbw==
X-Forwarded-Encrypted: i=1; AJvYcCUXe4GfCkiZDyiGy9Ifm0VUbOk1yW4R2pKADa93ujr1Xp1ZVrkc2UiguTh29F+BwwE9b3zbnanBOrz+5P4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZeV2gebvDnOXvW3oY5VbGrw4L5lHA9t46mDisdNCUPOm9wySg
	/kmJ7LQQjUuNxAtFNvh5xPo4Wno9FF0TPUBp8GPypFQ1dZJwWYuC06b4eV74tA==
X-Gm-Gg: ASbGnctxhRbOzsCZOVUhjfCEYILOcXFuvYP/wbTlip6DJojL5wPepkhu/YITW29qiar
	F6ugiLW+urhrNi+nQExN45IBPT4AQ0J90fjIMi81WLKTl43xPG0kh4+9skZWs+yMnRhtKxS1cAG
	GffBMWmLSdinI+751yJyHvTH0fjkjG39TsS2ckhz6d0ccVzQMsgj7e8lMXPPwEoDSAkr+yjRLiP
	tfcSdoQITU890ANA2vRmKNPzKiq4PAVtlCIFT+M79qfqbOKQImrTQMwnU7UessIqg8GLI4iKqPw
	8pgz2WPknY1w3N1W1WLOb68Fwnha8e2hz3ZuQIKS2P5+JFfhIUfnqlt/4TqxNdM=
X-Google-Smtp-Source: AGHT+IG9I6ymJP8Yn9sWgOhrKAuqv4C4BXk3mnHSHIV9H3EAoqsCVwxXNoqMwIDaADI20o7amsuxJQ==
X-Received: by 2002:a05:6000:2282:b0:3a3:6958:88dd with SMTP id ffacd0b85a97d-3a4cb436d3amr15128716f8f.23.1748459608030;
        Wed, 28 May 2025 12:13:28 -0700 (PDT)
Received: from qasdev.Home ([2a02:c7c:6696:8300:abd3:1cd4:20cf:34e5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4eac7e09bsm2271469f8f.36.2025.05.28.12.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 12:13:27 -0700 (PDT)
From: Qasim Ijaz <qasdev00@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: fix uninitialised-access bug in bch2_alloc_sectors_start_trans
Date: Wed, 28 May 2025 20:06:10 +0100
Message-Id: <20250528190610.50604-1-qasdev00@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During bch2_alloc_sectors_start_trans() if bch2_trans_relock() fails
the code jumps to label "err", skipping "cl" initialisation. Once at
the "err" label "cl" could potentially be accessed leading to a uinit
access.

Fix this by moving "cl" initialisation before bch2_trans_relock().

Fixes: c2e7fa88544d ("bcachefs: Use a loop for open_bucket_add_buckets() retries")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
---
 fs/bcachefs/alloc_foreground.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 1410a4afb36a..ccd51bcbcec5 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -1277,6 +1277,11 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 
 	req->data_type		= req->wp->data_type;
 
+	/* If we're going to fall back to the whole fs, try nonblocking first */
+	struct closure *cl = req->target && !(flags & BCH_WRITE_only_specified_devs)
+		? _cl
+		: NULL;
+
 	ret = bch2_trans_relock(trans);
 	if (ret)
 		goto err;
@@ -1285,10 +1290,6 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 	if (req->data_type != BCH_DATA_user)
 		req->have_cache = true;
 
-	/* If we're going to fall back to the whole fs, try nonblocking first */
-	struct closure *cl = req->target && !(flags & BCH_WRITE_only_specified_devs)
-		? _cl
-		: NULL;
 	while (1) {
 		ret = open_bucket_add_buckets(trans, req, cl);
 		if (!ret ||
-- 
2.39.5

