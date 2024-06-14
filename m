Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B89F1946BB;
	Fri, 14 Jun 2024 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718362239; cv=none; b=tVfhruHm4rpOHVJ5hccmmDU5aEFAWngNGW4j5uo4YRpVKnM+MC9hGLREBqUrIZiLhkmmk3fSsg0M9Hn04QqF8IAb7cq7D0v2/l+LzWC6qv5WMQ19JGsv4H1G08g5WKF68xHDLA4bdg1hanlgJQQnRvD2jonpGf0M6+bcBV0oGPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718362239; c=relaxed/simple;
	bh=E/lew3JDwMC8d+k4FDJJ8pPGPzx0HirBmRoLmBy/h90=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qu9B5OMUGShSQwm1KXPuL3LZP8sMEwXRnDEbkomUF9awhqyr4DrIlLPUWnPKPnXlfjiqEaNu7sG3YCn+xcKQqrI6NDlNMWUHJIVwLAKDH5x+63WaEt/Rl7r5iAkXlhxurXpLvwR37vpsk9BsGf7TGfgRZRZvOiBzJv5uO36kDPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=qfcSAHMO; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="qfcSAHMO"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4W0wzY5326z9t8m;
	Fri, 14 Jun 2024 12:50:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718362233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5SNP4imkB97oiPLlbVvACXP9BTvzyjvW1dmm0W8uf4Y=;
	b=qfcSAHMOMt8sN0CNXFBRxYL1MUoeAxhbZBTgVRkQ8NvbxT69huezeFyyXndhsJVSv7dnB6
	bi8+Ow/3/alukftvtTMCYAEWObioIZ1emyCvJLHQly0cxwRKduA9NX1KIIVfhlQ+/ov+5b
	zc9ND6XvTjWOMHWIh8FzV9L3zq5cygxzd2krYblDl7IQYudL8P2rQx3Eypet5aaeo+O/RQ
	1qAhvcoLODhLcIM/R9zKQNEXKOL1TruFMrBqJiWFNCbyATJOpl3jwlrfQDYcdWjjY1wvcJ
	3tLvXO4PIcus4up1HVVyImjiJqFnUkIocKF1Fau+TaWp/o0hRS6GlZ7KClNyNQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 0/2] improve buffered write performance with fgf order hint
Date: Fri, 14 Jun 2024 10:50:29 +0000
Message-ID: <20240614105031.57032-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4W0wzY5326z9t8m

From: Pankaj Raghav <p.raghav@samsung.com>

Filesystems that support large folios can set the fgf order before
buffered write(see XFS iomap_write_begin()) that can provide as a hint
to page cache to allocate large folios, if possible.

The first patch is a minor cleanup.
The second patch sets fgf order before starting the buffered write.

I tested the performance on Samsung SSD 990 pro on a system with 64GB
RAM as follows:

$ bcachefs format -f /dev/nvme0n1;
$ mount -t bcachefs /dev/nvme0n1 /mnt
$ fio --name=bcachefs --filename=/mnt/test  --size=100G \
    --ioengine=io_uring --iodepth=16 --rw=write --bs=128k

I measured the BW(MB/s) across three runs on 6.10-rc3:
Before patches: 2730
After patches: 3430 (1.25x boost)

With -o no_data_io mount option:
Before patches: 2920
After patches: 4630 (1.5x boost)

I was not able to test the patches with ktest due to some issue with
debian(some broken package issue). Maybe Kent can run it in his CI while
I try to fix ktest locally?

Pankaj Raghav (2):
  bcachefs: use FGP_WRITEBEGIN instead of combining individual flags
  bcachefs: set fgf order hint before starting a buffered write

 fs/bcachefs/fs-io-buffered.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


base-commit: 03d44168cbd7fc57d5de56a3730427db758fc7f6
-- 
2.44.1

