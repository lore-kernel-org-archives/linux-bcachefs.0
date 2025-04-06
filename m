Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890022094;
	Sun,  6 Apr 2025 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953372; cv=none; b=XS1vNy0DUgMoe5E/aifv9RH0LkzclC94U1Q6NCyywu6+jZuHinzpeHNdoiIsOq/DnoAv6jjBWE5/F/zDgWFBMQ6YGRzm+SqIYTlZmHD0yGuLVXhST8+//X8cdO9AhX+b7zRGKqYYf90uEQ2s15Max4ZwiKNsDjoHV/zoAxdKCjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953372; c=relaxed/simple;
	bh=YoxlVE1NNFWhvFPM+Z710wwtc4G/kXVJqJ0pNBN+izE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NC0qUU/aCdLl/DaxNPJG5EefmxIG5V1eD7xZXnWbEtBTjqOA0glkSpyQtBMYDrbJl+tqeXTgCEtjecmi5NWb9Ijb3Kv18wPLaCwVDm2BRA9omhmJ0o96D+5L57GAzY5hiOedkH4hF2gzrUGlCn06pU82hMThlHvou8T1egR+YfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=kQ4eeGAP; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="kQ4eeGAP"
DKIM-Signature: a=rsa-sha256; bh=jukXZqaeNyvPqh91iQiPBT6NXbL6OtIBSxusuULnE00=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1743953359; v=1; x=1744385359;
 b=kQ4eeGAPKqwAu8xwkwgAlmP3HBMn+jaTUrIAxyl66NmHEQjyQ4e+X9EFshKcCL6mb3vR9Jvh
 ar2vlwXCmM/DBQ0Cv6xgtCEzuZ3MqXVLTplHyxgOuGMz90UzlrEVVcaj47tFAQhDaRn2J9Kp9a7
 mTTf3xAcC8qOns94i1IavtOb6fnmtpBbw0YucoOrsYU2gosZmXiyZkuofShhVdtnNXlgOI7ERSw
 kBIPTfYgMJoPmgNUK6sa3QJnR8KP4+W2UGdi+sK8xOR0F6u3l0d5l6QzITrtWc+qGo8v/MWE+j6
 kvuwGrFjJjKLz+bnIp5oN0nCsBBwIu/9QVB4vKnnmxYHA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 7f7b7b40; Sun, 06 Apr 2025
 23:29:19 +0800
From: Integral <integral@archlinuxcn.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Integral <integral@archlinuxcn.org>
Subject: [PATCH 2/2] bcachefs: refactor if statements in bch2_opt_compression_parse()
Date: Sun,  6 Apr 2025 23:27:00 +0800
Message-ID: <20250406152659.205997-3-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250406152659.205997-2-integral@archlinuxcn.org>
References: <20250406152659.205997-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor if statements in bch2_opt_compression_parse() to make it
simpler & clearer.

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 fs/bcachefs/compress.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index d68c3c7896a3..adf939b47107 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -713,10 +713,11 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 	level_str = p;
 
 	ret = match_string(bch2_compression_opts, -1, type_str);
-	if (ret < 0 && err)
-		prt_str(err, "invalid compression type\n");
-	if (ret < 0)
+	if (ret < 0) {
+		if (err)
+			prt_str(err, "invalid compression type\n");
 		goto err;
+	}
 
 	opt.type = ret;
 
@@ -724,14 +725,13 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 		unsigned level;
 
 		ret = kstrtouint(level_str, 10, &level);
-		if (!ret && !opt.type && level)
-			ret = -EINVAL;
-		if (!ret && level > 15)
+		if (!ret && ((!opt.type && level) || level > 15))
 			ret = -EINVAL;
-		if (ret < 0 && err)
-			prt_str(err, "invalid compression level\n");
-		if (ret < 0)
+		if (ret < 0) {
+			if (err)
+				prt_str(err, "invalid compression level\n");
 			goto err;
+		}
 
 		opt.level = level;
 	}
-- 
2.49.0

