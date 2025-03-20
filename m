Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B021CA07
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505697; cv=none; b=gMwGJj1h/wNR4EMlaZHDeONQZuZ/geW3F42aeTpDUE8TlEJKr8DIZI1GtLEO/WLfE2wtyyueIzCn2PdPFwJHdPB1om6sJDTJDNUOZq8uspol2RxaXtaECdqEKzTmlXM5oRshesFFuz3FgDwvHp4qLu5ldkDhuszhkxdplvBH9Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505697; c=relaxed/simple;
	bh=SNC+3HrjEHzTc1mLv6IU5QJ1tm5DAu9s1wmZ9YxKcws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g3vUp9xXGwBI2kIuadyCvhlZkYCJ4GPecey3VHYfAhG1gNPAKTDGOirfrZABcpdo7O6OBIbitKBOLdjrOPZiq+RCbQlSpAD5R8Ta1pmsFOysTu+W9IOQ5mhCZQnOBqucCcw+3hScMv+6+1lAK5972SiAdD7p2RV0DKKBDvdy2cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1Ffv2Hc; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1Ffv2Hc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+mmexmmzST0qC2EuMoY91QsZY+/k90m3IlYZE8vE+as=;
	b=v1Ffv2Hc/T3BpIy1SWjY5CVAqFa27lSbSwqtPAfWBkFl6TGd+IA9fFBdvPS8M+L5zMob8w
	uf44rcJfwjFKaWYbWRVWXXL92BwtGyJ/xqSM7pgh1JNDW7rfePLjSCCM7Pvvk71XtOxlxV
	H8Z4UEHo3G8kpLd+gNylGmeGQwnPQPc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/5] device option handling improvements
Date: Thu, 20 Mar 2025 17:21:18 -0400
Message-ID: <20250320212125.3359155-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, device options had a fair bit of special casing - superblock
getter/setters, sysfs code.

This does a fair bit of cleanup and unifying, to fix a couple things

- discard option should now be working properly in all cases, i.e. when
  set at format time
- with the latest tools, all the device options can be set at device add
  time, in particular data_allowed and state (for spare/ro)

The io path option state changes are still a bit more "special" than I'd
like, but foreground_target now also triggers a rebalance when
necessary.

Kent Overstreet (5):
  bcachefs: Kill BCH_DEV_OPT_SETTERS()
  bcachefs: Device options now use standard sysfs code
  bcachefs: Setting foreground_target at runtime now triggers rebalance
  bcachefs: Device state is now a runtime option
  bcachefs: Filesystem discard option now propagates to devices

 fs/bcachefs/alloc_background.c  |  15 +++-
 fs/bcachefs/bcachefs.h          |   3 +-
 fs/bcachefs/fs.c                |   3 +
 fs/bcachefs/opts.c              | 117 +++++++++++++++--------------
 fs/bcachefs/opts.h              |  52 ++++++-------
 fs/bcachefs/sb-members_format.h |   1 +
 fs/bcachefs/super-io.c          |   8 +-
 fs/bcachefs/super.c             |   6 +-
 fs/bcachefs/sysfs.c             | 126 ++++++++++++++++++--------------
 fs/bcachefs/sysfs.h             |   5 +-
 fs/bcachefs/xattr.c             |   2 +-
 11 files changed, 187 insertions(+), 151 deletions(-)

-- 
2.49.0

