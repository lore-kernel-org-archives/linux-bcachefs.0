Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fXEjT5fu"
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E87F137
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 18:49:15 -0800 (PST)
Date: Sun, 19 Nov 2023 21:49:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700448553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8blsYMuTrI8HtPrYMkHvo3K67daG+QtGQ7YVITsqp8=;
	b=fXEjT5fum01B3IeBdXHkGyodTKodd+SjfkUbw9pp8M/tj1+5fQrERFP0Drc8gZ4SF0FJA+
	ikWJQochMB5JcvGeUQ7RIBdo4FAq+v1D0OJnV/b7CQxbxa0v+gejJVJ6XwtqApyxfk5WGR
	mLNxL/NeJXtUyXsvplc6mb7/j8uQqJQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v5 01/10] Increase cross-compile compatibility
Message-ID: <20231120024910.lawhwygusscc2t46@moria.home.lan>
References: <20231119160155.34496-1-janpieter.sollie@kabelmail.de>
 <20231119160155.34496-2-janpieter.sollie@kabelmail.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231119160155.34496-2-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 19, 2023 at 04:48:08PM +0100, Janpieter Sollie wrote:
> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> 
> Some user distros do not use standard triplets, but instead, the triplet has another name.
> Move the triplet name into a gitignored config file,
> and fix a few trivial error messages breaking a cross-compile build:
> - use headers-generic instead of headers-$arch
> - if ulimit isn't set, don't do it.
> 
> Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>

Applied
