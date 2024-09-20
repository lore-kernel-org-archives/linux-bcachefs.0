Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F1124B4A;
	Fri, 20 Sep 2024 12:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726834916; cv=none; b=Bkx0oS3/2B6qdrVapkqNqXltFfi8XXpg/kQhmZu3GQ2O1+3YPvOrf3CUpX5U7+eoPbrH9yayOt/2d3Tch1m/MKQcKaQ4EApyR3qppmqk0NDSfai8V96AXafjnETYA03tWKAP9vDXcV+xVbMdwXKPPHefWpuk71H6NV6ou5UAT5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726834916; c=relaxed/simple;
	bh=AG6kjxjkNM9mbd12P+8zC4kHqe/ZRLdEVDazq8bKcIg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=dZdS6XTmZ9FQ+qOvhnRUP8e0J0f3MsORMUiMBJYCZbXHXdXMsN28xxC/aUaH5TNOUa/M2eHhoyUgS2v1GZ2yXZtyCn961d8E0Mj5sDltkPs39zutgYyhlvifXKwJTMETLYchPbWu+PtUhEup9NboNA/qjrpLy8pVVWkqqrJ5Nc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=VTz/YkwH; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="VTz/YkwH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1726834906; bh=LzDB43+rwUwFrSpKw3qWvPXKcaPkm/FZbefFngZQP1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTz/YkwHQTq1sThoZ7Usd+XU7Q7Hs/2NLFAW5gnVp4vBYpo6sn7CkyBR1fHvFOMvz
	 ApNSjKTPB7a0aAqdAMTRwH8cjnT0s6a9S3gftzqU7LFgZg1PcMTf06Rjb3Jd23u4Mg
	 JXk+w+NTQDE0BkVAk6WbQRPpxgd7e5QXn9Bt8eLc=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc19-0.qq.com (NewEsmtp) with SMTP
	id 1C632C12; Fri, 20 Sep 2024 20:07:06 +0800
X-QQ-mid: xmsmtpt1726834026tkrh7r58u
Message-ID: <tencent_E7E4563771B76EA6CBD3758379C96FA3A405@qq.com>
X-QQ-XMAILINFO: MD2XmhJtctJJtCyN4ImttwMuDtZcraC96bHdWzMyXijH6WUbXZuAtCzN5inuIb
	 B9i7m8fRWiWmM9cjPw5bz40Bc9ZHLJ5kSujWWDlTTei088qgCLwAbiBVys95p3DY6e2xgB3ilTlO
	 UYXxKoMFraMVK/Weqwdc2ZpoJ8u/UjUvHW3KIa0IOVq0pjoruhOBVjRtp07xQyOUs1ROisoppQv1
	 zGRSu1gAzSUjVQmPFbmYTk+++jzuD3Ltgwt2qihcx8TMVnD+sUnpT6Nyi1kI9lEWXDJkX/xUyxjG
	 TFdpIc60x8UFY/8nbvIDGZVLgpg+iQ5wx6vUeCuyxZS9T+hdTmRDVDRrViMs+8FG4jVF50sIogYR
	 BvJXaMSamuMDOYM4bBaYaJAoqr+UmwzcjYi7ypHSZbTsDIQlJBNErix24MHdagj37xjdy50f4xIN
	 n+QR+W0fvXW+UZgQ4ZIfArgfqXh23p338sLCC0ffTzigEIYWPGu2jRpCIfOYzp3uAQjh+Oen5Z4Y
	 XTBeF2wedlaoHdn9SI7e6+dGlG3JAt0StZjDevcDYaQD8RTZEU0idt4MuxULrOV8Zdx63D0xIv3K
	 RJqsPPLXIGW4thOC3g9PhylPTnXsvNGBR5aeH2l8/JjnFrUVHgYsRKECiVef5her6I/G9WTzIAvX
	 VthfaJzuHuh72MieeqaJKd5FtAx1jh9gVrPIbjX02iairMqq28oLgerrO+AuKGcEV9CAQGoJveGG
	 UTJXA/5rrqLuKXlPiFiQDgWOy2XjsxR+2RXKuVzeqRGrnNOl653MlwnASty7s+6zQ41gJdMCSxfI
	 Z7NfMb3PzP/e+iqGTLjDBIT6xrJ14dPQcIX32IaslymfgMD6CKe/SB2/hRCLMI//DYNmdI5sUmdr
	 OcAZn4WLwVtbrwm/CGXzo7jzEv6botTyO3dVqrf+XcYFwTRyOYp72l3WIr5zRMPOfYY5vgl1J8Og
	 gPZJOZmHYhZlqbr6M9FZ+9QOMmXu5auNt8O2udDUvT2zPpASvru1Jf5CTie4fF
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Edward Adam Davis <eadavis@qq.com>
To: lkml@inml.grue.cc
Cc: eadavis@qq.com,
	kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+294f528e56138c357a48@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] bcachefs: Fix null-ptr-deref in bch2_opt_to_text
Date: Fri, 20 Sep 2024 20:07:02 +0800
X-OQ-MSGID: <20240920120701.924401-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <Zuzf7hg_5aOZ7LJl@inml.grue.cc>
References: <Zuzf7hg_5aOZ7LJl@inml.grue.cc>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mounting option values passed in by syzbot are:
"metadata_checksum=crc64, errors=continue, obj_user={^, subj_user=obj_ur,
approve", which does not meet the "key1=value1,key2=value2,..." requirement
of the bcachefs.

Reported-and-tested-by: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=294f528e56138c357a48
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: adjust error messages

 fs/bcachefs/opts.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index e10fc1da71b1..78307e092075 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -472,6 +472,12 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
 	u64 v;
 	int ret, id;
 
+	if (!val) {
+		pr_err("Bad mount option, value is missing but required");
+		ret = -BCH_ERR_option_value;
+		goto out;
+	}
+
 	id = bch2_mount_opt_lookup(name);
 
 	/* Check for the form "noopt", negation of a boolean opt: */
-- 
2.43.0

