Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79753E732F4
	for <linux-bcachefs@archiver.kernel.org>; Thu, 28 Sep 2023 16:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjI1Q6K (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjI1Q6J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 28 Sep 2023 12:58:09 -0400
Received: from out-195.mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D998BF
        for <linux-bcachefs@vger.kernel.org>; Thu, 28 Sep 2023 09:58:07 -0700 (PDT)
Date:   Thu, 28 Sep 2023 12:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695920285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOYDJFU4gLVG9Pob0kfDaTZf+wp5a9Gc4LeKmZ0nN1s=;
        b=MmI0I5T54H1jpRyZ9O57L5jP7pupnzKntskvfix6O0IkusIJMNDKx4lNFmcT7aHYiJhuzU
        2OVFhJ20zjabZSjw+lBrvZDBY+AjbBd5tUvV0SxzXL6UYXaOTi7VhqcwDykfVNgEz1dqYR
        451sqHkfOMFpzrbWs1id83d298KnFOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>, janpieter.sollie@edpnet.be
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order
 problem
Message-ID: <20230928165759.fzqogoqdolqocd2e@moria.home.lan>
References: <20230927112338.262207-1-bfoster@redhat.com>
 <20230927112338.262207-2-bfoster@redhat.com>
 <20230927220821.7yomjka3xhrcr5xa@moria.home.lan>
 <ZRWJwu0nOZcHi0NC@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRWJwu0nOZcHi0NC@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 28, 2023 at 10:12:18AM -0400, Brian Foster wrote:
> On Wed, Sep 27, 2023 at 06:08:21PM -0400, Kent Overstreet wrote:
> > On Wed, Sep 27, 2023 at 07:23:37AM -0400, Brian Foster wrote:
> > > An fsstress task on a big endian system (s390x) quickly produces a
> > > bunch of CRC errors in the system logs. Most of these are related to
> > > the narrow CRCs path, but the fundamental problem can be reduced to
> > > a single write and re-read (after dropping caches) of a previously
> > > merged extent.
> > > 
> > > The key merge path that handles extent merges eventually calls into
> > > bch2_checksum_merge() to combine the CRCs of the associated extents.
> > > This code attempts to avoid a byte order swap by feeding the le64
> > > values into the crc32c code, but the latter casts the resulting u64
> > > value down to a u32, which truncates the high bytes where the actual
> > > crc value ends up. This results in a CRC value that does not change
> > > (since it is merged with a CRC of 0), and checksum failures ensue.
> > > 
> > > Fix the checksum merge code to swap to cpu byte order on the
> > > boundaries to the external crc code such that any value casting is
> > > handled properly.
> > 
> > Thanks! Applied.
> > 
> > We really need to test creating a filesystem and then reading from it on
> > an opposite endianness machine, have you gotten a chance to do that?
> > 
> 
> I gave it a quick test by just dd'ing the disk image off my fstests
> TEST_DEV from the BE box I've been playing with and mounting it on a LE
> system. The fs mounts, but eventually complains about a backpointer
> issue after some stress I/O:
> 
>  bcachefs (loop0): error validating btree node at btree backpointers level 0/1
>    u64s 11 type btree_ptr_v2 0:5342578688:0 len 0 ver 0: seq 8574dcb72b17e918 written 486 min_key 0:3338403840:1 durability: 1 ptr: 0:10388:0 gen 6
>    node offset 486 bset u64s 1300: invalid bkey: backpointer at wrong pos
>    u64s 9 type backpointer 0:3339255808:0 len 0 ver 0: bucket=0:6369:0 btree=extents l=0 offset=0:256 len=64 pos=536913736:256:U32_MAX, shutting down
>  bcachefs (loop0): inconsistency detected - emergency read only
>  bcachefs (loop0): __bch2_btree_write_buffer_flush: insert error EIO
>  bcachefs (loop0 inum 201326618 offset 246272): write error while doing btree update: EIO
> 
> ... and fsck similarly complains about a bunch more bp and lru related
> inconsistencies. Write buffer issue, perhaps? At a glance, that seq
> value looks kind of bogus, but I haven't had a chance to dig into the
> details yet. Everything seems in order with the same image file on the
> BE box, FWIW.

bch_backpointer looks highly suspect re: endianness, if it's not fixable
we'll have to do a bch_backpointer_v2. I expect it will be fixable
though, just tricky.

The LRU btree is just a bitset btree now, so that shouldn't have
endianness issues.

So yeah, we definitely need to get automated foreign endianness testing
going - if there's going to be more of this I don't want us to be doing
this by hand, and we need to make sure issues like this get caught in
the future.

jpsollie was looking at ktest support for big endian architectures
recently and had some patches for that, I just haven't had time to look
at them - jpsollie, do you think you can post those patches to the list?
