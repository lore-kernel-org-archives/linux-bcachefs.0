Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZE1mSmzf"
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662ECF1
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:07:54 -0800 (PST)
Date: Fri, 8 Dec 2023 15:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702066072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QoQD9wmp00HJH9bYvW2Cz3zDFlPptZlIxS6o4OSVhtg=;
	b=ZE1mSmzfHnFaXeu35Wf0HZEMaMsM18DRs3uhTaQJttvVx/Vm5MYulq3W/TIF7ZR9TO68Cl
	8bTUfgI8WYWXMzjZTjBNX7c/7zi/rykJjghbt9maWXhP782Wnxa324swZfbBaBa9ckgsp2
	cL1THNQQltJC2JWRnNvk5ShThGTccC8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Tero Roponen <tero.roponen@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs-tools: make 'all' the default Makefile goal
Message-ID: <20231208200749.3bspxuhhqzuhunde@moria.home.lan>
References: <6f10341f-a98c-67f4-e6f0-0b9284f9c35b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f10341f-a98c-67f4-e6f0-0b9284f9c35b@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 08, 2023 at 10:10:52AM +0200, Tero Roponen wrote:
> "fsck/bcachefsck_all:" coming before "all:" in the Makefile
> causes the bcachefs binary not being built by default. Fix
> this by explicitly setting the .DEFAULT_GOAL=all.
> 
> Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

Thanks! Applied.
