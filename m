Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4DFC433EF
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 19:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2159160F43
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 19:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhJKTM7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Oct 2021 15:12:59 -0400
Received: from cdw.me.uk ([91.203.57.136]:50279 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhJKTM7 (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Oct 2021 15:12:59 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1ma0hH-0007Le-U4; Mon, 11 Oct 2021 20:10:51 +0100
Date:   Mon, 11 Oct 2021 20:10:51 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Other (perhaps related) subvolume strangeness
Message-ID: <20211011191051.GA20049@arachsys.com>
References: <20211010134413.GA31142@arachsys.com>
 <20211010185549.GA24560@arachsys.com>
 <YWRbw6FOnHc54yrY@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWRbw6FOnHc54yrY@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@gmail.com> writes:

> Have you looked at ktest[1]? We've got some subvolume & snapshot tests in
> there, if you could add a few test cases for the things you're finding
> that'd be really helpful (and it's a really slick virtual machine testing
> environment, too)

Hi Kent. Ah I hadn't tried that, thanks! Looks like an excellent way to make
a more useful report with a test to reliably reproduce it. I've set it up
in a Debian chroot to make the dependencies easier to satisfy, and it's
working nicely.

> On Sun, Oct 10, 2021 at 07:55:50PM +0100, Chris Webb wrote:
>
> > After deleting a snapshot, creating a new one also uncovers a bug:
> 
> Wrote a test that reproduces it, I'll look further - thanks

This might be the same issue as test_subvol_snapshot_reuse_snapshot_name
from ktest/tests/bcachefs/subvol.ktest?

> > If instead I try to create a new snapshot with a different name:
> >   kernel BUG at fs/bcachefs/btree_key_cache.c:548!
> 
> This one I don't seem to be able to reproduce.

I failed to reproduce in ktest until I deleted and recreated a few extra
snapshots in a loop. I'll follow up putting this in a proper patch against
ktest with a changelog and so on, but

  test_subvol_snapshot_delete_repeat()
  {
      run_quiet "" bcachefs format -f --errors=panic /dev/sdb
      mount -t bcachefs /dev/sdb /mnt
      for i in $(seq 1 64); do
          bcachefs subvolume snapshot /mnt/$i
          bcachefs subvolume delete /mnt/$i
      done
      umount /mnt
  }

reliably reproduces for me using the head of your tree at the time of
writing, 33a19429e827:

  00015 ========= TEST   subvol_snapshot_delete_repeat
  00015 
  00015 bcachefs (sdb): recovering from clean shutdown, journal seq 4
  00015 bcachefs (sdb): going read-write
  00015 bcachefs (sdb): mounted with opts: errors=panic
  00017 ------------[ cut here ]------------
  00017 kernel BUG at fs/bcachefs/btree_key_cache.c:548!
  00017 KGDB: Waiting for remote debugger

It fails on attempt 12 for me.

> > bcachefs subvolume delete only works on snapshot subvolumes:
> 
> For the moment at least this is intended behaviour, since a regular
> subvolume can be removed with rm -rf. I've been meaning to check how btrfs
> does it, and match their behaviour wherever reasonable - do you know
> offhand what they do?

I don't know I'm afraid: it's been a few years since I tested out btrfs, and
I was mostly marvelling at the strange new magic of reflinks rather than
subvolumes and snapshots back then. :)

ENOENT (with strerror "No such file or directory") is quite a surprising
result for a user that isn't expecting it, especially as subvolume delete
'sounds' like the opposite of subvolume create.

I guess there's an argument that both snapshots and normal subvolumes can
be deleted by rm -r, and therefore subvolume delete is redundant anyway?

Best wishes,

Chris.
