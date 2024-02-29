Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555F715B1
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 06:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188225; cv=none; b=XMhwNIC99bsZ/rm1DFkBskDamDexXrN2Dt8HM627MjYNIJvXsCcgJGZau1ZIyYpIHjys9a1Y0csIQm3g59b8W1kAds1C6gYgB+zvpqGEfaFHYa/9PRqCmG1uCGhrvpK4hJ5wMz6JTrMoONm4v+NXmhZ3NNDTXl0U8s87K+1YEV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188225; c=relaxed/simple;
	bh=4zL9imxi3/7SfnSRHTTLFP/ufPAV8u3BI2Gd9wj+KMk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rIuuFOgBAYsq6egRAXwsFh/zq4XPotA9QAvYPO3NoO6wTgASeBwUB+hZRdO3jt6WxbuurIvw6evC5V/kkWEfz5R3iIxNdmnWMUR/waOuaN+M9omEik2AGZAPORz69oKcs3y1mpinUugj3FXNRGseYMa1AEfIZnHX5zb/r0P/AA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uUj2DiMA; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uUj2DiMA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709188219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pg7J6RbvacNvwMRulFIzUbDizD8sxkMXgSftNlWyMUo=;
	b=uUj2DiMA/3/PjV0agfJadIZHvkN3SZ8uUIXPug7mI2VQs+Qe1++flNquFOceKgbc5Mt57i
	91+E/RKtwQmL8pwQb66hme/Vpvo6+SfJYkYXMSsXNBILDHhRfmTxgtaYEwTD349xkkpHmb
	m+suuoAMCHvg/iZbNcQ9hnvWPIoVQds=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	david@fromorbit.com,
	mcgrof@kernel.org,
	torvalds@linux-foundation.org,
	hch@lst.de,
	willy@infradead.org
Subject: [PATCH 0/2] buffered write path without inode lock (for bcachefs)
Date: Thu, 29 Feb 2024 01:30:06 -0500
Message-ID: <20240229063010.68754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

this is going in my for-next branch - it's tested and I think all the
corner cases are handled to my satisfaction (there are some fun ones!)

Kent Overstreet (2):
  fs: file_remove_privs_flags()
  bcachefs: Buffered write path now can avoid the inode lock

 fs/bcachefs/errcode.h        |   3 +-
 fs/bcachefs/fs-io-buffered.c | 145 +++++++++++++++++++++++++----------
 fs/inode.c                   |   7 +-
 include/linux/fs.h           |   1 +
 4 files changed, 112 insertions(+), 44 deletions(-)

-- 
2.43.0

