Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB355C99
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709860776; cv=none; b=B548eVrCn7+vJYqyXZ6oOIcskLL9IfyJv73l8Ax2bx6XESVVgSjo4DYSqOf3QlcX1/EGOEYYioZlqMCKGWajE+twp0swTBEkBhedEoEhE2GnZLGfiJRUt+254ixX4S/Y9GTqibDWmGYMn6QoRPx67B3HjTlFrXUoAyo3xgIB9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709860776; c=relaxed/simple;
	bh=hFYC+dZmItRqdY8eLFw1b+2n00gtumaoZ8ajsiyYiBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5i1u6/n12B26C0OrSSOGrTqj8aTEFe3MG4Q2rvacRjuoXnwYuSKhywZ0mdpRj4zOoaRyjXum48bP5p+sl1wgxDnWyKKJ2B0YJBMIb6FjF3RNIe4B2krYVYT+GGVK0uXbjdatg6GtxbfqiGUAGW6qdZCb6W/Atp36chdQW1Q4cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aC7yVitj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aC7yVitj"
Date: Thu, 7 Mar 2024 20:19:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709860772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2X7LxRDuZ9a7/MTnYErHNfaujnAmKQPJXz5HFUyzm6g=;
	b=aC7yVitjD/3VJNPjyrpmpsIFg0NkBYlE3gGaKZstakzQ1Lb7oY0lIFPgaiYjQSXpnGgFj1
	NKaYakKGgjbSNmyVl5MFkLIb/CZNbyUYR89uh5WwcNWWOdvLy2+BSZE/eP4SsBF+ykSVuf
	yvt8dJjQT9/zfXg0H9wkASDvCSvZHEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Steinar H. Gunderson" <steinar+bcachefs@gunderson.no>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Broken multi-device filesystem
Message-ID: <ppkxhvv7g4lkuqppijhhigmbu7ofpbkosenmoionbjdq7hsdoq@ds2sckvl5nyr>
References: <20240304173647.s5mpkojd3fnvbpu4@sesse.net>
 <20240306222521.rxlzivzuz6yqujes@sesse.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306222521.rxlzivzuz6yqujes@sesse.net>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 06, 2024 at 11:25:21PM +0100, Steinar H. Gunderson wrote:
> On Mon, Mar 04, 2024 at 06:36:47PM +0100, Steinar H. Gunderson wrote:
> > So the entire machine is hosed. (I still have an older copy of the filesystem
> > in xfs form on a different partition, so I can boot into that, and I do have
> > backups of all the user data, but it is still pretty inconvenient.)
> 
> I did a dump of the filesystem to two .qcow2 files, overriding the split
> brain detection (and then repaired them with qemu-img, as qemu-nbd was
> complaining they were broken). fsck on the resulting block devices gave an
> assertion error:

Can you hop on IRC and send me the dumps with magic wormhole?

> 
>   root@bigscreen:~/bcachefs-tools# ./bcachefs fsck /dev/nbd0:/dev/nbd1
>   mounting version 1.6: btree_subvolume_children opts=ro,compression=lz4,degraded,fsck,fix_errors=ask,read_only
>   recovering from unclean shutdown
>   superblock requires following recovery passes to be run:
>     check_subvols,check_dirents
>   Version upgrade from 1.3: rebalance_work to 1.6: btree_subvolume_children incomplete
>   Doing compatible version upgrade from 1.3: rebalance_work to 1.6: btree_subvolume_children
>   
>   journal read done, replaying entries 7263903-7263903
>   error validating btree node on /dev/nbd0 at btree extents level 2/2
>     u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq b25c303a8b7a1163 written 112 min_key POS_MIN durability: 1 ptr: 0:441498:0 gen 1
>     node offset 64/112: btree node data missing: expected 112 sectors, found 64: fix?
>    (y,n, or Y,N for all errors of this type) Y
>   btree_node_read_work: rewriting btree node at btree=extents level=2 SPOS_MAX due to error
>   error validating btree node on /dev/nbd0 at btree dirents level 1/1
>     u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
>     node offset 0/459 bset u64s 17199: checksum error: got bb38ac4c should be fbddc60e type crc32c_nonzero, fixing
>   error validating btree node at btree dirents level 1/1
>     u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
>     node offset 0/459 bset u64s 17199: invalid bkey: u64s too small (2 < 5)
>     u64s 2 type deleted POS_MIN len 0 ver 0: , fixing
>   error validating btree node on /dev/nbd0 at btree dirents level 1/1
>     u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
>     node offset 270/459: btree node data missing: expected 459 sectors, found 270, fixing
>   bcachefs: libbcachefs/extents.h:71: extent_entry_bytes: Assertion `0' failed.
> 
> /* Steinar */
> -- 
> Homepage: https://www.sesse.net/
