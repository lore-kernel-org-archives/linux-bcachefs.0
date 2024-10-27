Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B018DF87
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038937; cv=none; b=D05Dxqoa1b01+uxHYiA1OUHzu6mzkBHoLw+zXNFrnXRzHfP7YHeWeMfbogROeQVHWFh0NQNj9n4NV/ReJeJEB+Emxn354Q6aMoAWMX/rh4Ktp3r+hFJmkPh+35LnI6/sr25Cc2z+r3nQGdn/9g5bjDPUgaV2kL7nkwp9s436bdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038937; c=relaxed/simple;
	bh=BKAUIw21+DFEp2pm+2z5YsBJJNixsyaYCbq/y7DAV04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EwpMgJrrPtHuABePGSPY+dbWLzE9xkF/GFz3Do/n2WQA0b2N3w/xrNvW0rkxKphGEqaUT0WX9I349GZW+WuRJNNrP21i7nD7/uVnWGsfQk61AwZr2hEtv0vKnpBOn+S0zhrZx0nzh+VWmWPZMVLHB107zf6f7gYacTWEOgBpprM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=PGqODTek; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="PGqODTek"
DKIM-Signature: a=rsa-sha256; bh=6ydDdNapCTZ/OM0zm7uG+DBkHlqpSQZs/rvY6URtxU8=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1730038904; v=1; x=1730470904;
 b=PGqODTekAjnH7KE1hSsKdoOIbA95mqPhhSPePWGkoUeL/F6yvIPYtYTlCUBc0mBW1CVM4vEV
 /TWiiS9mU8Aa38CWxepWU6XWlmiQTdUIhArRFf6qiBoxNkTZ4qUiOEcAcnr6gbitVDnnZU49Gmn
 wjhOnufJm7suheYnYSQachIBxYpe4Zb9o1qrl4zdkjO768HUm28Oev5K49fbGHCbLQfZFNKCfZT
 RFdqQ25k3IZ7FUvVqqBYBfbTYNiN17xdDavom5Ob6ceWJQTyY+zLuL5drlJUc3KQieYaBSh06B3
 ALiDgyCPd7OULRzcEwA02cGhCybAvFlstYzw9mddexBwg==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 1838f174; Sun, 27 Oct 2024
 22:21:44 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com
Cc: mmpgouride@gmail.com,
	linux-bcachefs@vger.kernel.org,
	integral@archlinuxcn.org
Subject: [PATCH] bcachefs-tools: replace multiple if with match to improve readability
Date: Sun, 27 Oct 2024 22:21:27 +0800
Message-ID: <20241027142127.110704-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace multiple if expressions with match in Rust code to
improve readability.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 bch_bindgen/src/lib.rs | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
index b68f2d9b..7d65f17a 100644
--- a/bch_bindgen/src/lib.rs
+++ b/bch_bindgen/src/lib.rs
@@ -173,16 +173,11 @@ impl FromStr for c::bpos {
     type Err = BchToolsErr;

     fn from_str(s: &str) -> Result<Self, Self::Err> {
-        if s == "POS_MIN" {
-            return Ok(POS_MIN);
-        }
-
-        if s == "POS_MAX" {
-            return Ok(POS_MAX);
-        }
-
-        if s == "SPOS_MAX" {
-            return Ok(SPOS_MAX);
+        match s {
+            "POS_MIN" => return Ok(POS_MIN),
+            "POS_MAX" => return Ok(POS_MAX),
+            "SPOS_MAX" => return Ok(SPOS_MAX),
+            _ => (),
         }

         let mut fields = s.split(':');
--
2.47.0

