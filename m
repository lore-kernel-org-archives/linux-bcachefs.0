Received: from box.shakik.de (box.shakik.de [116.203.140.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7EC1DFD1;
	Sun,  1 Sep 2024 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.140.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210744; cv=none; b=F+TLU7hKHCGq/r0+40JqOVNR5dwPpPAjoJX2clrExV4RYSquZJffKCSc6EG4zOP4fnWHME9wsqxx5boOgEJ6Q+y/hZ0Qt6/bzOXUygowhg3E8ysNZlmyJElkLOtU8wPMVrKMPxEbpQLAAqEQTzxntQkWAE1KRqmLZvtZXdXjHVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210744; c=relaxed/simple;
	bh=3BP+ZfdplAybx2qytl7H/ivcCshwHcSKpjMtsxNQGP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V1wFiJQ0hDK77TpPHccIK0S1gKuue/E2xm2+Li9/Ci2jaWvaFX6jOBZVRiNXmQADlU1uS2HS6FYjEhGH6aBs9bYhAvk5qfNs/CL/A0/XDku9dlpldHNcsEqgmZyG8HGqgCS1xBrh/Jal+srx97Q4mAwlV5jdbLeUGFYYgMV2GtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fnanninga.de; spf=pass smtp.mailfrom=fnanninga.de; dkim=pass (2048-bit key) header.d=fnanninga.de header.i=@fnanninga.de header.b=pSVwYZIb; arc=none smtp.client-ip=116.203.140.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fnanninga.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnanninga.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnanninga.de header.i=@fnanninga.de header.b="pSVwYZIb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fnanninga.de; s=mail;
	t=1725210731; bh=3BP+ZfdplAybx2qytl7H/ivcCshwHcSKpjMtsxNQGP4=;
	h=From:To:Cc:Subject:Date:From;
	b=pSVwYZIb1uVTdyWyynpLj9khmUZl+yy5Unob60moBVECcUzV7Izd2Q8ptkdkcYKR4
	 inxy0YwEXKf+ARUwYX8GqoUlyakk6bnK3tX+o1uIT5YZVRD1k6mhUmTUqC2AQSIAac
	 ukKMJlOLrFxtvtZYyd73VCd8unyypK9BfQsCSQp+t9aktZCrBcJ9REenrzuCaqTSOa
	 IlyV0JTfwpQKdrOGpBKPwZ4nfTlfohxymm+vQ9QdyP8jX6FxWsZTWWcUte3yXx9fzU
	 tjguSe2rMmbjSKoBP7D68v3IyP9saMlyJdnMk9lr5N+y2RroFlatYXAA/zm0YeeuWX
	 WHkJAEnHO+sSg==
Received: from authenticated-user (box.shakik.de [116.203.140.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by box.shakik.de (Postfix) with ESMTPSA id 8CA823EB1D;
	Sun,  1 Sep 2024 19:12:11 +0200 (CEST)
From: Feiko Nanninga <feiko.nanninga@fnanninga.de>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Feiko Nanninga <feiko.nanninga@fnanninga.de>
Subject: [PATCH] Fix sysfs rebalance duration waited formatting
Date: Sun,  1 Sep 2024 19:08:05 +0200
Message-ID: <20240901170821.10617-2-feiko.nanninga@fnanninga.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cat /sys/fs/bcachefs/*/internal/rebalance_status
waiting
  io wait duration:  13.5 GiB
  io wait remaining: 627 MiB
  duration waited:   1392 m

duration waited was increasing at a rate of about 14 times the expected
rate.

div_u64 takes a u32 divisor, but u->nsecs (from time_units[]) can be
bigger than u32.

Signed-off-by: Feiko Nanninga <feiko.nanninga@fnanninga.de>
---
 fs/bcachefs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 1b8554460af4..a6c9c96955f1 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
 {
 	const struct time_unit *u = bch2_pick_time_units(ns);
 
-	prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+	prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
 }
 
 static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
-- 
2.45.2

