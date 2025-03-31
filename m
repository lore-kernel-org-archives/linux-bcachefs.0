Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E379321C9E3
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 23:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743464883; cv=none; b=LTSt1db2c9Nt4BtCVzB3qamYqatl65bn10JHHtrzvsCrx1ZXXpMdjemw475B/WhtvoPGp3g6aZ3DvhL/t8rwrMZUk6voPqpcwxlBEdSms/PV9uPgqHSfjgy8vWlDhZOdr1efVnxhM6mxTGie6DevZFMyV5HLYt6DmBlwBCEZbmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743464883; c=relaxed/simple;
	bh=WUjAW1vS40QPTpXl7YKxTiibJeDo0YkWnQd/lwbSzaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=engWJR8+B1lhCDPgyig6ku1VU0wlGF1u5l8s8E3SPmShDfvOPXVkWWRQt5tLSVgAER/94Rir2TqbA59B2CeOl2jKYg6XV3pLWCNNSQOCyxO+dQD0ObkJNNPyLnGZQYZqTzT/ynjy0WVmLZhvmJ8GJuKnmlvHw3QOitZiMliaJFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=rzx8WC5q; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="rzx8WC5q"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id EFB82240101
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Apr 2025 01:47:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743464878; bh=WUjAW1vS40QPTpXl7YKxTiibJeDo0YkWnQd/lwbSzaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=rzx8WC5qyK1WCaqB/+DHLXq4SDnUTHb2w9hjaqXoqiE/lEDkzyhXBrJVfOe384p3C
	 cze+cNnRy49CBFLcwiyChdSvA+i5KZDkl2mGM9hmLXeT1amegzRPIiUPDXVKHgEG1n
	 1ceCxEB3O6qt95ATadJSBIBlYpDBEmdMzjk72XRyen+BTWmkEiydxn5vZ3TKOlcwpF
	 Kex2eKglB7h9ny6/Aax+otNPV8fFR73hwHdcDkY8WUV0+YVq0tvvPdaktdSxFdCsot
	 3h3vakXfKNmfnLsKBYKKHZm8NvlMrDjZjeUkdP8L2HM/wbNbIYP/++wLCcRxhowM6L
	 2kuX32/g6n/4g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRSVk3f50z6tvd;
	Tue,  1 Apr 2025 01:47:58 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 1/2] fix(nix): allow msrv test to have warnings
Date: Mon, 31 Mar 2025 23:47:43 +0000
Message-ID: <20250331234744.428142-2-tmuehlbacher@posteo.net>
In-Reply-To: <20250331234744.428142-1-tmuehlbacher@posteo.net>
References: <20250331234744.428142-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It is otherwise inconvenient or maybe in other cases even impossible to
have clippy pass with both the current Rust version as well as the MSRV
Rust version. (e.g. `clippy::missing_transmute_annotations` is not yet
known to our current MSRV.)

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 flake.nix | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/flake.nix b/flake.nix
index 79ebfb94..2350f270 100644
--- a/flake.nix
+++ b/flake.nix
@@ -283,7 +283,7 @@
                 // {
                   pname = "msrv";
                   inherit (common) cargoArtifacts;
-                  cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
+                  cargoClippyExtraArgs = "--all-targets --all-features";
                 }
               );
           };
-- 
2.48.1

