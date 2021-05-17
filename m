Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A68C433ED
	for <linux-bcachefs@archiver.kernel.org>; Mon, 17 May 2021 15:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F90760FF3
	for <linux-bcachefs@archiver.kernel.org>; Mon, 17 May 2021 15:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhEQPXi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 17 May 2021 11:23:38 -0400
Received: from e246-3.smtp-out.eu-west-3.amazonses.com ([23.251.246.3]:47853
        "EHLO e246-3.smtp-out.eu-west-3.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244296AbhEQPUA (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 17 May 2021 11:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=axzmos4la3w74ngtxsngrtzf6xjixqeg; d=brouillet.org; t=1621264723;
        h=Subject:From:To:References:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=E830yuVxXsH53SRHXjq2N/sH+CZttV6vKUuNOgP3Agc=;
        b=fZ6Og9Y8r+tLEZFYB9KUFCGZgX6hb9hE2i4GvcsGxjc6JAG7j9rInxQyQnFb6BfF
        OmwSZSOHqvoFbAEwxizOHuXwvjaEkNo/ZrCu2XldqtDAqIE0GCYu2quVIWtffi6SGSP
        yl4TkwnNszPAN5szz0uxTtDTE9fS9xxxM1Zcntqc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=2xmcwjqtfc53o6h4t73lgyi3w3u43rzi; d=amazonses.com; t=1621264723;
        h=Subject:From:To:References:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=E830yuVxXsH53SRHXjq2N/sH+CZttV6vKUuNOgP3Agc=;
        b=f3duue/DXYGVKhWdOA2MTYf96JiWsOdnEXs7ivHsAmI3iGmwavOIWbtYfcMUl903
        LFHGpnhMZFclo7OcY9JIcvOStUMCh96yud6be0+Be/PXP1Rh+xSidzNE6wjDi6ZArUM
        JnfA8N2D9Mdv+n7Tv26mMJ/N+hpJaRKwQtfG/hwo=
Subject: Re: Bcachefs interest. Good or not for my use case ? documentation ?
From:   Marcel Brouillet <marcel@brouillet.org>
To:     linux-bcachefs@vger.kernel.org
References: <92af6695-2a6a-a1cc-6f31-2a481d9c516e@brouillet.org>
Message-ID: <011301797ae86c1d-5f2d0260-174b-4966-8aca-871cc0856a8d-000000@eu-west-3.amazonses.com>
Date:   Mon, 17 May 2021 15:18:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <92af6695-2a6a-a1cc-6f31-2a481d9c516e@brouillet.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Feedback-ID: 1.eu-west-3.q74FiVNfnmtxEeagwsOORWMbwqlfbKRSWCmVFkPqYFw=:AmazonSES
X-SES-Outgoing: 2021.05.17-23.251.246.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

I realize that my mailbox was overquota at the times I sent this email. 
I feel terribly sorry if someone spent time answering and I didn't 
receive the answer. I looked for a kernel.org mailinglist archive and 
didn't find any. If there was an answer, would anyone be so kind to 
forward it again to me ?

Thank you. And thank you for coding. I'm sure it makes a difference, if 
not for me, for the community.

Marcel.

On 26/04/2021 10:55, Marcel Brouillet wrote:
> Hello,
>
> I'm trying this email list, and I hope this isn't considered rude 
> posting here.
>
> ==> I am interested in Bcachefs for personal use. I have found (and 
> sponsor) the Patreon page. I am having a hard time understanding if 
> this is for me, or if I should stick with FS types that are shipped 
> with Ubuntu. It's hard to understand what all it's features are and if 
> they are adequate for my usage.
>
> The documentation that I found so far is https://bcachefs.org/ and 
> https://www.patreon.com/bcachefs but it's not easy for me to grasp the 
> benefits over the hassle of experimental.
>
> ==>_My usage is : for personal use, build a raid storage space for all 
> my media (pictures, sound) and files (administration, legal, scans), 
> on the following hardware:
>
> - two 5Tb 2.5" HDD Sata
> - one 1Tb SSD
> - some external USB3 5Tb HDD and/or cloud storage (I plan on using 
> rsync or similar, possibly storing md5sum of each file in xattr)
>
> ==> My understanding is that using Bcachefs
>
>    + I become one additional tester of the software. Do you need that?
>
>    + I can dedicate a partition of the SSD to cache R/W to the HDD
>    RAID. Will I see the difference for 5Mb pictures rarely accessed (at
>    CPU-timescale)? I'm not running a high I/O server, it's for desktop 
> use…
>
>    - It will be a pain for me to compile it in the kernel. I'm running
>    vanilla Ubuntu. I found this :
>    https://www.rwardrup.com/bcachefs-on-ubuntu-20-04/. I noticed
>    automount doesn't work.
>
>     - physical storage format is not finalized. Is there a risk I loose
>    everything, do I need to compile updates regularly? what happens
>    when physical format changes?…
>
>     - if anything goes wrong, I can't just plug the HDDs on another 
> system.
>
>     - isn't there a strain of the SSD that, at some point, will kill it?
>    If it dies, and my system is on it (on an ext4 partition) I loose
>    access to my data until I rebuild a system with Bcachefs kernel 
> support.
>
>     - would it make sense to have the external HDD be part of the RAID,
>    so to automate syncing on the backup drive ?
>
>
> I'm also fine with vanilla ext4 with software Raid-1 and rsync. What 
> would you recommend ? Irrespective of me using it or not, I like to 
> continue sponsoring the development, with my modest income.
>
>
> Best,
>
> Marcel (Paris, France)
>
