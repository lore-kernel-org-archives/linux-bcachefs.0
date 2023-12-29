Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137C12B92
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 18:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qVZXoIN7"
Date: Fri, 29 Dec 2023 13:48:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703875738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KP1PoXFv16lzBJHjSHOI+b7ak13VlJyMhJGLBGgsMzw=;
	b=qVZXoIN7gWn7GdtqboHbCpexDLQyco2OXOpVV8NWYbP/FnfHba19sQ1F24vy03hs3l4YEk
	YK8OddBZMnY7aFlZ+h/6zkiVxRlp2we1IfB76+2muPxgxQr9UQ9A/0TehQX0sdASF2bNS5
	56L3RF5DFhT8jExvBkS9OqjppOIFaNY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: deletion time of big files (was: Re: Questions related to
 BCacheFS)
Message-ID: <acpcgunii76iwukjkuqdx4q76ee3b4ohr5lcr5akcsjgscdsra@mxc5l4wlj7kd>
References: <23311511.6Emhk5qWAg@lichtvoll.de>
 <20231118195024.qe2bjxeubhru3de5@moria.home.lan>
 <2210413.NgBsaNRSFp@lichtvoll.de>
 <1903513.CQOukoFCf9@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1903513.CQOukoFCf9@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 28, 2023 at 11:29:19PM +0100, Martin Steigerwald wrote:
> Hi Kent!
> 
> Martin Steigerwald - 18.11.23, 21:57:50 CET:
> > Interesting. Only thing regarding performance I noticed so far that
> > deleting an almost 8 GiB large DVD ISO image file took a bit longer than
> > instant, but I was using Dolphin on Plasma, so not sure whether this
> > tiny delay was filesystem or GUI related.
> 
> Meanwhile I have a working BCacheFS test setup on my laptop. Currently 
> with 6.7-rc7.
> 
> I can confirm on the longer than instant deletion times for almost 8 GiB 
> large DVD ISO image files. It took 3,4 seconds for two of them.
> 
> It appears to me that there is some optimization potential hidden in that.

Bug me again in a few weeks/months if I don't get to it; Dave's fs
metadata benchmarks were also pointing out things that need to be
opimized as well, this is probably related - but I'm going to be deep in
the disk space accounting rewrite for a good while
