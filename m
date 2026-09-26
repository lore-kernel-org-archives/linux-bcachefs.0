Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B134250E
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413445; cv=none; b=GOp4lZKYBdgSSiVyuj2cjaafZ/NkTO4ZVBz4M3MKl59VFFOJqlvD2Ava5XVwv1zAf84fdeJG7G0IjlkiZ9gFubDESvZq/vENiyVKIWWUH+nE7Fnj16LpcGksGIepajVj0yF4iHPCPT3dAH5x2hSKRWEu4RDmuOcLIL9kM5rBKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413445; c=relaxed/simple;
	bh=1yKzm0AoVq6C3y/U/RK5ujphqXygePCEXzswf3EDY94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YlJStERlwoEFKN8chj6i6orK5c65STX7LTKT+bAQp5/s/uDhMvxCOai8BL0Yrd8F/MSnUp7jJZR0Q7SOFXBWaKT/bMNOMKavHvhK4CkwOtCfHj5nbU7vQCOznxuRp0azcbedHoyl//B3c4yEG9GPye1C2j4s+sHYATXpE97E/UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hitShqki; arc=none smtp.client-ip=74.125.229.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hitShqki"
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-1438f55921fso537927c88.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Sep 2026 02:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790413443; x=1791018243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+tqWqLo9zNz6Iw1mOO/qWw9uzH6TjWX0ev34no/fOaE=;
        b=hitShqkiFyoEjXunw7tFgPwnz6UuOpXjhMIaIY3dMBTVIOzlbWbHJILRELYaodFIQp
         11/bfQHjHU80W97ENVA5wNEzp2vZklZ+iGM9YMckENkM0rCOvFRcLD4B64DQ3fCaFe0m
         Vqt7CbuhHl/7dBAjcZ4G2BvANC8rv81/Hma5xaFk2t1LfRqRznB3hhb+B1DBzOH+Jfj5
         zMQwTdNPrZr2tI/XYpU+r3wJnzjZYq0tW9hqRtqlTr1Xy4a4FoB3PEJueySp84myvNl9
         p2T28p2sNGEUOrXnMUEkvFTO1x33TiAJyqGyv6zKqiP7xTTPUOC/o4qcu9xmAsY9X6U1
         kYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790413443; x=1791018243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tqWqLo9zNz6Iw1mOO/qWw9uzH6TjWX0ev34no/fOaE=;
        b=iLdlL3igN/3r1Q6khiQdSqVZNpnXss55nU/HUX5+yjeNGk6ykmmhin9reluwIXeVaq
         Upi4fsZO15prD18Ho176jOi6O5tJI1qS3UkUswhiJ5XJI0cjiF3U4LP2rRJ0DS0q1rIq
         eCZuSDFjswVl0XX1mQytr5BQfwEdvO18DWjN0RRYLyv7uwYsU5R3KG/3x/kx37kHhMnq
         ggMwpstkeWZWDxZa3nY0rVeuh8baODOFfmTzBcaYnABoEKkXUmE6jZjcSxi/+vSLSo/3
         PRyxsNSP4G8oNpPTngGPfcjfyHKWAGmwUZ0hPDQJEbmoKpw3tnTOTLi1VaOS5eRXwCMW
         35XA==
X-Gm-Message-State: AFuF++llxlZan2jf+uPuVZcVzNJ1514a3OFr5baGAYElLahqd7HN0NJA
	drU5GVcIS2r37fR4gemHmmoj1reHjvgABD+R/f/kCfeYWZRuk/oGLbvMoSyxvxIj7BBjcsIh
X-Gm-Gg: AYBFou3lrpIabbaYuHEDLmq6qKe1Jkz0jAvtAKltII0DR/U13cftqjYpuzJERzZGeRV
	kzTueiXamFARkrQzX63SNgz4PHjaDXlAGuBthF/I4q3GEIYZMGleAVPvJFkBguxAwxZZlMhcW19
	WcZjRb3pVT6yMHzEywbIJ80k/y3l7laKti561i8gnhfZN1nTsUcKfXEl4/BqJe87k8Nm1+1xTKH
	P887bndmiCFKhAi2XCejYkqwNGKKKmsU0/X8mJiVSdQOidpp/LIn1rw9PfLLuR3PdskkFCMhk2A
	/rSNH17o+7BJStkkOcLH/8nBpNJVwCMlzd8KYkU6Xlgu/1uG+Yysf6yhRU3DwYJHMvq6lw5/W3O
	Irj3Tk6JcxfDjlJJyUebxxbQ5tsjfFgHktIoPo9WOno4khnfIIhk+gqtQP9Npbn8e59gAmZXkAG
	LroQOpeekEMyeqN0/o4ezxhLJGxW5O7Rosj15YfYK443dJmpFZoqtBMDBJqENWCOXhdCRPA9/SF
	1IQaEjno734C5wRp8FIZS7yrWR2jHv3oYVLQdek+F75zjF/OtgrlH0cRuvzwhRexNa1XqXEH96Q
	sx3yiVXSI+BLS5UeJWRq5cwilVuw5bxwD4Oxhvd6r7wNr7aEPBVd63QeRogayj7uXxe3ug==
X-Received: by 2002:a05:701b:4284:10b0:144:e535:3ef6 with SMTP id a92af1059eb24-146d0b58524mr2476704c88.41.1790413442583;
        Sat, 26 Sep 2026 02:04:02 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145aa0cb7bcsm10004898c88.2.2026.09.26.02.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 02:04:01 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev
Subject: [RFC PATCH 0/1] bcachefs: make btree bitmap GC crash safe
Date: Sat, 26 Sep 2026 17:03:57 +0800
Message-ID: <20260926090358.603911-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kent,

Bitmap GC can replace the member bitmap while an interior update has
changed the in-memory topology but has not made its new nodes and parent
pointer durable. A crash can then leave old nodes reachable but absent
from the bitmap.

I will send the ktest patch separately in this thread; it applies to
ktest master. The test evacuates a member and holds btree-node and
journal writes on both devices with dm-delay. It runs bitmap GC while
interior updates are in flight, then checks offline crash copies taken
before and after the held writes are released. A no-GC case checks a
crash copy taken under the same I/O delay.

I reran the three cases on bcachefs-tools testing at a3e92ebc6d6f,
using a 7.3.0-rc2 VM kernel and separately built debug/test-hook modules.
The no-GC case held 71 interior updates and passed offline fsck. The
unfixed GC case also held 71 updates; GC published early and both crash
copies failed fsck, with 57 bitmap errors. With the fix, GC waited for
72 held updates, then both copies passed fsck without bitmap errors.

The fix drains pending interior updates, rechecks and scans under
gc.lock, then flushes the journal before publishing the new bitmap.
Earlier focused runs also exercised the drain/recheck retry, read-only
transition and journal-error paths. The source patch is based on
bcachefs-tools testing at a3e92ebc6d6f; the ktest patch is based on
ktest master at 1fa3232f27cd and applies to the newer master checked
before sending. The focused tests are:

  btree_bitmap_gc_crash
  btree_bitmap_gc_crash_no_gc

I have two open performance/liveness questions. The pre-scan drain waits
for the interior-update list to become empty, so a sustained overlapping
stream may delay this pass indefinitely. The gc.lock writer also spans
the full bitmap walk, including disk reads and any superblock repair
writes, and can delay interior updates. The VM results above establish
crash behaviour on a small tree; they do not measure these costs on a
large filesystem. I would welcome guidance on that trade-off.

Matthias
