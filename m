Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A80C433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 May 2022 19:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347554AbiEaTzi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 May 2022 15:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347502AbiEaTzh (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 May 2022 15:55:37 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23008FD5A
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 May 2022 12:55:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id AAA2939;
        Tue, 31 May 2022 12:55:36 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id L57yEdYsCkNt; Tue, 31 May 2022 12:55:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 48141B;
        Tue, 31 May 2022 12:55:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 48141B
Date:   Tue, 31 May 2022 12:55:32 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     Generic Plant <cmclfairbairn@gmail.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Command mistype on bcachefs.org
In-Reply-To: <20220525172223.gng6e7nfi5jn7hav@moria.home.lan>
Message-ID: <85aede4-4ca3-738e-6dab-6c5565eb73fb@ewheeler.net>
References: <CAM8=fNeR1rLw2puAtmY+3dTd0ekmUaCMj6Gjzb6MHoMvzNt3OQ@mail.gmail.com> <20220525172223.gng6e7nfi5jn7hav@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 25 May 2022, Kent Overstreet wrote:
> On Sat, May 21, 2022 at 08:19:11PM +0100, Generic Plant wrote:
> > Hi,
> > 
> > I noticed there was a mistype on https://bcachefs.org/. Specifically the
> > command:
> > 
> > bcachefs format /dev/sd[ab]1 \
> >     --foreground_target /dev/sda1 \*    --promote-target /dev/sda1 \
> > *    --background_target /dev/sdb1
> > mount -t bcachefs /dev/sda1:/dev/sdb1 /mnt
> 
> Thanks, fixed - the --target options now take sda1, not /dev/sda1

If --target options take the name without /dev, then how are paths like 
/dev/mapper/foo handled?  

Do you need to specify "dm-7" or whatever the /dev/dm-N path is?

--
Eric Wheeler



> 
> > Also, it's a weird edge case but has anyone attempted a multi device with
> > USB sticks? I've tried to but I can only create a folder then I get a file
> > system is read only error (mounting with -o rw).
> 
> What dmesg do you get?
> 
