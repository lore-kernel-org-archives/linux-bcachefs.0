Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A118E06;
	Sun,  8 Sep 2024 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725801057; cv=none; b=JJK9JuDrZRLyj3EItVpvNtI6fO2ptlLWcuD9nKeFBJM1Hw4fdu8z1C1DJbD1JBrDKOVJ1fmHQnsEm3z+tRW3MQlgUnq29OK+vleg/Dz8qfg7frni/s9GYQMmfv8h2DHFPeDUFAaalCd1AcF+J1oMWswyoTaVwE7AJvmFmfAjAJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725801057; c=relaxed/simple;
	bh=vmy3wYtA0bqBkRE7D1HK1YjHmGiijUSC5O9noOIlX2g=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=QO2Db0X+jsJPHcRhOvOKImkncFsjDDfFDC8RYsUIPL0RB3/+8KehYfqG/zQQN3yaVg0t+tcbz+v3hR3VtCufA0IHKbw2s2FsRofi+LUJDmH5XhXGXsiKbo+NSak/Of9Azw0yxChv95IgPDM4YWL/P5l/c+W3Rq0dfNp5xc4noj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dBFK7HKw; arc=none smtp.client-ip=43.163.128.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dBFK7HKw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1725801052; bh=qCzKK9/NiFxsnYf3uyLTDZ/hnpDcPheM8WoJaeTXBr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBFK7HKwaWne2e2Lz7fXhGYhkXcan/YSXoOEVcB8wBspuWWP4unLO2UiOsssrVXQE
	 a0TwKcLfzdDwnSHRpVIUB7qoYAkpNQkekI2yDn3hTsUSAGQOGyvympbk+/iByBSQbu
	 3gzyyNGLSlsGZRFeoXXTD8Aj/yorTr3R7CjBtoCs=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id 2B186C72; Sun, 08 Sep 2024 21:10:49 +0800
X-QQ-mid: xmsmtpt1725801049tj4vudcw8
Message-ID: <tencent_3EF360A372696363B6E45AF76BD769C6CB05@qq.com>
X-QQ-XMAILINFO: MyIXMys/8kCtp7tarnHIJG13GKqToQsjfTNkDCJSgaYxH/dIdOeXWP6Mb5W/4q
	 ctES+x0BVaCRRWYu5bca7iiPVk26tYdrtgEh0noZK12D3429hCtSIRZu+R4S3ktbjrVQl6MOf4eB
	 ZK0QJkj9IrZ2nj20ij8qDV705rAFMCaGFcjaYhErH2Z8vdSvi256Zlov4jEGxNj7VklylIGG1xGF
	 10dXTeJkBGTFHXfqj7MBD19dEJFsAP40fzZNfYJkJ5gMEwqzOkElrHSuupka2ULLRlVR58GkyL9V
	 CW8eZgtOGGrPLiwsFtYGP/6gy+qCMy8gkvZXFCO1vlPNzQ2nhxi2opiGSBor1GUc+I205sYqUNHY
	 G1mNFHOYDBxSl97IF1D52pZ8SMSwwDrnmxLfoFWYypuBEelv0UORCGdieAggIx+u4xUZzSn/rjGe
	 V55ak4g6aO3VXYiSly/RgGQUGSIN4YX4ejGBQsRvZZ4ICQnnl/6ggaYg6Ee/LpGlNmYeBzgRUZjG
	 MtYXQXiAsVSEG9eYRNtTXLmDXVa3ilDCmzL0j/NoEMTXiYdqdrNoYcDliUBubGC4DvVAsvSYM8D1
	 t9ri8B4ZoxR80ZZkAj36nP7PEBvaSeSKQIqdbN+vK6sfgk42UlJ3R91b+GOpkuTJvXDJasMQMrmk
	 2Kl9hEkVl7Hv+whwIlGnBiAYgpD9nst1vysoc7M/clnjKwsZ/ma4wPePRfrb73GW1GKWOI2cpAAJ
	 7yTU3kY+o4ZklsoCRU+ROoXl279uKJD+QsQos+pSoG3IbXlpq9sKL99fVY37SBTjEnaH8kUUDDTx
	 32r1WuL41dd/zzn2u80ZB/x4TyeRS0fxB8OhLX7Uvmj08mcKsnGtDAcZAKwVKe/Qrc3qu+Lrutto
	 CqmlxaHpWvYnaig7b7jibj6hTNYI+jeB26vceZmfVSH5uE4MWB129EavbQqUTwheG8VktiCuaiES
	 ohYgHB6W9KAUw9O5RVUWRaFluaZgHvCGCieBXoN76zaPDfpWOi6A==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] bcachefs: Fix oob in member_to_text
Date: Sun,  8 Sep 2024 21:10:50 +0800
X-OQ-MSGID: <20240908131049.1851817-2-eadavis@qq.com>
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

Add a check for btree_bitmap_shift in validate_member, when it is greater
than or equal to 64 return -BCH_ERR_invalid_sb_members.
Simultaneously adjust the output mode of btree_bitmap_shift in member_to_text.

Reported-and-tested-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=064ce437a1ad63d3f6ef
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/bcachefs/sb-members.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 39196f2a4197..c9daab47f886 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -162,6 +162,12 @@ static int validate_member(struct printbuf *err,
 		return -BCH_ERR_invalid_sb_members;
 	}
 
+	if (m.btree_bitmap_shift >= 64) {
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
-- 
2.43.0

