Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26415B122
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 09:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717751640; cv=none; b=lzXzBp7oQyPvC6lAf46C7yrg4ECpuDQQygZvS/1oe8Xepu10kE7gAlEYITthQ0I12Zux+MV7GsCxNMPZFUoRVLpIuH/Q0YoAM65rg4dJj5mYlx6C4ElvJARaBu6RZo2elI7rX5uScQ8jzovHWohn5uiLPnyPQi84HbJdFGnZToE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717751640; c=relaxed/simple;
	bh=4JfxDhUDJcWg2AfHjmYAMq2iQyR3y/kGxC93QYo0p94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llWldk9mRM+e7nii62dUq+Kilawb2XukWfpPwvxKEertAa0Z4KnpFV3AYMV+tIVwXww/+2B4xMKZzo2ZWKPbuG7Hl8QS8XvwutgR5MXBiKsVAZAr7euB2xehOQYF61HQHSeSk0zwY6QkFcpIoVhDmqN97kDVJlrVblvYEBfej0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qzMatOIY; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qzMatOIY"
X-Envelope-To: mjguzik@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717751636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fI/WKZRIybip19nzrgt7Fhaj4QVSy4OBy35Uy+M4500=;
	b=qzMatOIYgOdPdG53vGrrhTis9NgaGBrfGEPAnJDOTdjgmJ4Fk55E2YHLxJZbljDQAAHZ0I
	ibe4GbFolINAzxkUlmmieToEOUkctZcPwj0rTWdhDo6OA16jOmFjH6ucr9gqThZ0rE0ZXo
	9PpjgyH23swbUSgLkJDqh5f7+KKntp4=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Fri, 7 Jun 2024 05:13:52 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
 <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wrote:
> On Fri, Jun 7, 2024 at 2:31 AM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> > > So I tried out bcachefs again and it once more fails to complete
> > > parallel creation of 20 mln files -- processes doing the work use cpu
> > > time in the kernel indefinitely.
> >
> > Hey thanks for the report - can you try my branch? It's behaving
> > reasonable well in my testing now
> >
> > https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
> 
> No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d8959f5ce9

That commit completely fixes the lock contention on the btree key cache
lock I was seeing before, are you sure that's the commit you were
running?
