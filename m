Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F525E062
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149551; cv=none; b=awpuVwjGKF2Bz877Gw7CLkeeAw5QJg5dHfwIbJMZqqP+xV9bFHGoBlLco51Ea3jkMJM7Cq0IsqvDNcWm/FxTESyf00n+kOkL3IR5r8tGA2EUDinlvAVaFjjfEkAfnMT6Fm4Aoc0bwiewrc7fEoFb8/ZinkvljIIuP962TxrwETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149551; c=relaxed/simple;
	bh=4KtoiOCRcnMs/t8SpfAByiaZPoCcTce60WrsM/VMfb8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=i8En+th2Zci4EZuZX27tirRGbRZ18+U3+eHOOVg4U1il0dUMVxrxKmPZwRM87KFLNF1YyTWm5Hdv9mMW3OOyYK8hYz1WtSZearDhHILihjB0DFeOnYb9zV9cKkRz3odNwFHIefm7VoERAPndCGB8GD8oRB9JFGb48ilNHcFBXSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlyD7u4x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlyD7u4x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709149548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=E26FpUYmxrZfX/kO+jawlBkMusj190683O0wMzZqoxc=;
	b=RlyD7u4xmvstXY+A2Mqots3jcnGy+yvZmcWFLpGRDl7LyHADByCnmBjb1gn0nbTMydfe/j
	y3OilrfZe31XBQaXlqUtWaVeRB3cxMjCoXr5pvJHt0DIRvRclCbjEMEH6vOzcJjqSU1kFj
	PpB0FePlZKQmGnbAK5//HwYLR134k84=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-zOFS1YFpNyyXN3zeSRcdHg-1; Wed,
 28 Feb 2024 14:45:44 -0500
X-MC-Unique: zOFS1YFpNyyXN3zeSRcdHg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CE071C05AE9;
	Wed, 28 Feb 2024 19:45:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.137])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4996D492BC6;
	Wed, 28 Feb 2024 19:45:44 +0000 (UTC)
Date: Wed, 28 Feb 2024 14:47:26 -0500
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [BUG] bcachefs fio lockup via generic/703
Message-ID: <Zd+NzotWTooA/9zq@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Hi Kent,

Firstly, I confirmed that today's master seems to avoid the splat I sent
previously (re: your comment about a reverse journal replay patch or
some such).

I still reproduce the stall issue on this system. After peeling away at
it, I was eventually able to reproduce without the drop writes
(dm-flakey) behavior from the test, and with fio using either the libaio
or sync I/O engine options. The sync I/O mode fortunately provides a
more useful stack trace:

# cat /proc/177747/stack 
[<0>] bch2_dio_write_flush+0x122/0x160 [bcachefs]
[<0>] bch2_direct_write+0xb53/0xce0 [bcachefs]
[<0>] bch2_write_iter+0x142/0xc70 [bcachefs]
[<0>] vfs_write+0x29b/0x470
[<0>] ksys_write+0x6f/0xf0
[<0>] do_syscall_64+0x86/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

... which resolves down to the closure_sync() call in
bch2_dio_write_flush(). The problem seems to go away if I remove the
preceding journal flush from that function. This seems to rule out
io_uring/aio and instead suggest that we're getting stuck somehow
waiting on a journal flush.

Based on that I went back to the first commit before 746a33c96b7a0
("bcachefs: better journal pipelining"). With that, I can run hundreds
of iterations of generic/703 without a problem, so this appears to be a
regression associated with the journal pipeline improvements. I'm
currently re-running on the last known good commit with my test tweaks
backed out (i.e. so back to io_uring and drop writes) just to
corroborate that it's the same problem, but so far it's running as
expected...

Brian

