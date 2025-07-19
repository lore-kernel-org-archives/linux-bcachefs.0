Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026F911CA0
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752888731; cv=none; b=Oo1zGN/Q7GFL7zHq24R+lzJJE0+9Z0BH8usWoUEntvVZuDN5ADDZtBpzHqwoTtx3KB6aaFwD/+LxtLJdU6IH58gp+YH0br8n0XOYl5WFSTHGPl6F5g8gOzn4Ra2OTTYgZ0HdjB53F/g4eKEfQKqgYnEyGaBFbzAaENqZrR1Ch0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752888731; c=relaxed/simple;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNOo3mLAeicQ85vvpIflCHzozlEgPrJaHV6YP/G4P2iu5veBcONUQ2OsGT0XRFLK4AgqUUGoZJMzh/Ztw3G70Sf3fka3PI/BIxPu4z2c4hT4av1xUehEfTefAvgtyuq3M5rgLR5Dh00AZFg/Qq6zMGYK49g3nQ4a84JFtOX6qE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I61Ceuf2; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I61Ceuf2"
Date: Fri, 18 Jul 2025 21:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752888725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YYOVYUvREZN04Anb5VZesSY/aodjhWQXXvnzRS9byw=;
	b=I61Ceuf2qSgpZEwtfpnF6UFQJnlS0DcOak+lwoY18hCbZg/WwWOq5z0zahBL5AlewyU4T6
	Ij5Sum4vPsMe8S0M5d4pVpq9s0PorCw+Rx+PSAsDGHQtO9fKeOeOLbhmI9vgBVb2WO/rLH
	AYw3QbfoaET25sioipAT6m/ArTpCfOo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+5824b2660896028cfe7f@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (3)
Message-ID: <eu7ychmqiiteykpoq3knoa6hi2a6xlpf6fgjcp7luhowe24jxn@7iwldfn4xtcl>
References: <6766dfca.050a0220.25abdd.0130.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6766dfca.050a0220.25abdd.0130.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Don't build aux search tree when still repairing node
