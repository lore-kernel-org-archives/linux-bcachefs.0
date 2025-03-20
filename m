Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48FBBE6C
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505871; cv=none; b=XDA2YBaaKFealuVHMfBX92bFyF6Buekf4bfH0wbWj5SaxnqIMOXS9ZHarvIs6M6MQ5g+oC/XT05XOuPm3Zedl79jmBJDChPi4RJGxN6dPkV2uAH7w/QCv03s92mCxoAZlKcaw9Qa/B54Y1Hju4+5I1hZiTT9AcgewaFpoz6Zg4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505871; c=relaxed/simple;
	bh=V3DGzJHOktYM1nBHrCFQQGkWFhC2ZU1CzCBQqVidmXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rP7XaVdxzmPE6uem3vLyS9b/SKuG5g3jNcxon1H+BO1MuNemgJn+PCooV1QXlW6F+LyjvvhGYGnnPWk/hBsWGIOcJKKq8Y+EYqn/VJc6ilcu5XnLCWqDn/xOoVeIltlrV7wNIchoS7P3azv8heEXF2UFvAcoOK7jl2DCD2KdHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UVEB65JN; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UVEB65JN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wUc1/ufo1gsk0oDnLMZi7qJAIwZr+0sOUdpjREy5oAE=;
	b=UVEB65JN4rHcZ79oR0GKW0UtkMlYSh9pqv6I+tMVbDTo2BTLGiVBsMnXNI2I7stWEQgL6P
	6+/knnpK/4O11AHnCn8BAO5DW3g2V5gU4OG0RnMWaU3Sli1AF3CNGmpwa0oUH1CVOxVpKL
	4Js+6N6+ythmwyNLLYp9T2M3I+YczqY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] Private error code work
Date: Thu, 20 Mar 2025 17:24:15 -0400
Message-ID: <20250320212419.3359422-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We never want to be returning standard error codes - those are a
nightmare to track down when all you have is an error message that says
"EIO".

This kills off EIO usage, mostly in io_write.c.

Kent Overstreet (3):
  bcachefs: Simplify bch2_write_op_error()
  bcachefs: bch2_write_prep_encoded_data() now returns errcode
  bcachefs: EIO cleanup

 fs/bcachefs/alloc_background.c |   4 +-
 fs/bcachefs/alloc_foreground.c |   4 +-
 fs/bcachefs/alloc_foreground.h |   2 +-
 fs/bcachefs/checksum.c         |   2 +-
 fs/bcachefs/compress.c         |  65 ++++----
 fs/bcachefs/data_update.c      |   2 +-
 fs/bcachefs/ec.c               |  16 +-
 fs/bcachefs/ec.h               |   2 +-
 fs/bcachefs/errcode.h          |  18 ++-
 fs/bcachefs/inode.c            |   4 +-
 fs/bcachefs/io_write.c         | 277 +++++++++++++--------------------
 fs/bcachefs/io_write.h         |   9 +-
 fs/bcachefs/journal_io.c       |   2 +-
 fs/bcachefs/journal_reclaim.c  |   6 +-
 14 files changed, 175 insertions(+), 238 deletions(-)

-- 
2.49.0

