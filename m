Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A0B14AD02
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 09:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727949575; cv=none; b=Xe4KAcJqe18TuPLkeri1V61G1+gmKM2p0dVPMqb7K3BQ5UhYw1TNZ64dANWHC6aQ79sqqEKJkAv5yRaLvsn/ZXrBxQkZjWJFsnfHGINzt4eX59nRnc2+hrf/ocSleHrg3cPc+uuysH0DfTSdueXsCbhEVDWGyvnFG0cjqs+bKq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727949575; c=relaxed/simple;
	bh=ws++fftyryHhCAETNNzTX0HjvxlfudjsCorBxr25E9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuBqFUGKqSxwfRzlKrnLzHYJ25+JZ1rwwJJtrnJBBvBrK5oP7EUrmzGnVe8/ETh70cFxRdlg+sRWmXBgYPvpbM3ZsbNdMl4GC5dmRq9q6L5GLjAIX/SHJI6dxBbgosTfwsJJfA9ddfGv9HU9w7h/wfYNXmaOyF8iXk/J/C4ZxLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ixkIPFsQ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ixkIPFsQ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7db908c9c83so418931a12.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 02:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727949573; x=1728554373; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FZoVePEjRG3urznVwj0SIfeUiNk8Ws/Gg0iUzR96R7c=;
        b=ixkIPFsQcNrsGNxCOjHKFh2AFYRm6FRDqg2JkLijTz9+X1TrczYA0uAqvoOXekDvtG
         uc1VgRBOBHwZpTGKoDmUqRRmKo8j2AE6uL+NaAAdRxQaEyTlFy2wsgBNOScunA/XjWNH
         gemZhcos3TMMn3L9O6yIbHxpGeU3FbusIxMUhH7KBKexdojjF5c+d5yRtMR0+OxnPCPi
         gSc4pL5GgIgL46/ZL30Ztb7k+v/X3eNBx0FFpFeqZ3vDnqLiHolbYnYjbiUZJMhIvmIE
         S6urCvkJLyqxU+zcC7f6KGJDUpZ3mElBOM+RBG7NiD1IR1I27Vd2ikpJxaEmZaqZtSFM
         Uxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727949573; x=1728554373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZoVePEjRG3urznVwj0SIfeUiNk8Ws/Gg0iUzR96R7c=;
        b=tnZyOYpIJV/Ya6FlgwMyR3CFNzcMHl+RJyl/kxG3FKCzgFBnOckjqeBU81GUdWBQmj
         FqctKhMwn0BGkzLU+c5GLb3fhSmLftminmL6Lg4BhBhgFZbNpz6khBSN72QjfFBDXayd
         PcKgggGn9dhw1fIDovSY02uiuRdGu0LqZSvUoAd+B0mOI33ymhdKc1ctSH3dzWu3C7oG
         MEKAPXJf8rUxbnLOmts120s8X3JxYPJUrUQS4j6wF8q4hGee/WXWPP0atBSpeyqnw895
         vJih4jkA8HkIVlaqroJQZLkLtcPnqzonv2fB0PrXqsyxDol1W0Msi4CdIt65bUgXLr0V
         USkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsjFMvNhPKG0tSCkTSKyu4nU010JHE1zSw27jobj7VPCRAiOGhPgJqxBSpMkcEZ/R8pOXbptCD1VpZ/A98Yg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4RFAOy8lpM4ahVoJDrf7MC2N6b5ARwZ5pXLZZwG+MJIi+7TXa
	Hzm4yrf3nPd+U/auajDkXTGAK9PAumZqRpUoU3iT9hJR/7dPo4lfVAlJorHrijA=
X-Google-Smtp-Source: AGHT+IHRE80iIS0vtT8WICPYgmm1vV8aDhQHpiTupQ0As/uP52it766oR+Cw0QAYw1lPazD0ArHY1g==
X-Received: by 2002:a05:6a21:1643:b0:1d5:14ff:a15f with SMTP id adf61e73a8af0-1d5db20a5c0mr10402698637.11.1727949573106;
        Thu, 03 Oct 2024 02:59:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71dd9dee6adsm974968b3a.144.2024.10.03.02.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 02:59:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swIcL-00DL4k-2o;
	Thu, 03 Oct 2024 19:59:29 +1000
Date: Thu, 3 Oct 2024 19:59:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] vfs: improving inode cache iteration scalability
Message-ID: <Zv5rAYEgY3o7Rhju@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002-lethargisch-hypnose-fd06ae7a0977@brauner>
 <Zv098heGHOtGfw1R@dread.disaster.area>
 <3lukwhxkfyqz5xsp4r7byjejrgvccm76azw37pmudohvxcxqld@kiwf5f5vjshk>
 <Zv3H8BxJX2GwNW2Y@dread.disaster.area>
 <lngs2n3kfwermwuadhrfq2loff3k4psydbjullhecuutthpqz3@4w6cybx7boxw>
 <Zv32Vow1YdYgB8KC@dread.disaster.area>
 <20241003091741.vmw3muqt5xagjion@quack3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003091741.vmw3muqt5xagjion@quack3>

On Thu, Oct 03, 2024 at 11:17:41AM +0200, Jan Kara wrote:
> On Thu 03-10-24 11:41:42, Dave Chinner wrote:
> > On Wed, Oct 02, 2024 at 07:20:16PM -0400, Kent Overstreet wrote:
> > > A couple things that help - we've already determined that the inode LRU
> > > can go away for most filesystems,
> > 
> > We haven't determined that yet. I *think* it is possible, but there
> > is a really nasty inode LRU dependencies that has been driven deep
> > down into the mm page cache writeback code.  We have to fix that
> > awful layering violation before we can get rid of the inode LRU.
> > 
> > I *think* we can do it by requiring dirty inodes to hold an explicit
> > inode reference, thereby keeping the inode pinned in memory whilst
> > it is being tracked for writeback. That would also get rid of the
> > nasty hacks needed in evict() to wait on writeback to complete on
> > unreferenced inodes.
> > 
> > However, this isn't simple to do, and so getting rid of the inode
> > LRU is not going to happen in the near term.
> 
> Yeah. I agree the way how writeback protects from inode eviction is not the
> prettiest one but the problem with writeback holding normal inode reference
> is that then flush worker for the device can end up deleting unlinked
> inodes which was causing writeback stalls and generally unexpected lock
> ordering issues for some filesystems (already forgot the details).

Yeah, if we end up in evict() on ext4 it will can then do all sorts
of whacky stuff that involves blocking, running transactions and
doing other IO. XFS, OTOH, has been changed to defer all that crap
to background threads (the xfs_inodegc infrastructure) that runs
after the VFS thinks the inode is dead and destroyed. There are some
benefits to having the filesystem inode exist outside the VFS inode
life cycle....

> Now this
> was more that 12 years ago so maybe we could find a better solution to
> those problems these days (e.g. interactions between page writeback and
> page reclaim are very different these days) but I just wanted to warn there
> may be nasty surprises there.

I don't think the situation has improved with filesytsems like ext4.
I think they've actually gotten worse - I recently learnt that ext4
inode eviction can recurse back into the inode cache to instantiate
extended attribute inodes so they can be truncated to allow inode
eviction to make progress.

I suspect the ext4 eviction behaviour is unfixable in any reasonable
time frame, so the only solution I can come up with is to run the
iput() call from a background thread context.  (e.g. defer it to a
workqueue). That way iput_final() and eviction processing will not
interfere with other writeback operations....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
