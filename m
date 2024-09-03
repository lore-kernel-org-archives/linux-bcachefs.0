Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9616E1CCEDF;
	Tue,  3 Sep 2024 02:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725329589; cv=none; b=BTguBsRTMeG1o+e4SDVQ4jWz7VSDYKtlN9f07YJ8jp78pulrHPSZM7tTBHAQpFcn8FKZNhpwD2ndy8p2fzJlGgwom6SO5Lk5Jm/DZ1uH6WAl1X+4dMyIorygQCwkH6TaoXuZMdjbNGsfq5a9dbyybGO2ljv4hx3LSnVlTI1g5Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725329589; c=relaxed/simple;
	bh=GQfPyA/K7p414Vqf+JW+xWVAOD95RF0BlKhao2Y7ez4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=kZBW9xK/7YhUPH9YVMRaCIq/ulBB6JTWR28+rNcm/Vuk3pmvtsd0hTWEOeCYSdjQhBTXkC3WANCc8f8paz9cmlSMWgyFzA+CkzkushkpcCwJnEDHntd2/cAPK6TeEHgyFHGnL6rVlP+1APxJC/O0EcNsm/pWH27My5/0w6DSN8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=fhCwdvsx; arc=none smtp.client-ip=203.205.221.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="fhCwdvsx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1725329584; bh=pBMh/lRqkgDgcFwzfKRuq4u2YfMu4QR8UX6graWcUsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhCwdvsxHGuCAbXzWDY0zd2gwEHvwHxD07C1HoP0mfGoRC8ma32/Rv1TkicU1pi1n
	 1CYVYw+Cs593kFnYN7Q0w2lG6lXT0lg6TgBekqCF+gUUL3nE7j2wzQbZ7giDCrXl/y
	 c4ml6tOiRp0TABOgoDHnCn5T33PXHxtgB+i4SQ6A=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc19-0.qq.com (NewEsmtp) with SMTP
	id 3419B22F; Tue, 03 Sep 2024 10:13:01 +0800
X-QQ-mid: xmsmtpt1725329581tuvi45o3g
Message-ID: <tencent_6ECC3C5D37B696EC36DE4A4C759B770B6709@qq.com>
X-QQ-XMAILINFO: NyTsQ4JOu2J2dyjoxmi2UiETfu3GcAO1sOoWv9PV9n8oBpHog5VNwdngiF0YLt
	 AyKV5zfc2VCSYlDkw5fgHBlRwTF5uoUbjU6FzJ7++3D4fk7M0iafbY7IPuiqso2pMuj+uwvdSAr8
	 F6qQqOKAoTdXujvbyOmCykOZ27N4l0QDdb+lA4PeIwUhn2iHgECpFdCwQnyBORrHoqPiBvkeMeeN
	 zZM4ILgxuV5CH2Dtr0UixmlgJ9ndwF/inu+AzrhMOOXG3ZVMqiPQhZl6j10JdP5Uxg25YN+ezOVS
	 I55TT0pgiN2t93AHvvrI3tAoW2fHd6oq69crvtz40xtbpdEMeQX+PzMD78FIvcK1XmJwL2QOnRVv
	 S4Zwu8KoQBNUvpKFC5EFjdbANqyQtjPSWTQbERh3K0mZpeMOpeUY1ltp/DZvolFc0epg9OJsF5kC
	 fCRpmrK6b4A9/8kJ9aO/K2Kn9Lwi71IQCmUzxRJUjUTdUv6Dk1hS6JCvP04TFWe8yaYcpfBaAvgv
	 vBgNNCWmxq52CZ2ljG2911DzV8djCcnage3b44SGZdcRxBnO/bazKq4pxNHJ4KD3wnEiKf4o9EIK
	 ShXRv6xQ9lXOXBKI8r44IM6li+qTTjkThJURQ+6IstILFtNuXG6cwz5DSdl6d1Qn7moPgchby9Bp
	 oSY6CweztGqJfn+T2gEcdUyuxDR0pam/XZvW60McUNi882+dbGq/UsJBnCMxmiySD3SqfI7PmTLq
	 34lS9HbDVYnnayGhsI7uu/XWhy71766Bic02KmJMvKloahQldavhXgS14opbGXK0rF/6CHj1xqUy
	 82lWm28OybiSwYtBRp8/qxmmmajmKK0Ii3qklAATGhf3p8pUr61EOSCkhBpXGKjS48vYTlEdqg6t
	 6O/eADxOzC0XfrWqpUgiH1aX2SSzmrGrSS1TpFLFgz
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
Date: Tue,  3 Sep 2024 10:13:02 +0800
X-OQ-MSGID: <20240903021301.2616960-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <00000000000005e6c90621278371@google.com>
References: <00000000000005e6c90621278371@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because the value of m.btree_bitmap_shift is 69 in this case, it cause 
shift-out-of-bounds in member_to_text.

Add a check for btree_bitmap_shift in validate_member, when it bigger than 64
return -BCH_ERR_invalid_sb_members.
Simultaneously adjust the output mode of btree_bitmap_shift in member_to_text. 

#syz test

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 39196f2a4197..85a4245ea6a3 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -162,6 +162,12 @@ static int validate_member(struct printbuf *err,
 		return -BCH_ERR_invalid_sb_members;
 	}
 
+	if (m.btree_bitmap_shift > 64) {
+		prt_printf(err, "device %u: too many big bitmap shift (got %u, max 64)",
+			   i, m.btree_bitmap_shift);
+		return -BCH_ERR_invalid_sb_members;
+	}
+
 	return 0;
 }
 
@@ -245,8 +251,7 @@ static void member_to_text(struct printbuf *out,
 		prt_printf(out, "(none)");
 	prt_newline(out);
 
-	prt_printf(out, "Btree allocated bitmap blocksize:\t");
-	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
+	prt_printf(out, "Btree allocated bitmap shift: %d\t", m.btree_bitmap_shift);
 	prt_newline(out);
 
 	prt_printf(out, "Btree allocated bitmap:\t");

