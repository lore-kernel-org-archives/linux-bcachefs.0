Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC628181B84;
	Fri, 14 Jun 2024 16:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382672; cv=none; b=B95HkCLXp7nDjH8TU/rFl+M8AeSpvdgS0WmlDjY9Ucq8dXfuQX/w0BzhXVPjM438bAItCjflngMYkQaGZzuLxes+9lTfCAxo8fDC5QQVRSSG8KmcnoY7qKR71gygQMkeh2LPEYwxyQmpv8+fvVL4zPq0f5lLl/YaUssdrvwb4Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382672; c=relaxed/simple;
	bh=XWPS0m59zcRkwOd/f8gWqUJt6n5YUugq+iGhDd9PIFM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MumLMJjdveKVZJSMlxxuoJLPgeybW61Q9v0DWCcK2HdROzP+il/R4aHwE2SlrFVaL8AigJY2bFpgkJy0AG63UErNpcyEleDLwz5LBYYkS6dOfxnpv6+QjGWaxZtnmcCmfJpKroFgRkw6RUby6YUNEXloieXq5VKFehoOXqOsY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=JkDtGmuM; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="JkDtGmuM"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4W14XV0ct3z9scb;
	Fri, 14 Jun 2024 18:31:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1718382666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DGL89AmoQcHYVROUUZ1+SvMJTbjsjJS0Ai2n4W2+2kA=;
	b=JkDtGmuMJD3CP/sIDexXYLInxsIsCjbvYZEbxnNcRjspd/tM3cyP5NwfQ/DimMFL1CcaLf
	Jsv5Z1I8jipHhD9T4pCfVGHzCHTD15QNsZkuH3b4q6O9Omhk//8RITEoMriEbRH918ajCm
	8spDmiWulaqPIl8P6x6kTabl8heYDZXSf5NrOqKxTi5FgmdYTSCpeGSDObxf7TTImaYZSd
	nhqjWazN74csrVvgljcZ1oQrU0bLoRBEG+lwchADp7M9rxWLtfXS7NJGEqquCOnLAYa7Qj
	mRmrGt1G7OtgToAZBOxFvU7vmj4q56gORXQcbDqz4+ioiBo+RpnPB6BJOaQ25g==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Brian Foster <bfoster@redhat.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: gost.dev@samsung.com,
	linux-bcachefs@vger.kernel.org,
	willy@infradead.org,
	mcgrof@kernel.org,
	linux-kernel@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 0/2] improve buffered write performance with fgf order hint
Date: Fri, 14 Jun 2024 16:30:56 +0000
Message-ID: <20240614163058.74882-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes since v1:
- Avoid changing the indentation in the first patch.

Pankaj Raghav (2):
  bcachefs: use FGP_WRITEBEGIN instead of combining individual flags
  bcachefs: set fgf order hint before starting a buffered write

 fs/bcachefs/fs-io-buffered.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 03d44168cbd7fc57d5de56a3730427db758fc7f6
-- 
2.44.1

