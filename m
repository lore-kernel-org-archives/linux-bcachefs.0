Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6449158870;
	Mon, 24 Feb 2025 12:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400845; cv=none; b=GMh5WS8OxfWCrde2bKgg4VIwC2kc0iRps0nrjeJkoIirXcMi1IllRqk8D2r0sU1Y7LDI4jD4Xv69UEOAhUYFPRtdsaBlU2wGXqktRU1mZ+W6Dwb6MWi6m+KgRMi9z5IhZMhWB9qHA4GuhzH6uBL2FLOoL2iFhjzGesF0Y4MOI/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400845; c=relaxed/simple;
	bh=SQLajT4z7bmfJBkPXz2F5dIaF9jtUs4cUyT6QRWnEg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kf5jN5ALNxqCCSB54dCSoF+dN/y1khq2tcgpOoSjlONLZHQ2mymZtwuIkARiLr4oHZuLdDNUYgsqkSDXGnBp1rTsaRp5rIlunzwd46YWDRTPi/+jR+xEo/e4c1CzpmnryjslMooH20lIrr3uYd8RhmCnN6KXD/ZR7RwvoaPlm+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X32UPvtm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X32UPvtm"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22114b800f7so81896355ad.2;
        Mon, 24 Feb 2025 04:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400843; x=1741005643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxDhcIIfOi0Ejcuhqf9fXn1q3Kj1XENHhTye07+0O3o=;
        b=X32UPvtmPt/kTECk8AdMYyZ0RraFIEl+jW0XV26xkcvVFHR3WGAFpyj+u4bMZFMMrq
         9Q3rWCLE8mcJ/mfDFZNjmNTA5wsJasPhdLfjAZwKkIz7MTo/fN2zP9KwOGjIfeVs86za
         qtIvElfjdDj863PGrzE2nLxw+ptY4XQc6/LcLcXlvO3ToxBWogyzxjzQCR12bYaK14Bj
         Sqd1Gi8VLKHI1IOOLlzNbV9F/SSViaVnej/ZHsUXLG3yCkUaWU+kRh5LL8g79jFFuLxh
         yfkT/fAp0cYKCgozZsn00KWyvPM4HjkVrN8kC/UsyLAHlWQNaKwWXpxZuHwofHOG511H
         iUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400843; x=1741005643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxDhcIIfOi0Ejcuhqf9fXn1q3Kj1XENHhTye07+0O3o=;
        b=tkmCT4MqwPhQ2OhIDKZTvTb7mJlA51A3D1ldsOyOzOO1rJ5GsgZYpYdj0221c4G4vL
         um7V8g8mvN8oqB8BKJiVSMqtG9S82ApKDVoyieHrAUZjNaEDJbzJHg7ePe2yCjxLFuQR
         Q3WREZjYD7c9ioGASaFybl67FwfkI/zX+aeKl0veXApuY0fU/GJzL6lVj53AXJDDkROA
         9uUrfPoy/V9VbRK1aL6cO+4GOxkzqa1cuzjCn+xl0sEvQ8M8JTAjSdI4kfRQvE0mrxhr
         vmJs8BCORuUD7oy2re7JAbVFbUE4Y7Y5y3p4CaDJOJ40NQXu3+DidyMNW8tNkoZXBR9N
         iktQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfDhBN0EB0YgGV4o7fUFdaGTHFbBu8mcXJ0GKDFKatFI9Jcljpmr0jT4kdcbctnc8fJAaj9vsT/F+JqThtpA==@vger.kernel.org, AJvYcCWbBhhXtj9KXsNaGGc1FJAF/G5wjxGwSD3PS5loZNS6Y0GHLo8tLeLLMDvQwJMq/951RyOGkZyiYTru@vger.kernel.org
X-Gm-Message-State: AOJu0YyukfKy8vflTXo+IygXA0Sp9rHAclQVMOSfGqMdWmm7baC8S+Gf
	009yooIBEWk7XhnI/HFezQ9mKpwcCf1gBZ1YV1a3q5JyI1Fe40ER
X-Gm-Gg: ASbGncthWKLnUKUmilc2+WG3I9qvOk7dg2EU36oaeAuNeXyaEGceHjMStEC2/bBEwtO
	3Awc6BA2KvNgn42WqjIY+dAKvdWMXyXl3e7TL/Z408Oim5kP/otWZIeG9tX0fOAxBOCZM2ax9hj
	MY0+p3rgeDecRGM4Spr67nWBGlpDlT970ee/DWpwcmEEkAbSkDm3b1sTbdOBouhsbN6ypwAs8tY
	GaONOPJB+Ck1Em2RhLNoaPJesXfTyIDvjU5e0ajaTCemVWANh7dVYFKGmAfqjnDKFKluNfvJI49
	0VF83PY5vn083mo191psQbP2cg==
X-Google-Smtp-Source: AGHT+IHukjlTpSyyANyf1X0RijEHy54FY3sjovR1jYsCe6rqYOD7JUQhxb6PZDsCkAItbtOAJRfGSQ==
X-Received: by 2002:a17:903:944:b0:220:f449:7415 with SMTP id d9443c01a7336-2219fff18c3mr254529245ad.44.1740400842823;
        Mon, 24 Feb 2025 04:40:42 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2210005641dsm149187185ad.210.2025.02.24.04.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:40:42 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id A97A541296DB; Mon, 24 Feb 2025 19:40:39 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Wei Liu <wei.liu@kernel.org>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 3/3] Documentation: bcachefs: SubmittingPatches: Convert footnotes to reST syntax
Date: Mon, 24 Feb 2025 19:40:28 +0700
Message-ID: <20250224124028.42059-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224124028.42059-1-bagasdotme@gmail.com>
References: <20250224124028.42059-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3071; i=bagasdotme@gmail.com; h=from:subject; bh=SQLajT4z7bmfJBkPXz2F5dIaF9jtUs4cUyT6QRWnEg4=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOl7MvhKFup8/Tn5rp5DaJ6h0toEo6nPTsqwHNLZmVkYv pLL1tC0o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABPZEMbIcHCXodvP1MkhMcUp Fj0L6uuz/02qYZ2w5PzHe/PUo7LsVBgZ9kz6wV2VaHB4/Yeo8pQzU9YmGnvO7Xn5Y+59pvkG80O 3sQIA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Footnotes list are outputted in htmldocs simply as long-running
paragraph instead. Use reST numbered footnotes syntax for the job.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../bcachefs/SubmittingPatches.rst            | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/SubmittingPatches.rst b/Documentation/filesystems/bcachefs/SubmittingPatches.rst
index ece0e85d259807..a455f9cfd15c79 100644
--- a/Documentation/filesystems/bcachefs/SubmittingPatches.rst
+++ b/Documentation/filesystems/bcachefs/SubmittingPatches.rst
@@ -7,7 +7,7 @@ Submission checklist
 --------------------
 
 Patches must be tested before being submitted, either with the xfstests suite
-[0], or the full bcachefs test suite in ktest [1], depending on what's being
+[0]_, or the full bcachefs test suite in ktest [1]_, depending on what's being
 touched. Note that ktest wraps xfstests and will be an easier method to running
 it for most users; it includes single-command wrappers for all the mainstream
 in-kernel local filesystems.
@@ -39,7 +39,7 @@ prefereable to let a server farm do it in parallel, and then have the results
 in a nice test dashboard (which can tell you which failures are new, and
 presents results in a git log view, avoiding the need for most bisecting).
 
-That exists [2], and community members may request an account. If you work for
+That exists [2]_, and community members may request an account. If you work for
 a big tech company, you'll need to help out with server costs to get access -
 but the CI is not restricted to running bcachefs tests: it runs any ktest test
 (which generally makes it easy to wrap other tests that can run in qemu).
@@ -87,17 +87,19 @@ Other things to think about
 Mailing list, IRC
 -----------------
 
-Patches should hit the list [3], but much discussion and code review happens on
-IRC as well [4]; many people appreciate the more conversational approach and
-quicker feedback.
+Patches should hit the list [3]_, but much discussion and code review happens
+on IRC as well [4]_; many people appreciate the more conversational approach
+and quicker feedback.
 
 Additionally, we have a lively user community doing excellent QA work, which
 exists primarily on IRC. Please make use of that resource; user feedback is
 important for any nontrivial feature, and documenting it in commit messages
 would be a good idea.
 
-[0]: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
-[1]: https://evilpiepirate.org/git/ktest.git/
-[2]: https://evilpiepirate.org/~testdashboard/ci/
-[3]: linux-bcachefs@vger.kernel.org
-[4]: irc.oftc.net#bcache, #bcachefs-dev
+.. rubric:: References
+
+.. [0] git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
+.. [1] https://evilpiepirate.org/git/ktest.git/
+.. [2] https://evilpiepirate.org/~testdashboard/ci/
+.. [3] linux-bcachefs@vger.kernel.org
+.. [4] irc.oftc.net#bcache, #bcachefs-dev
-- 
An old man doll... just what I always wanted! - Clara

