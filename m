Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE05C77B78
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 14:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbjDZOlU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241032AbjDZOlT (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 10:41:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D0872A4
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 07:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682520031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7g8K21+5fOLxiOQMgxS0GepzAD9iidk0Ol4Aos1Ywjs=;
        b=Tw7ZNYOhKM0Cz07k9OgAMmVZkzJEnJM/8OGHE1sClKamBpoHedxubcmSPiDd0OuRon2TGI
        JVQJ0mytYBdYftx6D3/nLh/b3fp9zBEDvup5toFl4kiuoI7e3054KWaI0Iu3l0Kk+9mHwG
        2uqS/RAvgy30LaFlKRb4eSFaTJEotxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-SVbejwxLO4Wl5r8i5F3O4w-1; Wed, 26 Apr 2023 10:40:28 -0400
X-MC-Unique: SVbejwxLO4Wl5r8i5F3O4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FAA938221C4;
        Wed, 26 Apr 2023 14:40:28 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B68940C2064;
        Wed, 26 Apr 2023 14:40:28 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 33QEeSHZ009237;
        Wed, 26 Apr 2023 10:40:28 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 33QEeRjp009233;
        Wed, 26 Apr 2023 10:40:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 26 Apr 2023 10:40:27 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] A small compile fix
In-Reply-To: <ZEk2IBWDkmu5gkQ7@moria.home.lan>
Message-ID: <alpine.LRH.2.21.2304261039570.7866@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2304260820020.428@file01.intranet.prod.int.rdu2.redhat.com> <ZEk2IBWDkmu5gkQ7@moria.home.lan>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On Wed, 26 Apr 2023, Kent Overstreet wrote:

> On Wed, Apr 26, 2023 at 08:31:10AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending a small compile fix for bcachefs-tools.
> 
> Signed-off-by?

Yes, you can add

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas

