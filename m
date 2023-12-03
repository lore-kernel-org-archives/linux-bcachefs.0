Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UvLu7ebd"
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E24BC8
	for <linux-bcachefs@vger.kernel.org>; Sun,  3 Dec 2023 09:23:57 -0800 (PST)
Date: Sun, 3 Dec 2023 12:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701624235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IroTRZdUSPUCLdvLfSW5Jl91KxOk1UokamdB8F2kgkQ=;
	b=UvLu7ebd9y8AdgEdSsw8IUjgi9Z2p4UmPPekvSqxkT5UFVfnWO6Lr1LueitIIPLIKtdpPc
	ZIVZ899JamB4c84F1Oj4g/lHZJF3//WaBnw11puFsNo2gXh3Qh6WLdNDAQsBbNio4YGmLv
	uB7A06t2AkhCi2hlU1RM95NkO4dawgk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Richard Davies <richard@arachsys.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Remove obsolete comment about zstd
Message-ID: <20231203172352.ttlo5ndj67gajccd@moria.home.lan>
References: <1701612627-9182-1-git-send-email-richard@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1701612627-9182-1-git-send-email-richard@arachsys.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Dec 03, 2023 at 02:10:27PM +0000, Richard Davies wrote:
> Remove obsolete comment about zstd, since approach changed during
> development of commit bbc3a46065d08f9ab3412b1f26bbfa778c444833
> 
> Signed-off-by: Richard Davies <richard@arachsys.com>

:) Applied...
