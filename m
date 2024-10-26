Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1517C
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 00:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729901656; cv=none; b=jAzwS3ajhhsqL0fplpi4V/P2D1wK3P4uhHBCsWGrRTG7O+OkgG6JRaIl0qeJ4JjuKUGJThmLVJz9zclJ3d+m1Nr+wUOzveImPP3DWIHGNUtV3LjqnJZFjKEIEnoPAZKvvOmBVsgkR1RYIp3BqJ6jEd3L1ZQ1GUBH0BdBcCUgRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729901656; c=relaxed/simple;
	bh=HMm+NkhmzZul+EacG1gnfloXwofA9wpUFm31clTgta4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IEFRbl1El45KXwUoNDTfdEwMVCMj2siMTJH0gHGHoI4KY4iv1CKvwggH59tckm5K8McFpmERa1tsuH2aRE/adcLfUqJl6tl9Jv5OC66T2502FKf3nQTdDeoq5z7JF0NdIGu9ng8P9lDMWexW967Q8MxFESq0NmKM7ECgj2TJrz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s3uh1VJp; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s3uh1VJp"
Date: Fri, 25 Oct 2024 20:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729901652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/fipsK6eJbgphiXcDbsGeQM/SCYkyDHOqibSnL4+pI=;
	b=s3uh1VJpdtVehN8edMp2V4UEkXnVxpmeGD4qba7XBCEHozig0QDsare5D4E6QJJcix3IEM
	rcI17GauSFo2tM3UQ2aezSxDT+HfoGQdnv4uV/XniCsIx9ZIXvmBf8pVUagvux/i5+zHHS
	kmePWrVqXIaw0R5kG2rjoRcUmXzWX/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, 
	syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
Message-ID: <plhmwoygvh6plwq3d42f6kriyb6fsripwpe2njxn3zdd7yly4y@j6dgwf2ihubq>
References: <20241023072024.98915-3-pZ010001011111@proton.me>
 <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com>
 <L78wBCQQaurE7tyQP_T2Fklx8afGKmTXxDh-gweSzakgUoCwjCYeMHINndXWj4LWdUFpOvynoYeKlE7N0rUMiXYEM_VLDye48iN5ysgM09A=@proton.me>
 <8aW4pK0ZSmglofzD-Ej0W2ClwAV-1qDS95_nUqwxsw_I4w6gERwlUN-uqb-n2fiMyh5r_1pzEj4vCIBLL5vSJAAnzqTgijxAHB2pRnIFNww=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aW4pK0ZSmglofzD-Ej0W2ClwAV-1qDS95_nUqwxsw_I4w6gERwlUN-uqb-n2fiMyh5r_1pzEj4vCIBLL5vSJAAnzqTgijxAHB2pRnIFNww=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 25, 2024 at 11:39:38PM +0000, Piotr Zalewski wrote:
> Hi Alan and all,
> 
> On Wednesday, October 23rd, 2024 at 10:06 AM, Piotr Zalewski <pZ010001011111@proton.me> wrote:
> 
> > Hi Alan,
> >
> > On Wednesday, October 23rd, 2024 at 9:33 AM, Alan Huang mmpgouride@gmail.com wrote:
> >
> > > On Oct 23, 2024, at 15:21, Piotr Zalewski pZ010001011111@proton.me wrote:
> > >
> > > > Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
> > > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > > bch2_bkey_buf_reassemble.
> > >
> > > It would be helpful if the commit message explained why k.k is null in this case
> >
> >
> > I will debug this more thoroughly and provide details. For now I see that
> > during GC it sees journal replay hasn't finished but journal turns out to
> > be empty? Which seems weird, so maybe underlying issue should be solved on
> > a deeper level.
> >
> 
> There is a clean shutdown detected during recovery. Journal has no entries 
> as it was confirmed by debugging bch2_fs_journal_start. seq and seq_ondisk 
> members are equal so journal is "quiesced". Also, journal_keys size is 0.
> 
> So in check_allocations when keys are being marked for GC journal replay is
> not done so it peeks into journal and there is nothing.
> 
> Now, maybe in case journal is empty during start, replay done should be set 
> already in bch2_fs_journal_start? I tested it and it fixed the issue as well.

this is "btree_and_journal_iter_peek()" - it's iterating over the btree
node and overlaying keys from the journal, so the journal being empty is
fine.

It's because syzbot is feeding us filesystem images that are broken in
interesting ways :)
