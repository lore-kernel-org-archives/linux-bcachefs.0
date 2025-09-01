Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0689B1F0E32
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Sep 2025 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756766015; cv=none; b=LZrcBso+XaCvD/kyT/9eLZV5gFR50aVql2bUYRa7f2q418R+Znffq4QgV7TnTcUgL33RDnec9Kcy0bpWATzBlGGd0SCzobZQMY/AmkP24JRZX0YG/WOZjMnIrv18Tw62LC1wVrT2dQ73FuLmRqvpuK4BF3VtWkNrl1UCKoNeVzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756766015; c=relaxed/simple;
	bh=qDuXoOnYnbBGssQRyNFHFBIdy7JQ98LpQdvtsWbDLeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0PCsHxg31FoGCHSuQctyvrOKKvQ/kQOmr8W4TUNcA8jpq493CGI51EH51p/CRJjKDx4nWh26Snqp2LlL145m5RtRBzjDfcfTVkWe0Uwom3OWxApVQa1Rw5kkhIm+evzBarezmRG1W+lkj73IHj4iCb+AvL4r9O190w/RKxhC/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AizUyaBU; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AizUyaBU"
Date: Mon, 1 Sep 2025 18:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756766009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AoCcoDap2qLsMinQLOQQHbYzW3fSJEkF5Q/vB6+VJH8=;
	b=AizUyaBU6LS2K4ITLnKkr3DeY7wwXs8SXlfVamEXrzogwjWnCg+fOWGEpWh8ggE7d1c6zf
	aQgE50kDFD2HK/a+6EhEr2nlnj/IA21304MGisUI7FpDw97xQpBQeWaUXS00l9KMB2ywTe
	66OjB+PdGDwJ9hVaeANU01W1BvYMLqg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: himikof@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 00/15] Accounting for accurate progress reporting
Message-ID: <wkwm5nxgy23v7oftqid5itkbqnlji7ujdpfogpkj3mo6ady7mv@3r5tninakioe>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 28, 2025 at 05:16:02PM +0300, Nikita Ofitserov via B4 Relay wrote:
> This patch series introduces new per-btree accounting counters and uses
> them for (hopefully) accurate progress reporting in recovery passes.
> Also includes various assorted bugfixes.
> 
> The commit "Relax restrictions on the number of accounting 
> counters" is optional, but will likely greatly improve the 
> upgrade/tools version mismatch experience. Without it, all bree usage 
> accounting will be thrown out and rebuilt on any version mismatch.
> 
> The commit "bcachefs_metadata_version_btree_node_accounting"
> introduces the format change along with upgrade/downgrade table entries.
> 
> The first ten commits are drive-by fixes/improvements, especially 
> "Improve check_allocations pass speed not in fsck", which should make
> future accounting upgrades much faster (including this one).
> 
> Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
> ---
> Changes in v2:
> - Reordered the format-change-dependent commits to the end
> - Added the new metadata version, upgrade and downgrade entries
> - Fixed an issue with hidden usage calculation after device removal
> - Link to v1: https://lore.kernel.org/r/20250827-better-progress-v1-0-74c24de7988a@gmail.com

https://evilpiepirate.org/~testdashboard/ci?user=nofitserov&branch=nofitserov

Every patch before "Relax restrictions on the number of accounting
counters" looks good according to the CI; after that the test dashboard
explodes:

https://evilpiepirate.org/~testdashboard/ci?user=nofitserov&branch=nofitserov

And those look like clean and simple bugfixes/refactorings, so I'm going
to pull those into testing.
