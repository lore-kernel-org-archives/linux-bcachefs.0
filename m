Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE6031581
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="raAX/ATH"
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970BB4C3E
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 07:19:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-543c3756521so9663836a12.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 Nov 2023 07:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699370344; x=1699975144; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kvnw+5Z8XzZfEDMyj6XCH8/UXST3dZPPSlZR9k5HkhQ=;
        b=raAX/ATHrx7PI0yXrC51k/ZQKE3TUYtBIyKFoMZXS33fNCNlZAo5HVqepcr5dQeKJW
         OKr2jiv6oGnE+Pv/6K12R9xM+SN4RE3Ko4MVjFAJbSepwtTRWIh1BaenWIX4SigHoHkT
         cjYLbEPwDP8XiDLBBryKw+aAJi47nHQhxT1/KsWaiFGvBIwMpi8Iy4I8CsAmbqZw1/Wr
         mTS/+rNIvaifZFM/mX7YIiJes4F6lDeCQdI3+AtV7a4ItrXqUXn+mw5EbsQBnzbHb1xh
         zPGt62aoBg3+YokpRrLMbyRG1ZDqdktZ1ZB9y7v42G/AdBMnHyDyInKjvBt5ZFFTMJwp
         ewew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699370344; x=1699975144;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kvnw+5Z8XzZfEDMyj6XCH8/UXST3dZPPSlZR9k5HkhQ=;
        b=jPvEvx46eWqy4YYnP8B6939jjcwhKOU9MBj53iCPr9BPMI8a0qUGZcWy3GpgExRgQc
         bCx3lM6t70I8Da8AlEoKrxV0QS0DSWomUow/eCdfP1F2DRWeKVcvHluxKMMMKEnRQhrB
         quIWefIB3q2zDza4gNwo8SmZYs2yqi7HPcLJswLpJMcDMHPcUCLQXGEchGPaO8qdK4Cm
         CvXvzWnMwYqUrXx5FJRn9kPTDumyz0LJhagIIwitIZqR45mxY3Ape/bFkMyN28oHfepr
         8g2DIVL8SyMmygh87WFMmrNr4UqB/O/enjrjJTbtRIYu7j6CUlAbDNy3INZeUZAUnu9j
         VRMw==
X-Gm-Message-State: AOJu0YwK5lJv/bK3/9DuyVik2m46GPImJTQGgtR9MmdEAJvUEIt/hpCH
	DzyBi4+Fudn08u47DheglddjVdfQMQg49Fe9IFvXZXrj
X-Google-Smtp-Source: AGHT+IEeMhBfKgqh/2BJW46RBs4h2HR2f2v7fHd9CiMgcJpnEdlMsofIr2+F8rRfEzWHQMpEF4WEBw==
X-Received: by 2002:a17:907:724e:b0:9be:5ab2:73c0 with SMTP id ds14-20020a170907724e00b009be5ab273c0mr17345503ejc.8.1699370344200;
        Tue, 07 Nov 2023 07:19:04 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id ko18-20020a170907987200b0099ce025f8ccsm1135484ejc.186.2023.11.07.07.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 07:19:04 -0800 (PST)
Date: Tue, 7 Nov 2023 18:19:00 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] bcachefs: Fix NULL dereference in bch2_backpointer_get_node()
Message-ID: <5fc3c28b-c232-4ec7-b0ac-4ef220ddf976@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The bch2_btree_iter_peek_node() function returns both error pointers
and NULL.  Check for NULL before dereferencing "b".

Fixes: 853960d00b4b ("bcachefs: Simplify, fix bch2_backpointer_get_key()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/backpointers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index ef02c9bb0354..3f9c5c366708 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -316,7 +316,7 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 	if (IS_ERR(b))
 		goto err;
 
-	BUG_ON(b->c.level != bp.level - 1);
+	BUG_ON(b && b->c.level != bp.level - 1);
 
 	if (b && extent_matches_bp(c, bp.btree_id, bp.level,
 				   bkey_i_to_s_c(&b->key),
-- 
2.42.0

