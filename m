Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EFB22D4DB
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575252; cv=none; b=taT2wv5yeRgj5csdb6TNrONNzOv6sZq7SRz10GG1rkjZhc7UqSwKN7XF8TSwcj3a30QFJjyXDO/mV4JP6+MtoW+7/bS7XKhW150JHnhdvG9Wbnrr1NEZjksgEPzY6Fgwgw/8VMJzAcW/Cm3qsVNkaebfwE13uW0zPGmV2L1VYp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575252; c=relaxed/simple;
	bh=x96AVgyewFJvCdVMHkvsIgzs2lKVJp74fB+n1fb745U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xoq+0B3CUKbr3PzEeU/eWVKr6FuAoNgWfXtimXEz/t2eSEoGfbOyKWQ0z/k4QPCZ2tfciN4OzbxOn84bo1jqrUgcG2FReNtxm9ZULGm5zkgYpRT4spti+VlJ6HCQkuGLUMav5p0NMCwuYewcuE8mr44wIe8h/0bcuFd4WgWz0K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=JgOIN9fD; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="JgOIN9fD"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 1AA5324002B
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574869; bh=x96AVgyewFJvCdVMHkvsIgzs2lKVJp74fB+n1fb745U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=JgOIN9fDBL8T2oI1rPubGVHB6b9pmyTFsrTsW0xPYkLRnz+Sq5bVU5MLu5qkytcm1
	 3HRPbI7TE52zs/tCHk4lKH7v5XUU2uYC1YsPO5ni3mA1CYRow0SIzsr6G5RIOPwJ51
	 AY570iVqIfjRuf2lv/Ky9eF/4+Syh72Fh5dRbjE9Ed9ZC0q/tnDu+wfQY6A/03h8Vp
	 UUN7X332Psi9iYq7N8hhlKtpKp1z600cQgk+Fh0YPJ6UXw1ejei28UioX2klJMn7VU
	 lRMhEUnIO4mcQ17Os/GmuqvY1I2+I6wYDlmeh6bnDdlyJ2jL9paFLZ/qtfEQIJqkMc
	 iMDaycIwCwiIA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M61jmnz9rxQ;
	Fri, 21 Mar 2025 17:34:26 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 09/10] feat(nix): add a CI check that builds on 32-bit
Date: Fri, 21 Mar 2025 16:34:03 +0000
Message-ID: <20250321163404.353334-10-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Picked armv7l-linux but i686-linux would probably also work. Not sure
which one is more important to check for.
---
 flake.nix | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/flake.nix b/flake.nix
index c8225203..abb49a24 100644
--- a/flake.nix
+++ b/flake.nix
@@ -269,6 +269,8 @@
               }
             );
 
+          checks."32-bit" = config.packages."${cargoToml.package.name}-i686-linux";
+
           devShells.default = pkgs.mkShell {
             inputsFrom = [
               config.packages.default
-- 
2.48.1

