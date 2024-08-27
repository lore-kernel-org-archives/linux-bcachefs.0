Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439E2182BD
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724729400; cv=none; b=fiJZzCFZogWUiAXzRYd97MLioLjJEzcoZiu+BmiI8bF3aW3Rn8Of+b28HdRyTjvF+qM262gGAKYU1WF9Tc8j1BxBzrivGUNAGc7yt6FMgXvLb5slN+DXzJQR0Gjlwo7fLeaG/wLVMuGLHfM3MH7FG7dd4/SDRsui4nYneA4sFxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724729400; c=relaxed/simple;
	bh=WKIOaTG/O7gm+4/VSs3liOn/sNcWabSkU8R9R2Wzwc4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BiNqCpgWKDKmZbJWnpwsMvqxRq9DqqiZdVCtoNnX/qSsr0vjG+YgZzULzFSMAeeUWhbKkllC/7QdPfLqvkV+j4mUJTPs9Hp1uXwWfPrcUQoqAfOCyAWzATC8dLHlUOmW7c/NEhIY1Yb+/NJBJJJPeQM16WFsAcfsXes1stzHKrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i8xcbSD1; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i8xcbSD1"
Date: Mon, 26 Aug 2024 23:29:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724729396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WKIOaTG/O7gm+4/VSs3liOn/sNcWabSkU8R9R2Wzwc4=;
	b=i8xcbSD1ASqsUiZOK46wyT2H2y2KvX+yFJtQNePtQ8Jhn/SeA770yXrIrhJdqoP9xMD2qC
	DISxxYz1yd34hv1DRkXqrnKCS+gNxCY/JwgpU6yYnllUYTLfiaKvLLoo35WY+ECvHo0DWR
	+zAXU9wG/OplzgB1NY2W3hNLUH3afng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-bcachefs@vger.kernel.org
Subject: bcachefs dropped writes with lockless buffered io path,
 COMPACTION/MIGRATION=y
Message-ID: <ieb2nptxxk2apxfijk3qcjoxlz5uitsl5jn6tigunjmuqmkrwm@le74h3edr6oy>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

We had a report of corruption on nixos, on tests that build a system
image, it bisected to the patch that enabled buffered writes without
taking the inode lock:

https://evilpiepirate.org/git/bcachefs.git/commit/?id=7e64c86cdc6c

It appears that dirty folios are being dropped somehow; corrupt files,
when checked against good copies, have ranges of 0s that are 4k aligned
(modulo 2k, likely a misaligned partition).

Interestingly, it only triggers for QEMU - the test fails pretty
consistently and we have a lot of nixos users, we'd notice (via nix
store verifies) if the corruption was more widespread. We believe it
only triggers with QEMU's snapshots mode (but don't quote me on that).

Further digging implicates CONFIG_COMPACTION or CONFIG_MIGRATION.

Testing with COMPACTION, MIGRATION=n and TRANSPARENT_HUGEPAGE=y passes
reliably.

On the bcachefs side, I've been testing with that patch reduced to just
"don't take inode lock if not extending"; i.e. killing the fancy stuff
to preserve write atomicity. It really does appear to be "don't take
inode lock -> dirty folios get dropped".

It's not a race with truncate, or anything silly like that; bcachefs has
the pagecache add lock, which serves here for locking vs. truncate.

So - this is a real head scratcher. The inode lock really doesn't do
much in IO paths, it's there for synchronization with truncate and write
vs. write atomicity - the mm paths know nothing about it. Page
fault/mkwrite paths don't take it at all; a buffered non-extending write
should be able to work similarly: the folio lock should be entirely
sufficient here.

Anyone got any bright ideas?
