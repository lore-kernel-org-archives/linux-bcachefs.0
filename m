Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA02D1C84A1
	for <linux-bcachefs@vger.kernel.org>; Sat, 27 Sep 2025 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758963992; cv=none; b=Duk1rQD6Lx6DiRqcvcWYN+hcSAzWqtW+OTv/4JZkvhEIcAKyZKi4LRswA+fMXqmJkvz0skhivTA5LrhDtQi6eKVKNx9XJqBkF4x6DKZu8F/03J6t/YwJ+B5rH6ioxOCGgZn7R+bzO227pkVaZKrTYfbhVkZTgxhkTW0yC9mihJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758963992; c=relaxed/simple;
	bh=Hr7hpNMdUF2WDaaY5qlPkxtXvsgdHXvWif6/xAXRdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=keD5P4DolkF7Yb5k81IVUE+DUs1t3WY1xf0vr1sxNmkoGqhX7zr3Vak+5JE+uYQM1Ppcl1whUDdMT9hPlBS8VX6c5vmF0SYN9maa4X1EYWRRNkZgF6d1OmsfysurhNINedJ4w4cYSK+Wdm9vl7CYMLLMNen6y4Np8WUe+In13cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMva3wQ/; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMva3wQ/"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b5565f0488bso2095202a12.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 27 Sep 2025 02:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758963990; x=1759568790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hr7hpNMdUF2WDaaY5qlPkxtXvsgdHXvWif6/xAXRdmQ=;
        b=JMva3wQ//96BzKz84QhuPelmPm37UeFl5VplGKKveVP53VXxp/HCXd9YQPDSrYRdow
         jWCzDlYBTycDqwEgo6F07AODXCh4kUwkmPDA6HmhokRe+3LXHwBp7OXBI8vRtevtSBYU
         /01iilB4L7PJSwMiHkqUVDUmGh0orHtNAlad0Lfn3WXwjz7dMfcbm9Sa4jwvh7yWZZ4W
         MfojslUAfBrR7hfyknzh2JFyP/UINjAQEIBR4lKFi5a903uPIicixb1uJBgcYRwBk6q4
         3n6UjGzRcMoeacn4UEm5Hk91ZkYh4/hqAenr9BPy9bMoF0I6+nZTma3a8zuSgEgsK2Es
         fBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758963990; x=1759568790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hr7hpNMdUF2WDaaY5qlPkxtXvsgdHXvWif6/xAXRdmQ=;
        b=oqjucZLdgcqtdDWwpKRhBfZW0mJabYoTbY4foMYf18MCwuR4kbseoIVGDEOV/WgDR/
         362ZqxbzmB1OlILpk45n035nELrY+Fcy4EOYWATtHFsL343uJjP8FXpmUN7wVDRVhTLv
         EVWzP9lTCo3A0s9s5531ltKOQPMk5StvZkPSYdftimr7LqPuR7iwth5NMZDiI9r4Z1If
         pnYPSg1PKY1/9KGrKp4WD2c5zhNDIhNES+zwpWlQhxZrbAJuF2UbOX8t7ViBzIwSHcE8
         2L3byYvab2/Z8f01MIGK3/sYfQ7QSWjQfob0bbgkocG/4wK2bqo9hmhS63Oj9Hu2b8qg
         Iqlg==
X-Gm-Message-State: AOJu0YxvEmumLdE18+VAWjlghGJtjXcnm8F/jhOzoeygeJF2iUkJeH4a
	DQTVpW74HWHDuAxSfdUUkLdfZAcr926GxLk2PAPuRY+MIGRlHgdprAlh3C92YCQompc=
X-Gm-Gg: ASbGnctY5c3qkOj8jA00w2dLRORlBHo+IZXIkgy1BcGWeuRIrKdkViy2TO99zmvk7sX
	jL3YhpkcY2Y0HqxXlp3USDQ9AGGLGDEjUTkO+owMXZlJerFy5OZu8MgSTbELa8KttdF8/M4DD4J
	FQnpnNZl52Q+W8nLAvvDaTPUlIgrYf+pC/klXnje/dy0qpsteYGu1Ii7SUviZaOjeDqx0hkAYmd
	rRYBsUFaKo9852I1UsQSGwVVxl8i1yhioYlfbkt2+JWNK6BALlWZYVeEUFpjZPtilqcvWUlL7u4
	uE03qH1sFG0KJNaAkiabvtxTUGuyzkJ1DRxX/ZNgm0uGS8G0aBtE0WPbULWVQcnpJNyRAG8YBOH
	gaH9QRL7iMMnSlwHEo7J7YsRLFvSzh2agraLci0sbYnveihtRTLRKQwpy+t1pYQyGFk6qrpcC1w
	==
X-Google-Smtp-Source: AGHT+IEdXtdZWJP39SIZQwh+ANixzmcmzBAnJe6eF9v1tcCIh+gbLm+ELiBPGPPxoTg1GHgsIuKP+g==
X-Received: by 2002:a17:903:1a0d:b0:24c:cca1:7cfc with SMTP id d9443c01a7336-27ed4acebbcmr110769605ad.59.1758963989875;
        Sat, 27 Sep 2025 02:06:29 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:ff57:4e03:384:b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6716167sm75573375ad.44.2025.09.27.02.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 02:06:29 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix deadlocks between fallocate and readahead
Date: Sat, 27 Sep 2025 14:36:23 +0530
Message-ID: <20250927090623.42024-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for reviewing the patch. I'll join the IRC channel to discuss the pagecache lock issues further.

If there are other areas in bcachefs that would be good for learning the codebase, let me know.

Thanks,
Deepanshu
