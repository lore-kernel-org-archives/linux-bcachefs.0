Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A654AF64
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Dec 2023 23:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LtNj3s5H"
Date: Wed, 20 Dec 2023 18:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703115968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8QDfBjz7OeStsSM9er7ZB0JZevIxXMx74euRfDLa3zg=;
	b=LtNj3s5HGOrNolCMzyzKAy2xDFgvyFZBJ0x1kKPYWOeX5Fr7CaUKEbroqaxAgFoj+gR1Ff
	BmtmqrZ4IqxoLAPITTXQo+IpqCatEmt+tmOKwsT/NdvKOiRdiU+jwFZ+Z1cjl/w0ghl9xq
	FjINyooFQnNUURVIHC08vba91v/iGRI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH TOOLS] remove Rust artifacts during `make clean`
Message-ID: <20231220234606.7drdgkhahjduftir@moria.home.lan>
References: <20231220220228.92605-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220220228.92605-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 20, 2023 at 03:02:28PM -0700, Thomas Bertschinger wrote:
> This should use `cargo clean` instead of `rm -rf ...`. Also,
> due to a typo, the `rm` did not actually remove the Rust artifacts.

Applied!
