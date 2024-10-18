Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E1160884
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226425; cv=none; b=BlQtovAYv3tmj5Hgw4arCs83SlnZRX49gdppw6U/Jh4j0dHOSWL/QK4JhWRvATUaBp+1kMQUqzqaERh8Lv2Ma82NN4el/jlxAg45IEmBLrF+MRSvjRh3nkaPcQM5hkN8rF2HOqB7tonKA7xehAKeinSYXPWbSURg2ypuZ75K05Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226425; c=relaxed/simple;
	bh=SkjVl4fvhevVX7r1K2uX4hts6w6r8KvTniTwNAn6AlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5xbAj3UfALeeihVEMx2pWsRjwALRaP2DbfZQ3IFET+/+Bz5G754k/gH3AAT1xFm9NccsgKYoevV/mIXl4eqY8uk/HNcxlhr+cwZuG4Ky5ams+24BUcTZ48lgXf9NalnZ06cfwt33f7hQP/Y8OJhw59FDJ2EcmxWSsjO3Gypg8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SI0sktzZ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SI0sktzZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i8E73g5h1MFCZh1Exe/53cVk1gWUhN1+R+qxdjYx5OE=;
	b=SI0sktzZcm7bcqKkLBFsxabV58xj6zoVoxuEozbvai47SyK+bbywwTYG5n1yEwa3Tt2ic3
	+ce+Tl9Za9mkq1dFstT29wbcHDxRlrkEDqaBOEQRs3L3j49hV/3+2+hDa5zT1Sw0Y08jNS
	+kTzZbl68x/+54zXF6hwYU2sJzYYiBI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: fix disk reservation accounting in bch2_folio_reservation_get()
Date: Fri, 18 Oct 2024 00:40:01 -0400
Message-ID: <20241018044006.4067521-2-kent.overstreet@linux.dev>
In-Reply-To: <20241018044006.4067521-1-kent.overstreet@linux.dev>
References: <20241018044006.4067521-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_disk_reservation_put() zeroes out the reservation - oops.

This fixes a disk reservation leak when getting a quota reservation
returned an error.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-pagecache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index af3a24546aa3..cde3a0445ee9 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -431,9 +431,9 @@ int bch2_folio_reservation_get(struct bch_fs *c,
 		ret = bch2_quota_reservation_add(c, inode, &res->quota, quota_sectors, true);
 		if (unlikely(ret)) {
 			struct disk_reservation tmp = { .sectors = disk_sectors };
+			res->disk.sectors -= disk_sectors;
 
 			bch2_disk_reservation_put(c, &tmp);
-			res->disk.sectors -= disk_sectors;
 			return ret;
 		}
 	}
-- 
2.45.2

