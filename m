Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2308E732D8
	for <linux-bcachefs@archiver.kernel.org>; Thu, 28 Sep 2023 14:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjI1OMx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbjI1OMx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 28 Sep 2023 10:12:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0DF9
        for <linux-bcachefs@vger.kernel.org>; Thu, 28 Sep 2023 07:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695910325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xvx++/uj09XtYRrOYpM3xuKbexfKQDsV4TrKayuha60=;
        b=PN7yHCAAb11RRKkZciycmIbN2ZQXv/LLnlz5YQNXFUAYN5iXvdN719s0AdSFzFUXlyWpf+
        efiW6AU4nhl9kas9FJD40YslGM5eU/hyh3sl1ToP1olyqLA2T6zbx1auKY2x9zgeid1eCS
        tZf3Sv829HoGg0jXt9zr2vYzw00rAKc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-BURwB7YwOMi2ISv7Jzm0IQ-1; Thu, 28 Sep 2023 10:12:03 -0400
X-MC-Unique: BURwB7YwOMi2ISv7Jzm0IQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6557c921deeso210794926d6.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 28 Sep 2023 07:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695910322; x=1696515122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvx++/uj09XtYRrOYpM3xuKbexfKQDsV4TrKayuha60=;
        b=s9IT5EGYcpU5M/iQZxwSU0d+U2+Ni81vI3WE+Ol8UOkM2jw09MrlJ2ogPbBp+yuBZ2
         EewjFhV7UU1fJpnBNdG811WykQRSQe+CH7oCMLQEIH1zRhqie6DFdyz0EY/b4AJs9dxV
         bwN4+zKHjs/tcoLFADjoQaJcTmVr5JwTht/aMOIenv1zsjeGZapvc+FgBnYABoT3nk00
         gaz+jZuuxHNyTuRqIm2wAfBnwlnlpNW26Wua0tpsiVUCpyNNoaodJ0/7mt3AhwoHzRd1
         wHpSv/gDOCtC6Jm2DPA1H4YSmP6Ei/yzGu5quFvMRb79zVfA/Q9Dfy1wELKi6TQWKCQ6
         G3JA==
X-Gm-Message-State: AOJu0YwRL/fBCTGHyM4v3kmiI78YreomjsqmLfmA+Xe9csPGK1V7nmRS
        c2POG8pHGTcdLtykhEOXp7N872VDSkwG84AaKNMcn0/+Wmikt2+if2+ZwfobyWth3kJD9hbx2oS
        dkZ+xzVClkPhCcNLV68hUE2NLtMXG3iHdTdo=
X-Received: by 2002:a05:6214:419e:b0:65b:ed3:9a02 with SMTP id ld30-20020a056214419e00b0065b0ed39a02mr1305056qvb.17.1695910322576;
        Thu, 28 Sep 2023 07:12:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgrrYmAHEQV1HqCVuYLjsD2yL8BiVHMFj7rbvpixx6NsRvh4fojy2zJ1slMEqtzOM3Fm+mEA==
X-Received: by 2002:a05:6214:419e:b0:65b:ed3:9a02 with SMTP id ld30-20020a056214419e00b0065b0ed39a02mr1305043qvb.17.1695910322322;
        Thu, 28 Sep 2023 07:12:02 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id y11-20020a0ce04b000000b0064743dd0633sm6511089qvk.106.2023.09.28.07.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 07:12:01 -0700 (PDT)
Date:   Thu, 28 Sep 2023 10:12:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order
 problem
Message-ID: <ZRWJwu0nOZcHi0NC@bfoster>
References: <20230927112338.262207-1-bfoster@redhat.com>
 <20230927112338.262207-2-bfoster@redhat.com>
 <20230927220821.7yomjka3xhrcr5xa@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927220821.7yomjka3xhrcr5xa@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 27, 2023 at 06:08:21PM -0400, Kent Overstreet wrote:
> On Wed, Sep 27, 2023 at 07:23:37AM -0400, Brian Foster wrote:
> > An fsstress task on a big endian system (s390x) quickly produces a
> > bunch of CRC errors in the system logs. Most of these are related to
> > the narrow CRCs path, but the fundamental problem can be reduced to
> > a single write and re-read (after dropping caches) of a previously
> > merged extent.
> > 
> > The key merge path that handles extent merges eventually calls into
> > bch2_checksum_merge() to combine the CRCs of the associated extents.
> > This code attempts to avoid a byte order swap by feeding the le64
> > values into the crc32c code, but the latter casts the resulting u64
> > value down to a u32, which truncates the high bytes where the actual
> > crc value ends up. This results in a CRC value that does not change
> > (since it is merged with a CRC of 0), and checksum failures ensue.
> > 
> > Fix the checksum merge code to swap to cpu byte order on the
> > boundaries to the external crc code such that any value casting is
> > handled properly.
> 
> Thanks! Applied.
> 
> We really need to test creating a filesystem and then reading from it on
> an opposite endianness machine, have you gotten a chance to do that?
> 

I gave it a quick test by just dd'ing the disk image off my fstests
TEST_DEV from the BE box I've been playing with and mounting it on a LE
system. The fs mounts, but eventually complains about a backpointer
issue after some stress I/O:

 bcachefs (loop0): error validating btree node at btree backpointers level 0/1
   u64s 11 type btree_ptr_v2 0:5342578688:0 len 0 ver 0: seq 8574dcb72b17e918 written 486 min_key 0:3338403840:1 durability: 1 ptr: 0:10388:0 gen 6
   node offset 486 bset u64s 1300: invalid bkey: backpointer at wrong pos
   u64s 9 type backpointer 0:3339255808:0 len 0 ver 0: bucket=0:6369:0 btree=extents l=0 offset=0:256 len=64 pos=536913736:256:U32_MAX, shutting down
 bcachefs (loop0): inconsistency detected - emergency read only
 bcachefs (loop0): __bch2_btree_write_buffer_flush: insert error EIO
 bcachefs (loop0 inum 201326618 offset 246272): write error while doing btree update: EIO

... and fsck similarly complains about a bunch more bp and lru related
inconsistencies. Write buffer issue, perhaps? At a glance, that seq
value looks kind of bogus, but I haven't had a chance to dig into the
details yet. Everything seems in order with the same image file on the
BE box, FWIW.

Brian

> Otherwise, there's the big endian support in ktest to start looking at
> again.
> 

