Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769F82066D1;
	Sat, 22 Feb 2025 09:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740215953; cv=none; b=ZZX9X+0QZy4C3/r+Uwfcp1d0Blw46g537uS2Ye/Oi22DGbhxlqufpsmuRNAOvmIVOXovmKvWZu6Ua0YHEsWusZhAcKLHlfJgOQFvDcZen69GKfWxJgY3AXC5v4Tlq7wqHi36yTIIOIhGc9RP4IMPO9sFa/g2tlB6X/TD0N3i6zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740215953; c=relaxed/simple;
	bh=nBBIRijPJymDEb6vaYcK52HTsp/PP8gFPdm4maodQRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YHRPxK9vz8mj9Acj7BwW+zV/Bm0hAAB+hXQGGilErDs6buwF/sovRU+FkgOSGS64O8onUk1uyLYkePg00V9qZFeckGJ14KJY6nr0tkp3mFEKFbKBbt9pyEtXdbmPwklCWSSRLFqG54F1v8tDfj0CpIyyI2fv95LE+IKWyyiLNiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myfUwRDR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myfUwRDR"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21c2f1b610dso83669565ad.0;
        Sat, 22 Feb 2025 01:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740215952; x=1740820752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UFJ6AKFGbbK6ux0jUcpQlNT7bm5MUUBQoiknZQo2JJY=;
        b=myfUwRDRkVY25K4Sn/sItVp2HzB8+0TqaWjMNWKN5CNyiMRnNmjLH3qDJu8E98KI2R
         ANTaon0b0+3c9VMiEgOwnbAcBrcnCXUrnEnz4ebHRCwgiXI7lAYR5VNoYFJAQgm5Zu/6
         7ysaiRpxxIBXHqHCsMVAXEknE00gySvf1feLpRZe/HBCpRJehgPrmejYnt8GWoXKqnAV
         UUgBzQ58ewCcX623UTvQROgQJOurOaBiVQt7xrjuBpBgNmyQv5ADGe0ddRhwJuhXipK2
         VrpV7/QTIprHYBfkUg3XPuW0g+uMO7MPf+NThwYLfaMM87Gfb/ZDzb234L3D/gJnET59
         YyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740215952; x=1740820752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UFJ6AKFGbbK6ux0jUcpQlNT7bm5MUUBQoiknZQo2JJY=;
        b=pf1pjdnjhsD05xbZXkS6++hv/TYEMGccuH2GUJ35vStwVhxaJ8gj7tvzibQx4kmUS1
         gEuhfK3SxOv9OS0tvumglv9kpeYg90w1Ut4FgjFUOkVkNN2DA7A19uQs9LHyvFAu4VW6
         0L6NmhnFUBHFnQh3KYmjAkYlbpnYxBB/oIF43TyNL5hst7zgflUA0BeneQRJVjTOwsCb
         KV4q6dwm8hD4QopdCj2uNhexpY+4aozyX7ZipeW9G41HaVqDcQqGwulnCS8/o1qg57M1
         kgHF6ouu4QEg1/LCsGfueoJ75Gtcox35CtM4+4nAEyIf6iHhIYBXvaSIGin9b4zICx2C
         M3vw==
X-Forwarded-Encrypted: i=1; AJvYcCUtg2GezAOVfrWX+L3sNiV9QxgHzlPqSrbeEPCqX1nKLQM2cQaDRjXi8VG3cCzvUU3PMNi9hl9SoSQj@vger.kernel.org, AJvYcCXbVe+oGXw21Zl5Pp/GaRJ9QOp/9bwmkWC4JV21qnii1G1Qx0Y4E8yo23JxTe2mDivG5gqumJ7+uj4nogh+Zg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPaVlqdoI1iGpMBov4E21JW2XJLqKC3vlq0XUGu4tmunojreLF
	i4mZUlSLPEVjbKq8meIhivOOyVJfJ2E9FiXFG+IW7IkmKeDyyMsX
X-Gm-Gg: ASbGncsL6K12QLXamuMm5h4YzmCUV8Nl3qiLuHoCVw+L3Y/yNZoJ6xBCG6pcg3k36n3
	J5p/CsJLXlmHlgrqUuey3CPEHWECzey/bOzzCD8CdVmxmnQK72+3L1qmMg9LA4tkWFc59jFIc2R
	c1Yy4qMmKSgANDBUsXZJe+Ty5OtKOJ3MPbme5LcDqrCKg28licbJeXIq1ciBzhJg1+5HSvjaiOm
	gwUnc1aDQeYKhXQe4ZTIS9cnR1FgCIM1ndAOkeluEGWsPrstnqJFalvzJHHjGmu/Ri64kNe2vSf
	Mee77gTGoHkC9uOn2jQp4Svx8g==
X-Google-Smtp-Source: AGHT+IEHfAcyOPfxMjgI6mTNFM1OYivVU7ybtYnuP/8XttYupuEd0wAc1Y/QCwLcZqReuzrXPZ2U5Q==
X-Received: by 2002:a17:902:f712:b0:220:ecf7:4b5c with SMTP id d9443c01a7336-2219ff515dfmr120721855ad.14.1740215951649;
        Sat, 22 Feb 2025 01:19:11 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d558fe2fsm149030915ad.238.2025.02.22.01.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 01:19:10 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 559C14218358; Sat, 22 Feb 2025 16:19:07 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Ashton <joshua@froggi.es>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 0/4] bcachefs: casefolding.rst fixes
Date: Sat, 22 Feb 2025 16:18:49 +0700
Message-ID: <20250222091853.16487-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=768; i=bagasdotme@gmail.com; h=from:subject; bh=nBBIRijPJymDEb6vaYcK52HTsp/PP8gFPdm4maodQRM=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOk7p+ou9ZoQ+n//0SUvc+4EfDEu3JTJd//KvJPXvzcdf PGna8LJBx2lLAxiXAyyYooskxL5mk7vMhK50L7WEWYOKxPIEAYuTgGYiIgCI8PTGXt3XDn3mqP6 xvaNybzbGZoK0h3DTrxJPFnjr3b8k7g+w3+fvkM3pjaGNGq9zP8ie4TrRml28sYVNzoLzC6HVLt 9zOYDAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Hi Kent, hi Joshua,

Here are fixes for casefolding docs. Patches [1/4], [2/4], and [4/4]
fixes htmldocs warnings reported in linux-next.

Enjoy!

Bagas Sanjaya (4):
  Documentation: bcachefs: casefolding: Do not italicize NUL
  Documentation: bcachefs: casefolding: Fix dentry/dcache considerations
    section
  Documentation: bcachefs: casefolding: Use bullet list for dirent
    structure
  Documentation: bcachefs: Add casefolding toctree entry

 Documentation/filesystems/bcachefs/casefolding.rst | 13 ++++++++-----
 Documentation/filesystems/bcachefs/index.rst       |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)


base-commit: 77308424ba26e1b41a7db5d4eae121841a707c05
-- 
An old man doll... just what I always wanted! - Clara

