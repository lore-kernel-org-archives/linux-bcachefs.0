Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0073E125DF;
	Fri,  4 Apr 2025 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743730110; cv=none; b=kE+dUuT+QrdkTEuFBjNGZ84X28i3OLJw2zkkb6lbYaFkN90YTQVWgL3zNG35nymwlUEyQyNA7aKuok0jPQVwnFB/LPgBreXiNb7GWPRmq4S3raNGBM1iomG2CZt0KGqtuv3RLfJqca/eviwNFu7JgMjSYWmWJemUjqZKj8RJ5RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743730110; c=relaxed/simple;
	bh=+ResDCTvM23URDJCLa3ecYhjP+KuL5/bXpoaByzVOYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ap8uUB8Sa+hSEaHSSuTVPcv33XYLK249eMF04MzCmAEvZmE2LCfBy7qbTx13W1SkVHB9VenlPtAHT0PV4aBj0b6jFrPGTY6uzoS/+zFnIRvGBeGEjVhzfEb2c44OCegcpa4Br4G1dP2HoLVp1HKpQ0qVN6s5e0TBlowbwmYAhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJSDEkst; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJSDEkst"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c592764e54so188015785a.3;
        Thu, 03 Apr 2025 18:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743730108; x=1744334908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TdHSKPoc66HovlsYIHymAAPKNzysuy+s35fLRQ1k6k=;
        b=UJSDEksttgjGglKZhxvYUDUwNa9PLufhX4c2qk3tf7IVfMNzhg9mYfH2eHh5+jcGqw
         z4U1EvK961q3xmTMtkVo8S7/8O5sXyopsGe7NyLn4Rr5n7HtNBAFEz8iFzfQHEkZKmYV
         HAxBOqvLxJ/4x4Vm3W993EtIYsvMGPV2x3Ma1sAOrBN4isiI74v5aQxW51p8DaHsyHWj
         fAHBs7jcF0KbXjGM4oN+t1XMcxIq4lsppvibZevOSjLlwri3/ZdutSPNYWUqSUy2Nubm
         Sj3yiGa//sgeOsmPtLUkOd9i7G+M4lAX+gd1Cho+y9eoBOIRN+bdDH5ijTKMaDa5Eu6W
         Xtzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743730108; x=1744334908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1TdHSKPoc66HovlsYIHymAAPKNzysuy+s35fLRQ1k6k=;
        b=t7w7qdxRQ1nxPGwt6jEint8WiudOraD68qfiPwZPAMspRs1d+v9Noh792w6lr9ug1o
         2IbnF3EOB+bl9mEb2J55TA3GjX+RqKWJCiIj1ooh8L5nGw97TCbIwWI7q15aFewXRBeY
         TTGGHbuY4WTPDorUrnhUcyt1KFSyEkZxQqm/oyf2LVEWUgo8AU5wJgB/JGecq+eBVaCJ
         gc/U0R/I/L10sY3GisGZVKRliGvcqP0ftqjWfbO3iBnKsQYoJz5ZPkAtuM6hEzTq9BXR
         dAkqEAE7kadNSLQ02bvn/aaiNWD5pGrqKRPGx0eFRBaPbJ727BatgqoHnBxWponPafVi
         MSrg==
X-Forwarded-Encrypted: i=1; AJvYcCUA2HQBjgCnn5Eu0U2YDb5EzQqWq1EQtHPRE7MeyCcMTcE9d+mT+iSDqGkbM0eDlYbI1ect9bB3Jnu1hwnpNw==@vger.kernel.org, AJvYcCWa90TyvjpQKchGI/LXxkWn2URojheMw6GeYuKFDiHTM2Pkx/+Baf8vHgEFm2yF1ap6RkYSUI7jMBAjvgs6@vger.kernel.org
X-Gm-Message-State: AOJu0YxCqPEuS8o0NZduTAeQrj6W+7dHL4MIDwM2+SGSKDaC2Pp3K44A
	PZxHGXF6PH4ly7oOCYaKAbGBNq0aZFx3iPvH0186cqk1mvJ2eGhL
X-Gm-Gg: ASbGnctkXYuJfXIIQOKAlXSswt2y9reBuqeU9rSEZ9WcFphClT7y3wJH9XB6rMyD/EQ
	EH1OhoW8aleSwPxRUkciSPuURMd6bMl4eFEd3V75NsBOdR1Yism1BmE9p3ocX/WU/pRBea97/Rh
	z88WIfjbe8u5cvqhrUsWum+mYWthur0aBI+tZsROpDRf8j/maczWBdheMyxQQOU0H8thWj3suJx
	Hq+9JMZstRGZBDy7p/pd/iUczfKDg8b5lXkx5/hXS/DruAsib5ycqBuNx5sOfcGfya68Z31Yrob
	BzectNFrEZdaB+/b+yeJBKbRmQJOHHIDIuv0RbFrk/A4nt9xu3lxqkUfFnsE2x2AaxrlEn79Eaf
	KBhHdiUh36RE4FtSTomH9YYs=
X-Google-Smtp-Source: AGHT+IFueRiiCJVMRgu+RUz7h9R7hW0yLQ2FkCH5TbKaoZr+99YUdDkzX5Qicx2G0NKcSCf8m5e4XQ==
X-Received: by 2002:a05:620a:2903:b0:7c5:57e6:ee87 with SMTP id af79cd13be357-7c775ae04e7mr116877285a.41.1743730107913;
        Thu, 03 Apr 2025 18:28:27 -0700 (PDT)
Received: from theriatric.mshome.net (c-73-123-232-110.hsd1.ma.comcast.net. [73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea58f95sm147401185a.80.2025.04.03.18.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 18:28:27 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: kent.overstreet@linux.dev
Cc: gshahrouzi@gmail.com,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH 1/3] bcachefs: Fix escape sequence in prt_printf
Date: Thu,  3 Apr 2025 21:28:20 -0400
Message-ID: <20250404012822.188485-2-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250404012822.188485-1-gshahrouzi@gmail.com>
References: <20250404012822.188485-1-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove backslash before format specifier. Ensure correct output.

Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 fs/bcachefs/data_update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index fe400dfc5d76..9fb020a58d86 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -607,7 +607,7 @@ void bch2_data_update_inflight_to_text(struct printbuf *out, struct data_update
 	prt_newline(out);
 	printbuf_indent_add(out, 2);
 	bch2_data_update_opts_to_text(out, m->op.c, &m->op.opts, &m->data_opts);
-	prt_printf(out, "read_done:\t\%u\n", m->read_done);
+	prt_printf(out, "read_done:\t%u\n", m->read_done);
 	bch2_write_op_to_text(out, &m->op);
 	printbuf_indent_sub(out, 2);
 }
-- 
2.43.0

