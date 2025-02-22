Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC18206F3A;
	Sat, 22 Feb 2025 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740215956; cv=none; b=o/YtP/HJ6q7JNagae4a6jDCnIsB+MIay/5ZWJamJha6Jx3vyZUsMGkRKLJEKdLtAft4X8AYolEcX4KXm1c7FQuwfc/j9DQAHEE/x/Tdmrt5oaPg2QyBfZNe++9ZWmAMp8uHqOKJfVNak+jeSdl62znoDd/fWJhw0UxICjfiVyNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740215956; c=relaxed/simple;
	bh=GPvHd1NrZQbstxWEAi59upWEyTaGliQIzEFW49ggenc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDgO8xbUphnXEKM0geyuaAwb+O2KZCSPMCwdKf9irYLO0zfVolCfKxo3Cxfd5LkWHRjTB1CPeUJDYy8Wrh/al+mHXIpz9Mr/IvyCfbrXhAAbTxgOZpW5cw5r8lYclKVOSLeyqjWfjBejvcoo6CHRGo9oSWI90tie3mgPrMKyT6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBKbEv+l; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBKbEv+l"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fbffe0254fso5912652a91.3;
        Sat, 22 Feb 2025 01:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740215954; x=1740820754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1qQy4fjapAeS/W24BsommvSixWnehGKPR93GX3XfSA=;
        b=eBKbEv+lKABYVeOce9ICMPEsusPN4p9i+HpdJCGxTziTjy1Bzoz3CrwaXjCh+IKIgy
         ce5hw9LOq0IFbHbntYYtWIEB+yGcYEuaZ7CQhEItqhkhjZLEFWU3NPXY6ZAwCR0it5xy
         aR2248ZZ/vZ+1s7f5sf8GVwsXec0puyWtUJ/Y1j7SzWLS4NNab9O1XPsAucjuid8uH4t
         Yv/Wzbx3+VVurXsEBcNMCnrDTLSp0mmWVP2VguRy/gbZ+g9hp5fGUnzTFFA7pKv/2A/G
         pF1dWhA7UdHhxchfAEQUxjSKC9769olCTD/vBvzo+n/l2sb9FvCMP4d81xyds2TZLGmL
         JX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740215954; x=1740820754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1qQy4fjapAeS/W24BsommvSixWnehGKPR93GX3XfSA=;
        b=dAFiYyCj4jfcuOIC+jAXZSKmWRuZy1zJdsqZfjtfKZC3VVTjVKppN3Wno0aQftRaU4
         o82kV9DkchjiXI11OKmpLuKnyMXiyJes2fIsVysFBSe3WEnw2Wq0YH9TsaADhoeDr1Tg
         F43e66tjzZtJ9L2pLk6tApJ/MSl1ry8jQJ/pYnCL4ozmbmDGKqAy5cR1xfhcB5s0ZQgs
         VDQt9AnBjd/m88dSbWIPJHREB2XAoQ/0DKtJwIivfLRTuzO1r04ORek8xi5V3PxOmDmN
         07TdAVB7gLrH5MJ13kz8zwv4UeVLywbf3nKf0OKIeGUWI06bzJpva4lBYefyKRuNIa3j
         oLHw==
X-Forwarded-Encrypted: i=1; AJvYcCWaEnmCPmC8xMgXtYXmpwkK/nGucPB71n4RZ13LwXo9vUnuPkHJ3krj6VXVzAZhksQa3TsJnuWVplcO@vger.kernel.org, AJvYcCXAKKP3VyfHLLU+zaj82mS6jZ3Ji9Buqr8KfhWS/5lF/swO+8gpz+u977gh0wvvrnEhZixSg84PwT13TcwL+A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3uHGZK7VFXYGitACvUz917o/QGn7DYM3tspMULLQo6hjT73wf
	qkhU9lUZarP+4LNWJ1TO+PiZWmvceJBcVwUfKPKqAFlGuv5kfw9U
X-Gm-Gg: ASbGncu4tUGEtKkBJGVsreUUoFkQlV0PWOMXkiWRoOn97BPnbvMTdrq+G+48FspEDv7
	/GY+UeBc1JFtH9bf8YfegA6jGxz8tRTGRDHJjUijkdwmHHVoJQ7L+HhVzlomOVtuZDbm2Z1V2cT
	UDZfL2c0qiapD9tWH70JosKTjrtSvvDOxBCd9ZK0ZKEn0PWLB20CpW/RIdiCNA9JXAvcQt7MSOF
	evmRimd0JhCuC2xCipUHW9/Jc1OlIx+VbN6hjBNbOw7NiVi2qEpr+/GlKFskbZpCV2OaPw0fJCs
	ml2lZ0v9xPznZjauc7UfIP8ZyQ==
X-Google-Smtp-Source: AGHT+IFnH68kZlDtrEgag2LrOJ1a7YUl1B8syuohVJAbSHgLGBm/yXw3S1AP/WiDyAPmXjE2ePxQjQ==
X-Received: by 2002:a17:90b:2688:b0:2ee:f687:6adb with SMTP id 98e67ed59e1d1-2fce77a0195mr9486534a91.3.1740215954205;
        Sat, 22 Feb 2025 01:19:14 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb02e387sm2752753a91.9.2025.02.22.01.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 01:19:11 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id F02D742D904C; Sat, 22 Feb 2025 16:19:07 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Ashton <joshua@froggi.es>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 4/4] Documentation: bcachefs: Add casefolding toctree entry
Date: Sat, 22 Feb 2025 16:18:53 +0700
Message-ID: <20250222091853.16487-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250222091853.16487-1-bagasdotme@gmail.com>
References: <20250222091853.16487-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=bagasdotme@gmail.com; h=from:subject; bh=GPvHd1NrZQbstxWEAi59upWEyTaGliQIzEFW49ggenc=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOk7p5qtXqmesvhZboea/lR3XmaO5u2SpXo8XX35qZ7Xr 197apnfUcrCIMbFICumyDIpka/p9C4jkQvtax1h5rAygQxh4OIUgIn8XsTwh+cIo4ONut5reaGq +2f+M50235Bv2nRG6sZHLYZ3rC7XPjH8T319erGgzD6OM09WX38Uveq98KJTE7q/OvoFz/PXTV9 yjQ0A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports htmldocs toctree warning:

Documentation/filesystems/bcachefs/casefolding.rst: WARNING: document isn't included in any toctree

Fix the warning by adding casefolding documentation entry to bcachefs
toctree.

Fixes: bc5cc09246c5 ("bcachefs: bcachefs_metadata_version_casefolding")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250221161728.32739f85@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/filesystems/bcachefs/index.rst b/Documentation/filesystems/bcachefs/index.rst
index 7db4d7ceab5826..0415b5d781920d 100644
--- a/Documentation/filesystems/bcachefs/index.rst
+++ b/Documentation/filesystems/bcachefs/index.rst
@@ -10,4 +10,5 @@ bcachefs Documentation
 
    CodingStyle
    SubmittingPatches
+   casefolding
    errorcodes
-- 
An old man doll... just what I always wanted! - Clara

