Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A96D17FE
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Oct 2024 09:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728811243; cv=none; b=TzHlX4wS7qod2Ta010eyIYwhDAN4xKx4aKf3LU3IOZak6zhAqvYKCwhm+8WNNN9izHmi6J3Inv0K7CzeVJi5YbLgRAzmclbFvcupQmq7YC9gKbg1C+B44+El1JdLejoqZzrHPhnJgdOFHgj/2fojm5wt7EyR2/7dH/O/D39ZWbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728811243; c=relaxed/simple;
	bh=+X8luJ3g6zzJe2aZmB10ZtKGa8c9CNSmzZUjek14TSM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bkbjy2/HorElFi6bCKyCr4XeBa7H8o1d9FPCA5i1SPPjgLaC8+VZwXUlMU3tX60KGakLgG3IGSEEwT283K71gzsyaQnMcCDmbQ+lG9nNSWa2tclEZh42HRaDMq7ZhgVxkE+RsllFbbgLcbiwfdi+QL/zm8JMqGxF0JM8VELBeXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aS6aCj1M; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aS6aCj1M"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6e31413a196so27039927b3.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Oct 2024 02:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728811240; x=1729416040; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ESibpJs1Fq+Ud3OANB2RB3bJInOI0vpktJpsN/35Qwo=;
        b=aS6aCj1Mq8z3Y4FKU5DO5iyjZuiDxLACPB/Mg3p9UaJEBJUy3saNeDMWlAn/O3ux2I
         6QubfKJ7ev+YDZeXdpmUC+Aj6ThkvrIuvbWKaS6FuBSz8re/VETi2NyLsgS2LQ/+H272
         SV7W9HQlmzD7F6GT0bdpMP00AiBkhCKM0uwzteEB8Jsy+BTZ/I/nqcE8btIFaxBImDS6
         2wGZHVcgiDMn4X5GEEf81f4Kp7yozjlgkFSuv+VzGwP7ARfu5eGw5ne7tivAOyzCs6Cc
         Qa4pPZRuqCWx+JspcasSOFjfjeIgDvPLDp9Z6o8SRs1gkvVXNkd1zMsw/XlRMBcVIDEC
         CsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728811240; x=1729416040;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ESibpJs1Fq+Ud3OANB2RB3bJInOI0vpktJpsN/35Qwo=;
        b=gZ8sG1knSeAFDN4iW40+uzo6DnVCg28JYaAkn2SJW5zTE/c++vJS3TPYEvh9rV7pqL
         pvEGr2jdw2GnDjCEkxP5I5fvNplYIiNA44vC86/dsGA+rtdmZusbbcf/ZhSRdWl5nfb4
         VxaUlVZ7cKPd6+zwOYaIaAyixS1hkpxOJKVyHgMwJW+x+tI3ZCWeLdA9RfGEcUCWdHjh
         cNQRHBwt6FiCc4UkshpK0P9++hRrqeA1xrVCAemhzQ1n4l0B4k1WEvN39JJX+/CSSQ4m
         lLAEXeqWi1rXi/smyXCBM/5VD7ySQYkrlU/b1gLNwyjedUZMKVySABcDHIvMHySbvkEF
         JLIw==
X-Gm-Message-State: AOJu0YzQtPMsSVkyfCvYYkZdgaJeQelxdPLIiw7gBsLgD12rey+Fsz1P
	QAgfDyS/92ufpYm13lGOIaeCvJXa78Bc4MV8GqWnbbYjrcjMZDm32apg3/z7kizAKXrjuWg3SD8
	MQSk0je19IvBkauEi6T+rN7RBXYQ=
X-Google-Smtp-Source: AGHT+IFY1jZCAX6K288lQ17lmYHr5rEDuUSya27OSz/5tjxSOsr6ljjw0ibEncoj4H+6FXKFTgSA3RAfOkUZKMZcwFI=
X-Received: by 2002:a05:690c:720a:b0:6db:e280:a3ae with SMTP id
 00721157ae682-6e36434db2cmr35435597b3.23.1728811240455; Sun, 13 Oct 2024
 02:20:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naoki MATSUMOTO <m.naoki9911@gmail.com>
Date: Sun, 13 Oct 2024 18:20:30 +0900
Message-ID: <CAJQdmQGPTWRqN_DOhjgASCQWSKGRmZDUWC9DNzvpazOQxJ9hzA@mail.gmail.com>
Subject: [PATCH] bcachefs: Fix incorrect a year to seconds calculation
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, =?UTF-8?B?5p2+5pys55u05qi5?= <m.naoki9911@gmail.com>
Content-Type: text/plain; charset="UTF-8"

A year to seconds calculation includes '*7', but it is wrong.
Fixed to accurate calculation.

Signed-off-by: Naoki MATSUMOTO <m.naoki9911@gmail.com>
---
 fs/bcachefs/time_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/time_stats.c b/fs/bcachefs/time_stats.c
index 3fe82757f..d9bddda45 100644
--- a/fs/bcachefs/time_stats.c
+++ b/fs/bcachefs/time_stats.c
@@ -19,7 +19,7 @@ static const struct time_unit time_units[] = {
        { "h",          (u64) NSEC_PER_SEC * 3600},
        { "d",          (u64) NSEC_PER_SEC * 3600 * 24},
        { "w",          (u64) NSEC_PER_SEC * 3600 * 24 * 7},
-       { "y",          (u64) NSEC_PER_SEC * ((3600 * 24 * 7 * 365) +
(3600 * (24 / 4) * 7))}, /* 365.25d */
+       { "y",          (u64) NSEC_PER_SEC * ((3600 * 24 * 365) +
(3600 * (24 / 4)))}, /* 365.25d */
        { "eon",        U64_MAX          },
 };

--
2.34.1
