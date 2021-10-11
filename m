Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CEAC433EF
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10E960C4B
	for <linux-bcachefs@archiver.kernel.org>; Mon, 11 Oct 2021 15:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhJKPqH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhJKPqG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Oct 2021 11:46:06 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCD4C061570
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Oct 2021 08:44:06 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id v17so2395592qtp.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Oct 2021 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h5QuUCNQVUw9cpPZPL8diihURw5wQh47J0MXNXYnzrg=;
        b=YdNvI1Bqy6CgrKH7zhlOwtj4l8t6aG+1lVtzHE6aFxBhDuNWYND4GcbvK8NNThpoIW
         ZrCMyOQy7O4n9FAAzTW3hQeNsc5kShUzULM5v56UXmFP0n1JS48XaNQ2AYIKooKsIZwv
         V99BkIqKAwITOUgnXUw98wcFAv9xZnQ2SSolR63g4N8CuM5lw9+Z1kIPKDIyQ6tGXtPj
         ty9ChjPw6wVQMBXtxrX4i5amu3c9uXUf6vxqHLl0bT69oAaVvo8wsD+o+IxrvBE//dIM
         WWTkK1gl5IZJxKWJoOC7jwIfGR5UgidLGsEMMGml16yFZ4hgPrujPgGFGmMxdBrFqur4
         AUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h5QuUCNQVUw9cpPZPL8diihURw5wQh47J0MXNXYnzrg=;
        b=1hY9aoJZFgVVHOZ1oDLViljXoaWnITONSy7NOh+af2YnNev3iYOnCZA2CvZLMu91ls
         U1HHNTXmlnKjzZfgFpR8rMaPl9l51sEzhujrCfjigeN9S+jDR48Jb6tE9kHN9SHIpXbI
         rz/GYmLTXOhps3cspT0b0B/VV3fjpLIxICwRI5muvqWFdrKidK2OsEEgJ8gNqv3QrOR7
         yv6ZxJP/Zj3o6m//fv+pupmJCnxREk6QeZFbFi12gfVJCTwbSsksT5bHKFH/hdgDWQhn
         9XVRcOn8PyDWq4ESgWEPE1wY4CqiR38ayBGoUo1P1s6TxQptYv0sFs3fo+uiNlYzYe7e
         zkPA==
X-Gm-Message-State: AOAM530jyNPR0bi20zeqLl9YNpKJ7qSPh2alCuRKR0675slv0RkwPmw+
        ZpLuF7/UtzvtW/o8ZIEutaVC9GkN9w==
X-Google-Smtp-Source: ABdhPJxMYa0bFIfEvBOZAp/q84pplyYuXmokWb1B0E7oq8HFsDCP5lpwccOsJQ+qBvBN+PmthmU4XA==
X-Received: by 2002:ac8:7f8f:: with SMTP id z15mr7314402qtj.148.1633967045637;
        Mon, 11 Oct 2021 08:44:05 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id d11sm4979025qtb.39.2021.10.11.08.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 08:44:04 -0700 (PDT)
Date:   Mon, 11 Oct 2021 11:44:03 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Other (perhaps related) subvolume strangeness
Message-ID: <YWRbw6FOnHc54yrY@moria.home.lan>
References: <20211010134413.GA31142@arachsys.com>
 <20211010185549.GA24560@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010185549.GA24560@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Oct 10, 2021 at 07:55:50PM +0100, Chris Webb wrote:
> A couple of (perhaps related) issues I noticed...
> 
> bcachefs subvolume delete only works on snapshot subvolumes:
> 
>   # bcachefs subvolume create /mnt/s
>   # bcachefs subvolume snapshot /mnt/s /mnt/t
>   # bcachefs subvolume delete /mnt/s
>   BCH_IOCTL_SUBVOLUME_DESTROY ioctl error: No such file or directory
>   # bcachefs subvolume delete /mnt/t
>   #

For the moment at least this is intended behaviour, since a regular subvolume
can be removed with rm -rf. I've been meaning to check how btrfs does it, and
match their behaviour wherever reasonable - do you know offhand what they do?

> After deleting a snapshot, creating a new one also uncovers a bug:
> 
>   # bcachefs subvolume snapshot /mnt/s
>   # bcachefs subvolume delete /mnt/s
>   # ls /mnt
>   lost+found
>   # bcachefs subvolume snapshot /mnt/s
>   BCH_IOCTL_SUBVOLUME_CREATE ioctl error: File exists

Wrote a test that reproduces it, I'll look further - thanks

> 
> If instead I try to create a new snapshot with a different name:
> 
>   # bcachefs subvolume snapshot /mnt/
>   [hangs]
>   ^C
>   # dmesg -t
>   bcachefs (zram1): recovering from clean shutdown, journal seq 4
>   bcachefs (zram1): going read-write
>   bcachefs (zram1): mounted with opts: (null)
>   ------------[ cut here ]------------
>   kernel BUG at fs/bcachefs/btree_key_cache.c:548!

This one I don't seem to be able to reproduce.

Have you looked at ktest[1]? We've got some subvolume & snapshot tests in
there, if you could add a few test cases for the things you're finding that'd be
really helpful (and it's a really slick virtual machine testing environment,
too)

[1] https://github.com/koverstreet/ktest/
