Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9925F96D
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Aug 2025 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450461; cv=none; b=BcB5JyYpmwGl0Km1SQXIkMVQjPqs5J1WUURayWSzdrnNvggD3mTyg060ZK0QLKYqH1ianEHx+Rz+7C1U8ojPZoXboA/fW83187TCdZsMPzxIjYf2S2SQ5+s+BKuXDiXZqVj0W+wAnQbS9ddyIveW1V0SjkHO17gYhtXJcG/TWkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450461; c=relaxed/simple;
	bh=GOcUycjwL0I72hHKOoSRtIuX1z32u933GDAogXp1Wrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KGNccMlnRpFc9M8w+qJBh4MM0Awu4EYt6NmltJ8A1rCAz+yh9vG9EMuQDaYKCz1mpQa5TU0mhhJKsw9zk0IU3T6aMrfXsexOK3QuFmFtbT7wcWmJ2jy4v0mNtjSMZ9eEd4oDSCMHxMWKwNL32iT5cEz1Q0M8wSYK4g3y0c85IY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=havwLpxg; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="havwLpxg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756450454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IuYRNKEKT1I7CyJnYJPf7ti1Io5FjPtms36SrEl94e4=;
	b=havwLpxgfJJxZSn4dUIJDcbK2qe7FEW6oA+OGidebwSsp7vSwPxtj8azIuR9RrI0LKbn7l
	v6CcfnaD84nM+aYaNK0HoD0iWQT2RfAcQOUbRfjPVtxFeG2FNOg8EqwZn5GzE7Lq+PQbSa
	T+74QjEpSiqdL8soMfGkNiPDgvRKQa8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] better error messages for ioctls
Date: Fri, 29 Aug 2025 02:54:04 -0400
Message-ID: <20250829065409.3248746-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This fixes a common user complaint - uninformative error messages from
various bcachefs-tools commands.

Add v2 versions of various ioctls that include a 'struct
bch_ioctl_err_mesg', a pointer to a userspace buffer for an error
message - and plumb a printbuf through various code for returning
errors.

Kent Overstreet (3):
  bcachefs: Add v2 ioctls that return error strings
  bcachefs: v2 versions of subvolume ioctls
  bcachefs: Plumb error messages through data drop paths

 fs/bcachefs/bcachefs_ioctl.h |  87 ++++++++++++++-----
 fs/bcachefs/chardev.c        | 159 +++++++++++++++++++++++++++++++++--
 fs/bcachefs/chardev.h        |   3 +
 fs/bcachefs/ec.c             |  23 +++--
 fs/bcachefs/ec.h             |   5 +-
 fs/bcachefs/fs-ioctl.c       |  91 ++++++++++++++++++--
 fs/bcachefs/migrate.c        |  55 ++++++------
 fs/bcachefs/migrate.h        |   4 +-
 fs/bcachefs/super.c          |   6 +-
 9 files changed, 359 insertions(+), 74 deletions(-)

-- 
2.50.1

