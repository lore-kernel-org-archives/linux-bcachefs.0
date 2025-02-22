Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10599207658;
	Sat, 22 Feb 2025 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740215957; cv=none; b=mFi0txVPJ++9BrJbB2ljuFfh2PXxcJkW74mvxndU5gXVGzghE/0Gq2yPeoNDIZnNTj8qUB0jzANm0K5rRZV7/9VwUmct5A4m7Nf3Re4bfiECz0LJoakbfEpk3Mle/bGUOeHEMfZsR9as/GPmPjnjymA3eF/5WJEuZzXDfQhg9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740215957; c=relaxed/simple;
	bh=I+Hu4DmnujOxNtjjtyFf0/ct07Cish9O0boxecFj94I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWumRDfBEhY49KA270USWGHBZ3EyI4dW/wViK6AWgVNE2d6wu9J+3CFVYfwSFqpyU4C634sRNfWHPPoesFggre7OfFs8s6/XSyqeOYuFsanuEUz5ydkMzfdmmK2ld9pc0opNOzvTZB49q/MJDss3SW+Zl3QaVkUeYSEbQa+OEKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZyOhyyv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZyOhyyv"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa8ada6662so5875797a91.1;
        Sat, 22 Feb 2025 01:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740215955; x=1740820755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebN4cyzthHKaQm0kA6H3sa8m+6Zvx+02vow0Fqtwzi0=;
        b=KZyOhyyvbBNcZc4oxSFxpEFucRD5yq3s0U1OM2YfGL9wgD9NpNoguVIWIYIjmpb2fD
         ceHRBX3R1WkjnbRpoLrugI6HbHCKv4tOXLzyFF0NUTANeGNdNHdOeAV0QlEO7l+HcxC0
         QSXMOCt+AHpSkluUY9iHjKL4fkHqiH7Em3iPzAeQa+w6HhOnqprbR4C6vE+AvNPKPVBO
         n6RuaZJqM3e0vn4SBYulRrKtxgg2SisIOVf8wVRvu3m+LPKybAsib5XAxnpS425w30Jm
         ns6YNOBhjrV1RYvEArKiN9F1f+GLH8mqEIyw3AzbaRkJliiaE5h7wp8w4A0VYRfSHve4
         ACIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740215955; x=1740820755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ebN4cyzthHKaQm0kA6H3sa8m+6Zvx+02vow0Fqtwzi0=;
        b=t5FJOTd36R8q+k+E+ZnVX6pte5yGCuXvuuvJCUcOhUJxlehEDqJXJkb5nAIOcfSo+s
         JjyM9pWkwNALaX7fMl1U2pAXVAB8kDRAk6Iesvh5i53X7sVa1TSpb08ZXKYe6iWIJmDf
         OmByl4Lvw83Gc1qUqRLYU+9oZAcCRFdRVbK0T2Hdn7RGLACD/kpKY0FLHcKSeDwIT03s
         pD10yOqCcLkgDX5NuMVjQDGtUkJb/bqkIWqQXTeEkgmTCqTXyXOVwEzMWjtPuT5HwGT0
         QFKJKy04vDNpQTJEcFnQtHPF68EeEoQitnjKhzMd4vEcWrK5UHd4rFMsiV7ZpzkfVQfH
         NIpA==
X-Forwarded-Encrypted: i=1; AJvYcCUYRloMWb1IS4D6me2UgNuy7sq+URLyZHAm4X2altg37UWxigPsba7pmlbKvomOqtO77KGCs6Rusd7CisirIg==@vger.kernel.org, AJvYcCXe1JuIB17wAV1M54WekYCqw8m5FH5PWUkCIFfoXbW7w11vpE/LYZnZTv/FAMJsuEgiDGI3w1wtnvW2@vger.kernel.org
X-Gm-Message-State: AOJu0YwbovhuoEqXaA03e7nUtazmWu/+SD568/HCGYzlpH+dMoL7MVQ+
	332kuqhIa7fsNDZ18lXaRMrO0Jeea+qD97/KinR6zvp7Z004RyCp
X-Gm-Gg: ASbGnctvf3YihWB12b6RySRSgxlU2qhamqMQrDdNZSIJcWFwvtTmL/csdaFyw3KeMZu
	Oer31nh3I2HvPRcvZNaxHctzGA9dewP0PLsluo6f0jEY56aK4iMVaT/nr00JEB6Syj28JHFbvX+
	27tD17XevSeaq+R/GEkGRKH/vWn1pu9puXOAwO5aGGuxzWpkzSxt/Q+lNtgWFv12G74W4GVLY6J
	B4YPafDZmmVF55Lh7wQNd/z7CWya5qxk38AMWt4NqkZs4Xd8lp0i54ABsK7ZAp8BuTKBVWIN93H
	+dyg5YOAyuTJIGNj5waDXCRo4Q==
X-Google-Smtp-Source: AGHT+IFnPcE/P+j0slY93PwlWMJpK4tnReFB0rvawpdG0W7f5OuQwXBT72N1VBMFdr831Cun3CxxzA==
X-Received: by 2002:a05:6a00:98f:b0:732:1eb2:7bf3 with SMTP id d2e1a72fcca58-73426d9f1abmr11386853b3a.21.1740215955108;
        Sat, 22 Feb 2025 01:19:15 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73266fd6438sm13727366b3a.142.2025.02.22.01.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 01:19:11 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id C1F1542D904A; Sat, 22 Feb 2025 16:19:07 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Ashton <joshua@froggi.es>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 2/4] Documentation: bcachefs: casefolding: Fix dentry/dcache considerations section
Date: Sat, 22 Feb 2025 16:18:51 +0700
Message-ID: <20250222091853.16487-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250222091853.16487-1-bagasdotme@gmail.com>
References: <20250222091853.16487-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; i=bagasdotme@gmail.com; h=from:subject; bh=I+Hu4DmnujOxNtjjtyFf0/ct07Cish9O0boxecFj94I=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOk7p5pxXb58Vrpml8XMFa9nrFzFVDrd1HUex88v0S8bF tvxTjqwqaOUhUGMi0FWTJFlUiJf0+ldRiIX2tc6wsxhZQIZwsDFKQAT2VzMyHBx7ovrKzd/ielg XuyRk/YtdfcLTQZGbs/U38UdDM9Dp/Ay/Hdcy/P7T61c8M+fWU6B4Zs7etjznytvsmRtt9Zxzch p4QAA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports htmldocs warnings on dentry/dcache section:

Documentation/filesystems/bcachefs/casefolding.rst:75: WARNING: Title underline too short.

dentry/dcache considerations
--------- [docutils]
Documentation/filesystems/bcachefs/casefolding.rst:84: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]

Fix the section by:

* Extending the section underline to match the section title length;
* Separating problem list from surrounding paragraphs.

Fixes: bc5cc09246c5 ("bcachefs: bcachefs_metadata_version_casefolding")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250221161911.2d16138b@canb.auug.org.au/
Closes: https://lore.kernel.org/linux-next/20250221162135.79be0147@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/casefolding.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
index 1c385b6d21a0a8..d5861b44463576 100644
--- a/Documentation/filesystems/bcachefs/casefolding.rst
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -73,15 +73,17 @@ any encodings than a single UTF-8 version. When future encodings are desirable,
 they will be added trivially using the opts mechanism.
 
 dentry/dcache considerations
----------
+----------------------------
 
 Currently, in casefolded directories, bcachefs (like other filesystems) will not cache
 negative dentry's.
 
 This is because currently doing so presents a problem in the following scenario:
+
  - Lookup file "blAH" in a casefolded directory
  - Creation of file "BLAH" in a casefolded directory
  - Lookup file "blAH" in a casefolded directory
+
 This would fail if negative dentry's were cached.
 
 This is slightly suboptimal, but could be fixed in future with some vfs work.
-- 
An old man doll... just what I always wanted! - Clara

