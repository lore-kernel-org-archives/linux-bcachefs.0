Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A91840
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 02:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cNrNMytt"
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA6130CB
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Nov 2023 18:50:26 -0800 (PST)
Date: Sat, 11 Nov 2023 21:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699757424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JRg0nYM3PYFyskGveZfOcBXNBJBHuLwIvGKuNCf3fWo=;
	b=cNrNMyttGdaomXUb45n01GUa2GSuog7uLlSmz0nLiFxXM6VlC+kMajpUiGYcHuIO6n+V3o
	1Mtc4d7FOzUGA1I7beXqeCpNdK1mC0oJK9VNdnNJDfZED8fCypv/xqIxAe2u6qLvvUErhn
	+VPhYSHb8kGSk/NUKK35Ol1Ovuixegc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel J Blueman <daniel@quora.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix potential sleeping during mount
Message-ID: <20231112025021.jcc6etc5jbqanm6z@moria.home.lan>
References: <20231112003841.20186-1-daniel@quora.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112003841.20186-1-daniel@quora.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 12, 2023 at 12:38:41AM +0000, Daniel J Blueman wrote:
> During mount, bcachefs mount option processing may sleep while allocating a string buffer.
> 
> Fix this by reference counting in order to take the atomic path.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>

Thanks, applied
