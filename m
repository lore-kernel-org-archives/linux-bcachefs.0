Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93EFEB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGIRtG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGIRtF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:49:05 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E763BF
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1688924942; bh=fjzx+5t2tk1NFHOEJz65EKxtMUjk3y3PRNuGHrNNArE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVNQTxZjY+8W2I13JRvTsXGwcnKxRKIIQAFDkXGI/6+EB7Z+imGjDFL/Bavg6HIsU
         eJgNoCXrRRCPSIPx46J+t1RDkOKZAMj3/7WKqnldgmvXV7oKv99+cdUA8YMoGuci37
         F+7MGELDulddGkWaMXpJ1hoj+DAOPNl3vysTxmBI=
Date:   Sun, 9 Jul 2023 19:49:00 +0200
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, bfoster@redhat.com,
        sandeen@redhat.com
Subject: Re: [PATCH 10/10] bcachefs: bcachefs_metadata_version_major_minor
Message-ID: <4f717f9c-babe-467d-9b56-7e36fa5e2342@t-8ch.de>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
 <20230709171551.2349961-11-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709171551.2349961-11-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

the subject for this patch looks a bit like a placeholder, in contrast
with the other patches of the series.

More below.

On 2023-07-09 13:15:51-0400, Kent Overstreet wrote:
> This introduces major/minor versioning to the superblock version number.
> Major version number changes indicate incompatible releases; we can move
> forward to a new major version number, but not backwards. Minor version
> numbers indicate compatible changes - these add features, but can still
> be mounted and used by old versions.
> 
> With the recent patches that make it possible to roll out new btrees and
> key types without breaking compatibility, we should be able to roll out
> most new features without incompatible changes.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/bcachefs.h        |  1 -
>  fs/bcachefs/bcachefs_format.h | 46 +++++++++++++-----------
>  fs/bcachefs/btree_io.c        |  7 ++--
>  fs/bcachefs/journal_io.c      | 12 ++++---
>  fs/bcachefs/recovery.c        | 66 +++++++++++++++++++++++++++--------
>  fs/bcachefs/super-io.c        | 58 ++++++++++++++++++++----------
>  fs/bcachefs/super-io.h        |  3 +-
>  7 files changed, 132 insertions(+), 61 deletions(-)

> [..]

> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index 8a0f90a83d..8c1955b6a4 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -1574,28 +1574,32 @@ struct bch_sb_field_journal_seq_blacklist {
>   * One common version number for all on disk data structures - superblock, btree
>   * nodes, journal entries
>   */
> +#define BCH_VERSION_MAJOR(_v)		((__u8) ((_v) >> 10))

This "wastes" two bits of the major version that do not fit into the
u8 value. This is problematic in two cases:

* If in the future there is a major version so high that it will
  overflow the 8 bits it would be interpreted as major version "0" and
  inadvertedly accepted by older/ancient implementations.

* If this logic is used in other derived projects (libblkid/util-linux)
  it is likely that those will miss if the in-kernel logic is expanded
  to the full ten bits.

If eight bits are supposed to be enough for the major version, why not
split it into 8 bits major, 8 bits minor?
Or make the major version an u16.

> +#define BCH_VERSION_MINOR(_v)		((__u8) ((_v) >> 0))
> +#define BCH_VERSION(_major, _minor)	(((_major) << 10)|(_minor) << 0)

This changes the user-visible data format.
For example for libblkid/util-linux parses and exposes it to users.

I don't think it's a big problem and I will adapt blkid for this format.

But I think it would be good opportunity to have some sort of official
statement about the stability of the current (pre-mainline) superblock.

Do you expect or plan any incompatibilities?

> [..]

Thomas
