Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6376D31A69
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Jan 2024 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sQSXyd0o"
Date: Fri, 5 Jan 2024 12:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704474335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=n/T1lnqYsMLTrQPPmaSoNtt46/G4oldtmQB7RAk7nZQ=;
	b=sQSXyd0oRQdw+vUuu+lyH/De9lqo8Ybsu58YBDvd0q1V8uc+0X8kEZVwp5BXaho1L3J7vM
	zd6FFyV3xbPoFSAXrDzUBRs14rcoBZSwaEcVz6E3ScISFolkfvpCRPRFQ5LA/rtTCRfdnN
	AvTgKkB6ALAdQql1lNcYABD6A0qtFTE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: data corruption report with bcachefs + zstd
Message-ID: <gsjktjczzi7po3cymzk657s4ndx6g4jczhlhxbpopbhrq4pdxl@ap2jpp74totk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hey Nick, got a data corruption report without much to go on so far but
signs point to zstd: https://github.com/koverstreet/bcachefs/issues/619

Data corruption with postgresql and monero, doesn't happen with lz4 or
with compression off.

Are there debug options within the zstd code that might be useful here?
