Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555261CBE8C;
	Fri,  6 Sep 2024 19:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725652653; cv=none; b=e6TffipUFXrspBTd3wl5yLqtInpMdnR2sHf2lNZDOwicMDoCSjY1SmzTvbJj3sdUnBtJtGtBR4w2jqMQ0LlnJ+34QRlETr+PQGAzxALx4WgR655VdjvuCZPOcEuc8VOKlj4wGb04bgX7mgQutg60cUgUiegBXBxLIqDKCX8StnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725652653; c=relaxed/simple;
	bh=xgb8RdA+IbqrFjakhWLWKazxC3vqtLJDMg7U8lNtgac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bo9JF+1vlnFnTCmGMYy5PJD8eMjEEP0dcOo2sO8sG1lTCdwmFYBz+WULW+EephS/cUhCF1IXCqtbR+ybNtjxe44U+i5Vzc3JTwxg+U2Y6ATtQtYoS2cAjBN4bRSc+W8aeyJmtHZ9bQH0+XzLCI5EXl2hI37Som4ajIth1hdJkD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PLbJE8za; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PLbJE8za"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a018296fffso9494205ab.2;
        Fri, 06 Sep 2024 12:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725652650; x=1726257450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U4H5uqiK1lmCZLuR+QM9RaiOR/S50itqCPBhQCgAPtA=;
        b=PLbJE8zanNjhYF/3m5niVU4yxZK9MjI2gTYrtUa+16oghxuyOoLBnjgEK22CvZc4Us
         sqeuggJ/nKO0KjARkn8jkXoTu7AQuNDcYGveTSA31CnFH/88Z2/nCV7kkuCY9FGLw00S
         4kuSK+mjsldd0alLzVLlTPaTBcfFS1BYqY1sc4rDohq9tWQHTNgeQ3tQ2vwVOToQaEFd
         fSWYiqCHOzMVpXfIcpHCZKTjpEK+RRG15rc01jn89fpR6Jx04clkBQH/CgucNQnnKx2T
         /1O0NKfcyeH5Bye/gPiB1PI6btUHUp7BowYf0lJh0id84gwupIWl03hJHUeT6ho6EYTh
         tEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725652650; x=1726257450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U4H5uqiK1lmCZLuR+QM9RaiOR/S50itqCPBhQCgAPtA=;
        b=p3z4QdjGfqQXkT9J1mnKNenEav4zOMarMT8+B5hgiCh8HqgpJlgmHPkdHWYmV8Xo0U
         Nj6c8aZSOhk/WxKgXxBRp0fD7A4jrenneqYYjRwObnpJVrZzoCO3QWLBn8N2utZCywux
         3ULmDF7HdVEMkqyrMpfLC9HQgVAWKZVoH42eespcuImL2025coaV/ZLfCNP22FHMdLO9
         EH7c5qa/IwZ6v2t3G4Rk3sAZeD+5MGsDLI5ajEHcpZXPmMJbVwbbhlRYWHeOV6VXxbdv
         ItHiNkA7t8gq0mEE07VhnmTOjAQJUZfmtmwt6NTOPh5JPDdP4eiwcHhhciZHJlc0hAAN
         Kj/w==
X-Forwarded-Encrypted: i=1; AJvYcCVq1GRIv3bd1rmnX1t+EjKnmw7rznzUnqD2FeBEgITA7jxguCBnxRwRBIjOn6cCa7cj/K1bn+XoBSYGWuVEIA==@vger.kernel.org, AJvYcCWAsKUMyvWB9exnOh2XcAOMubjH4iI8MhZdTJm/pAdUj6kHV2EUDbVPuY8bnI5UD0Ej8aS6oBfbaahO@vger.kernel.org, AJvYcCXsOFBGd7xm7qHm6MuAm4VEydUBuoPcK1A9IkRT5BTfMDu40d6pb2TbswU/yVZo2Sx87HjKi+epfjvi66EB@vger.kernel.org
X-Gm-Message-State: AOJu0Yzor8djLdVTXpUNxamVOHjfwM97//PVzrQSZQeGi8mOGMq58Q8z
	lAMps57mS0GKKB81F2eaPMiBmIAI52WUeKDWfsXkUz23sANDYcfGzaeTWofQ
X-Google-Smtp-Source: AGHT+IEG8OLXGpAN9hbjGJpcG+GcKeU1qLL0CTyrnUIbcoOfmRVOUN5wKT3GoIhHIczbJuRvohqtMg==
X-Received: by 2002:a05:6e02:20ce:b0:398:39f:8b4d with SMTP id e9e14a558f8ab-3a05744e20amr5109605ab.5.1725652650221;
        Fri, 06 Sep 2024 12:57:30 -0700 (PDT)
Received: from localhost.localdomain (d24-150-189-55.home.cgocable.net. [24.150.189.55])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4d05252ae35sm1968378173.168.2024.09.06.12.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 12:57:29 -0700 (PDT)
From: Dennis Lam <dennis.lamerice@gmail.com>
To: kent.overstreet@linux.dev,
	corbet@lwn.net
Cc: Dennis Lam <dennis.lamerice@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs:fs:fixed some spelling mistakes in the bcachefs coding style page
Date: Fri,  6 Sep 2024 15:57:19 -0400
Message-ID: <20240906195720.40315-1-dennis.lamerice@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

