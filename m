Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFFA86320;
	Tue, 10 Dec 2024 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733854342; cv=none; b=GnmSmzdcqJ/lWnsk4wX9AuWJw5CwoclNOj/bY3j3inPy7uYwa/xAWqL95CXJV3dUfWpNCmSrX5SmfPhTmXTpwRM+Kr17oKGZjpf50E6QmxBEIXF1WRrXokxAFgLbkF+d+WlftCzEqDyanHexlrCXtoUB0aoK5hkbvoIeaU9ui04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733854342; c=relaxed/simple;
	bh=7ORZxsOZWUPMutI3SxAU5q/SoAGxVGfUG2lMA6/v/r4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kaaobVoOoCXaARwG13gqJo/nlVFj/gu0cg9SFVXPIMq/G+dJH9TsC7p/NiQIYfIgirzFtEYuxAzLZI6zxA6bpQ6KpxsFk4hb6nfq2weh2xTKDAo5POEB5TwvdF1BGAiu+k37nQB+pJQ0ug4qUx+KZGke7QQQEKGWZ9n077vNtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXp9lV5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXp9lV5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119C7C4CED6;
	Tue, 10 Dec 2024 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733854341;
	bh=7ORZxsOZWUPMutI3SxAU5q/SoAGxVGfUG2lMA6/v/r4=;
	h=From:Date:Subject:To:Cc:From;
	b=gXp9lV5UGFAX42ysKyXydzjDWEJN/gd3e19pbowRV4gXXRN62XyN0V111VR0va8vl
	 TtPKQkF4jdiWbeRcHUS/MiZOu02ASeWR4TfNeOyqYjZmv9HJbHxelPM0VUZLHrSFh2
	 jKp3T+sCOwkEFToapdhvhMsfNHEKdPH2PhhfU+A91iIue7caeXK54a30+OPE+0hwD2
	 VXw41OG0FtKPS+bgId/i2mP1cqDPWxbkxqW9yalRg3N/c6yklrMWhj7kW1V3m6K1kD
	 3OZh4lZVk5qfEYqRvXeVE0vWrq/HHwc4jnMTSZ9ja6q8dygYQtkbntJVpkTkMcaO5X
	 5fM4YC967CnAA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 10 Dec 2024 11:12:07 -0700
Subject: [PATCH] bcachefs: Add empty statement between label and
 declaration in check_inode_hash_info_matches_root()
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-bcachefs-fix-declaration-after-label-err-v1-1-22c705fc47e8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHaEWGcC/x2NwQrCMBAFf6Xs2YUm1gr+injYJC92IVTZFBFK/
 93F4xxmZqcOU3S6DTsZPtr1tTqE00B5kfUJ1uJMcYxTiGHklCUvqJ2rfrkgNzHZXGKpG4ybJDS
 GGacwp8u1zOepJvLc2+DKf3V/HMcPFG+nF3oAAAA=
X-Change-ID: 20241210-bcachefs-fix-declaration-after-label-err-b16b57d634fb
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7ORZxsOZWUPMutI3SxAU5q/SoAGxVGfUG2lMA6/v/r4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOkRLc1/Uhcksh6bZGw0/WMs693F7xfeZtuSnC3Evmxi7
 GTO+L73HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAilxkYGVb5LGjd/Whns9Th
 E9k+d2RtI6Uv3nhp83lX178+XzHx84cYGT6uN7v78tmrV84l0xICvDZ6ZGzrdSz9abTa4VV20d5
 tUTwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang 18 and newer warns (or errors with CONFIG_WERROR=y):

  fs/bcachefs/str_hash.c:164:2: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    164 |         struct bch_inode_unpacked inode;
        |         ^

In Clang 17 and prior, this is an unconditional hard error:

  fs/bcachefs/str_hash.c:164:2: error: expected expression
    164 |         struct bch_inode_unpacked inode;
        |         ^
  fs/bcachefs/str_hash.c:165:30: error: use of undeclared identifier 'inode'
    165 |         ret = bch2_inode_unpack(k, &inode);
        |                                     ^
  fs/bcachefs/str_hash.c:169:55: error: use of undeclared identifier 'inode'
    169 |         struct bch_hash_info hash2 = bch2_hash_info_init(c, &inode);
        |                                                              ^
  fs/bcachefs/str_hash.c:171:40: error: use of undeclared identifier 'inode'
    171 |                 ret = repair_inode_hash_info(trans, &inode);
        |                                                      ^

Add an empty statement between the label and the declaration to fix the
warning/error without disturbing the code too much.

Fixes: 2519d3b0d656 ("bcachefs: bch2_str_hash_check_key() now checks inode hash info")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412092339.QB7hffGC-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
If you would prefer to fix this in a different way, just consider this
an additional report.
---
 fs/bcachefs/str_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index ed3c852fc0befa69fabe90ab83d439986be36b42..f5977c5c67430688c8a2a31fa39115f231d5a167 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -160,7 +160,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
 	bch_err(c, "%s(): inum %llu not found", __func__, inum);
 	ret = -BCH_ERR_fsck_repair_unimplemented;
 	goto err;
-found:
+found:;
 	struct bch_inode_unpacked inode;
 	ret = bch2_inode_unpack(k, &inode);
 	if (ret)

---
base-commit: dd7d7f29a7c77d02264097e7b42073a902765c49
change-id: 20241210-bcachefs-fix-declaration-after-label-err-b16b57d634fb

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

