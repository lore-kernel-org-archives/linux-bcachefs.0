Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC795C433EF
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 13:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97D6560F6F
	for <linux-bcachefs@archiver.kernel.org>; Sun, 24 Oct 2021 13:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJXN3B (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 24 Oct 2021 09:29:01 -0400
Received: from cdw.me.uk ([91.203.57.136]:58655 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhJXN3A (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 24 Oct 2021 09:29:00 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1medWJ-000550-2A; Sun, 24 Oct 2021 14:26:39 +0100
Date:   Sun, 24 Oct 2021 14:26:39 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Kernel hang with excessive resize-journal on replicated fs
Message-ID: <20211024132638.GI11670@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The following ktest hangs in the kernel instead of producing an error from the
excessive journal resize:

  test_oversize_journal()
  {
      bcachefs format --errors=panic --replicas=2 /dev/sd[bc]
      mount -t bcachefs /dev/sdb:/dev/sdc /mnt

      # should fail, but actually hangs:
      ! bcachefs device resize-journal /dev/sdb $(blockdev --getsize64 /dev/sdb)

      umount /mnt
  }

(It would correctly return with an error on a single-device filesystem.)

The kernel is continuously looping on ret == -EAGAIN in
bch2_set_nr_journal_buckets. The disk reservation (unexpectedly) succeeds but
__bch2_set_nr_journal_buckets then keeps returning -EAGAIN because
bch2_bucket_alloc (correctly) fails.

Is the problem here that the disk reservation isn't confined to the specific
device we then want to allocate from? So although the space is available, it's
not available solely on the device where we want it?

Best wishes,

Chris.
