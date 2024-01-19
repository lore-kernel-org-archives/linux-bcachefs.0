Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81F1DFCB
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 21:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705698899; cv=none; b=p5GbiSizTUmzGWCD+2JKl1DWJTT72rzLbYAK5G+If+S5iGp99C8CwNI97ILl4t7QKIsvL/LpXspov/TBJ3fIEmSdSvYFY1exi85+I8Xx4PSjWOpG7WoVV58+YoHYJfspI7Q432scVzCogYoMGkmiIMcg3OWx5NJjQ8sAM+Cago8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705698899; c=relaxed/simple;
	bh=F9F2GNKmjLUbux+84Pb89lxHGN+eZi/eIvcnBt3MVnw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NVH5dW5b+yVexiYPUYPuT+XOkYVEYwjsxWByV6r+m2/eFVOre11ua83FyXOnshH8yuy9Fx7c78fY+SHlkmn0KESSv6koxl1V+YIogWtyZGcR0HA51mCcKUd0MPxGhoS3Q1k4YIPw4zmzUOoAI9xEdp602Kvkzlh7Yv936u6u7VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Npu+jXgd; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Npu+jXgd"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d5db9eb0e7so8387595ad.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 13:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705698896; x=1706303696; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1jO5gTxlFcZqy3fTlQWHVnYXrLv/qAX0Mnxwu0zISok=;
        b=Npu+jXgdh1m5j24CHVteSOvlcRn7MaK7MqofDUJIix+GgSLeP6O6k2Tdb1ohzCK4ZC
         nPRTHJhdhxwbJ9dl1oZ2Gn5aGuhcWMSgrFQvEMjunPub5aB9ZlNaznsFBMdObUs82kso
         +z1973MPe3ZAWGYSKC29TH0D+kevL0dTJDUMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705698896; x=1706303696;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1jO5gTxlFcZqy3fTlQWHVnYXrLv/qAX0Mnxwu0zISok=;
        b=wtKmQWyYUQveWNQv102szUfQnS2vMlRwqA76otI6qzDJSQ9ITj5xVcNZqERvcwrAx3
         rGI78qrPJ3wqWLMd/y2ySwzLNA06ufEDQfneIvf+LCBM3zBTHqN2MKwf9xRogHTRD34g
         bPxc90BIqE1JvIBnMu/+5suTTcbeU4d/BJB0lwpHKrBz/ZgK+I+mC2NXVhC4LKcqXnFx
         GooNj0fAM8GYIvv3Q3moUr6V4a+egrVd16wOO2C14s69cWd65jOeBwZPeCjuJCHDpYBm
         feNyMNqNumYl+P/IWlyVwm5bQS+fyniXhcd144gktnhzypBuhMbrnIcYDXL1IEn3bmiD
         v/5w==
X-Gm-Message-State: AOJu0YyfIqoESCBFYt8JKSqR2AceCGTmZbjOovT2K/6Ycm3lI3S1Im/R
	Sgk9jfGItbjkir/aUOgYArf90WqrXimfeZJSLr/XYAMVOR52bGhd9+H/Nx+8jg==
X-Google-Smtp-Source: AGHT+IHteMrsjbxz/XOxufy7SLo0IQwvOQ84Qlzbhc16uTdBfRGUnXUD7sidx0J4g0mfmpxi2kRqHg==
X-Received: by 2002:a17:902:db05:b0:1d7:20a4:4a91 with SMTP id m5-20020a170902db0500b001d720a44a91mr502945plx.109.1705698896431;
        Fri, 19 Jan 2024 13:14:56 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id kh6-20020a170903064600b001d5e1353693sm3433530plb.266.2024.01.19.13.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jan 2024 13:14:55 -0800 (PST)
Date: Fri, 19 Jan 2024 13:14:55 -0800
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [GIT PULL] strlcpy removal for v6.8-rc1
Message-ID: <202401191311.B6AA79D@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull this strlcpy removal for v6.8-rc1. As promised, it is the
"part 2" of the hardening tree, late in -rc1 now that all the other trees
with strlcpy() removals have landed. One new user appeared (in bcachefs)
but was a trivial refactor. The kernel is now free of the strlcpy() API!

Thanks!

-Kees

The following changes since commit b0d326da462e20285236e11e4cbc32085de9f363:

  Merge tag 'sched-urgent-2024-01-18' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2024-01-18 11:57:33 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/strlcpy-removal-v6.8-rc1

for you to fetch changes up to d26270061ae66b915138af7cd73ca6f8b85e6b44:

  string: Remove strlcpy() (2024-01-19 11:59:11 -0800)

----------------------------------------------------------------
strlcpy removal for v6.8-rc1

- Remove of the final (very recent) user of strlcpy() (in bcachefs).

- Remove the strlcpy() API. Long live strscpy().

----------------------------------------------------------------
Kees Cook (2):
      bcachefs: Replace strlcpy() with strscpy()
      string: Remove strlcpy()

 fs/bcachefs/super.c                           |  4 +--
 include/linux/fortify-string.h                | 51 ---------------------------
 include/linux/string.h                        |  3 --
 lib/nlattr.c                                  |  2 +-
 lib/string.c                                  | 15 --------
 lib/test_fortify/write_overflow-strlcpy-src.c |  5 ---
 lib/test_fortify/write_overflow-strlcpy.c     |  5 ---
 7 files changed, 3 insertions(+), 82 deletions(-)
 delete mode 100644 lib/test_fortify/write_overflow-strlcpy-src.c
 delete mode 100644 lib/test_fortify/write_overflow-strlcpy.c

-- 
Kees Cook
