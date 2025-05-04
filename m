Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E3F17B425
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 May 2025 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746388335; cv=none; b=CHWSzXvEIyG17DsdOcGMdNqA54MMy2k2JtVaXAMr9leJ+S3JZhkLoVGLKB57cBu/GVAcHGc0S4q7h3B3Ia9rFS/8Zqu7Kd0MdOYk2efc2mDdlDd3BiLvYeop3HpEYna0uB7SKDRUZ9Wc9arvV10TkwtnhImufpMZnCFM/WbfIcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746388335; c=relaxed/simple;
	bh=pq4rEjg6DyjORcTKiwR8u9s/MAjLES2O35mjiKuppg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YMzdv+oATnPsv0U9f7LtVLJtYKfV5xYpFFe8jSmxDWz5+SOwiY11LQpEK9YjxQOGonou9PTxCRuKzihGTJrqe5GGOVa7XFHxObrd8bF/nhimPmGNLs77WFVPP2DlTSgDwVpSLABy51BqzhALBRKVc0sT+QDFhdD+uojRdQXow0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GPHyX3VR; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GPHyX3VR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746388328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w61Xf9Je6TLO5s9htfuEHfgbptvm3g3mm+AbOzgMpn8=;
	b=GPHyX3VRyUvTF+exmdaQmdMwVMA+Rxh+H7XNVAGUY6IClhOVkQyfEWVh6904FkjaELiPqn
	Txci9JsV6bDwzESurFCEhSOcJv9MoPOz8K7EgiM6K2T89Kz6ygEbd1CJ0POwbb5KZzvrgV
	XawQALFyk/oGE2VAsp7z2i/SNi6x3i0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] Fast device removal
Date: Sun,  4 May 2025 15:51:56 -0400
Message-ID: <20250504195202.2073437-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, device removal had to do a full metadata scan to check for
pointers to the device being removed.

Instead, we can now walk backpointers - drastically faster on large
filesystems, particularly after we've already done an evacuate.

Since we don't fully trust backpointers this requires an incompatible
upgrade - we need a sentinal value on member devices so that device
indexes aren't reused until after a fsck.

Kent Overstreet (3):
  bcachefs: BCH_SB_MEMBER_DELETED_UUID
  bcachefs: bch2_dev_data_drop_by_backpointers()
  bcachefs: bcachefs_metadata_version_fast_device_removal

 fs/bcachefs/bcachefs_format.h   |   3 +-
 fs/bcachefs/btree_gc.c          |   4 ++
 fs/bcachefs/migrate.c           | 107 +++++++++++++++++++++++++++-----
 fs/bcachefs/migrate.h           |   3 +-
 fs/bcachefs/sb-members.c        |  29 ++++++++-
 fs/bcachefs/sb-members.h        |   4 +-
 fs/bcachefs/sb-members_format.h |   4 ++
 fs/bcachefs/super.c             |  25 +++++++-
 8 files changed, 158 insertions(+), 21 deletions(-)

-- 
2.49.0

