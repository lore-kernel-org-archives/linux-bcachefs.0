Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E723726AC1
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346141; cv=none; b=IHB1BPNuCmGB8pGfo2KwZeISNMwW+DDDFjX051s6swIGjdlnQ6hX0myPD7VQpwPGI4komuk0ze5RzPDS9bJ04vO2sDyoPnB1+wuIokx8dNMtmFvqvVjSPDB0d9jNX5CSelBzijGXvYPSTrAvsNnDjPtQwvXnhmYiHtsIeUhXhQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346141; c=relaxed/simple;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyh0PFbmR8gZFYGfBmxF3EfroJRxFOHxcYRHIWRq3rl368g5WnQpxeSBDRqjH734ehfdQ7oiYZ5b/hYnsEGDyY91GYu/mrQGfzux5vdsVizHHjtW6blG8KtVqXkEdeCblLkzpNIyno5UG7HmtfbCL8ZXqg3X1DxIeXsqt7DBwjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QCqeK03I; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QCqeK03I"
Date: Thu, 22 Aug 2024 13:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724346136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	b=QCqeK03IFwHrJyXxqTBzBJL6kwoP2I9cpIXnTxrWAZAX6jfVMAjA7qOry04CsrJad7BSO8
	0/I11A0TpQy5RvxnDbL1wp6UpW8pS8MmWCj3rbK4fptAiQhVwEGkEKvhKI/4dTaNMLwr99
	Hm9GtoQGIFnKz3SbUHxWzYUX/fLdyB8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+6583a960ba94699a7da6@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_val_invalid
Message-ID: <7uewvrde6szmhrchebb2rmtlrjaujdc5h2vjfycoc3ffd5wjn7@xke7muibwxzc>
References: <000000000000d0a6c8061acd2012@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d0a6c8061acd2012@google.com>
X-Migadu-Flow: FLOW_OUT

#syz invalid
