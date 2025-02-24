Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A746233731;
	Mon, 24 Feb 2025 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400847; cv=none; b=XciWy6fs1e7UuadEL/pvQfwpBdSFZ43iuj29XywiGhjikRO6XSbZkKI0cZyh4ymG3rpzFEpAwjiQWC/2lOgrtRIYQw8s8UGFK6M6GeqczRSmPZO5DahNoUaFxwBajd8JUzoQ4oKtMg3lhq9eSiFjWkk73Pw4ac783PElcKiWkiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400847; c=relaxed/simple;
	bh=ltMkYluF7v4H86I+PLGn409RIPQJDWdAwdWSwrXb2xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPEZmwWrBhfpnK2GuYU7/cah2uw4jo2lcs8ADDK8Mzp5Wd5kYlrZ++INWZK+nRWaXCPbfqVxxi8jDHtDRS6bAanDldf/+ZgJzpaqUNokKb96aGngYqMU0RkHjRAjRfbCyh9++hbYg9i2iReE2NvG2nZYKy4IXE0k2OlnZINh8/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDhBRG5n; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDhBRG5n"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-220c8f38febso88574155ad.2;
        Mon, 24 Feb 2025 04:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400845; x=1741005645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPFBYT/eZDBg2FRRA6Ij22jK0e44FN4G15uWJnLb6Qk=;
        b=PDhBRG5nLrHs3gnnlJXcV/wRzDF6Q6vAEBYzBZsTRJIIDZnJyXeu3Kpg5ncu49HBF6
         7aAwlVQeyPZs7hybiIR6n7iTSaaMTgR+iBUuROl0XOhOCvJS+HjnFRqClX0KbNW1m+2X
         OERTrIaWOMGpOrthQYhrkBINyTWKnrrfjTNC/wlqnAhPBdXkmYyUfbqJxIgHhAHGxcZQ
         O9c+HojFtk7Q5p7ewudSGHkYaYP6OhBQpZYCj2FMavvajMBtbQorXXXe7F+iwu9SG2ma
         gWa+9HTUenJZwi9wPoY33UqbY7PGdE6FDf6rO/5EvNeq1eQz4hyGZVpFLuXfE/kBcQKh
         6XLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400845; x=1741005645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CPFBYT/eZDBg2FRRA6Ij22jK0e44FN4G15uWJnLb6Qk=;
        b=Tk975H/5Zd5qwGBnrl4x03APzVBHmmsl41DTNU1HOfxW+Xp4THEETTU4pwZobymrm7
         jRpFbp6ivdEJ+DOpbQ/+RhQR9pq9rB6GlFKP0tRh/ZCiyaYduaqEtR+a0d/fYVvU3bE9
         E4VK2n4gtbAO6tavI1db79547BlFnoprB60q9BY+FLwdNTtXiyAUB9bbVrmHyuibHd9E
         DKIH/Ljh4pC1DjtJN972Ycw8UyK8dtGMuZ1LLCRH57mtDDXRN2IO9q3T6rjQcnCQAfyC
         piN7hoySE5XzQaBcxbWsfrGo2utjk5yT28FjICw/Lt2Kp6m2B+ritQtb1m9pKltkppdL
         MHeg==
X-Forwarded-Encrypted: i=1; AJvYcCVBkkyGyw5Y9lVW97DyqjLyTSOMvukexb2C24EMDz7Mw6dEhjowABCcm8EQmlIBaB4k14lsgRBzCK7T13YB6g==@vger.kernel.org, AJvYcCX9dhPGnEf6mXxTOPb8F5kadhOnaNLLUZBhpJ5c7qs7mEzj2XZvzDqv2zRoFldzk1s+YvFTB+bQn1Y/@vger.kernel.org
X-Gm-Message-State: AOJu0YzYtJ18mUKSiouYeMH+TSQUEJrpUm2d39ZUdjuyiFqBv4IK6YBc
	4LYCFwhqBUYsewtnVkXvUI0JP8hBWwxYFp5WlICbriHvRq4wllAY
X-Gm-Gg: ASbGncszPj2yTHpyTsfRilk2oUjM1OwjPVAeFpOsjOL/A6F5fPMbqXoFNQ4ntQbYPSS
	s4dTO/OhpR2zh5qW/buWi/nA5i94Q9ErA03mWr3F3da1jPZNcqMQL61yzYHUzQFk7x1VyhhsKSM
	O0h28TB5iYT7xuTIIoyyx+Q7qqHPHprlGcofpvPeo5mlI9d1DsoL4EIMS/itgxf+rN1/Gq2zJ59
	QwKZiWIHv5tQdSeL/5rFGw0UHorrR1ciApT+IcRVSuTLNCyqM8DxzFCQrE/G2J72+lXE5Q0X3jl
	yN6lpr5to32R55VJYKl9HA39Dw==
X-Google-Smtp-Source: AGHT+IGlrqpxrCJHs+wl2oqV3t76Dp4tdLNd/o4ccrDlub4xpdcRibwIr/Hwl/Oc0OmQyBQaCr+mXA==
X-Received: by 2002:a17:902:ec8c:b0:21f:3e2d:7d2e with SMTP id d9443c01a7336-2219ffb8b65mr194086615ad.27.1740400845365;
        Mon, 24 Feb 2025 04:40:45 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545d088sm177926175ad.129.2025.02.24.04.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:40:43 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 8D2E9412B0AC; Mon, 24 Feb 2025 19:40:39 +0700 (WIB)
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
Subject: [PATCH 1/3] Documentation: bcachefs: Split index toctree
Date: Mon, 24 Feb 2025 19:40:26 +0700
Message-ID: <20250224124028.42059-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224124028.42059-1-bagasdotme@gmail.com>
References: <20250224124028.42059-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; i=bagasdotme@gmail.com; h=from:subject; bh=ltMkYluF7v4H86I+PLGn409RIPQJDWdAwdWSwrXb2xQ=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOl7Mvi68g8YGu6fzStvKeb69JvaxLOLC2/F/vcr2fO3a PekgjTdjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzk9QGG/x5vLIVn+0xfuVHw X03z4U1uwd4r7m0LPBmbPDPA4cK3bn6G/w7xE54vejn1hs1U7QZ/jT3XnJVy7i32jhaZ/2rH5yW LVnECAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

bcachefs subsystem currently has 4 docs: two are development notes and
the rest are actual filesystem docs. These two groups are clearly
distinct and can be organized.

Split the toctree into two, one for each docs group. While at it, also
reduce :maxdepth: so that only title headings are listed in the
toctrees.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/index.rst | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/bcachefs/index.rst b/Documentation/filesystems/bcachefs/index.rst
index 0415b5d781920d..3864d0ae89c10b 100644
--- a/Documentation/filesystems/bcachefs/index.rst
+++ b/Documentation/filesystems/bcachefs/index.rst
@@ -4,11 +4,28 @@
 bcachefs Documentation
 ======================
 
+Subsystem-specific development process notes
+--------------------------------------------
+
+Development notes specific to bcachefs. These are intended to supplement
+:doc:`general kernel development handbook </process/index>`.
+
 .. toctree::
-   :maxdepth: 2
+   :maxdepth: 1
    :numbered:
 
    CodingStyle
    SubmittingPatches
+
+Filesystem implementation
+-------------------------
+
+Documentation for filesystem features and their implementation details.
+At this moment, only a few of these are described here.
+
+.. toctree::
+   :maxdepth: 1
+   :numbered:
+
    casefolding
    errorcodes
-- 
An old man doll... just what I always wanted! - Clara

