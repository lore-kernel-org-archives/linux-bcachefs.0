Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8346DC433EF
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 17:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F75A6128E
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 17:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhKFROj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:14:39 -0400
Received: from cdw.me.uk ([91.203.57.136]:36679 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234649AbhKFROi (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 6 Nov 2021 13:14:38 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mjPES-0001TY-Hg; Sat, 06 Nov 2021 17:11:56 +0000
Date:   Sat, 6 Nov 2021 17:11:56 +0000
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: More eager discard behaviour
Message-ID: <20211106171156.GM11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Discards issued to a loopback device punch holes in the underlying files, so I
thought they'd be an easy way to check (and maybe ktest) filesystem discard
behaviour. Here, I make a 1GB filesystem then repeatedly create and delete a
400MB file in it:

  # truncate -s 1G /tmp/fs
  # losetup /dev/loop0 /tmp/fs
  # bcachefs format -q --discard /dev/loop0
  initializing new filesystem
  going read-write
  mounted with opts: (null)
  # mkdir -p /tmp/mnt
  # mount -t bcachefs -o discard /dev/loop0 /tmp/mnt
  # while true; do
  >   sync && sleep 1 && du -h /tmp/fs
  >   dd if=/dev/zero of=/tmp/mnt/file bs=1M count=400 status=none
  >   sync && sleep 1 && du -h /tmp/fs
  >   rm /tmp/mnt/file
  > done
  1.7M  /tmp/fs
  404M  /tmp/fs
  403M  /tmp/fs
  806M  /tmp/fs
  806M  /tmp/fs
  992M  /tmp/fs
  993M  /tmp/fs
  992M  /tmp/fs
  992M  /tmp/fs
  992M  /tmp/fs
  [...]

Although bcachefs does issue discards (double-checked with printk in
discard_one_bucket), it only does so when the allocator thread wakes to
reclaim buckets once the entire block device is in use, so the practical
behaviour is that the whole device is kept full to the brim despite the
filesystem never being over 40% capacity. (With count=50, you can get the
same effect with an fs that never goes over 5% capacity.)

(Happy to roll the above into a ktest if it's useful, e.g. that capacity
never goes above x% with repeated deletes?)

The equivalent test with ext4 shows discard doing the expected thing:

  # truncate -s 1G /tmp/fs
  # losetup /dev/loop0 /tmp/fs
  # mkfs.ext4 -q /dev/loop0
  # mkdir -p /tmp/mnt
  # mount -t ext4 -o discard /dev/loop0 /tmp/mnt
  # while true; do
  >   sync && sleep 1 && du -h /tmp/fs
  >   dd if=/dev/zero of=/tmp/mnt/file bs=1M count=400 status=none
  >   sync && sleep 1 && du -h /tmp/fs
  >   rm /tmp/mnt/file
  > done
  33M /tmp/fs
  433M  /tmp/fs
  33M /tmp/fs
  433M  /tmp/fs
  33M /tmp/fs
  433M  /tmp/fs
  33M /tmp/fs
  433M  /tmp/fs
  33M /tmp/fs
  [...]

SSDs are happier TRIMmed, but discard is also invaluable for filesystems on
thin provisioning systems like dm-thin. (virtio-block can pass discards up
from guest to host, so this is a common VM configuration.)

How practical would it be either to more-greedily wake the allocator thread
and reclaim buckets, or to detect buckets available to discard earlier in
their lifetime?

Best wishes,

Chris.
