Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038B05789D;
	Fri,  4 Apr 2025 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743730113; cv=none; b=SqfBudax9TtpIg5w8xgyex9ubGpUyRiHm52zrf2ofbUFuSaG7zgmiPfq+8FzFwAkkVkEzmq5doV8mW+jfzzeml5ZCHNlKt9LETmWSEMV9V5fm3hdS/bEBbHJ73fnRy2/mKHd0O7YERcUJfUOma/Nj1lSHB2eTdVlw5Vy6eb59fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743730113; c=relaxed/simple;
	bh=rIpbipKaSZwzxcSazWpJgiVIkWHhxh9wS2F9QUtHSq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg631jTuRInVPrDg7pGY/Jz8YLK0naQzcXHUX4ZdPfIvEsJkVB9AMHWbVePOhFBjPN1VEtZFzIvlfr+/Vgq3Te7JKIT8YhccnLpkd6fHOIzrJr549CVeak858eZN3Sqvx4nxTJ31ezOVSmgVCk0ZvqUqAuoOSo3vghOdskwxZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pc9zYCC7; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pc9zYCC7"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c08f9d0ef3so84500385a.2;
        Thu, 03 Apr 2025 18:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743730111; x=1744334911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZKJu88jh4mbtsr5rz+BBFFaZRXP7TxJVqLawVpGfJpg=;
        b=Pc9zYCC7+0xxe5UgZpVZzV8sZorsQZRsELdeTZzQzWgRH/15QGyQLf6zNxk1Sie8Zx
         rzUjRx9AKQUZ6z14cAjmD8uhr4Bbo/dD8Z+vSkvD3vetRVipRmLhIL3qhhQ/xBa0csxu
         9k07xMBJvali+h02eTMVVhnFVlavJEDh4apQNOlD9cWD+bBJ/ww6DUV/VpzLFjll8rms
         U/OizSeEqIXEuof7FcMgaAkUkh7mnGm1+6AGhichpVu5ovQ33aYwo9m5cOwbS5xwn2V6
         WriOi3Cr16MneFD9zJuGtJAuZWCsGbJhPQKM5fNqhweS9W8GXuxhA+DQlce0q3pHTaRc
         DTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743730111; x=1744334911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZKJu88jh4mbtsr5rz+BBFFaZRXP7TxJVqLawVpGfJpg=;
        b=lPRpG3B1E+t44XpXEiZV3bn9TuFNCMR167+zmScsnGDlQCQRTVQg1rNxTUoHnTUhh0
         eNlW8NDcWIG+9NSLIU890VkQqqhNGv69f5cTi+fJurHCzUAE9hwRdRMPCDwgror1E2Lr
         9eoWud+A3AQG+lDmc/h2vwqnOjomby6lvIBFx5R1+5yzcgef7Xaf18rLDk7P2ck/y9gJ
         u6YgC2NHHao+sInMyNuJq0+n49KMyjGiLo0dpC9Xn5W5McWaExEdrLMkg3ZWvkGW8/VQ
         Af0XzQXP5Fh7ul4E2jHmQBPJC+vzz3oG9387fLLhwp6SoBKLr7R6k3WuSrLjLM0nTF0U
         fLYw==
X-Forwarded-Encrypted: i=1; AJvYcCWluKKI4nUP9b6qgWZuVal5BkArAhKwpiIvv8mpg4fgGHAOJSwZ3mlVBCCSaaa2jSRu+O+EC8/hZDR0QdCY@vger.kernel.org, AJvYcCXpSok9sAyELLQuPbV3rMqRnbLSFlvK0D01WFoPYQGXvLIRQKJ/qkVKZRAyGeqYIhqvlbVXuMcpxiRYbGgU1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnVfyHI4ZgS8sLlM8aJIPJc7Z2qwI5Rf6N2VK/zd/oGzsew23d
	JMnn3JL4Pq4sBLp2Lj0bErl0yKSvsP9JFx46Z+rdnu6qrT6xeNB3
X-Gm-Gg: ASbGncuQEYP4h9AC8NOOFZMIDoZOqGcYM2byDCAm2sCEoIpZ+F+6sQAZmfxZEESfIjV
	BV8GP4LgkQMKTnsijKGVy5hsFN4yI2Lluju+lGT7Q6EFNp6bM63CYm8JJ0VIeY03/PzvHcvKx0R
	jPIykKVrB2Ia/Cf8DCAiAzuEUupgFvoGSyHGOtJt/3GSdXKCmBeZH/i/VvtnCerHtRrAIi1yeBQ
	fMlpVHWeFBoJHrBRtImflOX79Bfd8qDV60RaMeU3WcjngKnICiRnN7cuqhxgiqxj3ldBEU3i28F
	NjEA8OUcm8r+jgPp295XtluF44tSiEJnb/u9IVhwr226cBRv0LOHlQvIqno9OZzvqfLsQLu7+mI
	8CvDGinl8hVaC33mZl8h1wbY=
X-Google-Smtp-Source: AGHT+IE2g3ZuJL9kYDpe6cJGOiCLNdbrBbng+BtoV0uybDV4dNGAypsGfwfrcNl5Sr2kL54wHyMiDA==
X-Received: by 2002:a05:620a:1916:b0:7c5:e370:5b1 with SMTP id af79cd13be357-7c7759eab09mr143479685a.7.1743730110894;
        Thu, 03 Apr 2025 18:28:30 -0700 (PDT)
Received: from theriatric.mshome.net (c-73-123-232-110.hsd1.ma.comcast.net. [73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea58f95sm147401185a.80.2025.04.03.18.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 18:28:30 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: kent.overstreet@linux.dev
Cc: gshahrouzi@gmail.com,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH 2/3] bcachefs: Fix type for parameter in journal_advance_devs_to_next_bucket
Date: Thu,  3 Apr 2025 21:28:21 -0400
Message-ID: <20250404012822.188485-3-gshahrouzi@gmail.com>
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

Replace u64 with __le64 to match the expected parameter type. Ensure consistency both in function calls and within the function itself.

Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 fs/bcachefs/journal_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 2debc213e47c..ff2fd20aa8b0 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1460,7 +1460,7 @@ int bch2_journal_read(struct bch_fs *c,
 
 static void journal_advance_devs_to_next_bucket(struct journal *j,
 						struct dev_alloc_list *devs,
-						unsigned sectors, u64 seq)
+						unsigned sectors, __le64 seq)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 
-- 
2.43.0

