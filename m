Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OqRl/KYJ"
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bd])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C642129
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 11:12:40 -0800 (PST)
Date: Tue, 5 Dec 2023 14:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701803558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DG1HmjIQsw/ozHk+cGHPnE6F9mBPjgKbZKMNLGo8wRg=;
	b=OqRl/KYJlvvBSvb8tHgm8b4RUyOtrZIi5aPIp6XmBFOcfTH/GFsaP6gtpwOSboHjToApmh
	bBj20P8gejKyjqTOFJ3bMqffyYgy1mNdJNJJnKKd3hi/5MZBqaAiZHp5QGgdXEhvM555DH
	GtnUpwwMMyJk1/SnrDMFrJPhPGGfnRE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: return from fsync on writeback error to
 avoid early shutdown
Message-ID: <20231205191235.jrrpbwiznuajaqmc@moria.home.lan>
References: <20231205132439.130755-1-bfoster@redhat.com>
 <20231205132439.130755-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205132439.130755-3-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 05, 2023 at 08:24:39AM -0500, Brian Foster wrote:
> When investigating transient failures of generic/441 on bcachefs, it
> was determined that the cause of the failure was a combination of
> unconditional emergency shutdown and racing between background
> journal activity and the test switchover from a working device
> mapper table to an error injecting table.
> 
> Part of the reason for this sequence of events is that bcachefs
> aggressively flushes as much as possible during fsync(), regardless
> of errors. While this is reasonable behavior, it is technically
> unnecessary because once an error is returned from fsync(), the
> caller cannot make any assumptions about the resilience of data.
> 
> Tweak the bch2_fsync() logic to return an error on failure of any of
> the steps involved in the flush. Note that this change alone does
> not prevent generic/441 failure, but in combination with a test
> tweak to avoid racing during the dm-error table switchover it avoids
> the unnecessary shutdowns and allows the test to pass reliably on
> bcachefs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied
