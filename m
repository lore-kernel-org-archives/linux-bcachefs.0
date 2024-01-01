Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6391BE559
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Jan 2024 22:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jAvUnE/O"
Date: Mon, 1 Jan 2024 17:56:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704149788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=mmjj0zkrQcUPMX1VLKXfS70g05nb8oIYbi8BoZoX5YQ=;
	b=jAvUnE/Oefi+dy+c5Vgd2n2n6E8Vb8voTNmRAgjkWVXYJnLwlFnUBPa1+kpLi3/UbCp5sF
	NlpW/Or3IL1aPoI8p8Bj18rNZdYbINL1PkGU4eC+AphEviW3OOdVF7lFFGb5TtZdoIi4Pf
	iHBh3eJ3JL/W7YpBOLyH+A0h1AS7P1k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] bcachefs
Message-ID: <i6ugxvkuz7fsnfoqlnmtjyy2owfyr4nlkszdxkexxixxbafhqa@mbsiiiw2jwqi>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

LSF topic: bcachefs status & roadmap

I'd like to make this as open ended as possible; I'll talk a bit about
current status and work on the technical innards, but I want the focus
to be more on

 - gathering ideas for the roadmap
 - what we can do to make it easier for poeple to contribtue
 - finding out what people are interested in
 - general brainstorming

Status wise: things are stabilizing nicely (knock on wood, 6.7 about to
come out and then we really find out how well I've done); CI test
failures slowly but steadily declining and user reported bugs are
getting fixed quickly and easily.

Some performance stuff to investigate still - we're still slower than we
ought to be on certain metadata workloads, haven't lokoed at why yet;
fsck times can be slow on very large filesystems, and we know what needs
to be addressed there - but users seem to be pretty happy with
scalability past the 100 TB mark.

A good chunk of online fsck is landing in 6.8 - fully functional for the
passes that are supported.

Disk space accounting rewrite is well underway - huge project but the
main challenges have been solved, when that's done we'll be able to add
per snapshot ID accounting, as well as per compression type accounting,
and it'll be a lot easier to add new counters.

Some cool forwards compat stuff just landed (bch_sb_downgrade section;
tells older versions what to do if they mount a newer filesystem that
needs fsck to use).

A delayed allocation for btree nodes mode is coming, which is the main
piece needed for ZNS support

Further off: some super fancy autotiering stuff is getting designed
(we should eventually be able to track data hotness on on an
inode:offset basis, which will eventually let us use more than 2
performance tiers of devices).

Erasure coding will finally be getting stabilized post disk space
accounting rewrite (which solves some annoying corner cases).

Cheers,
Kent
