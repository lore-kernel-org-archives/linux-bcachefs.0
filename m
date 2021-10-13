Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32948C433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 16:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1512860F3A
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Oct 2021 16:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhJMQyu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:54:50 -0400
Received: from cdw.me.uk ([91.203.57.136]:56745 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237654AbhJMQyr (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Oct 2021 12:54:47 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mahUe-0006Qv-8n; Wed, 13 Oct 2021 17:52:40 +0100
Date:   Wed, 13 Oct 2021 17:52:40 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Metadata rereplication not triggering
Message-ID: <20211013165240.GC11670@arachsys.com>
References: <20211012090745.GA11670@arachsys.com>
 <YWXRy46DZY7AV+Kf@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWXRy46DZY7AV+Kf@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> On Tue, Oct 12, 2021 at 10:07:46AM +0100, Chris Webb wrote:
> > 
> > If I create a filesystem with --replicas=2, fail a component drive and
> > replace with a new one, then use bcachefs data rereplicate, metadata
> > doesn't seem to get copied to the new drive.
> 
> It turns out rereplicate_pred() wasn't checking the key types correctly, and it
> wasn't rereplicating any of the newer key types - I just pushed a fix. Thanks
> for the report and the test!

Hi Kent. Ah, that makes sense, thanks!

I pulled the latest HEADs of bcachefs-tools and bcachefs, including this
patch, but when rerunning the ktest, it still fails.

  00016 bcachefs (dev-1): btree write error: device removed
  00016 bcachefs (f5d59006-9408-4179-859c-16e94b1d9b7a): insufficient devices
  online (0) for replicas entry btree: 1/2 [0 1]
  00016 bcachefs: bch2_fs_open() bch_fs_open err opening /dev/sdd:
  insufficient devices
  00016 mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sdd,
  missing codepage or helper program, or other error.
  00016 
  00016 ========= FAILED replace_replica in 2s

I added a bcachefs fs usage to the ktest just before the first umount to
provide a bit of additional debugging info: looks like sb and journal are
still zero on the newly added device even following the data rereplicate
operation.

Is there something extra I should be adding to the test to ensure the
superblock also gets mirrored (e.g. a pause if it's kicked off
asynchronously), or is there still something not quite right here? (Does the
test now pass for you? I'm guessing this should be reasonably deterministic
and host independent?)

Best wishes,

Chris.
