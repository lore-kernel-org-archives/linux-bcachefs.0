Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA638143C49
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Jun 2024 21:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719352436; cv=none; b=Jnt9rigAzFs04GB0chzgzP1lRbqytbjewbzQrQ+85TNnWuwFZ75jzWFxZy7gRy2NMC3a7vfiHtUEHm3YWkYRDG1ah5S3SPUZrh+9TQP6/kxG+jSe9xMIbDb8DMcQaMYr/UiC4QqH/Ubr68E7qx6/XJXpMv+92v9KdePke9uHq44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719352436; c=relaxed/simple;
	bh=GYDmKApHl9XXboQMrXfcJU6dcBzjYZzyi2dTPKuG7BA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AdIgBhuABoH0Yng5t+xQtug9ftyz0ABP6D+o6mQqKgkL6rTjr/fuI1Oh8EIvbBqz79iL2ZV5X5ukzBr5M38lFDNUHZiN4bF+Fh9vAkb8TKlFSfi+FqjdL4CkdPQTSLt+ZhF5HsYTSdQHIHjcBimOzmldDJYlYJapk1nl/nueNMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u9iOsSvA; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u9iOsSvA"
X-Envelope-To: peili.dev@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719352432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=265BkYEFixQ4+b8lDxdVq01LNWShrYh2S9wTmbzDUIM=;
	b=u9iOsSvA2I0XovjUD+GnpMU7woMznbrSiYJ2VR4Gzr2/NCOBO1DsunAuz8ik+ywjHFbX/Q
	5jvQonYvdPGof0cLLfun0AkpkDEO2e6n7cj6FERpqmcDmIlX3X+LyvauSFgzjeVVn6bIG+
	ZTatj/4j/jOCZMFTMPxVCfYl/VnSdP4=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
X-Envelope-To: skhan@linuxfoundation.org
X-Envelope-To: syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com
Date: Tue, 25 Jun 2024 17:53:48 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Pei Li <peili.dev@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, skhan@linuxfoundation.org, 
	syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix shift-out-of-bounds in
 bch2_blacklist_entries_gc
Message-ID: <v25urlaqpqzemumntbqus3uhug2ohy55cu3jmjenelti4f4dtb@qo7ou6qsnbp3>
References: <20240625-bug1-v1-1-9344c68582a7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625-bug1-v1-1-9344c68582a7@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 25, 2024 at 11:41:29AM -0700, Pei Li wrote:
> This series fix the shift-out-of-bounds issue in
> bch2_blacklist_entries_gc().
> 
> Instead of passing 0 to eytzinger0_first() when iterating the entries,
> we explicitly check 0 and initialize i to be 0.
> 
> syzbot has tested the proposed patch and the reproducer did not trigger
> any issue:
> 
> Reported-and-tested-by: syzbot+835d255ad6bc7f29ee12@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=835d255ad6bc7f29ee12
> Signed-off-by: Pei Li <peili.dev@gmail.com>
> ---
> Syzbot reported the following issue:
> UBSAN: shift-out-of-bounds in ./include/linux/log2.h:67:13
> shift exponent 4294967295 is too large for 64-bit type 'long unsigned int'
> 
> This is because 0 is passed to __rounddown_pow_of_two(), and -1 is
> returned as an unsigned integer. In 32 bit system, it will become
> 4294967295.
> 
> This patch fixes the issue by adding check in
> bch2_blacklist_entries_gc() to avoid passing 0 into eytzinger0_first().
> If we found out t->nr equals to 0, we directly use 0 to access the root
> of the list.

Thanks! Applied
