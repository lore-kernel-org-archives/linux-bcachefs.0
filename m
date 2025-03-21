Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E6E1ADC6D
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574872; cv=none; b=rMHgU4cPJs+DjTu8C53B1gDa8Jv1LmrDrSW/a3qVrzUVxUEBbCJ1AVHHF2wmC1T1kHAtWwPLFROhnAXUV1A9O+f6jnHC6jqqXl14jGf4MSAguOXFAICRh0c3oi/OohZING0xU8h1SiPwH8igjfbLu9u0kWI2zAOi91zSCSHEupc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574872; c=relaxed/simple;
	bh=kEguCeSNexi96rrX86/ttrDg561tllop1oMLibeH20Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JzstzviBVsQtgiSwrho7Dyslq1qQXw1QWSQWI/kGY7BaY5mLlU3rTYMCDTYNNlohQXm8ic5VfViLmqrXH66AsLjq9r9YbpmU+uXrjfvGEsEGXgZfw8kcfn/kM3Taq7zX8hocnvzqzH+ZWv3xkLm3cAb0sCCcNids64STF1tXAgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=COVMequB; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="COVMequB"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 3B0A2240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574863; bh=kEguCeSNexi96rrX86/ttrDg561tllop1oMLibeH20Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=COVMequBpGIWsC/AHBiuEPAtv79fibbVouHDIZ6zjS/FZbGvRCx5HtkkCY4PO11ME
	 Bh2Qf4R4VA20SlUfzkVa+lRyL/1pvJ05UUga0SrZdd0Pps2lfbpeLxbfegFEM4ZTKx
	 aFLhn4uvaUFkdoNK02kMV8RKFyPcOmqcY2ljoHVkAOVEHgGQ3jPdv8mJPfnDCi4scb
	 5Nj5ty9ILCOyQ4+m/grcG+KVDlJB4kn1kUkvk76wjf07xd14qyWdOq3eVKMjbUEvKb
	 CizcDl2K24HsauY9pGqyxmObVtrctxbd9gtM37xViYg52hqwtDAU34DV8244cWoDxi
	 7rW7beqip1bKw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M23Dzfz9rxF;
	Fri, 21 Mar 2025 17:34:22 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 01/10] flake.lock: Update
Date: Fri, 21 Mar 2025 16:33:55 +0000
Message-ID: <20250321163404.353334-2-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
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
  → 'github:ipetkov/crane/70947c1908108c0c551ddfd73d4f750ff2ea67cd' (2025-03-19)
• Removed input 'crane/nixpkgs'
• Updated input 'fenix':
    'github:nix-community/fenix/483df76def3e5010d709aa3a0418ba2088503994' (2024-07-30)
  → 'github:nix-community/fenix/7d9ba794daf5e8cc7ee728859bc688d8e26d5f06' (2025-03-20)
• Updated input 'fenix/rust-analyzer-src':
    'github:rust-lang/rust-analyzer/a021b85be57d34b1eed687fcafd5d5ec64b2d853' (2024-07-29)
  → 'github:rust-lang/rust-analyzer/15d87419f1a123d8f888d608129c3ce3ff8f13d4' (2025-03-18)
• Updated input 'flake-compat':
    'github:edolstra/flake-compat/0f9255e01c2351cc7d116c072cb317785dd33b33' (2023-10-04)
  → 'github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec' (2024-12-04)
• Updated input 'flake-parts':
    'github:hercules-ci/flake-parts/9227223f6d922fee3c7b190b2cc238a99527bbb7' (2024-07-03)
  → 'github:hercules-ci/flake-parts/f4330d22f1c5d2ba72d3d22df5597d123fdb60a9' (2025-03-07)
• Updated input 'flake-parts/nixpkgs-lib':
    'https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz?narHash=sha256-Fm2rDDs86sHy0/1jxTOKB1118Q0O3Uc7EC0iXvXKpbI%3D' (2024-07-01)
  → 'github:nix-community/nixpkgs.lib/147dee35aab2193b174e4c0868bd80ead5ce755c' (2025-03-02)
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/52ec9ac3b12395ad677e8b62106f0b98c1f8569d' (2024-07-28)
  → 'github:nixos/nixpkgs/a84ebe20c6bc2ecbcfb000a50776219f48d134cc' (2025-03-19)
• Updated input 'treefmt-nix':
    'github:numtide/treefmt-nix/768acdb06968e53aa1ee8de207fd955335c754b7' (2024-07-30)
  → 'github:numtide/treefmt-nix/adc195eef5da3606891cedf80c0d9ce2d3190808' (2025-03-19)
---
 flake.lock | 62 ++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/flake.lock b/flake.lock
index ba4887e2..d8a0ace7 100644
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
+        "lastModified": 1742394900,
+        "narHash": "sha256-vVOAp9ahvnU+fQoKd4SEXB2JG2wbENkpqcwlkIXgUC0=",
         "owner": "ipetkov",
         "repo": "crane",
-        "rev": "529c1a0b1f29f0d78fa3086b8f6a134c71ef3aaf",
+        "rev": "70947c1908108c0c551ddfd73d4f750ff2ea67cd",
         "type": "github"
       },
       "original": {
@@ -28,11 +23,11 @@
         "rust-analyzer-src": "rust-analyzer-src"
       },
       "locked": {
-        "lastModified": 1722320953,
-        "narHash": "sha256-DfGaJtgrzcwPQYLTvjL1KaVIjpvi85b2MpM6yEGvJzM=",
+        "lastModified": 1742452566,
+        "narHash": "sha256-sVuLDQ2UIWfXUBbctzrZrXM2X05YjX08K7XHMztt36E=",
         "owner": "nix-community",
         "repo": "fenix",
-        "rev": "483df76def3e5010d709aa3a0418ba2088503994",
+        "rev": "7d9ba794daf5e8cc7ee728859bc688d8e26d5f06",
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
+        "lastModified": 1741352980,
+        "narHash": "sha256-+u2UunDA4Cl5Fci3m7S643HzKmIDAe+fiXrLqYsR2fs=",
         "owner": "hercules-ci",
         "repo": "flake-parts",
-        "rev": "9227223f6d922fee3c7b190b2cc238a99527bbb7",
+        "rev": "f4330d22f1c5d2ba72d3d22df5597d123fdb60a9",
         "type": "github"
       },
       "original": {
@@ -77,11 +72,11 @@
     },
     "nixpkgs": {
       "locked": {
-        "lastModified": 1722185531,
-        "narHash": "sha256-veKR07psFoJjINLC8RK4DiLniGGMgF3QMlS4tb74S6k=",
+        "lastModified": 1742422364,
+        "narHash": "sha256-mNqIplmEohk5jRkqYqG19GA8MbQ/D4gQSK0Mu4LvfRQ=",
         "owner": "nixos",
         "repo": "nixpkgs",
-        "rev": "52ec9ac3b12395ad677e8b62106f0b98c1f8569d",
+        "rev": "a84ebe20c6bc2ecbcfb000a50776219f48d134cc",
         "type": "github"
       },
       "original": {
@@ -93,14 +88,17 @@
     },
     "nixpkgs-lib": {
       "locked": {
-        "lastModified": 1719876945,
-        "narHash": "sha256-Fm2rDDs86sHy0/1jxTOKB1118Q0O3Uc7EC0iXvXKpbI=",
-        "type": "tarball",
-        "url": "https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz"
+        "lastModified": 1740877520,
+        "narHash": "sha256-oiwv/ZK/2FhGxrCkQkB83i7GnWXPPLzoqFHpDD3uYpk=",
+        "owner": "nix-community",
+        "repo": "nixpkgs.lib",
+        "rev": "147dee35aab2193b174e4c0868bd80ead5ce755c",
+        "type": "github"
       },
       "original": {
-        "type": "tarball",
-        "url": "https://github.com/NixOS/nixpkgs/archive/5daf0514482af3f97abaefc78a6606365c9108e2.tar.gz"
+        "owner": "nix-community",
+        "repo": "nixpkgs.lib",
+        "type": "github"
       }
     },
     "root": {
@@ -116,11 +114,11 @@
     "rust-analyzer-src": {
       "flake": false,
       "locked": {
-        "lastModified": 1722262053,
-        "narHash": "sha256-KxjkPVn9rQqYam6DhiN/V2NcMXtYW25maxkJoiVMpmE=",
+        "lastModified": 1742296961,
+        "narHash": "sha256-gCpvEQOrugHWLimD1wTFOJHagnSEP6VYBDspq96Idu0=",
         "owner": "rust-lang",
         "repo": "rust-analyzer",
-        "rev": "a021b85be57d34b1eed687fcafd5d5ec64b2d853",
+        "rev": "15d87419f1a123d8f888d608129c3ce3ff8f13d4",
         "type": "github"
       },
       "original": {
@@ -137,11 +135,11 @@
         ]
       },
       "locked": {
-        "lastModified": 1722330636,
-        "narHash": "sha256-uru7JzOa33YlSRwf9sfXpJG+UAV+bnBEYMjrzKrQZFw=",
+        "lastModified": 1742370146,
+        "narHash": "sha256-XRE8hL4vKIQyVMDXykFh4ceo3KSpuJF3ts8GKwh5bIU=",
         "owner": "numtide",
         "repo": "treefmt-nix",
-        "rev": "768acdb06968e53aa1ee8de207fd955335c754b7",
+        "rev": "adc195eef5da3606891cedf80c0d9ce2d3190808",
         "type": "github"
       },
       "original": {
-- 
2.48.1

