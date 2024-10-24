Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA99618784C
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 21:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729805273; cv=none; b=CAKK7wQDUeJw8hrAy/B3rU59ixA5Qyz50Cb2oHmtyPTA5LTCr+d/itVV8AJlMUXlqOdiBFvt8olsY/bUP4nyr9x24ENGv1MIi7w4DuJqTwREsQKAghwctlzOYOKPYmZNftWKYxirQBSSjBvhpePRrEZCJpiJULv96++s1JdceCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729805273; c=relaxed/simple;
	bh=LlCIZy5kkQMqbaFoCv52ATMvnhzvlPKL3yeSshrBdUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjNjO1zEx5+qK1aB3VFR+URVKsEPpGSOf/yuL8yhZwBwO2PXSxK0AiZ/AlQ/4WIQSmW3vOLJzxhhi4z7bI/Ie7Qxfh7XCE9hWQfVf0So0XTHtfRzjSedhmMBbLOi+dnrrrGxLYYThapz9vvLkapEr+8TGKatNRtOeiWWatmQ5aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XXRkca1E; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XXRkca1E"
Date: Thu, 24 Oct 2024 17:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729805267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlYuM3A/+tIrtfK6Qs9gHAgEUkDD4An6uXn9WKx1GNw=;
	b=XXRkca1EkNR5puIU2w3t1BOOZaU2+LFSoXPwQnXgBrso6mFIz7MmbKj+hPj15W7luilotc
	sv8TpoWuZ+vaINFaME/nrsgWBqRIoVwDL2Sy7b8l5Q09umxw8kQ5dm3GPZd3ZTb8TW9PFu
	sY4jlCcVMzGbO7jmYT/GERoQyvMg73o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: ahmed Ehab <bottaawesome633@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs extent_entry_type setters
Message-ID: <fq2lvhpcdvf2paw7rfevnxburrlqmkc2wcjy2gyvuzhmmk5on2@hv246xqwnvft>
References: <CA+6bSavLk2wt=Q0OM7n4Z_XoR8jxwUue9LZ-qpQRZQLbig_4PA@mail.gmail.com>
 <5ai3oretd6friswe3dgn7qbibcbghom6uwytf6y4zcghzlzc5d@cyxx7w7qz4uz>
 <CA+6bSavtBTYXCYG_opO5sxKnATyWerDnfO0WZRZy6wB1YCJC0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+6bSavtBTYXCYG_opO5sxKnATyWerDnfO0WZRZy6wB1YCJC0Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 12:10:48AM +0300, ahmed Ehab wrote:
> On Thu, Oct 24, 2024 at 6:35 AM Kent Overstreet <kent.overstreet@linux.dev>
> wrote:
> 
> > On Thu, Oct 24, 2024 at 01:50:15AM +0300, ahmed Ehab wrote:
> > > Hi sir,
> > > I am currently working on a bug related to invalid extent_entry_type. Is
> > > there a place where we set this type for a bch_extent_entry? I found a
> > > method for crc type but I got no luck finding a generalized method for
> > this.
> >
> > There isn't a general method, no; and perhaps there should be, like we
> > do for bkey initialization.
> >
> > What are you seeing?
> >
> I am working on this sykaller-reported bug
> https://syzkaller.appspot.com/bug?extid=4f29c3f12f864d8a8d17. The failure
> happens because there is a bch_extent_entry with type = 2165668814409170944.
> This results in __ffs(entry->type) = 36 which is bigger than
> BCH_EXTENT_ENTRY_MAX. I think we might need a place to initialize the type.

No - look at the codepath; this is the big <-> little endian conversion
code.

The issue is that bch2_ptr_swab() has to work on keys that haven't
validated yet (because we can't validate them until they're swabbed to
native endianness) - so bch2_ptr_swab() needs to cope with that and do
its own validation.
