Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610401EF374
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 07:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742284210; cv=none; b=jcH53m+wUi6LPrXuAQ2zqxaV8Yj4cTdHmIBU3hfuLqEY7EjTS7//0mtFr+dXST5+Tk4KxX26oarumxFEk62sX9i8OiOFf+5zJve8AEO5ZmoScFaEncKe9EpqAMMgHgKsERCW4S/w3JdtZXUX45GIuhGxow3CBt8u7gRk3Vg7xLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742284210; c=relaxed/simple;
	bh=t/pUduuFSelN1PeOM7+6GF0+Q0DVNpfIyl2HM3J7DWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdbX511U4IbdqNEs5HEzcV4VT5GzhnFp4cb1azqdT1evil1qkJOvytLznPtbV2ZmlNOfDx4crYnaMHiZwi/zADVdFQZ+tGYhGPO7SlO1cQN5L4+cklIhrI+tay80ab7T1SLuI7fMfSQh47ctqyN4Mb5hPGLNfxLayoLds4Am5Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqFYxzsf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqFYxzsf"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22401f4d35aso98500885ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 00:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742284208; x=1742889008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxEVDADsplyP44tFO83S+KsZjp3IdpNT2ZYFkGv1oYM=;
        b=nqFYxzsfsNBjKJ2qOVFiBmYAf23G213VYksaPyKvXHle0LYDOS5fnEbzbQ/KcvkHPK
         npllrfDguVlcsj64kwI3hrnZr08aEE+LnGFJxpiNEtx47CkrOM4l7/VjDV2d793+NThw
         os3AbT9Y7dlpGVOLCHgXbshJVhuAHyZHF0uzw+hNzOM9/PGqpgEVxXPdaHWhYnzNhLk1
         S8F7oRdftwrX5ivlmL5knwzx/+Yf7WgH524QLCLm/8+KRJB3lN4x13WE46liW7f+ntRo
         heCzTtlfp6fOFhNvA2mDoH7HKxNMMFvXnY9ZhG9XL2uzGpyjKWXzdc1OM/Ycj1X2hiHU
         +iAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742284208; x=1742889008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxEVDADsplyP44tFO83S+KsZjp3IdpNT2ZYFkGv1oYM=;
        b=Ygyx5JeyOjyxRLkIYAhkIl2rm1H8BzBzEhlfeg5yx0lpgRmHCVFVOJBuk6d0mot/xG
         N2UrjKtz9NsVUIIzWKJSVxuAGyiNcX732k4dksunR3bDlC2Ik1W8lPd+CydsV4AaDieD
         2A+TqVN4rJcKXBTs1Ch5pa/PTETmv9xnFqXIASwohiLmfZxfcvEh7/aigDoaEkj/7Bjm
         8+cTAyW+mhVAkcvunOWgoZMIlu3S9HQAr9MUty60MkhPSK7pz0bCSIcr93ivU5hGphbS
         nufSsIoOtxySAQ/So7wnkVzlC9ssfcsqlYztoCJLOk3UqJdu4W3WyejyIMdFeyP35lWb
         Ik2Q==
X-Gm-Message-State: AOJu0YytnqFe6WwVJsBWgc7jOxIgNiZ0TzXZDymO3LrkF7Bt0HdbXjxT
	ZeNxufj1BVXvXk9MA468ou5uHV8lvTRIkekJIn62K5w3EIkEFKlWGHSl1g==
X-Gm-Gg: ASbGncunV7cyyGHNVUHOWOIGWgbCqIAE4/hW+h5PgJNSwDtw9ott/MQtstVq+wgEnKC
	r4dQv7Zj5C2fCKrMn+n2YzvysljjwL2YMJpd0VBcRxuwi447N1iND+mLA1DnhDeh6ApA+dk6ARF
	DfC3AboIaLY20VCaTDWVYvXdGxX0h5xYg853JmH/wfiHRv8J//KZoY7o2AYml1heqbdwc+wMX5Q
	BO5ROpHuGxlp7YL768CyWDmyqNoGQ/AUM83uRJE9dhThzWx9O5SFMq6+AOyuaV3ZH71dNPY+KBd
	aMS/r250LejjiTgU/rA=
X-Google-Smtp-Source: AGHT+IETqgDWc+CQbg5lQCIq2OfPsOkN7kvoXCXHNo+0T9T/7zvDvR7Ca8MPo5raAn61GMS3muXN9A==
X-Received: by 2002:a17:902:a60e:b0:223:35cb:e421 with SMTP id d9443c01a7336-2262c6118demr29230105ad.49.1742284208534;
        Tue, 18 Mar 2025 00:50:08 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301534f4742sm7492515a91.1.2025.03.18.00.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 00:50:08 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Remove spurious smp_mb()
Date: Tue, 18 Mar 2025 15:50:01 +0800
Message-ID: <20250318075001.1976165-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250318075001.1976165-1-mmpgouride@gmail.com>
References: <20250318075001.1976165-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The smp_mb() is paired with nothing.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/journal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 8d4f3bfaa228..fc15644c9f24 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -761,7 +761,6 @@ void bch2_journal_entry_res_resize(struct journal *j,
 		goto out;
 
 	j->cur_entry_u64s = max_t(int, 0, j->cur_entry_u64s - d);
-	smp_mb();
 	state = READ_ONCE(j->reservations);
 
 	if (state.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL &&
-- 
2.48.1

