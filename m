Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED98F1DE4E1
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752787204; cv=none; b=HYdg0JmTE2l3II1nLEEa1P6LJ9WGghttm1hStJDAX8MoHHKE+0br+cdCJzxv1afs03ZRzn5ih/PUml26haZSuOju6x/RzWvsbKv8pGjHOzTwFhMtC+Wk5hjHfZUikPG+wwBCW/XExSYaVpf4dqX/Zvg8npJwaI77A08Ew3F4yRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752787204; c=relaxed/simple;
	bh=t086Y0WBypJt11np6ZFZrPY5bSxS2lWjpbU0LwWMfu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/NoZ8AMT5Oi6tpHIGRLsT9dslvU/yQjbMQ0Vrw8OSZJMpmEwy/JNZiB5+kFU1MJzgxPEyHYr2Y6AwNbHVxd6hNh971ALQavrBhobNHKf9HZQ3HTfvCDTTqAKAF1qUaZSVQZrOKCoh2yZ8+J6dFsdt+GYaBhI8z8eJcEFeMAVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ieOIcZ1b; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ieOIcZ1b"
Date: Thu, 17 Jul 2025 17:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752787198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MHiglHGetQCJWdqUKUh+y/NkPsr2EhXh1aeaxNqtTOg=;
	b=ieOIcZ1bs6fSgWYXYgGuodQSP+U0kHkKjywTm6u1RE7YlLQrzKJGnr3/UzXkOVJhaqLdMk
	l0vTiV0APBNY6FdBXMorE9bnq2iIHSOsjs4ctZzKAGOiB4nmdTmgDO8qYd1EALas8d+m8g
	sYc/sFbew13k+ztCHNTU+1yypVeO/ng=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+1faf405b707c6475482f@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_printbuf_exit
Message-ID: <chw42cnofp6t3swazunegsdf3q44kacv3og4dttvcbddmyuer3@k7ehkcsuvf7m>
References: <68794b5c.a70a0220.693ce.004f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68794b5c.a70a0220.693ce.004f.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e8352908bdcd Add linux-next specific files for 20250716
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=100e158c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2594af20939db736
> dashboard link: https://syzkaller.appspot.com/bug?extid=1faf405b707c6475482f
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b1e382580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8e7d4580000

regression from the CLASS() conversion, fixed by:

commit e9b9bdc34894fb1cd5d0798507b4cca4f6435ad3
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Jul 17 15:20:06 2025 -0400

    fixup! bcachefs: convert str_hash.c to CLASS

diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index dfe4b6ae0733..3e08e55d2dc1 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -329,7 +329,6 @@ int bch2_str_hash_repair_key(struct btree_trans *trans,
 out:
 fsck_err:
 	bch2_trans_iter_exit(trans, dup_iter);
-	printbuf_exit(&buf);
 	if (free_snapshots_seen)
 		darray_exit(&s->ids);
 	return ret;
