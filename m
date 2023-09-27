Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFE0E7109E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 22:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjI0WI3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 18:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI0WI3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 18:08:29 -0400
Received: from out-205.mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F9BFB
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 15:08:27 -0700 (PDT)
Date:   Wed, 27 Sep 2023 18:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695852505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ztKzG37IIts293ndsQ6oL6ZjvVewcmGbeHmO/axQnwE=;
        b=nuRYh3dHUpwOKAuBomlOKgV7KQtEnj79/drok1v62nR9fIctM2L0E71q/wSWu3kAPiCX6I
        h1WvqDX75D8gjNlMy+/dCNddhmeAmEnPvYJ9/XZZpEWq0iIpPNU2HIV5lPfr+KU23q60sq
        W7/O/wrSIzLgG11mGJEFM+lFRTHkeNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: fix crc32c checksum merge byte order
 problem
Message-ID: <20230927220821.7yomjka3xhrcr5xa@moria.home.lan>
References: <20230927112338.262207-1-bfoster@redhat.com>
 <20230927112338.262207-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927112338.262207-2-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 27, 2023 at 07:23:37AM -0400, Brian Foster wrote:
> An fsstress task on a big endian system (s390x) quickly produces a
> bunch of CRC errors in the system logs. Most of these are related to
> the narrow CRCs path, but the fundamental problem can be reduced to
> a single write and re-read (after dropping caches) of a previously
> merged extent.
> 
> The key merge path that handles extent merges eventually calls into
> bch2_checksum_merge() to combine the CRCs of the associated extents.
> This code attempts to avoid a byte order swap by feeding the le64
> values into the crc32c code, but the latter casts the resulting u64
> value down to a u32, which truncates the high bytes where the actual
> crc value ends up. This results in a CRC value that does not change
> (since it is merged with a CRC of 0), and checksum failures ensue.
> 
> Fix the checksum merge code to swap to cpu byte order on the
> boundaries to the external crc code such that any value casting is
> handled properly.

Thanks! Applied.

We really need to test creating a filesystem and then reading from it on
an opposite endianness machine, have you gotten a chance to do that?

Otherwise, there's the big endian support in ktest to start looking at
again.
