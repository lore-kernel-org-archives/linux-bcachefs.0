Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AA82206A2;
	Tue,  8 Apr 2025 10:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744108309; cv=none; b=ZOOXVsmvBP6M37MAtaPYRH0dRCvWIjuCN5+ckvk7RfLwnr+fznmwFarjujN8D3r7OXWj70kpHboP5QJIBt//CY644/vbsJw9QSWYgYMnWD/64oArrTiZ9BTRRjzqmynl1xdwFbynQj048gWz5300lZv+zpOm6vbxpZbEAZt0wKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744108309; c=relaxed/simple;
	bh=PJ/j1iUqd0Rk3qLfk/yW/HjEuRuM5rVtIl+dWeNuOPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2jmeYqoXHJWYNSwdZRr0piQcWtKAMmgpkIjXl5I7Uzp84FmP9vxiHMF/U0eJr7UqJh86yOL3QpbXc7hsftBpp+Fo8fvActlmubpf+hycXvqkOrq/PWzTSA9hgFNtpd92axIG+ahNCCOtE7tLEI+Joz7TWJL0a5Uc7A0DZDhJJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=vyftkwxj; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="vyftkwxj"
DKIM-Signature: a=rsa-sha256; bh=fBUwH/TXDriRMaqhNspfOTIAoeBApUAl/ZQPgSW7+mU=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1744108296; v=1; x=1744540296;
 b=vyftkwxjpX1Qlrdyh2TgaHRRPlUM6JtIvTwaeuo2de0v1LEvQE52ZONZjtwKAcFRUUX4tpqf
 xy+R9nB9fIou/qAi2rBoQryFDYyKN3qWfx9/pMxsW6w3wo4Z9326lJTfnJLhUZjMoL+vCtQ0WM8
 SyfiFBubjkMkB1+UpXGbaP7VC/3Y1kQVwKNyWwPJylXXO1J9d5bHOPdDfpmkFDUqoGvGmZX7/lS
 b8I1g6kpe3rfjwJRpaqjti+tkHmwfxQ4ziOmndjSxhjdEzPkzMoVUgJbeFpZ2aHHpuIOqM0EmYc
 8va/Jf4gHS2+OISQehKjgJ32ITm2xAvUTpRQp0WFE5Stw==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id b79ffc12; Tue, 08 Apr 2025
 18:31:36 +0800
From: Integral <integral@archlinuxcn.org>
To: kent.overstreet@linux.dev
Cc: integral@archlinuxcn.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcachefs: indent error messages of invalid compression
Date: Tue,  8 Apr 2025 18:31:29 +0800
Message-ID: <20250408103129.61829-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <sd4nbvk24h5aiooqkzczyqfc33t7triwlsrp4neyd6wovmodak@lwvvuurcehbu>
References: <sd4nbvk24h5aiooqkzczyqfc33t7triwlsrp4neyd6wovmodak@lwvvuurcehbu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch uses printbuf_indent_add_nextline() to set a consistent
indentation level for error messages of invalid compression.

In my previous patch [1], the newline is added by using '\n' in
the argument of prt_str(). This patch replaces prt_str() with
prt_printf() to make indentation level work correctly.

[1] Link: https://lore.kernel.org/20250406152659.205997-2-integral@archlinuxcn.org

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 fs/bcachefs/compress.c | 4 ++--
 fs/bcachefs/opts.c     | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index d68c3c7896a3..1bca61d17092 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -714,7 +714,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 
 	ret = match_string(bch2_compression_opts, -1, type_str);
 	if (ret < 0 && err)
-		prt_str(err, "invalid compression type\n");
+		prt_printf(err, "invalid compression type\n");
 	if (ret < 0)
 		goto err;
 
@@ -729,7 +729,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 		if (!ret && level > 15)
 			ret = -EINVAL;
 		if (ret < 0 && err)
-			prt_str(err, "invalid compression level\n");
+			prt_printf(err, "invalid compression level\n");
 		if (ret < 0)
 			goto err;
 
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index cd7b0cd293c7..f35fde896253 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -365,6 +365,7 @@ int bch2_opt_parse(struct bch_fs *c,
 		   struct printbuf *err)
 {
 	ssize_t ret;
+	printbuf_indent_add_nextline(err, 2);
 
 	switch (opt->type) {
 	case BCH_OPT_BOOL:

base-commit: 4d37602fceff942694069cf33cc55863277bd1c2
-- 
2.49.0

