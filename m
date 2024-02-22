Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7510FF
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 00:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560178; cv=none; b=VsJtlA20SLB0rlIoFCa+RSxtmtKeFNrY4mKRCYetBHif2BlnMk2BVTilevw2C5YxD/nXaZ9RKsm9sRF8+zvR8WdbnqGKC5TXFfae0SOngrUcPPQegiQIBLq+CBUuS+D9XUTuyzj+H+7U5s1HNFHK7DoDV0RFL29c2EXts06JSLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560178; c=relaxed/simple;
	bh=YITB42z2gBOyqx6Q71wLebfZaKoNm9MkW92qkrFG/3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IEb5nOT0A2+cP9rDMx+57XAjgvqmxnIhSfFT2uCo6IBqVEOuP63jS/ExVcdhvfEhL5xGieIhqJVCFmbUAfofgeUu110Vzlb/wKSh8DhMdN14KJXzeFVSlcKfYR+kon5INGdLuXpMc6qMj8XHvmdrrRrz+PZEmw1H0oGcL7YT9jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WzMc6ufv; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WzMc6ufv"
Date: Wed, 21 Feb 2024 19:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708560174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tU6XmpQ7h9OYdty04fVEZuE7owvib7grq2s/Y5NagU8=;
	b=WzMc6ufvT1Tf4CHPAed/mGk/VDZedfrEHYatQL596B3MY/t1io25rrx9tON4MsvdwYP8Ro
	XtxjUXqDeYP54WbQ8DE+j4IR9eOZV3wNJFHBPRBsBSL+LgHEAraWMBJjWMo7UjLYTdQYiA
	7EVB9jYpvKMCYlbM4IyfdUimLqvP2KE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org, 
	smatch@vger.kernel.org
Subject: Re: [bug report] bcachefs: missing error checks for
 bio_alloc_bioset()
Message-ID: <vjbmwvibzi7os7hxiiirskl7ermrae7cjpnn54tersrt6j5ywx@zjic2wbvralq>
References: <fufpv24643xxn3a5jpfxx4wbfwlczrhjyzqkxo33be3yeb4sea@y4obfahio6ag>
 <11e692bc-4077-4e82-b680-fa86182d15d9@moroto.mountain>
 <34p5j77iamkybfexdpjslxegy74da7mjtpsssrv4mems4bo5mj@5xlpdnvm4yxz>
 <e92fc993-ab94-4f3b-9ee2-4e0ca5341720@moroto.mountain>
 <uxyjkjzbur2unpdkt5yl2bojacg4tptfj6k4zyshcyvyfun3i7@y6q267iebdgg>
 <a1d5fc7c-87ac-45f5-8f3d-5af1b7cd3614@moroto.mountain>
 <jno3abkiamnwk7nqh7ojvzvrurk2ua7q3fkhnhugsxdh5vjkbh@a43f35palmkn>
 <b1167150-77ee-414c-9858-50e8c90dbd6e@moroto.mountain>
 <oxbjbtdx4go62bkdeclz45iw2tmtumkeplillsntifhm7prjfo@q3xmjmo4ok7s>
 <0833b5be-10ad-4842-a6b2-008d7ca11bf7@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0833b5be-10ad-4842-a6b2-008d7ca11bf7@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 21, 2024 at 09:01:26AM +0300, Dan Carpenter wrote:
> On Tue, Feb 20, 2024 at 04:26:38PM -0500, Kent Overstreet wrote:
> > On Tue, Feb 20, 2024 at 02:39:35PM +0300, Dan Carpenter wrote:
> > > So right now I only have two bcache warnings.  The missing error code
> > > warning isn't published unfortunately...  I don't think I'm going to
> > > have a lot of time to dedicate to this stuff in the up coming months
> > > honestly.
> > 
> > Why not just put this stuff up in a dashboard? Make it easy for people
> > to see the full results for their code, without nagging them with a
> > separate email for every warning?
> > 
> 
> Honestly, it would require quite a bit of work to do that and someone
> would need to step up to fund Linaro for a project like that.  If
> someone else feels like doing that, I'm happy to help them but right now
> I have a bunch of other things on my plate.

naw, that's just making excuses :)

you're the engineer - it's our job to figure out the most efficient way
of solving the problem and making it happen :)

A dashboard doesn't have to be anything fancy whatsoever; just dumping
text files to a webserver would already be useful.

If we wanted something easier to read, the only thing I would add would
be (and I'd have to find someone who knows javascript for this) - with a
bit of js and trivial postprocessing of your smatch output you could
have an html file where each line is the file and line number of an
error, and clicking on it expands to see the actual error.

That would be an absolutely trivial project to a web programmer - I've
got something similar for my CI, and the javascript is ~20 lines:
https://evilpiepirate.org/~testdashboard/ci?branch=bcachefs-testing&commit=ac1591b48eaf5f3fd173b4144ac21b4c36de8428

> > > fs/bcachefs/alloc_background.c:1751 bch2_discard_one_bucket() warn: missing error code here? 'discard_in_flight_add()' failed. 'ret' = '0'
> > 
> > No idea what smatch is complaining about here, we're returning either
> > -EEXIST the error code of darray_push().
> 
> I don't understand.  I don't see an -EEXIST or a darray_push()... :/

Sorry, I was looking inside discard_in_flight_add()

> fs/bcachefs/alloc_background.c
>   1670  static int bch2_discard_one_bucket(struct btree_trans *trans,
>   1671                                     struct btree_iter *need_discard_iter,
>   1672                                     struct bpos *discard_pos_done,
>   1673                                     struct discard_buckets_state *s)
>   1674  {
>   1675          struct bch_fs *c = trans->c;
>   1676          struct bpos pos = need_discard_iter->pos;
>   1677          struct btree_iter iter = { NULL };
>   1678          struct bkey_s_c k;
>   1679          struct bch_dev *ca;
>   1680          struct bkey_i_alloc_v4 *a;
>   1681          struct printbuf buf = PRINTBUF;
>   1682          bool discard_locked = false;
>   1683          int ret = 0;
>   1684  
>   1685          ca = bch_dev_bkey_exists(c, pos.inode);
>   1686  
>   1687          if (!percpu_ref_tryget(&ca->io_ref)) {
>   1688                  bch2_btree_iter_set_pos(need_discard_iter, POS(pos.inode + 1, 0));
>   1689                  return 0;
>   1690          }
>   1691  
>   1692          discard_buckets_next_dev(c, s, ca);
>   1693  
>   1694          if (bch2_bucket_is_open_safe(c, pos.inode, pos.offset)) {
>   1695                  s->open++;
>   1696                  goto out;
>   1697          }
>   1698  
>   1699          if (bch2_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
>   1700                          c->journal.flushed_seq_ondisk,
>   1701                          pos.inode, pos.offset)) {
>   1702                  s->need_journal_commit++;
>   1703                  s->need_journal_commit_this_dev++;
>   1704                  goto out;
>   1705          }
>   1706  
>   1707          k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_alloc,
>   1708                                 need_discard_iter->pos,
>   1709                                 BTREE_ITER_CACHED);
>   1710          ret = bkey_err(k);
>   1711          if (ret)
>   1712                  goto out;
>   1713  
>   1714          a = bch2_alloc_to_v4_mut(trans, k);
>   1715          ret = PTR_ERR_OR_ZERO(a);
>   1716          if (ret)
>   1717                  goto out;
> 
> ret is zero
> 
>   1718  
>   1719          if (BCH_ALLOC_V4_NEED_INC_GEN(&a->v)) {
>   1720                  a->v.gen++;
>   1721                  SET_BCH_ALLOC_V4_NEED_INC_GEN(&a->v, false);
>   1722                  goto write;
>   1723          }
>   1724  
>   1725          if (a->v.journal_seq > c->journal.flushed_seq_ondisk) {
>   1726                  if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
>   1727                          bch2_trans_inconsistent(trans,
>   1728                                  "clearing need_discard but journal_seq %llu > flushed_seq %llu\n"
>   1729                                  "%s",
>   1730                                  a->v.journal_seq,
>   1731                                  c->journal.flushed_seq_ondisk,
>   1732                                  (bch2_bkey_val_to_text(&buf, c, k), buf.buf));
>   1733                          ret = -EIO;
>   1734                  }
>   1735                  goto out;
>   1736          }
>   1737  
>   1738          if (a->v.data_type != BCH_DATA_need_discard) {
>   1739                  if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
>   1740                          bch2_trans_inconsistent(trans,
>   1741                                  "bucket incorrectly set in need_discard btree\n"
>   1742                                  "%s",
>   1743                                  (bch2_bkey_val_to_text(&buf, c, k), buf.buf));
>   1744                          ret = -EIO;
>   1745                  }
>   1746  
>   1747                  goto out;
>   1748          }
>   1749  
>   1750          if (discard_in_flight_add(c, SPOS(iter.pos.inode, iter.pos.offset, true)))
>   1751                  goto out;
> 
> We this goto out.

Ok, this is intentional; this is "success; the bucket is already being
discarded by another thread so we just bail out and move on to the next
thing".

It's not as clear as I'd like, but - this is C, I'm not sure we can
change it to please smatch without annoying other static analyzers (and,
like I was saying, way too much of the linux-bcachefs traffic is already
absolutely trivial static analyzer nitpicky bullshit).

> 
>   1752  
>   1753          discard_locked = true;
>   1754  
>   1755          if (!bkey_eq(*discard_pos_done, iter.pos) &&
>   1756              ca->mi.discard && !c->opts.nochanges) {
>   1757                  /*
>   1758                   * This works without any other locks because this is the only
>   1759                   * thread that removes items from the need_discard tree
>   1760                   */
>   1761                  bch2_trans_unlock_long(trans);
>   1762                  blkdev_issue_discard(ca->disk_sb.bdev,
>   1763                                       k.k->p.offset * ca->mi.bucket_size,
>   1764                                       ca->mi.bucket_size,
>   1765                                       GFP_KERNEL);
>   1766                  *discard_pos_done = iter.pos;
>   1767  
>   1768                  ret = bch2_trans_relock_notrace(trans);
>   1769                  if (ret)
>   1770                          goto out;
>   1771          }
>   1772  
>   1773          SET_BCH_ALLOC_V4_NEED_DISCARD(&a->v, false);
>   1774          a->v.data_type = alloc_data_type(a->v, a->v.data_type);
>   1775  write:
>   1776          ret =   bch2_trans_update(trans, &iter, &a->k_i, 0) ?:
>   1777                  bch2_trans_commit(trans, NULL, NULL,
>   1778                                    BCH_WATERMARK_btree|
>   1779                                    BCH_TRANS_COMMIT_no_enospc);
>   1780          if (ret)
>   1781                  goto out;
>   1782  
>   1783          count_event(c, bucket_discard);
>   1784          s->discarded++;
>   1785  out:
>   1786          if (discard_locked)
>   1787                  discard_in_flight_remove(c, iter.pos);
>   1788          s->seen++;
>   1789          bch2_trans_iter_exit(trans, &iter);
>   1790          percpu_ref_put(&ca->io_ref);
>   1791          printbuf_exit(&buf);
>   1792          return ret;
> 
> It returns ret.
> 
>   1793  }
> 
> 
> regards,
> dan carpenter
