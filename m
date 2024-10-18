Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5361B176AAF
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226422; cv=none; b=KHoWyKMzU2pXEiUBXmSddKY5ySVvQafXp0a+Z6WHdcrBfDiT2pTzd3BO6rC4rJp4mmVENJnO2YMzya0eCdaUDwGV6Y21ldbma8gCpZqeRokCzWow21Raa0CSMJchH7VebVuuVA+Wz9IB1juoaSEhDBUNmczHQ6L+vpzBFrB8SUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226422; c=relaxed/simple;
	bh=zK9GZ6zvXfG/uzipZSg9NKiAVF820M7TOkkSgzIamS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=juOHzJrA1ZUybcm9gZ0RyE0yy2tzmWkl1rYxCmPDH6/HBSgkDNT6V5ZxxWtas6r9l3q//em7VMVIcWnfYxj11492JFNi3tFYecaJujanLZqfd1IJC0MIVousxEB6++KxqiYrsGxjAG0YCkwbKmx5hcbSGEC1yWkaGcjYP902i9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kVRcOtMB; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kVRcOtMB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c4THEnABXpp6kNHTCT3xJ7mA3h5YG1Ya1gXp/dlLLs8=;
	b=kVRcOtMBVEx0Q/nJBPG8sOaYwpBEuEeQgzPEMRhAo2lJa8WW84XhVwpr44qlXQF+6vKtUI
	ukj3ACBFV+X0w/279XjNaYf1tBpsMXSMfvHjEpW43H8E6V4qzbYh8T111x2q8kysdJKt1a
	B1HrCNMLD12KTZ5T1t+u7QzqtsrRuDs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] fix buffered write path on -ENOSPC
Date: Fri, 18 Oct 2024 00:40:00 -0400
Message-ID: <20241018044006.4067521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

xfstests generic/299 turned up a data corruption when we do a short
write because of -ENOSPC - when we truncate the write we might no longer
be doing a full write to a !uptodate folio, which then needs to be read
in.

Amusingly, fixing this turned up a bug in fio where verify mode behaves
badly in the presence of short writes, which took longer to figure out
than the original bug...

Kent Overstreet (3):
  bcachefs: fix disk reservation accounting in bch2_folio_reservation_get()
  bcachefs: bch2_folio_reservation_get_partial() is now better behaved
  bcachefs: Fix data corruption on -ENOSPC in buffered write path

 fs/bcachefs/buckets.c         |  7 +++-
 fs/bcachefs/buckets.h         | 12 +++---
 fs/bcachefs/fs-io-buffered.c  |  6 +++
 fs/bcachefs/fs-io-pagecache.c | 70 ++++++++++++++++++++++-------------
 4 files changed, 63 insertions(+), 32 deletions(-)

-- 
2.45.2

