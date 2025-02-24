Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87C323BCE3;
	Mon, 24 Feb 2025 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400848; cv=none; b=kvTydkhyT97L6GpnVHouvXf71lkcHZ1EvdZY7NHTCo3vVwjxQ6d9VNBqxGU9GXd1wMxL39iREfEONa3zeiQx2WsQeaRVgcqIGW4vYoMOZ5CUPRHxzNApGSKpH0+Cw13E82kayWmAzLNne7qYB2SBjFZRfTrV/tiGSLVm9P+7PRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400848; c=relaxed/simple;
	bh=u23oF0QW377DCF2g12JmtZDftKGIy09CDhlv1P8fYHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OEH1BDBcxOxjfoAf4b/WkC2VMAt02QXLyNAiWJhBYhSKtwOkin10/6yO/tiw/6toko5tcc9gyenOgjDk607ZKFoczYzhxzfb6X7tw50wvVeHv9fskVnKeu3m5Fi+EYycp2fZ0gr18ueJsGvNyFErch/Exjtd2kra6wz92CKSXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fU1+Cg/C; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fU1+Cg/C"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fbfe16cc39so8663932a91.3;
        Mon, 24 Feb 2025 04:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400846; x=1741005646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tkZFih/XZf2yI3GxthedwF42LMBAHKEi46yINuICECc=;
        b=fU1+Cg/CRhIGFyCqy3kUMIct+6UpjmrPXP+GMLhcRYc/SAg+yEnxISH5DSooIWiz7X
         cNuQU3Uh5D1HZ9QUysRGh4AleY6F2GCd/3MaBby3QwQDIq6B1J2lkTk4XVtgr3UelD6y
         KflpoaAeZG7SC+KYmAGn/3qVirj1kKRvoiJgj7plcj9sVKomNk7QDL2he5qv+p05uwWl
         xO1WO5o3dcjwWOFZfQzNN/V+RfKK8ThbelK5Js9cEKh3LwlNpmeTo1EWB6yFJqoqNQ3o
         oy7bFp/2DyyJYpaDF2ca8thtT6u3CVGO0X6kyq1yieuKQLfxVKHiaYXyjWHlQ/AzlPrk
         25qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400846; x=1741005646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tkZFih/XZf2yI3GxthedwF42LMBAHKEi46yINuICECc=;
        b=EEfij9OoWcokSpUYVldw4sFz4Rf0Wd42ozA8RSlkcX7plTxk5atLMkkqJQ9TtmbLp0
         A2q0HwZc9TpftbTULTQ9xGJMxFPsMB3NoUToSDyZhKtaD0FVyqx7J0O5VroJ3vGRaNOf
         KCKD73Wn7nQqoQsvY/LqELPeke2OeFXUmlepZ7uF9aUJ2OD3Ux3NWXUwqXn2O0qGb7C4
         VX1MLE3WIYFCFvwcZQvv4vLeaVZ8FrVnleywPq5mSSTb2sjqkVlAHiLg9gfLqkKCJ5BM
         peKcfsxDS+enFbqV17HSxy57nwAYXZ0mEmxtHeslAtmPJ5dczYWmZuYy6PGIBYxLUsMR
         hhMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS6QKTdgpWglXfbr4D2tY95gt4WyfN+Z0blfNDItqwb35msMK8gkYfutmkbUiENduX6aULDuOAsJP8@vger.kernel.org, AJvYcCVb2Sq13Nh/mSycze96zOUyqSz1r3cCYcKltwJbFW/Rd3xacS2lnU5gvulsnGIq3wrxaW+L0WZ4YZ+qWcxWRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxpdWdthd/MNgwlqNPZgtrfNlk/lWHdUAHPEP5BuwWyIODVgdxu
	w2v8vco1fGroGUiLj88McWTuXzCuOOVBCtBQvRcW4PoP76UeOiYk
X-Gm-Gg: ASbGncuBSQ20u6EXfrMjNeKPzKp3AQer+IhVKpQMiu3Kn2of2f1PHNf6SVeruAPwuTe
	k14aFwivGtKH17njitGKB3ubOTpkBkqhFhdhGWmxRDSOyFHKALFT4ZdztQpoZHrgQRtuQtlRHsM
	K3FNIk1o+wPmRbj0vN8GYsYjbnRsYpfDW+3OOzdSap2LhoqawimKJf45W0kkFPBN0qyLbi4O1pw
	i+R3Rdb5X8N2JEpHHBH49VP3oKuI2xxdTDV5xzyKNRPE3tc8a8H/NiBWIqnHvRXQWKLWnydgsH3
	ZXLTCmj20VIJ/i5rTKX+DmVUkQ==
X-Google-Smtp-Source: AGHT+IGKClpqPgKkTVHuqsoij0SCKsuAJFmN/t8lkLNgr8yhMAFXsbqAFFtBGkwF9vaCfhEex0fu2g==
X-Received: by 2002:a17:90b:3807:b0:2ee:d63f:d71 with SMTP id 98e67ed59e1d1-2fce86ae672mr25817022a91.14.1740400845730;
        Mon, 24 Feb 2025 04:40:45 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb02d781sm6409409a91.4.2025.02.24.04.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:40:43 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 2E2CD4209E40; Mon, 24 Feb 2025 19:40:39 +0700 (WIB)
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
Subject: [PATCH 0/3] bcachefs: docs index refactoring
Date: Mon, 24 Feb 2025 19:40:25 +0700
Message-ID: <20250224124028.42059-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=869; i=bagasdotme@gmail.com; h=from:subject; bh=u23oF0QW377DCF2g12JmtZDftKGIy09CDhlv1P8fYHo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDOl7MtgdNAovc396/Ur9zu1g70vXrQIvn+8MLc/pX7bl5 uYrrH0xHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZiIowQjw/c5i63/+fBxn9FY 7SygfGuy9uOsbfoLX9SlSNevO77H35iRYYrZDe/GaZvu8k9K7dB6uLhE02qn3Tf5016P1vRcm2g tygYA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Hi Kent,

Here is bcachefs docs toctree reorganizing (inspired by similar work on
tracing subsystem by Purva Yeshi [Cc'ed] [1]). The actual refactoring
is in patches [1/3] and [2/3]. Patch [3/3] is a bonus: footnotes
formatting.

Enjoy!

[1]: https://lore.kernel.org/linux-doc/20250217110637.6640-1-purvayeshi550@gmail.com/

Bagas Sanjaya (3):
  Documentation: bcachefs: Split index toctree
  Documentation: bcachefs: SubmittingPatches: Demote section headings
  Documentation: bcachefs: SubmittingPatches: Convert footnotes to reST
    syntax

 .../bcachefs/SubmittingPatches.rst            | 43 +++++++++++--------
 Documentation/filesystems/bcachefs/index.rst  | 19 +++++++-
 2 files changed, 43 insertions(+), 19 deletions(-)


base-commit: d139df3ad938bd1e18bcc16c2452dea1cf852807
-- 
An old man doll... just what I always wanted! - Clara

