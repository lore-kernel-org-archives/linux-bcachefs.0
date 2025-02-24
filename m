Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22923370D;
	Mon, 24 Feb 2025 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400846; cv=none; b=UzN5ytQl5nOFkGK6BVV27R7AJQ/AX3CKUBBgiChoLqW+z3noV5rlkEyNcSdTQ1dEW3F8RXWb/8RNc2vkKWdXQEyMnDBddPJ73pXe5Ha5XirzVfg19SAOv4EuYJeHSkvlVOw5lF49PyQiO8sYM9MNe2UlHySgN+HKgf/nNYgva8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400846; c=relaxed/simple;
	bh=rUYeLMwkMWE93iox1zqi2IL9CD9/fZmi24Dwjgci5lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTZf16s/QVh8xz7hIW3Tisw3bztBnLpN9wvxpNfvJko4NSmp21Elc/o/NeGlKzWlfnb98vH7Rk314bouT/6l26PCuH2ICz6Dq/dzLXdYx6O7nT0ZCuKLuG5LV7qHgZtfV9bqerWdqdcFsI6GqByc2YUXuXo6f7IISuhWy1/r/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyNMrFA5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyNMrFA5"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-220dc3831e3so81461955ad.0;
        Mon, 24 Feb 2025 04:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400844; x=1741005644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nH1mRhJzXJ+lnurKcLbDcsTkl48NjRzRyTmoQVE9c+o=;
        b=GyNMrFA5ZeVdZo9EvVUlXxLQHkhqu7CdJ9jd+DFYNt4/1xeg6AkdRUJee2/6W/oWTe
         ZJ+3S38FTh+9b2N55yrQIm1quUYDVGEJWZfcBGIIDoB7VKAuxmzLPWmqJ9BLl3rw0HbT
         vo6T7RjUPgA4MoS7uqCPQlgno6SFVNQA3DfQ3vgsRZSdo7qcJUpNy2DGzLtqGRopVWfY
         hFaWerZpYSwjHizlzKY5xGIpeMG3I7XpNlnibYylyxAtBrbov/2kINQ5fT2VmBT42I1+
         m3oWMd3U7UU8/0TdaBXnqK4BhUw6qnnvbe3valvxg8pjfQ2w6gKk1Z13Z281p38LeX/Y
         F/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400844; x=1741005644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nH1mRhJzXJ+lnurKcLbDcsTkl48NjRzRyTmoQVE9c+o=;
        b=SJ1ubtsCINtJqc1GQU0Ik2X3Lq2gNYBeAv0AbG6AU5uWsrDy5w9f9KzJ+48hubJkZY
         P8f1C7v39Gv5HBSSa+3l/TlfxFDKcvBspgPlgiFgb/kA4nmiSBGQzshSkRmli6hghPM1
         V2+V/5QK34TciyjS+DdhuHw6mAH7/KycJ0Sx7sgJ/ImReiabDOdxr7SfiD1u4vg3X63c
         cEYKlyRs9s4nuu6k9h2uUWOvXLkDDDkARaib28pcIjoTEtW19aeaiCiI2c7BtUGYYiuz
         IBgu9KX8Ctff53A1CoBs+I0MBeMq8ACKLWjGaFwB0bMqr4StY54YaNGSyiSx1YWFXp7P
         5J2w==
X-Forwarded-Encrypted: i=1; AJvYcCVpKtt/SJ9BW4VSxzpO+XPcgfebTm8E6neIN9D8QIAUJz8wN5xm8IWTp94LYGrDTnySO+C2PcPBF8XJbqmWlA==@vger.kernel.org, AJvYcCX4dLHtYnokxILv0r79dNFze7gc/OFenG6UbWaVPInQN0UkUwTxZlOcjr+BawLOzPj45L2BkRfKGc9q@vger.kernel.org
X-Gm-Message-State: AOJu0YwNMDw/PYxlyeuxVZBvi2O6Ja51Etst4AcM19noIOyBHAeoq7N4
	V22WFml28jk5wd7lEHFVCOcasc2ToAGouxEFQgZe74MwPLtMD2sm
X-Gm-Gg: ASbGncsI/7T0Zi7yku8bihCAI0KuL0Ak+eQXwenTNBFm9ZJVafpbqJybm+EiyXFCq7G
	XaB2dGGIbA0NtrqJflGghE3GQDfko/xyXC5R1EJwrh42TfhLFF96YAkn+cqbiVR5gMHFjhlH3sh
	LCOlnk3mau7641qWLcXQP9MME8Fz5uZ1SqdI0bn7EuT8WLfbzToUsWMqqQw2MK1Z5ugQSrplcMi
	g6jVNlq7DeNvbCpsHmpfIdJrU55DTnHEjQ8UBikozyxKdy4kb1ZfJ9bTg7sdT2wyNTQjB4h11ox
	PJHYROcO56Gfiq778xVIKriy/Q==
X-Google-Smtp-Source: AGHT+IEu2NKaB1pzYSUxuWN+h1ruzdodzFrBeuRDBRh+Q54BlMwWVgApQaE9iz0ag3B/SR8Ok6MWbQ==
X-Received: by 2002:a05:6a00:cc8:b0:730:949d:2d52 with SMTP id d2e1a72fcca58-73425b39e5cmr21655893b3a.3.1740400843526;
        Mon, 24 Feb 2025 04:40:43 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7326973705fsm16511425b3a.7.2025.02.24.04.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:40:43 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id A150141296DA; Mon, 24 Feb 2025 19:40:39 +0700 (WIB)
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
Subject: [PATCH 2/3] Documentation: bcachefs: SubmittingPatches: Demote section headings
Date: Mon, 24 Feb 2025 19:40:27 +0700
Message-ID: <20250224124028.42059-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224124028.42059-1-bagasdotme@gmail.com>
References: <20250224124028.42059-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2721; i=bagasdotme@gmail.com; h=from:subject; bh=rUYeLMwkMWE93iox1zqi2IL9CD9/fZmi24Dwjgci5lM=; b=kA0DAAoW9rmJSVVRTqMByyZiAGe8aA6jTkfvzf4RMVKT5o9/T46l4ytB4uFflXl4x1Uz38ngM oh1BAAWCgAdFiEEkmEOgsu6MhTQh61B9rmJSVVRTqMFAme8aA4ACgkQ9rmJSVVRTqMKTAD9G27v PuR3/QS5lCB1vr8+uZegGaiYpgWUa3vRaK7NfhIA/i+Ur2pnhXgPHhdagqbM49W2jlejZf1VU7/ Vwbl9Vf4A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

SubmttingPatches.rst has 4 section headings, all under the same heading
levels. In absence of title headings, these section headings are all
ended up as title headings in the docs output, which also affect
the index toctree (increasing titles to 6 from the original 2)
due to :numbered: option.

Demote second-to-last section headings, making "Submitting patches
to bcachefs" as title heading.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../bcachefs/SubmittingPatches.rst            | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/SubmittingPatches.rst b/Documentation/filesystems/bcachefs/SubmittingPatches.rst
index 026b12ae0d6a20..ece0e85d259807 100644
--- a/Documentation/filesystems/bcachefs/SubmittingPatches.rst
+++ b/Documentation/filesystems/bcachefs/SubmittingPatches.rst
@@ -1,5 +1,10 @@
-Submitting patches to bcachefs:
-===============================
+Submitting patches to bcachefs
+==============================
+
+Here are suggestions for submitting patches to bcachefs subsystem.
+
+Submission checklist
+--------------------
 
 Patches must be tested before being submitted, either with the xfstests suite
 [0], or the full bcachefs test suite in ktest [1], depending on what's being
@@ -26,8 +31,8 @@ considered out of date), but try not to deviate too much without reason.
 Focus on writing code that reads well and is organized well; code should be
 aesthetically pleasing.
 
-CI:
-===
+CI
+--
 
 Instead of running your tests locally, when running the full test suite it's
 prefereable to let a server farm do it in parallel, and then have the results
@@ -39,8 +44,8 @@ a big tech company, you'll need to help out with server costs to get access -
 but the CI is not restricted to running bcachefs tests: it runs any ktest test
 (which generally makes it easy to wrap other tests that can run in qemu).
 
-Other things to think about:
-============================
+Other things to think about
+---------------------------
 
 - How will we debug this code? Is there sufficient introspection to diagnose
   when something starts acting wonky on a user machine?
@@ -79,8 +84,8 @@ Other things to think about:
   tested? (Automated tests exists but aren't in the CI, due to the hassle of
   disk image management; coordinate to have them run.)
 
-Mailing list, IRC:
-==================
+Mailing list, IRC
+-----------------
 
 Patches should hit the list [3], but much discussion and code review happens on
 IRC as well [4]; many people appreciate the more conversational approach and
-- 
An old man doll... just what I always wanted! - Clara

