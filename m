Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1436D6FC5
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Mar 2024 03:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710992583; cv=none; b=LKNuclzdzESYcHDF/yqoPIp5VVJYEHLtkzr3nQUAzMIW7KxGlYLdZc7w49mcIY/VQbiU9yiR52mlq0uTSTzRJ9c/Hug7kukms3q+MRiUtoV93cSNhW8oziblSNH+vOj7s7Y5CUFyZsuDN9j3tR50HAoQsafYP9Zsx1pP8j0iHIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710992583; c=relaxed/simple;
	bh=1GBJ/mMXVpuFKGwWUFc8pcCRDhKY55Jv+Vtupl8uVh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=psTb4To2yLm8aKK1NaX32WeVZyLEvSU6pzuzZI/zEfsnx1hFVmYZrTA2SAxyqPoDWTNBIxZp0/01aNotiC3UKnede53HaO3rr8E75MZmbCIcvqvtSIpFEADUwnyVXhTwYls6//kyOqZsLvdhnLN4nafpSWIqyybqcOKznyd1gfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PPqz86PU; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PPqz86PU"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dcbd1d4904dso500662276.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 20:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710992581; x=1711597381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PKl0+VlcqjioOqk87D9R2597+8QGGcPzCan8pafWF5g=;
        b=PPqz86PUaZ92cPYcA63oGytcEMa/nTbuDtabb5YuhIjsh6HGAezMP5g+H+q9WVY4S4
         95L2r81kDCaNEdapnL5v/TlRmFTiWsuhtx6MJUsoWrw0ObGZIs3nGqp1hvvQvmOMfxjy
         HDwAhROmN5QKe/X2eO294Y0rhfL+S3/NoD5g/5/HSG3RyLxOnomLMqoqhP52Iq0XdET9
         jOnfIHsz4Sg2ob1kizrW5EG+gxGkEvXFulHIFQ2R27LiOxizP3ob9W7zZf5oZsdBByQc
         Vv4QYJaV+a8tb0CUnBPstid65JdEo/u1sCnjI53UXanIjtfM31PDY8r/eWC9oTNGp3uu
         XrAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710992581; x=1711597381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PKl0+VlcqjioOqk87D9R2597+8QGGcPzCan8pafWF5g=;
        b=Tpji/STqj/i2QFe+F2iXoGuu5/tlSi3WvkzUWaiadXlVu/xheMjE2LnCIXS1a7DI3K
         ASSaZQz4sFnHesVVTtmrqHDnGsP4E1VZ0a11LH8pYujQpvdfknbNrE4Aad0+6RkKozbx
         qkppJ7LEeDmpYOnzpgiZdCjhTcKize1yC05PwFiUXhA7TdyxbSwalyPLI/s9N+849+vS
         tfJJw9hjNmLryKnpoe33AIhUSCYqqF1/HZH52GqNFb5Pc9je0jpy2qJjoc5TF1UN7uW/
         +ymvH6n72K9x9ODr1KjzTqEuiVLyoiXXMp/aeltLSk8JJA5wsEBbHxcNSNY9WemjdIQo
         Vpyw==
X-Forwarded-Encrypted: i=1; AJvYcCXY6UAfrvCXX7C/n4jQS1tNlA6bMLL4fokcwPvgn+xJ/vxmSs3wWWzXvWhQydCIHL7q/jl46D6afzDC+9mgXhltO/ONpnqxrMzDW6V4YvE=
X-Gm-Message-State: AOJu0YyjTbaEZ2hIAUjvlALG0915+eftL7ZfIfPlINmLn8b8DgUOTjuz
	56psgHGrnfQIEswLE3rzm6picMnuXZH6PQMCoMXrXbvQIyNTjt/Y
X-Google-Smtp-Source: AGHT+IFhJ04ko0q+aTMNnPGFCs+BJQwphE4ZwlV1tW6V9ihkgHiBKlQYwN6nlyFqPtDiSEY7GAjIgQ==
X-Received: by 2002:a25:2704:0:b0:dcc:588f:1523 with SMTP id n4-20020a252704000000b00dcc588f1523mr4009383ybn.49.1710992580825;
        Wed, 20 Mar 2024 20:43:00 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id e2-20020a92de42000000b00368574dc676sm899474ilr.35.2024.03.20.20.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 20:43:00 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: fix misplaced newline in __bch2_inode_unpacked_to_text()
Date: Wed, 20 Mar 2024 21:42:42 -0600
Message-ID: <20240321034242.183717-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

before:

u64s 18 type inode_v3 0:1879048192:U32_MAX len 0 ver 0:   mode=40700
  flags= (15300000)
  journal_seq=4
  bi_size=0
  bi_sectors=0

  bi_version=0bi_atime=227064388944
  ...

after:

u64s 18 type inode_v3 0:1879048192:U32_MAX len 0 ver 0:   mode=40700
  flags= (15300000)
  journal_seq=4
  bi_size=0
  bi_sectors=0
  bi_version=0
  bi_atime=227064388944
  ...

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 2b5e06770ab3..ca4a066e9a54 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -552,8 +552,8 @@ static void __bch2_inode_unpacked_to_text(struct printbuf *out,
 	prt_printf(out, "bi_sectors=%llu", inode->bi_sectors);
 	prt_newline(out);
 
-	prt_newline(out);
 	prt_printf(out, "bi_version=%llu", inode->bi_version);
+	prt_newline(out);
 
 #define x(_name, _bits)						\
 	prt_printf(out, #_name "=%llu", (u64) inode->_name);	\
-- 
2.44.0

