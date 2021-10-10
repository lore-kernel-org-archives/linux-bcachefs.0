Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B99C433F5
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Oct 2021 13:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D33DC61076
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Oct 2021 13:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhJJNqP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 10 Oct 2021 09:46:15 -0400
Received: from cdw.me.uk ([91.203.57.136]:45921 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231907AbhJJNqP (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 10 Oct 2021 09:46:15 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mZZ7d-0000cs-KS; Sun, 10 Oct 2021 14:44:13 +0100
Date:   Sun, 10 Oct 2021 14:44:13 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: rmdir() succeeds on an empty subvolume
Message-ID: <20211010134413.GA31142@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

If I create an empty snapshot in a bcachefs filesystem, I can then remove
the snapshot directory causing the filesystem to drop into an emergency
read-only state:

  # bcachefs format -q /dev/zram1
  initializing new filesystem
  going read-write
  mounted with opts: (null)
  # mkdir -p /tmp/p
  # mount -t bcachefs /dev/zram1 /tmp/p
  # bcachefs subvolume create /tmp/p/s
  # rmdir /tmp/p/s
  # touch /tmp/p/test
  touch: cannot touch '/tmp/p/test': Read-only file system
  # dmesg -t | tail -n 6
  bcachefs (zram1): recovering from clean shutdown, journal seq 4
  bcachefs (zram1): going read-write
  bcachefs (zram1): mounted with opts: (null)
  bcachefs (zram1): missing subvolume 2
  bcachefs (zram1): emergency read only
  bcachefs (zram1): error deleting snapshot keys: -30

Since an unprivileged user can use bcachefs subvolume create in a directory
they own, they too can panic the filesystem by doing this.

Similarly, running rm -r on a directory containing a snapshot, the contents
of the snapshot are successfully cleared out before we run into trouble by
removing the subvolume inode.

I guess it should either succeed and delete the snapshot/subvolume, or it
should fail with EBUSY like rmdir() does on a mountpoint?

Best wishes,

Chris.
