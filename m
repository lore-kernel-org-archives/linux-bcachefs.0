Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE12135D1;
	Mon,  7 Apr 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744047792; cv=none; b=PZplZpk0LmBbu2J3TQkPYaKHW6EeK97Rb9eaF+EI2Ys0P6FuCoaRr8a0yPpRh54P5qFHZMjZiHkSx3LZ/zwoNzAj0gTftrAVNGKs8fTjALufc6eYxn/Uv53wAFCmEOw5zt4CN80YMEZ5PJQEfKdxDQRyup7fqK/KNy/FcgjEj5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744047792; c=relaxed/simple;
	bh=8hWmLsettw34H0/IdlPq3m8ikToGK0KA8pLw/AI0uRw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=juJNkVCz0r/CbJeWeQDMZjUkNvqt1oTpY3lqmCVs2YZXBv5QbijpCXONyLhe0X0vX9OM3SSpK0CFxcjSAZ9UdmfijSWJbni/ov6dE93Nzpracbyr65rLuF4vKd27RfTxZIC+pjDkMgB8Nduvljx2Ql1mdRdqqnP/MxXCuVo7c5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=5EYR3LV5; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="5EYR3LV5"
DKIM-Signature: a=rsa-sha256; bh=4P3JWbPT48Pf/5vDpLRBWrxPuB5msRnmEau32urQ6js=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:Message-Id:Message-Id:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1744047770; v=1; x=1744479770;
 b=5EYR3LV5y+rnUUPIQPn980+LSt38JyzX8NUXtH7fEqhD3/nANw6ThW1sQXPqA3lsqd4zbHF5
 C2SkMhhiBU93XHswqv7Uir0b7PDihCS6A+dm7N0iz6x4JdHM9FQNn1VCX2i7RjdbuQ3E+AmBJqj
 aHmkAo7wZnQXJHfPNFr8bhEi84hs6XRnb9nmECjbOr/CMkMezHutWDjHDrsyw17TuY9yX4/smKj
 o0GcORU3YVY1Hggo9GZ8Ioi6KgxbLCjs+fvnv2W767MRcmyfU8eRbyKTs1W0Ntg8Q9QZARm7GAF
 blO+WXMhHgcfzT3jhPI+m/UpajNtSS0uXtXEuHrjSaMcw==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id f4f16034; Tue, 08 Apr 2025
 01:42:50 +0800
From: Integral <integral@archlinuxcn.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Integral <integral@archlinuxcn.org>
Subject: [PATCH] bcachefs: indent error messages of invalid compression
Date: Tue,  8 Apr 2025 01:41:31 +0800
Message-ID: <20250407174129.251920-3-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.49.0
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
the argument of prt_str(). This patch replaces '\n' with prt_newline()
to make indentation level work correctly.

[1] Link: https://lore.kernel.org/20250406152659.205997-2-integral@archlinuxcn.org

Signed-off-by: Integral <integral@archlinuxcn.org>
---
 fs/bcachefs/compress.c | 12 ++++++++----
 fs/bcachefs/opts.c     |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index d68c3c7896a3..a107aa88a875 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -713,8 +713,10 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 	level_str = p;
 
 	ret = match_string(bch2_compression_opts, -1, type_str);
-	if (ret < 0 && err)
-		prt_str(err, "invalid compression type\n");
+	if (ret < 0 && err) {
+		prt_str(err, "invalid compression type");
+		prt_newline(err);
+	}
 	if (ret < 0)
 		goto err;
 
@@ -728,8 +730,10 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 			ret = -EINVAL;
 		if (!ret && level > 15)
 			ret = -EINVAL;
-		if (ret < 0 && err)
-			prt_str(err, "invalid compression level\n");
+		if (ret < 0 && err) {
+			prt_str(err, "invalid compression level");
+			prt_newline(err);
+		}
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

