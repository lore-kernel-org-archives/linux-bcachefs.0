Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5D1241682
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745590523; cv=none; b=eWwEFV9xkiCvXZs+qgk+Oa5Oe+RxNBgoxqx+WiRq5ZqeLMCxmEXPpYLqfi9mhSoiRqJcc+G3iOwYtNCBWuyDvMfTUBJlVkTZxnA3X+SSZSgjefJ/4v/R6lk34y/O7eMiLxY60vLJaMoQwYE3iUIOMc6EncNjnZzIHJromShRmMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745590523; c=relaxed/simple;
	bh=D14rKUp0O9uHFLCes3ZZUMCbMnMja1WXzwrMmkC/+Y4=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:
	 In-Reply-To:Content-Type; b=DJM0K+M+pZEK0AICYY7eqYB0RrV/X4Cmpt+ujUZqab/9mKNn3vK6cGQjK1A2zpHitZm8QlxNH8QhrOrusyIYFC+1l6S6U66kiCuuMTJm6Rj3We3344BGfnj4rpvn9rmjgMLERNI9W7d0boMugaOp+YKCV4UJVkFzEj9+aiiksBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gyjbrw2d; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gyjbrw2d"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso15513525e9.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 07:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745590520; x=1746195320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:to:content-language
         :references:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tnKsNQ1K1ckPHWsJscUiEfI7b3WPynX2dxLjjQJG/L4=;
        b=Gyjbrw2d1siK9eZcfCaaDDUOmxncH05nbeOdCbeqhUMg/h8RviA5LNGtJlwIAiXj64
         Ze2hs1r0zIv8P6+EU6G3lSF9v2Zc20YBLScLqjMoH034es91Xh7CkjZX0bjRrqGc+D+x
         MXw8NPSFQyEiXXNYQ2p28r5btlEGmhm5xpr683FO3lyYsx2N5aQVxUArdm0ybLHRJRoc
         ZZkxbt5UyMEQRO7qYKfKtaC7oOa9SPlEqVZwN0ztdJkPMp2iPcojoic/M5DY3a/FbfRX
         hfnkcJezRjELr7MxI5Ln5/xk27SBmYnYhK2IrEMbC+eTz8jyqcZ3SRH0wn7BS/gnsZUh
         uYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745590520; x=1746195320;
        h=content-transfer-encoding:in-reply-to:to:content-language
         :references:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnKsNQ1K1ckPHWsJscUiEfI7b3WPynX2dxLjjQJG/L4=;
        b=XNudhDP/P5rzdYzeegidJoO7GMPDlpe61UCvAypsqZ0iIMavtw7zCLjjG14eJ7ckI8
         5LbaH9WoWvoxLAhX9ciK2S+xsXUPrLsirbhPSJ3kRxowcHGiBz7L6la/wdyH1WryiBrR
         YGEmzE79UOft3FnqEaiTkAJKcDRvnNdOuQePnqkvs6fzWH+QnzTtWLbNrwu3K10QqJRs
         BaNRiO9wCkHoSNl5KyhaYDeHE3zxQBxRKuoNyh/V3bEihkStdo1Va8g67Kpnkfqo3vCF
         CD3mryMMS+RShCpWdywuqBgzgnVEKjgSejmZOpgSHm4XJrCVqCAbTmypJBruIeKoWVmn
         PhZg==
X-Forwarded-Encrypted: i=1; AJvYcCWRuRxpQwbiUCdy2wsMyAHok3x15MvVWWSkCkRzAPXWa+peP/lVXtvRCUksUCoEW7JSRZY62+KRSdrnLk7Vlg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3fYvLgNPT1mdM0gmxGi9OdGoiKCvRHLLLqWjGl7ghytE2iGla
	TUwO5kwxgGilJj1aVuTBT+XotQZCamozlYjA8QrU1p2Ykp4QUvVIeRVQ6w==
X-Gm-Gg: ASbGncukU+61kWDRxBDU58q76chHYbH3WaTWX2GXzAGuMLs9H2mMn06h1aQ3a1LDIXD
	adyWVTPtaEIlbNJSFRm5FdL21dynT50FRUDpdmJLRyKDwLWAoWTRxc5mXpGWhVll3ICduW+vIRG
	3U0LR9cp4nqGXDkjgNJvJYN5HHo2QGseqfuh+y74WAK1FqZQcGAexBMHyw0viL2s2hDAnMdJNfZ
	V7boRxlNJUYA4RE1ptkgk98NRVDZR+rDaTFc0HArmYaUSFuTMYoqxkJjy4OMCT/cTjJe762UZbR
	77FL0zTioO7oRvH592To78gPm4joOXPpVYWbYEzKXnG62Mi1w2qdMYMhnu0fvAGe16IJDtpShoP
	O9HMV2Q==
X-Google-Smtp-Source: AGHT+IFKbtC9SIkbMmoVf9C9NL8EAlKYwHrOBmyzKhwYmST/Ws3mDR3W4gYhu51LtpCLLDkriwThcw==
X-Received: by 2002:a05:6000:430a:b0:39e:cbca:7156 with SMTP id ffacd0b85a97d-3a074e0f4c2mr1926108f8f.1.1745590519997;
        Fri, 25 Apr 2025 07:15:19 -0700 (PDT)
Received: from ?IPV6:2001:861:73:f8d0:836b:f73c:457e:5674? ([2001:861:73:f8d0:836b:f73c:457e:5674])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073cb2acbsm2469985f8f.40.2025.04.25.07.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 07:15:19 -0700 (PDT)
Message-ID: <fd204ad5-b8bc-45aa-b761-fc2ef91abd27@gmail.com>
Date: Fri, 25 Apr 2025 16:15:18 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH v2] bcachefs: Don't pretty-print options in /proc/mounts
References: <03c6436f10a17e4e520c611d8dbca0b5a56532c8.1745590098.git.g2p.code@gmail.com>
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
In-Reply-To: <03c6436f10a17e4e520c611d8dbca0b5a56532c8.1745590098.git.g2p.code@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Pretty printing of sizes could introduce spaces and break
the expected space-separated format.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
v2: Tested and working this time

 fs/bcachefs/opts.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b1cf88905b816..633137567f463 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -452,25 +452,29 @@ int bch2_opt_parse(struct bch_fs *c,
 void bch2_opt_to_text(struct printbuf *out,
 		      struct bch_fs *c, struct bch_sb *sb,
 		      const struct bch_option *opt, u64 v,
 		      unsigned flags)
 {
+	enum opt_flags opt_flags = opt->flags;
+
 	if (flags & OPT_SHOW_MOUNT_STYLE) {
 		if (opt->type == BCH_OPT_BOOL) {
 			prt_printf(out, "%s%s",
 			       v ? "" : "no",
 			       opt->attr.name);
 			return;
 		}
 
 		prt_printf(out, "%s=", opt->attr.name);
+		// OPT_HUMAN_READABLE can introduce spaces which break the expected tabular format
+		opt_flags &= ~OPT_HUMAN_READABLE;
 	}
 
 	switch (opt->type) {
 	case BCH_OPT_BOOL:
 	case BCH_OPT_UINT:
-		if (opt->flags & OPT_HUMAN_READABLE)
+		if (opt_flags & OPT_HUMAN_READABLE)
 			prt_human_readable_u64(out, v);
 		else
 			prt_printf(out, "%lli", v);
 		break;
 	case BCH_OPT_STR:
-- 
2.45.2

