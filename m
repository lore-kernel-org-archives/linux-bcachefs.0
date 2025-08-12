Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB52FE573;
	Tue, 12 Aug 2025 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021757; cv=none; b=lg5UyxXHqtW4iLXGYbZ/via2J0BQXrhq1Gq8urMhtSpe1b8zYMR92IZgSxCTcXTXbERyWlMRNShoqMob8YUo4/mhVowmnIMWngwiZqalkfskjukThY1fC8ixtVsN8JjhPiZqwKEfyDmwLaLf5dOPCsFCplztB5o7xj8eFo6d17Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021757; c=relaxed/simple;
	bh=cTESMOkLVKR5uwzioJEzzF0am+6i99DL3eKP53iLwIM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kiASnGXcyxKDUv5D/1iNhhh7tMAddadCGgP7n0LndVmqopYTjLboXDxtFvvSU+QhUthyEr5Ij+YmSKfg4qJu+7IrAoYkz6uEiAwVT0ezQE8rvCky+KJfK0O9LHfVEzbNVImRwoFF3MfqA2AzPQcBBeqHMw90rztqIQhiUq6tUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYZ4nJWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYZ4nJWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E1C4CEF0;
	Tue, 12 Aug 2025 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755021756;
	bh=cTESMOkLVKR5uwzioJEzzF0am+6i99DL3eKP53iLwIM=;
	h=From:Date:Subject:To:Cc:From;
	b=MYZ4nJWouj0qgw0SBFYVMna1pjnviIFV8Dcd8CY1p/PQx9OFeR/wf4MozbCd6L1jZ
	 B2DsnZYYHANipgkDzV6czWZcH+Fhrf3rJa0HMipjnf0ZRvXj1Uh4bKAoRELHQ9vgeK
	 VaPUv6dWsQdTeePH6KB2eY5CFv1J3XNWimupHUj+kh0yXPmy3iGDhB2PbnUXXCjkUN
	 yvUDLwiLEipgMoPByvyVegif5i+61bSRUb2fBysfBhZ3ZTeYEX/TrMByjIyAn+Pbk6
	 YUHZehJ7/eHZZje9TrWRH0CXOzGeLy+e+cRu9GdSEemU2Xn/0Vt+/A29TUAazFio2B
	 IXeCTgirK7cxA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 12 Aug 2025 11:02:11 -0700
Subject: [PATCH] bcachefs: Add statement to switch in
 check_bch_counter_ids_unique()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-v1-1-def262fd6574@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKKBm2gC/x2N0QrCMAxFf2Xk2cBa0RV/RaSsWWaD0GmzqjD27
 wYfz4VzzwbKVVjh0m1Q+S0qSzFwhw4oj+XOKJMx+N6f+uA8Jhop86w4yxf1IytltIEeMVGOtLS
 yco0yaWxFXo3RhxCSO55TGAaw22dlU//J623ffwaFtfCCAAAA
X-Change-ID: 20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-2888b136b877
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Francis Rossi <francisdrossi@gmail.com>, linux-bcachefs@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1412; i=nathan@kernel.org;
 h=from:subject:message-id; bh=cTESMOkLVKR5uwzioJEzzF0am+6i99DL3eKP53iLwIM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmzG3ev0Rew4bir4todZiKanse1KdgqfvkL1tMO85OjP
 jlfLnnRUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbypYyRYbLuwomLb9sdS70j
 7jpVTE5k6Zmj/KJlDXKHXvPbx6Z+2sfw38Nu7v7pRzY9W16amHXHau8KMVZr/ost05NUerbstXa
 rZwQA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  fs/bcachefs/sb-counters_format.h:132:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
    132 |         }
        |         ^

In older versions of clang, this is an unconditional hard error:

  fs/bcachefs/sb-counters_format.h:130:34: error: label at end of compound statement: expected statement
          BCH_PERSISTENT_COUNTERS()
                                   ^
                                    ;

Add an empty statement to resolve the error/warning.

Fixes: 38de86383436 ("bcachefs: Switch statement evaluate ids and confirm they are unique going forward")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/sb-counters_format.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/sb-counters_format.h b/fs/bcachefs/sb-counters_format.h
index bfeb713dd210..96ad64920810 100644
--- a/fs/bcachefs/sb-counters_format.h
+++ b/fs/bcachefs/sb-counters_format.h
@@ -129,6 +129,7 @@ static inline void __maybe_unused check_bch_counter_ids_unique(void) {
 #define x(t, n, ...) case (n):
         BCH_PERSISTENT_COUNTERS()
 #undef x
+		;
 	}
 }
 

---
base-commit: 65c604dba89a86d3dae0bd98b7b0b6c077ac930c
change-id: 20250812-bcachefs-fix-switch-check_bch_counter_ids_unique-2888b136b877

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

