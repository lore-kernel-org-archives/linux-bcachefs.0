Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692C18F2E8;
	Tue, 30 Jul 2024 04:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722312631; cv=none; b=Ha+UOZQ9UBqT2/DiGuE6xKBM9xrPeb7UT4gPpwn/NiToHVr/e5reFO9MerQD5jU8g9OVAJl3avYvuQD1ljlvo4JCbEqlIt7rUsSxTlEfzBl7rAF2aZa66eZg5dyry9Yt2dWGPQNOY1spIAWZXrtH66TW8Nz7o6d8BGldQMm+IdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722312631; c=relaxed/simple;
	bh=tu/3M/G8db/oINDtWgmjFTcLEcSIY+X4DQnYH3EzaRw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ggJISLZXGMrRInsjVd3bclMA9NMHPKc/QBSIr4x/5Cf/WI83WKzP47yjkRiPD7sX/rnfS5AxbApxSk+eMzt4Ng8l+vNeZh+tYl9coR3ESHfbjl5bmfdwCQLH89iIHuyCNiQRA9UYFpCwjgSjEnJPkbn9UH3TJnPy3qY953cwrsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jl/tVaxq; arc=none smtp.client-ip=203.205.221.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jl/tVaxq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1722312620; bh=bQK+VWkHD4YqAQbmlzZUliUqtHWomCHtvQ/iZQIYIA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl/tVaxqkZMYG+NWZQUEFDbon6NrwGd322fIhIssNbiv2ljIL9+tOvpY1ftN4EBkv
	 i68qQotTdD9dXKyfNRE38OL0eCvtzryFtt+2S6amY4fGL8pElQsIKA6HeH/d21DczT
	 JYfPcXXbtEtQverIuk2cnzZCOGLQ9B5Bb90zk/zE=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id 2928BEB7; Tue, 30 Jul 2024 12:10:18 +0800
X-QQ-mid: xmsmtpt1722312618t828q0iwq
Message-ID: <tencent_3D4E4FB18DDDA5988DE9920ADDDFDD859907@qq.com>
X-QQ-XMAILINFO: MIAHdi1iQo+zBFmN+HK1i+P/wF/PoKVyCBY10lzCT4A4sl8knTiEl3HjenBJW+
	 4/Idai47EUV2k2SOEDI3Tjlr+96P3se6ipmgTfNXWbZ7zFZSDuNy9Mcrdme7tb42KvrsLJ9ttgki
	 Z0NBa0rjdPaRKG9snioh3RtythC321TlyX4K4xpehxfVsMs2/nvuFn6GxnJVmlYu3gYUJlgaW60M
	 AoE4/tWm9vNGG66IXh5LmwQtTj5D0TIZuNsNbXzwth1DKEycUly1Q1BTEPZbk8bKa87I2TsFo/mB
	 zYIkIXv8WACDJba9jJpqFRZZj6EnGWZDShCb+2x5/IJCawjPBMghLi6WdjWZ//U0o65hQhFC4t0E
	 3ZBGfFeUov/QD0KPfoi6OSGmJcdo6pScUYJtc+M/TTOXxIs/KdFQyFwRZc2zX677ZRjJByxWHgXg
	 zH+hWISWxq/yi6ynkPEXCa8xyDs25HNIJshyZdX5AjNfGw2lXq1I5kfXFYhYY9ltbQ3K/USjA+yX
	 6p2c2dJBKSsXzKE2KGabnp9Geb1tzcyo5eBxKfn7Xq6L/vGsISJOI0DV4VUvfS86biqKP9zr7BSJ
	 3vi8mDhYZdlv1++wAlPuQ39AINrybnVpXjYH0T2wEFPSeXOItrzuf9ws/IxC09WRVT2k8c8JMkT/
	 Gva/zL5+uYNn9E3Nb7FnfONOwmT2ku7bnCaGHpCXwgM6lxVF/39rMpDh7XPCL7CECz6V8d79OeNt
	 CChORkK5zRYlbxLP8m7n0ASCuoReH2NvLNq8jvdKGTwTyNDkJhxKfnliG4R41rPCTydKFR4AJ/iK
	 TD8CHaezHi400mG+d+qRFWpbNhrRVMPOw5kyw8u3/iNHQ7IfEfvQoCHfWkdMv1rcdiPbNnLztAYb
	 56jirJcCK++YIBbvy8Ygel5UBfXyggke6yQc6cMSYgtQQ6d7jQyGIj5p/CwdDVCw==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: Add checks for entry's _data bytes
Date: Tue, 30 Jul 2024 12:10:19 +0800
X-OQ-MSGID: <20240730041018.84379-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000b2c0fc061e6cb26b@google.com>
References: <000000000000b2c0fc061e6cb26b@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot report slab-out-of-bounds in journal_entry_dev_usage_to_text,
it because vstruct_bytes(entry) smaller than sizeof(struct 
jset_entry_dev_usage), overflow occurs when calculating the difference in
jset_entry_dev_usage_nr_types(u).

Reported-by: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=05d7520be047c9be86e0
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/sb-clean.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
index 47f10ab57f40..278e1a25159a 100644
--- a/fs/bcachefs/sb-clean.c
+++ b/fs/bcachefs/sb-clean.c
@@ -310,6 +310,9 @@ static void bch2_sb_clean_to_text(struct printbuf *out, struct bch_sb *sb,
 		    !entry->u64s)
 			continue;
 
+		if (vstruct_bytes(entry) < sizeof(struct jset_entry_dev_usage))
+			continue;
+
 		bch2_journal_entry_to_text(out, NULL, entry);
 		prt_newline(out);
 	}
-- 
2.43.0

