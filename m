Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qf1lh3O5"
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ae])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438BE10D
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 23:51:52 -0800 (PST)
Date: Thu, 7 Dec 2023 02:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701935510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BkONFho/w7ieKb4Y+QBWLxwYF2lgxNzbaLLiahpQ+BA=;
	b=Qf1lh3O5lcDPjO91tjeSLNpAvReUy7BpobKVsEDVbWH6t0rOoN49aC40fUDMnwby0NwDI2
	N8Hch5Z8iyhw4a3F6sSgfzVpgAlW2LJ/VW5jXdB4AzaBjpRS3WcB5jjAnSk+jd7lCD+A2W
	OvJ8nRg1b0Ax4l/UJcY0uRh4p4p1UrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Daniel Hill <daniel@gluo.nz>, linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools 1.3.5 FTBFS
Message-ID: <20231207075147.jexzitfswroaufn6@moria.home.lan>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 07, 2023 at 08:47:16AM +0100, Jan Engelhardt wrote:
> 
> With glibc 2.31, bcachefs-tools 314ce7d (tag: v1.3.5) cannot be built:
> 
> [   30s] linux/shrinker.c: In function 'run_shrinkers':
> [   30s] linux/shrinker.c:72:9: error: variable 'malloc_info' has initializer but incomplete type
> [   30s]   struct mallinfo2 malloc_info = mallinfo2();
> [   30s]          ^~~~~~~~~
> 
> This is a glibc-2.34 specific feature.

2.34 was released in 2021 - if you're on an enterprise distro, you have
my apologies... :)
