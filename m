Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11D92066C6;
	Sat, 22 Feb 2025 09:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740215953; cv=none; b=U6gRkLFBtL/Slva8dboCfivlkXt1cnMNBb2+BKE4dLBHCuy1VNOue3APfJ+mJ2TLwhvqMOLfUVyZVoRUrJS1YSYuRWweAe4T7K4G19Vc8saS0PwSsrH2tUBRkGihacOCNYoEwevKKospuxhxpuu8A4/aBo+Lse6hm6YPkKGlrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740215953; c=relaxed/simple;
	bh=MFbqUyuUwH6JHPIKpWRngzRo3nDBwc6+iIsV3edeApE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUbNiSZydl6KZgAq7Zxy6hCUkTc8nGqXdPyPV/iFgPp0vRSsoiliYWZ3wsX+Hbrt3wiu7LG/gptTYUNqM10rlvxMwYIA1rD5TEZZUH8u6QJvmI+OLppfKWZDL0AIgU1iOARD7iDRiY0JLGl9firhUMlm5oTokNgFaUO9UP0zQAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lk7/jg9B; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lk7/jg9B"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21f2339dcfdso50534095ad.1;
        Sat, 22 Feb 2025 01:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740215951; x=1740820751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CmN/h203aIe7+rWc2FIijkYQehqDGYKo0CapkZmle4=;
        b=Lk7/jg9BXnRK2mL3UlrwY6lMBzhLrLHjgWjpBcqNBBdyDCYiC91pHE0s3wuOt5roBJ
         tWPX9ezZbQtZz2Bzb/3YIuRw17/XLFS13YgYb8+VhjXzJwWeTGDrxHht29cxId/wl/7u
         IwXy8tWmsZmgL4I/4RDOsv96MqP/XtQO+sScL2hrA+AACgiJBaInlYB9OVOmiY1QUvq2
         bf3Ap3Bykgk7b9+UW9AztEA3uTi45roVfF8o5TL99JjlqtPnEQbE6Wz/PG2MW6V17Kz4
         bcjN2bi9IG5LnAnMR25BGmBNEL6AEF3BWrHujO4SyXyCA9pEh332iimfQ7MP8GvM46sj
         tPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740215951; x=1740820751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8CmN/h203aIe7+rWc2FIijkYQehqDGYKo0CapkZmle4=;
        b=JxifEb+72gCgF0gpLEuNGnTSxZ1hz0+bQqI/JoZaQIs44b0PTgdJlZn6U/zCFWDi8z
         z0UUZu56IAO8qHuwb5GWHlV74g14MdgfYGit6W47R8x41niRnxUIS9LNTn/o7n0POGc6
         iDYTApdGYfjkMhOf1OyrrU3+oI5Rx5EgOM2vdYfS/yKLciZjgJuTY2qiVgQt6Ogq/KCx
         ofbt23s8Btx4QdK7tjg03E5cCR+/EfsKbkULeV5qdWqQVcIMTg/KfIJnnpGtaLLzPgUt
         Fa3IPk8pM0qsbdfjf9FtCY5xIDUwPTblhE9CN7E/6iOR9GtksFh/ZnkRmhBcqrvGPQn1
         h/5w==
X-Forwarded-Encrypted: i=1; AJvYcCVVoORw5GAxAOgTvFcAyBhLez0N/5QzSH58LaxSqLp4fL9WSbt2wGflQgedmjqy0zFgmGa+ztl9mv9X@vger.kernel.org, AJvYcCXRii+0WOIqkQK4IPpmvuIvE6aLmcVXOf7ujGnfdPt92z48vJJ2kihgOgbxKXseLFMag/GC6vYZNtM2YOV/UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyksVSlqrOqHOe9OvWh78TwDAkndYqnDQLhy7mvauezCBHEQJAo
	Qym5g0X6eTsrIGXlzobMis5EE2m9SOZS22EDzHb5BVxT0P4o0ZE0
X-Gm-Gg: ASbGncsjPC60gImfbd2BbCtPHcx4hsp0DKGxLpTV5sLgB2sY3L09cOuiNHc0Ot1uIlN
	GcglgM7TEbygINyEFcNYI/yLUS6jyQNmhQAHIQSOtqHgFgiraZplj055ukG7Y8tIqo0WD/lCmFf
	UU33Zj3JIPZjIMAO5o9dL9a0PhR+CfFhQA+gDxzkes9s+tM0N+oUBPv6T4VebZP2VOf5I1/nNcI
	xRQFtsZ1jkJNWf0SNWsDf1ozlx6/QeGqJkwdUZWw2NVEbPL2LUfeXaNun8pqln0YVVnR4s7lYH4
	DohYpEA5SSzxKahEwhvpkVG98g==
X-Google-Smtp-Source: AGHT+IFkPIj2WzuHTUdpgPyd59w4HD/ACjdIJQJdmjGEiHME2Ya1y9Jl0XHq38pJVdL8kEcXQrcj8A==
X-Received: by 2002:a17:902:d487:b0:220:fffc:7296 with SMTP id d9443c01a7336-2219ff846f7mr94948255ad.6.1740215950865;
        Sat, 22 Feb 2025 01:19:10 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d558ee0bsm149401725ad.236.2025.02.22.01.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 01:19:10 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 9949842D9040; Sat, 22 Feb 2025 16:19:07 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Ashton <joshua@froggi.es>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 1/4] Documentation: bcachefs: casefolding: Do not italicize NUL
Date: Sat, 22 Feb 2025 16:18:50 +0700
Message-ID: <20250222091853.16487-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250222091853.16487-1-bagasdotme@gmail.com>
References: <20250222091853.16487-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1852; i=bagasdotme@gmail.com; h=from:subject; bh=MFbqUyuUwH6JHPIKpWRngzRo3nDBwc6+iIsV3edeApE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOk7p5qlym9hvMJ2u0zo1bXzF7+3Li/X9SkV033LMv9R9 ILX9dzRHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZhI+m5Ghv4T+wwuM4R6Tbhq 38g9tdR5elZHtPxM4QufknpirN6XBjEy3KvJPS9de7/8lVSyK3te5NH+Rcd3JjqqF9t5nipPTdr KCAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports htmldocs warning:

Documentation/filesystems/bcachefs/casefolding.rst:36: WARNING: Inline interpreted text or phrase reference start-string without end-string. [docutils]

That's because NUL word is italicized but it is written in plural form
instead (`NUL`s). Sphinx, however, doesn't tip over when the italicized
word in this fashion is followed by punctuation instead.

Do not italicize the word to keep Sphinx happy.

Fixes: bc5cc09246c5 ("bcachefs: bcachefs_metadata_version_casefolding")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250221162135.79be0147@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/casefolding.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
index 6546aa4f7a8684..1c385b6d21a0a8 100644
--- a/Documentation/filesystems/bcachefs/casefolding.rst
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -33,8 +33,9 @@ The structure looks like this:
 Regular:    [dirent data][regular name][nul][nul]...
 Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
 
-(Do note, the number of `NUL`s here is merely for illustration, they count can vary
- per-key, and they may not even be present if the key is aligned to `sizeof(u64)`.)
+(Do note, the number of NULs here is merely for illustration; their count can
+vary per-key, and they may not even be present if the key is aligned to
+`sizeof(u64)`.)
 
 This is efficient as it means that for all file lookups that require casefolding,
 it has identical performance to a regular lookup:
-- 
An old man doll... just what I always wanted! - Clara

