Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6715E22D7BA
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 03:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743564616; cv=none; b=r9lFTmBnPOhUyc6FV/rItmaztgFMOUWTWtB2ktkO71CMsd0TUIxUSLr9kpg7xst+tHpJOYd/nAD8/ak+RUlGDW73WFzmmoYWdBN5OIOyeF8YAlmMu6SfvtC/J1iOPP0lp0jCTAY32778bhftq1Flmnigk2fxZqZGhKKdLyn+5aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743564616; c=relaxed/simple;
	bh=5k9cjnqq9w8titPEqW2BLiuUEcqYkLOebPeKbq+4FgA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Pwf6d0YGwVZAV9qvp5QttZZYe4wvXDCmeWYbhxrfZniOVFfaA1CCGK1szrE4mICo0UfKxX06G1TGh1cpSne30OMcjCnqu/84QsKenpy7LbFoG2hn/tLW1B+x40XpoGjRvcLWBlGwymfiWMaBajmpiE9/fJZGmrfEdZx0kxa+xZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eT68wJdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eT68wJdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE89EC4CEDD;
	Wed,  2 Apr 2025 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743564614;
	bh=5k9cjnqq9w8titPEqW2BLiuUEcqYkLOebPeKbq+4FgA=;
	h=From:To:Subject:Date:From;
	b=eT68wJdwJMvMa5Twa6u2hHOLpEpE/Gl3CfoWoO8EPOvzzmwTuBJsBYfuH2PNfU9jz
	 3GwC7VXZNmbLEDvTYUDY3qdVLjV9/m72qdtNTk7GQyt4oahNH3+3bvpc7dxcwYDEA2
	 G5ml+Vyyd1N5R7ZnTJAtmW8pEsmjKTu3QcRrSjb+Ix1YBhwihkfvIL1v/D/kAN0zSo
	 MzRXlgv+/n/M+ogi7Z7kMdcedFu9YtdvS4VyzQlSC3S+SliOp0YqkLXKAKmvB7NQaW
	 WDlk49GFrqtEp+KMS17vTQVhKRCwptnoqBizx8rJIq3lAId1jQ1oAsfsYF22uXens0
	 NnKC/2diGJBUg==
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org
Subject: [ktest PATCH] kconfig: stop requiring CONFIG_MCORE2
Date: Tue,  1 Apr 2025 20:30:10 -0700
Message-ID: <20250402033010.266607-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This was removed upstream.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/kconfig.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index f3fb18f..5254530 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -5,11 +5,10 @@ have_virtio=0
 have_suspend=0
 
 case $ktest_arch in
     x86)
 	require-kernel-config SMP
-	require-kernel-config MCORE2	# optimize for core2
 	require-kernel-config IO_DELAY_0XED
 	require-kernel-config 64BIT=n
 	require-kernel-config ACPI	# way slower without it, do not know why
 	require-kernel-config UNWINDER_ORC
 	require-kernel-config HARDLOCKUP_DETECTOR
@@ -21,11 +20,10 @@ case $ktest_arch in
 
 	require-kernel-append console=hvc0
 	;;
     x86_64)
 	require-kernel-config SMP
-	require-kernel-config MCORE2	# optimize for core2
 	require-kernel-config IO_DELAY_0XED
 	#require-kernel-config IA32_EMULATION
 	require-kernel-config 64BIT
 	require-kernel-config ACPI	# way slower without it, do not know why
 	require-kernel-config UNWINDER_ORC

base-commit: 53229b36f8c4df0690af64dedfce3e247334505e
-- 
2.49.0

