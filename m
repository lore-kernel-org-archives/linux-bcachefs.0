Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0281084A2B
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Apr 2024 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714407860; cv=none; b=JskKJx45R0wDY3rBr6xklRuu/1VBPDypTasGWKswKIWSVHoIXlPhtuOfbJccIGOWEvaHtNi/LpnaPWwN7XK/+/mWk7TBZoXMdK/fb4EYhu7hwt6QXnl5fWe8fXhe8USrDCmy7rytnagMJQvVw2nZdzko3W4QvBZYlpkoOsAnWzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714407860; c=relaxed/simple;
	bh=8YNVDp1VjF+TTzNtG1oeKcZckCg0M6Ftu8YdUdjoKU4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pWbzHrsFkukIAVJSb1LlJl9ip9uCK5Y3944y+6gWgxmlQYGbOfD3YjACCwxZmvF43WKplMxYQwkChfSVJ+/Q03XnIxO3xIHTuE5gxu8Y6zuapa89KG2oANuob9Fk0Gwj8hJTGPWn004ur65J3XVS0wGu20jfqj7sMvwQ5lRcvZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A2dZ51jV; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A2dZ51jV"
Date: Mon, 29 Apr 2024 12:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714407857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=aVNNGIJFxvAdhIrJJb5GUGrR6z/uB4zEnTjjuH7SE68=;
	b=A2dZ51jVEypxRPFhDGhtaCD27UNeQ79vjRkIoqUD9FEglZpPOpGMUYx09Bcv96Le2QUr59
	dNcl+fEEes3Xpw93wGaC87j1vRiIMyR8IO9BlRc0x9TlYQU6stKydIEcIAfNtYvFEHYvUh
	whJ7lFhiCOW2wA0aVMEVzmZW71y3Mzg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] bcachefs fixes for 6.9-rc7
Message-ID: <grwoeqxbwxgunh4cvdp4jy2qctv2yplrjv2hr4wwqyproe6xor@nuehswrkwqaw>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Linus, tiny set of fixes this time.

Cheers,
Kent

The following changes since commit e67572cd2204894179d89bd7b984072f19313b03:

  Linux 6.9-rc6 (2024-04-28 13:47:24 -0700)

are available in the Git repository at:

  https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-2024-04-29

for you to fetch changes up to c258c08add1cc8fa7719f112c5db36c08c507f1e:

  bcachefs: fix integer conversion bug (2024-04-28 21:34:29 -0400)

----------------------------------------------------------------
bcachefs fixes for 6.9-rc7

----------------------------------------------------------------
Kent Overstreet (3):
      bcachefs: Remove accidental debug assert
      bcachefs: btree node scan now fills in sectors_written
      bcachefs: fix integer conversion bug

 fs/bcachefs/btree_node_scan.c       | 7 +++++--
 fs/bcachefs/btree_node_scan_types.h | 1 +
 fs/bcachefs/buckets.c               | 2 --
 fs/bcachefs/inode.c                 | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)
