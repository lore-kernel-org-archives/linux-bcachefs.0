Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52C22332D
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431728; cv=none; b=BtAnO14vxlEZ395HbNCNGtfbudjJFuPnsMi48p2QRCHHAhCk+BYXXNvk5nHk0FZoJ9pq24aUun6Nhu7Q4ShWMYqea7fdoLniQT1aneupW81cjfza1KVZMGxwMW1ZIj4owJgdmMyNzzChCEHcH5ARuW67dIp3osuPYdzhWal6u4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431728; c=relaxed/simple;
	bh=fcAElRc+LcIPVzHiIey65nzPSdJ5uV8jgdRTh0TKB9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdJVDZn02m/Nu6w2ywpLgCN/cjgDaazZzG43lgAhUkAXITu0MllTp6nMkCy8M1KLHK/7brEYF4g3DTUTWS8o5tu9F9bv/LfxJjf/xjtzegNiQQx0z/Fu4q3GM2vOTGQZmV+rkxpCK8eUho7PBWfaLQ3LET4BtDcMJcn4bheQCcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=ogw/8rFt; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="ogw/8rFt"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 38891240104
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:35:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743431719; bh=fcAElRc+LcIPVzHiIey65nzPSdJ5uV8jgdRTh0TKB9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=ogw/8rFtO3RDJKw3ldSz91rod+y9yS2URnf6/K1l4O9JBPJaKGWBXlxt1aSQrD6kC
	 7Frnn2mYATTVTEhCNAb7gqXwUiiPdIpqY7Yka3+8x/mKxbsVqrKSM4H8QCvbvItoqs
	 j9mMZp52HurqD27h7RyALQofAeM0JlUkqR5zAkEUNDmQhWhnTYra9XLoW7BwrRIBmw
	 tndIxLZx+WzJRXsHBr3KoWU4Rx4EWvhBGbojB5wJTgnLkjL7zryFAQWBpud0JQrTfI
	 Z+sbJCuEqCNJlcIUT5iHEmSaOug3BHWkm3X/MstgcvXi8YsgxWXvZQx/qipQqhsKNM
	 8fPAb535x7DIA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRDF20RYlz9rxD;
	Mon, 31 Mar 2025 16:35:18 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 2/5] fix: use cargo workspace
Date: Mon, 31 Mar 2025 14:35:06 +0000
Message-ID: <20250331143509.157528-3-tmuehlbacher@posteo.net>
In-Reply-To: <20250331143509.157528-1-tmuehlbacher@posteo.net>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This way bch_bindgen actually gets used by various cargo subcommands,
like clippy.

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 Cargo.toml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Cargo.toml b/Cargo.toml
index 54b6ec35..e9657884 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -1,3 +1,7 @@
+[workspace]
+resolver = "2"
+default-members = [".", "bch_bindgen"]
+
 [package]
 name = "bcachefs-tools"
 version = "1.25.0"
-- 
2.48.1

