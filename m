Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6838EB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 19:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjGIT3F (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 15:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjGIT3E (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 15:29:04 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8AFE6
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 12:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1688930941; bh=DcjEB2E9ifR5WdUPXWDPG/RUo/3Sy9Mz/zYS+5q7bHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8cKwy57bL+8CC29elhWJfN6RV7O29s1mdi3jI/BSAh+eT4TzyRe4nxQYctgAYen4
         Gro2ppJYWsBFHDcA2DGji4RgV2bLi2/sRmyrzYROST8jfY2bbVdxB+Rd3oxef8gqtL
         ZfI8dr2+ubORWlEaCUC9NCVcX7bE1L4oHEhBqGQk=
Date:   Sun, 9 Jul 2023 21:29:00 +0200
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, bfoster@redhat.com,
        sandeen@redhat.com
Subject: Re: [PATCH 10/10] bcachefs: bcachefs_metadata_version_major_minor
Message-ID: <6bfa02f4-380c-48e9-911f-dfbb533736ca@t-8ch.de>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
 <20230709171551.2349961-11-kent.overstreet@linux.dev>
 <4f717f9c-babe-467d-9b56-7e36fa5e2342@t-8ch.de>
 <20230709183122.y5qw53k43kuzxmic@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230709183122.y5qw53k43kuzxmic@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 2023-07-09 14:31:22-0400, Kent Overstreet wrote:
> On Sun, Jul 09, 2023 at 07:49:00PM +0200, Thomas Weißschuh wrote:
> > Hi Kent,
> > 
> > the subject for this patch looks a bit like a placeholder, in contrast
> > with the other patches of the series.
> > 
> > More below.
> > 
> > On 2023-07-09 13:15:51-0400, Kent Overstreet wrote:
> > > This introduces major/minor versioning to the superblock version number.
> > > Major version number changes indicate incompatible releases; we can move
> > > forward to a new major version number, but not backwards. Minor version
> > > numbers indicate compatible changes - these add features, but can still
> > > be mounted and used by old versions.
> > > 
> > > With the recent patches that make it possible to roll out new btrees and
> > > key types without breaking compatibility, we should be able to roll out
> > > most new features without incompatible changes.
> > > 
> > > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > > ---
> > >  fs/bcachefs/bcachefs.h        |  1 -
> > >  fs/bcachefs/bcachefs_format.h | 46 +++++++++++++-----------
> > >  fs/bcachefs/btree_io.c        |  7 ++--
> > >  fs/bcachefs/journal_io.c      | 12 ++++---
> > >  fs/bcachefs/recovery.c        | 66 +++++++++++++++++++++++++++--------
> > >  fs/bcachefs/super-io.c        | 58 ++++++++++++++++++++----------
> > >  fs/bcachefs/super-io.h        |  3 +-
> > >  7 files changed, 132 insertions(+), 61 deletions(-)
> > 
> > > [..]
> > 
> > > diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> > > index 8a0f90a83d..8c1955b6a4 100644
> > > --- a/fs/bcachefs/bcachefs_format.h
> > > +++ b/fs/bcachefs/bcachefs_format.h
> > > @@ -1574,28 +1574,32 @@ struct bch_sb_field_journal_seq_blacklist {
> > >   * One common version number for all on disk data structures - superblock, btree
> > >   * nodes, journal entries
> > >   */
> > > +#define BCH_VERSION_MAJOR(_v)		((__u8) ((_v) >> 10))
> > 
> > This "wastes" two bits of the major version that do not fit into the
> > u8 value. This is problematic in two cases:
> > 
> > * If in the future there is a major version so high that it will
> >   overflow the 8 bits it would be interpreted as major version "0" and
> >   inadvertedly accepted by older/ancient implementations.
> > 
> > * If this logic is used in other derived projects (libblkid/util-linux)
> >   it is likely that those will miss if the in-kernel logic is expanded
> >   to the full ten bits.
> > 
> > If eight bits are supposed to be enough for the major version, why not
> > split it into 8 bits major, 8 bits minor?
> > Or make the major version an u16.
> 
> Minor releases are going to be much more common than major releases:
> thus, I'm using 10 bits for the minor number and 6 bits for the major.

Sounds good. But can this be reflected in the definition of
BCH_VERSION_MINOR?
Currently it only supports 8 bits.

Something like:

#define BCH_VERSION_MINOR(_v)		((__u16) ((_v) & 0x03ff))

> It would've been better if the version number was a u32, and then the
> major and minor could've both been u16s, but alas I was not that
> foresightful :)
> 
> > > +#define BCH_VERSION_MINOR(_v)		((__u8) ((_v) >> 0))
> > > +#define BCH_VERSION(_major, _minor)	(((_major) << 10)|(_minor) << 0)
> > 
> > This changes the user-visible data format.
> > For example for libblkid/util-linux parses and exposes it to users.
> > 
> > I don't think it's a big problem and I will adapt blkid for this format.
> > 
> > But I think it would be good opportunity to have some sort of official
> > statement about the stability of the current (pre-mainline) superblock.
> > 
> > Do you expect or plan any incompatibilities?
> 
> I think it's pretty unlikely that there'll ever be a majorly
> incompatible superblock change. I recently switched to a new magic UUID,
> different from the one bcache uses - that and this change are the
> biggest incompatibilities there have been since I implemented the
> "tagged variable-length sections" scheme years ago.
> 
> If we can't fit something in the main part of the superblock, we'll just
> create new tagged sections, and those are much easier from a
> compatibility point of view.

Thanks for the clarification! Sounds good to me.

PS: Is the source for "bcachefs: Principles of Operations" available?
    While reading it I noticed some typos.
