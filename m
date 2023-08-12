Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492F4C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 23:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjHLXzp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 19:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjHLXzp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 19:55:45 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A8120
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 16:55:47 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4RNcxC3rDXz9sTK
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 01:55:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=elbmurf.de; s=MBO0001;
        t=1691884543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D9rPcVlUTxqR6ktFIahtZFlmFnmkqmIKz3hT/ClINN4=;
        b=IUMiIlUpiOq/Cfagbpqx5fw447n+8HLmlKxDhzai6kaO1TrbAE49rqNS8b2QEtjQ1e0h/d
        N/DkQi27i/xQVxrFOVoSNiLDhXIXYVMbOQ+EUrf9sL+sQh/KuZQ5gvGuZWtV/Dd3FP4xAk
        M9CaBodhPCpQHzboa41nFmx96AaF3wFho3BBu+zsFR11Ugamw2S+Xt4ZJuNHF/iH8ib8c7
        jDc4YWmSf01fvSeKio+VkJ0lwa3d41tE4Ss6Rvz4BtGC2KNetGLQBhtv1ZB11O8qdzzYtP
        BPvvlbga5IhX3bm5Wy61qMQCxb/KH+zDPW50RaNPcmHAO8nwa1C2LdGz3IZn/w==
Message-ID: <76853777-2f5f-4d8a-aa67-d84112c51c26@elbmurf.de>
Date:   Sun, 13 Aug 2023 01:55:42 +0200
MIME-Version: 1.0
Content-Language: de-DE, en-US-large
From:   =?UTF-8?Q?Maximilian_B=C3=B6hm?= <kernel@elbmurf.de>
Subject: Please consider a more end-user appealing filesystem name
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent et al., but especially Kent,

I’m very impressed by Bcachefs and very much looking forward to this FS hopefully delivering us from eternally flawed btrfs.
But I do have a consideration and please forgive me this blunt overreach: It would really gain from a better name.

Please don’t take this personally. I know, Bcache was your invention and its derivative is a fine academic name for an academic project. But for users? As much as I’m looking forward to using this FS for the next decades, having to read and write this name frequently doesn’t get me excited. It’s a fine academic name but
a) has too many syllables
b) is hard to remember and hard to type (I still always want to write Becachefs like in BeFS)
c) is downright confusing when you just read "cache" and think this is some sort of swap?
d) is loosing against ZFS in the battle for coolness

Think of project names like SPDY, QUIC, even XFS. Heck, why not a non-acronymic name, something like "Bontree", a wordplay with B+ trees? At the same time an allusion to one of btrfs’ pronunciations and the French word for "good". Something conveying a feeling, something to identify with. It doesn’t have to be this technical letter salad - it doesn’t even need the "fs" part, the "ext" series was perfectly good without. In fact, damn the fs part in a rebranding.

I’m not here to suggest a better name but maybe you could ask the community? I beg you to consider a shorter, cooler name for this FS before it’s reaching end users on mainline. It really does deserve it!

With best regards
Maximilian Böhm

