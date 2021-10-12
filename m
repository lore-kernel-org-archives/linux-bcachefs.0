Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D9DC433F5
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 09:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281A761039
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Oct 2021 09:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhJLJJu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Oct 2021 05:09:50 -0400
Received: from cdw.me.uk ([91.203.57.136]:33405 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235256AbhJLJJu (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Oct 2021 05:09:50 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1maDlC-0003gN-37; Tue, 12 Oct 2021 10:07:46 +0100
Date:   Tue, 12 Oct 2021 10:07:46 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Metadata rereplication not triggering
Message-ID: <20211012090745.GA11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

[Spotted while double-checking c85e27c45512 fixed the rereplicate BUG_ON at
fs/bcachefs/btree_iter.c:2475 the other day.]

If I create a filesystem with --replicas=2, fail a component drive and
replace with a new one, then use bcachefs data rereplicate, metadata
doesn't seem to get copied to the new drive.

bcachefs fs usage suggests that all the data contents of the filesystem do
get correctly rereplicated; it's just the metadata that's missing.

Here's a minimal ktest to reproduce - I'll follow up with a patch to
tests/bcachefs/replication.ktest:

  test_replace_replica()
  {
      bcachefs format --errors=panic --replicas=2 /dev/sd[bc]
      mount -t bcachefs -o degraded /dev/sdb /mnt

      bcachefs device add -f /mnt /dev/sdd
      bcachefs data rereplicate /mnt
      umount /mnt

      mount -t bcachefs -o degraded /dev/sdd /mnt
      umount /mnt
  }

The second mount (of the new replacement drive alone) fails:

  00016 bcachefs (dev-1): btree write error: device removed
  00016 bcachefs (a5f018b0-5a18-40b9-9539-b8d2325a4dc4): insufficient devices online (0) for replicas entry btree: 1/1 [0]
  00016 bcachefs: bch2_fs_open() bch_fs_open err opening /dev/sdd: insufficient devices
  00016 mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sdd, missing codepage or helper program, or other error.

Mounting /dev/sdb solo at this point will work fine, as that does contain the
metadata + data, as does /dev/sdc, albeit for an older version of the fs.

The specific procedure here don't seem to matter: you can mount the
filesystem non-degraded, force remove a drive then add a new one, etc. I've
not found a scenario where I'm able to successfully trigger metadata
rereplication.

/sys/fs/bcachefs/*/options/data_replicas and metadata_replicas are both
still 2 at the point the new device is added and following data replication.
(Setting them explicitly 'just in case' doesn't change the behaviour.)

I'm still learning my way around fs/bcachefs, but there seems to be code to
replicate metadata already in tree - looks like it should be automatic - so I
wonder if it's not getting triggered when the replacement is added any more?

Best wishes,

Chris.
