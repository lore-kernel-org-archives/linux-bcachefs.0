Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E771E1E1D;
	Mon, 16 Jun 2025 19:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750103483; cv=none; b=lcj2ZeRGtgKl81YxAuanICDwlxHc0Fp3OVHpJnDOmmtIC83TtyYWZVnljI3gjecAGW4mREUBwTFfwKncVclIyDZSXG23/q0iermQWtbVC5zOhbxxFdlczZNUyqAXkZJZwqYpyM2ebB/Q+R636nYEkfJC49cFqVOAgCg88bpJQi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750103483; c=relaxed/simple;
	bh=IFXcxDM9pgKU0OocNcFji54k0TH9pV4m21cMlj4+kcw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qtP51lAAbN3s4YePGgiMpA/pND2qqyLujc/x42CtC5ZhfQ7T8JsogRf99B+RkKNaoWdi13LRSxgOLhkNID77WNWq5MR2YAi4ItuWtQbJq8e/n0YHlD5AhZIm43mqQfHQXIvMiStiRBSnA/nd4DPlahH8pbvmZc0lj8wQs+HYlT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bAQ5/FJy; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAQ5/FJy"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so4523765a12.2;
        Mon, 16 Jun 2025 12:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750103481; x=1750708281; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1kZ2DRrGUR7QsNSeLGbTWtBPiubGAHbShPimdlaNxWI=;
        b=bAQ5/FJyq3bZ6oO/ed7q+w1r3lrf5yXiZCPvnC+ciO+2HDkiFZ3CicvaqRyVzAaaaH
         0o9zUFmI9SWx/Be4WgGfYrLumN0jT7YJMvruMIDVP+FUgR3uEvQJs5cizxnTHtxWyn6t
         2jz3LS5ONS/gNti2AMRLXv+lK8et290/mKxRfzkS2r92hapBe4GvblUbiWrYl2n8DTHb
         AqK6lDs/GndPx43+QxdygrhJtVcjob7CjRMRcn+9l6bNsviGYhOiQzlgktrpth8PDQJJ
         msl9k9kh+FFFPxANisvvIy5QMcmjR361rkP4T9xtLtdvpaxz2/mRVwUbAWLTO9MtBaWg
         FBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750103481; x=1750708281;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kZ2DRrGUR7QsNSeLGbTWtBPiubGAHbShPimdlaNxWI=;
        b=pr3IXNX+JxY2x5rl04EbEkVBVzNwNjuiEQJ6k70s8Vyhig1/Szac3CIJ00q3sYnFwK
         P+hIFxQycQeaGEHTn2x5WKx1kHXUBLEkzFOmpBS9Cl56JDjQpJGEA7Gnbbka/KK2ya/z
         YxKH4TJO6Cnqx3BsKznlB8tPyCz58yU9JRo/ffkUJsccC/PhGmgQgb76VpSwWNcQzJG8
         0XmBLv6vGp7UdkcqD3TGVkxXpWEqa1mQqI09vAIN9160MhqTJ3e/W7fyuBTVXRK44XWv
         djaj8MaCgbxDF5/NaWmswQSocxeSP8LhB8jntYxbmcv2CM5OT2ediFkOqq4rlUxlQBFg
         t54g==
X-Forwarded-Encrypted: i=1; AJvYcCUShrKpZt+aBp5gTDliIE2X0wOF92vBv7/6HZsAW3bnMBsEpU3mHNtmyCLUSh2kn/UWhuR5Y8YxUds=@vger.kernel.org, AJvYcCXrg9+U9Z7p+RdAJBNay84y/5CP7CzwszFR8w0gT9OhsILXhyw71Ab3ywV5BkNV14uVfwXDMLlMMH+btTEa@vger.kernel.org
X-Gm-Message-State: AOJu0YxQLJ6Cu3p/r8y+7MY9/reYVfV5iUN4yA6fGHGj+3QS6Hh481Ap
	ijd08KvbEqJOVwRikuzE5ySCnzdTPfMqP/tAbKwpUAagM1OiTZAKyIfC+vbBaw==
X-Gm-Gg: ASbGnculNXiizhe6rVSbNm57TwdVOEB+VIe9eNeclPg4UPO0EE7sYs5vyi6zpW2OwGs
	pExcXx74VWQxZlB/OUg8lzw0btKMguVQfHe5WtKBu8XKlwlrp/P3cjDEbS86it/ZHt+CE8ek1hW
	NyyW+dtdPB/9CYanHYRHxckIZlJ+4OTGVLY6LrufN6t8du0AFYFqpSy67hTw3/nuNqQnr4eFGWA
	pkUqx4LVGy7OWxGXkJvKtYiI/XH4i4o5XZf7VA0BPeycG9ogi0l4a/n9/f6fZyUs3DpoXsyZwWR
	TtWYoEnXCsay7yyc7J8UT8qI0dRgO2j7T/cRDt+1TIBEIQCI+XgjWgvEmH781Aj09w==
X-Google-Smtp-Source: AGHT+IF8qBNhRy32BR7c1mQ/1+zzbHKQNi8eo5Kfz6Cmd8PRQK5CNCK6AcspJ9Wblm2fcbC4M36Etw==
X-Received: by 2002:a17:90b:2d47:b0:312:db8f:9a09 with SMTP id 98e67ed59e1d1-313f1c380f7mr20083938a91.14.1750103481075;
        Mon, 16 Jun 2025 12:51:21 -0700 (PDT)
Received: from itsmeut ([103.215.237.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b59ed4sm9078880a91.39.2025.06.16.12.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 12:51:20 -0700 (PDT)
Date: Tue, 17 Jun 2025 01:21:16 +0530
From: Utkarsh Singh <utkarsh.singh.em@gmail.com>
To: linux-bcachefs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: kent.overstreet@linux.dev, corbet@lwn.net
Subject: [PATCH] docs: bcachefs: fix spelling of 'hierarchy' in idle_work.rst
Message-ID: <aFB1tGW3Iwf0isZ3@itsmeut>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From fe1a12fe8f5342e576b37c51aae101b52fc5f528 Mon Sep 17 00:00:00 2001
From: Utkarsh Singh <utkarsh.singh.em@gmail.com>
Date: Tue, 17 Jun 2025 01:10:56 +0530
Subject: [PATCH] [PATCH] docs: bcachefs: fix spelling of 'hierarchy' in
 idle_work.rst

Signed-off-by: Utkarsh Singh <utkarsh.singh.em@gmail.com>
---
 Documentation/filesystems/bcachefs/future/idle_work.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd..8421b2ab65a2 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want to be dribbling out
 background work while the system should be idle.
 
 The complicating factor is that there are a number of background tasks, which
-form a heirarchy (or a digraph, depending on how you divide it up) - one
+form a hierarchy or a digraph, depending on how you divide it up) - one
 background task may generate work for another.
 
-Thus proper idle detection needs to model this heirarchy.
+Thus proper idle detection needs to model this hierarchy.
 
 - Foreground writes
 - Page cache writeback
@@ -51,7 +51,7 @@ IDLE REGIME
 When the system becomes idle, we should start flushing our pending work
 quicker so the system can go to sleep.
 
-Note that the definition of "idle" depends on where in the heirarchy a task
+Note that the definition of "idle" depends on where in the hierarchy a task
 is - a task should start flushing work more quickly when the task above it has
 stopped generating new work.
 
-- 
2.34.1

