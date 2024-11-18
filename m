Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5582BCFF
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894309; cv=none; b=pp3mJU6cG4wIamPesrXHVPXxq+3FBM5Pu8FRime8+yjvrTQjngZ1Khakhq/4E6h7PR4FvVth8P4SqKwSTK/xt6Qm0wb/2r3tX/ZUfW+EHQsWtg4aOxU8dp+CA+d+dKYvl8X6Y2x6GuCiDQeJAEcog9XU29goZCSKxAp6OU+oQwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894309; c=relaxed/simple;
	bh=tzM2TMxpvRHD2nS3hIiofxhYSokxhH0DjoArX5ojXpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MY7W9riwT36nxIxuwdWCdK6d22UMGwyxF1eNQnVrodpgUkQQsszfsf9ReQbL8u3vTyMSLY3wyhHX3FcrwauOvpocEr96K3AQ+sa8LdslTHZvHbxWONT9MNrk7o937BXl65mQ20vBjb7RmGAdJdsI9ttbFEKhwRSa8w8uZt36Quo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aE5s2Y7p; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aE5s2Y7p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AdMnk+VkF25nOrGa3zd365pDki3eEjs7Z9fWE1T/hC4=;
	b=aE5s2Y7pP0F+s4Wo+VkyghezVRtEYgc9qpWZBtaS2cn7+18LgiJaKXSaPz/NizYUlh7jfM
	o3ES/7AwZEJQrY1Jv2hKGN81dvKdl84/bxC9XcF3r89OhT2zPIpwLHFraqMOKtcsVIkhi0
	DbWiiFt0j8URHSR2jm5MUUrnOrFPxKM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/7] backpointers cleanup and prep
Date: Sun, 17 Nov 2024 20:44:41 -0500
Message-ID: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

all small stuff, getting ready for killing off the (very expensive!)
backpointers fsck passes

Kent Overstreet (7):
  bcachefs: fix bp_pos_to_bucket_nodev_noerror
  bcachefs: bucket_pos_to_bp_end()
  bcachefs: Drop swab code for backpointers in alloc keys
  bcachefs: bch_backpointer -> bkey_i_backpointer
  bcachefs: kill bch_backpointer.bucket_offset usage
  bcachefs: kill __bch2_extent_ptr_to_bp()
  bcachefs: New backpointers helpers

 fs/bcachefs/alloc_background.c |   8 -
 fs/bcachefs/backpointers.c     | 282 ++++++++++++++++-----------------
 fs/bcachefs/backpointers.h     |  85 +++++-----
 fs/bcachefs/buckets.c          |  15 +-
 fs/bcachefs/ec.c               |   7 +-
 fs/bcachefs/move.c             |   5 +-
 6 files changed, 188 insertions(+), 214 deletions(-)

-- 
2.45.2

