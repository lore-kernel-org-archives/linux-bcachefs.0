Received: from pannekake.samfundet.no (pannekake.samfundet.no [193.35.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B471BF33
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Mar 2024 22:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.35.52.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709763933; cv=none; b=raqskHF/kpimiHqEPmVNOYijJYxZI3Es4M0pI66oQzPsqwpNna+HAMvveG08+PSvq3QJ7H2EhVNDpNcgk4YXIHGwYPeCFbDG6u+HrBGEc3Ti0K8DG4utjdGK4HuTmkJ+wAaKzOXCVsSTa+JB9Jt1p1Zab4b67DyLw5JOE5HjZ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709763933; c=relaxed/simple;
	bh=qVJEaec+aId0nWuc4X2dY1lZ0ghNX2yue20py1XyzG0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rqq9ik89qQ8Nh7rLJSlNgzcG1WqsbWg9n/FEqOS8hVDuy6e2reRIAih8bgvR9vWzTzgO7Nukzg5mAokTD5Vu0WS0CNusI1rhxVRIhkZldL+z3fdVzMi7T1XTwgE43oYKEP9nBRVxuFxortVOU+c4nw0fm+bDBR1M6M/N6byDsPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no; spf=pass smtp.mailfrom=gunderson.no; dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b=QW8Xq0a9; arc=none smtp.client-ip=193.35.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gunderson.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gunderson.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gunderson.no header.i=@gunderson.no header.b="QW8Xq0a9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gunderson.no; s=legacy; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WNJWZUqaM4BoVdO7/yLcEVcXlqIqsMtVpUm1xEmdCMM=; b=QW8Xq0a9RG/1/hEu5zJ/zhcAGS
	bPjzpIF/AOiuKvSJywuvVPdkym30iEBrVr0GKhLzZSrHepcHInFJqGmeeQcKVGUBELJACtbtzXli+
	JkBrJ4NpUyNKmIluUd+xfjYDwVUU5VfcjV2I7g1igIfjVjJi7HjZAJPHaoAM9VfUJ6K82dh50zOe3
	GIT70P7Ci9Tk5AoL/8vwPfFVTeZTtPzgybCzEbEq+BLwT9BeGGx6ZW5cJCMD+crG4U1vAHoEdgehG
	8Mr3j/Le/wCGiX7/CNa6RCp3qjcDeBf/FIiSbBbIHEJVLvpauaIrFuM2DmW299L6OAqqzwyHSByJT
	2rZHKGtg==;
Received: from sesse by pannekake.samfundet.no with local (Exim 4.96)
	(envelope-from <steinar+bounces@gunderson.no>)
	id 1rhzhR-005zcL-1T
	for linux-bcachefs@vger.kernel.org;
	Wed, 06 Mar 2024 23:25:21 +0100
Date: Wed, 6 Mar 2024 23:25:21 +0100
From: "Steinar H. Gunderson" <steinar+bcachefs@gunderson.no>
To: linux-bcachefs@vger.kernel.org
Subject: Re: Broken multi-device filesystem
Message-ID: <20240306222521.rxlzivzuz6yqujes@sesse.net>
X-Operating-System: Linux 6.8.0-rc2 on a x86_64
References: <20240304173647.s5mpkojd3fnvbpu4@sesse.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240304173647.s5mpkojd3fnvbpu4@sesse.net>

On Mon, Mar 04, 2024 at 06:36:47PM +0100, Steinar H. Gunderson wrote:
> So the entire machine is hosed. (I still have an older copy of the filesystem
> in xfs form on a different partition, so I can boot into that, and I do have
> backups of all the user data, but it is still pretty inconvenient.)

I did a dump of the filesystem to two .qcow2 files, overriding the split
brain detection (and then repaired them with qemu-img, as qemu-nbd was
complaining they were broken). fsck on the resulting block devices gave an
assertion error:

  root@bigscreen:~/bcachefs-tools# ./bcachefs fsck /dev/nbd0:/dev/nbd1
  mounting version 1.6: btree_subvolume_children opts=ro,compression=lz4,degraded,fsck,fix_errors=ask,read_only
  recovering from unclean shutdown
  superblock requires following recovery passes to be run:
    check_subvols,check_dirents
  Version upgrade from 1.3: rebalance_work to 1.6: btree_subvolume_children incomplete
  Doing compatible version upgrade from 1.3: rebalance_work to 1.6: btree_subvolume_children
  
  journal read done, replaying entries 7263903-7263903
  error validating btree node on /dev/nbd0 at btree extents level 2/2
    u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq b25c303a8b7a1163 written 112 min_key POS_MIN durability: 1 ptr: 0:441498:0 gen 1
    node offset 64/112: btree node data missing: expected 112 sectors, found 64: fix?
   (y,n, or Y,N for all errors of this type) Y
  btree_node_read_work: rewriting btree node at btree=extents level=2 SPOS_MAX due to error
  error validating btree node on /dev/nbd0 at btree dirents level 1/1
    u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
    node offset 0/459 bset u64s 17199: checksum error: got bb38ac4c should be fbddc60e type crc32c_nonzero, fixing
  error validating btree node at btree dirents level 1/1
    u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
    node offset 0/459 bset u64s 17199: invalid bkey: u64s too small (2 < 5)
    u64s 2 type deleted POS_MIN len 0 ver 0: , fixing
  error validating btree node on /dev/nbd0 at btree dirents level 1/1
    u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 79b64c5dfcd3e63e written 459 min_key POS_MIN durability: 1 ptr: 0:351317:0 gen 2
    node offset 270/459: btree node data missing: expected 459 sectors, found 270, fixing
  bcachefs: libbcachefs/extents.h:71: extent_entry_bytes: Assertion `0' failed.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
