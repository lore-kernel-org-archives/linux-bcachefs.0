Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB181749
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 14:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727101303; cv=none; b=M+rwY0NOY8Fl34+eldLBQb92PFujy4Zo+izWlO41pRQOl3t7+pVLIXc4PY2qldaLpn42Z/4sQYIeLlvLGnmPEdtP15X6mgLHPGe98P02xodQD1OBFoJU13hs4qjlDSAE6oadfuUWWwd8h1JT0KjIfQE+6WzmEsOmL1wS2Rbt0+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727101303; c=relaxed/simple;
	bh=+toSuw+73TBKSfr7QVZr9PZMzXt7BLaXCEUsLRd196U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l3wHOcl8LBr3nyCsf7MuAYkxQO2ryRfCbMTQGOuRj7uih/yWqI7KGN+H/oDUokCcraSvjRCW/3XPEkxDUbfP7e2Mco3zJRYs0rzSZuG8gfTUxCqIn2F2P6NLxlRnVs3hOGWNRq0HjvY/xtbmCxVk9jSvGPrW1t9J3/g3Ii9wxIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ltx3Yfe5; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ltx3Yfe5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727101298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YrXhasMZTPNLx7yJ0WgCizNLa3DnzJZY8Ov+16wH9aw=;
	b=ltx3Yfe5CF5giL/8T0DPe72jIo64EFbozaGakezG09DLUfCT++WaWTbYQ/gDBnKco5rXGK
	7msPAW22T/OroKHHAcIOAIPKVYT7G4hZKWARpcVduWrCJ/lprEjcN7d63n0RKkAotzeEdC
	R6EpnMNOHIMF3OSPT4RqNuPukHFD948=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@toblux.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] bcachefs: Remove duplicate included headers
Date: Mon, 23 Sep 2024 16:20:29 +0200
Message-ID: <20240923142028.232365-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Thorsten Blum <thorsten.blum@toblux.com>

The header files dirent_format.h and disk_groups_format.h are included
twice. Remove the redundant includes and the following warnings reported
by make includecheck:

  disk_groups_format.h is included more than once
  dirent_format.h is included more than once

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/bcachefs_format.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 14ce726bf5a3..b97fd0f75831 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -499,8 +499,6 @@ struct bch_sb_field {
 #include "disk_groups_format.h"
 #include "extents_format.h"
 #include "ec_format.h"
-#include "dirent_format.h"
-#include "disk_groups_format.h"
 #include "inode_format.h"
 #include "journal_seq_blacklist_format.h"
 #include "logged_ops_format.h"
-- 
2.46.1

