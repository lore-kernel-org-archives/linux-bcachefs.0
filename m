Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572215E5D4;
	Sat,  7 Sep 2024 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725725362; cv=none; b=CrBbEwyAsvo+YQpxeHG9qzIGo+ctLbyOf701yjBWXHGhAxC1vQ2nyclsiqFpKs1rIX8z9OKWMOYWnH0u7GcPy/Rk9WyHLmyd+z8+lNZ57xjx4Dbeigkfo0nVYbOK217QfmvmTZs4cDMCq493V667WmP0NotAbp/JSBAQjwDGPWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725725362; c=relaxed/simple;
	bh=+z9TXEI1CwBvKjLQKZEmST8X9R7foUmB7xMSxHcpB+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fahygYWVogdpBDUPdl/wazINYuaNMXwE/UF3WN9yE0FE4d23xN1/5b/J8hPGX74qGXIXyWMr8PojxNZmFqW7IDb+g64mr/sfCsRS3izHaVuOoymthwNvskkaNl1Em+6AOda1ag0M+zKxHIubFOqRNyPZJKK+KcoQ91WiFwkUfSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=wSd+clq7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=clzYQrik; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="wSd+clq7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="clzYQrik"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 736FB114017B;
	Sat,  7 Sep 2024 12:09:18 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sat, 07 Sep 2024 12:09:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1725725358; x=1725811758; bh=+j
	GRVewk9KOzvj4lvSZEtWysVqUlQYoIEqmfB4MDH0M=; b=wSd+clq7eetgFyg0HI
	rVx0UbTMbMVFn8sttz/RYi2Ip8Jih94Jtcnygum+2SYPHX96zP0MDuqc0ROIriV5
	fAwvkXNDjUe3kU1Rv5yxiYBf1FV4TAaJjLMHdmrzwB4TB0mdcEJ45+rJR1SY/Xko
	FDDNRCCAuh1rRCEkOCQmSFrs5xiYc8ADgd+qxYMd9467QXUA+fhqOx9X5rPL8xqQ
	tR4cOpVZMJWJVDzMz4vRTWyBEbxAXgfsZ48mqPyxANL/j7Wqm75cFeM8PrcjtBaB
	OO8c+vQjplkKEJIagvIfNe1Fyf2h+ESfPH/ZhkTEn79xoBx969AR7GZwF6auy5Y0
	C0yQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1725725358; x=1725811758; bh=+jGRVewk9KOzv
	j4lvSZEtWysVqUlQYoIEqmfB4MDH0M=; b=clzYQrikbEEBAcwZg7PSqlAqDXAHI
	EqaMU/e6h0vm9GFc4L5IbRQnHUWE6tuS5MJTx6dCr2e6YOJNskGyc4PeW303/ztK
	Hr5v1hRpGt6OnCK1qVEeohiVgdOzkrhrtUpNIGxIN5uhiv6iUytm6Y9sPi+2xj9f
	X9bN8yJxNP5/iwHVeZ5z6YeIHbm0ccSVWVeYCpJGFxae+Y3gs8NkqwgyHjt70jPO
	DAZ4EFhVuqxrYs53302XjI44ULiax97dkhU5C+fY6ns46V+xOj7Im8Owava4Gtrm
	JM7b3dIUTr86mn/SERHUcpeOD3e8WzNlMRPHPck3P9P/AEJTWPA/0maNw==
X-ME-Sender: <xms:rnrcZgcIQZ7fKwxPzqxBVTwozcADdx9XMbqctI8gdH8me8GCvgPYgQ>
    <xme:rnrcZiPRUI9xRRXcB9HAyQbeClOdWH4LOODfFBA961hnBCmTgKy8RVan3BeHI30-T
    iHVV5QW8baYfDnUCQ>
X-ME-Received: <xmr:rnrcZhjW8r5W2HJAUrlDRdZvL0hXoe7Lpci9hqxUFbA_NjUcWh2WJ4ipjcoiitzmDy-4ZkDc8zBQMYHsf-leNiFAh0Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeifedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffogggtgfesthekredtredtjeen
    ucfhrhhomheptehlhihsshgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecugg
    ftrfgrthhtvghrnhepvdetgedvjeetkeelteetleejveekhfffjedvkeetieelueeuieev
    hfffvedvvdfgnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorh
    hgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhi
    segrlhihshhsrgdrihhspdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuth
    dprhgtphhtthhopegvrhhinhdrshhhvghphhgvrhgusegvgeefrdgvuhdprhgtphhtthho
    pehrhigrnheslhgrhhhfrgdrgiihiidprhgtphhtthhopehkvghnthdrohhvvghrshhtrh
    gvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhs
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgv
    rhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:rnrcZl8kwuxTz2UQw_ws2g1RUCgEUd4bN0UazPIJ9K1ru2C1AHO7AA>
    <xmx:rnrcZsuaLmGwwbBS49Jgfq-QyI70Qyiq_UcYUfWUu7hxBOeo-lIwhA>
    <xmx:rnrcZsHm9H0-721jYUn_5eo5Cx8S4UZRyHfByv6rPM0NzLrx_G13Mg>
    <xmx:rnrcZrM3ITNUI_cbmOqkeGGfsszpqRVJSz-F7_z1CZBNbDB3EWtf9A>
    <xmx:rnrcZgh9LJ_iH12aixfHo9tEdOquun8-U8nt_wzsc3Am-8WxR4z1IQ7j>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Sep 2024 12:09:17 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 69A99300A6CF2; Sat, 07 Sep 2024 18:09:16 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Erin Shepherd <erin.shepherd@e43.eu>,
	Ryan Lahfa <ryan@lahfa.xyz>
Subject: [PATCH] bcachefs: Fix negative timespecs
Date: Sat,  7 Sep 2024 18:00:26 +0200
Message-ID: <20240907160024.605850-3-hi@alyssa.is>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes two problems in the handling of negative times:

 • rem is signed, but the rem * c->sb.nsec_per_time_unit operation
   produced a bogus unsigned result, because s32 * u32 = u32.

 • The timespec was not normalized (it could contain more than a
   billion nanoseconds).

For example, { .tv_sec = -14245441, .tv_nsec = 750000000 }, after
being round tripped through timespec_to_bch2_time and then
bch2_time_to_timespec would come back as
{ .tv_sec = -14245440, .tv_nsec = 4044967296 } (more than 4 billion
nanoseconds).

Cc: stable@vger.kernel.org
Fixes: 595c1e9bab7f ("bcachefs: Fix time handling")
Closes: https://github.com/koverstreet/bcachefs/issues/743
Co-developed-by: Erin Shepherd <erin.shepherd@e43.eu>
Signed-off-by: Erin Shepherd <erin.shepherd@e43.eu>
Co-developed-by: Ryan Lahfa <ryan@lahfa.xyz>
Signed-off-by: Ryan Lahfa <ryan@lahfa.xyz>
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
I've submitted an RFC to fstests to add a regression test for this:
https://lore.kernel.org/fstests/20240907154527.604864-2-hi@alyssa.is/

 fs/bcachefs/bcachefs.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 0c7086e00d18..81c4d935cca8 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -1195,12 +1195,15 @@ static inline bool btree_id_cached(const struct bch_fs *c, enum btree_id btree)
 static inline struct timespec64 bch2_time_to_timespec(const struct bch_fs *c, s64 time)
 {
 	struct timespec64 t;
+	s64 sec;
 	s32 rem;
 
 	time += c->sb.time_base_lo;
 
-	t.tv_sec = div_s64_rem(time, c->sb.time_units_per_sec, &rem);
-	t.tv_nsec = rem * c->sb.nsec_per_time_unit;
+	sec = div_s64_rem(time, c->sb.time_units_per_sec, &rem);
+
+	set_normalized_timespec64(&t, sec, rem * (s64)c->sb.nsec_per_time_unit);
+
 	return t;
 }
 

base-commit: 53f6619554fb1edf8d7599b560d44dbea085c730
-- 
2.45.2

