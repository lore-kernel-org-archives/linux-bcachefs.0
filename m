Return-Path: <linux-bcachefs+bounces-1-linux-bcachefs=archiver.kernel.org@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26277C4332F
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Nov 2023 23:21:40 +0000 (UTC)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A407C1F211A8
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Nov 2023 23:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D392F506;
	Mon,  6 Nov 2023 23:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VyCIOaSI"
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714FC2EB1F
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 23:21:34 +0000 (UTC)
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAED2134
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 15:21:31 -0800 (PST)
Date: Mon, 6 Nov 2023 18:21:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699312889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=F88GsdK+QKOYtviN5wzXPHr0kz2sfksGrovltL9R2Sw=;
	b=VyCIOaSIS8g80g6vDV/EHsg8XU2TJzfreXGimujwtNnfp4iIHQy9IQ1aswK3wjf+HHmWBI
	mq1oXje/gBMGlt+Fp1XB0iYtw4sKjosDvMqHs2ZXF+epsAEU4XKr4qqcGYavCRgP5QRXL3
	9tNFasWY4CbemhDYCLtq2a8zW4tzUZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: Weekly cabal meeting tomorrow, 1 pm eastern
Message-ID: <20231106232126.hatritz6xzv7rf7p@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Email me for an invite.

