Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0986585C4A
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759453; cv=none; b=G8A3UU4ujBg8kMiSfcdFh1GIvZK03JpMU3VGV+WZrGmSOIP291s6Oejn681+8m1v4dvJxdPGhdBBHhju2BllK+LvA2l2u8w18sncC7ARA5ybQY9SWekQyoGUt2Fh4VjC1sR5cpXw/RpSQOHam7QhftMf5OQpIe3laZAuUqkfi+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759453; c=relaxed/simple;
	bh=sU6/gJApOIyC+PndnFaiccj7rb7O6hvEk70FfcEbey8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGCTBCcWbSArA/HrImIaLgHAC/0b6oVdPSbvflqnE12cmbo+4qKJGjUHn0sGLyiq5mk4AMkGnk0s8lR+9/JEoRTfiFgD6nqbNBYOAqFz8IgNdNgQQ/EZ/1cTd6ynO/oHKX7Ct2q45hZkzhcqPMvXQcTJTZl/QVY8BMA8jhYAPdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=c9tbM023; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="c9tbM023"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 4631A240101
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759449; bh=a78kgKKeDwHng05TMoGc8pUJmO7v34BfKVa3IEkFeLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=c9tbM0232YipmltPdacB/wyYJEeSHhPmbK4jFIHSGO1v5rEiRHRHOgk1NVgnAtw06
	 sl4abLB/eH8oWLAtt6I5RnrYOIpkewZiUZofQuV7NgHKoDjdF6e4gY4Zbadpti4WaO
	 /Ssx5PxlmpLpVCyAAkg7JOvXp/SX7ShCc7FF9VskrL/XpI9nF7UznG5MjKnjotoLqv
	 efjgVFDT4k1Ef5owgVhYVmD++dzH9QAYsdM3slLYnn3l/nIoKg1+jfCMfea+ryPdIG
	 /+N98Y93hNxsC2/JzXMNfvC3T9+IAunNeAlFVgXFRqTDhrY0Wv9rFAPfeQrL9N82mE
	 dkYLvfo89CxjA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn45tFGz9rwn;
	Thu, 25 Sep 2025 02:17:28 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 2/7] flake.lock: Update
Date: Thu, 25 Sep 2025 00:17:29 +0000
Message-ID: <20250925001718.174749-3-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Flake lock file updates:

• Updated input 'crane':
    'github:ipetkov/crane/d599ae4847e7f87603e7082d73ca673aa93c916d' (2025-09-06)
  → 'github:ipetkov/crane/02063302383f43237602f5aea5a67766b08e4787' (2025-09-24)
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/ab0f3607a6c7486ea22229b92ed2d355f1482ee0' (2025-09-10)
  → 'github:nixos/nixpkgs/554be6495561ff07b6c724047bdd7e0716aa7b46' (2025-09-21)
• Updated input 'rust-overlay':
    'github:oxalica/rust-overlay/591c5ae84f066bdfc9797b217df392d58eafd088' (2025-09-12)
  → 'github:oxalica/rust-overlay/b12ed88d8d33d4f3cbc842bf29fad93bb1437299' (2025-09-24)
• Updated input 'treefmt-nix':
    'github:numtide/treefmt-nix/1aabc6c05ccbcbf4a635fb7a90400e44282f61c4' (2025-08-31)
  → 'github:numtide/treefmt-nix/5eda4ee8121f97b218f7cc73f5172098d458f1d1' (2025-09-24)
---
 flake.lock | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/flake.lock b/flake.lock
index 51d01cfe..d7bd8fd6 100644
--- a/flake.lock
+++ b/flake.lock
@@ -2,11 +2,11 @@
   "nodes": {
     "crane": {
       "locked": {
-        "lastModified": 1757183466,
-        "narHash": "sha256-kTdCCMuRE+/HNHES5JYsbRHmgtr+l9mOtf5dpcMppVc=",
+        "lastModified": 1758686891,
+        "narHash": "sha256-Lq8JkwjSzv80T1i8KCvqAch75zwD98UKA+4atZjvfZ0=",
         "owner": "ipetkov",
         "repo": "crane",
-        "rev": "d599ae4847e7f87603e7082d73ca673aa93c916d",
+        "rev": "02063302383f43237602f5aea5a67766b08e4787",
         "type": "github"
       },
       "original": {
@@ -71,11 +71,11 @@
     },
     "nixpkgs": {
       "locked": {
-        "lastModified": 1757487488,
-        "narHash": "sha256-zwE/e7CuPJUWKdvvTCB7iunV4E/+G0lKfv4kk/5Izdg=",
+        "lastModified": 1758427187,
+        "narHash": "sha256-pHpxZ/IyCwoTQPtFIAG2QaxuSm8jWzrzBGjwQZIttJc=",
         "owner": "nixos",
         "repo": "nixpkgs",
-        "rev": "ab0f3607a6c7486ea22229b92ed2d355f1482ee0",
+        "rev": "554be6495561ff07b6c724047bdd7e0716aa7b46",
         "type": "github"
       },
       "original": {
@@ -118,11 +118,11 @@
         ]
       },
       "locked": {
-        "lastModified": 1757644300,
-        "narHash": "sha256-bVIDYz31bCdZId441sqgkImnA7aYr2UQzQlyl+O2DWc=",
+        "lastModified": 1758681214,
+        "narHash": "sha256-8cW731vev6kfr58cILO2ZsjHwaPhm88dQ8Q6nTSjP9I=",
         "owner": "oxalica",
         "repo": "rust-overlay",
-        "rev": "591c5ae84f066bdfc9797b217df392d58eafd088",
+        "rev": "b12ed88d8d33d4f3cbc842bf29fad93bb1437299",
         "type": "github"
       },
       "original": {
@@ -138,11 +138,11 @@
         ]
       },
       "locked": {
-        "lastModified": 1756662192,
-        "narHash": "sha256-F1oFfV51AE259I85av+MAia221XwMHCOtZCMcZLK2Jk=",
+        "lastModified": 1758728421,
+        "narHash": "sha256-ySNJ008muQAds2JemiyrWYbwbG+V7S5wg3ZVKGHSFu8=",
         "owner": "numtide",
         "repo": "treefmt-nix",
-        "rev": "1aabc6c05ccbcbf4a635fb7a90400e44282f61c4",
+        "rev": "5eda4ee8121f97b218f7cc73f5172098d458f1d1",
         "type": "github"
       },
       "original": {
-- 
2.51.0

