Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4886F18E20
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 Jan 2025 04:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735963650; cv=none; b=QJ9PUOLMqhgGlBPbff/BIJYWy4ouhnWjNsomTWXSXFqg+UouV1vdK6Sm4m5NdhggdTFW+Y+LGkcp1ZTN/PIDKIzo1RF+rm0k70aowD/b5IE8aBG1MjrJgjDZM7lWY3CHrYoKAfvBLWKyXFPIOpPU91i+zLO52nW4sGFAr3NEZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735963650; c=relaxed/simple;
	bh=4OcLfgfz+HQsUGvQXBT5m1FX2zxjzkA1jSjCSy/t37U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcjbsyIwkvxxpwTDHH5YAcp00/WBE3fXI42rvQ3j5n0ouL076SQgxx4eG+3y0mYcXIvD19dZonL6ED6Boa7LkDuhBwOtr7msyMV7U0XHGzmgW0tILWTx5hGZDxKuGuXx3gG9hA0GiSqd0sIuwTO/E5rBKWjltqgxUSsIxByxU9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KT23Qvtp; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KT23Qvtp"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so1022081239f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 Jan 2025 20:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735963648; x=1736568448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3Mm2LeQA8ztu0b87Rmoq6/u2DnxJOE+rzOKOD6UKy8=;
        b=KT23QvtpssTNscyxJV6yNs9BaLoCZO/CCCNQSqYNce3sYIPR/1aI7kn+Nc0Wnfl4gX
         eTDEhv2r5+eNFyB6OhBaqN8v2M6kUAtcM4J4gxc9CS7jqLh80OCu4LZ6kkJDE84fSrn2
         M18QnLD4WUylkFjkV43kNSdT0QEFlP7Z3nCofJrBRSzEkBLisFJxQqxTflns0FUrBne9
         ED3d2hogZCgn9VxSL8b3Fs9e/EPKW8Ln24LtwxZH9EuthVN1jh0hQGuKFrApaz4HoeuZ
         rMc6pO6kqfOlloMH8np2yJ2PUkNe1b5LUtb3EHypydoor3d0BL/VQ4hvndKrt2eTqA/j
         XM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735963648; x=1736568448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3Mm2LeQA8ztu0b87Rmoq6/u2DnxJOE+rzOKOD6UKy8=;
        b=HIIoW4MrlXTyBTdfWO1/sB8UaElf/3L2lkkOebpzDDgPvyq94R7UH3te5m65fqxi5j
         AQY4uYP4xRl5zPAa1gEScv/LpF+AQQ79agMTgPLWNt4cL0d992QMOiCKr/wKDx1tTrYW
         k4rEufcTYHhJLGHdyTg2YKrmniXsEBsN4SxmUDodnfKh1lFD0e9c6Z6rugujHgQSoHIp
         ya7cqcT5sKkqApxjpD8rUUAlLKyM9QRw+Va4pafCZ4ln8ijAyF1yToVL8XXqe/zdAAQx
         yKT2wLnkO6qUGaGs2ur7Oo4qIozO01mczn2xwQhh7MTgZUddKWEozhWKatIlRKmzIwrU
         3DPw==
X-Forwarded-Encrypted: i=1; AJvYcCU89GHx0uV8sTSguEEN+nXIsLaOLcgwm7yDsXfssAtpB6nauOI/yTEZFvXxaOxejW7I1WmLZOFC/QBlt6nBeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo3VNsRN3HCxCW64RHYtk6wHJF2LonctzyeZ+GTi0YpnH5ApZW
	Z/PBynkqUKl61i7F1GRmSBVcDEJcL1AhTXG5Sf5SO2+u+jYPnr4Z
X-Gm-Gg: ASbGncvrR05VBC+Pa++VHd7NF/3s4aJq6DuJGgas60Zp66Jcf5w7GuiwNptcJahOJBT
	RtJ10Uqjk90qI2glk5puyIJlxV/R2sIAzZLDCjy+yQvCuWFJAczIVDOuRTDENcSvvE6hxPQr11h
	8VYEHM5UN8Q6vQ3wJYkPmWCv3B8tVqJuIxCtGnwAWUwuz5jNjObBt6Ans6pX1V4+C99tHc29ZuY
	L8IOxxtTvDBfM3C31hkGTGlQduT/zY8AE4z1XO/uUHOAgXbIOshMmU6gC2LpauAojHbGk2BKNZv
	a6T+
X-Google-Smtp-Source: AGHT+IHQ5NdSGLojZA7dMjhuuUdc1i97Nj4cGDPr5lSu6ACmeBhGngoRRbRQCPZq1i3tgSAWJyaE7A==
X-Received: by 2002:a92:cda6:0:b0:3a7:8720:9ea4 with SMTP id e9e14a558f8ab-3c2d1aa33f3mr431929305ab.5.1735963648436;
        Fri, 03 Jan 2025 20:07:28 -0800 (PST)
Received: from arc.hsd1.nm.comcast.net ([2601:8c1:c100:2480:5fae:69c4:d149:aeba])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0de0545c8sm81407875ab.10.2025.01.03.20.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 20:07:27 -0800 (PST)
From: Brett Holman <bholman.devel@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Brett Holman <bholman.devel@gmail.com>
Subject: [PATCH] tests/fs/bcachefs: Use https for git clone
Date: Fri,  3 Jan 2025 21:05:38 -0700
Message-ID: <20250104040705.160266-2-bholman.devel@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250104040705.160266-1-bholman.devel@gmail.com>
References: <20250104040705.160266-1-bholman.devel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent access error when building bcachefs-tools.

Fixes: 0ba6fd2 ("bcachefs: build bcachefs-tools from git when running interactivally")

Signed-off-by: Brett Holman <bholman.devel@gmail.com>
---
 tests/fs/bcachefs/bcachefs-test-libs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fs/bcachefs/bcachefs-test-libs.sh b/tests/fs/bcachefs/bcachefs-test-libs.sh
index 1dd293e..5ff6013 100644
--- a/tests/fs/bcachefs/bcachefs-test-libs.sh
+++ b/tests/fs/bcachefs/bcachefs-test-libs.sh
@@ -7,7 +7,7 @@
 . $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/../../test-libs.sh
 
 if $ktest_interactive; then
-    require-git git://evilpiepirate.org/git/bcachefs-tools.git
+    require-git https://evilpiepirate.org/git/bcachefs-tools.git
     init_build_bcachefs_tools() {
 	cd $ktest_dir/tests/fs/bcachefs/bcachefs-tools
 	make -j PREFIX=/usr install
-- 
2.45.2

