Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1487E9
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 00:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717720270; cv=none; b=hrtf0zgeltmx+Wk5zeAzzQ4fntRHjL1xiAtOHMaofi97N9qzhL7Dlf5123WczhWOAQZt7NiqY/v/6JeGNNUMP3jFIz7ZEwDazD6ZWAOwhvYOcVv7APUJT1F2zDKzWIFp/71s98asj14FUWw+vqvEVfM9eJ5pPSsaxvizty/aEP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717720270; c=relaxed/simple;
	bh=qjXtJ6dwfmTnF2hNh+I19IqEEj0Q5ExNyiZFSZp1Irc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGMG+f6Oi5XDoc9YEBlbKVkSTLqmY2J/kOKydKcTjlfghP51f4sZ936eIaudiJ/XC2Dr1T5dsZwPhOe8dgbtZ4uS7WogwuaUMPOMp8BFOlb+3g9CWvswamPuFl/llOoDejo0t4YDqUAJh+6XqIuyH6TY72fZB/QkWmhJWl/W4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sryDWWhj; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sryDWWhj"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717720263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qjXtJ6dwfmTnF2hNh+I19IqEEj0Q5ExNyiZFSZp1Irc=;
	b=sryDWWhjaeamq7XWCt9NBpn+xpcoGBp4jGyBKy1FQEWSvzq8eK1zSAiSbP9iQkQG40pbMT
	OFs2JTbwbo7zF9YTmPhFizBqhLjUbIj1CMKeoop68PS+TGKYM0zxJ1gLKyrlmlHsBqRrRU
	n3905i2i1IG5m097c1o74cRT0Cn56rk=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Thu, 6 Jun 2024 20:30:57 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> So I tried out bcachefs again and it once more fails to complete
> parallel creation of 20 mln files -- processes doing the work use cpu
> time in the kernel indefinitely.

Hey thanks for the report - can you try my branch? It's behaving
reasonable well in my testing now

https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
