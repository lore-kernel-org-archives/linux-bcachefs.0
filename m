Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68F10F7
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Feb 2024 00:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708822349; cv=none; b=UUb1WwjlU3z9T0meWZ8G5KGChFUc6dvzwtV934vbWgpkN+80nAi1oxePWet0TH2+CIgSDLtO83G3QiwRYh/yJ6AnVD32gXJhn1d8n7/gyJaCH3pn/aZJ4SpU5veerO6JBBrb5hWDApIIhIBuZV56pO2LIbQi9qrBCM+8pban9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708822349; c=relaxed/simple;
	bh=ftZtns3qGmb9r2WveXongU4udenzPbV4fOt/bbe+hF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAZQmr+Q9GmBOG4IH5lDWgbDBGfjxvm+Qy2BDfg8FTUTmfzLwBi+ePuo4OxmMpKVDY8WbSWuIua2o2zcaqjZ8yvVcolRKXkUwLFmZgrVKVPup+zp2Y/xEufgQK44dEyLeaS0GjfotZoFBg5kZOeaG7XxiOlvDzvryMGn19o5mT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wjSOZ0LU; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wjSOZ0LU"
Date: Sat, 24 Feb 2024 19:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708822344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6C+8ude/+IwsBnI5QizZR0SvU1w8AEuhKPokRHqFkIg=;
	b=wjSOZ0LUZGu35THtDakv4UCym4yNrece0LcspfXPSsh3m+TTxh0zFDkrhEBRRv9Da+CSuU
	YKcHZ+vhClBiXU8LANlMPV/ipp+xI2J1fYOYFTZw2ihOy6ahBhVi6VE4cafp+NCmBFltXp
	ElO5vHtIjYRWcc7+TRIYg6LiStB91Rw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Erick Archer <erick.archer@gmx.com>
Cc: Brian Foster <bfoster@redhat.com>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Kees Cook <keescook@chromium.org>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Prefer struct_size over open coded arithmetic
Message-ID: <2ysy6s2on7ae24j7tiwpwp6vp33gqvn2apqhprnvip6lzqxdao@p73c3ukzvcjd>
References: <20240224151658.8272-1-erick.archer@gmx.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240224151658.8272-1-erick.archer@gmx.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 24, 2024 at 04:16:58PM +0100, Erick Archer wrote:
> This is an effort to get rid of all multiplications from allocation
> functions in order to prevent integer overflows [1][2].
> 
> As the "t" variable is a pointer to "struct journal_seq_blacklist_table"
> and this structure ends in a flexible array:

there's no reason to break these out into multiple patches, just send me
a single patch when you're done - thanks!
