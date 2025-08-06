Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A51DAC95
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 06:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754461572; cv=none; b=KN4M0GFzVjAtWIp8Z06ZSx/bWuN4XEeI4OEVtfq5jPACmx6DTU2TYwwuAIndEPgZTBWjgq0KpMOZJ0kfiCKmFp8Kn1XvLJKJr0yKhDdPNjuLxfNMyRpEsVVUc9oWi1QkJggAIgnnVFcWM0frw1Qergewz2gWtMVgTLjXStwWwjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754461572; c=relaxed/simple;
	bh=Mmf5IuFwvOUs7jnrCbYJAXqA6ZPjt7eb4OAZY1RmQog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEb8vXAT+a58BYFierl+ARfzcSjUtV1/muTbmCdfQpk9SSYn3+uvGbpeNYWwhhNulQQOqWCXvP6wDhJJn1jjYnNfow4oYPp1IBveB5TPdYoXkq4HqcmRgd5wHG+aGx5Z1mnks/3GeCPM0RXjluYGPx20lXApQuyF/kNWbSKfUwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6TqKRET; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6TqKRET"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-315f6b20cf9so5544511a91.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Aug 2025 23:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754461570; x=1755066370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYHVQEzHxglE28fEnurxP5NsWDUrRwhZymWc4m2u6jQ=;
        b=j6TqKRETsYOuSI8BZRD1ksl+R2F+59jA7NaUbtGKQjoDT0mH0sDs6gHsepQ45jcWpf
         Y2Luls5mPvKjJTmeHJU3d11p0YW5YNnM1VpAfjbck5fW49afK1o1mB/dDQNP+jQPKp88
         4jzS+cY1U+usECJxEakEYJJd/xJyFK+cyGnw2qhwvj6yd/uxm5C+JOqDv54TVueUpSB3
         GJGPByamyUtUdtD6bGUChydaDj7xRjPgdrqCrtilDSX7PT+y1OzXgGlfdJOhq5+pBPMZ
         d9jN9F+wk2Sfvd4NzJ3LsEHHmcGarBi20J/qJdRv04y2ayeZ2M/fxnPRhpqz2QlVMQl7
         QaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754461570; x=1755066370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYHVQEzHxglE28fEnurxP5NsWDUrRwhZymWc4m2u6jQ=;
        b=ROd2pbLxVOIEyJcEFxv2j6QwYyghuFI7Ytrst3unbpB8nW1sVGSa/q7h8Xqil0GGk6
         ACbY/G0/JodODYq104D3HRPkRzmZw0NIaanqm1Tvculmp7jvDwdLiVa7MTrd6NqxvB19
         FtJKxpgA7syUuavUUAa61zUloj4GBSnUfZuDpfw6EVpHz45mNKWKRPSu0AyKE2tnizyY
         Msgs5JGIx3GjcrbV3n9VCcG8rBgOY686Jh9mxOwHG+O6slCtGZeqVJueWJFZt5jFrmDy
         5MrAvDEfkLDiLCpjQj7aMB9clxIYCi19lK83R8iOn0I4PUqSLwZ4+dXG7+27MgG/kCK1
         nVJA==
X-Gm-Message-State: AOJu0YzTOxk2gX1YybWEKRic2TDUg6j+/Wil3WNccIlsz2uMMA4CFwzP
	tuh9GDsXhg6T1F5iFmTtKHO8Cu4Pb/vyqyddan6z4GPVzU5E2UF0MZmF
X-Gm-Gg: ASbGncvF+D4ceS/avQlUuehNLCfKoVVX1pkv0YcYNh11+ThBpER+QvvXfENjnxfuwaM
	bkWPI2IGdUiZNRGA2yrXgVv7hgw8zNjyLM8tFto//7N2spYqFvmSZL4YAiQBToxOwlq8kuAl7F1
	clg4gTbMinZLf9R5qMGwvWZ1T6p7EX5zBDfjrHUGJTFd7FM8o4LHirmCvWAsYX/qvqhjjXTsKhu
	7pvAJbf5jEjtuq2DtVfrdqMWGxWbYLSgKN+e9w2FUMU4v9tplnshQpeoALx46vsCNL1e7LKstpZ
	ozCrW0WzAkPCp23+rSO/mwWHamYuIDiw5m2L+JgfA2umxluCtHQJytTh6dXcgYbx/5ETHPTz
X-Google-Smtp-Source: AGHT+IHCpcUEypiLKjmy4ln2TFhEr7IsFYHs2paOBEd75uWu6Gb43KX5Ge4I2HtAzs/9okby3vNirw==
X-Received: by 2002:a17:90b:1350:b0:312:1ac5:c7c7 with SMTP id 98e67ed59e1d1-32166e0c12cmr1965979a91.2.1754461569789;
        Tue, 05 Aug 2025 23:26:09 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3216129c8cfsm1811338a91.34.2025.08.05.23.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 23:26:09 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2 2/2] bcachefs: Factor out readpages_iter_folio_revert
Date: Wed,  6 Aug 2025 14:25:57 +0800
Message-ID: <20250806062557.458303-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250806062557.458303-1-mmpgouride@gmail.com>
References: <20250806062557.458303-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 9f6f9f0f21ff..fd8beb5167ee 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -42,6 +42,14 @@ struct readpages_iter {
 	folios			folios;
 };
 
+static inline void readpages_iter_folio_revert(struct readahead_control *ractl,
+					       struct folio *folio)
+{
+	bch2_folio_release(folio);
+	ractl->_nr_pages += folio_nr_pages(folio);
+	ractl->_index -= folio_nr_pages(folio);
+}
+
 static int readpages_iter_init(struct readpages_iter *iter,
 			       struct readahead_control *ractl)
 {
@@ -52,9 +60,7 @@ static int readpages_iter_init(struct readpages_iter *iter,
 	while ((folio = __readahead_folio(ractl))) {
 		if (!bch2_folio_create(folio, GFP_KERNEL) ||
 		    darray_push(&iter->folios, folio)) {
-			bch2_folio_release(folio);
-			ractl->_nr_pages += folio_nr_pages(folio);
-			ractl->_index -= folio_nr_pages(folio);
+			readpages_iter_folio_revert(ractl, folio);
 			return iter->folios.nr ? 0 : -ENOMEM;
 		}
 
@@ -68,9 +74,7 @@ static void readpages_iter_exit(struct readpages_iter *iter,
 			        struct readahead_control *ractl)
 {
 	darray_for_each_reverse(iter->folios, folio) {
-		bch2_folio_release(*folio);
-		ractl->_nr_pages += folio_nr_pages(*folio);
-		ractl->_index -= folio_nr_pages(*folio);
+		readpages_iter_folio_revert(ractl, *folio);
 		folio_get(*folio);
 	}
 }
-- 
2.49.0

