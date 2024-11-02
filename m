Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A820EAC6;
	Sat,  2 Nov 2024 13:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730552850; cv=none; b=UED8nZjvDzBpU3mIKAvfryBFEg5R1/bGygpER7L7iv8PmKjr70+Q2HUSMakp3WOEMs6JmjJocuJBLjj6KQ+o15V+/DQ9Quyb9SmcL1jo2XhyrZd0rypqB8Wnr9gfO79uVsbqPD35NDxMVz2QYA1hgY2yMNbTobLIMWlQ7VB8k4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730552850; c=relaxed/simple;
	bh=tm5JTs+8rrJD6s7WDi8gLZfx1FcLQYY5V8dG7CsjcX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJot+QwgQaz6xBGCsiWkOEsmEIvOyymTHz0W59cAyYJ/BvXcO11N4a1+faTyMsl/k0TPtefvDfHrXsIqKt543SY4GUmNeeUA/n06+Wv8Ug8dlPgSFRxf9MKAs8d6wCinWE73/m5jf3RS5RFxPn1Pl3a6p2DnY4MfgCmBPrN8VY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/4Nxcs+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/4Nxcs+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-431695fa98bso21312105e9.3;
        Sat, 02 Nov 2024 06:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730552845; x=1731157645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S4iOsAcaLFjRe6ZZb9+QSgjIyDu6SShR56xzrQ22ljQ=;
        b=P/4Nxcs+Z6uo0ZC6gRP3H4lbycgUWzOEwNDuJdYVTePW7YenDs98JOCq2vkSKB4Eq+
         QIQNoBOIqdhGJ3YnlGUZ1tK+OMgwtJ0VdJil0qZB4yVjnlqP6JZmgJWtG1eY1gbMuhQn
         KikcZetLA8z7m8kSu9D5bXk72Dqm81KoKHYcOyRheCTwTBeyVZmJKe2pKu5unvnfHM6e
         gJuAZUThXCR/X3nguAqf/xflrB2I1LqObrm+lT95jR2+9NyKhteePOVDr0wcbnFuT5aM
         BTzlvy/ClQUwL3Nx3+QtvXBPvEClnwnkVot+MH5/0PNR2peIbZ6sDjn12dTxLF2tYyla
         4YgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730552845; x=1731157645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S4iOsAcaLFjRe6ZZb9+QSgjIyDu6SShR56xzrQ22ljQ=;
        b=LUgqylLEGwcW/c6v2RLDN1zOCqqNaDYej+3mpqeUS99LH8q/9Ug716506/Gzv1t03J
         qk6p9lSZfZp3QALfgXZsic1Txe7jeUj90UXirFF+ygpy/9bufNZ+v3dXNjF84EzxRw01
         PY1uz79akDsIzv9D5rqsDM3SRdm5Sgp1MoJxhJnj7ApD9gxOFB56mqm2E2N5+gI1uirV
         GBgCFkALIGKQhT0FdG9htpyUzFWlIM4jwOeIDQ2Tt2ZlLynOxMake7U4XosHONjujxXr
         vt1yYrazyPVNHcvQesM8rI8ewLhlDsxalKztkvkBgkhynhPNz+oCySlVulnXdiK9+59k
         geOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH5NxUm2A6K0LFN9Ut0hd1nAfeW4OsfcDyagNCDON+Ps9OcbCaloheX4zctALb834f1efV1K17U03euUvz9IA=@vger.kernel.org, AJvYcCXO3ydaxpm4e6X2FbMz4fep00pn+KITF0VuS8cQqx3sY3bIo0N8vOQEsUI4Q39hsHTKSDZW4ut3gA3ZzRVW@vger.kernel.org
X-Gm-Message-State: AOJu0Yz33IabWfDOK7EHxYGWQnPQtH12BC4TUBQg9oRwBthVSmQGeSwD
	C/mVEiQ6kSyF3mFi7rdPHhXCPIsYgd4kXmEg0cRnrNEPlOioQtyy
X-Google-Smtp-Source: AGHT+IENln2RkJNRAASU9Ya8UIFIYQzyX/oVv5uQaDwgkHA/iNIs5WUWvcFEFXYMqg4je2UAkEJReA==
X-Received: by 2002:a05:600c:46d4:b0:427:ff3b:7a20 with SMTP id 5b1f17b1804b1-4319ad049a8mr215124795e9.27.1730552844525;
        Sat, 02 Nov 2024 06:07:24 -0700 (PDT)
Received: from void.void ([31.210.180.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d6852c3sm94227215e9.38.2024.11.02.06.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2024 06:07:24 -0700 (PDT)
From: Andrew Kreimer <algonell@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Andrew Kreimer <algonell@gmail.com>
Subject: [PATCH] bcachefs: Fix a typo
Date: Sat,  2 Nov 2024 15:06:28 +0200
Message-ID: <20241102130709.9259-1-algonell@gmail.com>
X-Mailer: git-send-email 2.47.0.170.g23d289d273.dirty
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo: nonexistant -> nonexistent.

Via codespell.

Signed-off-by: Andrew Kreimer <algonell@gmail.com>
---
 fs/bcachefs/alloc_background.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index c84a91572a1d..5f40b92fbf16 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1395,7 +1395,7 @@ static noinline_for_stack int bch2_check_discard_freespace_key(struct btree_tran
 
 	if (fsck_err_on(!bch2_dev_bucket_exists(c, pos),
 			trans, need_discard_freespace_key_to_invalid_dev_bucket,
-			"entry in %s btree for nonexistant dev:bucket %llu:%llu",
+			"entry in %s btree for nonexistent dev:bucket %llu:%llu",
 			bch2_btree_id_str(iter->btree_id), pos.inode, pos.offset))
 		goto delete;
 
-- 
2.47.0.170.g23d289d273.dirty

