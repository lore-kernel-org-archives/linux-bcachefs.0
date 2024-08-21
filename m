Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE78165EF0;
	Wed, 21 Aug 2024 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724273059; cv=none; b=fQuUJDLSSOHkZmGvQTvVMkUd00FTVkr9mA8c5BsQ/Fjplaslu3RrzWVDrd5KuOCmovMCWaRR/TLtzTCLMv2qBUQJ7riGotjT2UcM/rJ4+ENsr4K4lFxmGVZ5v0SZalc54SAld11Tx1AViMCHYkjWkTJvdbuqIcIse0K2ZBfmnPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724273059; c=relaxed/simple;
	bh=vbKtOxGHPdiSOdlRhANh9cXvjlpO9vMygiRN7n2CKs4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=e9Tpwoa3bFrhpueuqv+hhaGXq0i2wvy9F15lHGvHAZm9vnkRxd4s65a95t95Ry/QUb0eLIuWnI9fsoNk1l1yR9wI5K3G+9sPEQk6oHWVvXp3786Z2ao3UVHJGE1jyUPIQ6ioF6syvDGSllIks4Axl5UcJ10MV6T+JnAAajCwLeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJLflqKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJLflqKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99A5C32781;
	Wed, 21 Aug 2024 20:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724273059;
	bh=vbKtOxGHPdiSOdlRhANh9cXvjlpO9vMygiRN7n2CKs4=;
	h=From:Date:Subject:To:Cc:From;
	b=LJLflqKPxeuvl2xqVI7LyMuQ4lg0lJz9MlD3K47NHav5XLwSPl9l7gYKAkOQsiXXv
	 Cieq4CY74PJaUjEIH4zK3q8bY2YQXPxD8Te9yxuf2MJdjCfPV2ht0+u5bY+PH/nDge
	 kN3/xvxTYv6E+rdKsOOsyMNq2QAHb0xvJ9a8vcjUtx6Df348rzkteW/WpDfN6TEyfg
	 XF3yoQ9hKGFnUPHmS7jGuFGD/i2Q7s2EgfjmOW83DOJ4tJddKIdAtrUcsW/VLNCGl/
	 KtvshIaKQay7G6sbJiZf3yNuhHbJ9tD4PMWmtoxTmDCK21xkTj8i2k1Xg6eEXzKH7k
	 /RXutTTjxVPEA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 21 Aug 2024 13:43:03 -0700
Subject: [PATCH] bcachefs: Fix format specifier in
 bch2_btree_key_cache_to_text()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240821-bch2_btree_key_cache_to_text-fix-specifier-v1-1-2d9b89b15fdd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFZRxmYC/x2NUQqDMBAFryL73UASRGyvUkpI1mezFFQ2oVjEu
 xv6OTDMHFSggkKP7iDFV4qsSwN364hzXN4wMjUmb31vR+9M4uxDqgqED36BI2eEuoaKvZpZdlM
 2sMwCNYN1PEzj3buYqAU3RRP+s+frPC9uoQ1VfAAAAA==
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2571; i=nathan@kernel.org;
 h=from:subject:message-id; bh=vbKtOxGHPdiSOdlRhANh9cXvjlpO9vMygiRN7n2CKs4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnHAhc5PBM73D23av1E9amWvOsuRl/Je6O1XWBNaNglg
 76tAleXdpSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJpLkyMjyO8L9Sc3un8o09
 69wXTUje97jW07y8eIfG4Z55HaWa8nsYGWZ+MrqiKJ3dsXRTaNkpq5LSJQdNWvVCdvu+rLzkvtS
 ggBcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for a 32-bit architecture, for which 'size_t' is
'unsigned int', there is a compiler warning due to use of '%lu':

  In file included from fs/bcachefs/vstructs.h:5,
                   from fs/bcachefs/bcachefs_format.h:80,
                   from fs/bcachefs/bcachefs.h:207,
                   from fs/bcachefs/btree_key_cache.c:3:
  fs/bcachefs/btree_key_cache.c: In function 'bch2_btree_key_cache_to_text':
  fs/bcachefs/btree_key_cache.c:795:25: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
    795 |         prt_printf(out, "pending:\t%lu\r\n",            per_cpu_sum(bc->nr_pending));
        |                         ^~~~~~~~~~~~~~~~~~~
  fs/bcachefs/util.h:78:63: note: in definition of macro 'prt_printf'
     78 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
        |                                                               ^~~~~~~~~~~
  fs/bcachefs/btree_key_cache.c:795:38: note: format string is defined here
    795 |         prt_printf(out, "pending:\t%lu\r\n",            per_cpu_sum(bc->nr_pending));
        |                                    ~~^
        |                                      |
        |                                      long unsigned int
        |                                    %u
  cc1: all warnings being treated as errors

Use the proper specifier, '%zu', to resolve the warning.

Fixes: e447e49977b8 ("bcachefs: key cache can now allocate from pending")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/btree_key_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index caddda160a23..5f479cb8ae5a 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -792,7 +792,7 @@ void bch2_btree_key_cache_to_text(struct printbuf *out, struct btree_key_cache *
 	prt_printf(out, "skipped_accessed:\t%lu\r\n",	bc->skipped_accessed);
 	prt_printf(out, "skipped_lock_fail:\t%lu\r\n",	bc->skipped_lock_fail);
 	prt_newline(out);
-	prt_printf(out, "pending:\t%lu\r\n",		per_cpu_sum(bc->nr_pending));
+	prt_printf(out, "pending:\t%zu\r\n",		per_cpu_sum(bc->nr_pending));
 }
 
 void bch2_btree_key_cache_exit(void)

---
base-commit: 8ff69508bbd974755240b30307fc95904cb8c17d
change-id: 20240821-bch2_btree_key_cache_to_text-fix-specifier-601c6d8921ab

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

