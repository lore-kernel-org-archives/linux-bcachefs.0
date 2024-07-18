Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29E1442E8
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 22:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721343189; cv=none; b=j41A+JQiQWfjH0bGOeSaI+9vkR06PTYv3vlIANXfE5AH4g3VGQcKP4uMLeqFGbyynjPCUI4Fsdaa1ULKdjAiOq1CkPTwLY278BNf+Vk+8pHjY1ecg4DnPH8IPrA3ApjqG6MqGnyEqHRu+t50j21rjMwfpGHvbcJoYo4WmEvhqVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721343189; c=relaxed/simple;
	bh=AVm8SI0fjYywF4iYnBFlunGk3WnzTcKRXdncLouDEAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gq/QA57jwhmiXiRSNK+VoYYUIZP0Ev747yzwJYIQBgc5b2gkVDtBJcFz7L8tqQaA+RWyfHZB5jbyGaoLQosGnovHa91v/hK7l58US/1yApBRopR943VoyNGWqqKjRTQRzcxQySLik6PYsgJy8Jd3VwwH0V1LRV0H/jIELB7fbKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AuWDl9fW; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AuWDl9fW"
X-Envelope-To: cam.alvarez.i@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721343184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JA06MH+KNmFQt3EUPEC0LJkWEBAq7MbGXfaNNkQ6iRs=;
	b=AuWDl9fWlF3sB1bW4dNs6CMCHPSiyNbLc7YEs+so/QkAcT8+1X3Ezv6q9aYwpZ/29R6y3A
	QVC+w/6L/I1k3/KzlZeWMGyz8ZgT0IHxZ5i0Hhznrb52d2F8vAz4Xx13HSC2s7TxJDZptA
	QWQdQraG2hYEPP7Tai4EA4/brze+Gvw=
X-Envelope-To: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Thu, 18 Jul 2024 18:53:02 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
Cc: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
Message-ID: <6cysckb2o54lmg27htyr67mogkprkqjfipmws27fp4rhe3wxwm@edgdbatbeahw>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>
 <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x>
 <6d42612b-1c20-0484-ce9f-eac509e6740d@macbook-pro-de-camila.local>
 <f6lmsdtntfs3ot4jc2waizihayhipszr3iuro3tzyjgbfvjwuw@ms4foq466yiz>
 <d25b7319-5b16-da76-6f07-226d1da11e16@macbook-pro-de-camila.local>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d25b7319-5b16-da76-6f07-226d1da11e16@macbook-pro-de-camila.local>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 06:49:02PM GMT, Camila Alvarez Inostroza wrote:
> 
> 
> On Thu, 18 Jul 2024, Kent Overstreet wrote:
> 
> > On Thu, Jul 18, 2024 at 06:42:55PM GMT, Camila Alvarez Inostroza wrote:
> > > 
> > > 
> > > On Thu, 18 Jul 2024, Kent Overstreet wrote:
> > > 
> > > > On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
> > > > > last_seq and last_empty_seq suffered from an off by one error when the
> > > > > journal has no entries.
> > > > > 
> > > > > The indexes were fixed and an assertion is added to check that the
> > > > > last_empty_seq is always kept under the next valid seq number.
> > > > 
> > > > oh nice. I'm going to need to stare at this some more, I still feel like
> > > > this code needs to be clearer and less fiddly.
> > > > 
> > > Sure! Please let me know if there's anything I can do to help.
> > 
> > I'm just applying it - the warning you added gave me warm fuzzies.
> > 
> > I'll let you know if anything pops up in the CI (and I should give you
> > an account so you can point it at your own branches; email me a username
> > and ssh key)
> > 
> Should I give you the info in this same thread or in a separate email?

doesn't matter, ssh pubkeys aren't secrets
