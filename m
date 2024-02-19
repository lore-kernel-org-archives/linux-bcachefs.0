Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C532182
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708350935; cv=none; b=ejJl73oPBvUHEk6pdHKd1oztHoYrN/FpI5jlYpyvDhjYym26/1TOvyRnEt20Uao/4TfxXY064EUzRfJHVJZtwVb/RqJKrX5EWlLwDvtzSWn191i4TlaO6TYGsycSxsqJ2/nkFw+/wot90hWWlf7OY/G1ZrSinef0SNi5WoX+MjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708350935; c=relaxed/simple;
	bh=6WnC7WDwUQjZDlGG16kuE0BJoOtjv47SwOJJqiUan8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W52Cmocihm9ZhonxIzI+dmvf7yWxcdmyhqHYoV/WNCyePNCc/LXRXkMoFjNyQFnxS57W3Qbvizx8sdlwN+D5N2VThroJhCwHnhyNEMjHi+kODaRAtFuXJZ9RDyAKd+w00CG5GPqN2ybqnFo1Fv+f06/qdzVUdRGfMEjuQefRcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=J3GEgRjy; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="J3GEgRjy"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e34d12404eso1310852b3a.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 05:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708350932; x=1708955732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XskJ4lXU/mDh4qs/QbSdhJRoD0AD59Prx9avJWxMMxM=;
        b=J3GEgRjy/Vbs1JptvmiVcDB+euMj+eyWKXhzTBEySLJg2UrbDO1h5wnE+51BDjbUCI
         2oSJFVpf1WG5XQXYJvANGSauK/m2D3OKiwiYirtlUZsjHRKHbRdbg2Yt9V1hnwbZBpfM
         zKC0UgIRBIY9+7srGPzFsk2p8aj+UPdSh7hqWFJcrR05d5ErMVxrelfsVfBh0aSc/1E1
         zGZe1bDQB8m8KZwgoX4YTfJ0trSsbXqLbkrNl7E+tYaHdPQC9ZoTdkeeQGd75sdC3u7/
         +SnaYfi/jB3dEcPJ3A6AaQX/PItCMjrLKdwLwfVFDnzaLA5nNRTKZ+vHXwaGDgKa/dZu
         vYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708350932; x=1708955732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XskJ4lXU/mDh4qs/QbSdhJRoD0AD59Prx9avJWxMMxM=;
        b=Z4yu8KRKHKVESaOcgyWmeKR1JjkjO8D6ezGhfGIka485Ii5b/3aIsnDAOFBhq5Pxt+
         3UunJHpzTO6/2AKpvaFMVjO6p2QQ2WcmAPXbvZ2ah3ZKjBQ+4Zgt2nw6W7tDp8EOaZmx
         WmQVMeI2iU+6V7dE55t0/jo0Oqn9sP4uSMqX1Wkssj7aVIbLVZAoEQu/hTsZg8xS77HJ
         LByEssnCOlO0nUSrBN+LD9v0HRLsCgd6nmW8uVa/DGX/MzyvKVkN9QioePlDxSjWIcrL
         C+hq6sHwkpJcnBnXI/+KBw8KDFko2kaggODQcrmYGaCbIFrWty3pSL+JBxwLCFYdJft/
         F8xQ==
X-Gm-Message-State: AOJu0YxJbA1GhHVM5iTLYQViJOnPdAFkXQwgm3TS34KFsdjf/NgACrVC
	Ys70fOlDz2G5ToathlQhzObFYFqVVs/nJ7oG4YA9ffupXIsaJG8XutpTOzvi816DdiuWJhiCFFt
	C
X-Google-Smtp-Source: AGHT+IG8r/OP+1f1i6YJP9CuyRiu78xS4JmZUI3+7hRbnC6uY/Q/smJTiL7XTxBNuXmc66oGGEm35A==
X-Received: by 2002:a05:6a20:c842:b0:19e:a21e:e01e with SMTP id ha2-20020a056a20c84200b0019ea21ee01emr10265737pzb.23.1708350932452;
        Mon, 19 Feb 2024 05:55:32 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id k13-20020aa788cd000000b006e4641f578csm1853499pff.189.2024.02.19.05.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 05:55:32 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 1/3] bcachefs: add a printbuf formatter for percentages
Date: Tue, 20 Feb 2024 02:28:38 +1300
Message-ID: <20240219135425.885068-2-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219135425.885068-1-daniel@gluo.nz>
References: <20240219135425.885068-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/printbuf.c | 14 ++++++++++++++
 fs/bcachefs/printbuf.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/fs/bcachefs/printbuf.c b/fs/bcachefs/printbuf.c
index b27d22925929..8e1f5b0bc2e9 100644
--- a/fs/bcachefs/printbuf.c
+++ b/fs/bcachefs/printbuf.c
@@ -446,3 +446,17 @@ void bch2_prt_bitflags_vector(struct printbuf *out,
 		bch2_prt_printf(out, "%s", list[i]);
 	}
 }
+
+/* format a ratio of two u64s as a percentage (to three decimal places)
+ * supplying a default value for when the denominator is zero
+ */
+
+void bch2_prt_percent_rational_u64(struct printbuf *out,
+				   u64 numerator, u64 denominator, u64 def)
+{
+	u64 rem = 0;
+
+	bch2_prt_printf(out, "%3llu.%03llu%%",
+			denominator ? div64_u64_rem(numerator * 100, denominator, &rem) : def,
+			div64_u64(rem * 100, denominator));
+}
diff --git a/fs/bcachefs/printbuf.h b/fs/bcachefs/printbuf.h
index 9a4a56c40937..e8a87d17793b 100644
--- a/fs/bcachefs/printbuf.h
+++ b/fs/bcachefs/printbuf.h
@@ -126,6 +126,7 @@ void bch2_prt_string_option(struct printbuf *, const char * const[], size_t);
 void bch2_prt_bitflags(struct printbuf *, const char * const[], u64);
 void bch2_prt_bitflags_vector(struct printbuf *, const char * const[],
 			      unsigned long *, unsigned);
+void bch2_prt_percent_rational_u64(struct printbuf *, u64, u64, u64);
 
 /* Initializer for a heap allocated printbuf: */
 #define PRINTBUF ((struct printbuf) { .heap_allocated = true })
-- 
2.43.0

