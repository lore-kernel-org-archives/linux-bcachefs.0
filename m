Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278C6185B
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Mar 2024 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710004292; cv=none; b=h2DnDXpFEicdTjngBjbqe1vl9VuNGs9RUbc3MwiY/7PpPki591LdZiMLjsrpIPVZkL+RqPmOLcqzgf9CAu1yNZKUbah1UGi3hbSwWfB26V4Puu/j3es2VZrpMA6ljw578od8v1NWjdm/BX56FIzxWvvk6vrW+neNC92qoeUBdrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710004292; c=relaxed/simple;
	bh=3IKo6eUW1qhuA3c2WioBZUmwkzLJT33gFnzMojKtdKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyBjjBMoJPTc0CTO5P0hlJlatXqZFfRoqTDs6gsFN68FOS4s0o1VpkesKXwSopiHsjetjpepDvUurvn7DtzLrHE18pqwVaWGXu8zaRn0C8k6ZFQ+Kr1mwqjrOac5LQ+FYSo0nCZTG1Qg2udBL6GQ3rA75SQNEraQ5wPVRpV2IXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LVXMlWMk; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LVXMlWMk"
Date: Sat, 9 Mar 2024 12:11:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710004287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYfd2noUPDlDAcvE5k6g33cmZjgACAciyuFWjaVcDso=;
	b=LVXMlWMkGNCc5LOGFO/mgtJIv5wDJbWvfLY+DgZOhPvdqmI7gXbiEStagS+HWujRAJWvHD
	4DbPfzdnznk/jwrwF78zmpQ9BVoKICzOQfY6E5nn69Yc50+Rhad7tN2qQ9ZGEIiPId+eY+
	PpbObp7d42KBL9LP2tpspOk5pvDfZcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alec Moskvin <list.bcachefs@e.netreq.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Kernel WARNING in get_page_from_freelist on Linux 6.7.9
Message-ID: <enefmzphksyx3nclbgf4imddmgoaxzwbpcj5esihmdewv4fqvh@rjil5nzhtwuf>
References: <20240309160907.GA3229@haswell>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309160907.GA3229@haswell>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 09, 2024 at 11:09:07AM -0500, Alec Moskvin wrote:
> Hello,
> 
> I'm getting the warning below when linking with the mold linker on 
> bcachefs. It's very reproducible, and seems to always be triggered by 
> ld.mold.

this was a __GFP_NOFAIL use or two we needed to get rid of - it's fixed
in 6.8.
