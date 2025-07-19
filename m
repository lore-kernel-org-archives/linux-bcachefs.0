Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769E01E522
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752946523; cv=none; b=a3FlHIvZ3Gk5+lY1ouJXOj7A+0wHYIBk139o71pty98GpENnLlmx8ZIv55FR4V+LQj103nyWjN5JajnW6TeHCNRc3+EW3vSICWknsG+fc6ioU0HBDmuJhfgXWEZYpyFFpLm+IOwBPAjiWlRXhG5c4JmfdXg0ntIBLHZ+UWPjrdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752946523; c=relaxed/simple;
	bh=xvRXDi6I7bH838FXYg/+BfhiQMF45sAu4BFnKcKYZeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igcJ88FK0TR6rKP+Xq/k9VDiyLqVlfye5u3PQLgqvpVwcOTg8n0Lves9DP9x8bEHJDL6+ESmU/FcxlAZY11LFsmAa4XEmbXeY2ry+p1zYtTnCotNMJfkTbAs911Kf5Wcw3hXOwKtkNqm/O/a/m3LVwjTkP+0+ERfiYj0rypivKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YrqmLRbY; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YrqmLRbY"
Date: Sat, 19 Jul 2025 13:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752946508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xvRXDi6I7bH838FXYg/+BfhiQMF45sAu4BFnKcKYZeQ=;
	b=YrqmLRbY5uJRvPK3OPwXb5pisE9umsWxB6zNNulF4pTSDt8FYvEGuStQldY6n/lNnqcJ4w
	kNEL8a20hpW+YRGNbKr6f2lTGUnnr44TA2EgpsSSesm2AFj+9I/tTSSDQAlYP23MdW08IM
	UNORLujrKEVtboC8J1kvAawXF1qET80=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in
 bch2_get_next_dev
Message-ID: <nxgsgizgeja6265rgz3uezzpgy33toz7aiicwy6uf5g5orhbcj@qmqipkujhg5c>
References: <687a71bf.a70a0220.693ce.006b.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687a71bf.a70a0220.693ce.006b.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

Will syzbot reopen if the fix is still in linux-next? Let's find out.

#syz fix: bcachefs: Fix UAF by journal write path

