Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B12142624;
	Tue, 23 Apr 2024 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713903152; cv=none; b=B5z6bJhTZPFiX4b9D9MQVaZi1OSaulJ80jGVft7LuDZWwfAHwPnaSxNboHfSt6Zyvq5Y3d2cwMh+mxI+Z9uMP048jExzvlvcSwbfFIWWp+mBVVf2MOuLPfLkTADuOxmsr2H6uoVGMXOG7VMZrCqkgnyBHwE1gLfik9wvU0SGe64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713903152; c=relaxed/simple;
	bh=InSkFLYHQqAIysFqlMPninTOcFQBon0rntp+aAphEwc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Kf1zzhyGaY202AR9aLrVjMTV+e8IbfVQjv/w0HGyztXqQR7sBLi9vD+qtuo/dPGSDo2OusmA63J0WPfnFvGumq5h/EKPLJjMZDl0NazKTUPQsFNijEIHK9s4ZL1a5ovjtH9/mDgIQi9r3eN2V1QQCbEWiyLKYsg1XUaadrMjijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iN1lcoCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iN1lcoCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57211C116B1;
	Tue, 23 Apr 2024 20:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713903151;
	bh=InSkFLYHQqAIysFqlMPninTOcFQBon0rntp+aAphEwc=;
	h=From:Date:Subject:To:Cc:From;
	b=iN1lcoCjdIZrtR3mCOexDzLcF19cdpU6wOeIsgy4rvThuWG7H4r20bKgMDuiEt4Ef
	 r3LZKZF6Mo0mYChtiqT0tvdT6KNskXsX6NuI35KByODblkss5ZvVgKmBsLAkZBVKs/
	 eJkU+IgAq7x+rWVro247cwolkF8Bx31OB0bYk0GuPkEGOqpmND+YN1LvyhlnSRl5B8
	 wm7lGOzNXlBMDckrN3wszBb20wYNy7xDD7jpbDlOXuo0y4cxyN1DxCNes4FVSDHvrf
	 poZ7mAMZvdRtOMO9+uKhQZ883oJ/eQHL+umKjRePOYVkE3ffXE5xRe+/9zrQyBZOYN
	 gbkyUsxq2I7Ag==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 23 Apr 2024 13:12:27 -0700
Subject: [PATCH] bcachefs: Fix format specifiers in
 bch2_btree_key_cache_to_text()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240423-bcachefs-fix-wformat-32-bit-pcpu-v1-1-a10549e5271d@kernel.org>
X-B4-Tracking: v=1; b=H4sIACoWKGYC/x2NSQqAMAwAvyI5G6ip4PIV8VBrqjmopXUD8e8Wj
 wPDzAORg3CENnsg8ClRtjVBkWdgZ7NOjDImBlJUqpI0DtbYmV1EJzdebguL2VETDrKjt/5AXRX
 KjVXNpiFIGR84qf+i69/3A9UZoGZyAAAA
To: kent.overstreet@linux.dev
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4259; i=nathan@kernel.org;
 h=from:subject:message-id; bh=InSkFLYHQqAIysFqlMPninTOcFQBon0rntp+aAphEwc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkaYvrhq4uK+tnSvtQJbI34vUFaa0pbalSMxaELTJ7/5
 Jk5P4R1lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgIlE3GRkODMvs2lGrkj7mtBn
 rEncufrsP955+u0881HHslfMaZpyM8Nf6WXqXEmvTdw/KdicnPCrivFWl2+YZkF3sMP2D0ZHl6W
 wAgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for a 32-bit target, for which 'size_t' is 'unsigned int',
there are two warnings around mismatched format specifiers and argument
types:

  In file included from fs/bcachefs/vstructs.h:5,
                   from fs/bcachefs/bcachefs_format.h:79,
                   from fs/bcachefs/bcachefs.h:207,
                   from fs/bcachefs/btree_key_cache.c:3:
  fs/bcachefs/btree_key_cache.c: In function 'bch2_btree_key_cache_to_text':
  fs/bcachefs/btree_key_cache.c:1046:25: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
   1046 |         prt_printf(out, "nonpcpu freelist:\t%lu\r\n",   bc->nr_freed_nonpcpu);
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~~~~~
        |                                                           |
        |                                                           size_t {aka unsigned int}
  fs/bcachefs/util.h:192:63: note: in definition of macro 'prt_printf'
    192 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
        |                                                               ^~~~~~~~~~~
  fs/bcachefs/btree_key_cache.c:1046:47: note: format string is defined here
   1046 |         prt_printf(out, "nonpcpu freelist:\t%lu\r\n",   bc->nr_freed_nonpcpu);
        |                                             ~~^
        |                                               |
        |                                               long unsigned int
        |                                             %u
  fs/bcachefs/btree_key_cache.c:1047:25: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
   1047 |         prt_printf(out, "pcpu freelist:\t%lu\r\n",      bc->nr_freed_pcpu);
        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~       ~~~~~~~~~~~~~~~~~
        |                                                           |
        |                                                           size_t {aka unsigned int}
  fs/bcachefs/util.h:192:63: note: in definition of macro 'prt_printf'
    192 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
        |                                                               ^~~~~~~~~~~
  fs/bcachefs/btree_key_cache.c:1047:44: note: format string is defined here
   1047 |         prt_printf(out, "pcpu freelist:\t%lu\r\n",      bc->nr_freed_pcpu);
        |                                          ~~^
        |                                            |
        |                                            long unsigned int
        |                                          %u
  cc1: all warnings being treated as error

Use the proper 'size_t' specifier, '%zu', to clear up the warnings for
these platforms.

Fixes: f2d47ec26af5 ("bcachefs: Btree key cache instrumentation")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/btree_key_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 52aada7a34ca..4c8da356f765 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -1043,8 +1043,8 @@ void bch2_btree_key_cache_to_text(struct printbuf *out, struct btree_key_cache *
 	prt_printf(out, "keys:\t%lu\r\n",		atomic_long_read(&bc->nr_keys));
 	prt_printf(out, "dirty:\t%lu\r\n",		atomic_long_read(&bc->nr_dirty));
 	prt_printf(out, "freelist:\t%lu\r\n",		atomic_long_read(&bc->nr_freed));
-	prt_printf(out, "nonpcpu freelist:\t%lu\r\n",	bc->nr_freed_nonpcpu);
-	prt_printf(out, "pcpu freelist:\t%lu\r\n",	bc->nr_freed_pcpu);
+	prt_printf(out, "nonpcpu freelist:\t%zu\r\n",	bc->nr_freed_nonpcpu);
+	prt_printf(out, "pcpu freelist:\t%zu\r\n",	bc->nr_freed_pcpu);
 
 	prt_printf(out, "\nshrinker:\n");
 	prt_printf(out, "requested_to_free:\t%lu\r\n",	bc->requested_to_free);

---
base-commit: 711f072a8f7f795e63c4f729cc258ba238851333
change-id: 20240423-bcachefs-fix-wformat-32-bit-pcpu-3710fd78ea92

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

