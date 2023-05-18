Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 548DAC77B7D
	for <linux-bcachefs@archiver.kernel.org>; Thu, 18 May 2023 06:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjERGZl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 18 May 2023 02:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjERGZX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 18 May 2023 02:25:23 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68DB170B
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 May 2023 23:25:20 -0700 (PDT)
X-ASG-Debug-ID: 1684391116-15c43446152457190001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b01.edpnet.be with ESMTP id JnW4d9XntxqAqXBm; Thu, 18 May 2023 08:25:16 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <995dd846-5b16-54f2-a211-6050881d6945@kabelmail.de>
Date:   Thu, 18 May 2023 08:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] Improve CFLAGS for faster release, and more agressive
 debugging
To:     Kent Overstreet <kent.overstreet@linux.dev>
X-ASG-Orig-Subj: Re: [PATCH] Improve CFLAGS for faster release, and more agressive
 debugging
Cc:     linux-bcachefs@vger.kernel.org
References: <20230517061529.902-1-janpieter.sollie@kabelmail.de>
 <ZGWjh7BIcMgJZ6bj@moria.home.lan>
Content-Language: en-US, nl-BE
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
In-Reply-To: <ZGWjh7BIcMgJZ6bj@moria.home.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1684391116
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1419
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.108926
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Op 18/05/2023 om 06:03 schreef Kent Overstreet:
> On Wed, May 17, 2023 at 08:15:30AM +0200, Janpieter Sollie wrote:
>> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
>>
>> We've got several complaints about bcachefs being memory hungry and slow these days.
>> It's not a good idea to start optimizing when debugging,
>> but as we've a "make debug" target, I propose:
>> - we turn on O2 for regular targets
>> - we build a debug build with address sanitizer
>> - we turn off 02 for debug builds, instead switching to -0g
>> According to GCC manual, the last O flag is the one that counts,
>> so having O2 and Og won't be a problem
>> we still keep basic -g on release builds for a while,
>> but set -ggdb on debug builds for more accurate debug options
> This doesn't match the commit subject, you're only changing debug
> options - and the -static options aren't explained.
>
> Additionally, these are options I turn on on a case-by-case basis, not
> for every debug build.

OK, gotcha,

Do you believe there is a target in optimizing userspace tools to perform algorithm testing etc 
instead of doing it in kernel space?
Compiling and running a kasan kernel is a lot more CPU-intensive than using options I put in the 
patch to perform address sanitization.
Is this a path that has some use? or is fs development / testing in userspace not a good idea 
whatsoever?

Janpieter Sollie
