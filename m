Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062C38DE1
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853421; cv=none; b=MSRyeqbY1i+wtAV8edm+/q1TD6x0q5Nxdhc99Gi5GY87cMrY0Umft2LvWtHsoNoVixzc9j92x1KHa2mmb0QkB92hPHJVOOvjcaUt9dqdi8gCA21cC6XPpJypb3Tju0hC+Fla5Oebat4ZiaRrN576sPy0Na3DUmtForw0k4jfjYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853421; c=relaxed/simple;
	bh=9Mh3ikPKDO02lGqbJFoV8tFYUJ5OmTK6KcEALUPSAFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KUE0RmnwwozLPp4wuMBQqh9rFf56evDqmwjVTF7yRWV8DrZCGhcYG6tW+c7WwxM3y+JYIy/jd6AaHEfR5tP0vyDiZK01m75o3s1PaPGVJK9odobDIkJpJcnrESccpDM2DionDf4YzDlpw908+j3Pajx56Q9fDVtEYJDgQMrYTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eTEUWRa/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eTEUWRa/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758853416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xFJUAlc1QedN1ML8UqazsmtqcsiA3368RFOlp1Qtjc0=;
	b=eTEUWRa/614WScGZACtLUDDBAg0WuIYH8QK1arxC9X4CinwDDMRGhTV8d3+0MZjJ9bjlHO
	mZireO8fFq1mD7bDlfKi58eCjo0OywkFHtBD37UFfZWkEeQxI8LW0QEqMdaEfpu25vPN9b
	8WoUNUTWsZkg7oEFNGQD/IPJjC+ClC0=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 0/3] bcachefs: Fix some hard link count issues
Date: Fri, 26 Sep 2025 10:21:47 +0800
Message-ID: <20250926022150.493115-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

- Improves error reporting by returning the semantically correct
  -EMLINK error code.
- Fixes the maximum link count validation logic during hard link
  creation.
- Consolidates link count checks at the VFS layer for better
  maintainability.

NOTE: Patch3 alone can resolve this series of issues, but patches1-2
are retained to better trace the problem origins.

Youling Tang (3):
  bcachefs: return -EMLINK instead of -EINVAL when hard link count
    exceeds limit
  bcachefs: Fix maximum link count check when creating hard links
  bcachefs: Move the link counting check to the VFS layer

 fs/bcachefs/bcachefs.h |  1 +
 fs/bcachefs/fs.c       |  1 +
 fs/bcachefs/inode.c    | 10 ++--------
 fs/bcachefs/inode.h    |  2 +-
 fs/bcachefs/namei.c    |  4 +---
 5 files changed, 6 insertions(+), 12 deletions(-)

-- 
2.43.0

