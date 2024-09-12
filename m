Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB455684;
	Thu, 12 Sep 2024 01:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726103822; cv=none; b=JYmMVDfbiXGKeYCUfkp8kIDx+96Y24cJvud9Rp3lMOg8RAsDsbUrV5hqQFT/e3t3BMRhWWERSqYgc/Cp/HJcWp9K/J8Ns29372sg/aDDYX2+Z9DZp4eFeHiKVc4In33IgL7m9tkzLiOCETETE7DRvH6bP86+vhXbj7qYzieXgio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726103822; c=relaxed/simple;
	bh=QHsU8N87ajGHNvG7SkWHAwdOP5xSbhjxwmgb8LHviJI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNnQ9l58Zba24vNqJ2Bjsg1oai17XVlDb+dPHie7TE3QpUv2QzAyA95pQAxUmGIVx6miOmrzZUg1JlmYquPD24mGmcRa3BNOWNZLh16DeUWRga1N6Wp9wocuuodMo0iYprdxEzQSwheEvADdX/LQX4IBNo+MkeP6vH1+AmZ6DGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DsOzGFmV; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DsOzGFmV"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4585721f6edso3011711cf.2;
        Wed, 11 Sep 2024 18:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726103819; x=1726708619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9Ce9nGjZFP5vHJs9bz+yR3wENufdBul9eEWmrVfgH8=;
        b=DsOzGFmV9CanGAhjbCakQMxL3cAjYPIhXYMEvh5Y0JY7TRdFKZbBGxAyH85YIRsi2Y
         QJ3igGwsl+f8GPnnxcMjg0JQ4SixdcIONKMplawGVXlmHiSjG4K1Db5b+epP82CyvHLT
         AJP2raGQZqdvobTDT2hio+FpMtu8sILpzJPqFwEboKek+0TQbvk7Lk3+vsNM9FbUd7Bi
         jkAAhStPnyKRa7etrY94IIZSTi5Gz6E7aS6oi6C0Tvl4uxJHLimGVOoFMzXHsmCmTadU
         Slm2iV9K3CvNA79sBOWeQstVeAe9uoBi5RRDteQpEEroo+PXDtVS42ZcLi9Ejj8N8YAD
         do8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726103819; x=1726708619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9Ce9nGjZFP5vHJs9bz+yR3wENufdBul9eEWmrVfgH8=;
        b=bdw2SlXFPDcEkM5limOmmZnYsdW6ZZlRN4bTrZN5wnlZX0MwajI2kGtzhWSyK3VHjt
         B/JMdSVjbtrgij+s6fg/VlF+QyvQUKSvbTHJWshf8XpltTkc0FNVqwiOEt2os9ZW4enA
         eGKdF2obakDAQMJRxzxCMubCjVDkQmeMueFSUQrG138e9dU3o5WqQDf5rqTEDSnHH9Lw
         a8WZB0d6FLHQZLjjE6FvlRY67CEvWMlUtAhnN2uDuLxYlhAE+w2VhnYWfIFIUi5qsgZe
         PRK06MYKxELeJY4ByPOlBs05AgT1I/IiCRu+J5GXMHWH2OkFq8vQe8eqkkLPdhw96EXF
         IpDw==
X-Forwarded-Encrypted: i=1; AJvYcCVDKiOscacgLIldJgFvxqw0uEDxpUcJ54Y+UHQhFcvAsrReplv+UOM4O7co7udMFbCcQPM6FmPN3e8lpFG8@vger.kernel.org, AJvYcCVRqPDeVBwbaZpe4plVh0uxYR1Oe0kfY3TjPKeOYiSg1p1yahplZzMqJnVO3yLOpCfnaiEulpCP06A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjWTAfjO2C5zqmAKQT8mD88Wv2LDJgsg+k2NkTZOebM4clp/AA
	6ejnXOZ/Uw2QyL/C+Dcp7ksvk8X9yGarVlt3ipyNQQRQJs7eP71k
X-Google-Smtp-Source: AGHT+IFblIHJnaDVwGh4GzETKTU5M0uWbRP7F8yh0VAq3YMWQXVcBEBz7bfKQ3ON8am6DPt38xlgsg==
X-Received: by 2002:a05:622a:205:b0:458:2619:36c with SMTP id d75a77b69052e-45860358394mr17039931cf.35.1726103819397;
        Wed, 11 Sep 2024 18:16:59 -0700 (PDT)
Received: from localhost.localdomain (d24-150-189-55.home.cgocable.net. [24.150.189.55])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-458320392cbsm34695801cf.61.2024.09.11.18.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 18:16:59 -0700 (PDT)
From: Dennis Lam <dennis.lamerice@gmail.com>
To: kent.overstreet@linux.dev,
	corbet@lwn.net
Cc: linux-bcachefs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dennis Lam <dennis.lamerice@gmail.com>
Subject: [PATCH] docs: filesystems: bcachefs: fixed some spelling mistakes in the bcachefs coding style page
Date: Wed, 11 Sep 2024 21:16:28 -0400
Message-ID: <20240912011626.11614-3-dennis.lamerice@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Specifically, fixed spelling of "commit" and pluralization of last sentence.

Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
---
 Documentation/filesystems/bcachefs/CodingStyle.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/CodingStyle.rst b/Documentation/filesystems/bcachefs/CodingStyle.rst
index 0c45829a4899..b29562a6bf55 100644
--- a/Documentation/filesystems/bcachefs/CodingStyle.rst
+++ b/Documentation/filesystems/bcachefs/CodingStyle.rst
@@ -175,7 +175,7 @@ errors in our thinking by running our code and seeing what happens. If your
 time is being wasted because your tools are bad or too slow - don't accept it,
 fix it.
 
-Put effort into your documentation, commmit messages, and code comments - but
+Put effort into your documentation, commit messages, and code comments - but
 don't go overboard. A good commit message is wonderful - but if the information
 was important enough to go in a commit message, ask yourself if it would be
 even better as a code comment.
@@ -183,4 +183,4 @@ even better as a code comment.
 A good code comment is wonderful, but even better is the comment that didn't
 need to exist because the code was so straightforward as to be obvious;
 organized into small clean and tidy modules, with clear and descriptive names
-for functions and variable, where every line of code has a clear purpose.
+for functions and variables, where every line of code has a clear purpose.
-- 
2.46.0

