Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJ4vjlbc"
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739581724
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 00:10:55 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-50c05ea5805so2067585e87.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 08 Dec 2023 00:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702023053; x=1702627853; darn=vger.kernel.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cksrgT3wpcn3EfnPEwLSUNqiGsEIz2fuyhXk6kBnVoM=;
        b=PJ4vjlbckUJFizo0+EhsSYEFTP6GcVdpAAIUjyLhrD9RQKLwl4JYI7cc6WwLfn/ct9
         OHbZzwrOCkPjG90ZTyMSg410ifXpmb4Ze8r0mABB2Kq1TPwi93cbM0rGcaW+sIB6BDz1
         MUjSYvXtEfJszQDHdrw0S6hQfC28ezqkLKgVxmxBddB6TJnY1k1g+SwaCESQHyUuP1E1
         0Nmmt6LFYKUMgKOkRGy63Es2QIBocMOcoOh5PiW9K/8hrdm6p6O0vyXwDlo1cj3Ef+Dv
         5sQFvzx0EOXwNVixqYjCTNYqobt8L8W/hgzimO3+bknsyBI4ObvXCcVr1XoOngSvKnHS
         YaqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023053; x=1702627853;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cksrgT3wpcn3EfnPEwLSUNqiGsEIz2fuyhXk6kBnVoM=;
        b=kWgIKF7E0SnehzsBW0xPxoCpJ/3HO8prQ3J8zQsp7nLp943agth2Hz/U1wDqZ+EVNG
         2vCerehLju0gWP+c6L/8VXAOayS6ooZg/N6rtLM9x48X9YU2H/C8hOlIvm53Qct5fJSM
         taD3roMfvy+pBALChVOhEHXLrKqYC9H3InqkbUwUGMncyNcX/FphPFYjXsvkuYTUaSMn
         l5bRQ4OYMsda+S50HJsnnZYuVxYQglmk+MeruB1KgmUFLkWVfWBl+b6xsVQLNZcPyCxr
         qjVky4/NtTfjX/AVMrIZ8FVdGDiS7KB/nn2M+2pwx2OOiOdxVWK4htZgPQqaQObZRQ0o
         wGSg==
X-Gm-Message-State: AOJu0YwYf/m9BEIXvOsy8665XZIPgmMHFdUUvK5N2nFLlE8M7lsd4ouw
	F9zTuHerrYjQUBQXwyjhrhXC4ynBl/E=
X-Google-Smtp-Source: AGHT+IG9+sSqL2kBqk7+ZkXSPI3tzc72gViuwkuZBB4R7zUyKt/hR1ZRoGVHk2Bnzl/cMN3l+XrpIA==
X-Received: by 2002:a05:6512:32b7:b0:50b:efdf:9e96 with SMTP id q23-20020a05651232b700b0050befdf9e96mr2369452lfe.25.1702023053224;
        Fri, 08 Dec 2023 00:10:53 -0800 (PST)
Received: from neocoros (cable-jkl-54f97d-163.dhcp.inet.fi. [84.249.125.163])
        by smtp.gmail.com with ESMTPSA id f18-20020a0565123b1200b0050bf52949a9sm140791lfv.70.2023.12.08.00.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 00:10:52 -0800 (PST)
Date: Fri, 8 Dec 2023 10:10:52 +0200 (EET)
From: Tero Roponen <tero.roponen@gmail.com>
To: kent.overstreet@linux.dev
cc: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: make 'all' the default Makefile goal
Message-ID: <6f10341f-a98c-67f4-e6f0-0b9284f9c35b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

"fsck/bcachefsck_all:" coming before "all:" in the Makefile
causes the bcachefs binary not being built by default. Fix
this by explicitly setting the .DEFAULT_GOAL=all.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index a7926f4..177ee45 100644
--- a/Makefile
+++ b/Makefile
@@ -4,6 +4,7 @@ PREFIX?=/usr/local
 PKG_CONFIG?=pkg-config
 INSTALL=install
 LN=ln
+.DEFAULT_GOAL=all
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
-- 
2.43.0

