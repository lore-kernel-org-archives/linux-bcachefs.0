Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB3234C154
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Dec 2025 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764869766; cv=none; b=s1lgCgpkds9orWTXccDx8Px690QzQtXwyRBtl//mIa8ysKQAMaxR6RgSLBLjfHAiko2DJAK+tT67X0jIvPx4llGBxWXiesoBPjSekxMB2P13NAJCaGPj6PEmHstB9UZUUjLhKtpWfm6dl8bI/xUfZut8KyOiOzd7aEzzF3xxZQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764869766; c=relaxed/simple;
	bh=QWE5b5j1DoAXQcH7bL7vggRNnQZfjqUVOspxpoeiN68=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YiG9jIhqXIamXO/oV0m2sO20zDO/1zdxqF0zSKXS1YP6DfH1nkIkaDI4Q5hgDWZjzDBHeJ/MXWdjulLcj4AOKJGkw3hTp+kpRdAAIbqZSE+C8Vi2To2Pe+wIF8HIX1iBWw3K9i68F3JodlLseWAwg6gRMCCrQpf/9SM2w5tQsy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAM7MzbQ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAM7MzbQ"
Date: Thu, 4 Dec 2025 12:35:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764869762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=hqum8qZ8d+nZrpm8tlE3aDVe5uVwW9pInioVOvffyOY=;
	b=EAM7MzbQ1tEvTgwqpUUqchebJhRTPcVt0WTPe2xFfKFa2Lj6koQamHCY3HNYf16xZu3jpO
	0u3ajXbekVdSS6h+YYRtyWNOpbXNl99XpDsEQc7/+GfH0IQOuTvoB7nzN7uWtFwzGsmN91
	pxeTCzSTot+XYiVRwMoQNoQtEiqny/w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Subject: bcachefs 1.33.0 - reconcile
Message-ID: <slvis5ybvo7ch3vxh5yb6turapyq7hai2tddwjriicfxqivnpn@xdpb25wey5xd>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Biggest new feature in the past ~2 years, I believe. The user facing
stuff may be short and sweet - but so much going on under the hood to
make all this smooth and polished.

Big thank you to everyone who helped out with testing, design feedback,
and more.

As always, keep the bug reports coming - you find 'em, we fix em :)

Cheers,
Kent


Changelog:
==========

`bcachefs_metadata_version_reconcile` (formerly known as rebalance_v2)

### Reconcile

An incompatible upgrade is required to enable reconcile.

Reconcile now handles all IO path options; previously only the background target
and background compression options were handled.

Reconcile can now process metadata (moving it to the correct target,
rereplicating degraded metadata); previously rebalance was only able to handle
user data.

Reconcile now automatically reacts to option changes and device setting
changes, and immediately rereplicates degraded data or metadata

This obsoletes the commands `data rereplicate`, `data job
drop_extra_replicas`, and others; the new commands are `reconcile status` and
`reconcile wait`.

The recovery pass `check_reconcile_work` now checks that data matches the
specified IO path options, and flags an error if it does not (if it wasn't due
to an option change that hasn't yet been propagated).

Additional improvements over rebalance and implementation notes:

We now have a separate index for data that's scheduled to be processed by
reconcile but can't (e.g. because the specified target is full),
`BTREE_ID_reconcile_pending`; this solves long standing reports of rebalance
spinning when a filesystem has more data than fits on the specified background
target.

This also means you can create a single device filesystem with replicas=2, and
upon adding a new device data will automatically be replicated on the new
device, no additional user intervention required.

There's a separate index for "high priority" reconcile processing -
`BTREE_ID_reconcile_hipri`. This is used for degraded extents that need to be
rereplicated; they'll be processed ahead of other work.

Rotating disks get special handling. We now track whether a disk is rotational
(a hard drive, instead of an SSD); pending work on those disks is additionally
indexed in the `BTREE_ID_reconcile_work_phys` and
`BTREE_ID_reconcile_hipri_phys` btrees so they can be processed in physical
LBA order, not logical key order, avoiding unnecessary seeks.

We don't yet have the ability to change the rotational setting on an existing
device, once it's been set; if you discover you need this, please let us know so
it can be bumped up on the list (it'll be a medium sized project).

`BCH_MEMBER_STATE_failed` has been renamed to `BCH_MEMBER_STATE_evacuating`;
as the name implies, reconcile automatically moves data off of devices in the
evacuating state. In the future, when we have better tracking and monitoring
of drive health, we'll be able to automatically mark failing devices as
evacuating: when this lands, you'll be able to load up a server with disks and
walk away - come back a year later to swap out the ones that have been failed.

Reconcile was a massive project: the short and simple user interface is
deceptive, there was an enormous amount of work under the hood to make
everything work consistently and handle all the special cases we've learned
about over the past few years with rebalance.

There's still reconcile-related work to be done on disk space accounting when
devices are read-only or evacuating, and in the future we want to reserve space
up front on option change, so that we can alert the user if they might be doing
something they don't have disk space for.

### Other improvements and changes:

- Degraded data is now always properly reported as degraded (by `bcachefs fs
  usage`); data is considered degraded any time the durability on good
  (non-evacuating devices) is less than the specified replication level.

- Counters (shown by `bcachefs fs top` and tracepoints have gotten a giant
  cleanup and rework: every counter has a corresponding tracepoint. This makes
  it easy to drill down and investigate when a filesystem is doing something
  unusual and unexpected.

  Under the hood, the conversion of tracepoints to printbufs/pretty printers has
  now been completed, with some much improved helpers. This makes it much easier
  to add new counters and tracepoints or add additional info to existing
  tracepoints, typically a 5-20 line patch. If there's something you're
  investigating and you need more info, just ask.

  We now make use of type information on counters to display data rates in
  `bcachefs fs top` where applicable, and many counters have been converted to
  data rates. This makes it much easier to correlate different counters (e.g.
  `data_update`, `data_update_fail`) to check if the rates of slowpath events
  should be a cause for concern.

- Logging/error message improvements

  Logging has been a major area of focus, with a lot of under the hood
  improvements to make it ergonomic to generate messages that clearly explain
  what the system is doing an why: error messages should not include just the
  error, but how it was handled (soft error or hard error) and all actions taken
  to correct the error (e.g. scheduling self healing or recovery passes).

  When we receive an IO error from the block layer we now report the specific
  error code we received (e.g. `BLK_STS_IOERR`, `BLK_STS_INVAL`).

  The various write paths (user data, btree, journal) now report one error
  message for the entire operation that includes all the sub-errors for the
  individual replicated writes and the status of the overall operation (soft
  error (wrote degraded data) vs. hard error), like the read paths.

  On failure to mount due to insufficient devices, we now report which device(s)
  were missing; we remember the device name and model in the superblock from the
  last time we saw it so that we can give helpful hints to the user about what's
  missing.

  When btree topology repair recovers via btree node scan, we now report which
  node(s) it was able to recover via scan; this helps with determining if data
  was actually lost or not.

  We now ratelimit soft and hard errors separately, in the data/journal/btree
  read and write paths, ensuring that if the system is being flooded with soft
  errors the hard errors will still be reported.

  All error ratelimiting now obeys the `no_ratelimit_errors` option.

  All recovery passes should now have progress indicators.

- New options:

  `mount_trusts_udev`: there have been reports of mounting by UUID failing due
  to known bugs in libblkid. Previously this was available as an environment
  variable, but it now may be specified as a mount option (where it should also
  be much easier to find). When specified, we only use udev for getting the list
  of the system's block devices; we do all the probing for filesystem members
  ourself.

  `writeback_timeout`: if set, this overrides the `vm.dirty_writeback*` sysctls
  for the given filesystem, and may be set persistently. Useful for setting a
  lower writeback timeout for removeable media.

- Other smaller user-visible improvements

  The `mi_btree_bitmap` field in the member info section of the superblock now
  has a recovery pass to clean it up and shrink it; it will be automatically
  scheduled when we notice that there is significantly more space on a device
  marked as containing metadata than we have metadata on that device.

  The member-info btree bitmap is used by btree node scan, for disaster recovery
  repair; shrinking the bitmap reduces the amount of the device that has to be
  scanned if we have to recover from btree nodes that have become unreadable or
  lost despite replication. You don't ever want to need it, but if you do need
  it it's there.

- Promotes are now ratelimited; this resolves an issue with spinning up far too
  many kworker threads for promotes that wouldn't happen due to the target being
  busy.

- An issue was spotted on a user filesystem where btree node merging wasn't
  happening properly on the `reconcile_work` btree, causing a very slow upgrade.
  Btree node merging has now seen some improvements; btree lookups can now kick
  off asynchronous btree node merges when they spot an empty btree node, and the
  btree write buffer now does btree merging asynchronously, which should be a
  noticeable improvement on system performance under heavy load for some users -
  btree write buffer flushing is single threaded and can be a bottleneck.

  There's also a new recovery pass, `merge_btree_nodes`, to check all btrees for
  nodes that can be merged. It's not run automatically, but can be run if
  desired by passing the `recovery_passes` option to an online fsck.

- And many other bug fixes.

### Notable under-the-hood codebase work:

A lot of codebase modernization has been happening over the past six months,
to prepare for Rust. With the latest features recently available in C and in
the kernel, we can now do incremental refactorings to bring code steadily more
in line with what the Rust version will be, so that the future conversion will
be mostly syntactic - and not a rewrite. The big enabler here was CLASS(),
which is the kernel's version of pseudo-RAII based on `__cleanup()`; this
allows for the removal of goto based error handling (Rust notably does not
have goto).

We're now down to ~600 gotos in the entire codebase, down from ~2500 when the
modernization started, with many files being complete.

Other work includes avoiding open coded vectors; bcachefs uses DARRAY(), which
is decently close to Rust/C++ vectors, and the try() macro for forwarding
errors, stolen from Rust. These cleanups have deleted thousands of lines from
the codebase over the past months.
