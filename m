Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988AEEB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjGIRQG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjGIRQF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:05 -0400
Received: from out-61.mta0.migadu.com (out-61.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4F1F1
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vo2NIHEjCdxP40GfjJPA4gK4qKtEHvX85Kd+95c7OG4=;
        b=UgwHnRab3FAsKG3pnr3I4YYEirQq/o10K1U4lG1pULybhwOMnQqHfeWlihkG+6SSATD6E9
        dxye16mnBNuZAeU2PcZDKgmRWiA7rRziP5Xslpqy6mzqG/jsA2QnvlJul6qeTn4/wlwli8
        hDM5Pp+Obf97IXX7oLzZKlxuFC3ITVc=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 00/10] bcachefs - semvar, forward compatibility
Date:   Sun,  9 Jul 2023 13:15:41 -0400
Message-Id: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

So - in the upstreaming discussion, Brian mentioned code review, so now
seems like a good time to start making sure bcachefs patches hit the
list.

In the last cabal meeting, we started talking about on disk
compatibility issues for mainlining. Since (IIRC) the first release,
we've maintained backwards compatibility (support for very old versions
has been dropped, but there's always been an upgrade path) - but we
generally haven't been addressing forwards compatibility yet - we've
been doing a lot of forced incompatible version upgrades, where the old
version is no longer able to mount the filesystem after it's been
mounted by the new version.

Obviously, we can't do that anymore after we're in mainline and out of
EXPERIMENTAL. There were two main issues to address:

Major/minor version numbers
---------------------------

bcachefs started out with the traditional compatible/incompatible
feature bits in the superblock, but they are no longer my preferred
approach.

The problem with feature bits is that there was an ordering in which new
on disk format features were released, and feature bits lose that
ordering: they make it possible for users to create filesystems where x,
y, and z modern feature bits are enabled, but not feature bit a from 5
years ago - and the code was never written to expect that and you
certainly never tested that configuration, so things break in incredibly
fun ways.

Assigning every new on disk feature a distinct version number instead of
a feature bit preserves this ordering and makes it impossible for users
to create or use filesystems with features selected that historically
should not have existed. This has been the practice in bcachefs for
awhile now, and I've been quite happy with it.

The missing bit that this patch series adds is to split the version
number field into major and minor versions. Incrementing the minor
version number corresponds to adding a new compat feature flag, if we
were using feature bits: incrementing the major version number
corresponds to adding a new incompatible feature bit.

IOW, we'll allow mounting a filesystem with a version number greater
than the currently supported version as long as the major version number
is the same. As with compat feature bits, if you do so the filesystem
will be downgraded to the currently supported version, indicating those
new on disk structures may now be inconsistent.

Forwards compatibility of on disk structures:
---------------------------------------------

We need to be able to roll out new on disk data structures without
causing problems for old versions - old versions should just ignore
metadata they don't understand. This had been planned for in the past
and most of the work was done, so there wasn't much left.

Specifically, we need to be able to roll out new
 - Superblock sections: already handled, audited and cleaned up a bit
 - Journal entry types: already handled, audited
 - Btrees: addressed by this patchset
 - Bkey types: addressed by this patchset
 - New fields for existing bkeys: addressed by the patch series that
   introduced "bch2_bkey_get_val_typed()", but this is the trickiest to
   handle and likely more work will be required

With all this in place, we'll be able to roll out most of the new
features we want that require new on disk data structures as forwards
compatible changes, including everything currently in the pipeline. That
includes

 - Snapshot nodes are gaining skiplist entries soon: this will fix O(n)
   issues with bch2_snapshot_is_ancestor()

 - rebalance_work btree: Rebalance is the last operation that happens
   during normal operation that requires metadata scanning - soon I'll
   be adding a rebalance_work btree that references extents that
   rebalance will have work to do on in the future (e.g. for the
   background_compression or background_target io options). 

 - inodes_deleted btree: After unclean shutdown we still have to scan
   the entire inodes btree for deleted inodes, I'll be adding another
   bitset btree to address this - and also adding a tmpdir feature as
   well.

Things that will require incompatible changes:

 - New key types that replace existing key types, or in general new data
   structures that replace existing data structures

   Where we can maintain both the old and new data structures this isn't
   a problem - e.g. we can roll out a new bch_sb_members_v2 superblock
   section and just also keep writing out bch_sb_members for old
   versions to use; but we won't be able to roll out e.g. a new extent
   key type without an incompatible change.

 - New btree node header/journal entry headers - we'd like bigger
   nonces, so this will need to happen eventually

 - New extent_entry types: this one is a bit unfortunate, because
   extents contain a list of variable size fields (e.g. ptrs, different
   sized crc entries) and the entries themselves don't specify their
   size - the code that's reading it has to know how big every extent
   entry type is.

   This just came up with rebalance_work - rebalance_work needs a new
   extent entry type, so I rolled that out ahead of time so we can roll
   out the rest of the functionality as a compatible change.

Forced version upgrades:
------------------------

Going forward, we will still be doing forced version upgrades for awhile
- but only to forwards-compatible versions. After the next incompatible
(version 2.0) release, we likely won't be doing forced version upgrades
at all anymore.

Currently, version upgrades generally require a fsck. Another thing this
patchset addresses is enumerating all our recovery (including version
upgrade and fsck passes); this will let us specify "upgrading to this
version only requires this pass to run".

Kent Overstreet (10):
  bcachefs: Allow for unknown btree IDs
  bcachefs: Allow for unknown key types
  bcachefs: Refactor bch_sb_field_ops handling
  bcachefs: Change check for invalid key types
  bcachefs: BCH_SB_VERSION_UPGRADE_COMPLETE()
  bcachefs: version_upgrade is now an enum
  bcachefs: Kill bch2_bucket_gens_read()
  bcachefs: Stash journal replay params in bch_fs
  bcachefs: Enumerate recovery passes
  bcachefs: bcachefs_metadata_version_major_minor

 fs/bcachefs/alloc_background.c      | 129 +++++-----
 fs/bcachefs/alloc_background.h      |  18 +-
 fs/bcachefs/alloc_foreground.c      |   9 +-
 fs/bcachefs/backpointers.c          |  23 +-
 fs/bcachefs/backpointers.h          |   2 +-
 fs/bcachefs/bcachefs.h              |  62 ++++-
 fs/bcachefs/bcachefs_format.h       |  63 +++--
 fs/bcachefs/bkey_methods.c          |  81 ++++---
 fs/bcachefs/bkey_methods.h          |  20 +-
 fs/bcachefs/btree_cache.c           |  23 +-
 fs/bcachefs/btree_cache.h           |  22 +-
 fs/bcachefs/btree_gc.c              |  26 +-
 fs/bcachefs/btree_io.c              |   9 +-
 fs/bcachefs/btree_iter.c            |   4 +-
 fs/bcachefs/btree_update_interior.c |  18 +-
 fs/bcachefs/btree_update_leaf.c     |  17 +-
 fs/bcachefs/dirent.c                |   3 +-
 fs/bcachefs/dirent.h                |   4 +-
 fs/bcachefs/ec.c                    |   3 +-
 fs/bcachefs/ec.h                    |   4 +-
 fs/bcachefs/extents.c               |  12 +-
 fs/bcachefs/extents.h               |   9 +-
 fs/bcachefs/fsck.c                  |  77 +-----
 fs/bcachefs/fsck.h                  |  10 +-
 fs/bcachefs/inode.c                 |  12 +-
 fs/bcachefs/inode.h                 |  12 +-
 fs/bcachefs/journal_io.c            |  15 +-
 fs/bcachefs/lru.c                   |   3 +-
 fs/bcachefs/lru.h                   |   3 +-
 fs/bcachefs/move.c                  |  10 +-
 fs/bcachefs/opts.c                  |   5 +
 fs/bcachefs/opts.h                  |   5 +-
 fs/bcachefs/quota.c                 |   3 +-
 fs/bcachefs/quota.h                 |   4 +-
 fs/bcachefs/recovery.c              | 353 ++++++++++++++--------------
 fs/bcachefs/reflink.c               |   9 +-
 fs/bcachefs/reflink.h               |   8 +-
 fs/bcachefs/subvolume.c             |  16 +-
 fs/bcachefs/subvolume.h             |  14 +-
 fs/bcachefs/super-io.c              |  91 +++++--
 fs/bcachefs/super-io.h              |   3 +-
 fs/bcachefs/super.c                 |   1 +
 fs/bcachefs/xattr.c                 |   3 +-
 fs/bcachefs/xattr.h                 |   3 +-
 44 files changed, 700 insertions(+), 521 deletions(-)

-- 
2.40.1

