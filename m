Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5176919924D
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950130; cv=none; b=Od7GRf/7v/SW51pMeCAFvGiq8AabCOpGoKhE5hrCw7s6yco3GF7bGyQj8vTMeFV9N3mxoiTO0jAb+aTJQQiq8/gtbfFkpqCVvuwvIE6YzPtIUWZkZQ8VocpRfR+OiXZCR9by5kYdQPUAlSQ+6odcAld/L6SwH50JwkgPf7cL234=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950130; c=relaxed/simple;
	bh=vcQLjCPsJ6QGJeVa8vFck5L4jVlpAeMNWF4/zfnIILQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHlSmUtfQ2wODDZSY8HEd1WvpDbukwfL0ofHnnZdF31hpfnL9q7vW2sc/ewcsCLWw4Kb20bG6d144wGJVJYQwU8rschPijvzQpXSmsygM0fKXmnSoFdf+Ikcsot4e9NIOkV+Aa/aijWDnWmAWuqvqsrpMoOwnX8d/g1O1FjqlKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VqiLH5t7; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VqiLH5t7"
Date: Sat, 19 Jul 2025 14:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vcQLjCPsJ6QGJeVa8vFck5L4jVlpAeMNWF4/zfnIILQ=;
	b=VqiLH5t7n1n9ienbUNGIoQRUBk8qpB/3J/8tpUXSr+bIN5I43NpXbn6qfi+eXQarTgistC
	/iQKnoHEISZ0gHhESF+uV37upt4gxld5Zr+9M5lrYmbXMSaPMOgx5aTb1bdvcCUuYGbiY/
	nGj7ZcIRosFCiU0+A8iTHQ2ngEmc4go=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+8eb51728519f6659ef7b@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in
 __bch2_alloc_v4_to_text
Message-ID: <t2rrvrm4o2cc5ch54rubvta7wynoq7npa2jflfp54djooepd42@jlz5nqlx6j4l>
References: <68512333.a70a0220.395abc.0206.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68512333.a70a0220.395abc.0206.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix refs to undefined fields in __bch2_alloc_v4_to_text()
