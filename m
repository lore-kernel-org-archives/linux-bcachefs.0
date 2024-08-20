Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9F14D2A3
	for <linux-bcachefs@vger.kernel.org>; Tue, 20 Aug 2024 23:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196777; cv=none; b=EGuIOCVrKum36oq8pQ8+Vo5Dr62+vEZ5vj0fXQmwZSBvwEXRTqTmK0B1dZ288EMr3eXOM4z7toilFZbvZAnNMKPLHgMIxNGnmNrN/M17it9YoKi/rfibQUeBB30VIeaAAfdg3ZBnaijGOdQRfY+TgV5DDzFtXDCaoQUptklfkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196777; c=relaxed/simple;
	bh=7Z5LeSU2q+pvGqj3g/BFZtbVg+1PwhQhunU7FBnwMHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9MKTDophBF+8t3jW+1ts49RKLFVBtO+Kk+QT6EF93YWRRlp06G1L8i0KvH3YAiHqru9sqgbqR4Hg3Y3UzN1zl2ZxTW3Q1IgSET7081KFb9TqpTAeGdGO3yJAgjmCraYNpxmr+no27iyyfF22/u7WKOlOZ/nLZAggR8Wp/cCkwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s7BnA2wl; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s7BnA2wl"
Date: Tue, 20 Aug 2024 19:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724196773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Z5LeSU2q+pvGqj3g/BFZtbVg+1PwhQhunU7FBnwMHE=;
	b=s7BnA2wlhhq1cIpNOvWBWn6YwWrtc1jZ29bmGcRKLoqJzVhhID9kJSyoG/lz/kna308qc2
	+BmSKvKhRFEUYHsroB+w4xaIkiFIkNrNVQsIi9tq+//xgnRbMNILR1C+5oinNnhcwo3ND7
	JsKTym3KRP/1iDf4adO3tjFhWKOofGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+7e9efdfec27fbde0141d@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_write_super
Message-ID: <slqmzqevvgpdzvtcferxf45mzfj4rvk4g6fr74styt3csdk3z3@dayd7ytn5jac>
References: <0000000000000b533e062024e702@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000b533e062024e702@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix locking in bch2_ioc_setlabel()
