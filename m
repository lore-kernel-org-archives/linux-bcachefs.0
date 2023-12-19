Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3CC1170D
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 04:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAWPOIl3"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-35d74cf427cso16401665ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Dec 2023 20:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702958870; x=1703563670; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=udIYRPrcW+z7SYAVuub5lgEodWWt7pu/61MZNmpaedY=;
        b=fAWPOIl3sZSr90Kh15FIY5AzVulNTWqLIQug+W/7LCpR8sPbBC3xoc2nKc8Ohhmq4O
         KmyY3XLq0TmCZRrUi76wBk1rNuIrq4R5qWS7wNFzRHqZnyCcCs/pSO8G4F4VUUg0s1bX
         GKgz48TZLR0J24tdUDlLIDu4fxbAsyRkkv1cLH2Bcx5SxJDXGklaG02+/9IO6IxvJKWo
         c9kvb2BZHfZqpgZC6emfx13uBBDMloZBo/w+zbLVYyhA1rqmuHHadG+i/oe/8v5B41TB
         7WEM+ZAcr04jzcpiQNHX9B/Ao/QVTUdcXf8zrJ92prKyAcS/O7RiDzDXs3zgOZAatXD+
         im8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702958870; x=1703563670;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=udIYRPrcW+z7SYAVuub5lgEodWWt7pu/61MZNmpaedY=;
        b=ebvgkqyrFRIElVFDAgbtZv3muPYBQMxIj0acY37JUF1T31lqNvBX5scHoE8fhhe9hJ
         L01B0SZWSF04ddZWvZHwhP9SBEzLm+E2YncNkdEY5g9iyoVQCurWDFwI8QZRhpeHPhil
         3FyFQoZkO8aBTNi0JTev0aMsUL5LWdmKaJsotIrFC9wm8Coy39o80M7o6d58++kOaV/X
         zTHacWouLbf52AJL27kX+NM3lgKA7H46uj3cPktexdJxzewZbbA4r8NeY3MG4tm5c7YF
         /qOLMkvGig5qsPbifdt6bwye1UVO0ovb+szrkO4Dk0Yjbmuv2mUQd2OU628yaQHQ0TKI
         wyyA==
X-Gm-Message-State: AOJu0YwukZn7f8jc64mOnctqRuLQBl3q76BfcepiiDABUY6XecwQmto/
	JY8fM0Xs7+2GdNhfxBoMMqt7Eu1+TNo=
X-Google-Smtp-Source: AGHT+IEEXRX1H6N1R4Z5QdKB8Wybia7v8yIHV6r+SBYALKo0AiW6zzzuQw1btSoTQBL3no5wW58rIQ==
X-Received: by 2002:a05:6e02:2161:b0:35d:66f5:946b with SMTP id s1-20020a056e02216100b0035d66f5946bmr20616612ilv.21.1702958870330;
        Mon, 18 Dec 2023 20:07:50 -0800 (PST)
Received: from fedora (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id g7-20020a056e02130700b0035faecac7e5sm1172011ilr.35.2023.12.18.20.07.49
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 20:07:49 -0800 (PST)
Date: Mon, 18 Dec 2023 21:07:47 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: linux-bcachefs@vger.kernel.org
Subject: bcachefs CLI: question on use of mlockall()
Message-ID: <20231219040747.GB251273@fedora>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The mlockall(MCL_FUTURE) call at the beginning of the bcachefs CLI
tool seems problematic in some cases. When running commands as an
unprivileged user with the default mlock limit (8 MiB), it can cause
ENOMEM failures, for example:

$ ulimit -l
8192
$ fallocate -l $((1024 ** 3)) test-image
$ bcachefs format test-image
...
error opening test-img: ENOMEM_fs_other_alloc


While this can be worked around by running the bcachefs utility as
root, or by raising the default limit, I think commands like this
should work for unprivileged users under a common default configuration.

I wonder if the mlockall() can be targeted to the scenarios where it's
really needed, instead of applying to every bcachefs command? Some
ideas on how to target it: 
- only call it if running as root
- check that getrlimit(RLIMIT_MEMLOCK, ...) is at a "high enough" value
first
- or, only call it for subcommands that actually need it

Any thoughts / comments? Would a better, or complementary approach, be
to reduce the amount of memory mapped for operations like 'format'?

Thanks!

- Thomas Bertschinger
