Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6D51EFF93
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Apr 2025 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745430399; cv=none; b=CbKf6fX4MvWBUXsgLuGdJlEuVtWF51LE1mBOlBj9R5Ch6zO4kQYy9mCDwN9xmxaeo9aLc5tfaMC1ZlpxNRehmqTjOYIX+WuBmHBWSj2U93DzuGusvi68+k3WQD+xlEUg6XkUicwYeJ7X6O8PPpYmyW5kEB1W8JEtuGemY71VfZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745430399; c=relaxed/simple;
	bh=+iYVZayri0+hd86I/QKT7kk81fBaNiCG9vGxGY/EKPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/hlEBcc4tdO7PjUIWASM7vwJHLK7o9idh9LKv2nA+zPkvBv9tFhhzOvkJ46LbV0vyoQjl6DGMXMhWubbXTn+miaubSYyKt7Sq8fui+yyGaDiMH/w8KEMrw5GODrl2YNGNSq3pO6aCvhCjt8TdYAF3mUw+m6uy7IGmhDHiZLl9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rGza7rF9; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rGza7rF9"
Date: Wed, 23 Apr 2025 13:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745430393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/l8j5ATWqWXvzRZpWxnTOslyjPUQ12leqWJIrv6M8Q=;
	b=rGza7rF9GWGgTZOPhjP1ZeebjAVXpx47K7M+QE6GVTVZCwOULJP710tMf6p2L7jT1Udt2L
	dvBORzkvV3IPfTxFiZvYLcQjXv/XGdPEWlWdLI9DKc2bRjwavlAz8Pw4ThMs7eqhz45D/7
	kQ9faUF5/V6cH0tVXV35yN9VUG7DCGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Arnaud Lecomte <contact@arnaud-lcm.com>
Cc: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: Sub volumes handling in bch2_fsck_update_backpointers
Message-ID: <r7uir3b5ikbzaoaeh4hmuua73kaa2ydetnhfbxc6554wjdyr6l@pkpgzp2zonan>
References: <6806d857.050a0220.f25bb.07a8.GAE@google.com>
 <20250423154531.376838-1-contact@arnaud-lcm.com>
 <22hlu76p6uzlu6zexcjxgpijenfba3en4bx74nx6etr2mpgw4g@liyxgcpx7hbl>
 <53206807-b595-4fec-8113-a81a24c3e8db@arnaud-lcm.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53206807-b595-4fec-8113-a81a24c3e8db@arnaud-lcm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 23, 2025 at 07:18:34PM +0200, Arnaud Lecomte wrote:
> Would you be  okay if I try to handle it ? I am fairly new to bcachefs but I
> am really interested to get involve into it, I like the project.

go for it, get ktest going and join the IRC channel

https://evilpiepirate.org/git/ktest.git/

> 
> On 23/04/2025 18:47, Kent Overstreet wrote:
> > On Wed, Apr 23, 2025 at 05:45:31PM +0200, Arnaud Lecomte wrote:
> > > Hey everyone, in fsck.c, we have:
> > > /*
> > >   * Prefer to delete the first one, since that will be the one at the wrong
> > >   * offset:
> > >   * return value: 0 -> delete k1, 1 -> delete k2
> > >   */
> > > int bch2_fsck_update_backpointers(struct btree_trans *trans,
> > > 				  struct snapshots_seen *s,
> > > 				  const struct bch_hash_desc desc,
> > > 				  struct bch_hash_info *hash_info,
> > > 				  struct bkey_i *new)
> > > {
> > > 	if (new->k.type != KEY_TYPE_dirent)
> > > 		return 0;
> > > 
> > > 	struct bkey_i_dirent *d = bkey_i_to_dirent(new);
> > > 	struct inode_walker target = inode_walker_init();
> > > 	int ret = 0;
> > > 
> > > 	if (d->v.d_type == DT_SUBVOL) {
> > > 		BUG();
> > > 	} else {
> > > 		ret = get_visible_inodes(trans, &target, s, le64_to_cpu(d->v.d_inum));
> > > 		if (ret)
> > > 			goto err;
> > > 
> > > 		darray_for_each(target.inodes, i) {
> > > 			i->inode.bi_dir_offset = d->k.p.offset;
> > > 			ret = __bch2_fsck_write_inode(trans, &i->inode);
> > > 			if (ret)
> > > 				goto err;
> > > 		}
> > > 	}
> > > err:
> > > 	inode_walker_exit(&target);
> > > 	return ret;
> > > }
> > > 
> > > What is the current state for handling subvolumes ? In someone already working on or it is something we don't want to implement
> > > for some reasons ?
> > This does need to be handled, I haven't started on it yet.
> > 
> > I did just fix another subvolume root backpointers bug, which makes this
> > one easier - now, only the newest snapshot version of a subvolume root
> > inode needs to have a backpointer.
> > 
