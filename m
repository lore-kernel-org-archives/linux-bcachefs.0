Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD4F1EF0AD
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Apr 2025 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743781010; cv=none; b=stw+4sJGk6YTF+Q0yTG1y+i0CpWRbWkBtJHa/RfO3vqoZZuGVr9aV5zkh64jZZz46rSemzQQz4TfGsBz8xVLc7Pyd96Ri3B6lgEfhdt0WqXNTSI8B9IxEyheMRF6qA9pu1lORtAlpQXJd1WbG5pm8EWenXkiUXo0Rvbtc9Pl0J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743781010; c=relaxed/simple;
	bh=Wm0hlOk2KjnydJuWr4Tp+yAP5KMUtZGePGoHip7UhjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeP8hcXCxZdqdk3zDQtnJ5Ms3sh3jLYNM8BpS2z+TxXUel7NKBP/i+dKLERCFKR3m2DyB3PJSSak9ThjT/+EjLdSUu2WH+eyQMvWlUvkJDF68LFtWWhCQ0Ps2qzAF3M9Yj0yxhRNsUmQ1xABZE7PBgYL8vh+9p5wb2pXEUiW+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kozys/Ds; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kozys/Ds"
Date: Fri, 4 Apr 2025 11:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743780996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s4sptiDS64TqakxXpUmcHXO8tnkrK0BIqcsdKGFEneU=;
	b=Kozys/Ds7/cg6lJiuP9pxF9pevq4wb5QSquXowWNSK/3r/thjFBnegULAihzhspi5PSuJH
	ryd9tEkOfDKiFseeiNb/uCMcURT7IlHxZIS/3NwP6TzCs2JLRjIIRypw87bfMuyOVGZSMw
	bhWzTBj9OqnQLGrPoZTwTZHHJYTvWNA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: don't call sleeping funcs when handling
 inconsistency errors
Message-ID: <6jgqlz555qrn3l34e45nc6ubg53ydtzh6l7ghra7od2xjctugp@ztmjdn3cwt6h>
References: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
 <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
 <CAPZ5DTEGi8RXBMui823bwnt96PcqZSavH8AQ+LPhRs=sJ-Br1Q@mail.gmail.com>
 <ciw5ocj6io5q5p2tsv3sqpga2ff73eqwhlrrug4el63ggolcho@iviprrqsaemj>
 <CAPZ5DTGWC2Xemgby9E8EL61Vio0NYQrKBd5FNpvERwwBoEP8tg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPZ5DTGWC2Xemgby9E8EL61Vio0NYQrKBd5FNpvERwwBoEP8tg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 04, 2025 at 12:22:45PM +0530, Bharadwaj Raju wrote:
> On Wed, Apr 2, 2025 at 10:08 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Apr 02, 2025 at 10:03:10PM +0530, Bharadwaj Raju wrote:
> > > On Wed, Apr 2, 2025 at 9:47 PM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> >
> > If you're feeling particularly adventurous - print_string_as_lines() is
> > a hack, I think we should be able to do something more robust by
> > skipping printk (that's where the 1k limit comes from) and calling
> > something lower level - that will require digging into the printk
> > codepath and finding lower level we can call.
> 
> I tried looking into the printk codepath, namely vprintk_emit -> vprintk_store.
> It doesn't seem like there's a convenient single lower-level
> entrypoint we could
> call which just avoids the 1k limit, rather there's a lot of internal
> code mixed with
> the truncation that we'd have to just copy if we want printk behavior.
> I don't think that's a reasonable option for us.

Yeah that does look a bit messy - and it doesn't exactly explain where
the 1k limit comes in.


> > I also just noticed that print_string_as_lines() needs to check for
> > being passed a NULL pointer - in case the printbuf memory allocation
> > fails. Want to get that one too?
> 
> From what I'm seeing __bch2_print_string_as_lines already checks
> for the lines pointer being NULL. The only unchecked pointer is prefix,
> which I don't think needs to be checked since it will be something constant
> from kern_levels.h, not something which could be NULL.

Yep, I should've checked the code before I said that :)
