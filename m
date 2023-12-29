Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E6D12B7C
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mAwh/3Y6"
Date: Fri, 29 Dec 2023 13:50:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703875854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=agg1eF4Q/o1xjrIiCxgsElDTKjmDvCr7RyO5KXhMR7E=;
	b=mAwh/3Y6cR3ACZeii3T6jaxaE+wKN2i0G5WHiWLBIVYVKry2CNdAjtVMrKgKFzqAMbv2ka
	PxJLKj5ZgdaZELxtBezhh7tzgMMX3pytage2xj6LRIzA4EuzqzZR4w+aBmb6KJLbSk/BbR
	74n/nEbA/3sJu7ixcUcHFLtRGu63xes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: bcachefs subvols / snapshots broken
Message-ID: <evltrlnkclj3g3yqm2nqyfz63tg53ojxs45uouq5e6nosxz37z@rxqrn6smqmuc>
References: <1804957404.243.1703798376220@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1804957404.243.1703798376220@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 28, 2023 at 01:19:36PM -0800, Carl E. Thompson wrote:
> Hello, there appears to be a bug in bcachefs in which certain changes to subvolumes and snapshots can result in file contents not being read properly when copied. Specifically, if a snapshot is created of a subvolume and a file in either the subvolume or the snapshot is removed or modified, incorrect data is read from the corresponding unmodified file in the subvolume or snapshot if that corresponding file is copied. I've reproduced on multiple systems running rc6 and rc7 but on my systems I can reproduce this 100% of the time on bcachefs filesystems where the block size is 4k; I cannot reproduce at all on filesystems with 512 byte blocks (but see below). I've only tested with 4k and 512 block sizes. None of the other format options I've tried made a difference in my tests including compression and bucket size.
> 
> Here is a short example:
> ---
> [carl@clip test]$ bcachefs subvolume create subvol
> 
> [carl@clip test]$ echo "Test" > subvol/file
> 
> [carl@clip test]$ bcachefs subvolume snapshot subvol snapshot_of_subvol
> 
> [carl@clip test]$ rm subvol/file 
> 
> [carl@clip test]$ cat snapshot_of_subvol/file 
> Test
> 
> [carl@clip test]$ cp snapshot_of_subvol/file file
> 
> [carl@clip test]$ cat file
> 
> [carl@clip test]$ ls -l file
> -rw-r--r-- 1 carl carl 5 Dec 28 12:56 file
> 
> [carl@clip test]$ hexdump -C file
> 00000000  00 00 00 00 00                                    |.....|
> 00000005
> 
> [carl@clip test]$ 
> ---
> 
> - The copied file has the correct length but has zeroes instead of the correct data
> - The problem also occurs if the file in the **snapshot** is removed or modified and the original file in the subvolume is copied
> - In my tests I only see the problem on filesystems with 4k blocks. I've never been able to reproduce with 512 byte blocks. However someone else on Reddit says that it definitely happened to them on a filesystem with 512 byte blocks (but they can't reproduce it now)
> - The bug only happens if the file is copied to the same bcachefs filesystem. It does **not** happen if the file is copied to a different bcachefs filesystem or a different filesystem entirely
> - The bug does **not** occur if the cp command is given the `--reflink=never` option
> - Discussion can be found on this Reddit thread (but not all comments are correct: https://www.reddit.com/r/bcachefs/comments/18sbl9z/how_do_you_restore_a_file_from_a_snapshot/
> 
> In my opinion this is a severe issue because it could lead to data loss if users rely on copied files having the correct contents.

Fix is in the -testing branch, will be making it to the appropriate
places shortly:

commit 05b11fb627bcd71cc19e79cdeabfa1b514bf8acf
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Dec 29 13:39:07 2023 -0500

    bcachefs: Fix extents iteration + snapshots interaction
    
    peek_upto() checks against the end position and bails out before
    FILTER_SNAPSHOTS checks; this is because if we end up at a different
    inode number than the original search key none of the keys we see might
    be visibile in the current snapshot - we might be looking at inode in a
    completely different subvolume.
    
    But this is broken, because when we're iterating over extents we're
    checking against the extent start position to decide when to bail out,
    and the extent start position isn't monotonically increasing until after
    we've run FILTER_SNAPSHOTS.
    
    Fix this by adding a simple inode number check where the old bailout
    check was, and moving the main check to the correct position.
    
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 732c8bb3f803..7e5c797cfaf2 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2145,18 +2145,16 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
 			goto out_no_locked;
 
 		/*
-		 * iter->pos should be mononotically increasing, and always be
-		 * equal to the key we just returned - except extents can
-		 * straddle iter->pos:
+		 * We need to check against @end before FILTER_SNAPSHOTS because
+		 * if we get to a different inode that requested we might be
+		 * seeing keys for a different snapshot tree that will all be
+		 * filtered out.
+		 *
+		 * But we can't do the full check here, because bkey_start_pos()
+		 * isn't monotonically increasing before FILTER_SNAPSHOTS, and
+		 * that's what we check against in extents mode:
 		 */
-		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
-			iter_pos = k.k->p;
-		else
-			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
-
-		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
-			     ? bkey_gt(iter_pos, end)
-			     : bkey_ge(iter_pos, end)))
+		if (k.k->p.inode > end.inode)
 			goto end;
 
 		if (iter->update_path &&
@@ -2215,6 +2213,21 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
 			continue;
 		}
 
+		/*
+		 * iter->pos should be mononotically increasing, and always be
+		 * equal to the key we just returned - except extents can
+		 * straddle iter->pos:
+		 */
+		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
+			iter_pos = k.k->p;
+		else
+			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
+
+		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
+			     ? bkey_gt(iter_pos, end)
+			     : bkey_ge(iter_pos, end)))
+			goto end;
+
 		break;
 	}
 
