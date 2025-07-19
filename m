Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D337CCA4E
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950399; cv=none; b=dExXk3WORl0LxJccTStUtbvXcMNJTBpD5BWpnNXtEgOfdR81vDkK8KhLCmZYo9Db3cGoRl9GH7skwlI3GKbYomr/bCwuiHd0q5RAw8p6qNEUW3LQhQlneGM00DSWXYcxH5y3Z5MJ5PphHwZE7XMm1QwlHfg5TTBRDxooRdF29Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950399; c=relaxed/simple;
	bh=5p+PZ5SsqDHnWtLXR9irbtALlXuRogq/81ysSPWwdfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhZ1glJIhOsOwRa4Q5UDD9810g7slAVU5iR9KM9rViGIH2cv+xRMyqK5TuOAr+5F7H0ymj72wCripPx1KLuFqiJdAGL+9lkKVtTxdMas72BxpAXJLKe46gBbgZv43rqqiDkXJoFfrwu4VNKDQzknlLeiMVJRe8euUZGSQbb5h3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qa2Phvg3; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qa2Phvg3"
Date: Sat, 19 Jul 2025 14:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752950395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5p+PZ5SsqDHnWtLXR9irbtALlXuRogq/81ysSPWwdfQ=;
	b=Qa2Phvg3v070rK/OqJEFCGzfTW3x36A4WpvrnqA2KvCc/jgmADvYaDQei2PeifxM64vBnr
	KZcH8GRAY8JVywEhm6GSkuafZBXaNn6gqOMcHX3JNm224N5WyFEv65Q5MKG+BTQT+4M5Nc
	USckaXblJmwGyqU5dZsI6dSDF4T+5Y8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+5e43fb34e0478e83681c@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in
 bch2_journal_keys_peek_prev_min
Message-ID: <2mlpcljan4o4m6fen2z3x47qwudifc6skxvld3atp4fybfm3we@ssuovfsd32th>
References: <68616ffe.a70a0220.2f4de1.001e.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68616ffe.a70a0220.2f4de1.001e.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: fix bch2_journal_keys_peek_prev_min() underflow
