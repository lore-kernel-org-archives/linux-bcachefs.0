Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C78206F21;
	Sat, 22 Feb 2025 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740215956; cv=none; b=etSiSHFv/l0uD3bXfEbjta4H3Uvn4KB5LJ6IcdH/m3xf8D+mteOFsMBtuMJf9K0ksBnGUS/zKAuZtkLqUr1V6nl9R6+quKtih0CQeHwBce49Nz6poFNd2UbUwoBdvBMX5v48ch6z6ufv1pGdsV0jpG179AfjDXR6aG29/Ahz2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740215956; c=relaxed/simple;
	bh=1H0fcjZ59e5m2Wwr+sCq68rVcNKl1r6ctu9g3xbBDDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N53Jq0oRR37UJnKGgpvCTtxR5W6EdmmBtRFNOZW8WFTsH6MfDf9rY7tnt1MbDPABab4C13nDtFaEbSumh24takw+kbc8wJGAMa3z/Ji4oefPVsQA1RSH/Dbsg/IN7Tojyut4hvd565vClfiEBmXsE1VipJ7MDyeUrOxlIS7tlFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAjVtJe0; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAjVtJe0"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fbf77b2b64so5918499a91.2;
        Sat, 22 Feb 2025 01:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740215954; x=1740820754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arSSywPBAqrtMA/12WOxSIM6m3MIN4jFYb5tokjbeI4=;
        b=fAjVtJe06cpogUy+1FHV50X2W30/UxAIvns1/ViV4JgmUs+aOvlahO/lhvNDZpXPgB
         zE2EkFi8vNTuhUcDlQCXb44DwxM0zYdOUSpCUQCjs0wRfpfFskJM5eep9sem9EMhd8fB
         9+Latt+03qlI14+D1FTlWYkk5L3bMSzDIQS8nLLuZ6ctUKFXCSMvzWyoqg6Zq+Dy7C9I
         VnK33CrehyByLcpkBnjw8SdR8FIvhsXlPArZsGaNspdLOeuKnKOVEqzwzXjIlyLvz6U6
         t3x6lui3AlkIdQvbqNJhej05oHCsalbkzzgn1IswIDRykv3v+kykDZ+5B8L4I/ax9a8h
         hNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740215954; x=1740820754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arSSywPBAqrtMA/12WOxSIM6m3MIN4jFYb5tokjbeI4=;
        b=YKz0Kj9/L3oSczOHw+kRtSbfj0xdTe3McBHuNZM2oXsNboYz3LYSjlz8rq27/W6vkk
         YIYqtTTiCcqy6NerwcB8js53/lBvUlfxeh7NJsOctf3FMOAii6xAMEIEZ0vVlv88QQfx
         tnMnrozCCaDGZXPVjlygo4ESXs4qnUMSqxYBwIF76yDDqFJfK2oeOoRXb+P1d8oLFmn/
         B+Z+1i45L8MtwYPkOFDkFedbB7t/bGsSFKOYKMx6Slju2qXYrCpY1nDDN7fYN/zpsuh/
         ZsruT5++8oKrI9uG3mRua2Kv4GV8EOMh+qaaNGed9br8JlXkp3Tzb/16f9KiBtFKPbXF
         3j3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyOSQSMUzU2IRoIDcBtA6YSfhjUF4PTQlmOtjX90HIlNqNToHWg7/0M7jGdM0GB7kjyhO36krFMYfa@vger.kernel.org, AJvYcCVxBcRpmzP3sC84e9y9nVw43ezzaOEuFMb+KaayvM37wvrehUxpMo97xKLhBWivwrV6lIqtN1LFyln9nUwtgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyDsmk1Ayjgp6OQ9xrAXICpjuBeapRo/Madi/o7dKY+JBG3g/H
	P12HahUHvKNofSaq2ALMzT/qdheTULjPpO1LgWGWolSj0ysMMaSD
X-Gm-Gg: ASbGncvmw05DdKb2BkhkwrZLoXujCWEOXnDxp38ZDgMo1AZwHEVgB/zQ+SDulZ9/BIg
	zYKcKMGzeH2A4aktrCjRbFhe/+yy+DmZ7X8Z+3VBORl12JycOZegQAw2AY2VXC9KDCOyxKh/FhV
	xnFVxzFvRMS7OsH2X2/qh6ESqAd7VRnkQ4x2BkNmFHnsbP1QQfESai/BUi1kmxZRlo/d2VQUNnv
	bUpNwe7JVIRAzEBGiOGf5gHq5MaOB7rQlHnDepYQ6FkQMOPDaCwhRHxC6Y2iflLw9q6Mx4JtaZi
	mjxhZTjakXK7REUl1V8xBYuPug==
X-Google-Smtp-Source: AGHT+IHL3fDQk9Pp/3H+yX5WF7dXe/HQfFbAD4mwCOURPeue7PPNy5SO2roanyZd7Nvyx3WYhAm6ng==
X-Received: by 2002:a05:6a00:464e:b0:732:a24:7354 with SMTP id d2e1a72fcca58-73426c84381mr8960226b3a.4.1740215953718;
        Sat, 22 Feb 2025 01:19:13 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-add2e0ad0dfsm13375942a12.78.2025.02.22.01.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 01:19:10 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id DD1B042D904B; Sat, 22 Feb 2025 16:19:07 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Ashton <joshua@froggi.es>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 3/4] Documentation: bcachefs: casefolding: Use bullet list for dirent structure
Date: Sat, 22 Feb 2025 16:18:52 +0700
Message-ID: <20250222091853.16487-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250222091853.16487-1-bagasdotme@gmail.com>
References: <20250222091853.16487-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1311; i=bagasdotme@gmail.com; h=from:subject; bh=1H0fcjZ59e5m2Wwr+sCq68rVcNKl1r6ctu9g3xbBDDI=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOk7p5pt9mu6c27pRc+j2Z/9m9fGFDG4VUZekVPUvpiUy uukHfK/o5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABOp8mNk2NWk8uCPsfzn47ND E8S+6jUpW7r7GUVev3H2j++t+/kdTIwMJ34uPPKjPW/b5nCb9Uduif8+6jepa7LYdYGgSYkZG1Y rMgAA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

The doc lists dirent structure for both regular and casefolded names,
yet it is written (and rendered) as long paragraph instead.

Write the structure list as bullet list.

Fixes: bc5cc09246c5 ("bcachefs: bcachefs_metadata_version_casefolding")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/filesystems/bcachefs/casefolding.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/casefolding.rst b/Documentation/filesystems/bcachefs/casefolding.rst
index d5861b44463576..ba5de97d155ffa 100644
--- a/Documentation/filesystems/bcachefs/casefolding.rst
+++ b/Documentation/filesystems/bcachefs/casefolding.rst
@@ -30,8 +30,8 @@ name with the regular name in the dirent.
 
 The structure looks like this:
 
-Regular:    [dirent data][regular name][nul][nul]...
-Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
+* Regular:    [dirent data][regular name][nul][nul]...
+* Casefolded: [dirent data][reg len][cf len][regular name][casefolded name][nul][nul]...
 
 (Do note, the number of NULs here is merely for illustration; their count can
 vary per-key, and they may not even be present if the key is aligned to
-- 
An old man doll... just what I always wanted! - Clara

