Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0378521C175
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549389; cv=none; b=X2ElUez/vOm0b4FWrb76LF1uJSbNiASVJ/YhfumzImOQzyOyvBDmZzvxKtPEe84COrUFEGp/9xlMJcQq0KkikekHHc8VozsSiX0YsS1lc9rUXHA7L9aWC0AhGfpctikoxqvSq70wYVk/uuOjUC/q1dZRU6ENMUiZ8xekJY5zmFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549389; c=relaxed/simple;
	bh=3JYrlXhLsS1BwXXYqiPawLsQYvRgYmDHkot1udUnZng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2xMgoc5Lm/aFXy9PRnJx+nJpqiFxQDF3YF/i+lf3+b9RtHOTAjO094xBB6peZA6YIVo+SgPel2JjsGfqeRkbpzQQJU6w0cfCthsBxBDJwtNbrW4lhsUVGIMyaXdmx4fe//6oX+VMhcW6yaNr24YHNslMtsYKsWVl+j28/6yTuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=eo0ZfNFP; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="eo0ZfNFP"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 42E46240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549385; bh=3JYrlXhLsS1BwXXYqiPawLsQYvRgYmDHkot1udUnZng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=eo0ZfNFP89sjbu6SYtbaltHxNzI9z+aQ6p16+MHN82Pp8Ux8v+enSETkJtdsTr66U
	 380F8ttJPx4vKMIpfGAy1K/q5LxUh/F6KO3fN6534KUL+a8Ucf5IL7qtDYZwg5dFVW
	 MgQj+Gb7AWSgUNo6pf2ngOD/UOoJI43E9K53rUFAvyVGLq8bGF9BUeqUvxXiKtXrnD
	 f0kyjLvoc/4W3bMp0YRrsvV3d07a62nY9VgNzNyysbWosgBfv4/qCpF+iBmhZkzndM
	 vZaQsQ+AQ2w4n6itYOmZ28I/zvu5zdV9r6csqG3ER1dbe/5ZbWTpn8um31EfCQesZz
	 pXOXc6Neglcdw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0S581xz6tyK;
	Fri, 10 Jan 2025 23:49:44 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 1/9] flake.lock: Update
Date: Fri, 10 Jan 2025 22:49:04 +0000
Message-ID: <20250110224912.445491-2-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
    'github:ipetkov/crane/529c1a0b1f29f0d78fa3086b8f6a134c71ef3aaf' (2024-07-24)
  → 'github:ipetkov/crane/61ba163d85e5adeddc7b3a69bb174034965965b2' (2025-01-05)
• Removed input 'crane/nixpkgs'
• Updated input 'fenix':
    'github:nix-community/fenix/483df76def3e5010d709aa3a0418ba2088503994' (2024-07-30)
  → 'github:nix-community/fenix/9e13860d50cbfd42e79101a516e1939c7723f093' (2025-01-08)
• Updated input 'fenix/rust-analyzer-src':
    'github:rust-lang/rust-analyzer/a021b85be57d34b1eed687fcafd5d5ec64b2d853' (2024-07-29)
  → 'github:rust-lang/rust-analyzer/91fc0a239af4e56b84b1d3974ac0f34dcc99b895' (2025-01-07)
• Updated input 'flake-compat':
    'github:edolstra/flake-compat/0f9255e01c2351cc7d116c072cb317785dd33b33' (2023-10-04)
  → 'github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec' (2024-12-04)
• Updated input 'flake-parts':
    'github:hercules-ci/flake-parts/9227223f6d922fee3c7b190b2cc238a99527bbb7' (2024-07-03)
  → 'github:hercules-ci/flake-parts/b905f6fc23a9051a6e1b741e1438dbfc0634c6de' (2025-01-06)
• Updated input 'flake-parts/nixpkgs-lib':
    'https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz?narHash=sha256-Fm2rDDs86sHy0/1jxTOKB1118Q0O3Uc7EC0iXvXKpbI%3D' (2024-07-01)
  → 'https://github.com/NixOS/nixpkgs/archive/e9b51731911566bbf7e4895475a87fe06961de0b.tar.gz?narHash=sha256-CewEm1o2eVAnoqb6Ml%2BQi9Gg/EfNAxbRx1lANGVyoLI%3D' (2025-01-01)
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/52ec9ac3b12395ad677e8b62106f0b98c1f8569d' (2024-07-28)
  → 'github:nixos/nixpkgs/bffc22eb12172e6db3c5dde9e3e5628f8e3e7912' (2025-01-08)
• Updated input 'treefmt-nix':
    'github:numtide/treefmt-nix/768acdb06968e53aa1ee8de207fd955335c754b7' (2024-07-30)
  → 'github:numtide/treefmt-nix/13c913f5deb3a5c08bb810efd89dc8cb24dd968b' (2025-01-06)
---
 flake.lock | 55 +++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/flake.lock b/flake.lock
index ba4887e2..b38af96b 100644
--- a/flake.lock
+++ b/flake.lock
@@ -1,17 +1,12 @@
 {
   "nodes": {
     "crane": {
-      "inputs": {
-        "nixpkgs": [
-          "nixpkgs"
-        ]
-      },
       "locked": {
-        "lastModified": 1721842668,
-        "narHash": "sha256-k3oiD2z2AAwBFLa4+xfU+7G5fisRXfkvrMTCJrjZzXo=",
+        "lastModified": 1736101677,
+        "narHash": "sha256-iKOPq86AOWCohuzxwFy/MtC8PcSVGnrxBOvxpjpzrAY=",
         "owner": "ipetkov",
         "repo": "crane",
-        "rev": "529c1a0b1f29f0d78fa3086b8f6a134c71ef3aaf",
+        "rev": "61ba163d85e5adeddc7b3a69bb174034965965b2",
         "type": "github"
       },
       "original": {
@@ -28,11 +23,11 @@
         "rust-analyzer-src": "rust-analyzer-src"
       },
       "locked": {
-        "lastModified": 1722320953,
-        "narHash": "sha256-DfGaJtgrzcwPQYLTvjL1KaVIjpvi85b2MpM6yEGvJzM=",
+        "lastModified": 1736318091,
+        "narHash": "sha256-RkRHXZaMgOMGgkW2YmEqxxDDYRiGFbfr1JuaI0VrCKo=",
         "owner": "nix-community",
         "repo": "fenix",
-        "rev": "483df76def3e5010d709aa3a0418ba2088503994",
+        "rev": "9e13860d50cbfd42e79101a516e1939c7723f093",
         "type": "github"
       },
       "original": {
@@ -44,11 +39,11 @@
     "flake-compat": {
       "flake": false,
       "locked": {
-        "lastModified": 1696426674,
-        "narHash": "sha256-kvjfFW7WAETZlt09AgDn1MrtKzP7t90Vf7vypd3OL1U=",
+        "lastModified": 1733328505,
+        "narHash": "sha256-NeCCThCEP3eCl2l/+27kNNK7QrwZB1IJCrXfrbv5oqU=",
         "owner": "edolstra",
         "repo": "flake-compat",
-        "rev": "0f9255e01c2351cc7d116c072cb317785dd33b33",
+        "rev": "ff81ac966bb2cae68946d5ed5fc4994f96d0ffec",
         "type": "github"
       },
       "original": {
@@ -62,11 +57,11 @@
         "nixpkgs-lib": "nixpkgs-lib"
       },
       "locked": {
-        "lastModified": 1719994518,
-        "narHash": "sha256-pQMhCCHyQGRzdfAkdJ4cIWiw+JNuWsTX7f0ZYSyz0VY=",
+        "lastModified": 1736143030,
+        "narHash": "sha256-+hu54pAoLDEZT9pjHlqL9DNzWz0NbUn8NEAHP7PQPzU=",
         "owner": "hercules-ci",
         "repo": "flake-parts",
-        "rev": "9227223f6d922fee3c7b190b2cc238a99527bbb7",
+        "rev": "b905f6fc23a9051a6e1b741e1438dbfc0634c6de",
         "type": "github"
       },
       "original": {
@@ -77,11 +72,11 @@
     },
     "nixpkgs": {
       "locked": {
-        "lastModified": 1722185531,
-        "narHash": "sha256-veKR07psFoJjINLC8RK4DiLniGGMgF3QMlS4tb74S6k=",
+        "lastModified": 1736344531,
+        "narHash": "sha256-8YVQ9ZbSfuUk2bUf2KRj60NRraLPKPS0Q4QFTbc+c2c=",
         "owner": "nixos",
         "repo": "nixpkgs",
-        "rev": "52ec9ac3b12395ad677e8b62106f0b98c1f8569d",
+        "rev": "bffc22eb12172e6db3c5dde9e3e5628f8e3e7912",
         "type": "github"
       },
       "original": {
@@ -93,14 +88,14 @@
     },
     "nixpkgs-lib": {
       "locked": {
-        "lastModified": 1719876945,
-        "narHash": "sha256-Fm2rDDs86sHy0/1jxTOKB1118Q0O3Uc7EC0iXvXKpbI=",
+        "lastModified": 1735774519,
+        "narHash": "sha256-CewEm1o2eVAnoqb6Ml+Qi9Gg/EfNAxbRx1lANGVyoLI=",
         "type": "tarball",
-        "url": "https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz"
+        "url": "https://github.com/NixOS/nixpkgs/archive/e9b51731911566bbf7e4895475a87fe06961de0b.tar.gz"
       },
       "original": {
         "type": "tarball",
-        "url": "https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz"
+        "url": "https://github.com/NixOS/nixpkgs/archive/e9b51731911566bbf7e4895475a87fe06961de0b.tar.gz"
       }
     },
     "root": {
@@ -116,11 +111,11 @@
     "rust-analyzer-src": {
       "flake": false,
       "locked": {
-        "lastModified": 1722262053,
-        "narHash": "sha256-KxjkPVn9rQqYam6DhiN/V2NcMXtYW25maxkJoiVMpmE=",
+        "lastModified": 1736266405,
+        "narHash": "sha256-V2FDSb8YjuquZduBRNp5niWYlWurja2yGN6Xzh5GPYk=",
         "owner": "rust-lang",
         "repo": "rust-analyzer",
-        "rev": "a021b85be57d34b1eed687fcafd5d5ec64b2d853",
+        "rev": "91fc0a239af4e56b84b1d3974ac0f34dcc99b895",
         "type": "github"
       },
       "original": {
@@ -137,11 +132,11 @@
         ]
       },
       "locked": {
-        "lastModified": 1722330636,
-        "narHash": "sha256-uru7JzOa33YlSRwf9sfXpJG+UAV+bnBEYMjrzKrQZFw=",
+        "lastModified": 1736154270,
+        "narHash": "sha256-p2r8xhQZ3TYIEKBoiEhllKWQqWNJNoT9v64Vmg4q8Zw=",
         "owner": "numtide",
         "repo": "treefmt-nix",
-        "rev": "768acdb06968e53aa1ee8de207fd955335c754b7",
+        "rev": "13c913f5deb3a5c08bb810efd89dc8cb24dd968b",
         "type": "github"
       },
       "original": {
-- 
2.47.0

