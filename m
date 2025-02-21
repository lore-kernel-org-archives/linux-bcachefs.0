Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A272512F5
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162396; cv=none; b=JMklMwAE83Rlf0dS3wGxJ1cH00+ABUJm9HMSqjGhsBGytmPd2NAf0JQkWBH3RITV0aP8frnucwduG90oMtRMQxQ08OazMW2SuoJ60r3FgcQ34eTfRiV5hl09nQuTI2TonN5QMI8ywdZjvxmhms/7NBN5eroBguFuMaLApm7WjuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162396; c=relaxed/simple;
	bh=Gh3tf2YfMIaAPWZkugyPUuEbnI+p4R1jjqMctK4B5a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMHKo1SQx4IiWiO6kcqjhIcdLyAvlmcov/dLh4wt6iYlJE0vc4YpeBmkWoRU4uchZpJC0Qdl6/zFLgFDfMG9YicPKGWtRowTUhtw69NsT5pb7n0mpGaMXYhq2cAn3LFOFKDG1rbR7SEDQ+Hi3LdMdUP8FcCl535vT1VomaNAZlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDq7NI8c; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDq7NI8c"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so1361296f8f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 10:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740162393; x=1740767193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhwaxfdUnUHJPRXtIotdgaoBMN7h4LXE8+tn493xc6Y=;
        b=KDq7NI8cfV7J0DnM66kWsJWyuXHKh1+I5CcVhB/zhwAIYeYK33+0R6tYJCD794sFV6
         apjQWOLeKxjll/p2alwFh/m/clhgBS5ru7C1LqAxaojB8hLSFiaYxm1sVt9+R/PUSSJa
         D0iLur/pwuMyTeZw/y7paKB9VeQ4+eikgKiIBdju5A34q61l0NzV3Z7nak5p6M3ecnDD
         EE7A2qCYkUPULnepsqiSfknPlCjlfszwBQwoD1dT7Aew3KIxqJ6UPyj0tyVCwdk4CNHO
         UNeONRRJCtMQJu0QrkrUB0/xBvQrrCc8plj8zFkvEP90A904uDF1FMf87I2Hz94duMtZ
         aJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740162393; x=1740767193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhwaxfdUnUHJPRXtIotdgaoBMN7h4LXE8+tn493xc6Y=;
        b=l6PcoTXlA9JI/aG5BzTRVk4B7pAP0J2kgPQd4QK2FHbCanvWp/Q17Clj/lXVCrt86K
         6IXFA6DVMkneJBGzn3X4fKSSC9ja3RrN7qrnhQ2omCINP7BlGn2ibjdkWZGu5TE08PEN
         QU6W4h3z0GS4vT6W2L6RhBw3ge4HCKHAb7xZEzxGks/yuq5KBS6SYChE9aR4LNA24lac
         2XJTMJqOH2gDljn5gybCT5aE/r1HK9jhkt8iJwfwCvH8glF91GNm1jyFHW8xuM8Q8nKY
         sjAYJFKMdfeo3oCcaClsi59XFQcP80aiSZVQPnH3hFVTlSUDNdPxiV35xW3zyHdR33l5
         Dn2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQNUPKfPH0GI/OwYoiEt9aDbRhc77yLTxKbPX05YRZfXnIrohKm1W97fDLfiL5M2aD0iygubWodDbuEOK3xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuvBV7inCwxhpzxYNYNPawX+AJ/hLmNlaKmcySMSGWxbblSPgh
	OwWsNYFEdRy4fKN4ea6fzvfCZ6YguBGWZLoOGLdJWS/HVDJUURxs
X-Gm-Gg: ASbGncuxQLQcJJ6cVFy/mD/dJHorlzX9XQwuLb6+MB9ezlSVTZeE7FVH+PVrI2aN30F
	rvBdzz109PbEyiDjQKzQ7W5SZNAmi++bVwHec+yw7De9iwC8k9DLm8U/v2/oPNPRYUp5OW+i93J
	EsR0ajT0+JiWLo8aHNZXuT07PmD8HFVVeNOQL+eFisZlkfGynDjVx5yaWE+sGPoH6vGZadIFsnD
	x79ME0EJCmZO7kKZ6oCrbsfFRMhJHTFPirUuc72FIJVCCRq9l/4OOkPjBRgoqUVYk+jTjqXPtkD
	GRObEGwGk78rSv6K171+5RXpQwIS6ypWVov2ZPpG1A==
X-Google-Smtp-Source: AGHT+IEcxPVTktwUjicxZUrwUQEVCusFtDf+77UrLbj1rWwPSGY0EV7SScR6Ux8Q+NRwun8/skYDLQ==
X-Received: by 2002:a05:6000:1569:b0:38d:daf3:be60 with SMTP id ffacd0b85a97d-38f6f0bfademr4316556f8f.48.1740162391745;
        Fri, 21 Feb 2025 10:26:31 -0800 (PST)
Received: from localhost.localdomain ([2001:861:73:f8d0:e2df:8a62:2fdf:8d4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8217sm24389502f8f.90.2025.02.21.10.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 10:26:31 -0800 (PST)
From: Gabriel de Perthuis <g2p.code@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	Joshua Ashton <joshua@froggi.es>
Cc: =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] bcachefs: Use flexible arrays in dirent
Date: Fri, 21 Feb 2025 18:26:27 +0000
Message-ID: <f048a5a514b41af8523618ab759c3e79df130954.1740161242.git.g2p.code@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250213184607.18237-19-kent.overstreet@linux.dev>
References: <20250213184607.18237-19-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A fake d_name[0]/d_names[0] flexible array tickled UBSAN.

Use DECLARE_FLEX_ARRAY to work around a compiler restriction on flex
arrays in unions:
https://people.kernel.org/kees/bounded-flexible-arrays-in-c

Fixes: "bcachefs: bcachefs_metadata_version_casefolding"
Closes: https://github.com/koverstreet/bcachefs/issues/824

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 fs/bcachefs/dirent_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/dirent_format.h b/fs/bcachefs/dirent_format.h
index 2e766032e1e91..a46dbddd21aad 100644
--- a/fs/bcachefs/dirent_format.h
+++ b/fs/bcachefs/dirent_format.h
@@ -42,13 +42,13 @@ struct bch_dirent {
 	union {
 	struct {
 		__u8		d_pad;
 		__le16		d_name_len;
 		__le16		d_cf_name_len;
-		__u8		d_names[0];
+		__u8		d_names[];
 	} d_cf_name_block __packed;
-	__u8			d_name[0];
+	__DECLARE_FLEX_ARRAY(__u8, d_name);
 	} __packed;
 } __packed __aligned(8);
 
 #define DT_SUBVOL	16
 #define BCH_DT_MAX	17
-- 
2.45.2

