Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42E636134
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351383; cv=none; b=tui62uNtsFnehaBtmH2NA27pMULk7U05QfFKIQvrv+W9NqisfP6c4EUAtHPMXN8+jGspnmY1pDWp74xlIc+HKCDyzxm7hcZjiDh+aLOd8BIYB5lkGZvHDhMVyBtqJwBvUnf0SHcp1zLyqcLZbeWBnAn5oPyVt1pmS88XRCBkan0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351383; c=relaxed/simple;
	bh=a6NkhsbuTd0Ckce4siU01oMpGCvhEnawGw63ZRgmQK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J4Bg6ftBVG6py8UlrdJgcUd2XGqq7vZMy8q7oxGHWDt+9Xrqus0LU5tRP4z3wC+hV5IKwuqn6Tj5SPuJi7nbkanKQcO5SHtu0AA8jCYnhTSunT7Ie5xcGF738cp1pjxOz64VIdOmkynywiAUilOJe+W1RBofrPSal6JcEk5t8dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=Fk8C0OB2; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="Fk8C0OB2"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dba177c596so22312675ad.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708351380; x=1708956180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DqCHtKsy1ZCi0E6gLS8MoF3CvoeAmYhNlzNG347hxGc=;
        b=Fk8C0OB2shrrRpswYChsPf5/Ud2JIif4B8n91prhj7/Qnv6dr/PkEUWoYZ8w9usgiE
         jYO7PuUPdxV1Znk0iWKJmsAWAhZRWnRVyrrq4wPXsQxgMZkM/xDbHKjbq0NOcif/SRx4
         FgPc9XTPc+kLZCskrC574qA3TtQgKtbWSV92yp/j23PgF2VicO9BbzeSzUJSUEDWpi/s
         MdEhbFBYNL18yQ9DRqXJ/vJIrxRXKzTRAYdPQdUe0blote/JBOZKwG297GXPFGKrwASZ
         aeaj6sQZDpJ3q59sGzKKUFPWxn3qxspoyfomWD0OvVWpF4DY0mofEbEDITi2CEAWLcD9
         64XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708351380; x=1708956180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DqCHtKsy1ZCi0E6gLS8MoF3CvoeAmYhNlzNG347hxGc=;
        b=QKNugfH6RnPJyTjwwGApXyvkC4pW/1EDkmkKjwtt3UsHlsfwkaJgUa7vtDBMJ4jNrr
         2VkEov/trdh5RMseLz0GpisSEGgC9LnJuujpT/KwNAuZ7pgKJVrrXohKvMhYILGSKzeB
         xI8fuQHhZVCdwSx6/IPZV1DK0j0WG3384T2i46R4xbnuUlBAUtzsXE3aPTbctilidg66
         +7W2+iSTOeCfTk6Huubz8C0GS/o1cd4WNLTw+2eDPE9Dv/wAxJ/VFvbGK/10p38mDtSJ
         P4E9/DeLqCEnR+ZDjeNP6WxPxVVbs9WMhRKjBMNc9FGtzAm9vxFClXlcZO9IrCWv28Kd
         Wxcg==
X-Gm-Message-State: AOJu0YyZAieInpIW+PMSWq3lxlXrNOmfLevtnEspjOVcEQM9RosBK8yW
	LLclyZwHIreI/SEsd9VmYm8I7LcLsIq6P2RPFaScThDdsgbSC1sgxu3PTGldbq8MkI4OboRnCxP
	u
X-Google-Smtp-Source: AGHT+IFVPX+dRa862uuOHvbvqdYO3jJ9YZN/KC8H7SAmNtK33XWGaB3VVmBkn3RRQGKnILjndDNIdA==
X-Received: by 2002:a17:902:ea0e:b0:1db:f15c:85c0 with SMTP id s14-20020a170902ea0e00b001dbf15c85c0mr3757312plg.33.1708351380608;
        Mon, 19 Feb 2024 06:03:00 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id kj4-20020a17090306c400b001d6f29c12f7sm4456722plb.135.2024.02.19.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:03:00 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 0/3] tracepoint improvements
Date: Tue, 20 Feb 2024 03:01:55 +1300
Message-ID: <20240219140230.897597-1-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While trying to debug copygc I made a few changes and improve naming consistency.

Daniel Hill (3):
  bcachefs: improve move_extent tracepoints
  bcachefs: improve evacuate_bucket tracepoints
  bcachefs: improve copygc tracepoints

 fs/bcachefs/data_update.c | 70 +++++++++++++++++++++++------
 fs/bcachefs/move.c        | 34 ++++++++++++---
 fs/bcachefs/movinggc.c    | 11 +++--
 fs/bcachefs/trace.h       | 92 +++++++++++++++++++++++++++++----------
 4 files changed, 163 insertions(+), 44 deletions(-)

-- 
2.43.0

