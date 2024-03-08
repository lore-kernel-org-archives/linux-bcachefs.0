Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD6291E
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709864178; cv=none; b=EwumbUVq3jT6+fmzQwj7mhnG4y92OfQnpQqGIJS6UDcHsIUZAGbTfgXtAgtjVD8Ef6Brjy2XUUFTGsPnhIda81NZ9gaapOYE3JQuwN6fLfEuXh1KuC7ZqjDZIMf0mI5vLnZ4E8cz1lkzuU3VWlZGgsmMlMDV4IFHp83eLnydTBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709864178; c=relaxed/simple;
	bh=F8yVwcwUhMdYpyoNjCbrQATc7YxQHdRop7Wg9KIOeVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRSijjPR+aSOb3+jdd753f++qEXIXlkHYJAInvw/nxx3NBORvmp/xLk/OTocN3Qr+P1vq9SLgZnHvDpPc6jbDlieyNlpy/8GLaJIDlQImP6pNvSL16xUmbGSAUImSD9dQNwgkos8GnN15f4891Gje5fCqDyV1sFIqQAEtH5wkww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tR259gx6; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tR259gx6"
Date: Thu, 7 Mar 2024 21:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709864168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QBWOWKm1iYzMC3NDh04sVaYnxhrTV2qNfOpvi6z74tM=;
	b=tR259gx6B3nAk5rDdpRTEqsojwbf7uybcJhq6R1tSNxDIOzONMnih1TlUQ105wmzat07G+
	/LwmHLg4QUYkyQOF5YCas2lxExwZ5Yirk3QejBJC5LOa0CDMeJnjDoiajt1zBsxmhr3iK+
	fOGTrbt7v/ojmYC+NGMThNKnbQbn84k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] make-release-tarball.sh: run cargo audit
Message-ID: <n6p6xwwrm4rusf2wjrhqromfajixigo5ddc3ma46ch3f3w7jhi@mwl3h25abthd>
References: <20240130070356.8174-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130070356.8174-1-ddiss@suse.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 30, 2024 at 06:03:56PM +1100, David Disseldorp wrote:
> cargo audit can be used to check bcachefs dependencies for
> vulnerabilities published in the advisory database at
> https://github.com/RustSec/advisory-db.git
> 
> Given the significant size of dependency sources (currently ~292M),
> manual audit is mostly unviable, so rely on this for now.

Not a good place for this, workflow-wise; I run make-release-tarball.sh
after the new release is tagged and frequently after the tag is
uploaded.

This would better be run as some sort of cron job that emails results to
the list when something is found.
