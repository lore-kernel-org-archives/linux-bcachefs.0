Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C6DEE7FF4
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Sep 2023 04:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbjIJEb3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 10 Sep 2023 00:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238403AbjIJEb3 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 10 Sep 2023 00:31:29 -0400
Received: from out-218.mta1.migadu.com (out-218.mta1.migadu.com [IPv6:2001:41d0:203:375::da])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761F6C7
        for <linux-bcachefs@vger.kernel.org>; Sat,  9 Sep 2023 21:31:24 -0700 (PDT)
Date:   Sun, 10 Sep 2023 00:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694320282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4tNz0B7X1/PEX9tMB65gdEDeC5vTYbpdG6j1hg+l2p8=;
        b=TmYYNAVinh2tMEhzdx+cka8W11d3lL7JuuuNsr+K0eJS6QtQxFgqo2G+bSBWjQzbDY+wb9
        bHpkQOWdKR8a5xUytTRaefPvZ6zsBU5bwrA/7DAQTu7bUuBOkXghV7ii5hx2Op61NWYrrP
        RkO9fG0fAHqqHIDOrtJjNdPh2IbiaiM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: bcachefs tree for next
Message-ID: <20230910043118.6xf6jgeffj5es572@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Stephen,

Please include a new tree in linux-next:

http://evilpiepirate.org/git/bcachefs.git for-next

I don't see any merge conflicts with the linux-next master branch

Cheers,
Kent
