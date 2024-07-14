Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ADC7492
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987379; cv=none; b=ACeXl9ypNOWaCy3yvSw8jcKW/eM5JFn7CrNGbJNe9EbIFfZEWVzgXu5gksFEcMeFYXA6fsYypOYrF59xihbKArxpoUB2drlTjoe9PmPOQ8WaBbHqFFrPw4rmGeeYeG/K+DfS/L8kVvsxH+vgn9dRbOmW1HzvA6eU90BvVjQwUHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987379; c=relaxed/simple;
	bh=SC7nK45HhUfgY/eumJRXsSuorecmoyx3CgVzshUYuqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TGGKbddPvmVk2IPnYZWCztAbQwkxUx+91jS5Uiy9Xl33DBKslaL4hBd5thEHCE0s1MxRGxkOwbveeI+Elc47a9HTULj1MZPJymFElJLZeNdoJAV+dnDrSU9oY5viq6trE7LCs/yApr0M6YC6gC/Rzuc48BeEKONqtirJmd90oC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ML3K9wTg; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ML3K9wTg"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7f3c5af0a04so176508439f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987377; x=1721592177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I3kctNEFXg32NnAx8p7Z3CBBcRc6ROFzBCtqdFJBzhY=;
        b=ML3K9wTgj6xDq9MFP1zBVJSVXCmSe1rG9CW/mBnzUTrHRsr37hPg1er7jEIndSUckk
         ZFc1LkcyFdYLBHXR6Da+buPYzqsnViHvDzQSbZdJvgs3P+duudSto7jpsu7lzFMtZuCW
         421BEysf6+l2J7KKI1EU0g1cTby7luJm+d7Iw+aqXrBCiQXTFM0Efqv7SAXSXkirPtBY
         ZVKuhb4R/Q5VOfKd0jlaa4mp5ATfcAEeCGSb+3/vgrT7/lr9FXc9l2kr0x4LXkY+7cV6
         SAS0kfJqWGAfFGYvYaGoBj49nTpKGwLhnntB6SN5bo2JoAGqXgNhzKhzgmNEZJUJSOMT
         aVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987377; x=1721592177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3kctNEFXg32NnAx8p7Z3CBBcRc6ROFzBCtqdFJBzhY=;
        b=sBQp8uWV+AoiKlwKFZniQOK0kK9EltNNNF2RazlPQFk+0bUr5y/VaFmu0ertCd3TDh
         AYTUCBn/CpVaxekmuAPylmxIRjAtfLRQz8OSFIbQoti4L0726PNmWMh4eXNsKeWJt7Qb
         zCxUdYkzgwG+cwOen0CKyh2tm6L7r3JK499Aw/mESybfNetd2fL8egsg8fhr3OW+fx0l
         Uwuz4k/owdtScyITdBYZfrR8S/09T4w/xY5oqeJVCki+B17RTMwTx+2GtTu+XfUF8l7K
         Mrg90eHU3XImaJ8YPYf47lmugMBqtWvmXag/ok7aCRFDdp3LlAbPhHDvW1RxcsMxzr9o
         nhdA==
X-Forwarded-Encrypted: i=1; AJvYcCWmIT9H4InmrJevnDOdICYMfcvUziwLBFh6vfxJgg5X8XUzTEalcpqKQFleAJ2Sfat7J2dhsOLwL/kX55cyZ5jGYG1um0P9ivBmhJOyVvM=
X-Gm-Message-State: AOJu0YxoKgc7Z9NSUSQl59VWxSQDRUpsp99LXLCew58XLSMWMp6ORz0U
	p3RcDfvmE5JIwGiT1+5O/p0K+4CCzO8KYoeSWjJM22nOi/mexuoJF/5Z9g==
X-Google-Smtp-Source: AGHT+IF3N3Ai4KUFlGjhCYjAF+2Z3VgbQ+AUGS0n8rGpQpwRmoOQeOGOOUit454yBpRbD94gKOuxEA==
X-Received: by 2002:a5e:8d18:0:b0:7fa:4e03:abcd with SMTP id ca18e2360f4ac-80003ca8ec4mr1756904539f.14.1720987377288;
        Sun, 14 Jul 2024 13:02:57 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:02:56 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 0/5] new debug command
Date: Sun, 14 Jul 2024 14:02:21 -0600
Message-ID: <20240714200226.746471-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces a new command, "debug", to the bcachefs tool.

Changes in v2:
- minor fixups
- added "field+=value" to increment a field's value, in addition to
  "field=value"

Thomas Bertschinger (5):
  include debuginfo in bcachefs binary by default
  update minimum Rust version to 1.74.0
  introduce "list_bkeys" command
  introduce "debug" command and "dump" subcommand
  introduce new "debug update" command

 Cargo.lock                       | 374 ++++++++++++++++++++++---------
 Cargo.toml                       |   9 +-
 c_src/bcachefs.c                 |   4 +-
 c_src/cmd_debug.c                | 145 ++++++++++++
 c_src/cmds.h                     |  18 ++
 src/bcachefs.rs                  |   5 +-
 src/commands/debug/bkey_types.rs | 340 ++++++++++++++++++++++++++++
 src/commands/debug/mod.rs        | 173 ++++++++++++++
 src/commands/debug/parser.rs     | 105 +++++++++
 src/commands/mod.rs              |   3 +
 10 files changed, 1061 insertions(+), 115 deletions(-)
 create mode 100644 c_src/cmd_debug.c
 create mode 100644 src/commands/debug/bkey_types.rs
 create mode 100644 src/commands/debug/mod.rs
 create mode 100644 src/commands/debug/parser.rs

--
2.45.2

