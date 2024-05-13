Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3E414EC6A;
	Mon, 13 May 2024 12:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715602729; cv=none; b=kcxNipLrAmGZvGB7rKr9n4/N4WuYBae9hP86uMvCtx8VXTNwQ6Dn/PdOWHiwMFDPymRrf9hv3U4yajreLaHpeIULJKZonzfeJDUWLKSOpazXDMi908B7bgag9S4V4Wkxbwx6QuWBUHaf7j0UvwtmAv0X9/InPuPJT4e5GjCCtoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715602729; c=relaxed/simple;
	bh=eTJyGFZuuUTf0Z9OwR7wZgGFFPBjo9/DMFTo6oR/Ncw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=rM1D2PaOaEgQwsIrYeJ8HXfb/Z6/a8Ztt7YDpjQzzJTw5IEbJisTDonnOupp6voeH/NpZUGbz88rdoN1j58RamTAimXWEeVJam+l97/Ev556CK/dBC9ZU/C0Y+0M91dF3mw1rwK+Uz11dlY7TJplgPB80kyIDDgipBbSVfS0C5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=FBfnzJF7; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="FBfnzJF7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1715602416; bh=xv+9xk6+JmJ0SrgxJjY2cegIbCyOT4cBAO76O1vPTxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBfnzJF7yo5kFg+i/lP4ezMVj/PlZp43R+qepMoMmCj1/eAew618hV8nXhsdEUQ7A
	 iYpwSIMgqrha0dhSpRIq9PnALbbzc/rqQ7NpdsxXi/0BHLTNIIzBKCZ+YgnRK5rM5J
	 54jAoJCprxpgV5LVVzCL8Qb0bCpYk2cl4V6+GAw8=
Received: from pek-lxu-l1.wrs.com ([111.198.228.153])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id 1D13ACD5; Mon, 13 May 2024 20:07:17 +0800
X-QQ-mid: xmsmtpt1715602037tws7b70qy
Message-ID: <tencent_8BBBDE33A39E011B1B4BFB1B332504BA4808@qq.com>
X-QQ-XMAILINFO: NvH2zBBgt3uT997bsVhXHWC5QIzHeJNxRUlyXolPdllYLQueIU+6HC1jfqXrDH
	 zkSAgVyu1yXWNcxU2vyh3aokE5Jx5B53H6KTNBG6jGJnoDIQ7UobGNi6l71ivnZ/GO87z88vd8kx
	 ZLSua5Kup6S2TZ8J5ZZHvZm7nkjDjWLyssLeGd9ndq4z4aNV2Cj+mIDer2fNoddpO3eA5LD0ntfu
	 x8K2yzh3TZqVlCpgyoPQNEKqtX9k02TG69wL7sYLWa6GSALywRxGYAQVax10+oXtmKLampK94/2t
	 437/Icwuk1hqy/kN5L1RWtx24cupN9LxhMk7hnkDFmxHx7fJAiUgomWtUkcF/IDmKlK2pK93pT0s
	 2XK3FVN7PRbAOEF3fFEoypvNNKtuv72tw8VYd60hA5IjxoYJhcHfHjf9wAmJzi2/WB0QGMhUPVYP
	 Ba2gSKz60JWHdI9m+2DzJwIZfdoTudxYOYcUfpmQei9uOW45QwllIviXa+Efa6DlCT3QXZ+vJ16c
	 1L4aKMjSJU5ydZtuwAtr9syhGO5BYU80Q1B7Y79pB3h5AcMiaMKWOJGxccIZK0aShvbvYFwa0dFc
	 QQI5Puefy9YzYnjkBIVS6EijF2GKNDPsyYiNo+J7z8V+rqs8BrOYAeqbfMDZTh9la6jOdpgkdtLo
	 LzWs1U7Rb8EzSmzkh0O5q2Cb0gDVkrQ5hU/1o/Gv7nnNzNT5GNNiVdrMa2CEMal6mGjIGlwFlA6f
	 KxYmtG/L7RE0RmZ2AP+x8lTNZz9ISBTqLocYXMbAlEuQXo1MF2QRUlZhLY4MxWawRgBsEMagYUU8
	 bn84U1ToQjqnhewfbl59Af7qx5qQM8r3TIAV8H1H7Z4YbtmYrMvhyByFfbysJTxUEQsrme0RoIH4
	 LmS32iKNx76WlpwaraJ95vAkLzh0P/Cejnmm7SfFN/vazSvzxek3vFTxW66zyfLIohriAmYsDDa6
	 PyqitKZCg=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+73414091bd382684ee2b@syzkaller.appspotmail.com
Cc: bfoster@redhat.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: if input options invalid return -BCH_ERR_option_name
Date: Mon, 13 May 2024 20:07:17 +0800
X-OQ-MSGID: <20240513120717.3349265-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0000000000001e59c20618455922@google.com>
References: <0000000000001e59c20618455922@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the input parameter options format is invalid, it will cause the opts object
to not be set correctly. 
When a similar situation occurs, it should return -BCH_ERR_option_name and terminate
the mounting action.

Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
Reported-and-tested-by: syzbot+73414091bd382684ee2b@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/opts.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e1800c4119b5..2fc59b8aa32d 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -443,7 +443,7 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 			  char *options)
 {
 	char *copied_opts, *copied_opts_start;
-	char *opt, *name, *val;
+	char *opt, *name, *val, opts_set = 0;
 	int ret, id;
 	struct printbuf err = PRINTBUF;
 	u64 v;
@@ -498,8 +498,11 @@ int bch2_parse_mount_opts(struct bch_fs *c, struct bch_opts *opts,
 			goto bad_val;
 
 		bch2_opt_set_by_id(opts, id, v);
+		opts_set = 1;
 	}
 
+	if (!opts_set)
+		goto bad_opt;
 	ret = 0;
 	goto out;
 
-- 
2.43.0

