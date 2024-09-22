Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79A768E7;
	Sun, 22 Sep 2024 23:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727048143; cv=none; b=kwZOL47c98QLY5qWNWGKfI+RG5S1Btk2iGBakI1sWks1nmN234/OX6suXxEslPomdeIIvdPMt/N87Ls+DWPnegC1q7ogRnzyq1HmSNOYD9kwyoKnjkILVjYIXoVnZDIj4YosNUxjfFiIszTjb4o3I87y2GG1oN7XBq5iXhmpA/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727048143; c=relaxed/simple;
	bh=9E9Vd3oqfcEY88ItHZvQHnivGZTM4ubhD0H+LkTPPDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QWqlGvQXZNNfFEao9OO+6VxG4gCq/D1b9XpVy10Vsdei6F6g3NBu2GqiiWH4u7u5sLFa2cpDUOGhyKDRAs/il/tZ1kidTUTCLi0cYcO504T/O97MssDvkEoV1buIDGDbbfv7HnbpdJlWL6sWSm6R6vw1W2c6ihZIiyaTNNP16U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PspyYap1; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PspyYap1"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4585e250f9dso23830611cf.1;
        Sun, 22 Sep 2024 16:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727048141; x=1727652941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/PEJwHOdY7wkPp0EG+MaZgMxqJRwsEBUudUxGaSPXa0=;
        b=PspyYap17PQO9+U8giO3G8FgkNf4a0xQLynMHr1xNibE7g7bP30s0G3m1BRM9yOfKq
         5zpEvzf0Yqaep1pFQDD4laRFjmXIEBRedpcEVJiZysk1fk0lKJnIZxFWeZmjADEflTB5
         NPBmRCDCRXmVjJ9QedB/Q7v01LGTzqe55EHqx8NhNFUwrSP4XWTZbnHodT3ctA2UmUty
         z+MmNa8ephbviz5oxxTDyq487Zq+insZhS2+SQLHOrsONkZpKmPKPTGFhOm/9vwqJerD
         Rt7sbGK3CevsgvdPVqX/Uo5YUkl5i43wBG6kVUVY0NpSm1ZvRkySyCyjrNHlBMFYbDqT
         jKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727048141; x=1727652941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/PEJwHOdY7wkPp0EG+MaZgMxqJRwsEBUudUxGaSPXa0=;
        b=gFMb3zut557DVhxE2+eUR4LY5Wb4TNaAUqwQVD3VIXyWt+I8td8crYIyEU49f/U42C
         goVYR9CRhWYdXgvI/QrFkTbzSE6T2Gw/GHEF/NsdbOeX5AWbMVAhcguSQaanbjIQhTwS
         NGiMJHujTAq20m0zfaZDwjtV0OGjSddJ5ujY0zvFIXCKr9sgBiVk26/sy4wAR5H/gxcG
         o2eTh7UhW5RHtP9YIF+tFMBJp5WuSbgPbA79W3QEuOc9sVxS6WzLEJdncTKDdDACvtN0
         IDg9vUgdWTsfdP5/ZtZri4Lsc3Q4lRChoGmpiwPxqqtz8unVSMSjtOLyPQxLw9S74ck9
         5paQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLGDGGUXkl4S2sRjBgL1MpO/yrpjy+XBBdNWf6vz77vzQyYOBCvCe/rqaambtfPOKzsYHhd1H8jpREdws=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/y6N6+3GSdG6zxzGfc/Vt/4k2dhoLIEK2bbTzXxB+pZYBqHL
	A0GNsRQYv8tZ/buxH59qcd+UZ+7tr8kOJSge5JoUkbBEq6rldcIp
X-Google-Smtp-Source: AGHT+IHCNMlo2XNAIETIqPMq0YQaisDQ+va5DNyj6dh95cu537MVSDNcpnQLCfcAI9GJRE8a4CBp1w==
X-Received: by 2002:ac8:5914:0:b0:455:9ef:8895 with SMTP id d75a77b69052e-45b204e0575mr144933911cf.11.1727048140583;
        Sun, 22 Sep 2024 16:35:40 -0700 (PDT)
Received: from localhost.localdomain (d24-150-189-55.home.cgocable.net. [24.150.189.55])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-45b17919f40sm41426341cf.79.2024.09.22.16.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 16:35:40 -0700 (PDT)
From: Dennis Lam <dennis.lamerice@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+24beef64217854da05a4@syzkaller.appspotmail.com,
	Dennis Lam <dennis.lamerice@gmail.com>
Subject: [PATCH] bcachefs: fix divide by zero error in util.c
Date: Sun, 22 Sep 2024 19:33:44 -0400
Message-ID: <20240922233343.121427-2-dennis.lamerice@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch aims to fix a bug found by syzbot where a crash occurs due to
a divide by zero error in the bcachefs subsystem [1].

Bcachefs has a file called util.c that uses the function div_u64 to perform
division using 64-bit values. The function's parameters uses a 64-bit dividend
and a 32-bit divisor to perform its division, however sometimes in this file
a 64-bit divisor is passed using this function. When in use, the 64-bit value
is passed as a 32-bit value, creating the possibility of a division by zero error.

Therefore, this fix replaces the function div_u64 with div64_u64 where the
dividend and divisor is a 64-bit value to perform the correct division.

[1] https://syzkaller.appspot.com/bug?extid=24beef64217854da05a4

Reported-and-tested-by: syzbot+24beef64217854da05a4@syzkaller.appspotmail.com
Signed-off-by: Dennis Lam <dennis.lamerice@gmail.com>
---
 fs/bcachefs/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 1b8554460af4..cea162b99864 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
 	*res = 1;
 
 	while (p--) {
-		if (*res > div_u64(U64_MAX, n))
+		if (*res > div64_u64(U64_MAX, n))
 			return -ERANGE;
 		*res *= n;
 	}
@@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res)
 
 	parse_or_ret(cp, parse_unit_suffix(cp, &b));
 
-	if (v > div_u64(U64_MAX, b))
+	if (v > div64_u64(U64_MAX, b))
 		return -ERANGE;
 	v *= b;
 
-	if (f_n > div_u64(U64_MAX, b))
+	if (f_n > div64_u64(U64_MAX, b))
 		return -ERANGE;
 
-	f_n = div_u64(f_n * b, f_d);
+	f_n = div64_u64(f_n * b, f_d);
 	if (v + f_n < v)
 		return -ERANGE;
 	v += f_n;
@@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
 {
 	const struct time_unit *u = bch2_pick_time_units(ns);
 
-	prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+	prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
 }
 
 static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
@@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
 			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
 
 			u64 q = max(quantiles->entries[i].m, last_q);
-			prt_printf(out, "%llu ", div_u64(q, u->nsecs));
+			prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
 			if (is_last)
 				prt_newline(out);
 			last_q = q;
@@ -511,7 +511,7 @@ void bch2_ratelimit_increment(struct bch_ratelimit *d, u64 done)
 {
 	u64 now = local_clock();
 
-	d->next += div_u64(done * NSEC_PER_SEC, d->rate);
+	d->next += div64_u64(done * NSEC_PER_SEC, d->rate);
 
 	if (time_before64(now + NSEC_PER_SEC, d->next))
 		d->next = now + NSEC_PER_SEC;
-- 
2.46.1

