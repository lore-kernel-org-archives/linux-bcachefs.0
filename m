Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xUMKPruQ"
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2491ED59
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 00:14:05 -0800 (PST)
Date: Thu, 7 Dec 2023 03:14:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701936843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+z9iEkOq0fQz1oXohFE/W33irfRU7Sr9dzUkdwAxT2w=;
	b=xUMKPruQV5lP0d3nhf36Ufw9GDIzJnCvBzzUc32k7gwM3uiXFsRHxiGp+KFkA4BK3tbDnV
	Egkeqyo+qn9yH7YOangDrAb+U0E9ixn3AxvLFcT3yC4dqLSxtpIDG84jgggQ4FodsWG1iP
	1HvW8Trpah5mEj6lQWHz+tT9MnA4PJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Chris Webb <chris@arachsys.com>
Cc: Jan Engelhardt <jengelh@inai.de>, Daniel Hill <daniel@gluo.nz>,
	linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools 1.3.5 FTBFS
Message-ID: <20231207081401.w44znpjbndiomrg4@moria.home.lan>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
 <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 07, 2023 at 07:53:29AM +0000, Chris Webb wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
> 
> > 
> > With glibc 2.31, bcachefs-tools 314ce7d (tag: v1.3.5) cannot be built:
> > 
> > [   30s] linux/shrinker.c: In function 'run_shrinkers':
> > [   30s] linux/shrinker.c:72:9: error: variable 'malloc_info' has
> > initializer but incomplete type
> > [   30s]   struct mallinfo2 malloc_info = mallinfo2();
> > [   30s]          ^~~~~~~~~
> > 
> > This is a glibc-2.34 specific feature.
> 
> It's glibc-specific too, so it'll break building the tools on on musl
> distributions like alpine and void.
> 
> I don't remember compatibility problems with musl when I last built and
> tested a few months ago, so probably a relatively recent and localised
> regression?

yeah, it's a change Daniel made to speed up memory allocation -
mallinfo2() is way faster than reading /proc/meminfo, and it's an
important improvement since right now fsck performance is still quite a
bit lower in userspace than in the kernel.

If you know of an equivalent interface on musl...
